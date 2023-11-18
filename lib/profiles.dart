import 'package:flutter/material.dart';
import 'package:pill_reminder/constant.dart';
import 'package:pill_reminder/db/profile_helper.dart';
import 'package:pill_reminder/db/sharedpref_helper.dart';
import 'package:pill_reminder/model/profile.dart';
import 'package:pill_reminder/profile_add.dart';
import 'package:pill_reminder/profile_edit.dart';

class ProfilesWidget extends StatefulWidget {
  const ProfilesWidget({super.key});

  @override
  State<ProfilesWidget> createState() => _ProfilesWidgetState();
}

class _ProfilesWidgetState extends State<ProfilesWidget> {
  List<Profile> list = [];
  int userid = 0;
  int profileactive = 0;

  @override
  void initState() {
    super.initState();
    dataRefresh();
  }

  void dataRefresh() {
    List<Profile> tempList = [];
    SharedPreferHelper.getData("login_session_userid").then((value) {
      setState(() {
        userid = int.parse(value);
      });
      ProfileHelper.getProfile(userid).then((value1) {
        for (var element in value1) {
          Profile temp = Profile.fromMap(element);

          tempList.add(temp);
        }
        setState(() {
          SharedPreferHelper.getData("active_profile")
              .then((value2) => {profileactive = int.parse(value2)});

          list = tempList;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool refresh = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProfileAddWidget()));

            if (refresh) dataRefresh();
          },
          child: const Icon(Icons.add),
        ),
        body: Container(
            color: Colors.grey[200],
            child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: makeCard(list[index]),
                  );
                })));
  }

  Card makeCard(Profile profile) => Card(
        elevation: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: const BoxDecoration(color: Constants.listBackgroundColor),
          child: makeListTile(profile),
        ),
      );

  ListTile makeListTile(Profile profile) => ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: const EdgeInsets.only(right: 12.0),
          decoration: const BoxDecoration(
              border: Border(
                  right: BorderSide(
                      width: 1.0, color: Color.fromARGB(59, 246, 238, 238)))),
          child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                const Icon(Icons.account_circle, color: Colors.white),
                Text('Age ${profile.age}',
                    style: const TextStyle(
                        fontSize: 10,
                        color: Color.fromARGB(255, 255, 255, 255)))
              ])),
        ),
        title: Text(
          profile.name ?? "",
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Expanded(
            flex: 4,
            child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(profile.relation ?? "",
                    style: const TextStyle(color: Colors.white))),
          ),
          Expanded(
            flex: 4,
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(profileactive == profile.id ? "ACTIVE" : "",
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        backgroundColor: Color.fromARGB(255, 3, 134, 10)))),
          ),
        ]),
        trailing: const Icon(Icons.keyboard_arrow_right,
            color: Colors.white, size: 30.0),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditProfileWidget(id: profile.id ?? 0)));
        },
      );
}
