import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../src/posts_tap/data/models/posts_model.dart';

class SqlService {
  static Database? _database;

  static SqlService? _instance;

  static Future<SqlService?> getInstance() async {
    _instance ??= SqlService();
    _database ??= await _initDB();
    return _instance;
  }

  static Future<Database> _initDB() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'database.db');
    return openDatabase(
      path,
      version: 9,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE database ('
            'id INTEGER PRIMARY KEY,'
            'postId TEXT,'
            'image TEXT,'
            'likes TEXT,'
            'tags TEXT,'
            'text TEXT,'
            'publishDate TEXT,'
            'owner TEXT'
            ')');
      },
    );
  }

  Future insertProduct({
    required String id,
    required String image,
    required String likes,
    required String tags,
    required String text,
    required String publishDate,
    required String owner,
  }) async {
    Map<String, dynamic> row = {
      "postId": id,
      "image": image,
      "likes": likes,
      "tags": tags,
      "text": text,
      "publishDate": publishDate,
      "owner": owner,
    };
    await _database?.insert('database', row);
  }

  Future deleteProduct(String postId) async {
    await _database
        ?.delete('database', where: 'postId = ?', whereArgs: [postId]);
  }

  Future<List<PostModel>> loadSavedProduct() async {
    final res = await _database?.query('database');
    List<PostModel> list = [];
    if (res!.isNotEmpty) {
      for (var element in res) {
        list.add(PostModel.fromDataBase(element));
      }
    } else {
      list = [];
    }
    return list;
  }

  Future<int>? clearDataBase() {
    return _database?.rawDelete('DELETE FROM database');
  }
}
