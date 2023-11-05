import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    Batch batch = database.batch();
    batch.execute("DROP TABLE IF EXISTS user");
    batch.execute("DROP TABLE IF EXISTS profile");
    batch.execute('''CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        firstName TEXT,
        lastName TEXT,
        dob TEXT,
        phonenumber TEXT,
        username TEXT,
        password TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      ''');
    batch.execute('''CREATE TABLE profile(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        age TEXT,
        relation TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      ''');

    List<dynamic> result = await batch.commit();
    print(result);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'pillremainder.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }
}
