import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditUser {
  final String _url = "http://api.naffeth.com/";
  final String _edit = "user/";
  FormData _formData;

  Future editUser(
      {String name, String phone, String password, File image}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    print(password);
    image == null && password.isEmpty
        ? _formData = FormData.fromMap({"name": "$name", "mobile": "$phone"})
        : password.isEmpty
            ? _formData = FormData.fromMap({
                "name": "$name",
                "mobile": "$phone",
                "photo": await MultipartFile.fromFile("${image.path}"),
              })
            : _formData = FormData.fromMap({
                "name": "$name",
                "password": "$password",
                "photo": await MultipartFile.fromFile("${image.path}"),
                "mobile": "$phone"
              });
    try {
      Response response = await Dio().patch("$_url$_edit",
          data: _formData,
          options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
          ));
      if (response.statusCode == 200) {
        print(response.data);
        prefs.setString('token', "${response.data['token']}");
        prefs.setString('name', "${response.data['name']}");
        prefs.setString('mobile', "${response.data['mobile']}");
        prefs.setString('photo', "${response.data['photo']}");
        prefs.setInt('id', response.data['id']);

        return 200;
      }
    } on DioError catch (e) {
      print(e.response.data);
      return e.response.statusCode;
    }
  }
}
