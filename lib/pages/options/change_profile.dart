import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realestate/I10n/app_localizations.dart';
import 'package:realestate/pages/home.dart';
import 'package:realestate/services/editUser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeProfile extends StatefulWidget {
  @override
  _ChangeProfileState createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  FocusNode passwordNode = FocusNode();
  FocusNode usernameNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  File _image;

  unFocus() {
    passwordNode.unfocus();
    usernameNode.unfocus();
    phoneNode.unfocus();
  }

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  bool phoneEmptyError = false;
  bool nameEmptyError = false;
  bool alreadyRegistered = false;
  bool phoneLength = false;

  editProfile() async {
    bool isReg = false;
    Pattern pattern = r"[a-zA-Z]+(?:\s[a-zA-Z]+)?";
    isReg = RegExp(pattern).hasMatch(usernameController.text);
    int apiCode = _image == null
        ? await EditUser().editUser(
            phone: phoneController.text,
            name: usernameController.text,
            password: passwordController.text,
          )
        : await EditUser().editUser(
            phone: phoneController.text,
            name: usernameController.text,
            password: passwordController.text,
            image: _image,
          );
    print(apiCode);
    if (phoneController.text.isEmpty) {
      phoneEmptyError = true;
    } else
      phoneEmptyError = false;
    if (apiCode == 412) {
      alreadyRegistered = true;
    } else
      alreadyRegistered = false;
    if (apiCode == 413) {
      phoneLength = true;
    } else
      phoneLength = false;
    if (usernameController.text.isEmpty || isReg == false) {
      nameEmptyError = true;
    } else
      nameEmptyError = false;
    setState(() {});
    if (phoneController.text.isNotEmpty &&
        alreadyRegistered == false &&
        phoneLength == false &&
        isReg == true) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  }

  String photo;
  String fullName;
  String phone;
  String token = "";
  bool isLoading = true;

  getPhoto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    if (token.isNotEmpty) {
      photo = prefs.getString('photo');
      fullName = prefs.getString('name');
      phone = prefs.getString('mobile');
      usernameController.text = fullName;
      phoneController.text = phone;
      print(photo);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPhoto();
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
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () => getImage(),
                            child: _image == null
                                ? CircleAvatar(
                              radius: 50.0,
                              backgroundImage: NetworkImage("$photo"),
                            )
                                : ClipRRect(
                              borderRadius:
                              BorderRadius.all(Radius.circular(100)),
                              child: Image.file(
                                _image,
                                fit: BoxFit.cover,
                                width: 150,
                                height: 150,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 40)),
                          SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.8,
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
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                      borderSide:
                                      BorderSide(color: Color(0xFFB9B9B9))),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                      borderSide:
                                      BorderSide(color: Color(0xFFB9B9B9))),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                      borderSide:
                                      BorderSide(color: Colors.blue)),
                                  hintText:
                                  "${AppLocalizations.of(context).translate(
                                      'name')}"),
                            ),
                          ),
                          nameEmptyError
                              ? Text(
                            "${"${AppLocalizations.of(context).translate(
                                'nameEmptyError')}"}",
                            style: TextStyle(color: Colors.red),
                          )
                              : Container(),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.8,
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
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                      borderSide:
                                      BorderSide(color: Color(0xFFB9B9B9))),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                      borderSide:
                                      BorderSide(color: Color(0xFFB9B9B9))),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                      borderSide:
                                      BorderSide(color: Colors.blue)),
                                  hintText:
                                  "${AppLocalizations.of(context).translate(
                                      'password')}"),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.8,
                            child: TextField(
                              controller: phoneController,
                              focusNode: phoneNode,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  filled: true,
                                  focusColor: Color(0xFFF3F3F3),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 25,
                                    vertical: 15,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                      borderSide:
                                      BorderSide(color: Color(0xFFB9B9B9))),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                      borderSide:
                                      BorderSide(color: Color(0xFFB9B9B9))),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                      borderSide:
                                      BorderSide(color: Colors.blue)),
                                  hintText:
                                  "${AppLocalizations.of(context).translate(
                                      'phoneNumber')}"),
                            ),
                          ),
                          phoneEmptyError
                              ? Text(
                            "${"${AppLocalizations.of(context).translate(
                                'phoneEmptyError')}"}",
                            style: TextStyle(color: Colors.red),
                          )
                              : alreadyRegistered
                              ? Text(
                            "${"${AppLocalizations.of(context).translate(
                                'phoneAlreadyRegistered')}"}",
                            style: TextStyle(color: Colors.red),
                          )
                              : phoneLength
                              ? Text(
                            "${"${AppLocalizations.of(context).translate(
                                'phoneLengthError')}"}",
                            style: TextStyle(color: Colors.red),
                          )
                              : Container(),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      InkWell(
                        onTap: editProfile,
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.9,
                          height: 50,
                          margin: EdgeInsets.only(bottom: 30),
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20)),
                              color: Color(0xFF0D986A)),
                          alignment: Alignment.center,
                          child: Text(
                            "${AppLocalizations.of(context).translate('edit')}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
