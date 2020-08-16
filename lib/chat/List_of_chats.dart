import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realestate/I10n/app_localizations.dart';
import 'package:realestate/models/chatRoomInfo_model.dart';
import 'package:realestate/pages/auth/login.dart';
import 'package:realestate/services/chat.dart';
import 'package:realestate/widgets/chat_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_conversation.dart';

class ListOfChatsClass extends StatefulWidget {
  ///this for hide and enable the back button
  bool comeFromProductScreen;

  ListOfChatsClass(this.comeFromProductScreen);

  @override
  _ListOfChatsClassState createState() => _ListOfChatsClassState();
}

class _ListOfChatsClassState extends State<ListOfChatsClass> {
  int userId;
  bool isLoading = true;
  List<ChatRoomInfo> charRoomInfo = new List<ChatRoomInfo>();
  List<ChatMembers> chatMembers = new List<ChatMembers>();
  String userToken;

  getChatRoomsInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getInt('id');
    userToken = preferences.getString('token') ?? "";
    if (userToken.isNotEmpty) {
      ChatServices().getChats().then((value) {
        if (value.isNotEmpty) {
          charRoomInfo = value;
          for (int i = 0; i < value.length; i++) {
            for (int k = 0; k <= 1; k++) {
              if (value[i].chatMembers[k].uID != userId) {
                print('value[i].chatMembers[k].uID--------------->${value[i].chatMembers[k].uID}');
                print('userId------------->$userId');
                print('userId-------------> ${value[i].chatMembers[k].name}');
                chatMembers.add(value[i].chatMembers[k]);
              }
            }
            //charRoomInfo
          }
          ;
        } else
          charRoomInfo = [];
        isLoading = false;
        setState(() {});
      });
    } else {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getChatRoomsInfo();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : userToken.isEmpty
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(AppLocalizations.of(context).translate('not log in')),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 15,
                      ),
                      child: InkWell(
                        onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login())),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff00B200),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context).translate('login button'),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Scaffold(
                body: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(35),
//                  bottomLeft: Radius.circular(25),
                            ),
                            gradient: LinearGradient(colors: [
                              Color(0xFF787FF6),
                              Color(0xFF4ADEDE),
                            ])),
                        child: Text(
                          AppLocalizations.of(context).translate('chat title'),
                          style: TextStyle(color: Colors.white, fontSize: 27),
                        ),
                      ),
                      widget.comeFromProductScreen == true
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.23,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        AppLocalizations.of(context).translate('back'),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                  margin: EdgeInsets.only(top: 10, left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.only(top: 30),
                          itemCount: charRoomInfo.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: ChatCard(
                                  name: '${chatMembers[index].name}',
                                  image: 'http://api.naffeth.com/media/${chatMembers[index].avatar}',
                                  date: '21 May 2019',
                                  time: '03:13AM',
                                ),
                              ),
                              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChatConversation(
                                        true,
                                        roomId: charRoomInfo[index].roomId,
                                        userToken: userToken,
                                        creatorId: chatMembers[index].uID,
                                        name: chatMembers[index].name,
                                        photo: chatMembers[index].avatar,
                                      ))),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );

//      SingleChildScrollView(
//        child: Padding(
//          padding: EdgeInsets.only(
//            top: 10,
//            right: MediaQuery
//                .of(context)
//                .padding
//                .right + 24,
//            left: MediaQuery
//                .of(context)
//                .padding
//                .left + 24,
//          ),
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              InkWell(
//                child: ChatCard(
//                  name: 'احمد محمد',
//                  image: 'assets/images/Ovaal.png',
//                  date: '21 May 2019',
//                  time: '03:13AM',
//                ),
//                onTap: () =>
//                    Navigator.of(context)
//                        .push(MaterialPageRoute(
//                        builder: (context) => ChatMessages())),
//              ),
//              ChatCard(
//                name: 'محمود الورداني',
//                image: 'assets/images/Oval.png',
//                date: '08 Jan 2019',
//                time: '08:13PM',
//              ),
//            ],
//          ),
//        ),
//      ),
  }
}
