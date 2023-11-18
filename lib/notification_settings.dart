import 'package:flutter/material.dart';

class NotificationSettingsWidget extends StatelessWidget {
  final int profileId;
  const NotificationSettingsWidget({super.key, required int this.profileId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notification Settings')),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Snooze',
                    hintText: 'Snooze'),
              )
            ],
          )),
    );
  }
}
