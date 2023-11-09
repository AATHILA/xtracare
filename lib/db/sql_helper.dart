import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    Batch batch = database.batch();
    batch.execute("DROP TABLE IF EXISTS user");
    batch.execute("DROP TABLE IF EXISTS profile");
    batch.execute("DROP TABLE IF EXISTS timeslot");
    batch.execute("DROP TABLE IF EXISTS timeslot_times");
    batch.execute("DROP TABLE IF EXISTS medicine");
    batch.execute('''CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        firstName TEXT,
        lastName TEXT,
        dob TEXT,
        phonenumber TEXT,
        username TEXT,
        password TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updatedOn TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        sync_status TEXT DEFAULT 'PI'
      )
      ''');
    batch.execute('''CREATE TABLE profile(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        age TEXT,
        relation TEXT,
        userid TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
        updatedOn TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        sync_status TEXT DEFAULT 'PI'
      )
      ''');

    batch.execute('''CREATE TABLE timeslot(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        type TEXT,
        nooftimes TEXT,
        userid TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updatedOn TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        sync_status TEXT DEFAULT 'PI'
      )
      ''');
    batch.execute('''CREATE TABLE timeslot_times(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        time TEXT,
        timeslotid INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updatedOn TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        sync_status TEXT DEFAULT 'PI'
      )
      ''');

    batch.execute('''CREATE TABLE medicine(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
		    description TEXT,
        side_effects TEXT,
		    category TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updatedOn TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        sync_status TEXT DEFAULT 'PI'
      )
      ''');

    List<dynamic> result = await batch.commit();
    print(result);
  }

  static Future<sql.Database> db() {
    return sql.openDatabase(
      'pillremainder.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }
}
