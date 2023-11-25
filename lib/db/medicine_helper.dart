import 'package:pill_reminder/db/sql_helper.dart';
import 'package:pill_reminder/model/medicine.dart';

class MedicineHelper {
  static Future<int> createMedicine(Medicine medicine) async {
    final db = await SQLHelper.db();
    return await db.insert('medicine', medicine.toMap());
  }

  static Future<int> updateMedicine(Medicine medicine) async {
    final db = await SQLHelper.db();
    return await db.update('medicine', medicine.toMap(),
        where: "id = ?", whereArgs: [medicine.id]);
  }


  static Future<List<Map<String, dynamic>>> getMedicineById(int id) async {
    final db = await SQLHelper.db();
    return db.query('medicine',
        where: "id = ? ", whereArgs: [id], orderBy: "id", limit: 1);
  }

  static Future<int> deleteMedicine(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('deleteMedicine',where: "medicineid = ? ", whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getMedicineByName(
      String search) async {
    final db = await SQLHelper.db();
    return db.query('medicine',
        where: "lower(name) like ? ", whereArgs: [search], orderBy: "name");
  }

  static Future<List<Map<String, dynamic>>> getMedicines() async {
    final db = await SQLHelper.db();
    return db.query('medicine', orderBy: 'updatedOn desc', limit: 10);
  }
  /*static Future<List> queryAll() async {
    final db = await SQLHelper.db();
    List<Map> timeslots = await db.rawQuery(
        'select timeslot.id,timeslot.name,timeslot_times.time from timeslot inner join timeslot_times on timeslot.id=timeslot_times.timeslotid group by timeslot.name');
    return timeslots;
  }*/
}
