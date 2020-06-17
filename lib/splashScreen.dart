import 'package:flutter/material.dart';
import 'package:realestate/pages/auth/login.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  goTo() async{
    Future.delayed(Duration(seconds: 1),()=>Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Login(),)
    ));
  }

  @override
  void initState() {
    super.initState();
    goTo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo.png',scale: 5,),
      ),
    );
  }
}
