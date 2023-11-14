import 'package:pill_reminder/db/sql_helper.dart';
import 'package:pill_reminder/model/dashboard.dart';
import 'package:pill_reminder/model/schedules.dart';

class SchedulesHelper {
  static Future<int> createSchedule(Schedules schedule) async {
    final db = await SQLHelper.db();
    return await db.insert('schedules', schedule.toMap());
  }

  static Future<List<Map<String, dynamic>>> getSchedulr(
      String date, String time) async {
    final db = await SQLHelper.db();
    return db.query('schedules',
        where: "schedule_date = ? and time = ? ",
        whereArgs: [date, time],
        orderBy: "id",
        limit: 1);
  }

  static Future<List<Dashboard>> getSchedulesToday(String todaydate) async {
    final db = await SQLHelper.db();
    List<Dashboard> list = [];
    List<Map> rows = await db.rawQuery(
        'select id,schedule_date,time from  schedules  where schedule_date=? order by time',
        [todaydate]);

    for (var item in rows) {
      Dashboard dsh = Dashboard(
          id: item['id'], date: item['schedule_date'], time: item['time']);
      await getScheduleMedicineById(item['id']).then((value) {
        List<DashboardItem> ttt = [];
        for (var sitms in value) {
          DashboardItem tmditm = DashboardItem(
              name: sitms['name'],
              dose: sitms['dose'],
              status: sitms['status']);
          ttt.add(tmditm);
        }
        dsh.items = ttt;
        list.add(dsh);
      });
    }
    return list;
  }

  static Future<List> getScheduleMedicineById(int id) async {
    final db = await SQLHelper.db();
    List<Map> rows = await db.rawQuery(
        'select it.id,it.status,m.name,md.dose from  schedules_item it,medication md,medicine m  where m.id=md.medicine_id and  md.id=it.medication_id and schedules_id=? order by name',
        [id]);
    return rows;
  }
}

class SchedulesItemHelper {
  static Future<int> createScheduleItems(ScheduleItem scheduleitem) async {
    final db = await SQLHelper.db();
    return await db.insert('schedules_item', scheduleitem.toMap());
  }
}
