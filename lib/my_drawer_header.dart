// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pill_reminder/model/user.dart';

class MyHeaderDrawer extends StatefulWidget {
  final User user;
  const MyHeaderDrawer(this.user, {super.key});

  @override
  State<StatefulWidget> createState() => _MyHeaderState();
}



class _MyHeaderState extends State<MyHeaderDrawer> {
  

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 7, 53, 91),
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/profile.png'),
              ),
            ),
          ), Container(
            padding: EdgeInsets.only(bottom:10),
            child:
          Text(
            widget.user.firstName!,
            style: TextStyle(color: Colors.white, fontSize: 20),
          )),
          Text(
             widget.user.username!,
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
