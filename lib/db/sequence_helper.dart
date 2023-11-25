import 'package:pill_reminder/db/sql_helper.dart';
import 'package:pill_reminder/model/table_sequence.dart';

class SequenceHelper {
  static Future<int> createTableSequence(TableSequence tableSequence) async {
    final db = await SQLHelper.db();
    return await db.insert('table_sequence', tableSequence.toMap());
  }

  static Future<int> deleteTableSequence(String tableName, int userId) async {
    final db = await SQLHelper.db();
    return await db.delete('table_sequence',
        where: 'tableName=? and userId=?', whereArgs: [tableName, userId]);
  }

  static Future<String> getSequence(String tableName, int userId) async {
    final db = await SQLHelper.db();
    List<Map> rows = await db.rawQuery(
        'select currentValue from table_sequence where tableName=? and userId=? limit 1',
        [tableName, userId]);
    int currentValue = rows.first['currentValue'];
    await db.rawUpdate(
        'update table_sequence set currentValue=?,updatedOn=current_timestamp,sync_status="PU" where tableName=? and userId=?',
        [currentValue + 1, tableName, userId]);
    return '${userId}_$currentValue';
  }
}
