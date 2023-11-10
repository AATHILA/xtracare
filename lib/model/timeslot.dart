class Timeslot {
  int? id;
  String? name;
  String? type;
  String? nooftimes;
  int? userid;
  List<TimeslotTimes>? times;
  Timeslot(
      {this.id, this.name, this.type, this.nooftimes, this.userid, this.times});
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'nooftimes': nooftimes,
      'userid': userid
    };
  }

  factory Timeslot.fromMap(Map<String, dynamic> map) {
    return Timeslot(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      nooftimes: map['nooftimes'],
      userid: int.parse(map['userid']),
      times: map['times'],
    );
  }

  isEqual(Timeslot s) {
    return s.id == this.id;
  }
}

class TimeslotTimes {
  int? id;
  String? time;
  int? timeslotid;
  TimeslotTimes({this.id, this.time, this.timeslotid});

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'timeslotid': timeslotid,
    };
  }

  factory TimeslotTimes.fromMap(Map<String, dynamic> map) {
    return TimeslotTimes(time: map['time'], timeslotid: map['timeslotid']);
  }
}
