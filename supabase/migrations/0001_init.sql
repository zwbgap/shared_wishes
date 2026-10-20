-- ============================================================
-- Shared Wishes — Supabase 数据库初始化（v1.1 鉴权修订）
-- 目标：2~4 人共享组，无账户体系（Supabase 匿名登录），组内数据隔离
-- 执行：Supabase Dashboard → SQL Editor → 粘贴运行（可重复执行）
--
-- ⚠️ 前置配置：Dashboard → Authentication → Sign In / Up →
--    开启「Anonymous sign-ins」，否则客户端无法取得身份。
--
-- 鉴权模型（v1.1，替代旧版 x-device-id header 方案 —— 该方案的
-- anon key 公开在 App 内，header 可被任意伪造，属致命越权，已废弃）：
--   1. 设备首次启动调用 auth.signInAnonymously()，获得绑定 auth.uid() 的 JWT
--   2. devices.auth_uid 唯一绑定匿名身份（一身份最多一个设备行、只属一个组）
--   3. RLS 一律以 auth.uid() / current_group_id() 判权
--   4. 建组 / 入组只能走 security definer RPC（create_group / join_group），
--      邀请码校验、人数上限、字段校验全部在服务端
--   5. anon（未认证）角色对业务表零权限，RPC 仅授予 authenticated
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
  created_by    uuid references auth.users(id) on delete set null,
  created_at    timestamptz not null default now(),
  member_count  int         not null default 1
);

comment on table public.groups is '2~4 人共享组，一个设备只属于一个组';
comment on column public.groups.invite_code is '8 位邀请码，字符集已剔除 O/0/I/1/L';
comment on column public.groups.created_by is '创建者匿名身份 auth.uid()，解散组鉴权依据';

-- 设备（成员）
create table if not exists public.devices (
  id            uuid primary key default gen_random_uuid(),
  group_id      uuid not null references public.groups(id) on delete cascade,
  auth_uid      uuid not null unique references auth.users(id) on delete cascade,
  device_id     uuid not null unique,          -- 客户端生成并持久化，作为同步幂等键（非鉴权依据）
  nickname      varchar(20) not null,
  avatar_emoji  varchar(8)  not null,
  platform      varchar(10) not null check (platform in ('ios','android')),
  model_name    varchar(60),
  last_active_at timestamptz not null default now(),
  created_at    timestamptz not null default now()
);

create index if not exists devices_group_idx on public.devices(group_id);

comment on column public.devices.auth_uid is
  '绑定的匿名身份（auth.uid()），RLS 判权唯一依据；一身份最多一行';

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
-- 3. 成员数维护与上限
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

-- 人数上限 4 人（数据库层兜底，防 RPC 并发竞态）
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
-- 4. 邀请码与成员输入校验（供 RPC 调用）
-- ============================================================
create or replace function public.generate_invite_code()
returns varchar(8)
language plpgsql
volatile
as $$
declare
  charset text := 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';  -- 剔除 O/0/I/1/L
  code    text;
begin
  loop
    code := '';
    for i in 1..8 loop
      code := code || substr(charset, floor(random() * length(charset))::int + 1, 1);
    end loop;
    exit when not exists (select 1 from public.groups g where g.invite_code = code);
  end loop;
  return code;
end;
$$;

create or replace function public.validate_member_input(
  p_nickname    text,
  p_avatar_emoji text,
  p_platform    text
)
returns void
language plpgsql
as $$
begin
  if char_length(btrim(p_nickname)) < 2 or char_length(btrim(p_nickname)) > 20 then
    raise exception '昵称长度需在 2~20 字之间';
  end if;
  if p_avatar_emoji is null or char_length(p_avatar_emoji) = 0 or char_length(p_avatar_emoji) > 8 then
    raise exception '头像 emoji 无效';
  end if;
  if p_platform not in ('ios','android') then
    raise exception 'platform 必须为 ios 或 android';
  end if;
end;
$$;

-- ============================================================
-- 5. 身份与鉴权辅助（security definer：避免 devices 表 RLS 递归）
-- ============================================================

-- 旧版基于请求头判身份的函数已废弃
drop function if exists public.current_device_id();

-- 当前设备所属组（以 auth.uid() 判定，不再信任任何客户端自报 header）
create or replace function public.current_group_id()
returns uuid
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select d.group_id
  from public.devices d
  where d.auth_uid = auth.uid()
  limit 1;
$$;

-- ============================================================
-- 6. 建组 / 入组 RPC（security definer —— 客户端不直写 groups/devices）
-- ============================================================
create or replace function public.create_group(
  p_group_name   text,
  p_nickname     text,
  p_avatar_emoji text,
  p_platform     text,
  p_device_id    uuid,
  p_model_name   text default null
)
returns json
language plpgsql
volatile
security definer
set search_path = public, pg_temp
as $$
declare
  v_uid       uuid := auth.uid();
  v_code      varchar(8);
  v_group_id  uuid;
  v_name      varchar(50);
  v_attempts  int := 0;
begin
  if v_uid is null then
    raise exception '请先完成匿名登录';
  end if;
  perform public.validate_member_input(p_nickname, p_avatar_emoji, p_platform);
  if p_device_id is null then
    raise exception 'device_id 不能为空';
  end if;
  if exists (select 1 from public.devices d where d.auth_uid = v_uid) then
    raise exception '当前设备已加入一个组，请先离开原组';
  end if;

  loop
    v_attempts := v_attempts + 1;
    v_code := public.generate_invite_code();
    begin
      insert into public.groups (invite_code, name, created_by)
      values (v_code, left(btrim(p_group_name), 50), v_uid)
      returning id, name into v_group_id, v_name;
      exit;
    exception when unique_violation then
      if v_attempts >= 20 then
        raise exception '邀请码生成失败，请重试';
      end if;
    end;
  end loop;

  insert into public.devices (group_id, auth_uid, device_id, nickname, avatar_emoji, platform, model_name)
  values (v_group_id, v_uid, p_device_id, btrim(p_nickname), p_avatar_emoji, p_platform, p_model_name);

  return json_build_object(
    'group_id', v_group_id,
    'group_name', v_name,
    'invite_code', v_code
  );
end;
$$;

create or replace function public.join_group(
  p_invite_code  text,
  p_nickname     text,
  p_avatar_emoji text,
  p_platform     text,
  p_device_id    uuid,
  p_model_name   text default null
)
returns json
language plpgsql
volatile
security definer
set search_path = public, pg_temp
as $$
declare
  v_uid   uuid := auth.uid();
  v_group public.groups%rowtype;
begin
  if v_uid is null then
    raise exception '请先完成匿名登录';
  end if;
  perform public.validate_member_input(p_nickname, p_avatar_emoji, p_platform);
  if p_device_id is null then
    raise exception 'device_id 不能为空';
  end if;
  if exists (select 1 from public.devices d where d.auth_uid = v_uid) then
    raise exception '当前设备已加入一个组，请先离开原组';
  end if;

  select * into v_group
  from public.groups g
  where g.invite_code = upper(btrim(p_invite_code));
  if not found then
    raise exception '邀请码无效';
  end if;

  if (select count(*) from public.devices d where d.group_id = v_group.id) >= 4 then
    raise exception '该组已满（上限 4 人）';
  end if;

  insert into public.devices (group_id, auth_uid, device_id, nickname, avatar_emoji, platform, model_name)
  values (v_group.id, v_uid, p_device_id, btrim(p_nickname), p_avatar_emoji, p_platform, p_model_name);

  return json_build_object(
    'group_id', v_group.id,
    'group_name', v_group.name,
    'invite_code', v_group.invite_code
  );
end;
$$;

-- RPC 仅授予已认证（含匿名登录）身份
revoke execute on function public.create_group(text,text,text,text,uuid,text) from public, anon;
revoke execute on function public.join_group(text,text,text,text,uuid,text) from public, anon;
grant execute on function public.create_group(text,text,text,text,uuid,text) to authenticated;
grant execute on function public.join_group(text,text,text,text,uuid,text) to authenticated;

-- ============================================================
-- 7. 行级安全（RLS）
--
-- 说明：客户端必须先 signInAnonymously() 取得 JWT（authenticated 角色）；
-- 未认证（anon）对业务表零权限。判权只看 auth.uid()，
-- 不再使用任何客户端自报的 header。
-- ============================================================

alter table public.groups  enable row level security;
alter table public.devices enable row level security;
alter table public.wishes  enable row level security;
alter table public.moments enable row level security;

-- 未认证角色零权限（防匿名扫库）
revoke all on public.groups, public.devices, public.wishes, public.moments from anon;

-- --- groups ---
drop policy if exists groups_select on public.groups;
create policy groups_select on public.groups
  for select using (id = public.current_group_id());

-- 无 insert 策略 = 禁止直插，建组只能走 create_group RPC
drop policy if exists groups_insert on public.groups;

drop policy if exists groups_update on public.groups;
create policy groups_update on public.groups
  for update using (id = public.current_group_id());

drop policy if exists groups_delete on public.groups;
create policy groups_delete on public.groups
  for delete using (created_by = auth.uid());   -- 仅创建者可解散组

-- --- devices ---
drop policy if exists devices_select on public.devices;
create policy devices_select on public.devices
  for select using (
    auth_uid = auth.uid() or group_id = public.current_group_id()
  );

-- 无 insert 策略 = 入组只能走 join_group RPC
drop policy if exists devices_insert on public.devices;

drop policy if exists devices_update on public.devices;
create policy devices_update on public.devices
  for update using (auth_uid = auth.uid());

drop policy if exists devices_delete on public.devices;
create policy devices_delete on public.devices
  for delete using (auth_uid = auth.uid());   -- 离开组

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
-- 8. 实时订阅（仅按组推送；Realtime 同样受 RLS 约束）
-- ============================================================
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'wishes'
  ) then
    alter publication supabase_realtime add table public.wishes;
  end if;

  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'moments'
  ) then
    alter publication supabase_realtime add table public.moments;
  end if;

  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'devices'
  ) then
    alter publication supabase_realtime add table public.devices;
  end if;
end $$;

-- ============================================================
-- 9. 存储桶（日常图片）
-- ============================================================
insert into storage.buckets (id, name, public)
values ('moments-images', 'moments-images', false)
on conflict (id) do nothing;

-- 仅同组成员可读写删（按路径前缀 group_id 校验）
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

drop policy if exists moments_images_delete on storage.objects;
create policy moments_images_delete on storage.objects
  for delete using (
    bucket_id = 'moments-images'
    and (storage.foldername(name))[1] = public.current_group_id()::text
  );
