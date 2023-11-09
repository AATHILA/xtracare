class Medicine {
  int? id;
  String? name;
  String? description;
  String? side_effects;
  String? category;

  Medicine(
      {this.id, this.name, this.category, this.description, this.side_effects});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'side_effects': side_effects,
      'category': category
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      side_effects: map['side_effects'],
      category: map['category'],
    );
  }
}
