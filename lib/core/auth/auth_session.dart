import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import '../supabase/supabase_bootstrap.dart';

/// 会话状态（ sealed 以便 switch 穷尽）。
sealed class AuthSessionState {
  const AuthSessionState();
}

/// 离线模式：未配置 Supabase，应用所有数据仅存本地。
final class AuthOfflineMode extends AuthSessionState {
  const AuthOfflineMode();
}

/// 已配置 Supabase，正在进行匿名登录。
final class AuthSigningIn extends AuthSessionState {
  const AuthSigningIn();
}

/// 已登录（匿名身份），[userId] 即 `auth.uid()`。
final class AuthSignedIn extends AuthSessionState {
  const AuthSignedIn(this.userId);

  final String userId;
}

/// 登录失败（多为网络原因），可通过 [AuthSessionNotifier.retry] 重试。
final class AuthFailed extends AuthSessionState {
  const AuthFailed(this.message);

  final String message;
}

/// 匿名会话管理。
///
/// 对应设计文档 5.2「匿名身份获取（自动、无感）」：
/// 首次启动调用 `auth.signInAnonymously()`，会话由 supabase_flutter 自动持久化，
/// 后续冷启动直接从本地恢复 JWT。
///
/// 未配置 Supabase 时处于 [AuthOfflineMode]，建组/入组之外的本地功能不受影响。
class AuthSessionNotifier extends Notifier<AuthSessionState> {
  static final Logger _log = Logger();

  @override
  AuthSessionState build() {
    if (!AppConfig.hasSupabase || !SupabaseBootstrap.isInitialized) {
      return const AuthOfflineMode();
    }
    // 热重载 / 冷启动：优先复用已持久化的会话，避免重复匿名注册
    final Session? session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      return AuthSignedIn(session.user.id);
    }
    Future<void>.microtask(_signIn);
    return const AuthSigningIn();
  }

  /// 登录失败后手动重试（UI 重试按钮）。
  Future<void> retry() => _signIn();

  Future<void> _signIn() async {
    if (state is! AuthSigningIn) {
      state = const AuthSigningIn();
    }
    try {
      final GoTrueClient auth = Supabase.instance.client.auth;
      if (auth.currentSession == null) {
        await auth.signInAnonymously();
      }
      final User? user = auth.currentUser;
      if (user == null) {
        throw StateError('匿名登录成功但未取得用户对象');
      }
      _log.i('匿名登录完成：${user.id}');
      state = AuthSignedIn(user.id);
    } on AuthException catch (e) {
      _log.w('匿名登录失败：${e.message}');
      state = AuthFailed('登录失败：${e.message}');
    } catch (e) {
      _log.w('匿名登录失败', error: e);
      state = const AuthFailed('网络异常，请检查网络后重试');
    }
  }
}

/// 匿名会话 Provider。
final authSessionProvider =
    NotifierProvider<AuthSessionNotifier, AuthSessionState>(
  AuthSessionNotifier.new,
);

/// 当前匿名身份 `auth.uid()`（离线模式 / 未登录为 null）。
final authUserIdProvider = Provider<String?>(
  (ref) => switch (ref.watch(authSessionProvider)) {
    AuthSignedIn(:final String userId) => userId,
    _ => null,
  },
);
