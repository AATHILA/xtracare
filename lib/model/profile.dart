import 'dart:ffi';

class Profile {
  int? id;
  String? name;
  String? age;
  String? relation;
  int? userid;
  Profile({this.id, this.name, this.age, this.relation, this.userid});

  Map<String, dynamic> toMap() {
    return {'name': name, 'age': age, 'relation': relation, 'userid': userid};
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      relation: map['relation'],
      userid: int.parse(map['userid']),
    );
  }
}
