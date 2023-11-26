import 'package:flutter/material.dart';
import 'package:pill_reminder/api/api_call.dart';
import 'package:pill_reminder/db/sharedpref_helper.dart';
import 'package:pill_reminder/feedbacks.dart';
import 'package:pill_reminder/model/feedback.dart';
import 'package:pill_reminder/validate_helper.dart';

class FeedBackAddWidget extends StatefulWidget {
  const FeedBackAddWidget({super.key});

  @override
  State<FeedBackAddWidget> createState() => _FeedBackAddWidgetState();
}

class _FeedBackAddWidgetState extends State<FeedBackAddWidget> {
  TextEditingController subEditController = TextEditingController();
  TextEditingController contentEditController = TextEditingController();
  bool _validate = true;
  String validField = '', errMsg = '';
  int userID = 0;
  @override
  void initState() {
    super.initState();
    SharedPreferHelper.getData("login_session_userid").then((value) {
      setState(() {
        userID = int.parse(value);
      });
    });
  }

  validateFields() {
    setState(() {
      _validate = true;
      if (!ValidatorHelper.validateFields(
          subEditController.text, 'TEXT_FIELD_NOT_EMPTY')) {
        _validate = false;
        validField = 'SUBJECT';
        errMsg = "Subject is required";
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
            await sendFeedback();
          },
          child: const Icon(Icons.send),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    child: Text('Check Your Feedbacks'),
                    onPressed: () {},
                  )),
              Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: subEditController,
                    decoration: InputDecoration(
                      label: Text('Subject'),
                      border: OutlineInputBorder(),
                      errorText:
                          !_validate && validField == "SUBJECT" ? errMsg : null,
                    ),
                  )),
              Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: contentEditController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Content',
                      label: Text('Content'),
                      border: OutlineInputBorder(),
                    ),
                  )),
            ],
          ),
        ));
  }

  sendFeedback() async {
    FeedBack fd = FeedBack(
      subject: subEditController.text,
      content: contentEditController.text,
      userId: userID,
      createdAt: DateTime.now().toString(),
      updatedOn: DateTime.now().toString(),
    );
    await ApiCall.createFeedback(fd).then((value) async {
      if (value.statusCode == 201) {
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const FeedBacksWidget()));
      }
    });
  }
}
