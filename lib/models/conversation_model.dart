class ConversationModel {
  int id;
  String message;
  String sentAt;
  Sender sender;

  ConversationModel({
    this.id,
    this.message,
    this.sentAt,
    this.sender,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> parsedJson) {
    return ConversationModel(
      id: parsedJson['id'],
      message: parsedJson['text'],
      sentAt: parsedJson['sent_at'],
      sender: Sender.fromJson(parsedJson['sender']),
    );
  }
}

class Sender {
  int id;
  String name;
  String photo;

  Sender({this.id, this.name, this.photo});

  factory Sender.fromJson(Map<String, dynamic> parsedJson) {
    return Sender(
      id: parsedJson['id'],
      name: parsedJson['username'],
      photo: parsedJson['pic'],
    );
  }
}
