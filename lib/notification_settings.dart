import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pill_reminder/common_data.dart';
import 'package:pill_reminder/db/notification_settings_helper.dart';
import 'package:pill_reminder/db/sharedpref_helper.dart';
import 'package:pill_reminder/model/notification_settings.dart';
import 'package:pill_reminder/validate_helper.dart';

class NotificationSettingsWidget extends StatefulWidget {
  const NotificationSettingsWidget({super.key});

  @override
  State<StatefulWidget> createState() => NotificationSettingsState();
}

class NotificationSettingsState extends State<NotificationSettingsWidget> {
  TextEditingController editSnoozeController = TextEditingController();
  String? selectedValue = "alarm1";
  NotificationSettings nt = NotificationSettings();
  bool _validate = true;
  int profileId = 0;
  String validField = '', errMsg = '';
  validateFields() {
    setState(() {
      _validate = true;
      if (!ValidatorHelper.validateFields(
          editSnoozeController.text, 'TEXT_FIELD_NOT_EMPTY')) {
        _validate = false;
        validField = 'SNOOZE';
        errMsg = "Snooze is required";
      } else if (!ValidatorHelper.validateFields(
          selectedValue ?? '', 'TEXT_FIELD_NOT_EMPTY')) {
        _validate = false;
        validField = 'SOUND';
        errMsg = "Alram sound is required";
      }
    });
  }

  @override
  void initState() {
    super.initState();

    SharedPreferHelper.getData('active_profile').then((value) async {
      profileId = int.parse(value);
      await NotificationSettingsHelper.getNotificationByprofileid(profileId)
          .then((listNt) {
        setState(() {
          nt = NotificationSettings.fromMap(listNt.first);

          editSnoozeController.text = nt.snooze.toString();

          selectedValue = nt.alarmSound;
        });
      });
    });
  }

  Future<void> _editNotificationSettings(BuildContext context) async {
    nt.snooze = int.parse(editSnoozeController.text);
    nt.alarmSound = selectedValue;
    await NotificationSettingsHelper.updateNotitificationSettings(nt);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(title: Text("Notification Settings Saved"));
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
            await _editNotificationSettings(context);
          },
          child: const Icon(Icons.save),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    controller: editSnoozeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Snooze Time',
                        hintText: 'Snooze Time in minutes',
                        errorText: !_validate && validField == "SOOZE"
                            ? errMsg
                            : null),
                  ),
                ],
              )),
          Container(
            padding: const EdgeInsets.all(10),
            child: DropdownSearch<String>(
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Alarm Sound",
                  hintText: "Select Sound",
                  errorText:
                      !_validate && validField == "SOUND" ? errMsg : null,
                ),
              ),
              onChanged: (value) {
                selectedValue = value ?? '';
              },
              popupProps: const PopupPropsMultiSelection.modalBottomSheet(
                showSelectedItems: true,
              ),
              items: const ['alarm1', 'alarm2', 'alarm3'],
              selectedItem: selectedValue,
            ),
          ),
        ])));
  }
}
