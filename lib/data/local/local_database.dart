import 'dart:io' show Platform;

import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'entities/device_entity.dart';
import 'entities/group_entity.dart';
import 'entities/moment_entity.dart';
import 'entities/sync_item_entity.dart';
import 'entities/wish_entity.dart';

/// Isar 本地数据库入口。
///
/// 所有实体的注册集中于此，Schema 变更后需重新运行：
/// ```
/// dart run build_runner build --delete-conflicting-outputs
/// ```
abstract final class LocalDatabase {
  static Isar? _instance;

  static Isar get instance {
    final Isar? isar = _instance;
    if (isar == null) {
      throw StateError('LocalDatabase 尚未初始化，请先 await LocalDatabase.open()');
    }
    return isar;
  }

  static bool get isOpen => _instance != null;

  static Future<Isar> open() async {
    if (_instance != null) return _instance!;

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String dbPath = Platform.isIOS
        ? '$dir/shared_wishes.isar'
        : '$dir/shared_wishes.db';

    _instance = await Isar.open(
      <CollectionSchema<dynamic>>[
        WishEntitySchema,
        MomentEntitySchema,
        DeviceEntitySchema,
        GroupEntitySchema,
        SyncItemEntitySchema,
      ],
      directory: dir,
      name: dbPath.split('/').last.replaceAll(RegExp(r'\.(isar|db)$'), ''),
      inspector: false,
    );
    return _instance!;
  }

  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
  }
}
