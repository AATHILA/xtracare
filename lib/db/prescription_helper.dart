import 'package:pill_reminder/db/medicine_helper.dart';
import 'package:pill_reminder/db/sql_helper.dart';
import 'package:pill_reminder/model/medicine.dart';
import 'package:pill_reminder/model/prescription.dart';

class PrescriptionHelper {
  static Future<int> createPrescription(Prescription prescription) async {
    final db = await SQLHelper.db();
    return await db.insert('prescription', prescription.toMap());
  }

  static Future<int> updatePrescription(Prescription prescription) async {
    final db = await SQLHelper.db();
    return await db.update('prescription', prescription.toMap(),
        where: "id = ?", whereArgs: [prescription.id]);
  }

  static Future<List<Map<String, dynamic>>> getPrescriptionByprofileid(
      int profileId) async {
    final db = await SQLHelper.db();
    return db.query('prescription',
        where: "profile_id = ? ", whereArgs: [profileId], orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getTimeSlotById(int id) async {
    final db = await SQLHelper.db();
    return db.query('timeslot',
        where: "id = ? ", whereArgs: [id], orderBy: "id", limit: 1);
  }

  static Future<List<Prescription>> queryAll(int profileId) async {
    List<Prescription> list = [];
    await getPrescriptionByprofileid(profileId).then((value) async {
      for (int i = 0; i < value.length; i++) {
        Prescription tt = Prescription.fromMap(value[i]);
        List<Medication> medications = [];
        int tempid = tt.id ?? 0;
        await MedicationHelper.getMedicationByPrescritionId(tempid)
            .then((value1) async {
          for (var med in value1) {
            Medication ttt = Medication.fromMap(med);

            await MedicineHelper.getMedicineById(ttt.medicine_id!)
                .then((medic) {
              for (var it in medic) {
                ttt.medicine = Medicine.fromMap(it);
              }
            });

            medications.add(ttt);
          }
          tt.medications = medications;
        });

        list.add(tt);
      }
    });

    return list;
  }
}

class MedicationHelper {
  static Future<int> createMedication(Medication medication) async {
    final db = await SQLHelper.db();
    return await db.insert('medication', medication.toMap());
  }

  static Future<int> updateMedication(Medication medication) async {
    final db = await SQLHelper.db();
    return await db.update('medication', medication.toMap(),
        where: "id = ?", whereArgs: [medication.id]);
  }

  static Future<List<Map<String, dynamic>>> getMedicationByPrescritionId(
      int prescriptionId) async {
    final db = await SQLHelper.db();
    return db.query('medication',
        where: "prescription_id = ? ",
        whereArgs: [prescriptionId],
        orderBy: "id");
  }
}
