import 'dart:io';

import 'package:dio/dio.dart';
import 'package:realestate/models/chatRoomInfo_model.dart';
import 'package:realestate/models/conversation_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatServices {
  final String _apiChatUrl = "http://api.naffeth.com:7777/";
  final String _chatStatus = "chatStatus/check?receiver_id=";
  final String _getChatsEndPoint = "rooms";
  final String _getConversationEndPoint = "fetch-messages";
  final String _createChat = "rooms/start?receiver_id=";
  final String _sendMessageEndPoint = "new-message";

  Future<List<ChatRoomInfo>> getChats() async {
    List<ChatRoomInfo> charRoomInfo = List<ChatRoomInfo>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    print(token);
    Response response = await Dio().get("$_apiChatUrl$_getChatsEndPoint",
        options: Options(
          headers: {HttpHeaders.authorizationHeader: "$token"},
        ));
    List data = response.data;
    print('gi bee $data');
    data.forEach((item) {
      charRoomInfo.add(ChatRoomInfo.fromJson(item));
    });
    return charRoomInfo;
  }

  Future<List<ConversationModel>> getConversation(int roomId) async {
    List<ConversationModel> conversation = List<ConversationModel>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    print(token);
    Response response = await Dio().get("$_apiChatUrl$_getChatsEndPoint" + "/$roomId/" + "$_getConversationEndPoint",
        options: Options(
          headers: {HttpHeaders.authorizationHeader: "$token"},
        ));
    List data = response.data;
    print('conversation data------------->$data');
    data.forEach((item) {
      conversation.add(ConversationModel.fromJson(item));
    });
    if (conversation.isNotEmpty) print(conversation.first.sender.name);
    return conversation;
  }

  Future sendMessage(String message, int roomId) async {
    print('msg pending');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    Response response = await Dio().post("$_apiChatUrl$_getChatsEndPoint" + "/$roomId/" + "$_sendMessageEndPoint",
        data: {"text": "$message"},
        options: Options(
          headers: {HttpHeaders.authorizationHeader: "$token"},
        ));
    print('msg send');
    return response;
  }

  Future<bool> checkChatStatus(int receiverId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    Response response;
    print('1');
    try {
      print('2');
      print('receiverId: $receiverId');
      response = await Dio().get("$_apiChatUrl$_chatStatus$receiverId",
          options: Options(
            headers: {HttpHeaders.authorizationHeader: "$token"},
          ));
      print('3');
    } on DioError catch (e) {
      print('4');
      print('error from checkChatStatus: ${e.response.data}');
      print('5');
    }

    print('checkChatStatus: ${response.data}');
    return response.data;
  }

  Future<int> creatChat(int receiverId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    Response response = await Dio().get("$_apiChatUrl$_createChat$receiverId",
        options: Options(
          headers: {HttpHeaders.authorizationHeader: "$token"},
        ));
    return response.data['id'];
  }
}
