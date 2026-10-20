import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/storage/prefs_provider.dart';
import 'core/supabase/supabase_bootstrap.dart';
import 'data/local/local_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 本地 KV 与 Isar 先行（引导分流 / 离线数据都依赖）
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await LocalDatabase.open();

  // 未配置 Supabase 时以纯离线模式启动（本地骨架联调 / CI 构建）
  await SupabaseBootstrap.init();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const SharedWishesApp(),
    ),
  );
}
