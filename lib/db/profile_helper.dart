import 'package:pill_reminder/db/sql_helper.dart';
import 'package:pill_reminder/model/profile.dart';

class ProfileHelper {
 
  static Future<int> createUser(Profile profile) async {
    final db = await SQLHelper.db();
    return await db.insert('user', profile.toMap());
  }
}