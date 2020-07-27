import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  final String _url = "http://api.naffeth.com/";
  final String _login = "login";
  FormData _formData;

  Future login({String phone, String password}) async {
    _formData = FormData.fromMap({"password": "$password", "mobile": "$phone"});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post("$_url$_login", data: _formData);

      if (response.statusCode == 200) {
        prefs.setString('token', "${response.data['token']}");
        prefs.setString('name', "${response.data['name']}");
        prefs.setString('mobile', "${response.data['mobile']}");
        prefs.setString('photo', "${response.data['photo']}");
        print(response.data);
        return response.statusCode;
      }
    } on DioError catch (e) {
      print(e.response.data);
      return e.response.statusCode;
    }
  }
}
