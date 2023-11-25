import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pill_reminder/db/schedules_helper.dart';
import 'package:pill_reminder/model/dashboard.dart';
import 'package:pill_reminder/notification_helper.dart';

class NotificationDetailsWidget extends StatefulWidget {
  final String payload;
  const NotificationDetailsWidget(this.payload);

  @override
  State<NotificationDetailsWidget> createState() =>
      NotificationDetailsWidgetState();
}

class NotificationDetailsWidgetState extends State<NotificationDetailsWidget> {
  List<Dashboard> listToShow = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    dataRefresh();
  }

  dataRefresh() async {
    await SchedulesHelper.getSchedulesById(int.parse(widget.payload))
        .then((value) {
      setState(() {
        listToShow = value;
      });
    });
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? CircularProgressIndicator()
        : Container(
            margin: EdgeInsets.only(top: 18),
            color: Colors.grey,
            alignment: Alignment.center,
            child: Material(
                color: Colors.transparent,
                child: ListView(shrinkWrap: true, children: [
                  Card(
                    color: Colors.white,
                    elevation: 8,
                    child: Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    width: 5.0,
                                    color: Color.fromARGB(59, 246, 238, 238)))),
                        child: Column(children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(10),
                                        child: InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.black,
                                            ))),
                                  ],
                                )
                              ]),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: listToShow.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        child: makeListTile(listToShow[index]),
                                      );
                                    }),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          SchedulesHelper
                                              .updateScheduleCompleted(
                                                  int.parse(widget.payload));
                                          SchedulesItemHelper
                                              .updateScheduleItems(
                                                  int.parse(widget.payload));

                                          Navigator.pop(context, true);
                                        },
                                        child: Column(children: [
                                          Icon(
                                            Icons.done,
                                            color: Colors.black,
                                          ),
                                          Text('Taken',
                                              style: TextStyle(
                                                  color: Colors.black))
                                        ]),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          NotificationService().snoozeSchedule(
                                              int.parse(widget.payload));
                                          Navigator.pop(context,
                                              true); // Close the alert box
                                        },
                                        child: Column(children: [
                                          Icon(
                                            Icons.snooze,
                                            color: Colors.black,
                                          ),
                                          Text('Snooze',
                                              style: TextStyle(
                                                  color: Colors.black))
                                        ]),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: Column(children: [
                                          Icon(
                                            Icons.skip_next,
                                            color: Colors.black,
                                          ),
                                          Text('Skip',
                                              style: TextStyle(
                                                  color: Colors.black))
                                        ]),
                                      )
                                    ])
                              ]),
                        ])),
                  )
                ])));
  }

  int indx = 0;

  ListTile makeListTile(Dashboard dashboard) => ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        title: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Hi ${dashboard.profileName}. Please take your medications today',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
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
