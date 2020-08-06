import 'dart:io';

import 'package:dio/dio.dart';
import 'package:realestate/models/produc_mini_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserFavorite {
  final String url = "http://api.naffeth.com/";
  final String favorProduct = "favorProduct";
  final String favoriteProducts = "favoriteProducts";

  Future userFavorite({int id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var data = {'product': "$id"};

    try {
      Response response = await Dio().post(
        "$url$favorProduct",
        data: data,
        options: Options(

            ///bearer token in dio
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}),
      );
      print(response.data);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future<List<ProductMiniModel>> getUserFavorite() async {
    List<ProductMiniModel> productMiniModel = List();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    try {
      Response response = await Dio().get(
        "$url$favoriteProducts",
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}),
      );

      List data = response.data;
      data.forEach((value) {
        productMiniModel.add(ProductMiniModel.fromJson(value));
      });
      //print(response.data);
      return productMiniModel;
    } catch (e) {
      print(e);
      return productMiniModel;
    }
  }
}
