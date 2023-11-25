import 'package:pill_reminder/db/medicine_helper.dart';
import 'package:pill_reminder/db/sql_helper.dart';
import 'package:pill_reminder/db/timeslot_helper.dart';
import 'package:pill_reminder/model/medicine.dart';
import 'package:pill_reminder/model/prescription.dart';
import 'package:pill_reminder/model/timeslot.dart';

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
  static Future<List<Map<String, dynamic>>> getPrescriptionByid(
      int id) async {
    final db = await SQLHelper.db();
    return db.query('prescription',
        where: "id = ? ", whereArgs: [id], limit: 1);
  }
  static Future<List<Map<String, dynamic>>> getTimeSlotById(int id) async {
    final db = await SQLHelper.db();
    return db.query('timeslot',
        where: "id = ? ", whereArgs: [id], orderBy: "id", limit: 1);
  }

  static Future<List<Prescription>> queryAll(int profileId) async {
    List<Prescription> list = [];
    await getPrescriptionByprofileid(profileId).then((value) async {
     preparePrescriptionObject(value).then((objlist){
      list=objlist;}
     );
    });

    return list;
  }
  
  static Future<Prescription> prescriptionByIdList(int id) async {
    List<Prescription> list = [];
    await getPrescriptionByid(id).then((value) async {
    await preparePrescriptionObject(value).then((objlist){
      list=objlist;}
     );
    });
    return list.first;
  }

 static Future<List<Prescription>>  preparePrescriptionObject(List<Map<String,dynamic>> map) async {
    List<Prescription> list = [];
 for (int i = 0; i < map.length; i++) {
        Prescription tt = Prescription.fromMap(map[i]);
        List<Medication> medications = [];
        int tempid = tt.id ?? 0;
        await MedicationHelper.getMedicationById(tempid).then((value1) async {
          for (var med in value1) {
            Medication ttt = Medication.fromMap(med);

            await MedicineHelper.getMedicineById(ttt.medicine_id ?? 0)
                .then((medic) {
                ttt.medicine = Medicine.fromMap(medic.first); 
            });
            await TimeSlotHelper.timeSlotById(ttt.timeslot_id ?? 0)
                .then((timeslot) {
              
                ttt.timeslot = timeslot;
              
            });

            medications.add(ttt);
          }
          tt.medications = medications;
        });

        list.add(tt);
      }
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

  static Future<List<Map<String, dynamic>>> getMedicationById(
      int prescriptionId) async {
    final db = await SQLHelper.db();
    return db.query('medication',
        where: "prescription_id = ? ",
        whereArgs: [prescriptionId],
        orderBy: "id");
  }
}
