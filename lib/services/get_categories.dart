import 'package:dio/dio.dart';
import 'package:realestate/models/categories.dart';

class GetCategories {
  final String url = "http://134.209.25.40/";
  final String categories = "category/";

  Future<List<CategoriesModel>> getCategories() async {
    List<CategoriesModel> categoriesModel = List<CategoriesModel>();
    Response response;
    try {
      response = await Dio().get('$url$categories');
      List data = response.data;
      data.forEach((element) {
        categoriesModel.add(CategoriesModel.fromJson(element));
      });
    } on DioError catch (e) {
      print('error from get categoreis => ${e.response.data}');
    }
    return categoriesModel;
  }
}
