import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:pill_reminder/db/notification_settings_helper.dart';
import 'package:pill_reminder/db/schedules_helper.dart';
import 'package:pill_reminder/db/sharedpref_helper.dart';
import 'package:pill_reminder/model/dashboard.dart';
import 'package:pill_reminder/model/notification_settings.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:rxdart/rxdart.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_stat_xtracare');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    // the initialization settings are initialized after they are setted
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveNotificationResponse);
  }

  Future<void> scheduleNotification() async {
    await SchedulesHelper.getSchedulesTodayPending(
            DateFormat('dd/MM/yyyy').format(DateTime.now()), 0)
        .then((value) async {
      for (var dashboard in value) {
        DateTime currentDate = DateTime.now();

        DateTime dtt = DateFormat('dd/MM/yyyy HH:mm aa')
            .parse('${dashboard.date} ${dashboard.time}');
        if (dtt.compareTo(currentDate) > 0) {
          showNotification(
              dashboard.id ?? 0,
              'Hi ${dashboard.profileName}. Dont Forget to take your medicine',
              'Please take medicine at ${dashboard.time}',
              dtt.toUtc(),
              dashboard.audioName ?? '');
          await SchedulesHelper.updateScheduleScheduled(dashboard.id ?? 0);
        }
      }
    });
  }

  Future<void> snoozeSchedule(int id) async {
    int snooze = 0;
    Dashboard dashboard = Dashboard();
    await SharedPreferHelper.getData('active_profile').then((profileId) async {
      await NotificationSettingsHelper.getNotificationByprofileid(
              int.parse(profileId))
          .then((map) {
        NotificationSettings nt = NotificationSettings.fromMap(map.first);

        snooze = nt.snooze!;
      });
    });
    await SchedulesHelper.updateSnooze(id, snooze);
    await SchedulesHelper.getSchedulesById(id).then((dash) {
      dashboard = dash.first;
    });
    DateTime dtt = DateFormat('dd/MM/yyyy HH:mm aa')
        .parse('${dashboard.date} ${dashboard.time}')
        .add(Duration(minutes: snooze));

    showNotification(
        dashboard.id ?? 0,
        'Hi ${dashboard.profileName}. Dont Forget to take your medicine',
        'Please take medicine at ${dashboard.time}',
        dtt.toUtc(),
        dashboard.audioName ?? '');
    await SchedulesHelper.updateScheduleScheduled(dashboard.id ?? 0);
  }

  Future<void> showNotification(
      int id, String title, String body, DateTime dtt, String audioStr) async {
    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime(tz.local, dtt.year, dtt.month, dtt.day, dtt.hour,
            dtt.minute, 0, 0, 0),
        NotificationDetails(
          android: AndroidNotificationDetails('main_channel', 'Main Channel',
              channelDescription: "Reminder",
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
              enableVibration: true,
              enableLights: true,
              fullScreenIntent: true,
              ticker: 'ticker',
              sound: RawResourceAndroidNotificationSound(audioStr),
              actions: <AndroidNotificationAction>[
                AndroidNotificationAction('taken', 'Taken'),
                AndroidNotificationAction('snooze', 'Snooze'),
                AndroidNotificationAction('skip', 'Skip',
                    cancelNotification: true),
              ]),
        ),
        payload: id.toString(),

        // Type of time interpretation
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.alarmClock);
  }
}

final onClickNotification = BehaviorSubject<String>();
void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  onClickNotification.add(payload ?? '');
}
