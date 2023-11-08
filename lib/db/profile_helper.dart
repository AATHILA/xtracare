import 'package:pill_reminder/db/sql_helper.dart';
import 'package:pill_reminder/model/profile.dart';

class ProfileHelper {
  static Future<int> createProfile(Profile profile) async {
    final db = await SQLHelper.db();
    return await db.insert('profile', profile.toMap());
  }

  static Future<int> updateProfile(Profile profile) async {
    final db = await SQLHelper.db();
    return await db.update('profile', profile.toMap(),
        where: "id = ?", whereArgs: [profile.id]);
  }

  static Future<List<Map<String, dynamic>>> getProfile(int userid) async {
    final db = await SQLHelper.db();
    return db.query('profile',
        where: "userid = ? ", whereArgs: [userid], orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getProfileById(int id) async {
    final db = await SQLHelper.db();
    return db.query('profile',
        where: "id = ? ", whereArgs: [id], orderBy: "id", limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getProfileActiveByRelation(
      int userid, String relation) async {
    final db = await SQLHelper.db();
    return db.query('profile',
        where: "userid = ? and relation=? ",
        whereArgs: [userid, relation],
        orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getProfiles() async {
    final db = await SQLHelper.db();
    return db.query('profile', orderBy: "id");
  }
}
