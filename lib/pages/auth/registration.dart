import 'package:flutter/material.dart';
import 'package:realestate/I10n/app_localizations.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  FocusNode phoneNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode nameNode = FocusNode();

  bool phoneEmptyError = false;
  bool passwordEmptyError = false;
  bool nameEmptyError = false;

  unFocus(){
    phoneNode.unfocus();
    passwordNode.unfocus();
    nameNode.unfocus();
  }

  validate(){
    print('phoneController = ${phoneController.text.isEmpty}');
    print('passwordController = ${passwordController.text}');
    if(phoneController.text.isEmpty){
      phoneEmptyError = true;
    }
    else phoneEmptyError = false;
    if(passwordController.text.isEmpty){
      passwordEmptyError = true;
    }
    else passwordEmptyError = false;
    if(nameController.text.isEmpty){
      nameEmptyError = true;
    }
    else nameEmptyError = false;
    setState(() {});
    if(passwordController.text.isNotEmpty && phoneController.text.isNotEmpty){

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
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: null,
                          child: Text("${AppLocalizations.of(context).translate('skip')}"),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Image.asset('assets/icons/back.png',scale: 4,),
                        )
                      ],
                    ),
                  )
              ),
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/images/profile.png',scale: 3.5,),
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
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(color: Color(0xFFB9B9B9))
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(color: Color(0xFFB9B9B9))
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(color: Colors.blue)
                              ),
                              hintText: "${AppLocalizations.of(context).translate('name')}"
                          ),
                        ),
                      ),
                      nameEmptyError?
                      Text("${"${AppLocalizations.of(context).translate('nameEmptyError')}"}",style: TextStyle(color:
                      Colors.red),):Container(),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
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
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(color: Color(0xFFB9B9B9))
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(color: Color(0xFFB9B9B9))
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(color: Colors.blue)
                              ),
                              hintText: "${AppLocalizations.of(context).translate('phoneNumber')}"
                          ),
                        ),
                      ),
                      phoneEmptyError?
                      Text("${"${AppLocalizations.of(context).translate('phoneEmptyError')}"}",style: TextStyle(color:
                      Colors.red),):Container(),
                      Padding(padding: EdgeInsets.only(top: 20)),
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
                                  borderSide: BorderSide(color: Color(0xFFB9B9B9))
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(color: Color(0xFFB9B9B9))
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(color: Colors.blue)
                              ),
                              hintText: "${AppLocalizations.of(context).translate('password')}"
                          ),
                        ),
                      ),
                      passwordEmptyError?
                      Text("${"${AppLocalizations.of(context).translate('passwordEmptyError')}"}",style: TextStyle(color:
                      Colors.red)):Container(),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      InkWell(
                        onTap: () => validate(),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                              color: Color(0xFF0D986A),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          alignment: Alignment.center,
                          child: Text("${AppLocalizations.of(context).translate('register')}",style: TextStyle(color: Colors.white),),
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
