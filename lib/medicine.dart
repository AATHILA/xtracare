import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pill_reminder/db/medicine_helper.dart';
import 'package:pill_reminder/medicineadd.dart';
import 'package:pill_reminder/model/medicine.dart';
import 'package:pill_reminder/medicine_edit.dart';

class MedicineWidget extends StatefulWidget {
  const MedicineWidget({super.key});

  @override
  State<StatefulWidget> createState() => _MedicineWidgetState();
}

class _MedicineWidgetState extends State<MedicineWidget> {
  List<Medicine> foundlist = [];

  @override
  void initState() {
    super.initState();
    dataRefresh();
  }

  void dataRefresh() {
    List<Medicine> tmpList = [];

    MedicineHelper.getMedicines().then((value) {
      for (var item in value) {
        tmpList.add(Medicine.fromMap(item));
      }
      setState(() {
        foundlist = tmpList;
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
                MaterialPageRoute(builder: (context) => const MedicineAddWidget()));

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
                            MedicineHelper.getMedicineByName('$search%')
                                .then((value) {
                              List<Medicine> tmpList = [];
                              for (var tmp in value) {
                                tmpList.add(Medicine.fromMap(tmp));
                              }
                              setState(() {
                                foundlist = tmpList;
                              });
                            });
                          },
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              hintText: "Search",
                              suffixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide())))),
                            foundlist.isNotEmpty?      
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: foundlist.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: makeCard(foundlist[index]),
                        );
                        }):
                      Container(
                         height: 300,
                child: Center(
                    child: const Text(
                  'No Medicines added',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        trailing:
            const Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
        onTap: () async {
          bool refresh = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => MedicineEditWidget(id: medicine.id ?? 0)));

            if (refresh) dataRefresh();},
      );
}
