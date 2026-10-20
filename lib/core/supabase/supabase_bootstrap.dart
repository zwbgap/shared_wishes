import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';

/// Supabase 启动引导。
///
/// 未注入 [AppConfig.supabaseUrl] / [AppConfig.supabaseAnonKey] 时**跳过初始化**，
/// 应用以纯离线模式运行 —— 便于本地骨架联调与 CI 构建。
abstract final class SupabaseBootstrap {
  static final Logger _log = Logger();

  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  static Future<void> init() async {
    if (_initialized) return;

    if (!AppConfig.hasSupabase) {
      _log.w(
        'Supabase 未配置（缺少 SUPABASE_URL / SUPABASE_ANON_KEY），'
        '以纯离线模式启动。',
      );
      return;
    }

    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      publishableKey: AppConfig.supabaseAnonKey,
      realtimeClientOptions: const RealtimeClientOptions(
        // 小团体场景：仅按组订阅，避免全表推送
        eventsPerSecond: 5,
      ),
    );
    _initialized = true;
    _log.i('Supabase 初始化完成');
  }

  /// 客户端（未初始化时抛错，调用方需先判断 [isInitialized]）。
  static SupabaseClient get client => Supabase.instance.client;
}
