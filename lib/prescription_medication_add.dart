import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pill_reminder/common_data.dart';
import 'package:pill_reminder/db/medicine_helper.dart';
import 'package:pill_reminder/db/prescription_helper.dart';
import 'package:pill_reminder/db/schedules_helper.dart';
import 'package:pill_reminder/db/sharedpref_helper.dart';
import 'package:pill_reminder/db/timeslot_helper.dart';
import 'package:pill_reminder/model/medicine.dart';
import 'package:pill_reminder/model/prescription.dart';
import 'package:pill_reminder/model/schedules.dart';
import 'package:pill_reminder/model/timeslot.dart';
import 'package:pill_reminder/notification_helper.dart';

class AddMedicationWidget extends StatefulWidget {
  final int id;
  const AddMedicationWidget({super.key, required this.id});

  @override
  State<AddMedicationWidget> createState() => _AddMedicationWidgetState();
}

class _AddMedicationWidgetState extends State<AddMedicationWidget> {
  String selectedMedicine = '';
  String selectedDose = '';
  int selectedTimeslot = 0;
  int userID = 0;
  int profile_id = 0;
  bool _validate = true;
  String validField = '', errMsg = '';
  DateFormat format = DateFormat("dd/MM/yyyy");

  validateFields() {
    setState(() {
      _validate = true;
      if (selectedMedicine == 0) {
        _validate = false;
        validField = 'SELECTMEDICINE';
        errMsg = "Medicine is required";
      } else if (selectedDose.isEmpty) {
        _validate = false;
        validField = 'SELECTDOSE';
        errMsg = "Dose is required";
      } else if (selectedTimeslot == 0) {
        _validate = false;
        validField = 'SELECTTIMESLOT';
        errMsg = "Frequency is required";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      SharedPreferHelper.getData('login_session_userid')
          .then((value) => {userID = int.parse(value)});
      SharedPreferHelper.getData('active_profile')
          .then((value) => {profile_id = int.parse(value)});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          validateFields();
          if (_validate == false) return;
          await _addMedication();
        },
        child: const Icon(Icons.save),
      ),
      appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Container(
              alignment: Alignment.topLeft, child: Text('Add Medication'))),
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              child: DropdownSearch<Medicine>(
                  itemAsString: (item) {
                    return item.name.toString();
                  },
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Medicine",
                      hintText: "Select Medicine",
                      errorText: !_validate && validField == "SELECTMEDICINE"
                          ? errMsg
                          : null,
                    ),
                  ),
                  onChanged: (value) {
                    selectedMedicine = value!.id ?? '';
                  },
                  asyncItems: (filter) => getMedicine(filter),
                  compareFn: (i, s) => i.isEqual(s),
                  popupProps: PopupPropsMultiSelection.modalBottomSheet(
                    isFilterOnline: true,
                    showSelectedItems: true,
                    showSearchBox: true,
                    itemBuilder: _customPopupItemBuilderMedcine,
                  ))),
          Container(
            padding: const EdgeInsets.all(10),
            child: DropdownSearch<String>(
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Dose",
                  hintText: "Select Dose",
                  errorText:
                      !_validate && validField == "SELECTDOSE" ? errMsg : null,
                ),
              ),
              onChanged: (value) {
                selectedDose = value ?? '';
              },
              popupProps: const PopupPropsMultiSelection.modalBottomSheet(
                isFilterOnline: true,
                showSelectedItems: true,
                showSearchBox: true,
              ),
              items: CommonData.doseList,
              selectedItem: selectedDose,
            ),
          ),
          Container(
              padding: const EdgeInsets.all(10),
              child: DropdownSearch<Timeslot>(
                itemAsString: (item) {
                  return item.name.toString();
                },
                onChanged: (value) {
                  selectedTimeslot = value!.id ?? 0;
                },
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Frequency",
                    hintText: "Select Frequency",
                    errorText: !_validate && validField == "SELECTTIMESLOT"
                        ? errMsg
                        : null,
                  ),
                ),
                asyncItems: (filter) => getTimeslot(filter),
                compareFn: (i, s) => i.isEqual(s),
                popupProps: PopupPropsMultiSelection.modalBottomSheet(
                  isFilterOnline: true,
                  showSelectedItems: true,
                  showSearchBox: true,
                  itemBuilder: _customPopupItemBuilderTimeslot,
                ),
              )),
        ],
      ),
    );
  }

  Future<List<Medicine>> getMedicine(filter) async {
    List<Medicine> dt = [];
    await MedicineHelper.getMedicineByName(filter + '%').then((value) => {
          for (var it in value) {dt.add(Medicine.fromMap(it))}
        });
    return dt;
  }

  Future<List<Timeslot>> getTimeslot(filter) async {
    List<Timeslot> dt = [];
    await TimeSlotHelper.queryAll(userID).then((value) => {
          for (var it in value) {dt.add(it)}
        });
    return dt;
  }

  Widget _customPopupItemBuilderTimeslot(
      BuildContext context, Timeslot item, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
      child: makeListTile(item),
    );
  }

  ListTile makeListTile(Timeslot timeslot) => ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: const EdgeInsets.only(right: 12.0),
          decoration: const BoxDecoration(
              border:
                  Border(right: BorderSide(width: 1.0, color: Colors.black))),
          child: Container(
              child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Icon(Icons.timer, color: Colors.black),
              ])),
        ),
        title: Text(
          timeslot.name ?? "",
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                                    width: 2,
                                    color: const Color.fromARGB(255, 0, 0, 0)),
                              ),
                              child: Text(ele.time ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 10))))
                  ],
                )),
          ),
        ]),
        onTap: () {
          selectedTimeslot = timeslot.id ?? 0;
        },
      );

  Widget _customPopupItemBuilderMedcine(
      BuildContext context, Medicine item, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
      child: ListTile(
        onTap: () {
          setState(() {
            selectedMedicine = item.id ?? '';
          });
        },
        selected: isSelected,
        title: Text(item.name ?? ''),
      ),
    );
  }

  _addMedication() async {
    Medication newMed = Medication(
        prescription_id: widget.id,
        timeslot_id: selectedTimeslot,
        dose: selectedDose,
        medicine_id: selectedMedicine);
    Prescription prescription = Prescription();

    await PrescriptionHelper.getPrescriptionByid(widget.id).then((value) {
      prescription = Prescription.fromMap(value.first);
    });
    await MedicationHelper.createMedication(newMed).then((md) async {
      DateTime startDate = format.parse(prescription.start_date!);
      DateTime endDate = format.parse(prescription.end_date!);

      List<DateTime> dates = CommonData.getDaysInBetween(startDate, endDate);

      for (var dt in dates) {
        await TimeSlotTimesHelper.getTimeSlotById(newMed.timeslot_id ?? 0)
            .then((timeslots) async {
          for (var timestr in timeslots) {
            await SchedulesHelper.getSchedulr(format.format(dt),
                    TimeslotTimes.fromMap(timestr).time ?? '', profile_id)
                .then((schedule1) async {
              if (schedule1.isNotEmpty) {
                int sid = 0;

                sid = schedule1.first['id'];

                ScheduleItem sti = ScheduleItem(
                    schedulesId: sid, medicationId: md, status: 'PENDING');
                await SchedulesItemHelper.createScheduleItems(sti);
                await SchedulesHelper.updateSchedulePending(sid);
              } else {
                Schedules sttt = Schedules(
                    time: TimeslotTimes.fromMap(timestr).time,
                    scheduleDate: format.format(dt),
                    snooze: 0,
                    profileId: profile_id,
                    scheduleStatus: 'PENDING');
                await SchedulesHelper.createSchedule(sttt).then((sss) async {
                  ScheduleItem sti = ScheduleItem(
                      schedulesId: sss, medicationId: md, status: 'PENDING');
                  await SchedulesItemHelper.createScheduleItems(sti);
                });
              }
              NotificationService().scheduleNotification();
            });
          }
        });
      }

      Navigator.pop(context, true);
    });
  }
}
