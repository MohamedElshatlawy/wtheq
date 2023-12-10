import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../src/employee/data/models/employee_model.dart';

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
    final path = join(documentsDirectory.path, 'poc.db');
    return openDatabase(
      path,
      version: 5,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db
            .execute('CREATE TABLE poc ('
                'id INTEGER PRIMARY KEY,'
                'first_name TEXT,'
                'last_name TEXT,'
                'role TEXT,'
                'employee_id TEXT,'
                'isSaved REAL'
                ')')
            .then((value) => print('table created'))
            .catchError((error) {
          print('Error when creating table ${error.toString()}');
        });
      },
    );
  }

  Future insertEmployee({required Employee employeeModel}) async {
    await _database?.insert('poc', employeeModel.toJson());
  }

  Future deleteEmployee(String employeeId) async {
    await _database
        ?.delete('poc', where: 'employee_id = ?', whereArgs: [employeeId]);
  }

  Future<List<Employee>> loadSavedEmployee() async {
    final res = await _database?.query('poc');
    final List<Employee> list =
        res!.isNotEmpty ? res.map(Employee.fromJson).toList() : [];
    return list;
  }

  Future<int>? clearSavedEmployeeList() {
    return _database?.rawDelete('DELETE FROM poc');
  }
}
