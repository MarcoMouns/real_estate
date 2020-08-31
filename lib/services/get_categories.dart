import 'package:dio/dio.dart';
import 'package:realestate/models/categories.dart';

class GetCategories {
  final String url = "http://api.naffeth.com/";
  final String categories = "category/";

  Future<List<CategoriesModel>> getCategories() async {
    List<CategoriesModel> categoriesModel = List<CategoriesModel>();
    Response response;
    try {
      response = await Dio().get('$url$categories');
      print('*******************');
      print(response.data);
      print('*******************');
      List data = response.data;
      data.forEach((element) {
        categoriesModel.add(CategoriesModel.fromJson(element));
      });
    } on DioError catch (e) {
      print('error from get categoreis => ${e.response.data}');
      categoriesModel
          .add(CategoriesModel(id: 0, name: "unTitled", color: 0xFFC0C0C0));
    }
    return categoriesModel;
  }
}
