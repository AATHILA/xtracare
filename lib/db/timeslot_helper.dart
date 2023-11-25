import 'package:pill_reminder/db/sql_helper.dart';
import 'package:pill_reminder/model/timeslot.dart';

class TimeSlotHelper {
  static Future<int> createTimeslot(Timeslot timeslot) async {
    final db = await SQLHelper.db();
    return await db.insert('timeslot', timeslot.toMap());
  }

  static Future<int> updateTimeslot(Timeslot timeslot) async {
    final db = await SQLHelper.db();
    return await db.update('timeslot', timeslot.toMap(),
        where: "id = ?", whereArgs: [timeslot.id]);
  }

  static Future<List<Map<String, dynamic>>> getTimeSlotByuserid(
      int userid) async {
    final db = await SQLHelper.db();
    return db.query('timeslot',
        where: "userid = ? ", whereArgs: [userid], orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getTimeSlotById(int id) async {
    final db = await SQLHelper.db();
    return db.query('timeslot',
        where: "id = ? ", whereArgs: [id], orderBy: "id", limit: 1);
  }
   static Future<Timeslot> timeSlotById(int id) async {
  List<Timeslot> list = [];
    await getTimeSlotById(id).then((value) async {
      for (int i = 0; i < value.length; i++) {
        Timeslot tt = Timeslot.fromMap(value[i]);
        List<TimeslotTimes> times = [];
        int tempid = tt.id ?? 0;
        await TimeSlotTimesHelper.getTimeSlotById(tempid).then((value1) {
          for (var timeslotTime in value1) {
            TimeslotTimes ttt = TimeslotTimes.fromMap(timeslotTime);
            times.add(ttt);
          }
          tt.times = times;
        });

        list.add(tt);
      }
    });

    return list.first;}

  static Future<List<Timeslot>> queryAll(int userid) async {
    List<Timeslot> list = [];
    await getTimeSlotByuserid(userid).then((value) async {
      for (int i = 0; i < value.length; i++) {
        Timeslot tt = Timeslot.fromMap(value[i]);
        List<TimeslotTimes> times = [];
        int tempid = tt.id ?? 0;
        await TimeSlotTimesHelper.getTimeSlotById(tempid).then((value1) {
          for (var timeslotTime in value1) {
            TimeslotTimes ttt = TimeslotTimes.fromMap(timeslotTime);
            times.add(ttt);
          }
          tt.times = times;
        });

        list.add(tt);
      }
    });

    return list;
  }
  /*static Future<List> queryAll() async {
    final db = await SQLHelper.db();
    List<Map> timeslots = await db.rawQuery(
        'select timeslot.id,timeslot.name,timeslot_times.time from timeslot inner join timeslot_times on timeslot.id=timeslot_times.timeslotid group by timeslot.name');
    return timeslots;
  }*/
}

class TimeSlotTimesHelper {
  static Future<int> createTimeslot(TimeslotTimes timeslottimes) async {
    final db = await SQLHelper.db();
    return await db.insert('timeslot_times', timeslottimes.toMap());
  }

  static Future<int> updateTimeslot(TimeslotTimes timeslottimes) async {
    final db = await SQLHelper.db();
    return await db.update('timeslot_times', timeslottimes.toMap(),
        where: "id = ?", whereArgs: [timeslottimes.id]);
  }

  static Future<List<Map<String, dynamic>>> getTimeSlotById(int id) async {
    final db = await SQLHelper.db();
    return db.query('timeslot_times',
        where: "timeslotid = ? ", whereArgs: [id], orderBy: "id");
  }

  static Future<int> deleteTimeslot(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('timeslot_times',where: "timeslotid = ? ", whereArgs: [id]);
  }
}
