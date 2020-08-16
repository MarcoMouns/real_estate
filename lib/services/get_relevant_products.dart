import 'package:dio/dio.dart';
import 'package:realestate/models/produc_mini_model.dart';

class GetRelevantProducts {
  String url = "http://api.naffeth.com/";
  String relevant = "relevantProducts?";
  String categoryParam = "category=";
  String excludeParam = "exclude=";

  Future<List<ProductMiniModel>> getRelevantProducts(int categoryID, int productId) async {
    Response response;
    List<ProductMiniModel> productMiniModelList = List<ProductMiniModel>();
    try {
      response = await Dio().get("$url$relevant$categoryParam$categoryID&$excludeParam$productId");
      List data = response.data;
      data.forEach((element) {
        productMiniModelList.add(ProductMiniModel.fromJson(element));
      });
      return productMiniModelList;
    } on DioError catch (e) {
      print('error in get relevant product => ${e.response.data}');
    }
  }
}
