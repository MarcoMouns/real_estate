import 'package:flutter/material.dart';
import 'package:realestate/pages/auth/login.dart';
import 'package:realestate/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  goTo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    Future.delayed(Duration(seconds: 1), () =>
    token != null ? Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Home(),)) : Navigator.of(
        context).pushReplacement(
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
