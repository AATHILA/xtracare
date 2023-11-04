import 'package:flutter/material.dart';
import 'package:pill_reminder/db/sharedpref_helper.dart';
import 'package:pill_reminder/home.dart';
import 'package:pill_reminder/register.dart';
import 'package:pill_reminder/db/user_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                          print(value),
                          if (value.isNotEmpty)
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeWidget()),
                              ),
                              map['login_session_username'] =
                                  usernameController.text,
                              SharedPreferHelper.saveData(map)
                            }
                        });
              },
            )),
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
    return UserHelper.checkUser(username, password);
  }
}
