import 'package:flutter/material.dart';
import 'package:pill_reminder/db/prescription_helper.dart';
import 'package:pill_reminder/db/sharedpref_helper.dart';
import 'package:pill_reminder/model/prescription.dart';
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
                  builder: (context) => AddPrescriptionStepOneWidget()));

          if (refresh) refreshData();
        },
        child: Icon(Icons.add),
      ),
      body: Container(
          child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: plist.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: makeCard(plist[index]),
                );
              })),
    );
  }

  Card makeCard(Prescription pp) => Card(
        elevation: 8.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(34, 78, 154, 0.886)),
          child: makeListTile(pp),
        ),
      );

  ListTile makeListTile(Prescription pp) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          pp.prescribed_by ?? "",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Expanded(
            flex: 4,
            child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(pp.start_date ?? "",
                    style: TextStyle(color: Colors.white))),
          ),
          Expanded(
            flex: 4,
            child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(pp.end_date ?? "",
                    style: TextStyle(color: Colors.white))),
          ),
        ]),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
        onTap: () {},
      );
}
