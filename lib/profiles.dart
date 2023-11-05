import 'package:flutter/material.dart';
import 'package:pill_reminder/db/profile_helper.dart';
import 'package:pill_reminder/model/profile.dart';

class ProfilesWidget extends StatefulWidget {
  const ProfilesWidget({super.key});

  @override
  State<ProfilesWidget> createState() => _ProfilesWidgetState();
}

class _ProfilesWidgetState extends State<ProfilesWidget> {
  List<Profile> list = [];
  @override
  void initState() {
    super.initState();

    ProfileHelper.getProlfiles().then((value) => {
          value.forEach((element) {
            Profile temp = Profile.fromMap(element);

            setState(() {
              list.add(temp);
            });
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[200],
        child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(list[index].name.toString()),
              );
            }));
  }
}
