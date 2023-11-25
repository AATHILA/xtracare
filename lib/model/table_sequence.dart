class TableSequence {
  int? id;
  String? tableName;
  int? userId;
  int? currentValue;
  String? createdAt;
  String? updatedOn;
  TableSequence(
      {this.id,
      this.tableName,
      this.userId,
      this.currentValue,
      this.createdAt,
      this.updatedOn});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tableName': tableName,
      'userId': userId,
      'currentValue': currentValue,
      'createdAt': createdAt,
      'updatedOn': updatedOn
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tableName': tableName,
      'userId': userId,
      'currentValue': currentValue,
      'createdAt': createdAt,
      'updatedOn': updatedOn
    };
  }

  factory TableSequence.fromMap(Map<String, dynamic> map) {
    return TableSequence(
        id: map['id'],
        tableName: map['tableName'],
        userId: map['userId'],
        currentValue: map['currentValue'],
        createdAt: DateTime.parse(map['createdAt']).toString(),
        updatedOn: DateTime.parse(map['updatedOn']).toString());
  }

  factory TableSequence.fromJson(Map<String, dynamic> map) {
    return TableSequence(
        id: map['id'],
        tableName: map['tableName'],
        userId: map['userId'],
        currentValue: map['currentValue'],
        createdAt: DateTime.parse(map['createdAt']).toString(),
        updatedOn: DateTime.parse(map['updatedOn']).toString());
  }
}
