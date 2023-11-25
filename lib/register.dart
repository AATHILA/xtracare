import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pill_reminder/api/api_call.dart';
import 'package:pill_reminder/db/notification_settings_helper.dart';
import 'package:pill_reminder/db/profile_helper.dart';
import 'package:pill_reminder/db/user_helper.dart';
import 'package:pill_reminder/login.dart';
import 'package:pill_reminder/model/notification_settings.dart';
import 'package:pill_reminder/model/profile.dart';
import 'package:pill_reminder/model/table_sequence.dart';
import 'package:pill_reminder/model/user.dart';
import 'package:pill_reminder/validate_helper.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  //CalendarDatePicker dateOffBirth= CalendarDatePicker(initialDate: initialDate, firstDate: firstDate, lastDate: lastDate, onDateChanged: onDateChanged);
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  bool _validate = true;
  bool _hidePass = true;
  String validField = '', errMsg = '';

  void validateFields() {
    setState(() {
      _validate = true;
      if (!ValidatorHelper.validateFields(
          firstNameController.text, 'TEXT_FIELD_NOT_EMPTY')) {
        _validate = false;
        validField = 'FIRST';
        errMsg = "First Name is required";
      } else if (!ValidatorHelper.validateFields(
          lastNameController.text, 'TEXT_FIELD_NOT_EMPTY')) {
        _validate = false;
        validField = 'LAST';
        errMsg = "Last Name is required";
      } else if (!ValidatorHelper.validateFields(
          dobController.text, 'TEXT_FIELD_NOT_EMPTY')) {
        _validate = false;
        validField = 'DOB';
        errMsg = "Date of Birth is required";
      } else if (!ValidatorHelper.validateFields(
          usernameController.text, 'TEXT_FIELD_NOT_EMPTY')) {
        _validate = false;
        validField = 'USERNAME';
        errMsg = "Username/Email is required";
      } else if (!ValidatorHelper.validateFields(
          usernameController.text, 'EMAIL')) {
        _validate = false;
        validField = 'USERNAME';
        errMsg = "Username/Email is invalid";
      } else if (!ValidatorHelper.validateFields(
          phoneNumberController.text, 'TEXT_FIELD_NOT_EMPTY')) {
        _validate = false;
        validField = 'PHONE';
        errMsg = "PhoneNumber is required";
      } else if (!ValidatorHelper.validateFields(
          phoneNumberController.text, 'TEXT_FIELD_NOT_EMPTY')) {
        _validate = false;
        validField = 'PASS';
        errMsg = "Password is required";
      } else if (!ValidatorHelper.validateFields(
          phoneNumberController.text, 'TEXT_FIELD_NOT_EMPTY')) {
        _validate = false;
        validField = 'CONFIRMPASS';
        errMsg = "Confirm Password is required";
      } else if (passwordController.text != confirmPasswordController.text) {
        _validate = false;
        validField = 'CONFIRMPASS';
        errMsg = "Confirm Password not match with password";
      }
    });
  }

  void _presentDatePicker() {
    // showDatePicker is a pre-made funtion of Flutter
    showDatePicker(
            context: context,
            initialDate: DateTime(DateTime.now().year - 18),
            firstDate: DateTime(DateTime.now().year - 80),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate != null) {
        String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
        print(
            formattedDate); //formatted date output using intl package =>  2021-03-16
        //you can implement different kind of Date Format here according to your requirement

        setState(() {
          dobController.text =
              formattedDate; //set output date to TextField value.
        });
      } else {
        print("Date is not selected");
      }
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  final focus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/xtracare.png'),
                  ),
                ))),
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Register User',
              style: TextStyle(fontSize: 20),
            )),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: firstNameController,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            autofocus: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'First Name',
              errorText: !_validate && validField == "FIRST" ? errMsg : null,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: lastNameController,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Last Name',
              errorText: !_validate && validField == "LAST" ? errMsg : null,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            readOnly: true,
            controller: dobController,
            focusNode: focus,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Date of Birth',
              errorText: !_validate && validField == "DOB" ? errMsg : null,
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            onTap: () => {_presentDatePicker()},
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: usernameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Username/Email',
              errorText: !_validate &&
                      (validField == "USERNAME" ||
                          validField == "USERNAME_EXIST")
                  ? errMsg
                  : null,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: phoneNumberController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Phonenumber',
              errorText: !_validate && validField == "PHONE" ? errMsg : null,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: TextField(
            obscureText: _hidePass,
            controller: passwordController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Password',
                errorText: !_validate && validField == "PASS" ? errMsg : null,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _hidePass = !_hidePass;
                      });
                    },
                    icon: Icon(
                        _hidePass ? Icons.visibility_off : Icons.visibility))),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: TextField(
            obscureText: true,
            textInputAction: TextInputAction.next,
            controller: confirmPasswordController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Confirm Password',
              errorText:
                  !_validate && validField == "CONFIRMPASS" ? errMsg : null,
            ),
          ),
        ),
        Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              child: const Text('Register'),
              onPressed: () {
                validateFields();
                if (_validate == false) return;
                _addUser(context);
              },
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Already have account?'),
            TextButton(
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginWidget()),
                );
              },
            )
          ],
        ),
      ],
    ));
  }

  Future<void> _addUser(BuildContext context) async {
    User newUser = User(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      username: usernameController.text.trim(),
      dob: dobController.text.trim(),
      password: passwordController.text.trim(),
      phonenumber: phoneNumberController.text.trim(),
    );

    await ApiCall.signUp(newUser).then((userData) {
      if (userData.statusCode == 201) {
        Map<String, dynamic> userMap = jsonDecode(userData.body);
        User user = User.fromJson(userMap);

        DateTime currentDate = DateTime.now();
        DateFormat format = DateFormat("dd/MM/yyyy");
        DateTime dateOfBirth = format.parse(dobController.text.trim());

        int age = currentDate.year - dateOfBirth.year;
        Profile newProf = Profile(
            name: "${firstNameController.text} ${lastNameController.text}",
            age: age.toString(),
            relation: "Me");

        Future<int> userId = UserHelper.createUser(user);
        userId.then((value) async {
          newProf.userid = value;
          await ProfileHelper.createProfile(newProf).then((profileId) async {
            NotificationSettings newStt = NotificationSettings(
                profileId: profileId, snooze: 10, alarmSound: 'alarm1');
            NotificationSettingsHelper.createNotitificationSettings(newStt);

            TableSequence tableSequence = TableSequence(
                tableName: 'medicine', currentValue: 1, userId: value);
            await ApiCall.createSequence(tableSequence);
          });

          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginWidget()),
            );
          }
        });
      } else if (userData.statusCode == 302) {
        setState(() {
          _validate = false;
          validField = 'USERNAME_EXIST';
          errMsg = "Username already registered";
        });
      }
    });
  }
}
