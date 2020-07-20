import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realestate/I10n/app_localizations.dart';
import 'package:realestate/pages/auth/otp.dart';
import 'package:realestate/services/registration.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  File _image;

  FocusNode phoneNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode nameNode = FocusNode();

  bool phoneEmptyError = false;
  bool passwordEmptyError = false;
  bool nameEmptyError = false;
  bool alreadyRegistered = false;
  bool phoneLength = false;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  unFocus() {
    phoneNode.unfocus();
    passwordNode.unfocus();
    nameNode.unfocus();
  }

  validate() async {
    bool isReg = false;
    Pattern pattern = r"[a-zA-Z]+(?:\s[a-zA-Z]+)?";
    print(nameController.text);
    isReg = RegExp(pattern).hasMatch(nameController.text);
    int apiCode =
        await RegistrationAndOtp().sendOtp(phone: phoneController.text);
    print('phoneController = ${phoneController.text.isEmpty}');
    print('passwordController = ${passwordController.text}');
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
    if (passwordController.text.isEmpty) {
      passwordEmptyError = true;
    } else
      passwordEmptyError = false;
    if (nameController.text.isEmpty || isReg == false) {
      nameEmptyError = true;
    } else
      nameEmptyError = false;
    setState(() {});
    if (passwordController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        alreadyRegistered == false &&
        phoneLength == false) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Otp(
          image: _image,
          name: nameController.text,
          password: passwordController.text,
          phone: phoneController.text,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => unFocus(),
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: null,
                          child: Text(
                              "${AppLocalizations.of(context).translate('skip')}"),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Image.asset(
                            'assets/icons/back.png',
                            scale: 4,
                          ),
                        )
                      ],
                    ),
                  )),
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () => getImage(),
                        child: _image == null
                            ? Image.asset(
                                'assets/images/profile.png',
                                scale: 3.5,
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
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          controller: nameController,
                          focusNode: nameNode,
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
                                  borderSide: BorderSide(color: Colors.blue)),
                              hintText:
                                  "${AppLocalizations.of(context).translate('name')}"),
                        ),
                      ),
                      nameEmptyError
                          ? Text(
                              "${"${AppLocalizations.of(context).translate('nameEmptyError')}"}",
                              style: TextStyle(color: Colors.red),
                            )
                          : Container(),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          controller: phoneController,
                          focusNode: phoneNode,
                          maxLength: 9,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              counterText: "",
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
                                  borderSide: BorderSide(color: Colors.blue)),
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
                      Padding(padding: EdgeInsets.only(top: 20)),
                      SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.8,
                        child: TextField(
                          controller: passwordController,
                          focusNode: passwordNode,
                          obscureText: true,
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
                                  borderSide: BorderSide(color: Colors.blue)),
                              hintText:
                                  "${AppLocalizations.of(context).translate('password')}"),
                        ),
                      ),
                      passwordEmptyError
                          ? Text(
                              "${"${AppLocalizations.of(context).translate('passwordEmptyError')}"}",
                              style: TextStyle(color: Colors.red))
                          : Container(),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      InkWell(
                        onTap: () => validate(),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                              color: Color(0xFF0D986A),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          alignment: Alignment.center,
                          child: Text(
                            "${AppLocalizations.of(context).translate('register')}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
