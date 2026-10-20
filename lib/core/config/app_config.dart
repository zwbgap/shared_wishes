/// 运行时配置。
///
/// 敏感配置不写入代码库，通过 `--dart-define` 注入：
/// ```
/// flutter run \
///   --dart-define=SUPABASE_URL=https://xxx.supabase.co \
///   --dart-define=SUPABASE_ANON_KEY=eyJhbGci...
/// ```
abstract final class AppConfig {
  static const String supabaseUrl =
      String.fromEnvironment('SUPABASE_URL');

  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  /// 是否已完成 Supabase 配置（未配置时以纯离线模式启动，便于骨架联调）。
  static bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// 构建模式
  static const bool isRelease = bool.fromEnvironment('dart.vm.product');
}
