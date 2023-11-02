import 'package:flutter/material.dart';
import 'package:pill_reminder/db/user_helper.dart';
import 'package:pill_reminder/home.dart';
import 'package:pill_reminder/login.dart';
import 'package:pill_reminder/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: myApp(),
      routes: {
        'login': (context) => const LoginWidget(),
        'home': (context) => const HomeWidget(),
        'register': (context) => const RegisterWidget(),
      }));
}
class myApp extends StatefulWidget {
 const myApp({super.key});
 
 @override
 State<myApp> createState() => _myAppState();
}
 
class _myAppState extends State<myApp> {
    @override
  void initState() {
    super.initState();
    Future<List<Map<String,dynamic>>> userlist= UserHelper.getUsers();
    userlist.then((value)=>  print(value));
    getUserSessionData().then((value) =>{ 
  
     if ((value != null)) {
      Navigator.of(context).pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false),
    }
    else{
      Navigator.of(context).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false),
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

  Future<String?> getUserSessionData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('login_session_username');
  }
}