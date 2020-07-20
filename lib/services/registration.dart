import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationAndOtp {
  final String _url = "http://134.209.25.40/";
  final String _registration = "registration/";
  final String _otp = "otp";
  FormData _formData;

  Future registration(
      {String name, String phone, String password, File image}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    image == null
        ? _formData = FormData.fromMap(
            {"name": "$name", "password": "$password", "mobile": "$phone"})
        : _formData = FormData.fromMap({
            "name": "$name",
            "password": "$password",
            "photo": await MultipartFile.fromFile("${image.path}"),
            "mobile": "$phone"
          });
    try {
      Response response =
          await Dio().post("$_url$_registration", data: _formData);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        print(response.data);
        prefs.setString('token', "${response.data['token']}");
        prefs.setString('name', "${response.data['name']}");
        prefs.setString('mobile', "${response.data['mobile']}");
        prefs.setString('photo', "${response.data['photo']}");
        prefs.setInt('id', response.data['id']);

        return 201;
      } else {
        print(response.data);
        return 404;
      }
    } on DioError catch (e) {
      print(e.response.data);
      return e.response.data;
    }
  }

  Future sendOtp({String phone}) async {
    _formData = FormData.fromMap({"mobile": "$phone"});
    try {
      Response response = await Dio().post("$_url$_otp", data: _formData);
      print(response.data);

      return response.statusCode;
    } on DioError catch (e) {
      print(e.response.data);
      return e.response.statusCode;
    }
  }

  Future confirmOtp({String phone, String otp}) async {
    _formData = FormData.fromMap({"mobile": "$phone", "code": "$otp"});
    try {
      Response response = await Dio().post("$_url$_otp", data: _formData);
      print(response.data);

      return response.statusCode;
    } on DioError catch (e) {
      print(e.response.data);
      return e.response.statusCode;
    }
  }

  Future<dynamic> resendOtp({String phone}) async {
    _formData = FormData.fromMap({"mobile": "$phone", "resend": 1});
    try {
      Response response = await Dio().post("$_url$_otp", data: _formData);
      print(response.data);

      return response.statusCode;
    } on DioError catch (e) {
      return e.response.data;
    }
  }
}
