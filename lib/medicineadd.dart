import 'package:flutter/material.dart';
import 'package:pill_reminder/common_data.dart';
import 'package:pill_reminder/db/medicine_helper.dart';
import 'package:pill_reminder/db/sequence_helper.dart';
import 'package:pill_reminder/db/sharedpref_helper.dart';
import 'package:pill_reminder/model/medicine.dart';
import 'package:pill_reminder/model/table_sequence.dart';
import 'package:pill_reminder/validate_helper.dart';

class MedicineAddWidget extends StatefulWidget {
  const MedicineAddWidget({super.key});

  @override
  State<StatefulWidget> createState() => _MedicineAddWidgetState();
}

class _MedicineAddWidgetState extends State<MedicineAddWidget> {
  String? selectedValue = "PILL";
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController sideeffectController = TextEditingController();

  bool _validate = true;
  String validField = '', errMsg = '';
  int userID = 0;
  validateFields() {
    setState(() {
      _validate = true;
      if (!ValidatorHelper.validateFields(
          nameController.text, 'TEXT_FIELD_NOT_EMPTY')) {
        _validate = false;
        validField = 'NAME';
        errMsg = "Name is required";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    SharedPreferHelper.getData("login_session_userid").then((value) {
      setState(() {
        userID = int.parse(value);
      });
    });
  }

  Future<void> _addMedicine() async {
    await SequenceHelper.getSequence('medicine', userID)
        .then((medicineId) async {
      Medicine med = Medicine(
          id: medicineId,
          name: nameController.text.trim(),
          description: descriptionController.text.trim(),
          sideEffects: sideeffectController.text.trim(),
          category: selectedValue);
      await MedicineHelper.createMedicine(med);
    });
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            validateFields();
            if (_validate == false) return;
            await _addMedicine();
          },
          child: const Icon(Icons.save),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text("Add Medicine", style: TextStyle(color: Colors.black)),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Name',
                  errorText: !_validate && validField == "NAME" ? errMsg : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Description',
                  errorText: !_validate && validField == "DESC" ? errMsg : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextField(
                controller: sideeffectController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Side Effects',
                  errorText:
                      !_validate && validField == "SIDEEFFECT" ? errMsg : null,
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.only(
                    left: 10, top: 10, bottom: 10, right: 10),
                child: FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                          errorStyle: const TextStyle(
                              color: Colors.redAccent, fontSize: 16.0),
                          hintText: 'Select',
                          errorText: !_validate && validField == "CATEGORY"
                              ? errMsg
                              : null,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      isEmpty: selectedValue == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            value: selectedValue,
                            isDense: true,
                            onChanged: (value) =>
                                {selectedValue = value, state.didChange(value)},
                            items: CommonData.dropdownMedicineCategoryItems),
                      ),
                    );
                  },
                )),
          ],
        ));
  }
}
