import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pill_reminder/db/medicine_helper.dart';
import 'package:pill_reminder/db/sharedpref_helper.dart';
import 'package:pill_reminder/db/timeslot_helper.dart';
import 'package:pill_reminder/model/medicine.dart';
import 'package:pill_reminder/model/timeslot.dart';
import 'package:pill_reminder/validate_helper.dart';

class AddPrescriptionStepOneWidget extends StatefulWidget {
  const AddPrescriptionStepOneWidget({super.key});

  @override
  State<AddPrescriptionStepOneWidget> createState() =>
      _AddPrescriptionStepOneState();
}

class _AddPrescriptionStepOneState extends State<AddPrescriptionStepOneWidget> {
  final _prescribedByController = TextEditingController();
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  final _consultationDateController = TextEditingController();

  int _currentStep = 0;
  int selectedMedicine = 0;
  String selectedDose = '';
  int selectedTimeslot = 0;
  int userID = 0;

  bool _validate = true;
  String validField = '', errMsg = '';
  validateFields() {
    setState(() {
      _validate = true;
      if (!ValidatorHelper.validateFields(
          _prescribedByController.text, 'TEXT_FIELD_NOT_EMPTY')) {
        _validate = false;
        validField = 'PRECRIBED';
        errMsg = "Prescribed By is required";
        _currentStep = 0;
      } else if (!ValidatorHelper.validateFields(
          _fromDateController.text, 'TEXT_FIELD_NOT_EMPTY')) {
        _validate = false;
        validField = 'STARTDATE';
        errMsg = "Start Date is required";
        _currentStep = 1;
      } else if (selectedMedicine == 0) {
        _validate = false;
        validField = 'SELECTMEDICINE';
        errMsg = "Medicine is required";
        _currentStep = 3;
      } else if (selectedDose.isEmpty) {
        _validate = false;
        validField = 'SELECTDOSE';
        errMsg = "Dose is required";
        _currentStep = 3;
      } else if (selectedTimeslot == 0) {
        _validate = false;
        validField = 'SELECTTIMESLOT';
        errMsg = "Frequency is required";
        _currentStep = 3;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      SharedPreferHelper.getData('login_session_userid')
          .then((value) => {userID = int.parse(value)});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 7, 53, 91),
          title: const Center(
            child:
                Text("Add Prescription", style: TextStyle(color: Colors.white)),
          ),
        ),
        body: Stepper(
          steps: getSteps(),
          currentStep: _currentStep,
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
              });
            }
          },
          onStepContinue: () {
            final isLastStep = _currentStep == getSteps().length - 1;
            if (isLastStep) {
              validateFields();
              if (_validate == false) return;
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(title: Text("Prescription Created"));
                  });
            } else {
              setState(() {
                _currentStep++;
              });
            }
          },
        ));
  }

  List<Step> getSteps() {
    return <Step>[
      Step(
          title: Text('Prescription Details'),
          content: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                      controller: _prescribedByController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Prescribed By",
                        errorText: !_validate && validField == "PRECRIBED"
                            ? errMsg
                            : null,
                      )))
            ],
          )),
      Step(
          title: Text('Schedule'),
          content: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                      onTap: () {
                        _presentDatePicker(_fromDateController);
                      },
                      controller: _fromDateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Start Date",
                        suffixIcon: Icon(Icons.calendar_today),
                        errorText: !_validate && validField == "STARTDATE"
                            ? errMsg
                            : null,
                      ))),
              Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                      onTap: () {
                        _presentDatePicker(_toDateController);
                      },
                      controller: _toDateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "End Date",
                        suffixIcon: Icon(Icons.calendar_today),
                      )))
            ],
          )),
      Step(
          title: Text('Next Consultation(Optional)'),
          content: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                      onTap: () {
                        _presentDatePicker(_consultationDateController);
                      },
                      controller: _consultationDateController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Consultation Date",
                        suffixIcon: Icon(Icons.calendar_today),
                      ))),
            ],
          )),
      Step(
          title: Text('Medication'),
          content: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  child: DropdownSearch<Medicine>(
                    itemAsString: (item) {
                      return item.name.toString();
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Medicine",
                        hintText: "Select Medicine",
                        errorText: !_validate && validField == "SELECTMEDICINE"
                            ? errMsg
                            : null,
                      ),
                    ),
                    onChanged: (value) {
                      selectedMedicine = value!.id ?? 0;
                    },
                    asyncItems: (filter) => getMedicine(filter),
                    compareFn: (i, s) => i.isEqual(s),
                    popupProps: PopupPropsMultiSelection.modalBottomSheet(
                      isFilterOnline: true,
                      showSelectedItems: true,
                      showSearchBox: true,
                      itemBuilder: _customPopupItemBuilderMedcine,
                    ),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: DropdownSearch<String>(
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Dose",
                      hintText: "Select Dose",
                      errorText: !_validate && validField == "SELECTDOSE"
                          ? errMsg
                          : null,
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
                  items: const [
                    '1/2 Capsule',
                    '1 Capsule',
                    '1 ML',
                    '2.5 ML',
                    '5 ML',
                    '10 ML'
                  ],
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
                        border: OutlineInputBorder(),
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
          ))
    ];
  }

  void _presentDatePicker(controller) {
    // showDatePicker is a pre-made funtion of Flutter
    DateTime currentDate = DateTime.now();
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(
                currentDate.year, currentDate.month - 1, currentDate.day),
            lastDate: DateTime(
                currentDate.year, currentDate.month + 3, currentDate.day))
        .then((pickedDate) {
      if (pickedDate != null) {
        String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);

        setState(() {
          controller.text = formattedDate;
        });
      } else {
        print("Date is not selected");
      }
    });
  }

  Widget _customPopupItemBuilderMedcine(
      BuildContext context, Medicine item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Color.fromARGB(255, 255, 255, 255),
            ),
      child: ListTile(
        onTap: () {
          setState(() {
            selectedMedicine = item.id ?? 0;
          });
        },
        selected: isSelected,
        title: Text(item.name ?? ''),
      ),
    );
  }

  Widget _customPopupItemBuilderTimeslot(
      BuildContext context, Timeslot item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Color.fromARGB(255, 255, 255, 255),
            ),
      child: makeListTile(item),
    );
  }

  ListTile makeListTile(Timeslot timeslot) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: BoxDecoration(
              border:
                  Border(right: BorderSide(width: 1.0, color: Colors.black))),
          child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Icon(Icons.timer, color: Colors.black),
              ])),
        ),
        title: Text(
          timeslot.name ?? "",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Expanded(
            flex: 4,
            child: Padding(
                padding: EdgeInsets.only(left: 10.0),
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
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                              child: Text(ele.time ?? "",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 10))))
                  ],
                )),
          ),
        ]),
        onTap: () {
          selectedTimeslot = timeslot.id ?? 0;
        },
      );

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
}
