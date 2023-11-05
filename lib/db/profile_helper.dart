import 'package:pill_reminder/db/sql_helper.dart';
import 'package:pill_reminder/model/profile.dart';

class ProfileHelper {
 
  static Future<int> createProfile(Profile profile) async {
    final db = await SQLHelper.db();
    return await db.insert('user', profile.toMap());
  }

    static Future<List<Map<String, dynamic>>> getProlfiles() async {
    final db = await SQLHelper.db();
    return db.query('profile', orderBy: "id");
  }
}