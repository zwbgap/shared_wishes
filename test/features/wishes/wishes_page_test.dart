// 愿望页 widget 测试：fake WishRepository，覆盖渲染 / 勾选完成 /
// 新建 / 筛选 / 滑动删除。
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared_wishes/core/constants/app_constants.dart';
import 'package:shared_wishes/core/storage/prefs_provider.dart';
import 'package:shared_wishes/core/theme/app_theme.dart';
import 'package:shared_wishes/data/repositories/wish_repository.dart';
import 'package:shared_wishes/features/wishes/domain/wish.dart';
import 'package:shared_wishes/features/wishes/presentation/wishes_page.dart';

import '../../helpers/fakes.dart';

Wish _wish({
  required String remoteId,
  required String title,
  String? createdBy,
  WishStatus status = WishStatus.pending,
  String? category,
  DateTime? targetDate,
  String? completedBy,
  DateTime? completedAt,
}) {
  final DateTime now = DateTime(2026, 1, 1);
  return Wish(
    remoteId: remoteId,
    groupId: 'g1',
    title: title,
    status: status,
    createdAt: now,
    updatedAt: now,
    completionNotes: const <String>[],
    version: 1,
    createdByDeviceId: createdBy,
    category: category,
    targetDate: targetDate,
    completedByDeviceId: completedBy,
    completedAt: completedAt,
  );
}

Future<FakeWishRepository> _pumpPage(
  WidgetTester tester, {
  List<Wish>? seed,
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    StorageKeys.onboardingDone: true,
    StorageKeys.groupId: 'g1',
    StorageKeys.inviteCode: 'ABCD2345',
    StorageKeys.deviceId: 'dev-1',
    StorageKeys.deviceNickname: '小明',
    StorageKeys.deviceAvatarEmoji: '🐱',
  });
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final FakeWishRepository repository = FakeWishRepository(seed);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        wishRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        theme: AppTheme.material(Brightness.light),
        home: const WishesPage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return repository;
}

void main() {
  testWidgets('渲染愿望卡片与归属标签', (WidgetTester tester) async {
    await _pumpPage(
      tester,
      seed: <Wish>[
        _wish(
          remoteId: 'w1',
          title: '周末去吃日料',
          createdBy: 'dev-1',
          category: 'food',
          targetDate: DateTime(2026, 12, 25),
        ),
        _wish(remoteId: 'w2', title: '一起去看极光', createdBy: 'dev-2'),
        _wish(
          remoteId: 'w3',
          title: '学会提拉米苏',
          createdBy: 'dev-2',
          status: WishStatus.completed,
          completedBy: 'dev-2',
          completedAt: DateTime(2026, 10, 1),
        ),
      ],
    );

    expect(find.text('周末去吃日料'), findsOneWidget);
    expect(find.text('一起去看极光'), findsOneWidget);
    expect(find.text('学会提拉米苏'), findsOneWidget);
    // 自己创建的显示昵称 + emoji；他人的显示"小伙伴"
    expect(find.text('来自 🐱 小明'), findsOneWidget);
    expect(find.text('来自 小伙伴'), findsOneWidget);
    expect(find.textContaining('小伙伴完成'), findsOneWidget);
    // 分类与目标日期
    expect(find.text('🍣 美食'), findsOneWidget);
    expect(find.text('📅 12月25日'), findsOneWidget);
  });

  testWidgets('勾选复选框标记完成', (WidgetTester tester) async {
    await _pumpPage(
      tester,
      seed: <Wish>[
        _wish(remoteId: 'w1', title: '周末去吃日料', createdBy: 'dev-1'),
      ],
    );

    await tester.tap(find.byIcon(Icons.radio_button_unchecked));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.textContaining('小明完成'), findsOneWidget);
  });

  testWidgets('FAB 新建愿望', (WidgetTester tester) async {
    final FakeWishRepository repository = await _pumpPage(tester);
    expect(find.text('还没有愿望'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('新愿望'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, '去看樱花');
    await tester.tap(find.text('创建'));
    await tester.pumpAndSettle();

    expect(find.text('去看樱花'), findsOneWidget);
    expect(repository.wishes.single.title, '去看樱花');
    expect(repository.wishes.single.createdByDeviceId, 'dev-1');
  });

  testWidgets('筛选「已完成」只显示已完成愿望', (WidgetTester tester) async {
    await _pumpPage(
      tester,
      seed: <Wish>[
        _wish(remoteId: 'w1', title: '未完成的愿望', createdBy: 'dev-1'),
        _wish(
          remoteId: 'w2',
          title: '已完成的愿望',
          createdBy: 'dev-1',
          status: WishStatus.completed,
          completedBy: 'dev-1',
          completedAt: DateTime(2026, 10, 1),
        ),
      ],
    );

    await tester.tap(find.text('已完成'));
    await tester.pumpAndSettle();

    expect(find.text('已完成的愿望'), findsOneWidget);
    expect(find.text('未完成的愿望'), findsNothing);
  });

  testWidgets('滑动删除：确认后愿望消失', (WidgetTester tester) async {
    final FakeWishRepository repository = await _pumpPage(
      tester,
      seed: <Wish>[
        _wish(remoteId: 'w1', title: '要被删除的愿望', createdBy: 'dev-1'),
      ],
    );

    await tester.drag(find.text('要被删除的愿望'), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('删除愿望'), findsOneWidget);

    await tester.tap(find.text('删除'));
    await tester.pumpAndSettle();

    expect(find.text('要被删除的愿望'), findsNothing);
    expect(repository.wishes, isEmpty);
    expect(find.text('还没有愿望'), findsOneWidget);
  });
}
