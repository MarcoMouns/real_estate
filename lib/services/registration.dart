import 'dart:io';

import 'package:dio/dio.dart';

class Registration {
  final String _url = "http://134.209.25.40/";
  final String _registration = "user/";
  FormData _formData;

  Future<int> registration(
      {String name, String phone, String password, File image}) async {
    _formData = FormData.fromMap({
      "name": "$name",
      "password": "$password",
      "photo": await MultipartFile.fromFile("${image.path}"),
      "phone": "$phone"
    });
    try {
      Response response =
          await Dio().post("$_url$_registration", data: _formData);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return 201;
      } else {
        return 404;
      }
    } on DioError catch (e) {
      return e.response.data;
    }
  }
}
