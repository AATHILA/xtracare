import 'package:pill_reminder/model/medicine.dart';
import 'package:pill_reminder/model/timeslot.dart';

class Prescription {
  int? id;
  String? prescribed_by;
  String? start_date;
  String? end_date;
  String? consultation_date;
  int? profile_id;

  List<Medication>? medications;
  Prescription(
      {this.id,
      this.prescribed_by,
      this.start_date,
      this.end_date,
      this.consultation_date,
      this.profile_id,
      this.medications});
  Map<String, dynamic> toMap() {
    return {
      'prescribed_by': prescribed_by,
      'start_date': start_date,
      'end_date': end_date,
      'consultation_date': consultation_date,
      'profile_id': profile_id,
    };
  }

  factory Prescription.fromMap(Map<String, dynamic> map) {
    return Prescription(
        id: map['id'],
        prescribed_by: map['prescribed_by'],
        start_date: map['start_date'],
        end_date: map['end_date'],
        consultation_date: map['consultation_date'],
        profile_id: map['profile_id'],
        medications: map['medications']);
  }
}

class Medication {
  int? id;
  int? prescription_id;
  int? medicine_id;
  String? dose;
  int? timeslot_id;
  Timeslot? timeslot;
  Medicine? medicine;

  Medication(
      {this.id,
      this.medicine_id,
      this.dose,
      this.timeslot_id,
      this.prescription_id,
      this.medicine,
      this.timeslot});

  Map<String, dynamic> toMap() {
    return {
      'prescription_id': prescription_id,
      'medicine_id': medicine_id,
      'dose': dose,
      'timeslot_id': timeslot_id,
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      prescription_id: map['prescription_id'],
      medicine_id: map['medicine_id'],
      dose: map['dose'],
      timeslot_id: map['timeslot_id'],
      medicine: map['medicine'],
      timeslot: map['timeslot'],
    );
  }
}
