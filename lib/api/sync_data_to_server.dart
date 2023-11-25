import 'package:pill_reminder/api/api_call.dart';
import 'package:pill_reminder/db/commmon_helper.dart';
import 'package:pill_reminder/db/sequence_helper.dart';
import 'package:pill_reminder/model/medicine.dart';
import 'package:pill_reminder/model/table_sequence.dart';

class SyncDataToServer {
  static syncDataToServer() async {
    await CommonHelper.getDatatoSync('table_sequence', 'PU').then((list) async {
      for (var row in list) {
        TableSequence tableSequence = TableSequence.fromMap(row);
        await ApiCall.updateSequence(tableSequence).then((value) async {
          if (value.statusCode == 200) {
            await CommonHelper.updateSyncStatus(
                'table_sequence',
                'userId=? and tableName=?',
                [tableSequence.userId, tableSequence.tableName],
                'DONE');
          }
        });
      }
    });

    await CommonHelper.getDatatoSync('medicine', 'PI').then((list) async {
      for (var row in list) {
        Medicine med = Medicine.fromMap(row);
        await ApiCall.createMedicine(med).then((value) async {
          if (value.statusCode == 201) {
            await CommonHelper.updateSyncStatus(
                'medicine', 'id=?', [med.id], 'DONE');
          }
        });
      }
    });
    await CommonHelper.getDatatoSync('medicine', 'PU').then((list) async {
      for (var row in list) {
        Medicine med = Medicine.fromMap(row);
        await ApiCall.updateMedicine(med).then((value) async {
          if (value.statusCode == 200) {
            await CommonHelper.updateSyncStatus(
                'medicine', 'id=?', [med.id], 'DONE');
          }
        });
      }
    });
  }
}
