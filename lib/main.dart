import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pill_reminder/db/profile_helper.dart';
import 'package:pill_reminder/db/schedules_helper.dart';
import 'package:pill_reminder/db/sharedpref_helper.dart';
import 'package:pill_reminder/db/user_helper.dart';
import 'package:pill_reminder/home.dart';
import 'package:pill_reminder/login.dart';
import 'package:pill_reminder/notification_helper.dart';
import 'package:pill_reminder/register.dart';
import 'package:workmanager/workmanager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerPeriodicTask(
    "2",
    "NotificationPeriodicTask",
    frequency: const Duration(minutes: 15),
  );
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyApp(),
      routes: {
        'login': (context) => const LoginWidget(),
        'home': (context) => const HomeWidget(),
        'register': (context) => const RegisterWidget(),
      }));
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    // initialise the plugin of flutterlocalnotifications
    // NotificationService().showNotification(1, "Reminder", "Please take your medication");

    int dr = 0;
    SchedulesHelper.getSchedulesToday(
            DateFormat('dd/MM/yyyy').format(DateTime.now()))
        .then((value) => {
              value.forEach((element) {
                dr = dr + 1;
                print(element);
                // DateTime dtt = DateFormat('dd/MM/yyyy HH:mm aa').parse(element['schedule_date'] + ' ' + element['time']);
                DateTime dtt = DateTime.now().add(Duration(minutes: dr));

                print(dtt);
                NotificationService().showNotification(element.id ?? 0,
                    "Reminder", "Please take your medication", dtt.toUtc());
              })
            });

    print("EXECUTED");
    return Future.value(true);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _myAppState();
}

class _myAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future<List<Map<String, dynamic>>> userlist = UserHelper.getUsers();
    userlist.then((value) => print(value));
    Future<List<Map<String, dynamic>>> profilelist =
        ProfileHelper.getProfiles();
    profilelist.then((value) => print(value));

    SharedPreferHelper.getData("login_session_username").then((value) => {
          if ((value != null))
            {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  'home', (Route<dynamic> route) => false),
            }
          else
            {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  'login', (Route<dynamic> route) => false),
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Super Screen",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      )),
    );
  }
}
