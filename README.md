# shared_wishes

2-4 人共享的**愿望清单 + 日常记录**应用（Flutter，双端：iPhone 17 Pro / iOS 18 + OPPO Find X9 Pro / ColorOS 16）。

设计基线见 [docs/shared-wishes-design.md](docs/shared-wishes-design.md)。

## 架构速览

- **离线优先**：所有写操作先落本地 Isar，再入 Sync Queue，联网后异步同步。
- **乐观更新**：UI 立即反映本地变更，失败回滚。
- **冲突解决**：Last-write-wins（按 `updatedAt` 比较）。
- **鉴权**：无账户体系。设备首次启动 `signInAnonymously()` 取得匿名身份（`auth.uid()`），`devices.auth_uid` 绑定身份后由 RLS 判权；建组/入组仅能走 `create_group` / `join_group` RPC（服务端校验邀请码与 4 人上限），威胁模型见设计文档 8.3。
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

开发环境：**Windows + PowerShell**，Flutter **3.47.7**（stable）/ Dart **3.13.5**，SDK 位于 `D:\flutter\flutter`（已在 PATH 中）。

本机 GitHub 不可达，依赖下载需走国内镜像。**每个 PowerShell 会话先设置**：

```powershell
$env:FLUTTER_STORAGE_BASE_URL = 'https://storage.flutter-io.cn'
$env:PUB_HOSTED_URL = 'https://pub.flutter-io.cn'
```

建议写入用户环境变量一劳永逸（设置后新开终端自动生效）：

```powershell
[Environment]::SetEnvironmentVariable('FLUTTER_STORAGE_BASE_URL', 'https://storage.flutter-io.cn', 'User')
[Environment]::SetEnvironmentVariable('PUB_HOSTED_URL', 'https://pub.flutter-io.cn', 'User')
```

## Supabase 配置

敏感配置不进代码库，通过 `--dart-define` 注入。**未注入时应用以纯离线模式启动**（便于骨架联调与 CI 构建）。

1. 在 Supabase 控制台建项目，并开启 **Authentication → Sign In / Up → Anonymous sign-ins**（鉴权模型依赖匿名登录）。
2. 在 SQL Editor 执行 [supabase/migrations/0001_init.sql](supabase/migrations/0001_init.sql)（含建组/入组 RPC 与 RLS）。
3. 运行应用时注入 URL 与 key（PowerShell 续行用反引号，或写一行）：

```powershell
flutter run --dart-define=SUPABASE_URL=https://xxxx.supabase.co --dart-define=SUPABASE_ANON_KEY=eyJhbGciOi...
```

## 常用命令

```powershell
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # 重新生成 Isar .g.dart
flutter analyze
flutter test
flutter build apk --debug        # 需 Android SDK
flutter build ios --no-codesign  # 需 macOS/Xcode
```

## 真机运行

两端均以 USB 连接后：

```powershell
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
- [x] 鉴权模型 v1.1（匿名登录 + 邀请码 RPC，修复 x-device-id 伪造与入组查询漏洞）
- [x] 三 Tab 根容器 + 三页面骨架
- [x] `flutter analyze` 零问题
- [x] `flutter test` 冒烟测试通过
