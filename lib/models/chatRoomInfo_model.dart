class ChatRoomInfo {
  int roomId;
  String roomName;
  List<ChatMembers> chatMembers;

  ChatRoomInfo({this.roomId, this.roomName, this.chatMembers});

  factory ChatRoomInfo.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['members'] as List;
    List<ChatMembers> chatMembersList = list.map((value) => ChatMembers.fromJson(value)).toList();

    return ChatRoomInfo(
      roomId: parsedJson['id'],
      roomName: parsedJson['name'],
      chatMembers: chatMembersList,
    );
  }
}

class ChatMembers {
  int uID;
  String name;
  String avatar;

  ChatMembers({this.uID, this.name, this.avatar});

  factory ChatMembers.fromJson(Map<String, dynamic> parsedJson) {
    return ChatMembers(
      uID: parsedJson['id'],
      name: parsedJson['name'],
      avatar: parsedJson['photo'],
    );
  }
}
