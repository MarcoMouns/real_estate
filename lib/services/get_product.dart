import 'package:dio/dio.dart';
import 'package:realestate/models/product_model.dart';

class GetProduct {
  final String url = "http://api.naffeth.com/";
  final String product = "product/";

  Future<ProductModel> getProduct(int productId) async {
    Response response;
    ProductModel productModel = ProductModel();
    try {
      response = await Dio().get("$url$product$productId/");
      productModel = ProductModel.fromApi(response.data);
    } on DioError catch (e) {
      print('error in getProduct => ${e.response.data}');
    }
    return productModel;
  }
}
