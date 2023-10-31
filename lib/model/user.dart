class User {
  String? id;
  String firstName;
  String lastName;
  String? dob;
  String phonenumber;
  String username;
  String? password;

  User(
      {this.id,
      required this.firstName,
      required this.lastName,
      this.dob,
      required this.phonenumber,
      required this.username,
      this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob,
      'phonenumber': phonenumber,
      'username': username,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: map['id'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        dob: map['dob'],
        phonenumber: map['phonenumber'],
        username: map['username']);
  }
}
