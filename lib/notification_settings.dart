import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationSettingsWidget extends StatelessWidget {
  const NotificationSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final audioPlayer = AudioPlayer();
    ;
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Snooze Time',
                    hintText: 'Snooze Time in minutes'),
              ),
              TextButton(
                  onPressed: () async {
                    await audioPlayer.play('res/raw/alarm1.mp3' as Source);
                  },
                  child: Text('play'))
            ],
          )),
    );
  }
}
