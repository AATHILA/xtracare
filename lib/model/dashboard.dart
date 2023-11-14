class Dashboard {
  int? id;
  String? date;

  String? time;

  List<DashboardItem>? items;

  Dashboard({this.id, this.date, this.time, this.items});

  Map<String, dynamic> toMap() {
    return {'id': id, 'date': date, 'time': time, 'items': items};
  }

  factory Dashboard.fromMap(Map<String, dynamic> map) {
    return Dashboard(
      id: map['id'],
      date: map['date'],
      time: map['time'],
      items: map['items'],
    );
  }
}

class DashboardItem {
  String? name;
  String? dose;
  String? status;

  DashboardItem({this.name, this.dose, this.status});
  Map<String, dynamic> toMap() {
    return {'name': name, 'dose': dose, 'status': status};
  }

  factory DashboardItem.fromMap(Map<String, dynamic> map) {
    return DashboardItem(
        name: map['name'], dose: map['dose'], status: map['status']);
  }
}
