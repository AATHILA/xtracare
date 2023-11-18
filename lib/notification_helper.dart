import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:pill_reminder/db/schedules_helper.dart';

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
    SchedulesHelper.getSchedulesTodayPending(
            DateFormat('dd/MM/yyyy').format(DateTime.now()), 0)
        .then((value) async {
      for (var dashboard in value) {
        DateTime currentDate = DateTime.now();

        DateTime dtt = DateFormat('dd/MM/yyyy HH:mm aa')
            .parse('${dashboard.date} ${dashboard.time}');
        if (dtt.compareTo(currentDate) > 0) {
          showNotification(
              dashboard.id ?? 0,
              'Dont Forget to take your medicine',
              'Please take medicine at ${dashboard.time}',
              dtt.toUtc());
          SchedulesHelper.updateScheduleScheduled(dashboard.id ?? 0);
        }
      }
    });
  }

  Future<void> showNotification(
      int id, String title, String body, DateTime dtt) async {
    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime(tz.local, dtt.year, dtt.month, dtt.day, dtt.hour,
            dtt.minute, 0, 0, 0),
        //schedule the notification to show after 2 seconds.
        const NotificationDetails(
          android: AndroidNotificationDetails('main_channel', 'Main Channel',
              channelDescription: "Reminder",
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
              enableVibration: true,
              enableLights: true,
              fullScreenIntent: true,
              ticker: 'ticker',
              sound: RawResourceAndroidNotificationSound('alarm1'),
              actions: <AndroidNotificationAction>[
                AndroidNotificationAction('taken', 'Taken'),
                AndroidNotificationAction('snooze', 'Snooze'),
                AndroidNotificationAction('skip', 'Skip'),
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
