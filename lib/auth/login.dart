import 'package:flutter/material.dart';
import 'package:realestate/I10n/app_localizations.dart';
import 'package:realestate/auth/registration.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode phoneNode = FocusNode();
  FocusNode passwordNode = FocusNode();

  bool phoneEmptyError = false;
  bool passwordEmptyError = false;

  unFocus(){
    phoneNode.unfocus();
    passwordNode.unfocus();
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
                child: InkWell(
                  onTap: null,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: Text("${AppLocalizations.of(context).translate('skip')}"),
                  ),
                ),
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
                          child: Text("${AppLocalizations.of(context).translate('login')}",style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      InkWell(
                        onTap: null,
                        child: Text("${AppLocalizations.of(context).translate("forgetPassword")}"),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Registration(),)
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("${AppLocalizations.of(context).translate('doNotHaveAccount')}"),
                      Text("${AppLocalizations.of(context).translate('registerNow')}",style: TextStyle(color: Color(0xFFF99743)),),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
