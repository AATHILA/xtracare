class SyncStatusTable {
  String? tableName;
  DateTime? lastSynced;

  SyncStatusTable({this.tableName, this.lastSynced});

  Map<String, dynamic> toMap() {
    return {
      'tableName': tableName,
      'lastSynced': lastSynced!.millisecondsSinceEpoch
    };
  }

  factory SyncStatusTable.fromMap(Map<String, dynamic> map) {
    return SyncStatusTable(
        tableName: map['tableName'],
        lastSynced: DateTime.fromMillisecondsSinceEpoch(map['lastSynced']));
  }
}
