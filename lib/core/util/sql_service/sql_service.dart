import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../src/home/data/models/Product_model.dart';

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
    final path = join(documentsDirectory.path, 'wteq.db');
    return openDatabase(
      path,
      version: 5,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE wteq ('
            'id INTEGER PRIMARY KEY,'
            'internalName TEXT,'
            'title TEXT,'
            'salePrice TEXT,'
            'normalPrice TEXT,'
            'steamRatingCount TEXT,'
            'thumb TEXT,'
            'isFav REAL,'
            'qty REAL'
            ')');
      },
    );
  }

  Future insertProduct({required ProductModel productModel}) async {
    await _database?.insert('wteq', productModel.toJson());
  }

  Future deleteProduct(String title) async {
    await _database?.delete('wteq', where: 'title = ?', whereArgs: [title]);
  }

  Future<List<ProductModel>> loadSavedProduct() async {
    final res = await _database?.query('wteq');
    final List<ProductModel> list =
        res!.isNotEmpty ? res.map(ProductModel.fromJson).toList() : [];
    return list;
  }

  Future<int>? clearWishList() {
    return _database?.rawDelete('DELETE FROM wteq');
  }
}
