import 'package:flutter/material.dart';
import 'package:pill_reminder/common_data.dart';
import 'package:pill_reminder/db/notification_settings_helper.dart';
import 'package:pill_reminder/db/profile_helper.dart';
import 'package:pill_reminder/db/sharedpref_helper.dart';
import 'package:pill_reminder/model/notification_settings.dart';
import 'package:pill_reminder/model/profile.dart';
import 'package:pill_reminder/validate_helper.dart';

class ProfileAddWidget extends StatefulWidget {
  const ProfileAddWidget({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileAddWidgetState();
}

class _ProfileAddWidgetState extends State<ProfileAddWidget> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  String? selectedValue;
  bool _validate = true;
  String validField = '', errMsg = '';

  void validateFields() {
    setState(() {
      _validate = true;
      if (!ValidatorHelper.validateFields(
          fullNameController.text, 'TEXT_FIELD_NOT_EMPTY')) {
        _validate = false;
        validField = 'FULL';
        errMsg = "Full Name is required";
      } else if (!ValidatorHelper.validateFields(
          ageController.text, 'TEXT_FIELD_NOT_EMPTY')) {
        _validate = false;
        validField = 'LAST';
        errMsg = "Last Name is required";
      } else if (!ValidatorHelper.validateFields(
          selectedValue ?? '', 'TEXT_FIELD_NOT_EMPTY')) {
        _validate = false;
        validField = 'RELATION';
        errMsg = "Relation is required";
      }
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
            await _addProfile()
                .then((value) => {if (value) Navigator.pop(context, true)});
          },
          child: const Icon(Icons.save),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text("Add Profile", style: TextStyle(color: Colors.black)),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Full Name',
                    errorText:
                        !_validate && validField == "FULL" ? errMsg : null,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: ageController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Age',
                    errorText:
                        !_validate && validField == "AGE" ? errMsg : null,
                  ),
                  keyboardType: TextInputType.number,
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
                            hintText: 'Select Relation',
                            errorText: !_validate && validField == "RELATION"
                                ? errMsg
                                : null,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        isEmpty: selectedValue == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                              value: selectedValue,
                              isDense: true,
                              onChanged: (value) => {
                                    selectedValue = value,
                                    state.didChange(value)
                                  },
                              items: CommonData.dropdownItems),
                        ),
                      );
                    },
                  )),
            ],
          ),
        ));
  }

  Future<bool> _addProfile() async {
    Profile pf = Profile(
        name: fullNameController.text.trim(),
        age: ageController.text.trim(),
        relation: selectedValue);
    await SharedPreferHelper.getData("login_session_userid").then((value) => {
          pf.userid = int.parse(value),
          ProfileHelper.createProfile(pf).then((profid) {
            NotificationSettings notification = NotificationSettings(
                snooze: 10, alarmSound: 'alarm1', profileId: profid);
            NotificationSettingsHelper.createNotitificationSettings(
                notification);
          })
        });

    return Future(() => true);
  }
}
