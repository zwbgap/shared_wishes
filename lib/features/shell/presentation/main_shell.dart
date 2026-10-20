import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/haptics/platform_haptics.dart';
import '../../../core/platform/platform_info.dart';
import '../../group/presentation/group_page.dart';
import '../../moments/presentation/moments_page.dart';
import '../../wishes/presentation/wishes_page.dart';

/// 根容器：三 Tab 骨架。
///
/// - iPhone 17 Pro：`CupertinoTabScaffold`（HIG 底部标签栏 + 毛玻璃）
/// - OPPO Find X9 Pro：`NavigationBar`（Material 3 + Material You）
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final PlatformHaptics _haptics = PlatformHaptics.forCurrentPlatform();
  final CupertinoTabController _tabController = CupertinoTabController();
  int _index = 0;

  static const List<Widget> _pages = <Widget>[
    WishesPage(),
    MomentsPage(),
    GroupPage(),
  ];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _switchTo(int index) {
    if (index == _index) return;
    _haptics.trigger(HapticEvent.tabSwitch);
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    return AppPlatform.isIOS ? _buildCupertino() : _buildMaterial();
  }

  Widget _buildCupertino() {
    return CupertinoTabScaffold(
      controller: _tabController,
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart),
            label: '愿望',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.photo_on_rectangle),
            label: '日常',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2),
            label: '我们',
          ),
        ],
        onTap: (int index) => _haptics.trigger(HapticEvent.tabSwitch),
      ),
      tabBuilder: (BuildContext context, int index) => CupertinoTabView(
        builder: (BuildContext context) => _pages[index],
      ),
    );
  }

  Widget _buildMaterial() {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _switchTo,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: '愿望',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library),
            label: '日常',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: '我们',
          ),
        ],
      ),
    );
  }
}
