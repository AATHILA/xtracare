import 'dart:convert';

import 'package:pill_reminder/api/api_call.dart';
import 'package:pill_reminder/db/medicine_helper.dart';
import 'package:pill_reminder/db/sync_status_table_helper.dart';
import 'package:pill_reminder/model/medicine.dart';
import 'package:pill_reminder/model/sync_status_table.dart';

class SyncDataFromServer {
  static syncDataFromServer() async {
    await SyncStatusTableHelper.getSyncStatus('medicine')
        .then((syncTimeList) async {
      DateTime lastSync = DateTime.now().subtract(const Duration(days: 1000));
      if (syncTimeList.isNotEmpty) {
        lastSync = SyncStatusTable.fromMap(syncTimeList.first).lastSynced!;
      } else {
        SyncStatusTable syncStatusTable =
            SyncStatusTable(tableName: 'medicine', lastSynced: lastSync);
        await SyncStatusTableHelper.createSyncStatus(syncStatusTable);
      }

      await ApiCall.getMedicinesForSync(lastSync).then((list) async {
        Iterable l = json.decode(list.body);
        List<Medicine> medicines =
            List<Medicine>.from(l.map((model) => Medicine.fromJson(model)));
        for (Medicine med in medicines) {
          await MedicineHelper.deleteMedicine(med.id!);
          await MedicineHelper.createMedicine(med).then((id) async {
            SyncStatusTable syncStatusTable = SyncStatusTable(
                tableName: 'medicine',
                lastSynced: DateTime.parse(med.updatedOn!));
            await SyncStatusTableHelper.updateSyncStatus(syncStatusTable);
          });
        }
      });
    });
  }
}
