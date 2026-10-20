# Shared Wishes — 移动应用设计文档

> **版本**：v1.1（设计基线；2026-10-20 修订：鉴权模型改为 Supabase 匿名登录，见 8.3）
> **目标设备**：iPhone 17 Pro（iOS 18）× OPPO Find X9 Pro（ColorOS 16 / Android 16）
> **技术栈**：Flutter 3.x + Supabase + Riverpod + Isar
> **文档用途**：开发大纲 + 设计规范单一事实来源
> **最后更新**：2026-10-20

---

## 目录

```
Part 1. 产品定义与核心场景
Part 2. 目标设备精确规格与约束
Part 3. 导航架构
Part 4. 设计系统（Design Tokens）
Part 5. 屏幕逐一设计（含组件分解）
Part 6. 交互与手势规范
Part 7. 触觉反馈映射表
Part 8. 状态管理与数据流
Part 9. 离线与同步策略
Part 10. 无障碍（Accessibility）
Part 11. 平台差异对照表（iOS 18 vs ColorOS 16）
Part 12. 性能预算与检查点
Part 13. 里程碑与交付物
Appendix A. 额外想法（Bonus Ideas）
Appendix B. MFRI 评估
```

---

## Part 1. 产品定义与核心场景

### 1.1 一句话描述
**2 人专属亲密空间**（可扩展至 4 人），共享愿望清单 + 日常图片/文字记录，**零账户、邀请码组队、实时同步**。

### 1.2 用户关系
情侣 / 夫妻 / 家庭成员 / 合租密友 —— **高度信任**，无陌生人社交需求。

### 1.3 核心场景（按优先级排序）

| # | 场景 | 触发端 | 两端一致性 | 备注 |
|---|------|--------|-----------|------|
| S1 | 创建愿望 | 任一方 | 🟢 实时 | |
| S2 | 标记愿望完成 + 写纪念 | 任一方 | 🟢 实时推送 + 谁标记的 | **核心闭环体验** |
| S3 | 拍照/文字记录日常 | 任一方 | 🟡 图片可延迟 | 弱网下优先文字 |
| S4 | 浏览对方新增内容 | 被动查看 | 🟢 刷新可见 | |
| S5 | 离线操作（地铁/地下室） | 任一方 | 🔴 必须可用 | |
| S6 | 分享邀请码给新成员 | 任一方 | 🟢 | V1 支持最多 4 人 |

### 1.4 明确非目标

```
❌ 不做公开社交 / 陌生人发现
❌ 不做多群组切换（一个设备只属一个组）
❌ 不做 AI 推荐愿望
❌ 不做网页端
❌ 不做 iPad / 平板 / 折叠屏（V1）
❌ 不做 Apple Watch / Wear OS（V1.1 再评估）
```

---

## Part 2. 目标设备精确规格与约束

### 2.1 iPhone 17 Pro

| 项目 | 值 | 设计含义 |
|------|-----|---------|
| 系统 | iOS 18 | 支持 Dynamic Island Live Activity、StandBy Widget、App Intents |
| 显示屏 | 6.3" Super Retina XDR，2622×1206，460 ppi | 安全区顶部 59pt（Dynamic Island），底部 34pt（Home Indicator） |
| 刷新率 | ProMotion 自适应最高 120Hz | 所有列表滚动需保持 120fps 流畅 |
| 亮度 | 峰值 3000 nits 户外 | 阳光下对比度有保障 |
| 交互 | Face ID + 侧边按钮 | 侧边按钮双击触发快捷操作（V1.1 评估 App Intents） |
| 认证 | Ceramic Shield 2 | 不影响设计，只是耐用 |
| 手势基准 | iOS 18 HIG：左边缘返回、下拉关闭 Sheet、双击抬起唤醒 | |
| Always-On | ✅ 支持 | **额外想法**：锁屏显示"我们今天有 3 个未完成愿望"（Widget） |
| 通知 | APNs，支持 Live Activity（实时刷新） | 愿望完成时显示实时徽章动画 |

### 2.2 OPPO Find X9 Pro

| 项目 | 值 | 设计含义 |
|------|-----|---------|
| 系统 | ColorOS 16（底层 Android 16） | **关键**：ColorOS 16 有自研 Luminous Rendering Engine，tap 响应 < 100ms；Seamless Animations |
| 显示屏 | 6.78" AMOLED ProXDR，2772×1272，约 450 ppi | 挖孔屏（居中），顶部安全区约 36dp；底部手势条 24dp |
| 刷新率 | 120Hz Adaptive | Pro 版恒定 120Hz 场景更多，需保持流畅 |
| 触控采样 | **300Hz**（Find X9 Pro 亮点） | 比 iPhone 的 ~120Hz 更高，**我们的动画响应必须够快才能不浪费** |
| 亮度 | 局部峰值 3600 nits，全局默认 800 nits | 阳光下可读性比 iPhone 更好 |
| 交互 | 超声波屏下指纹（位置偏下）+ 侧边按键 + 面部 | 手势区在底部偏上位置，避免 FAB 与指纹位置冲突 |
| 认证 | Gorilla Victus 2 | |
| 手势基准 | ColorOS 16 可配置：**边缘返回** / 三键导航 / 手势导航（三种并存） | **必须全部兼容**，不要假设单一模式 |
| Always-On | ❌ 无（OPPO Find X9 Pro 全系不支持息屏显示小组件） | Widget 走系统桌面小组件路线 |
| 电池 | 7500 mAh（业界顶级） | 后台上传队列可以更激进 |
| 快充 | 80W 有线 / 50W 无线 | 不重要 |
| 曲面/直面 | **直面屏**（1.15mm 极窄边框） | 无曲面边缘误触问题 |
| 后台管理 | ColorOS 16 相较前代已放宽，但仍比 iOS 激进 | **必须使用 WorkManager + 前台常驻通知保活上传队列** |
| 通知 | FCM + OPPO Push 通道（国内） | 国内需 OPPO Push 辅助，海外走 FCM |
| 隐私 | ColorOS 隐私中心、应用分身、沙盒 | 不影响我们，但不要滥用权限（存储、位置可选申请） |
| 无障碍 | 系统级 TalkBack、ColorOS 朗读、放大手势 | |

### 2.3 双端关键差异（直接影响设计）

```
                iPhone 17 Pro       OPPO Find X9 Pro
                ─────────────       ─────────────────
屏幕尺寸        6.3"                 6.78"（大 ~7.6%）
宽度逻辑像素    390pt                ~393dp
高度逻辑像素    844pt                ~872dp
安全区顶部      59pt（动态岛）        36dp（挖孔）
安全区底部      34pt                 24dp
最大触控采样    ~120Hz               300Hz（更灵敏）
Always-On       ✅                   ❌
后台激进度      温和                 较激进（需 WorkManager）
息屏 Widget     ✅（StandBy）        ❌
指纹位置        —                    屏幕中下部（避让 FAB）
Face ID         ✅                    ✅
```

**设计直接影响**：
1. Find X9 Pro 更宽更高 → 图片瀑布流 Android 端可以 3 列（而非 2 列）
2. Find X9 Pro 300Hz 触控 → FAB 点击反馈必须 < 50ms，否则会觉得"反应慢"
3. iPhone Dynamic Island 比 OPPO 挖孔占更多垂直空间 → 顶部导航栏 Android 可以稍紧凑
4. OPPO 有超声波指纹 → FAB 右下角 56dp 圆圈要避开指纹区域（通常底部 1/3 区域靠中间），放到更靠右下
5. iPhone Always-On → 额外做一个锁屏 Widget 显示今日进度（Bonus）

---

## Part 3. 导航架构

### 3.1 整体结构

```
根导航：
├── iPhone 17 Pro → CupertinoTabScaffold（iOS 18 HIG）
└── OPPO Find X9 Pro → Material 3 NavigationBar + Scaffold

三个 Tab：
├── Tab 1：愿望清单（主入口）
├── Tab 2：日常记录
└── Tab 3：我的（组管理）

栈导航（Stack）：
├── 愿望详情 ← 卡片 push
├── 新建/编辑愿望 ← FAB / Sheet modal
├── 日常详情 ← 卡片 push
├── 组邀请码 ← 从"我的"进入
└── 成员管理 ← 从"我的"进入

模态（Modal）：
├── 加入组输入邀请码 → iOS Sheet detent / Android Dialog
├── 标记完成写纪念文字 → Bottom Sheet
├── 相机/相册 → 系统原生
└── 确认离开组/解散组 → Alert

Floating Action Button（FAB）：
├── 愿望清单 Tab → "➕ 新愿望"
└── 日常记录 Tab → "📷 记录此刻"
```

### 3.2 平台差异点

| 元素 | iPhone 17 Pro / iOS 18 | OPPO Find X9 Pro / ColorOS 16 |
|------|----------------------|------------------------------|
| 底部导航 | `CupertinoTabBar`，49pt 高，毛玻璃背景，选中态填充 | Material 3 `NavigationBar`，80dp 高，**Material You Dynamic Color**（若系统支持），indicator pill |
| 导航栏 | `CupertinoNavigationBar`，44pt，大标题可折叠，iOS 18 新 Liquid Glass 可选 | Material 3 `TopAppBar`（Medium → Small 折叠），支持 1dp elevation |
| 返回手势 | **左边缘滑动**（系统自动） | 系统可选三种：①左/右边缘返回手势 ②三键导航 ③手势导航（上滑+左右滑），**全部兼容** |
| Sheet | iOS 15+ Sheet，支持 detents（medium/large）+ 拖拽关闭 + grabber | Material 3 `ModalBottomSheet`，28dp 顶部圆角，scrim 背景，可点击外部关闭 |
| Dialog | `CupertinoAlertDialog`（iOS 18 新材质） | Material 3 `AlertDialog`，居中 + scrim |
| 下拉刷新 | `UIRefreshControl` 原生样式 | `SwipeRefreshIndicator`（Material 3 圆形指示器） |
| 长按菜单 | iOS Context Menu（带预览卡 + Quick Action） | Material 3 `DropdownMenu` 或 `ModalBottomSheet` 菜单 |
| 分段选择 | `CupertinoSegmentedControl` | Material 3 `SegmentedButton` |

---

## Part 4. 设计系统（Design Tokens）

> **基础网格**：8pt/dp Grid（双端通用）。Flutter 自动处理 pt ↔ dp 密度比。

### 4.1 间距系统

```
4    组件内部微间距（icon 与 text 之间）
8    最小点击间距（相邻可点击元素之间，WCAG 2.5.8）
12   按钮内部 vertical padding
16   屏幕边距 / 卡片内部 padding（标准）
24   Section 间距
32   大模块间距
48   双行文本间距
```

### 4.2 触摸目标（强制规范）

| 元素 | 视觉尺寸 | 点击区域（padding 扩展） |
|------|---------|------------------------|
| 复选框 ☑ | 24pt/dp | **48pt/dp（MUST）** |
| 图标按钮（顶部导航） | 24pt/dp | 44pt（iOS）/ 48dp（Android） |
| 列表行（WishCard） | 全宽 | 高度 ≥ **72pt/dp** |
| FAB | **56pt/dp** 直径 | 本身 56pt/dp（满足） |
| 文本按钮 | height ≥ 36pt | 扩展到 44pt / 48dp |
| Sheet 关闭（✕） | 24pt/dp | **44pt/dp** |
| Filter Chip | 自适应文字 | height ≥ **48pt/dp** |
| Tab 栏项 | 25pt icon + label | 49pt（iOS Tab 高度）/ 80dp（Android） |
| 长按菜单项 | — | 高度 ≥ **48dp** |

### 4.3 字体系统

#### iPhone 17 Pro / iOS 18（SF Pro，语义样式 + Dynamic Type）

| 样式 | 默认 | 字重 | 用途 |
|------|------|------|------|
| Large Title | 34pt | Bold | 导航栏大标题（滚动折叠） |
| Title 1 | 28pt | Bold | 页面标题 |
| Title 2 | 22pt | Bold | Section 标题 |
| Title 3 | 20pt | Semibold | 卡片标题（愿望名称） |
| Headline | 17pt | Semibold | 强调正文 |
| Body | 17pt | Regular | 愿望描述 / 日常正文 |
| Callout | 16pt | Regular | 次要正文 |
| Subhead | 15pt | Regular | 辅助文字（分类标签、谁创建的） |
| Footnote | 13pt | Regular | 时间戳 |
| Caption 1 | 12pt | Regular | 极小文字 |

**强制：所有使用系统语义样式，不硬编码 size**，让 Dynamic Type 自动放大到 Accessibility 53pt。

#### OPPO Find X9 Pro / ColorOS 16（Roboto，Material 3 Type Scale）

| Role | Size | Weight | Line Height | 用途 |
|------|------|--------|-------------|------|
| Headline Large | 32sp | Regular | 40sp | 大标题 |
| Headline Medium | 28sp | Regular | 36sp | 页面标题 |
| Title Large | 22sp | Regular | 28sp | Section |
| Title Medium | 16sp | Medium | 24sp | 卡片标题（愿望名称） |
| Body Large | 16sp | Regular | 24sp | 正文 |
| Body Medium | 14sp | Regular | 20sp | 次要正文 |
| Label Large | 14sp | Medium | 20sp | 按钮文字 |
| Label Medium | 12sp | Medium | 16sp | Chip / Tab label |
| Body Small | 12sp | Regular | 16sp | 时间戳 |

**强制：使用 sp 单位**，支持 ColorOS 字体缩放 85%–200%。

### 4.4 颜色系统

#### iOS（语义色，自动 Dark Mode）

```
Primary (Tint):       #007AFF（系统蓝）
Secondary:           #FF2D55（粉红 → 表达亲密/庆祝）
Success:             #34C759（已完成状态 ✓）
Warning:             #FF9500
Error:               #FF3B30（危险操作）

Background:           systemBackground
SecondaryBackground:  secondarySystemBackground
Label:                label（主文字）
SecondaryLabel:       secondaryLabel
Separator:            separator
Fill:                 systemFill
```

#### Android（Material 3 + Dynamic Color）

```
Material 3 ColorScheme:
├── Primary:           isDynamicColorAvailable ? MaterialYou : #6750A4
├── OnPrimary:         #FFFFFF
├── PrimaryContainer:  #EADDFF
├── Secondary:         isDynamicColorAvailable ? MaterialYou : #625B71
├── Tertiary:          isDynamicColorAvailable ? MaterialYou
├── Error:             #B3261E
├── Surface:           Material You 动态色
├── OnSurface:         Material You 动态色
├── 必须自动启用 Dynamic Color → ColorOS 16 支持
└── 如果系统不支持 → 使用固定 Material 3 紫色系
```

#### 通用语义（双端一致）

```
已完成状态视觉：
├── 标题文字：删除线 + 70% opacity
├── 卡片背景：light 模式灰色 5% opacity；dark 模式 900 深色底
├── ✓ 勾选图标：Success 色
├── "谁标记完成的" badge：Secondary 色轻底

空状态：
├── 灰色 emoji + 灰色说明文字
└── 主按钮用 Primary 色
```

### 4.5 圆角规范

| 元素 | iPhone 17 Pro | OPPO Find X9 Pro |
|------|--------------|------------------|
| 卡片 | 14pt（iOS 标准） | 12dp（Material 3 Filled Card） |
| Sheet 顶部 | 22pt | 28dp（Material 3 BottomSheet） |
| FAB | Circle 56pt | Circle 56dp |
| 按钮（Primary） | 8pt | **20dp（Material 3 Fully Rounded）** |
| 按钮（Text） | 无 | 无 |
| 输入框 | 8pt | 4dp（Material 3 Outlined） |
| Chip | 16pt | 8dp |
| Dialog | 14pt | 28dp |

### 4.6 阴影 / Elevation

| 元素 | iOS（shadow） | Android（elevation） |
|------|--------------|---------------------|
| 卡片 resting | 无 | 0dp |
| 卡片 elevated | — | 1dp |
| FAB | 0 0 4pt rgba(0,0,0,0.2) | 6dp |
| Sheet | — | 1dp + scrim 叠加 |
| Navigation Bar | — | 0dp 静止 / 1dp 滚动 |

### 4.7 Emoji 头像系统

```
因为"不分账户"，使用 emoji + 确定性颜色：

可选 emoji 池（温馨向，排除过难识别）：
🐱 🐶 🐼 🦊 🐰 🦄 🐸 🐙 🦋 🌸 🌙 ⭐ 🍀 ☀️ 🎨 🎵 🐻 🐨 🦔 🐧

颜色分配：
├── 根据 device nickname + MAC 地址 hash 确定性选择
├── iOS 从系统色池选（label / secondaryLabel tint）
└── Android 从 Material You ColorScheme 的 Secondary 派生

显示尺寸：
├── 成员列表中：48pt/dp × 48pt/dp
├── 愿望卡片（"来自 xxx"）：28pt/dp × 28pt/dp
└── "我的"页主头像：72pt/dp × 72pt/dp
```

---

## Part 5. 屏幕逐一设计

### 5.1 屏幕总览

| # | 屏幕 | 所属 Tab | 导航方式 | 优先级 |
|---|------|---------|---------|--------|
| S0 | 启动页 | — | 首次 | P0 |
| S0.1 | Welcome 引导（3 张） | — | Push | P0 |
| S0.2 | 创建新组 | — | Push | P0 |
| S0.3 | 加入组（邀请码） | — | Push | P0 |
| S0.4 | 设置昵称 + emoji | — | Push | P0 |
| S1 | **愿望清单** | Tab 1 | 根 | P0 |
| S1.1 | 新建/编辑愿望 | Tab 1 | Sheet Modal | P0 |
| S1.2 | 愿望详情 | Tab 1 | Stack Push | P0 |
| S1.3 | 筛选器 | Tab 1 | Popover / Sheet | P1 |
| S2 | **日常记录（瀑布流）** | Tab 2 | 根 | P1 |
| S2.1 | 拍照 / 从相册选 | Tab 2 | 系统原生 | P1 |
| S2.2 | 编辑 + 文字描述 | Tab 2 | Sheet Modal | P1 |
| S2.3 | 日常详情（全屏大图 + 时间线） | Tab 2 | Stack Push | P1 |
| S3 | **我的（组管理）** | Tab 3 | 根 | P0 |
| S3.1 | 成员列表 + 邀请 | Tab 3 | Stack Push | P0 |
| S3.2 | 邀请码展示 + 分享 | Tab 3 | Sheet | P0 |
| S3.3 | 设置（通知/深色/图片质量） | Tab 3 | Stack Push | P1 |
| S3.4 | 离开组 / 解散组 | Tab 3 | Alert | P1 |

### 5.2 S0 首次引导流

```
[启动页]（2 秒）
    │
    ▼
[Welcome 横向滑动]
    ├── 卡片 1："🎯 一起记录愿望"
    ├── 卡片 2："📷 随手拍日常"
    ├── 卡片 3："🔗 两人实时同步，无需账号"
    └── [开始] 按钮（底部，拇指区）
    │
    ▼
[匿名身份获取（自动、无感）]
    └── auth.signInAnonymously() → 绑定 auth.uid() 的 JWT（零账户，详见 8.3）
    │
    ▼
[分支选择]
    ├── [创建新组] ──► [设置昵称] ──► RPC create_group ──► [生成邀请码] ──► 进入主界面
    └── [加入已有组] ──► [输入 8 位邀请码] ──► [设置昵称] ──► RPC join_group ──► 进入主界面

关键交互：
├── 全程零账户：身份由 Supabase 匿名登录提供，用户无感（威胁模型见 8.3）
├── 建组/入组必须走 security definer RPC（create_group / join_group），
│   邀请码校验、人数上限、字段校验都在服务端，客户端不直写 groups/devices
├── 昵称长度 2–20 字，必填
├── emoji 从候选池选 1 个，或让系统 hash 自动分配
├── 邀请码 8 位大写字母+数字（O/I/0/1 排除易混淆字符）
├── 邀请码可复制、可分享（系统分享面板）
└── 分享面板：iOS ActivityViewController / Android Intent.ACTION_SEND
```

### 5.3 S1 愿望清单（主屏幕）— 详细组件分解

```
SCREEN: 愿望清单
├── Safe Area（已自动处理动态岛/挖孔）
│
├── APP BAR
│   ├── iOS 18: Large Title "愿望" → 滚动后折叠
│   │   ├── iOS 18 Liquid Glass 材质（可选，跟随系统）
│   │   └── 右侧：[⚙️ 筛选]（icon button）
│   └── ColorOS 16: TopAppBar Medium → 滚动折叠为 Small
│       ├── Material 3 样式
│       └── 右侧：[⚙️ 筛选]（icon button）
│
├── FILTER SEGMENT / CHIPS
│   ├── iOS: CupertinoSegmentedControl
│   │   [ 全部 42 ] [ 进行中 30 ] [ 已完成 12 ]
│   └── Android: Material 3 SegmentedButton 或 FilterChip
│   ├── 高度 ≥ 48dp
│   └── 左右 padding 16
│
├── WISH LIST
│   ├── Widget: ListView.builder（懒加载）
│   ├── itemExtent: 80pt/dp（固定高度 → 高性能）
│   ├── padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)
│   └── 每个 item: WishCard（见下方）
│
├── FAB
│   ├── 位置：右下角
│   │   ├── iPhone: 距右 16pt，距 Tab 栏上沿 16pt
│   │   └── OPPO: 距右 16dp，距底部 112dp（避开超声波指纹区域！）
│   ├── 尺寸：56pt/dp 直径
│   ├── 图标：SF Symbols "plus" / Material Icons "add"
│   ├── 点击 → 新建愿望 Sheet
│   └── Haptic：iOS .medium / Android HEAVY_CLICK
│
├── EMPTY STATE（无数据时）
│   ├── 居中 Emoji 🎯 + "还没有愿望，一起创建第一个吧"
│   └── [ ➕ 创建愿望 ] 主按钮
│
└── OFFLINE BANNER（顶部，Snackbar 样式）
    ├── 网络断开时显示
    ├── "📡 离线中，本地仍可操作"
    └── 不阻挡滚动

WishCard 组件（单列，固定高度 80）：
┌────────────────────────────────────────────┐
│ [☐/✓ 48pt]  标题文字（Title 3 / Title Medium）  │
│             描述前 1 行（Body Small / 50% opacity） │
│             [🏷️ 分类]  [📅 目标日期]            │
│             来自：🐱 小明                         │
└────────────────────────────────────────────┘
触摸区域拆分：
├── 整个卡片 → 点击进入详情（onTap）
├── ✓/☐ → 独立 48pt 点击区，切换完成（onTap）
├── 左滑（iOS/Android 都支持）→ Reveal [完成][编辑][删除]
└── 长按 → Context Menu（iOS 预览卡 / Android 弹出菜单）

已完成状态视觉变化：
├── ✓ 变为绿色实心圆 ✓
├── 标题 → 删除线 + 70% opacity
├── 描述 → 50% opacity
├── 右侧新增 "✨ 小明完成于昨天" badge（Subhead / Secondary Label）
└── 卡片背景 → 轻灰色覆盖
```

### 5.4 S1.1 新建/编辑愿望 — Sheet Modal

```
SCREEN: 新建愿望
├── PRESENTATION
│   ├── iOS 18: Sheet from bottom，detents: [.medium, .large]，支持拖拽关闭
│   └── ColorOS 16: ModalBottomSheet，28dp 顶部圆角，点击外部可关闭
│
├── SHEET HEADER
│   ├── grabber（iOS 系统自带 / Android 28dp 小圆）
│   ├── 标题："新愿望" / "编辑愿望"（居中）
│   └── 右按钮：
│       ├── iOS: "完成"（CupertinoButton, text style）
│       └── Android: Material Icons "check" icon button
│
├── FORM（Scrollable）
│   ├── 标题输入（TextFormField，max 100 字，必填，标红色 *）
│   ├── 描述输入（多行，max 500 字，选填）
│   ├── 分类 Chip Row（HorizontalScroll + Wrap）
│   │   🍣 美食  ✈️ 旅行  🛍️ 购物  🎁 体验  🏠 居家  💡 学习
│   │   └── 选中态：背景填充 + 主色
│   └── 目标日期（可选，点击 → DatePicker）
│
├── VALIDATION
│   ├── 标题为空 → 红色错误提示 + haptic error
│   └── 保存后关闭 Sheet → haptic success
│
└── KEYBOARD AVOIDANCE
    ├── 必须使用 ResizeToAvoidBottomInset
    └── iOS：键盘弹起时 Sheet detent 自动调整到 large
```

### 5.5 S1.2 愿望详情

```
SCREEN: 愿望详情
├── 顶部大标题（愿望名称）
├── 副标题："由 🐶 小明 创建于 2025-12-01"
├── 描述段落（如果有）
├── 分类 Chip + 目标日期（醒目）
├── 状态 Banner（如果已完成）
│   └── "🎉 2026-01-15 由 🐱 小红 标记完成" + 纪念文字
├── 操作 Buttons
│   ├── [ 编辑 ]（Text）
│   ├── [ 🗑️ 删除 ]（红色，Danger）
│   └── 如果已完成 → [ 重新激活 ]
└── 如果是自己创建的 + 未完成 → [ 我来完成 ] 主 CTA（底部 FAB 区）
```

### 5.6 S2 日常记录（瀑布流）

```
SCREEN: 日常记录
├── APP BAR
│   └── "日常"（大标题）
│
├── GRID VIEW
│   ├── Widget: StaggeredGridView.builder
│   ├── iPhone 17 Pro：3 列（390pt 宽 → 每列约 123pt + 间距）
│   ├── OPPO Find X9 Pro：3 列（393dp 宽 → 每列约 124dp + 间距）
│   ├── 间距：4pt/dp（密一些）
│   ├── 边距：16pt/dp
│   ├── 下拉刷新（平台原生）
│   └── 点击 → 全屏大图查看 + 详情
│
├── UPLOAD INDICATOR（顶部横幅）
│   ├── 有未上传图片时显示
│   ├── 进度条 + "📤 后台上传中 2/5"
│   └── 点击可查看上传队列详情
│
├── OFFLINE INDICATOR
│   └── 无网络时横幅变灰 + "图片将在恢复网络后自动上传"
│
└── FAB
    ├── 图标：📷
    ├── iPhone 避开动态岛 / OPPO 避开指纹区
    ├── 点击 → Action Sheet：
    │   ├── 📷 拍照（打开系统相机）
    │   ├── 🖼️ 从相册选（打开系统相册）
    │   └── ✏️ 只写文字（打开编辑 Sheet）
    └── Haptic：iOS .medium / Android CLICK
```

### 5.7 S2.2 编辑 + 发布

```
SCREEN: 编辑日常
├── 图片预览（水平滚动，多选时 3 列网格）
├── 文字输入（多行，max 500 字，底部 placeholder "记录此刻…"）
├── 位置（可选，点击 → 获取当前位置 + 城市名）
├── 发布按钮（底部固定，大按钮，主色）
└── 取消（左上角）

Haptics：
├── 发布：iOS .success + Android DOUBLE_CLICK
└── 取消：iOS .selection + Android TICK
```

### 5.8 S3 我的（组管理）

```
SCREEN: 我的
├── GROUP HEADER（Card 样式）
│   ├── 组名（可编辑，点击 → TextField）
│   ├── 成员 emoji 横排（🐱 🐶）+ 在线点
│   └── 统计："我们 🎯 已创建 42 个愿望 · 12 个达成"
│
├── SECTION 1：成员
│   ├── 成员卡片 ListTile
│   │   ├── emoji 头像 48pt
│   │   ├── nickname
│   │   └── 副标题："在线 🟢" 或 "上次活跃 2h 前"
│   └── [ + 邀请新成员 ]（Outlined Button，底部）
│
├── SECTION 2：设置
│   ├── 通知开关（Switch）
│   ├── 深色模式跟随系统（Switch）
│   ├── 图片质量（ListTile → [原片 / 高清 / 省流量] Dialog）
│   ├── 清除本地缓存（ListTile + 显示大小，如 23.4 MB）
│   └── 关于（版本号）
│
└── SECTION 3：危险操作（**放在靠下困难区，防误触**）
    ├── [ 离开此组 ]（Text，红色，点击 → Confirm Dialog）
    └── [ 解散此组 ]（仅创建者可见，Destructive Button）

关键：
├── ColorOS Find X9 Pro 指纹在底部中下部 → 危险按钮放到更靠上
└── 危险操作 Confirm Dialog：iOS 使用 .error haptic / Android REJECT
```

### 5.9 Widget（Bonus，V1.1 评估）

```
iPhone 17 Pro Only（Find X9 Pro 无 Always-On）：
├── StandBy 模式 Widget：
│   └── "我们今天还有 3 个愿望未完成" + emoji 列表
├── 锁屏 Widget：
│   └── 圆形 / 矩形两种尺寸，显示最近的愿望状态
└── App Intents：
    └── "标记下一个愿望完成"（Shortcuts 可调用）

ColorOS 16 桌面 Widget：
├── 2×2 / 4×2 两种尺寸
└── 显示今日进度 + FAB 快捷入口
```

---

## Part 6. 交互与手势规范

### 6.1 手势完整映射表

| 手势 | iPhone 17 Pro 行为 | OPPO Find X9 Pro 行为 | 替代按钮 |
|------|-------------------|----------------------|---------|
| **单点击卡片** | 进入详情 | 进入详情 | — |
| **点击 ☑/✓** | 切换完成状态 | 切换完成状态 | — |
| **左滑列表项** | Reveal: [完成][编辑][删除] | Reveal: [完成][编辑][删除] | 长按菜单 |
| **右滑列表项** | Reveal: [置顶] | Reveal: [置顶] | 长按菜单 |
| **长按卡片** | iOS Context Menu（预览卡 + Action） | Material 3 DropdownMenu | — |
| **下拉** | 原生刷新 | 原生刷新 | — |
| **下拉 Sheet** | 关闭（detent 识别手势） | 关闭（scrim 点击也可关闭） | 取消按钮 |
| **边缘滑动** | 左边缘 → 返回上一页 | 左/右边缘 → 返回上一页（系统可配置） | — |
| **双击卡片** | 快速完成（V1.1 可选） | — | 复选框 |
| **捏合图片** | — | —（V1 不做） | 双指缩放按钮（V1.1） |

### 6.2 OPPO ColorOS 16 特别注意事项

```
ColorOS 16 特性必须兼容：
├── 边缘返回手势 / 三键导航 / 全面屏手势 三种并存
│   → WillPopScope 正确处理所有返回路径
├── 智能隐私保护：相册选择器可能拒绝某些权限
│   → 降级到系统选图器的精简模式
├── 后台管理严格：APP 切后台后上传队列可能被杀
│   → 使用 WorkManager + 前台常驻通知
│   → 显示 "📤 上传中 N/M" 通知
│   → 首次启动时弹窗引导用户关闭后台限制
├── Luminous Rendering Engine
│   → 不要在主线程阻塞 > 16ms（Flutter 默认 ok）
│   → 列表 scroll 必须 > 60fps
└── Seamless Animations
    → 我们的页面过渡动画要足够流畅，否则显得与系统脱节
```

### 6.3 iPhone 18 / iOS 18 特别注意事项

```
iOS 18 特性：
├── Liquid Glass 材质（可选使用 CupertinoSliverNavigationBar）
├── Dynamic Island Live Activity
│   → 愿望完成时显示实时徽章（可选）
├── StandBy 模式
│   → Widget 适配
├── App Intents
│   → 快捷操作（V1.1）
└── 新的 Context Menu（iOS 18 增强预览）
    → 长按愿望卡片显示 HIG 风格预览
```

---

## Part 7. 触觉反馈映射表

> **强制**：触觉反馈不是锦上添花，是**两个设备差异最大的感觉点**。iPhone 触觉更细腻，OPPO 因为 300Hz 触控采样，如果反馈延迟会**特别明显**——必须 < 50ms。

| 场景 | iPhone 17 Pro Haptic | OPPO Find X9 Pro Haptic |
|------|---------------------|------------------------|
| 切换 Tab | `.selection` | `HapticFeedback.selectionClick`（TICK） |
| 点击复选框（选中） | `.medium` | `CLICK` |
| 点击复选框（取消） | `.light` | `CLICK`（轻） |
| **标记愿望完成** | **`.heavy`** | **`HEAVY_CLICK`** |
| **愿望达成（首次会话）** | **`.success`** | **`DOUBLE_CLICK`（双 CLICK 模式）** |
| 滑动删除阈值 | `.medium` | `LONG_PRESS` |
| 表单验证失败 | `.error` | `REJECT` |
| 下拉刷新触发 | `.selection` | `CLICK` |
| 保存成功 | `.success` | `CLICK` |
| 文件上传完成 | `.medium` | `CLICK` |
| 文件上传失败 | `.error` | `REJECT` |
| 长按菜单弹出 | —（iOS 18 自动管理） | `LONG_PRESS` |
| Alert 按钮点击 | `.selection` | `CLICK` |
| FAB 点击 | `.medium` | `HEAVY_CLICK` |
| Sheet 拖拽到 detent | `.selection` | — |

**Flutter 封装要求**：
```dart
// platform_haptics.dart — 必须抽象层
abstract class PlatformHaptics {
  Future<void> light();
  Future<void> medium();
  Future<void> heavy();
  Future<void> success();
  Future<void> error();
  Future<void> warning();
}
// CupertinoHaptics implements PlatformHaptics  → CupertinoFeedback
// MaterialHaptics implements PlatformHaptics     → HapticFeedback
```

---

## Part 8. 状态管理与数据流

### 8.1 架构选择：Riverpod

```
为什么 Riverpod：
├── Flutter 官方推荐方向（Provider 继任者）
├── 编译时安全（比 Provider 强，可 override 测试）
├── 不依赖 BuildContext → 易测试
├── AsyncNotifier 内置错误/加载状态
└── 支持代码生成（riverpod_generator）

架构层级：
┌────────────────────────────────────┐
│       UI Layer (Widgets)            │
├────────────────────────────────────┤
│   State Providers（局部筛选/表单）   │
├────────────────────────────────────┤
│   AsyncNotifiers（WishNotifier,     │
│                   MomentNotifier）   │
├────────────────────────────────────┤
│   Repository Layer                  │
├────────────────────────────────────┤
│   DataSources:                      │
│   ├── Local（Isar — 比 SQLite 快）  │
│   └── Remote（Supabase）            │
└────────────────────────────────────┘
```

### 8.2 数据流完整图

```
用户操作（点击 ☑ 完成）
    │
    ▼
UI Widget onTap
    │
    ▼
WishNotifier.markCompleted(id, note)
    │
    ├──► 1. 立即更新 Isar 本地 DB（< 10ms）
    │      └── 乐观更新 UI（Stream 监听 → 自动刷新）
    │
    ├──► 2. 写入 Sync Queue（Isar 表 sync_items）
    │      └── {action: 'mark_completed', payload: {...}, retries: 0}
    │
    └──► 3. 启动后台同步引擎
           ├── connectivity_plus 检测网络
           │   ├── Online → Supabase upsert
           │   │   ├── 成功 → queue.remove()
           │   │   └── 冲突（version mismatch）
           │   │       → Last-write-wins
           │   │       → 取最早 completed_at 作为主标记
           │   │       → 多纪念文字都保留为 array
           │   └── Offline → 保持 queue
           │               → connectivity 恢复后自动重启
           │
           └── Supabase Realtime（group_id 精准订阅）
                 └── 他人变更 → 更新本地 Isar → UI 自动刷新
```

---

### 8.3 鉴权与威胁模型（v1.1 修订）

> **为什么改**：旧方案让客户端自报 `x-device-id` header 充当身份，但 anon key 公开打包在 App 内，
> 任何人可伪造 header 读取 devices 表拿到任意 group_id，进而横向读取/写入任意组数据。
> 任何基于客户端自报字段的 RLS 都不可修补 —— 模型必须整体替换。

#### 新模型：Supabase 匿名登录（保留"零账户"产品体验）

```
设备首次启动
    └── auth.signInAnonymously()   ← 无感、无表单，用户不知道"登录"发生了
          └── 获得 auth.uid() 的 JWT（supabase_flutter 自动持有并刷新）

数据边界（全部服务端强制）：
├── devices.auth_uid 唯一绑定匿名身份（一身份 = 一设备行 = 一个组）
├── RLS 一律以 auth.uid() / current_group_id()（security definer）判权
├── 建组/入组只能走 RPC：create_group / join_group（security definer）
│   └── 邀请码校验、4 人上限、字段校验全部在服务端
└── anon（未认证）角色对业务表零权限；RPC 仅授予 authenticated
```

#### 威胁对照表

| 威胁 | 旧方案（x-device-id） | 新方案（匿名登录） |
|------|----------------------|-------------------|
| 伪造他人身份读任意组 | ❌ 可行（致命） | ✅ 不可能：无 JWT 零权限；有 JWT 只能代表自己 |
| 不凭邀请码进组 | ❌ 可经 devices 表横向读 | ✅ 仅 RPC 校验邀请码 |
| 穷举邀请码 | — | 空间 31^8 ≈ 8.5×10^11；V1.1 在 RPC 层加尝试频控 |
| 无限建组垃圾数据 | ❌ groups_insert 全开 | ✅ 仅 RPC，且每身份最多属一组（auth_uid 唯一） |
| 会话丢失（重装/清数据） | — | refresh token 本地持久化，常规重启/升级不丢；若真丢失则以新身份凭邀请码重新入组（占新名额） |

#### 已知限制（V1.1 评估项）

```
├── 匿名身份无法跨设备迁移（如换手机）—— V1.1 可评估"恢复码/身份链接"
├── 重装后旧 devices 行成为"幽灵成员"占名额 —— V1.1 按 last_active_at 做清理
└── 邀请码穷举频控待加（RPC 层限流）
```

---

## Part 9. 离线与同步策略

### 9.1 同步队列数据结构（Isar Schema）

```dart
@collection
class SyncItem {
  late String id;              // UUID
  required String action;      // 'create' | 'update' | 'delete' | 'mark_completed'
  required String entityType;  // 'wish' | 'moment' | 'device'
  required String entityId;
  required Map<String, dynamic> payload;
  required DateTime createdAt;
  int retryCount = 0;
  DateTime? lastAttempt;
}
```

### 9.2 冲突解决矩阵

| 场景 | 策略 | 原因 |
|------|------|------|
| 两人同时编辑愿望标题 | Server-wins（时间戳新者覆盖） | 单值无合并空间 |
| 两人同时标记完成 | 取**最早** completed_at | 本质都是完成，保留最早的达成时刻 |
| 两人同时写纪念文字 | 都保留为数组 | 不丢内容 |
| 一人编辑 + 一人删除 | **删除优先**（保守） | 用户主动删除意图强 |
| 照片同时上传 | 各自独立保留 | 独立资源 |

### 9.3 离线场景覆盖

```
场景 1：完全离线（飞机/地下室）
├── ✅ 所有愿望/记录可读（Isar 本地）
├── ✅ 创建新愿望 → 本地写入 + 进队列
├── ✅ 拍照 + 写文字 → 暂存本地 + 进上传队列
├── ✅ 标记完成 → 本地更新 + 进队列
├── ✅ 状态流转正常
└── ❌ 收不到他人变更（网络恢复后自动拉）

场景 2：弱网（电梯/地铁）
├── ✅ 操作即时（乐观更新）
├── ⏳ 上传排队（指数退避，最多 5 次）
├── 📊 进度 UI 正常显示
└── ❌ 实时推送延迟（恢复后批量拉）

场景 3：正常网络
├── ✅ 实时双向同步
├── ✅ 照片并行上传（每个独立队列）
└── ✅ 冲突自动解决

场景 4：OPPO Find X9 Pro 后台被杀
├── ⚠️ 由于 ColorOS 后台策略，可能发生
├── 对策：
│   ├── WorkManager + 前台常驻通知（"📤 上传中"）
│   ├── Isar sync queue 持久化 → 进程重启后自动恢复
│   └── 首次启动时提示关闭 ColorOS 后台限制
└── 用户可接受：重新打开 App 后自动续传
```

### 9.4 图片压缩管线

```
拍摄/选择 → 客户端压缩 → 本地暂存 → 上传队列 → Supabase Storage

压缩参数（两端统一）：
├── 最长边：1920px（移动设备展示足够）
├── 格式：JPEG
├── Quality：80%（画质与体积平衡）
├── 单张上限：≤ 3MB
└── 使用 Flutter image 库（Dart 原生，快速）

上传策略：
├── WiFi 下立即并行上传
├── 移动网络 → 提示用户（省流量开关可绕过）
├── 失败自动重试（指数退避：5s → 10s → 20s → 40s → 80s）
└── OPPO 后台被杀 → WorkManager 续传

Supabase Storage：
├── bucket: 'moments-images'（私有，认证读写）
├── 生成 CDN URL（全球加速）
├── 可选：自动生成缩略图变体（w=400 / w=800）
└── 照片 URL 带签名（防止外链）
```

---

## Part 10. 无障碍（Accessibility）

### 10.1 双端通用 Checklist

```
✅ 所有 touch target ≥ 44pt（iOS）/ 48dp（Android）
✅ 所有图片/图标有语义标签（accessibilityLabel / contentDescription）
✅ 颜色对比度 ≥ 4.5:1（正文）/ 3:1（大文字）—— 使用系统语义色自动达标
✅ 不依赖颜色传达信息（已完成状态同时有 ✓ 图标 + 删除线 + 灰色）
✅ 动画可关闭（iOS Reduce Motion / Android Motion 关闭）
✅ 支持 Switch Control / 分屏 / 小窗
```

### 10.2 iPhone 17 Pro / iOS 18

```
VoiceOver 必需：
├── 每个 Interactive Element 必须有：
│   ├── accessibilityLabel（"周末去吃日料"）
│   ├── accessibilityHint（可选："点击标记为完成"）
│   ├── accessibilityTraits（button / selected / disabled）
│   └── accessibilityValue（复选框："未选中" / "已选中"）
└── Flutter: Semantics widget 精确声明

Dynamic Type：
├── 使用系统语义样式，不硬编码 size
├── 支持所有尺寸到 Accessibility 53pt
└── 测试：iOS 设置 → 辅助功能 → 字体，拉到最大后卡片不溢出

Reduce Motion：
├── AccessibilityInfo.isReduceMotionEnabled()
├── 禁用不必要的动画（保留核心过渡）
└── 禁用 PageView / Sheet 关闭动画，改为 instant transition
```

### 10.3 OPPO Find X9 Pro / ColorOS 16

```
TalkBack 等同于 iOS VoiceOver：
├── contentDescription（对应 accessibilityLabel）
├── Semantics.role / state 必须声明
└── 点击区域 ≥ 48dp（MUST）

ColorOS 辅助功能：
├── 跟随系统无障碍设置（朗读、放大、色彩滤镜）
├── 高对比度模式兼容（Material 3 自动支持）
└── 系统字体缩放测试到 200%（ColorOS 可拉很大）

Flutter 关键：
├── 必须把每个交互组件包在 Semantics 中
├── 列表项不能把整个 Row 设为一个大语义节点 → 子节点独立
└── 用 android:contentDescription 暴露 TalkBack
```

---

## Part 11. 平台差异对照表（iOS 18 vs ColorOS 16）

> **开发时必查**。每一项都要显式处理。

| 模块 | iPhone 17 Pro / iOS 18 | OPPO Find X9 Pro / ColorOS 16 | Flutter 处理 |
|------|----------------------|------------------------------|-------------|
| **底部导航** | CupertinoTabBar，49pt，毛玻璃 | Material 3 NavigationBar，80dp，Dynamic Color | Platform.isIOS 分支 |
| **App 栏** | CupertinoNavigationBar，44pt | Material 3 TopAppBar Medium → Small | 同上 |
| **返回手势** | 左边缘（系统自动） | 系统三选一（边缘/三键/全面屏） | WillPopScope + 系统自动 |
| **Sheet** | iOS 15+ Sheet detents | ModalBottomSheet 28dp 圆角 | showModalBottomSheet 平台适配 |
| **Dialog** | CupertinoAlertDialog | Material 3 AlertDialog | 同上 |
| **按钮** | CupertinoButton（Tinted） | Material 3 FilledButton（20dp 圆角） | 分支 |
| **复选框图标** | SF Symbols circle / checkmark.circle.fill | Material Icons radio_button_unchecked / check_circle | Icons 分库 |
| **列表样式** | InsetGrouped | Filled Card | 样式分支 |
| **日期选择** | CupertinoDatePicker | Material DatePicker | 分支 |
| **颜色主题** | 系统语义色 + Dark Mode 自动 | Material You Dynamic Color + fallback | 判断 isDynamicColorAvailable |
| **字体** | SF Pro（系统） | Roboto（系统） | 用系统默认 |
| **图标库** | cupertino_icons | material_symbols_icons | 两个依赖都加 |
| **下拉刷新** | UIRefreshControl | SwipeRefreshIndicator | flutter_refresh_indicator |
| **触觉反馈** | 3 种类型 + 模式 | 4 种类型 | platform_haptics 抽象层 |
| **安全区** | SafeArea（动态岛 59pt + Home Indicator 34pt） | SafeArea（挖孔 36dp + 手势条 24dp） | MediaQuery.padding 统一 |
| **后台任务** | backgroundTasks | WorkManager | flutter_workmanager |
| **推送** | APNs（需 .p8 证书） | FCM + OPPO Push（国内） | firebase_messaging |
| **Widget** | StandBy + 锁屏（iOS WidgetKit） | 桌面小组件（ColorOS） | 两个原生桥接 |
| **Always-On Widget** | ✅ 额外做（Bonus） | ❌ 不做 | — |
| **屏幕尺寸** | 390 × 844 pt | 393 × 872 dp | LayoutBuilder + MediaQuery |
| **触控采样** | ~120Hz | **300Hz**（Find X9 Pro 亮点） | 动画响应 < 50ms |
| **指纹位置** | — | 屏幕中下部（避让 FAB） | FAB 放更靠右下 |
| **后台激进度** | 温和 | 较激进 | WorkManager + 前台通知 |
| **曲面屏边缘** | — | Find X9 Pro 是直面屏 | 无需处理 |
| **电池** | 中等（一天） | 7500mAh（两天） | 后台上传可激进 |

---

## Part 12. 性能预算与检查点

### 12.1 性能指标（必须达成）

| 指标 | 目标 | 测量方法 |
|------|------|---------|
| 冷启动 | iPhone < 2.0s / OPPO < 2.5s | 原生启动时间 |
| 热启动 | iPhone < 1.0s / OPPO < 1.2s | 同上 |
| 列表滚动 FPS | ≥ 60（两设备），理想 120 | Flutter DevTools Performance |
| 内存 | ≤ 200MB（有图片瀑布流时） | DevTools Memory view |
| 缩略图加载 | ≤ 200ms | 端到端测量 |
| Supabase 请求 P95 | ≤ 1s | Supabase Dashboard |
| 离线本地写 | ≤ 10ms | Isar benchmark |
| FAB 点击 → 反馈 | **≤ 50ms**（OPPO 300Hz 触控要求） | instrumentation test |
| 包体积 | iOS ≤ 40MB / Android ≤ 50MB | App Store / Play Store 统计 |
| OTA 更新 | 支持 CodePush / Shorebird（可选） | Shorebird |

### 12.2 Anti-Pattern 禁止清单

```
❌ 禁止 Column + 手写滚动手写列表 → 必须 ListView.builder / Sliver
❌ 禁止 index 作为 List key → 必须 item.id
❌ 禁止内联 renderItem → 必须 const widget + useCallback
❌ 禁止 setState 在 build 中触发 → 必须状态上提
❌ 禁止 Image.network 无缓存 → 必须 cached_network_image
❌ 禁止生产 console.log → 必须统一 logger + release 自动 strip
❌ 禁止全屏图片上传 → 必须客户端压缩到 max 1920px
❌ 禁止 Supabase Realtime 订阅全表 → 按 group_id 精准订阅
❌ 禁止 AnimatedBuilder 在非 const widget 上 → 必须 const
❌ 禁止 Opacity 0 隐藏 widget → 必须 Visibility（Opacity 0 仍占用渲染）
```

### 12.3 Flutter 强制优化模式

```dart
// 1. 强制 const Widget（编译器优化）
const WishCard({required this.item, super.key}) : super();

// 2. 列表固定高度 → 跳过布局计算
ListView.builder(
  itemExtent: 80,  // ← 关键！
  itemBuilder: ...,
);

// 3. RepaintBoundary 隔离重绘
RepaintBoundary(child: const WishCard(...))

// 4. Tab 切换保持状态
class _WishListState extends State<WishList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
}

// 5. 图片缓存配置
CachedNetworkImage(
  memCacheWidth: 400,       // 内存缓存宽度
  maxWidthDiskCache: 800,   // 磁盘上限
  imageBuilder: ...,
);

// 6. 避免过度 build
Widget build(BuildContext context) {
  return Consumer<WishNotifier>(
    builder: (context, notifier, child) {
      // 只重建真正变化的部分
    },
  );
}
```

---

## Part 13. 里程碑与交付物

### Phase 0：脚手架（1 周）

| 天 | 任务 | 交付物 |
|----|------|--------|
| D1 | Flutter 3.x 项目初始化 | `pubspec.yaml` + 目录结构 |
| D1 | 包名确定 | iOS: com.wishes.shared / Android: com.wishes.shared |
| D2 | Supabase 项目创建 | 数据库 + 存储桶 + RLS 策略 |
| D3 | Isar 本地 DB 搭建 | Schema + Repository 接口 |
| D3 | Riverpod 架构搭好 | BaseAsyncNotifier + 状态骨架 |
| D4 | 主题 & Design Tokens 实现 | `app_theme.dart` + token 常量 |
| D4 | 双平台路由搭建 | CupertinoTabScaffold + Material Scaffold 分支 |
| D5 | CI/CD + Fastlane | GitHub Actions + iOS/Android 自动化 |
| D6 | 真机调试工具就绪 | iPhone 接 Mac + OPPO USB + flutter run 双设备 |
| D7 | **里程碑 Demo** | 两个设备同时跑空壳 App + Tab 切换 + 大标题 |

### Phase 1：MVP 核心（2 周）

- [ ] 首次引导 + 组创建/加入（邀请码生成 + 分享）
- [ ] 愿望清单 CRUD（Isar 本地 + Supabase 实时）
- [ ] **已完成标记**（点击 ☑ → 视觉变化 + haptic + 乐观更新）
- [ ] 已完成纪念文字（长按 → 写一句话）
- [ ] "谁标记的完成" badge + 实时推送
- [ ] 筛选器（全部/进行中/已完成）
- [ ] FAB 双端适配（OPPO 避开超声波指纹区域）
- [ ] 基础触觉反馈（platform_haptics 抽象层）
- [ ] 离线读写 + Sync Queue 持久化
- [ ] 冲突解决（Last-write-wins + 数组合并）
- [ ] Widget（iPhone StandBy + 锁屏）—— 可选先做

### Phase 2：日常记录（1.5 周）

- [ ] 系统相机 / 相册调用（image_picker 插件）
- [ ] 客户端图片压缩管线（image 库）
- [ ] Supabase Storage 上传 + 队列
- [ ] 瀑布流展示（StaggeredGridView.builder）
- [ ] 上传进度 UI（顶部横幅 + 常驻通知）
- [ ] OPPO WorkManager 保活
- [ ] 后台任务前台常驻通知
- [ ] 照片详情全屏查看

### Phase 3：打磨（1.5 周）

- [ ] 深色模式完整测试（双端切换 + 系统跟随）
- [ ] 双端触觉反馈精细映射（对照 Part 7）
- [ ] 空状态 + 错误状态 + 加载状态全覆盖
- [ ] iPhone Dynamic Island Live Activity（可选）
- [ ] 无障碍测试（VoiceOver / TalkBack / 字体放大 200% / Reduce Motion）
- [ ] 弱网模拟测试（Network Link Conditioner / 开发者选项）
- [ ] 性能 profile（DevTools + 真机 FPS 记录）
- [ ] OPPO ColorOS 后台限制引导弹窗
- [ ] Widget 最终版

### Phase 4：上架（1 周）

- [ ] Sentry / Firebase Crashlytics 接入
- [ ] App Store Connect 审核准备（截图 + 隐私说明 + 年龄分级）
- [ ] 中国大陆 Android 商店备案（如果要上小米/OPPO 应用市场）
- [ ] Google Play 上架（可跳过，如果只在国内）
- [ ] 真机双机回归测试
- [ ] 发布 + 验证 + 第一轮 Crash 告警处理

---

## Appendix A. 额外想法（Bonus Ideas）

> 不在 MVP 范围，但值得评估的增强：

### A1. iPhone 专属

```
├── Dynamic Island Live Activity
│   → 正在同步时显示小图标 + "同步中..."
│   → 愿望首次标记完成时，动态岛弹出 ✓ 动画
├── StandBy Widget
│   → 夜间充电时显示："我们今天完成了 2 个愿望 🎉"
├── App Intents + Shortcuts
│   → "标记下一个愿望完成" 快捷指令
│   → "打开日常记录" 快捷指令
├── ProMotion 120Hz 专门优化
│   → 所有动画 duration 用 16.67ms（60Hz）或 8.33ms（120Hz）单位
└── 相机 Center Stage（iPhone 17 Pro 新特性）
    → 不影响，但日常记录拍照时系统自动跟随人脸
```

### A2. OPPO Find X9 Pro 专属

```
├── 300Hz 触控采样利用
│   → 所有点击反馈 < 50ms（我们已有此要求）
├── ColorOS 16 桌面 Widget
│   → 2×2 显示今日进度 + "+" 快捷入口
├── 屏幕共享 / 跨屏协作
│   → ColorOS 支持跨设备共享 App 画面（V2 考虑）
├── 息屏截图快启
│   → 锁屏长按音量键拍照 → 直接存到我们的日常（需要权限）
└── SuperVOOC 80W 快充实利用
    → 充电时自动触发后台同步（充电 = 电量充足 + WiFi 在线）
```

### A3. 双端共通

```
├── "纪念日"概念
│   → 设置恋爱/结婚/纪念日 → 在愿望卡片上显示倒计时
├── 愿望完成时间线
│   → "一年中的这一天我们..." 回忆回顾
├── Emoji 评论 / Reaction
│   → 看到对方的日常，可以点 ❤️ 👍 🎉 等快速反应
├── 生日提醒
│   → 设置双方生日 → 提前 7 天推送 + 自动生成"生日愿望"模板
├── 愿望 AI 分类
│   → 自动识别内容归类（需要后端 + 成本评估）
├── Shorebird OTA
│   → 热更新，不用等 App Store 审核就能修 bug
└── 本地通知（Daily Reminder）
    → 每天固定时间推送："今天一起看看愿望清单吧 💌"
```

---

## Appendix B. MFRI 评估

```
┌─────────────────────────────────────────────────────────┐
│          Mobile Feasibility Risk Index                  │
├─────────────────────────────────────────────────────────┤
│ Platform Clarity     +5   双设备精确规格已锁定           │
│ Accessibility Read   +4   有明确规范 + 测试点            │
│ Interaction Complex  -1   照片/日期交互中等               │
│ Performance Risk     -2   图片瀑布流 + 120Hz 滚动        │
│ Offline Dependence   -1   核心功能必须离线可用            │
├─────────────────────────────────────────────────────────┤
│ **总分 = +5**                                           │
│ Interpretation: SAFE → 正常推进                          │
└─────────────────────────────────────────────────────────┘

关键风险缓释：
├── 图片瀑布流性能 → cached_network_image + const widget + itemExtent
├── 120Hz 流畅 → 固定高度列表 + RepaintBoundary + 避免 build 循环
├── OPPO 后台杀进程 → WorkManager + 前台通知 + Isar queue 持久化
└── 冲突解决 → Last-write-wins + 数组合并 + 用户可手动查看冲突历史
```

---

## ✅ 设计文档完成检查

```
🧠 MOBILE CHECKPOINT

Platform:     iPhone 17 Pro (iOS 18) + OPPO Find X9 Pro (ColorOS 16)
Framework:    Flutter 3.x
Files Read:   mobile-design 全套（design-thinking, touch-psychology, 
              mobile-backend, platform-ios, platform-android）

3 Principles I Will Apply:
1. 拇指可达区放主要操作 —— FAB、复选框、提交按钮全在底部（注意 OPPO 超声波指纹位置）
2. 乐观更新 + 离线优先 —— 任何网络状况下核心功能可用（Isar 本地 + Sync Queue 持久化）
3. 平台尊重 —— iOS 用 Cupertino 组件/手势/SF Symbols，Android 用 Material 3/Dynamic Color/Material Symbols/ColorOS 三键返回全兼容

Anti-Patterns I Will Avoid:
1. 禁止 Column + 手写滚动 → 必须 ListView.builder + itemExtent
2. 禁止 index 作为 key → 必须 item.id
3. 禁止生产 console.log → 必须统一 logger + release strip
4. 禁止忽略 OPPO 后台管理 → WorkManager + 前台通知
5. 禁止忽略 ColorOS 返回三选一 → WillPopScope 正确处理所有路径
6. 禁止忽略 iPhone Dynamic Island → SafeArea 正确配置
```

---

> **文档结语**：
> 这份文档是**单一事实来源（Single Source of Truth）**。开发过程中所有设计决策、组件选择、平台适配都以此为基线。发现不一致时，先更新文档，再改代码。
>
> 下一步：确认文档 → 初始化 Flutter 项目 + Supabase。准备好了吗？
