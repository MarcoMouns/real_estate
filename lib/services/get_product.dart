import 'dart:io';

import 'package:dio/dio.dart';
import 'package:realestate/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetProduct {
  final String url = "http://api.naffeth.com/";
  final String product = "product/";

  Future<ProductModel> getProduct(int productId) async {
    Response response;
    ProductModel productModel = ProductModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";
    try {
      token.isEmpty
          ? response = await Dio().get(
              "$url$product$productId/",
            )
          : response = await Dio().get(
              "$url$product$productId/",
              options: Options(headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}),
            );
      print(response.data);
      productModel = ProductModel.fromApi(response.data);
    } on DioError catch (e) {
      print('error in getProduct => ${e.response.data}');
    }
    return productModel;
  }
}
