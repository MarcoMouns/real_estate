import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostViews {
  final String url = "http://api.naffeth.com/";
  final String views = "viewProduct";

  postViews(int productId) async {
    Response response;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token') ?? "";
    try {
      if (token.isNotEmpty)
        response = await Dio().post("$url$views",
            data: {"product": "$productId"},
            options: Options(
                headers: {HttpHeaders.authorizationHeader: "Bearer $token"}));
    } on DioError catch (e) {
      print("error in post views => ${e.response.data}");
    }
  }
}
