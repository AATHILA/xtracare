import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pill_reminder/dashboard.dart';
import 'package:pill_reminder/db/sharedpref_helper.dart';
import 'package:pill_reminder/db/user_helper.dart';
import 'package:pill_reminder/medicine.dart';
import 'package:pill_reminder/model/user.dart';
import 'package:pill_reminder/my_drawer_header.dart';
import 'package:pill_reminder/notification_details.dart';
import 'package:pill_reminder/notification_helper.dart';
import 'package:pill_reminder/notification_settings.dart';
import 'package:pill_reminder/prescription.dart';
import 'package:pill_reminder/profiles.dart';
import 'package:pill_reminder/timeslot.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  User usr = User();
  var currentPage = DrawerSections.dashboard;
  var titleApp = 'Pill Reminder';

  @override
  void initState() {
    super.initState();
    listenToNotification();

    SharedPreferHelper.getData('login_session_username').then((username) => {
          UserHelper.getUser(username).then((value) => {
                setState(() {
                  for (var element in value) {
                    usr = User.fromMap(element);
                  }
                })
              })
        });
  }
  showAlertDialog(BuildContext context) {

  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("No"),
    onPressed:  () {
      setState(() {
        currentPage=DrawerSections.dashboard;
      });
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: Text("Yes"),
    onPressed:  () { 
      SharedPreferHelper.removeData("login_session_username");
      SharedPreferHelper.removeData("login_session_userid");
      Navigator.of(context).pushNamedAndRemoveUntil(
                'login', (Route<dynamic> route) => false);},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Confirmation"),
    content: Text("Are you sure want to logout?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

  listenToNotification() async {
    onClickNotification.stream.listen((event) async {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NotificationDetailsWidget(event)));
    });
  }

  @override
  Widget build(BuildContext context) {
    var container;
    if (currentPage == DrawerSections.dashboard) {
      container = const DashboardWidget();
    } else if (currentPage == DrawerSections.profiles) {
      container = const ProfilesWidget();
    } else if (currentPage == DrawerSections.timeslot) {
      container = const TimeSlotWidget();
    } else if (currentPage == DrawerSections.medicine) {
      container = const MedicineWidget();
    } else if (currentPage == DrawerSections.prescription) {
      container = const PrescriptionWidget();
    } else if (currentPage == DrawerSections.notifications) {
      container = const NotificationSettingsWidget();
    } /* else if (currentPage == DrawerSections.privacy_policy) {
      container = PrivacyPolicyPage();
    } */
    
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(titleApp, style: const TextStyle(color: Colors.black)),
        ),
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [MyHeaderDrawer(usr), MyDrawerList()],
          ),
        ),
      ),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(1, "Dashboard", Icons.dashboard_outlined,
              currentPage == DrawerSections.dashboard ? true : false),
          menuItem(2, "Profiles", Icons.person,
              currentPage == DrawerSections.profiles ? true : false),
          menuItem(3, "Time Slot", Icons.timer,
              currentPage == DrawerSections.timeslot ? true : false),
          menuItem(4, "Medicines", Icons.medical_information,
              currentPage == DrawerSections.medicine ? true : false),
          menuItem(5, "Prescription", Icons.medication,
              currentPage == DrawerSections.prescription ? true : false),
          const Divider(),
          menuItem(6, "Notifications", Icons.notifications_outlined,
              currentPage == DrawerSections.notifications ? true : false),
          menuItem(7, "Logout", Icons.logout,
              currentPage == DrawerSections.logout ? true : false)
          

        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);

          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.dashboard;
              titleApp = 'Dashboard';
            } else if (id == 2) {
              currentPage = DrawerSections.profiles;
              titleApp = 'Profiles';
            } else if (id == 3) {
              currentPage = DrawerSections.timeslot;
              titleApp = 'Timeslots';
            } else if (id == 4) {
              currentPage = DrawerSections.medicine;
              titleApp = 'Medicine';
            } else if (id == 5) {
              currentPage = DrawerSections.prescription;
              titleApp = 'Prescription';
            } else if (id == 6) {
              currentPage = DrawerSections.notifications;
              titleApp = 'Notification';
            } else if (id == 7) {
              currentPage = DrawerSections.logout;
            }
            
          });
          if (currentPage == DrawerSections.logout) {
             showAlertDialog(context);
           
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  dashboard,
  profiles,
  timeslot,
  medicine,
  prescription,
  notifications,
  logout
  
}
