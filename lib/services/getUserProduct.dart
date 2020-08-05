import 'dart:io';

import 'package:dio/dio.dart';
import 'package:realestate/models/produc_mini_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetUserProduct {
  final String url = "http://api.naffeth.com/";
  final String product = "myProduct/";

  Future<List<ProductMiniModel>> getProduct() async {
    Response response;
    List<ProductMiniModel> productMiniModel = List();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    try {
      response = await Dio().get("$url$product",
          options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
          ));
      List data = response.data;
      data.forEach((value) {
        productMiniModel.add(ProductMiniModel.fromJson(value));
      });
    } on DioError catch (e) {
      print('error in getProduct => ${e.response.data}');
    }
    return productMiniModel;
  }
}
