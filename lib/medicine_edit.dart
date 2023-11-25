import 'package:flutter/material.dart';
import 'package:pill_reminder/common_data.dart';
import 'package:pill_reminder/db/medicine_helper.dart';
import 'package:pill_reminder/db/sharedpref_helper.dart';
import 'package:pill_reminder/model/medicine.dart';
import 'package:pill_reminder/validate_helper.dart';

class MedicineEditWidget extends StatefulWidget {
  final int id;
  const MedicineEditWidget({super.key,required this.id});

  @override
  State<StatefulWidget> createState() => _MedicineEditWidgetState();
}

class _MedicineEditWidgetState extends State<MedicineEditWidget> {
  String? selectedValue = "PILL";
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController sideeffectController = TextEditingController();

  bool _validate = true;
  String validField = '', errMsg = '';
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


  void initState() {
    super.initState();
    setState(() {
      SharedPreferHelper.getData("login_session_userid").then((value) {
        var userID = int.parse(value);
      });
       MedicineHelper.getMedicineById(widget.id).then((value) {
        
        Medicine mm = Medicine.fromMap(value.first);
        setState(() {
          nameController.text=mm.name!;
          descriptionController.text=mm.description!;
          sideeffectController.text=mm.side_effects!;
          selectedValue=mm.category;
        });

      });
});
  }
  Future<void> _editMedicine(BuildContext context) async {
    Medicine med = Medicine(
        id: widget.id,
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        side_effects: sideeffectController.text.trim(),
        category: selectedValue);
    await MedicineHelper.updateMedicine(med).then((value) {Navigator.pop(context, true);});

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            
            validateFields();
            if (_validate == false) return;
            await _editMedicine(context);
          },
          child: const Icon(Icons.save),
        ),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 7, 53, 91),
          title: const Center(
            child: Text("Edit Medicine", style: TextStyle(color: Colors.white)),
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
                padding:
                    const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
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
