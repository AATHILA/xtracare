import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:pill_reminder/db/profile_helper.dart';
import 'package:pill_reminder/db/schedules_helper.dart';
import 'package:pill_reminder/db/sharedpref_helper.dart';
import 'package:pill_reminder/db/user_helper.dart';
import 'package:pill_reminder/home.dart';
import 'package:pill_reminder/login.dart';
import 'package:pill_reminder/notification_details.dart';
import 'package:pill_reminder/notification_helper.dart';
import 'package:pill_reminder/register.dart';
import 'package:workmanager/workmanager.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyApp(),
      /* theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.black,
        brightness: Brightness.light,
      )),*/
      routes: {
        'login': (context) => const LoginWidget(),
        'home': (context) => const HomeWidget(),
        'register': (context) => const RegisterWidget(),
      }));
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    // NotificationService().scheduleNotification();
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
    WidgetsFlutterBinding.ensureInitialized();
    NotificationService().initNotification();
    Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
    Workmanager().registerPeriodicTask(
      "2",
      "NotificationPeriodicTask",
      frequency: const Duration(minutes: 15),
    );

    return MaterialApp(
      title: "Xtracare",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Container(
        margin: EdgeInsets.all(10),
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          image: DecorationImage(
            image: AssetImage('assets/images/xtracare.png'),
          ),
        ),
      )),
    );
  }
}
