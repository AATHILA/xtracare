class NotificationSettings {
  int? id;
  int? profileId;
  int? snooze;
  String? alarmSound;

  NotificationSettings({this.id, this.profileId, this.snooze, this.alarmSound});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profile_id': profileId,
      'snooze': snooze,
      'alarm_sound': alarmSound
    };
  }

  factory NotificationSettings.fromMap(Map<String, dynamic> map) {
    return NotificationSettings(
        id: map['id'],
        profileId: map['profile_id'],
        snooze: map['snooze'],
        alarmSound: map['alarm_sound']);
  }
}
