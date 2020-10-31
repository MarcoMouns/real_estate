import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:realestate/I10n/app_localizations.dart';
//import 'package:url_launcher/url_launcher.dart';

class CallUs extends StatefulWidget {
  @override
  _CallUsState createState() => _CallUsState();
}

class _CallUsState extends State<CallUs> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  FocusNode titleNode = FocusNode();
  FocusNode contentNode = FocusNode();

  String about;
  String phone;
  String email;

  bool isLoading = true;

  unFocus() {
    titleNode.unfocus();
    contentNode.unfocus();
  }

  getUserData() async {
    Response response = await Dio().get("http://api.naffeth.com/about/");
    print(response.data);
    about = response.data['about_ar'];
    phone = response.data['phone'];
    email = response.data['email'];

    isLoading = false;
    setState(() {});
  }

  Future<void> _makePhoneCall(String url) async {
//    if (await canLaunch(url)) {
//      await launch(url);
//    } else {
//      throw 'Could not launch $url';
//    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text("${AppLocalizations.of(context).translate('callUs')}"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () => unFocus(),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 20)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("${AppLocalizations.of(context).translate('callUs')}"),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      InkWell(
                        onTap: () => _makePhoneCall('tel: $phone'),
                        child: Text(
                          "$phone",
                          style: TextStyle(color: Color(0xFF0D986A)),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Text("${AppLocalizations.of(context).translate('msgUs')}"),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Text(
                    "$email",
                    style: TextStyle(color: Color(0xFF0D986A)),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Text("عن التطبيق"),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Text(
                    "$about",
                    style: TextStyle(color: Color(0xFF0D986A)),
                  ),
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.8,
//                    child: TextField(
//                      controller: titleController,
//                      focusNode: titleNode,
//                      decoration: InputDecoration(
//                          filled: true,
//                          focusColor: Color(0xFFF3F3F3),
//                          contentPadding: EdgeInsets.symmetric(
//                            horizontal: 25,
//                            vertical: 15,
//                          ),
//                          border: OutlineInputBorder(
//                              borderRadius: BorderRadius.all(Radius.circular(20)),
//                              borderSide: BorderSide(color: Color(0xFFB9B9B9))),
//                          enabledBorder: OutlineInputBorder(
//                              borderRadius: BorderRadius.all(Radius.circular(20)),
//                              borderSide: BorderSide(color: Color(0xFFB9B9B9))),
//                          focusedBorder: OutlineInputBorder(
//                              borderRadius: BorderRadius.all(Radius.circular(20)),
//                              borderSide: BorderSide(color: Colors.blue)),
//                          hintText: "${AppLocalizations.of(context).translate('msgTitle')}"),
//                    ),
//                  ),
//                  Padding(padding: EdgeInsets.only(top: 10)),
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.8,
//                    child: TextField(
//                      controller: contentController,
//                      focusNode: contentNode,
//                      maxLines: 10,
//                      decoration: InputDecoration(
//                          filled: true,
//                          focusColor: Color(0xFFF3F3F3),
//                          contentPadding: EdgeInsets.symmetric(
//                            horizontal: 25,
//                            vertical: 15,
//                          ),
//                          border: OutlineInputBorder(
//                              borderRadius: BorderRadius.all(Radius.circular(20)),
//                              borderSide: BorderSide(color: Color(0xFFB9B9B9))),
//                          enabledBorder: OutlineInputBorder(
//                              borderRadius: BorderRadius.all(Radius.circular(20)),
//                              borderSide: BorderSide(color: Color(0xFFB9B9B9))),
//                          focusedBorder: OutlineInputBorder(
//                              borderRadius: BorderRadius.all(Radius.circular(20)),
//                              borderSide: BorderSide(color: Colors.blue)),
//                          hintText: "${AppLocalizations.of(context).translate('msgContent')}"),
//                    ),
//                  ),
                ],
              ),
//              Container(
//                width: MediaQuery.of(context).size.width * 0.9,
//                height: 50,
//                margin: EdgeInsets.only(bottom: 30),
//                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Color(0xFF0D986A)),
//                alignment: Alignment.center,
//                child: Text(
//                  "${AppLocalizations.of(context).translate('continue')}",
//                  style: TextStyle(color: Colors.white),
//                ),
//              )
            ],
          ),
        ),
      ),
    );
  }
}
