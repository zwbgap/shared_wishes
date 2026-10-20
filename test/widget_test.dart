// 根容器冒烟测试：验证应用可启动、入口分流正确。
//
// 测试运行在宿主机（非 iOS），因此走 Material 3 分支。

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared_wishes/app.dart';
import 'package:shared_wishes/core/constants/app_constants.dart';
import 'package:shared_wishes/core/storage/prefs_provider.dart';
import 'package:shared_wishes/data/repositories/wish_repository.dart';

import 'helpers/fakes.dart';

void main() {
  testWidgets('未入组时启动进入首次引导（Welcome 页）', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const SharedWishesApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Welcome 引导页
    expect(find.text('一起记录愿望'), findsOneWidget);
    expect(find.text('开始'), findsOneWidget);
  });

  testWidgets('已入组时启动进入三 Tab 主界面', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      StorageKeys.onboardingDone: true,
      StorageKeys.groupId: 'test-group-id',
      StorageKeys.inviteCode: 'ABCD2345',
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          wishRepositoryProvider.overrideWithValue(FakeWishRepository()),
        ],
        child: const SharedWishesApp(),
      ),
    );
    await tester.pumpAndSettle();

    // 底部导航三个 Tab 标签
    expect(find.text('愿望'), findsWidgets);
    expect(find.text('日常'), findsOneWidget);
    expect(find.text('我们'), findsOneWidget);
  });
}
