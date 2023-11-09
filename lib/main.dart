import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pill_reminder/db/profile_helper.dart';
import 'package:pill_reminder/db/sharedpref_helper.dart';
import 'package:pill_reminder/db/user_helper.dart';
import 'package:pill_reminder/home.dart';
import 'package:pill_reminder/login.dart';
import 'package:pill_reminder/register.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
        useMaterial3: true,

        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 0, 0, 0),
          // ···
          brightness: Brightness.dark,
        ),

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.oswald(
            fontSize: 30,
            fontStyle: FontStyle.italic,
          ),
          bodyMedium: GoogleFonts.merriweather(),
          displaySmall: GoogleFonts.pacifico(),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyApp(),
      routes: {
        'login': (context) => const LoginWidget(),
        'home': (context) => const HomeWidget(),
        'register': (context) => const RegisterWidget(),
      }));
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
