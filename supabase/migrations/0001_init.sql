-- ============================================================
-- Shared Wishes — Supabase 数据库初始化
-- 目标：2~4 人共享组，无账户体系（设备配对），组内数据隔离
-- 执行：Supabase Dashboard → SQL Editor → 粘贴运行
-- ============================================================

-- ---------- 扩展 ----------
create extension if not exists "pgcrypto";

-- ============================================================
-- 1. 表结构
-- ============================================================

-- 组
create table if not exists public.groups (
  id            uuid primary key default gen_random_uuid(),
  invite_code   varchar(8)  not null unique,
  name          varchar(50),
  created_at    timestamptz not null default now(),
  member_count  int         not null default 1
);

comment on table public.groups is '2~4 人共享组，一个设备只属于一个组';
comment on column public.groups.invite_code is '8 位邀请码，字符集已剔除 O/0/I/1/L';

-- 设备（成员）
create table if not exists public.devices (
  id            uuid primary key default gen_random_uuid(),
  group_id      uuid not null references public.groups(id) on delete cascade,
  device_id     uuid not null unique,          -- 客户端生成并持久化的设备 ID
  nickname      varchar(20) not null,
  avatar_emoji  varchar(8)  not null,
  platform      varchar(10) not null check (platform in ('ios','android')),
  model_name    varchar(60),
  last_active_at timestamptz not null default now(),
  created_at    timestamptz not null default now()
);

create index if not exists devices_group_idx on public.devices(group_id);

-- 愿望
create table if not exists public.wishes (
  id                    uuid primary key default gen_random_uuid(),
  group_id              uuid not null references public.groups(id) on delete cascade,
  title                 varchar(100) not null,
  description           text,
  status                varchar(20) not null default 'pending'
                          check (status in ('pending','in_progress','completed')),
  category              varchar(30),
  target_date           date,
  created_by            uuid references public.devices(device_id) on delete set null,
  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now(),

  -- 完成标记
  completed_by          uuid references public.devices(device_id) on delete set null,
  completed_at          timestamptz,
  completion_notes      jsonb not null default '[]'::jsonb,

  -- 同步
  version               int not null default 1,
  deleted_at            timestamptz
);

create index if not exists wishes_group_idx on public.wishes(group_id);
create index if not exists wishes_status_idx on public.wishes(group_id, status);
create index if not exists wishes_completed_at_idx on public.wishes(group_id, completed_at desc);

comment on column public.wishes.completion_notes is
  '完成后写的纪念文字。多人冲突时保留全部内容（jsonb 数组，见 ConflictResolver.mergeNotes）';

-- 日常记录
create table if not exists public.moments (
  id            uuid primary key default gen_random_uuid(),
  group_id      uuid not null references public.groups(id) on delete cascade,
  text          text,
  image_urls    text[] not null default '{}',
  latitude      double precision,
  longitude     double precision,
  place_name    varchar(100),
  created_by    uuid references public.devices(device_id) on delete set null,
  created_at    timestamptz not null default now(),
  version       int not null default 1,
  deleted_at    timestamptz
);

create index if not exists moments_group_idx on public.moments(group_id, created_at desc);

-- ============================================================
-- 2. updated_at 自动维护
-- ============================================================
create or replace function public.touch_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := now();
  new.version := coalesce(old.version, 0) + 1;
  return new;
end;
$$;

drop trigger if exists wishes_touch_updated_at on public.wishes;
create trigger wishes_touch_updated_at
  before update on public.wishes
  for each row execute function public.touch_updated_at();

-- ============================================================
-- 3. 成员数维护
-- ============================================================
create or replace function public.sync_member_count()
returns trigger
language plpgsql
as $$
begin
  if tg_op = 'INSERT' then
    update public.groups set member_count = member_count + 1 where id = new.group_id;
  elsif tg_op = 'DELETE' then
    update public.groups set member_count = greatest(member_count - 1, 0) where id = old.group_id;
  end if;
  return null;
end;
$$;

drop trigger if exists devices_member_count on public.devices;
create trigger devices_member_count
  after insert or delete on public.devices
  for each row execute function public.sync_member_count();

-- 人数上限 4 人（数据库层兜底）
create or replace function public.enforce_group_size()
returns trigger
language plpgsql
as $$
declare
  cnt int;
begin
  select count(*) into cnt from public.devices where group_id = new.group_id;
  if cnt >= 4 then
    raise exception '该组已达到 4 人上限';
  end if;
  return new;
end;
$$;

drop trigger if exists devices_enforce_group_size on public.devices;
create trigger devices_enforce_group_size
  before insert on public.devices
  for each row execute function public.enforce_group_size();

-- ============================================================
-- 4. 行级安全（RLS）
--
-- 说明：本项目「不分账户」，客户端通过 anon key 直连。
-- 因此用「设备 ID」作为身份凭证：
--   客户端在每次请求的 header 中携带 `x-device-id`，
--   RLS 策略据此判断该设备是否属于目标组。
-- ============================================================

alter table public.groups  enable row level security;
alter table public.devices enable row level security;
alter table public.wishes  enable row level security;
alter table public.moments enable row level security;

-- 读取当前请求的设备 ID
create or replace function public.current_device_id()
returns uuid
language plpgsql
stable
as $$
declare
  raw text;
begin
  raw := coalesce(
    current_setting('request.headers', true)::json ->> 'x-device-id',
    ''
  );
  if raw = '' then
    return null;
  end if;
  return raw::uuid;
exception
  when others then
    return null;
end;
$$;

-- 当前设备所属组
create or replace function public.current_group_id()
returns uuid
language sql
stable
as $$
  select group_id
  from public.devices
  where device_id = public.current_device_id()
  limit 1;
$$;

-- --- groups ---
drop policy if exists groups_select on public.groups;
create policy groups_select on public.groups
  for select using (id = public.current_group_id());

drop policy if exists groups_insert on public.groups;
create policy groups_insert on public.groups
  for insert with check (true);   -- 建组：任何设备可创建

drop policy if exists groups_update on public.groups;
create policy groups_update on public.groups
  for update using (id = public.current_group_id());

-- --- devices ---
-- 加入组时需要按邀请码查组，因此允许读取同组设备
drop policy if exists devices_select on public.devices;
create policy devices_select on public.devices
  for select using (
    group_id = public.current_group_id() or device_id = public.current_device_id()
  );

drop policy if exists devices_insert on public.devices;
create policy devices_insert on public.devices
  for insert with check (device_id = public.current_device_id());

drop policy if exists devices_update on public.devices;
create policy devices_update on public.devices
  for update using (device_id = public.current_device_id());

drop policy if exists devices_delete on public.devices;
create policy devices_delete on public.devices
  for delete using (device_id = public.current_device_id());

-- --- wishes ---
drop policy if exists wishes_select on public.wishes;
create policy wishes_select on public.wishes
  for select using (group_id = public.current_group_id());

drop policy if exists wishes_insert on public.wishes;
create policy wishes_insert on public.wishes
  for insert with check (group_id = public.current_group_id());

drop policy if exists wishes_update on public.wishes;
create policy wishes_update on public.wishes
  for update using (group_id = public.current_group_id());

drop policy if exists wishes_delete on public.wishes;
create policy wishes_delete on public.wishes
  for delete using (group_id = public.current_group_id());

-- --- moments ---
drop policy if exists moments_select on public.moments;
create policy moments_select on public.moments
  for select using (group_id = public.current_group_id());

drop policy if exists moments_insert on public.moments;
create policy moments_insert on public.moments
  for insert with check (group_id = public.current_group_id());

drop policy if exists moments_update on public.moments;
create policy moments_update on public.moments
  for update using (group_id = public.current_group_id());

drop policy if exists moments_delete on public.moments;
create policy moments_delete on public.moments
  for delete using (group_id = public.current_group_id());

-- ============================================================
-- 5. 实时订阅（仅按组推送）
-- ============================================================
alter publication supabase_realtime add table public.wishes;
alter publication supabase_realtime add table public.moments;
alter publication supabase_realtime add table public.devices;

-- ============================================================
-- 6. 存储桶（日常图片）
-- ============================================================
insert into storage.buckets (id, name, public)
values ('moments-images', 'moments-images', false)
on conflict (id) do nothing;

-- 仅同组设备可读写（按路径前缀 group_id 校验）
drop policy if exists moments_images_read on storage.objects;
create policy moments_images_read on storage.objects
  for select using (
    bucket_id = 'moments-images'
    and (storage.foldername(name))[1] = public.current_group_id()::text
  );

drop policy if exists moments_images_write on storage.objects;
create policy moments_images_write on storage.objects
  for insert with check (
    bucket_id = 'moments-images'
    and (storage.foldername(name))[1] = public.current_group_id()::text
  );
