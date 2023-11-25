import 'package:pill_reminder/db/sql_helper.dart';
import 'package:pill_reminder/model/sync_status_table.dart';

class SyncStatusTableHelper {
  static Future<int> createSyncStatus(SyncStatusTable syncStatusTable) async {
    final db = await SQLHelper.db();
    return await db.insert('sync_status_table', syncStatusTable.toMap());
  }

  static Future<int> updateSyncStatus(SyncStatusTable syncStatusTable) async {
    final db = await SQLHelper.db();
    return await db.update('sync_status_table', syncStatusTable.toMap(),
        where: 'tableName=?', whereArgs: [syncStatusTable.tableName]);
  }

  static Future<List<Map<String, dynamic>>> getSyncStatus(
      String tableName) async {
    final db = await SQLHelper.db();
    return await db.query('sync_status_table',
        where: 'tableName=?', whereArgs: [tableName]);
  }
}
