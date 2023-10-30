import 'package:flutter/material.dart';
import 'package:pill_reminder/login.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login',
    routes: {'login':(context) => const LoginWidget()}
  ));
}
