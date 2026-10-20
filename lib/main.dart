import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/supabase/supabase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 未配置 Supabase 时以纯离线模式启动（本地骨架联调 / CI 构建）
  await SupabaseBootstrap.init();

  runApp(const ProviderScope(child: SharedWishesApp()));
}
