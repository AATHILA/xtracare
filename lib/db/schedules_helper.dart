import 'package:pill_reminder/db/sql_helper.dart';
import 'package:pill_reminder/model/dashboard.dart';
import 'package:pill_reminder/model/schedules.dart';

class SchedulesHelper {
  static Future<int> createSchedule(Schedules schedule) async {
    final db = await SQLHelper.db();
    return await db.insert('schedules', schedule.toMap());
  }

  static Future<int> updateSchedule(Schedules schedule) async {
    final db = await SQLHelper.db();
    return await db.update('schedules', schedule.toMap(),
        where: "id = ?", whereArgs: [schedule.id]);
  }

  static Future<int> updateScheduleScheduled(int id) async {
    final db = await SQLHelper.db();
    int count = await db.rawUpdate(
        'UPDATE schedules SET schedule_status = ? WHERE id = ?',
        ['SCHEDULED', id]);
    return count;
  }

  static Future<int> updateScheduleCompleted(int id) async {
    final db = await SQLHelper.db();
    int count = await db.rawUpdate(
        'UPDATE schedules SET schedule_status = ? WHERE id = ?',
        ['COMPLETED', id]);
    return count;
  }

  static Future<int> updateSchedulePending(int id) async {
    final db = await SQLHelper.db();
    int count = await db.rawUpdate(
        'UPDATE schedules SET schedule_status = ? WHERE id = ?',
        ['PENDING', id]);
    return count;
  }

  static Future<List<Map<String, dynamic>>> getSchedulr(
      String date, String time, int profileid) async {
    final db = await SQLHelper.db();
    return db.query('schedules',
        where: "schedule_date = ? and time = ? and profile_id=? ",
        whereArgs: [date, time, profileid],
        orderBy: "id",
        limit: 1);
  }

  static Future<List<Dashboard>> getSchedulesToday(
      String todaydate, int profileId) async {
    final db = await SQLHelper.db();
    List<Dashboard> list = [];
    List<Map> rows = await db.rawQuery(
        'select s.id,s.schedule_date,time,p.name as profile_name,s.profile_id,n.alarm_sound from  schedules s,notification_settings n, profile p where p.id=s.profile_id and s.profile_id=n.profile_id and schedule_date=? and s.profile_id like ? order by substr(time,7,2),substr(time,1,5)',
        [todaydate, profileId > 0 ? profileId : '%']);

    for (var item in rows) {
      Dashboard dsh = Dashboard(
          id: item['id'],
          date: item['schedule_date'],
          time: item['time'],
          profileId: item['profile_id'],
          profileName: item['profile_name'],
          audioName: item['alarm_sound']);
      await getScheduleMedicineById(item['id']).then((value) {
        List<DashboardItem> ttt = [];
        for (var sitms in value) {
          DashboardItem tmditm = DashboardItem(
              name: sitms['name'],
              dose: sitms['dose'],
              status: sitms['status'],
              prescribedBy: sitms['prescribed_by']);
          ttt.add(tmditm);
        }
        dsh.items = ttt;
        list.add(dsh);
      });
    }
    return list;
  }

  static Future<List<Dashboard>> getSchedulesById(int id) async {
    final db = await SQLHelper.db();
    List<Dashboard> list = [];
    List<Map> rows = await db.rawQuery(
        'select s.id,s.schedule_date,p.name,s.time from  schedules s,profile p where p.id=s.profile_id and s.id=? limit 1',
        [id]);

    for (var item in rows) {
      Dashboard dsh = Dashboard(
          id: item['id'],
          date: item['schedule_date'],
          time: item['time'],
          profileName: item['name']);
      await getScheduleMedicineById(item['id']).then((value) {
        List<DashboardItem> ttt = [];
        for (var sitms in value) {
          DashboardItem tmditm = DashboardItem(
              name: sitms['name'],
              dose: sitms['dose'],
              status: sitms['status'],
              prescribedBy: sitms['prescribed_by']);
          ttt.add(tmditm);
        }
        dsh.items = ttt;
        list.add(dsh);
      });
    }
    return list;
  }

  static Future<List<Dashboard>> getSchedulesTodayPending(
      String todaydate, int profile_id) async {
    final db = await SQLHelper.db();
    List<Dashboard> list = [];

    List<Map> rows = await db.rawQuery(
        'select s.id,s.schedule_date,s.time,p.name as profile_name,s.profile_id,n.alarm_sound from  schedules s,notification_settings n, profile p where p.id=s.profile_id and n.profile_id=s.profile_id and schedule_date=? and schedule_status=? and s.profile_id like ? order by time',
        [todaydate, 'PENDING', profile_id > 0 ? profile_id : '%']);

    for (var item in rows) {
      Dashboard dsh = Dashboard(
          id: item['id'],
          date: item['schedule_date'],
          time: item['time'],
          profileId: item['profile_id'],
          profileName: item['profile_name'],
          audioName: item['alarm_sound']);
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
        'select it.id,it.status,m.name,md.dose,p.prescribed_by from  prescription p,schedules_item it,medication md,medicine m  where m.id=md.medicine_id and  md.id=it.medication_id and p.id=md.prescription_id and schedules_id=? order by name',
        [id]);
    return rows;
  }

  static Future<int> updateSnooze(int id, int snooze) async {
    final db = await SQLHelper.db();

    return await db.rawUpdate(
        'UPDATE schedules SET snooze = snooze+? WHERE id = ?', [snooze, id]);
  }
}

class SchedulesItemHelper {
  static Future<int> createScheduleItems(ScheduleItem scheduleitem) async {
    final db = await SQLHelper.db();
    return await db.insert('schedules_item', scheduleitem.toMap());
  }

  static Future<int> updateScheduleItems(int scheduleId) async {
    final db = await SQLHelper.db();

    return await db.rawUpdate(
        'UPDATE schedules_item SET status = ? WHERE schedules_id = ?',
        ['TAKEN', scheduleId]);
  }
}
