import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:getwidget/getwidget.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pill_reminder/api/sync_data_from_server.dart';
import 'package:pill_reminder/api/sync_data_to_server.dart';
import 'package:pill_reminder/db/schedules_helper.dart';
import 'package:pill_reminder/db/sharedpref_helper.dart';
import 'package:pill_reminder/medicineadd.dart';
import 'package:pill_reminder/model/dashboard.dart';
import 'package:pill_reminder/notification_details.dart';
import 'package:pill_reminder/notification_helper.dart';
import 'package:pill_reminder/prescriptionaddstep1.dart';
import 'package:pill_reminder/profile_add.dart';
import 'package:pill_reminder/timeslot.dart';
import 'package:pill_reminder/timeslotadd.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  List<Dashboard> listToShow = [];
  String date = '';
  int profileID = 0;
  @override
  void initState() {
    super.initState();

    date = DateFormat('dd/MM/yyyy').format(DateTime.now());
    dataRefresh();
  }

  dataRefresh() async {
    await SharedPreferHelper.getData('active_profile').then((value) {
      profileID = int.parse(value);
    });

    await SchedulesHelper.getSchedulesToday(date, profileID).then((value) {
      value.sort((a, b) {return DateFormat('hh:mm a')
            .parse(a.time!).compareTo(DateFormat('hh:mm a')
            .parse(b.time!));});
      setState(() {
        listToShow = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: SpeedDial(
            icon: Icons.add,
            backgroundColor: Colors.black45,
          

//provide here features of your parent FAB

            children: [
              SpeedDialChild(
                  child: Icon(Icons.medication),
                  label: 'Add Prescription',
                  onTap: () async {
                    bool refresh = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AddPrescriptionStepOneWidget()));
                  }),
              SpeedDialChild(
                  child: Icon(Icons.person),
                  label: 'Add Profile',
                  onTap: () async {
                    bool refresh = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileAddWidget()));
                  }),
              SpeedDialChild(
                  child: Icon(Icons.timelapse_rounded),
                  label: 'Add Timeslot',
                  onTap: () async {
                    bool refresh = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TimeSlotAddWidget()));
                  }),

                   SpeedDialChild(
                  child: Icon(Icons.medical_services_outlined),
                  label: 'Add Medicine',
                  onTap: () async {
                    bool refresh = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MedicineAddWidget()));
                  }),
            ]),
        body: SingleChildScrollView(
          child: Column(children: [
            EasyDateTimeLine(
              initialDate: DateTime.now(),
              onDateChange: (selectedDate) {
                setState(() {
                  date = DateFormat('dd/MM/yyyy').format(selectedDate);

                  dataRefresh();
                });
              },
              activeColor: Color.fromARGB(255, 177, 155, 255),
              headerProps: const EasyHeaderProps(
                selectedDateFormat: SelectedDateFormat.fullDateDMonthAsStrY,
              ),
              dayProps: const EasyDayProps(
                height: 56.0,
                width: 56.0,
                dayStructure: DayStructure.dayNumDayStr,
                inactiveDayStyle: DayStyle(
                  borderRadius: 48.0,
                  dayNumStyle: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                activeDayStyle: DayStyle(
                  dayNumStyle: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            listToShow.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: listToShow.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: makeCard(listToShow[index]),
                      );
                    })
                : Container(
                    height: 300,
                    child: Center(
                        child: const Text(
                      'No Medication Today',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ))),
          ]),
        ));
  }

  int indx = 0;
  Card makeCard(Dashboard dashboard) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
        child: Container(
          decoration: const BoxDecoration(
              border: Border(
                  right: BorderSide(
                      width: 5.0, color: Color.fromARGB(59, 246, 238, 238)))),
          child: makeListTile(dashboard),
        ),
      );

  ListTile makeListTile(Dashboard dashboard) => ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        title: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                child: const Icon(
                  Icons.calendar_month,
                  color: Colors.black,
                ),
              ),
              Text(
                toBeginningOfSentenceCase(dashboard.time) ?? "",
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(color: Colors.white, height: 15, thickness: 0.7),
          for (int i = 0; i < dashboard.items!.length; i++)
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Card(
                  color: Colors.black,
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 5),
                          alignment: Alignment.topLeft,
                          child: Column(children: [
                            const Text(
                              'Medicine',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 196, 194, 194),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8),
                            ),
                            Container(
                                padding: EdgeInsets.only(left: 20, top: 2),
                                child: Text(
                                  toBeginningOfSentenceCase(
                                          dashboard.items![i].name) ??
                                      '',
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.bold),
                                ))
                          ])),
                      const Divider(
                        color: Colors.white,
                      ),
                      Row(children: [
                        Container(
                            padding:
                                const EdgeInsets.only(left: 35, bottom: 10),
                            child: Text(
                              toBeginningOfSentenceCase(
                                      '${dashboard.items![i].status == 'PENDING' ? 'Take' : 'Taken'} ${dashboard.items![i].dose!}') ??
                                  '',
                              style: TextStyle(
                                  color:
                                      (dashboard.items![i].status == 'PENDING'
                                          ? Colors.white
                                          : Colors.greenAccent),
                                  fontWeight: FontWeight.bold),
                            )),
                        const Spacer(),
                        Container(
                            padding:
                                const EdgeInsets.only(right: 15, bottom: 10),
                            child: Row(
                              children: [
                                Container(
                                    padding: EdgeInsets.only(right: 3),
                                    child: Icon(MfgLabs.pencil,
                                        size: 12, color: Colors.grey)),
                                Text(
                                  toBeginningOfSentenceCase(
                                          dashboard.items![i].prescribedBy) ??
                                      '',
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ))
                      ]), ///////////////
                    ],
                  ),
                ))
        ]),
        onTap: () async {
          bool refresh = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NotificationDetailsWidget(dashboard.id.toString())));
          if (refresh) dataRefresh();
          //   _showAlertBox(context, dashboard.id ?? 0);
        },
      );

  void _showAlertBox(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: Text(
            'Mark the status',
            textAlign: TextAlign.center,
          ),
          content: Text('Please mark your pill status?'),
          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the alert box
                },
                child: Column(children: [Icon(Icons.done), Text('Taken')]),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the alert box
                  // Perform snooze action here
                  print('Snooze');
                },
                child: Column(children: [Icon(Icons.snooze), Text('Snooze')]),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the alert box
                  // Perform snooze action here
                  print('Skip');
                },
                child: Column(
                    children: [Icon(Icons.skip_next_sharp), Text('Skip')]),
              )
            ])
          ],
        );
      },
    );
  }
}
