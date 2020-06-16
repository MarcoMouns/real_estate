import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:realestate/I10n/app_localizations.dart';

import 'change_password.dart';

class Otp extends StatefulWidget {
  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  String pin;

  reSendOtp() async{

  }

  validate(String pin) async{
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangePassword(),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
              child: Column(
                children: <Widget>[
                  Image.asset('assets/images/phoneChat.png',scale: 4,),
                  Padding(padding: EdgeInsets.only(top: 15)),
                  Text("${AppLocalizations.of(context).translate('otpNote')}"),
                  Padding(padding: EdgeInsets.only(top: 25)),
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.8,
                            child: PinCodeTextField(
                              length: 4,
                              autoFocus: true,
                              selectedColor: Colors.blue,
                              // describes the field number
                              // autoFocusFirstField: false,
                              // // defaults to true
                              // margin: EdgeInsets.all(15),
                              // margin between the fields
                              backgroundColor: Colors.transparent,
                              textStyle: TextStyle(
                                // style for the fields
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.w500),
                              activeColor: Colors.green,

                              // dashStyle: TextStyle(
                              //   // dash style
                              //   fontSize: 25.0,
                              //   color: Colors.grey,
                              // ),
                              onCompleted: (String pin) async {
                                this.pin = pin;
                                validate(pin);
                              },
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 50)),
                        InkWell(
                          onTap: () => validate(pin),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                                color: Color(0xFF0D986A),
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            alignment: Alignment.center,
                            child: Text("${AppLocalizations.of(context).translate('check')}",style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => reSendOtp(),)
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("${AppLocalizations.of(context).translate('otpNotSend')}"),
                    Text("${AppLocalizations.of(context).translate('sendAgain')}",style: TextStyle(color: Color(0xFFF99743)),),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
