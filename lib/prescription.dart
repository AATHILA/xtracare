import 'package:flutter/material.dart';
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
                  builder: (context) => const AddPrescriptionStepOneWidget()));

          if (refresh) refreshData();
        },
        child: const Icon(Icons.add),
      ),
      body:
      plist.isNotEmpty? 
      Container(
          child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: plist.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: makeCard(plist[index]),
                );
              }))
              :Container(
                         height: 300,
                child: Center(
                    child: const Text(
                  'No Prescriptions added',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )))
    );
  }

  Card makeCard(Prescription pp) => Card(
        elevation: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: makeListTile(pp),
        ),
      );

  ListTile makeListTile(Prescription pp) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          pp.prescribed_by ?? "",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Expanded(
            flex: 4,
            child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(pp.start_date ?? "",
                    style: const TextStyle(color: Colors.white))),
          ),
          Expanded(
            flex: 4,
            child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(pp.end_date ?? "",
                    style: const TextStyle(color: Colors.white))),
          ),
        ]),
        trailing:
            const Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0 ),
        onTap: () async {
          bool refresh = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => PrescriptionEditWidget(id: pp.id??0)));

            if (refresh) refreshData();},
      );
}
