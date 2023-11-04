import 'package:flutter/foundation.dart';
import 'package:pill_reminder/db/sql_helper.dart';
import 'package:pill_reminder/model/user.dart';

class UserHelper {
  // Create new item (journal)

  static Future<int> createUser(User user) async {
    final db = await SQLHelper.db();
    return await db.insert('user', user.toMap());
  }

  static Future<List<Map<String, dynamic>>> checkUser(
      String username, String password) async {
    final db = await SQLHelper.db();
    return db.query('user',
        where: "username = ? and password = ? ",
        whereArgs: [username, password],
        limit: 1);
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await SQLHelper.db();
    return db.query('user', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getUser(String username) async {
    final db = await SQLHelper.db();
    return db.query('user',
        where: "username = ?", whereArgs: [username], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(User user) async {
    final db = await SQLHelper.db();

    final result = await db
        .update('user', user.toMap(), where: "id = ?", whereArgs: [user.id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("user", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
