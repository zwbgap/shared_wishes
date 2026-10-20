import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 全局 [SharedPreferences] 实例。
///
/// 在 `main()` 中以真实实例 override，在测试中以
/// `SharedPreferences.setMockInitialValues` 后的实例 override。
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider 尚未注入：请在 main / 测试中 override',
  );
});
