import 'dart:convert';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:realestate/models/conversation_model.dart';
import 'package:realestate/services/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatConversation extends StatefulWidget {
  int roomId;
  String name;
  String photo;
  int creatorId;
  String userToken;

  ///this to check if the user have a chat with the user that he will chat with
  ///or not cuz the get request of the API of previous conversations between them
  bool chatStatus;

  ChatConversation(this.chatStatus, {this.roomId, this.name, this.photo, this.creatorId, this.userToken});

  @override
  _ChatConversationState createState() => _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation> {
  FocusNode _chatFocusNode = FocusNode();
  TextEditingController _chatController = new TextEditingController();
  List<ConversationModel> conversation = List<ConversationModel>();
  bool isLoading = true;
  int userId;
  SocketIO socketIO;
  bool roomIsCreated = true;

  _connectSocket01() {
    //update your domain before using
    /*socketIO = new SocketIO("http://127.0.0.1:3000", "/chat",
        query: "userId=21031", socketStatusCallback: _socketStatus);*/
    socketIO = SocketIOManager().createSocketIO(
      "http://api.naffeth.com:7777",
      "/",
      query: "key=${widget.userToken}",
      socketStatusCallback: _socketStatus,
    );

    //call init socket before doing anything
    socketIO.init();

    //subscribe event
    socketIO.subscribe("new-message", _onSocketInfo);

    //connect socket
    socketIO.connect();
  }

  _socketStatus(dynamic data) {
    print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    print("Socket status: " + data);
  }

  ///response shape from socket.io --->
  /// {
  /// "id":116,
  /// "text":"hello 209",
  /// "image":null,
  /// "video":null,
  /// "sent_at":"2020-03-16T11:35:54.000Z",
  /// "sender":
  ///         {
  ///            "id":2,
  ///            "username":"test123",
  ///            "pic":"Screenshot_20200222-172856.jpg"
  ///         }
  /// }

  _onSocketInfo(String data) {
    var decodedData = jsonDecode(data);
    print(decodedData);
    conversation.insert(0, ConversationModel.fromJson(decodedData));
    setState(() {});
    print(conversation.last.message);
    print("Socket info: " + data);
  }

  void unFocusNodes() {
    _chatFocusNode.unfocus();
  }

  getuserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getInt('id');
    print('userId--------------------->$userId');
  }

  getData() async {
    ChatServices().getConversation(widget.roomId).then((value) {
      conversation = value;
      setState(() {
        isLoading = false;
      });
    });
  }

  sendMessage(String message) async {
    if (widget.chatStatus == false) {
      ChatServices().creatChat(widget.creatorId).then((roomId) {
        print('roooooooooooooooooom id---------->$roomId');
        widget.roomId = roomId;
        widget.chatStatus = true;
        roomIsCreated = true;
        ChatServices().sendMessage(message, widget.roomId);
        setState(() {});
      });
    }

    /// remember when you send the msg its auto send to the socket as a stream
    /// conc.: when you send a mssg it will auto display on the screen due to
    /// stream of the socket.io --> this comment is for you newbie :"D
    if (roomIsCreated == true) ChatServices().sendMessage(message, widget.roomId);
    _chatController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    socketIO.unSubscribe("new-message");
    socketIO.disconnect();
    SocketIOManager().destroySocket(socketIO);
    print('leave chat');
  }

  @override
  void initState() {
    super.initState();
    _connectSocket01();
    getuserId();
    if (widget.chatStatus == true)
      getData();
    else
      setState(() {
        roomIsCreated = false;
        isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;

    BubbleStyle styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );
    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color(0xff00c700),
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );

    Widget senderBubble(String message, String sendAt) {
      return Bubble(
        margin: BubbleEdges.only(right: 7),
        nipOffset: 25,
        nipWidth: 10,
        nipHeight: 10,
        nip: BubbleNip.rightTop,
        style: styleMe,
        color: Color(0xff00c700),
        alignment: Alignment.topRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '$message',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xffFFFFFF),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Text(
                '${sendAt.substring(11, 16)}',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget receiverBubble(String message, String sendAt) {
      return Bubble(
        margin: BubbleEdges.only(left: 6),
        nipOffset: 13,
        nipWidth: 10,
        nipHeight: 15,
        style: styleSomebody,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '$message',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Text(
                '${sendAt.substring(11, 16)}',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.green,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white30,
          elevation: 0,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: Row(
                children: <Widget>[
                  Text(
                    '${widget.name}',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 18.0),
//                Container(
//                  width: 50.0,
//                  height: 50.0,
//                  decoration: BoxDecoration(
//                    shape: BoxShape.circle,
//                    image: DecorationImage(
//                      image: widget.chatStatus ==true? NetworkImage(
//                        'http://207.154.192.121/media/${widget.photo}',
//                      ):
//                      NetworkImage(
//                      '${widget.photo}',
//                    ),
//                      fit: BoxFit.cover,
//                    ),
//                  ),
//                ),
                ],
              ),
            ),
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.78,
                      child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        reverse: true,
                        // physics: NeverScrollableScrollPhysics(),
                        itemCount: conversation.length,
                        itemBuilder: (context, index) {
                          print(conversation.length);
                          if (conversation[index].sender.id == userId) {
                            return senderBubble(conversation[index].message, conversation[index].sentAt);
                          } else {
                            return receiverBubble(conversation[index].message, conversation[index].sentAt);
                          }
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextField(
                            controller: _chatController,
                            focusNode: _chatFocusNode,
                            textAlign: TextAlign.right,
                            maxLines: 5,
                            minLines: 1,
                            onChanged: (String txt) {
                              setState(() {});
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                  right: 15,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[400]),
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                ),
                                hintText: "اكتب هنا"),
                          ),
                        ),
                        InkWell(
                            onTap: () => _chatController.text.isEmpty ? null : sendMessage(_chatController.text),
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.send,
                                color: _chatController.text.isEmpty ? Colors.grey : Colors.green,
                              ),
                            )),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 10))
                  ],
                ),
              ));
  }
}
