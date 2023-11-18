import 'package:flutter/material.dart';

class CommonData {
  static List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Me", child: Text("Me")),
      const DropdownMenuItem(value: "Father", child: Text("Father")),
      const DropdownMenuItem(value: "Mother", child: Text("Mother")),
      const DropdownMenuItem(value: "Brother", child: Text("Brother")),
      const DropdownMenuItem(value: "Sister", child: Text("Sister")),
      const DropdownMenuItem(value: "Siblings", child: Text("Siblings")),
      const DropdownMenuItem(value: "Child", child: Text("Child")),
    ];
    return menuItems;
  }

  static List<DropdownMenuItem<String>> get dropdownTimeStotItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "DAILY", child: Text("DAILY")),
      const DropdownMenuItem(value: "EVERY", child: Text("EVERY")),
    ];
    return menuItems;
  }

  static List<DropdownMenuItem<String>> get dropdownMedicineCategoryItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "PILL", child: Text("PILL")),
      const DropdownMenuItem(value: "SOLUTION", child: Text("SOLUTION")),
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
