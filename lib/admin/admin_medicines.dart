import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pill_reminder/admin/admin_medicine_add.dart';
import 'package:pill_reminder/admin/admin_medicine_edit.dart';
import 'package:pill_reminder/api/api_call.dart';
import 'package:pill_reminder/model/medicine.dart';

class AdminMedicineWidget extends StatefulWidget {
  const AdminMedicineWidget({super.key});

  @override
  State<StatefulWidget> createState() => _AdminMedicineWidgetState();
}

class _AdminMedicineWidgetState extends State<AdminMedicineWidget> {
  List<Medicine> foundlist = [];

  @override
  void initState() {
    super.initState();
    dataRefresh();
  }

  void dataRefresh() {
    List<Medicine> tmpList = [];

    ApiCall.getMedicinesSearch().then((list) {
      jsonDecode(list.body);
      Iterable l = json.decode(list.body);
      List<Medicine> medicines =
          List<Medicine>.from(l.map((model) => Medicine.fromJson(model)));
      setState(() {
        foundlist = medicines;
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
                    builder: (context) => const AdminMedicineAddWidget()));

            if (refresh) dataRefresh();
          },
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                          onChanged: (search) {
                            /* MedicineHelper.getMedicineByName('$search%')
                                .then((value) {
                              List<Medicine> tmpList = [];
                              for (var tmp in value) {
                                tmpList.add(Medicine.fromMap(tmp));
                              }
                              setState(() {
                                foundlist = tmpList;
                              });
                            });*/
                          },
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              hintText: "Search",
                              suffixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide())))),
                  foundlist.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: foundlist.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: makeCard(foundlist[index]),
                            );
                          })
                      : Container(
                          height: 300,
                          child: Center(
                              child: const Text(
                            'No Medicines added',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )))
                ]))));
  }

  Card makeCard(Medicine medicine) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: const BoxDecoration(
              border: Border(
                  right: BorderSide(
                      width: 1.0, color: Color.fromARGB(59, 246, 238, 238)))),
          child: makeListTile(medicine),
        ),
      );

  ListTile makeListTile(Medicine medicine) => ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
                Icon(
                    medicine.category == 'PILL'
                        ? Icons.medication
                        : Icons.medication_liquid,
                    color: Colors.black),
              ])),
        ),
        title: Text(
          toBeginningOfSentenceCase(medicine.name) ?? "",
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.keyboard_arrow_right,
            color: Colors.white, size: 30.0),
        onTap: () async {
          bool refresh = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AdminMedicineEditWidget(id: medicine.id!)));

          if (refresh) dataRefresh();
        },
      );
}
