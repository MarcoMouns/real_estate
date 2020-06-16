import 'package:flutter/material.dart';
import 'package:realestate/I10n/app_localizations.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  TextEditingController passwordController = TextEditingController();

  FocusNode passwordNode = FocusNode();

  bool passwordEmptyError = false;

  unFocus(){
    passwordNode.unfocus();
  }

  validate(){
    print('passwordController = ${passwordController.text}');
    if(passwordController.text.isEmpty){
      passwordEmptyError = true;
    }
    else passwordEmptyError = false;
    setState(() {});
    if(passwordController.text.isNotEmpty){

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
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: Image.asset('assets/icons/back.png',scale: 4,),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/images/lock.png',scale: 3.5,),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      Text("${AppLocalizations.of(context).translate('forgetPasswordNote')}"),
                      Padding(padding: EdgeInsets.only(top: 40)),
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
                              hintText: "${AppLocalizations.of(context).translate('phoneNumber')}"
                          ),
                        ),
                      ),
                      passwordEmptyError?
                      Text("${"${AppLocalizations.of(context).translate('passwordEmptyError')}"}",style: TextStyle(color:
                      Colors.red),):Container(),
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
                          child: Text("${AppLocalizations.of(context).translate('continue')}",style: TextStyle(color: Colors.white),),
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
