class FeedBack {
  int? id;
  String? subject;
  String? content;
  String? reply;
  int? userId;
  String? createdAt;
  String? updatedOn;
  FeedBack(
      {this.id,
      this.subject,
      this.content,
      this.reply,
      this.userId,
      this.createdAt,
      this.updatedOn});

  factory FeedBack.fromMap(Map<String, dynamic> map) {
    return FeedBack(
        id: map['id'],
        subject: map['subject'],
        content: map['content'],
        reply: map['reply'],
        userId: map['userId'],
        createdAt: DateTime.parse(map['createdAt']).toString(),
        updatedOn: DateTime.parse(map['updatedOn']).toString());
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'content': content,
      'reply': reply,
      'userId': userId,
      'createdAt': createdAt,
      'updatedOn': updatedOn,
    };
  }

  factory FeedBack.fromJson(Map<String, dynamic> map) {
    return FeedBack(
        id: map['id'],
        subject: map['subject'],
        content: map['content'],
        reply: map['reply'],
        userId: map['userId'],
        createdAt: DateTime.parse(map['createdAt']).toString(),
        updatedOn: DateTime.parse(map['updatedOn']).toString());
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'content': content,
      'reply': reply,
      'userId': userId,
      'createdAt': createdAt,
      'updatedOn': updatedOn,
    };
  }
}
