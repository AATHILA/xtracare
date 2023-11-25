import 'package:flutter/material.dart';
import 'package:pill_reminder/common_data.dart';
import 'package:pill_reminder/db/profile_helper.dart';
import 'package:pill_reminder/db/sharedpref_helper.dart';
import 'package:pill_reminder/model/profile.dart';
import 'package:pill_reminder/validate_helper.dart';

class EditProfileWidget extends StatefulWidget {

 final int id;

  const EditProfileWidget({super.key, required this.id});
  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  String? selectedValue;
  bool _validate = true;
  String validField = '', errMsg = '';
  Profile newpf = Profile();
  bool _loading = true;

  void validateFields() {
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
  }

  @override
  void initState() {
    super.initState();

    ProfileHelper.getProfileById(widget.id).then((value) => {
          value.forEach((element) {
            newpf = Profile.fromMap(element);
            fullNameController.text = newpf.name ?? '';
            ageController.text = newpf.age ?? '';
            selectedValue = newpf.relation ?? '';
          }),
          setState(() {
            _loading = false;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Container(child: const CircularProgressIndicator())
        : Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniEndFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                validateFields();
                if (_validate == false) return;
                await _updateProfile()
                    .then((value) => {if (value) Navigator.pop(context, true)});
              },
              child: const Icon(Icons.save),
            ),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 7, 53, 91),
              title: const Center(
                child: Text("Update Profile",
                    style: TextStyle(color: Colors.white)),
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
                                errorText:
                                    !_validate && validField == "RELATION"
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
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                          child: const Text('Activate'),
                          onPressed: () {
                            Map<String, dynamic> map = {};

                            map['active_profile'] = widget.id.toString();
                            SharedPreferHelper.saveData(map).then((value) => {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      'home', (Route<dynamic> route) => false),
                                });
                          }))
                ],
              ),
            ));
  }

  Future<bool> _updateProfile() async {
    Profile pf = Profile(
        id: widget.id,
        name: fullNameController.text.trim(),
        age: ageController.text.trim(),
        relation: selectedValue);
    await SharedPreferHelper.getData("login_session_userid").then((value) =>
        {pf.userid = int.parse(value), ProfileHelper.updateProfile(pf)});

    return Future(() => true);
  }
}
