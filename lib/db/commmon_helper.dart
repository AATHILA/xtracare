import 'package:pill_reminder/db/sql_helper.dart';

class CommonHelper {
  static Future<List<Map<String, dynamic>>> getDatatoSync(
      String tableName, String syncType) async {
    final db = await SQLHelper.db();
    return await db
        .query(tableName, where: 'sync_status=?', whereArgs: [syncType]);
  }

  static Future<int> updateSyncStatus(String tableName, String whereQ,
      List<Object?> whereArgm, String syncStatus) async {
    final db = await SQLHelper.db();
    Map<String, Object?> mp = {'sync_status': syncStatus};
    return await db.update(tableName, mp, where: whereQ, whereArgs: whereArgm);
  }
}
