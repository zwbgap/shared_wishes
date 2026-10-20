// 根容器冒烟测试：验证应用可启动、三 Tab 骨架可渲染。
//
// 测试运行在宿主机（非 iOS），因此走 Material 3 分支。

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_wishes/app.dart';

void main() {
  testWidgets('应用启动并渲染三 Tab 骨架', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: SharedWishesApp()),
    );
    await tester.pumpAndSettle();

    // 底部导航三个 Tab 标签
    expect(find.text('愿望'), findsWidgets);
    expect(find.text('日常'), findsOneWidget);
    expect(find.text('我们'), findsOneWidget);
  });
}
