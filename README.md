# shared_wishes

2-4 人共享的**愿望清单 + 日常记录**应用（Flutter，双端：iPhone 17 Pro / iOS 18 + OPPO Find X9 Pro / ColorOS 16）。

设计基线见 [docs/shared-wishes-design.md](docs/shared-wishes-design.md)。

## 架构速览

- **离线优先**：所有写操作先落本地 Isar，再入 Sync Queue，联网后异步同步。
- **乐观更新**：UI 立即反映本地变更，失败回滚。
- **冲突解决**：Last-write-wins（按 `updatedAt` 比较）。
- **鉴权**：无账户体系，设备配对 + 8 位邀请码；Supabase 侧用 `X-Device-Id` 头 + RLS 按设备鉴权。
- **小团体上限**：单组最多 4 名成员（DB 层约束）。

```
lib/
├── main.dart                        # 入口（Supabase 引导 → ProviderScope）
├── app.dart                         # 根 MaterialApp + CupertinoTheme 覆写
├── core/
│   ├── config/app_config.dart       # --dart-define 注入的运行时配置
│   ├── theme/design_tokens.dart     # 8pt Grid 统一数值来源
│   ├── theme/app_theme.dart         # Material 3 / Cupertino 主题
│   ├── platform/platform_info.dart  # 平台判定（集中管理）
│   ├── haptics/                     # 触觉反馈抽象层
│   └── supabase/                    # 启动引导 + 客户端封装
├── data/
│   └── local/
│       ├── local_database.dart      # Isar 入口（5 个 schema）
│       └── entities/                # Wish / Moment / Device / Group / SyncItem
├── features/
│   ├── shell/       # 三 Tab 根容器
│   ├── wishes/      # 愿望清单
│   ├── moments/     # 日常记录
│   └── group/       # 组管理
└── shared/widgets/  # AdaptivePageScaffold、WishCard 等复用组件
supabase/migrations/0001_init.sql    # 表结构 + RLS + 实时订阅 + 存储桶
```

## 双端适配要点

| 维度 | iPhone 17 Pro / iOS 18 | OPPO Find X9 Pro / ColorOS 16 |
| --- | --- | --- |
| 页面骨架 | `CupertinoPageScaffold` + 大标题导航栏 | `Scaffold` + Material 3 `AppBar` |
| 根导航 | `CupertinoTabScaffold` + 毛玻璃 TabBar | `NavigationBar` + IndexedStack |
| 主题 | `CupertinoTheme`（系统蓝 / SF Pro 字重） | Material 3 + Material You |
| FAB 位置 | 右下角，避开动态岛/底部手势区 | `endFloat`，避开居中偏下超声波指纹区 |
| 后台同步 | BGTaskScheduler | WorkManager + 前台常驻通知 |
| 危险操作 | 置于困难区（远离拇指热区） | 同左，防误触 |

## 环境准备

本仓库使用持久化的 Flutter 环境（含国内镜像加速）。**每条命令前先 source**：

```bash
source /workspace/.tooling/env.sh
```

该脚本设置 `FLUTTER_ROOT`、`PUB_CACHE`（落在 `/workspace/.tooling/pub-cache`，避免被清空）、以及 `pub.flutter-io.cn` 镜像。

## Supabase 配置

敏感配置不进代码库，通过 `--dart-define` 注入。**未注入时应用以纯离线模式启动**（便于骨架联调与 CI 构建）。

1. 在 Supabase 控制台建项目，执行 [supabase/migrations/0001_init.sql](supabase/migrations/0001_init.sql)。
2. 运行应用时注入 URL 与 key：

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOi...
```

## 常用命令

```bash
source /workspace/.tooling/env.sh

flutter pub get
dart run build_runner build --delete-conflicting-outputs   # 重新生成 Isar .g.dart
flutter analyze
flutter test
flutter build apk --debug        # 需 Android SDK
flutter build ios --no-codesign  # 需 macOS/Xcode
```

## 真机运行

两端均以 USB 连接后：

```bash
flutter devices                 # 确认设备已识别
flutter run -d <device-id> --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```

- **iOS**：首次需在 Xcode 中配置签名 Team；`Runner/Info.plist` 已含所需权限声明。
- **Android**：ColorOS 16 需在「设置 → 应用 → 后台耗电管理」中允许后台活动，否则同步可能被系统冻结。

## Phase 0 完成状态

- [x] 项目骨架 + 目录分层
- [x] 设计令牌与双端主题
- [x] Isar 本地库 + 5 实体（代码生成完毕）
- [x] Supabase 初始化脚本（表/RLS/实时/存储）
- [x] 三 Tab 根容器 + 三页面骨架
- [x] `flutter analyze` 零问题
- [x] `flutter test` 冒烟测试通过
