class Schedules {
  int? id;

  String? scheduleDate;
  String? time;
  int? snooze;
  int? profileId;
  String? scheduleStatus;

  Schedules(
      {this.id,
      this.scheduleDate,
      this.time,
      this.snooze,
      this.profileId,
      this.scheduleStatus});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'schedule_date': scheduleDate,
      'time': time,
      'snooze': snooze,
      'profile_id': profileId,
      'schedule_status': scheduleStatus
    };
  }

  factory Schedules.fromMap(Map<String, dynamic> map) {
    return Schedules(
      id: map['id'],
      scheduleDate: map['schedule_date'],
      time: map['time'],
      snooze: map['snooze'],
      profileId: map['profile_id'],
      scheduleStatus: map['schedule_status'],
    );
  }
}

class ScheduleItem {
  int? id;
  int? schedulesId;
  int? medicationId;
  String? status;

  ScheduleItem({this.id, this.schedulesId, this.medicationId, this.status});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'schedules_id': schedulesId,
      'medication_id': medicationId,
      'status': status
    };
  }

  factory ScheduleItem.fromMap(Map<String, dynamic> map) {
    return ScheduleItem(
      id: map['id'],
      schedulesId: map['schedules_id'],
      medicationId: map['medication_id'],
      status: map['status'],
    );
  }
}
