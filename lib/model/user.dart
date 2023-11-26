class User {
  int? id;
  String? firstName;
  String? lastName;
  String? dob;
  String? phonenumber;
  String? username;
  String? password;
  String? role;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.dob,
      this.phonenumber,
      this.username,
      this.password,
      this.role});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob,
      'phonenumber': phonenumber,
      'username': username,
      'password': password,
      'role': role
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: map['id'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        dob: map['dob'],
        phonenumber: map['phonenumber'],
        username: map['username'],
        password: map['password'],
        role: map['role']);
  }
  factory User.fromJson(Map<String, dynamic> map) {
    return User(
        id: map['id'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        dob: map['dob'],
        phonenumber: map['phonenumber'],
        username: map['username'],
        password: map['password'],
        role: map['role']);
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob,
      'phonenumber': phonenumber,
      'username': username,
      'password': password,
      'role': role
    };
  }
}
