import 'package:flutter/material.dart';
import 'package:pill_reminder/login.dart';
import 'package:pill_reminder/sql_helper.dart';

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
  
  DateTime? _selectedDate;
  void _presentDatePicker() {
    // showDatePicker is a pre-made funtion of Flutter
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2023),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if(pickedDate != null ){
                      print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); 
                      print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                      setState(() {
                         dobController.text = formattedDate; //set output date to TextField value. 
                      });
                  }else{
                      print("Date is not selected");
                  }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Pill Reminder',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w500,
                  fontSize: 30),
            )),
       
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Register User',
              style: TextStyle(fontSize: 20),
            )),
/*
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
              children: [
          // Show the Date Picker when this button clicked
          ElevatedButton(
              onPressed: _presentDatePicker, child: const Text('Select Date', style: TextStyle(fontSize: 20))),

          // display the selected date
          Container(
            padding: const EdgeInsets.all(30),
            child: Text(
              _selectedDate != null
                  ? _selectedDate.toString()
                  : 'No date selected!',
              style: const TextStyle(fontSize: 20),
            ),
          )
        ]),
  */
  
      Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
           
            controller: dobController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Date of Birth',
               icon: Icon(Icons.calendar_today,textDirection: TextDirection.rtl),
            ),
             onTap: () => {
_presentDatePicker()

             },
          ),
        ),
    
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username/Email',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: phoneNumberController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Phonenumber',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: TextField(
            obscureText: true,
            controller: passwordController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: TextField(
            obscureText: true,
            controller: confirmPasswordController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Confirm Password',
            ),
          ),
        ),
        Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              child: const Text('Register'),
              onPressed: () {
                _addUser();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginWidget()),
                );
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
                Navigator.push(
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

  Future<void> _addUser() async {
    await SQLHelper.createUser(
        usernameController.text, passwordController.text);
  }
}
