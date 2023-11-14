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

  static List<DropdownMenuItem<String>> get dropdownTimeStotItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("DAILY"), value: "DAILY"),
      DropdownMenuItem(child: Text("EVERY"), value: "EVERY"),
    ];
    return menuItems;
  }

  static List<DropdownMenuItem<String>> get dropdownMedicineCategoryItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("PILL"), value: "PILL"),
      const DropdownMenuItem(child: Text("SOLUTION"), value: "SOLUTION"),
    ];
    return menuItems;
  }

  static List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }
}
