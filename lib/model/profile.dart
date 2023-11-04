class Profile {
  String? id;
  String? name;
  String? age;
  String? relation;

  Profile({this.id,this.name, this.age, this.relation});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'age': age, 'relation': relation};
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      relation: map['relation'],
    );
  }
}
