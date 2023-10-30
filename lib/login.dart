
import 'package:flutter/material.dart';
import 'package:pill_reminder/home.dart';
import 'package:pill_reminder/register.dart';
import 'package:pill_reminder/sql_helper.dart';

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
              child: const Text('Forgot Password',),
            ),
        Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              child: const Text('Login'),
              onPressed: () {
              
                bool valid=validateUser(usernameController.text,passwordController.text);
                if (valid) {
  Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeWidget()),
                );

                } 
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


bool validateUser(String username,String password)  {
 
Future<List<Map<String, dynamic>>>  users=  SQLHelper.checkUser(username, password);
List<Map<String, dynamic>> data=[];
users.then((value) => {
  data=value,print(data)
});
print(data);
if(data.isEmpty){ return false;}
else {return true;}
}
}