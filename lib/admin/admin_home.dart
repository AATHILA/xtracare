import 'package:flutter/material.dart';
import 'package:pill_reminder/admin/admin_dashboard_widget.dart';
import 'package:pill_reminder/admin/admin_medicines.dart';
import 'package:pill_reminder/admin/header_drawer.dart';
import 'package:pill_reminder/db/sharedpref_helper.dart';
import 'package:pill_reminder/db/user_helper.dart';
import 'package:pill_reminder/model/user.dart';

class AdminHomeWidget extends StatefulWidget {
  const AdminHomeWidget({super.key});

  @override
  State<AdminHomeWidget> createState() => _AdminHomeWidgetState();
}

class _AdminHomeWidgetState extends State<AdminHomeWidget> {
  User usr = User();
  var currentPage = DrawerSections.dashboard;
  var titleApp = 'Dashboard';
  @override
  void initState() {
    super.initState();

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

  @override
  Widget build(BuildContext context) {
    var container;
    if (currentPage == DrawerSections.dashboard) {
      container = const AdminDashboardWidget();
    } else {
      container = const AdminMedicineWidget();
    }
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
            children: [AdminHeaderDrawer(usr), MyDrawerList()],
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
          menuItem(2, "Medicines", Icons.medical_information,
              currentPage == DrawerSections.medicine ? true : false),
          menuItem(3, "Users", Icons.verified_user_sharp,
              currentPage == DrawerSections.users ? true : false),
          menuItem(4, "Feedbacks", Icons.feedback,
              currentPage == DrawerSections.feedback ? true : false),
          const Divider(),
          menuItem(5, "Logout", Icons.medication,
              currentPage == DrawerSections.logout ? true : false),
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
              currentPage = DrawerSections.medicine;
              titleApp = 'Medicines';
            } else if (id == 3) {
              currentPage = DrawerSections.users;
              titleApp = 'Users';
            } else if (id == 4) {
              currentPage = DrawerSections.feedback;
              titleApp = 'Feedback';
            } else if (id == 5) {
              currentPage = DrawerSections.logout;
              titleApp = 'Logout';
            }
          });
          if (currentPage == DrawerSections.logout) {
            // showAlertDialog(context);
            SharedPreferHelper.removeData("login_session_username");
            SharedPreferHelper.removeData("login_session_userid");
            Navigator.of(context).pushNamedAndRemoveUntil(
                'login', (Route<dynamic> route) => false);
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

enum DrawerSections { dashboard, medicine, users, feedback, logout }
