class MessageModel {
  String? messageId;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createOn;

  MessageModel({
    this.sender,
    this.messageId,
    this.text,
    this.seen,
    this.createOn,
  });
  MessageModel.fromMap(Map<String, dynamic> map) {
    sender = map['sender'];
    text = map['text'];
    seen = map['seen'];
    createOn = map['createOn'].toDate();
    messageId = map['messageId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'text': text,
      'seen': seen,
      'createOn': createOn,
      'messageId': messageId,
    };
  }
}
