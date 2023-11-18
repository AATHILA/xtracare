import 'package:pill_reminder/db/sql_helper.dart';
import 'package:pill_reminder/model/notification_settings.dart';

class NotificationSettingsHelper {
  static Future<int> createNotitificationSettings(
      NotificationSettings notification) async {
    final db = await SQLHelper.db();
    return await db.insert('notification_settings', notification.toMap());
  }

  static Future<int> updateNotitificationSettings(
      NotificationSettings notification) async {
    final db = await SQLHelper.db();
    return await db.update('notification_settings', notification.toMap(),
        where: "id = ?", whereArgs: [notification.id]);
  }

  static Future<List<Map<String, dynamic>>> getNotificationByprofileid(
      int profileId) async {
    final db = await SQLHelper.db();
    return db.query('notification_settings',
        where: "profile_id = ? ",
        whereArgs: [profileId],
        orderBy: "id",
        limit: 1);
  }
}
