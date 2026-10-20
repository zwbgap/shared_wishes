// 引导流 widget 测试：fake GroupRepository + fake MembershipStore，
// 走通 welcome → choose → create → profile → inviteCode → 主界面。
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared_wishes/app.dart';
import 'package:shared_wishes/core/storage/prefs_provider.dart';
import 'package:shared_wishes/data/repositories/group_repository.dart';
import 'package:shared_wishes/data/repositories/membership_store.dart';
import 'package:shared_wishes/data/repositories/wish_repository.dart';

import '../../helpers/fakes.dart';

void main() {
  testWidgets('建组全流程：Welcome → 邀请码 → 进入主界面', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final FakeMembershipStore membershipStore = FakeMembershipStore();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          groupRepositoryProvider.overrideWithValue(FakeGroupRepository()),
          membershipStoreProvider.overrideWithValue(membershipStore),
          wishRepositoryProvider.overrideWithValue(FakeWishRepository()),
        ],
        child: const SharedWishesApp(),
      ),
    );
    await tester.pumpAndSettle();

    // S0.1 Welcome
    expect(find.text('一起记录愿望'), findsOneWidget);
    await tester.tap(find.text('开始'));
    await tester.pumpAndSettle();

    // 分支选择
    expect(find.text('你们的小窝'), findsOneWidget);
    await tester.tap(find.text('创建新的小窝'));
    await tester.pumpAndSettle();

    // S0.2 组名
    expect(find.text('给小窝起个名字'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '我们的小窝');
    await tester.tap(find.text('下一步'));
    await tester.pumpAndSettle();

    // S0.4 昵称 + emoji
    expect(find.text('你是谁？'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '小明');
    await tester.pump();
    await tester.tap(find.text('创建小窝'));
    await tester.pumpAndSettle();

    // 建组成功：展示邀请码
    expect(find.text('小窝建好了'), findsOneWidget);
    expect(find.text('TEST2345'), findsOneWidget);
    expect(membershipStore.saveCount, 1);
    expect(membershipStore.currentGroupId, 'g1');

    // 进入主界面
    await tester.tap(find.text('进入小窝'));
    await tester.pumpAndSettle();
    expect(find.text('日常'), findsOneWidget);
    expect(find.text('我们'), findsOneWidget);
    expect(find.text('还没有愿望'), findsOneWidget);
  });
}
