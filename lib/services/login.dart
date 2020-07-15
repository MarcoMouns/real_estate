import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login {
  final String _url = "http://134.209.25.40/";
  final String _login = "login";
  FormData _formData;

  Future<int> login({String phone, String password}) async {
    _formData = FormData.fromMap({"password": "$password", "phone": "$phone"});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post("$_url$_login", data: _formData);

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
