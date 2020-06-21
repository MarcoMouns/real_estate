import 'package:flutter/material.dart';
import 'package:realestate/I10n/app_localizations.dart';

class ChangeProfile extends StatefulWidget {
  @override
  _ChangeProfileState createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  FocusNode passwordNode = FocusNode();
  FocusNode usernameNode = FocusNode();

  unFocus() {
    passwordNode.unfocus();
    usernameNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("${AppLocalizations.of(context).translate('editProfile')}"),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => unFocus(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 20)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: usernameController,
                      focusNode: usernameNode,
                      decoration: InputDecoration(
                          filled: true,
                          focusColor: Color(0xFFF3F3F3),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 15,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(color: Color(0xFFB9B9B9))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(color: Color(0xFFB9B9B9))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(color: Colors.blue)),
                          hintText: "${AppLocalizations.of(context).translate('name')}"),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: passwordController,
                      focusNode: passwordNode,
                      decoration: InputDecoration(
                          filled: true,
                          focusColor: Color(0xFFF3F3F3),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 15,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(color: Color(0xFFB9B9B9))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(color: Color(0xFFB9B9B9))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(color: Colors.blue)),
                          hintText: "${AppLocalizations.of(context).translate('password')}"),
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                margin: EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Color(0xFF0D986A)),
                alignment: Alignment.center,
                child: Text(
                  "${AppLocalizations.of(context).translate('edit')}",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
