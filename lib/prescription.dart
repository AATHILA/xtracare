import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pill_reminder/db/prescription_helper.dart';
import 'package:pill_reminder/db/sharedpref_helper.dart';
import 'package:pill_reminder/model/prescription.dart';
import 'package:pill_reminder/model/timeslot.dart';
import 'package:pill_reminder/prescription_edit.dart';
import 'package:pill_reminder/prescriptionaddstep1.dart';

class PrescriptionWidget extends StatefulWidget {
  const PrescriptionWidget({super.key});

  @override
  State<PrescriptionWidget> createState() => _PrescriptionWidgetState();
}

class _PrescriptionWidgetState extends State<PrescriptionWidget> {
  List<Prescription> plist = [];
  int profileid = 0;
  @override
  void initState() {
    super.initState();
    refreshData();
  }

  refreshData() {
    SharedPreferHelper.getData('active_profile').then((value) {
      setState(() {
        profileid = int.parse(value);
      });

      PrescriptionHelper.getPrescriptionByprofileid(profileid).then((value) {
        List<Prescription> tmplist = [];
        for (var item in value) {
          tmplist.add(Prescription.fromMap(item));
          print(Prescription.fromMap(item));
        }
        setState(() {
          plist = tmplist;
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
                    builder: (context) =>
                        const AddPrescriptionStepOneWidget()));

            if (refresh) refreshData();
          },
          child: const Icon(Icons.add),
        ),
        body: plist.isNotEmpty
            ? Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: plist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: makeCard(plist[index]),
                      );
                    }))
            : Container(
                height: 300,
                child: Center(
                    child: const Text(
                  'No Prescriptions added',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ))));
  }

  Card makeCard(Prescription pp) => Card(
        elevation: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: makeListTile(pp),
        ),
      );

  ListTile makeListTile(Prescription pp) => ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        title: Container(
            padding: EdgeInsets.only(top: 5),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                    alignment: Alignment.topLeft,
                    child: Text("Prescribed By",
                        style: const TextStyle(
                            color: Colors.white, fontSize: 10))),
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(5),
                    child: Text(
                      toBeginningOfSentenceCase(pp.prescribed_by) ?? "",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))
              ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.only(top: 10),
                              child: Text('Start Date',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10))),
                          Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.only(top: 5, left: 5.0),
                              child: Text(pp.start_date ?? "",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)))
                        ],
                      ),
                    ),
                    Spacer(),
                    Expanded(
                        flex: 4,
                        child: Column(children: [
                          Container(
                              alignment: Alignment.topRight,
                              padding:
                                  const EdgeInsets.only(top: 10, right: 45),
                              child: Text('End Date',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10))),
                          Container(
                              alignment: Alignment.topRight,
                              padding: const EdgeInsets.only(top: 5, left: 5.0),
                              child: Text(pp.end_date ?? "",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)))
                        ])),
                  ])
            ])),

        /*
        subtitle:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text('Start Date',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 10))),
                Container(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text(pp.start_date ?? "",
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)))
              ],
            ),
          ),
          Spacer(),
          Expanded(
              flex: 4,
              child: Column(children: [
                Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text('End Date',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 10))),
                Container(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text(pp.end_date ?? "",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)))
              ])),
        ]),*/
        onTap: () async {
          bool refresh = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PrescriptionEditWidget(id: pp.id ?? 0)));

          if (refresh) refreshData();
        },
      );
}
