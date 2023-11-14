import 'package:flutter/material.dart';
import 'package:pill_reminder/db/profile_helper.dart';
import 'package:pill_reminder/db/sharedpref_helper.dart';
import 'package:pill_reminder/model/profile.dart';
import 'package:pill_reminder/model/user.dart';
import 'package:pill_reminder/register.dart';
import 'package:pill_reminder/db/user_helper.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Pill Reminder',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w500,
                  fontSize: 30),
            )),
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Login User',
              style: TextStyle(fontSize: 20),
            )),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: TextField(
            obscureText: true,
            controller: passwordController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            //forgot password screen
          },
          child: const Text(
            'Forgot Password',
          ),
        ),
        Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
                child: const Text('Login'),
                onPressed: () {
                  Map<String, dynamic> map = {};
                  validateUser(usernameController.text.trim(),
                          passwordController.text.trim())
                      .then((value) => {
                            if (value.isNotEmpty)
                              {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginWidget()),
                                  ModalRoute.withName("/home"),
                                ),
                                value.forEach((element) {
                                  User usr = User.fromMap(element);
                                  map['login_session_username'] = usr.username;
                                  map['login_session_userid'] =
                                      usr.id.toString();
                                  ProfileHelper.getProfileActiveByRelation(
                                          usr.id ?? 0, 'Me')
                                      .then((value1) => {
                                            value1.forEach((element1) {
                                              Profile pf =
                                                  Profile.fromMap(element1);
                                              map['active_profile'] =
                                                  pf.id.toString();
                                            }),
                                            SharedPreferHelper.saveData(map)
                                                .then(
                                              (value) => Navigator.of(context)
                                                  .pushNamedAndRemoveUntil(
                                                      'home',
                                                      (Route<dynamic> route) =>
                                                          false),
                                            )
                                          });
                                })
                              }
                          });
                })),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Does not have account?'),
            TextButton(
              child: const Text(
                'Register',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterWidget()),
                );
              },
            )
          ],
        ),
      ],
    ));
  }

  Future<List<Map<String, dynamic>>> validateUser(
      String username, String password) {
    UserHelper.getUsers().then((value) => value.forEach((element) {
          print(User.fromMap(element));
        }));
    return UserHelper.checkUser(username, password);
  }
}
