import 'package:flutter/material.dart';
import 'package:pill_reminder/db/sharedpref_helper.dart';
import 'package:pill_reminder/db/timeslot_helper.dart';
import 'package:pill_reminder/model/timeslot.dart';
import 'package:pill_reminder/timeslot_edit.dart';
import 'package:pill_reminder/timeslotadd.dart';

class TimeSlotWidget extends StatefulWidget {
  const TimeSlotWidget({super.key});

  @override
  State<StatefulWidget> createState() => _TimeSlotWidgetState();
}

class _TimeSlotWidgetState extends State<TimeSlotWidget> {
  int userID = 0;
  List<Timeslot> list = [];

  @override
  void initState() {
    super.initState();
    refreshData();

  }

  void refreshData() {
    SharedPreferHelper.getData("login_session_userid").then((value) {
      setState(() {
        userID = int.parse(value);
      });
      TimeSlotHelper.queryAll(userID).then((value) {
     

        setState(() {
          list = value;
        });
        print('Fetched ${list.length}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool refresh = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TimeSlotAddWidget()));

          if (refresh) refreshData();
        },
        child: const Icon(Icons.add),
      ),
      body: 
      list.isNotEmpty?
      Container(
          color: Colors.grey[200],
          child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: makeCard(list[index]),
                );
              }))
              :Container(
                height: 300,
                child: Center(
                    child: const Text(
                  'No Timeslot',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ))),
              
    );
  }
  
  Card makeCard(Timeslot timeslot) => Card(
        elevation: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: const BoxDecoration(color: Colors.black,borderRadius: BorderRadius.all(Radius.circular(5))),
          child: makeListTile(timeslot),
        ),
      );

  ListTile makeListTile(Timeslot timeslot) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: const EdgeInsets.only(right: 12.0),
          decoration: const BoxDecoration(
              border: Border(
                  right: BorderSide(
                      width: 1.0, color: Color.fromARGB(59, 246, 238, 238)))),
          child: Container(
              child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Icon(Icons.timer, color: Colors.white),
              ])),
        ),
        title: Text(
          timeslot.name ?? "",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Expanded(
            flex: 4,
            child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  children: <Widget>[
                    for (var ele in timeslot.times!)
                      Container(
                          child: Container(
                              margin: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 253, 254, 255)),
                              ),
                              child: Text(ele.time ?? "",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 9))))
                  ],
                )),
          ),
        ]),
        trailing:
            const Icon(Icons.edit, color: Colors.white, size: 30.0),
        onTap: () async {
           bool refresh = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => TimeslotEditWidget(id:timeslot.id ?? 0)));

          if (refresh) refreshData();
        },
      );
}
