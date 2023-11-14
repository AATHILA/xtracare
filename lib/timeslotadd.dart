import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pill_reminder/common_data.dart';
import 'package:pill_reminder/db/sharedpref_helper.dart';
import 'package:pill_reminder/db/timeslot_helper.dart';
import 'package:pill_reminder/model/timeslot.dart';
import 'package:pill_reminder/validate_helper.dart';

class TimeSlotAddWidget extends StatefulWidget {
  const TimeSlotAddWidget({super.key});
  @override
  State<StatefulWidget> createState() => _TimeSlotAddWidgetState();
}

class _TimeSlotAddWidgetState extends State<TimeSlotAddWidget> {
  String? selectedValue = null;
  bool _validate = true;
  bool _enabled = false;
  int userID = 0;

  String validField = '', errMsg = '';

  TextEditingController timeslotNameController = TextEditingController();
  TextEditingController timeslotNDayController = TextEditingController();

  final List<TextEditingController> times = [];
  DateFormat dateFormat = DateFormat("hh:mm aa");
  Future<void> _show(i) async {
    final TimeOfDay? result = await showTimePicker(
        context: context,
        initialTime: times[i].text.isNotEmpty
            ? TimeOfDay.fromDateTime(dateFormat.parse(times[i].text))
            : TimeOfDay.now());
    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    if (result != null) {
      String formattedTime =
          localizations.formatTimeOfDay(result, alwaysUse24HourFormat: false);
      if (formattedTime != null) {
        setState(() {
          times[i].text = dateFormat.format(dateFormat.parse(formattedTime));
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      SharedPreferHelper.getData("login_session_userid").then((value) {
        userID = int.parse(value);
      });

      selectedValue = "DAILY";
      timeslotNDayController.text = "1";
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _addTime();
      });
    });
  }

  _addTime() {
    setState(() {
      if (times.length <= 4) {
        times.add(TextEditingController());
      }
    });
  }

  _removeTime(i) {
    setState(() {
      if (times.length > 1) {
        times.removeAt(i);
      }
    });
  }

  validateFields() {
    setState(() {
      _validate = true;
      if (!ValidatorHelper.validateFields(
          timeslotNameController.text, 'TEXT_FIELD_NOT_EMPTY')) {
        _validate = false;
        validField = 'TIMESLOTNAME';
        errMsg = "Time Slot Name is required";
      } else if (!ValidatorHelper.validateFields(
          timeslotNDayController.text, 'TEXT_FIELD_NOT_EMPTY')) {
        _validate = false;
        validField = 'TIMESLOTDAY';
        errMsg = "Days is required";
      } else if (!ValidatorHelper.validateFields(
          selectedValue ?? '', 'TEXT_FIELD_NOT_EMPTY')) {
        _validate = false;
        validField = 'REPEAT';
        errMsg = "Repeat is required";
      } else {
        for (int i = 0; i < times.length; i++) {
          if (!ValidatorHelper.validateFields(
              times[i].text ?? '', 'TEXT_FIELD_NOT_EMPTY')) {
            _validate = false;
            validField = 'TIME${i}';
            errMsg = "Time is required";
            break;
          }
        }
      }
    });
  }

  Future<void> _addTiming() async {
    Timeslot newtime = Timeslot(
        name: timeslotNameController.text.trim(),
        type: selectedValue,
        nooftimes: timeslotNDayController.text.trim(),
        userid: userID);
    TimeSlotHelper.createTimeslot(newtime).then((value) {
      for (int i = 0; i < times.length; i++) {
        TimeslotTimes timeslots =
            TimeslotTimes(time: times[i].text, timeslotid: value);
        TimeSlotTimesHelper.createTimeslot(timeslots);
      }
    });

    Navigator.pop(context, true);
  }

  @override
  Widget build(Object context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            validateFields();
            if (_validate == false) return;
            await _addTiming();
          },
          child: Icon(Icons.save),
        ),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 7, 53, 91),
          title: const Center(
            child: Text("Add Timeslot", style: TextStyle(color: Colors.white)),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Column(children: <Widget>[
          Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: timeslotNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Time Slot Name',
                  errorText: !_validate && validField == "TIMESLOTNAME"
                      ? errMsg
                      : null,
                ),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                  child: Container(
                padding:
                    EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
                child: FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                              color: Colors.redAccent, fontSize: 16.0),
                          hintText: 'Select Occurance',
                          errorText: !_validate && validField == "REPEAT"
                              ? errMsg
                              : null,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      isEmpty: selectedValue == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            value: selectedValue,
                            isDense: true,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value;
                                state.didChange(value);
                                if (value == "DAILY") {
                                  timeslotNDayController.text = "1";
                                  _enabled = false;
                                } else {
                                  _enabled = true;
                                }
                              });
                            },
                            items: CommonData.dropdownTimeStotItems),
                      ),
                    );
                  },
                ),
              )),
              Flexible(
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        enabled: _enabled,
                        controller: timeslotNDayController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Days',
                          errorText: !_validate && validField == "TIMESLOTDAY"
                              ? errMsg
                              : null,
                        ),
                      )))
            ],
          ),
          Divider(thickness: 1),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Timings"),
            Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.centerRight,
              child: InkWell(child: Icon(Icons.add), onTap: () => {_addTime()}),
            )
          ]),
          for (int i = 0; i < times.length; i++)
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Flexible(
                  child: Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  readOnly: true,
                  controller: times[i],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Select Time',
                    suffixIcon: Icon(Icons.timer),
                    errorText:
                        !_validate && validField == "TIME${i}" ? errMsg : null,
                  ),
                  onTap: () => {_show(i)},
                ),
              )),
              Container(
                  child: Container(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                    child: Icon(Icons.delete), onTap: () => {_removeTime(i)}),
              ))
            ])
        ]))));
  }
}
