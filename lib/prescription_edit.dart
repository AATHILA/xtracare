import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pill_reminder/db/prescription_helper.dart';
import 'package:pill_reminder/model/prescription.dart';

class PrescriptionEditWidget extends StatefulWidget {
  final int id;
  const PrescriptionEditWidget({super.key, required this.id});

  @override
  State<PrescriptionEditWidget> createState() => _PrescriptionEditWidgetState();
}

class _PrescriptionEditWidgetState extends State<PrescriptionEditWidget> {
  final _prescribedByController = TextEditingController();
  String validField = '', errMsg = '';
  bool _validate = true;
  Prescription prescription = Prescription();
  bool _loading = true;
  @override
  void initState() {
    super.initState();

    PrescriptionHelper.prescriptionByIdList(widget.id).then((value) {
      setState(() {
        prescription = value;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Center(
            child: Text("Edit Prescription",
                style: TextStyle(color: Colors.white)),
          ),
        ),
        body: _loading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Column(children: [
                    Card(
                        child: Container(
                            child: Column(children: [
                      Container(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Column(children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: const Text(
                                  "Prescribed By",
                                  style: TextStyle(fontSize: 10),
                                )),
                            Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 7),
                                child: Text(
                                  prescription.prescribed_by!,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ))
                          ])),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Column(children: [
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: const Text("Start Date",
                                          style: TextStyle(fontSize: 10))),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(left: 7),
                                      child: Text(
                                        prescription.start_date!,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ])),
                            const Spacer(),
                            Container(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Column(children: [
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: const Text(
                                        "End Date",
                                        style: TextStyle(fontSize: 10),
                                      )),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(left: 7),
                                      child: Text(
                                        prescription.end_date!,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ])),
                          ]),
                    ]))),
                    Container(
                      child: Column(
                        children: [
                          Card(
                              child: Container(
                                  child: Column(children: [
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Text("Medications",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Container(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: prescription.medications!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        child: makeListTile(
                                            prescription.medications![index]),
                                      );
                                    })),
                          ]))),
                        ],
                      ),
                    ),
                    Container(),
                  ]),
                ),
              ));
  }

  ListTile makeListTile(Medication medication) => ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        title: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Card(
                color: Colors.black,
                child: Column(
                  children: [
                    Container(
                        padding:
                            const EdgeInsets.only(top: 10, bottom: 10, left: 5),
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
                                        medication.medicine!.name) ??
                                    '',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontWeight: FontWeight.bold),
                              ))
                        ])),
                    Row(children: [
                      Container(
                          padding: const EdgeInsets.only(left: 35, bottom: 4),
                          child: Text(
                            toBeginningOfSentenceCase(medication.dose) ?? '',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold),
                          )),
                      const Spacer(),
                      Container(
                          padding: const EdgeInsets.only(right: 15, bottom: 4),
                          child: Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.only(right: 3),
                                  child: Icon(MfgLabs.bell,
                                      size: 12, color: Colors.grey)),
                              Text(
                                toBeginningOfSentenceCase(
                                        medication.timeslot!.name) ??
                                    '',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ))
                    ]),
                    const Divider(
                      color: Colors.white,
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.topRight,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Wrap(
                                    alignment: WrapAlignment.spaceBetween,
                                    direction: Axis.horizontal,
                                    children: <Widget>[
                                      for (var ele
                                          in medication.timeslot!.times!)
                                        Container(
                                            child: Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        5, 5, 0, 0),
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              253,
                                                              254,
                                                              255)),
                                                ),
                                                child: Text(ele.time ?? "",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 9))))
                                    ],
                                  )),
                            ),
                          ]),
                    )
                  ],
                ),
              ))
        ]),
        onTap: () async {},
      );
}
