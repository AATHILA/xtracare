class Medicine {
  String? id;
  String? name;
  String? description;
  String? sideEffects;
  String? category;
  String? createdAt;
  String? updatedOn;

  Medicine(
      {this.id,
      this.name,
      this.category,
      this.description,
      this.sideEffects,
      this.createdAt,
      this.updatedOn});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sideEffects': sideEffects,
      'category': category,
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        sideEffects: map['sideEffects'],
        category: map['category'],
        createdAt: DateTime.parse(map['createdAt']).toString(),
        updatedOn: DateTime.parse(map['updatedOn']).toString());
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sideEffects': sideEffects,
      'category': category,
      'createdAt': createdAt,
      'updatedOn': updatedOn
    };
  }

  factory Medicine.fromJson(Map<String, dynamic> map) {
    return Medicine(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        sideEffects: map['sideEffects'],
        category: map['category'],
        createdAt: DateTime.parse(map['createdAt']).toString(),
        updatedOn: DateTime.parse(map['updatedOn']).toString());
  }

  bool isEqual(Medicine s) {
    return (s.id == id);
  }
}
