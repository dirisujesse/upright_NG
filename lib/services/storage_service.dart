import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as fs;
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class LocalStorage {
  static String _dbPath;
  static DatabaseFactory dbFactory = databaseFactoryIo;

  static Future<String> get _fsPath async {
    final basePath = await fs.getApplicationDocumentsDirectory();
    return basePath.path;
  }

  static Future<Database> get _db async {
    final String tmpPath = await _fsPath;
    LocalStorage._dbPath = join(tmpPath, "upright.db");
    Database db = await dbFactory.openDatabase(LocalStorage._dbPath);
    return db;
  }

  static Future<bool> removeItem(String key) async {
    final db = await _db;
    try {
      await db.delete(key);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<dynamic> getItem(String key) async {
    final db = await _db;
    final hasKey = await db.containsKey(key);
    if (hasKey) {
      try {
        final val = await db.get(key);
        return val;
      } catch (e) {
        print(e);
        return false;
      }
    }
    return false;
  }

  static Future<dynamic> setItem(String key, dynamic value) async {
    final db = await _db;
    try {
      final val = await db.put(value, key);
      return val;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
