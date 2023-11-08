import 'package:flutter/material.dart';

class CommonData {
  static List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Me"), value: "Me"),
      DropdownMenuItem(child: Text("Father"), value: "Father"),
      DropdownMenuItem(child: Text("Mother"), value: "Mother"),
      DropdownMenuItem(child: Text("Brother"), value: "Brother"),
      DropdownMenuItem(child: Text("Sister"), value: "Sister"),
      DropdownMenuItem(child: Text("Siblings"), value: "Siblings"),
      DropdownMenuItem(child: Text("Child"), value: "Child"),
    ];
    return menuItems;
  }
}
