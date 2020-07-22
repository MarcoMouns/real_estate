import 'package:dio/dio.dart';
import 'package:realestate/models/produc_mini_model.dart';

class GetMiniProduct {
  final String url = "http://134.209.25.40/";
  final String product = "product/?";
  static bool isThereNextPagebool;

  Future<List<ProductMiniModel>> getMiniProduct(int page,
      {String search,
      int categoryID,
      double lat,
      double long,
      int numberOfRooms,
      int numberOfBaths,
      double startPrice,
      double endPrice,
      bool fromTwoWeeksAgo}) async {
    Response response;
    List<ProductMiniModel> productMiniModelList = List<ProductMiniModel>();

    /// to see if there is a next page or not cuz if we send a page number that doesn`t have products in it
    /// it will return error 500 ... why we can`t send empty list instead ask the genius backEnd
    String next;
    String searchApi =
        search == null || search.isEmpty ? '' : '&search=$search';
    String categoryApi =
        categoryID == null || categoryID == 0 ? '' : '&category=$categoryID';
    String latApi =
        lat == null || lat == 0 ? '' : '&latitude=$lat&longitude=$long';
    String numberOfRoomsApi = numberOfRooms == null || numberOfRooms == 0
        ? ''
        : '&numberOfRooms=$numberOfRooms';
    String numberOfBathsApi = numberOfBaths == null || numberOfBaths == 0
        ? ''
        : '&numberOfBathRooms=$numberOfBaths';
    String startPriceApi =
        startPrice == null ? '' : '&price=$startPrice,$endPrice';
    String fromTwoWeeksAgoApi =
        fromTwoWeeksAgo == null || fromTwoWeeksAgo == false
            ? ''
            : '&last2Weeks=1';

    print('=========>  $latApi');

    try {
      response = await Dio().get("$url$product" +
          "page=$page&size=10" +
          "$searchApi$categoryApi$numberOfRoomsApi$numberOfBathsApi$startPriceApi$fromTwoWeeksAgoApi$latApi");
      List data = response.data['results'];
      next = response.data['next'];
      isThereNextPagebool = isThereNextPage(next);
      print(isThereNextPagebool);
      data.forEach((element) {
        productMiniModelList.add(ProductMiniModel.fromJson(element));
      });
    } on DioError catch (e) {
      print('error in getMiniProduct => ${e.response.data}');
    }
    return productMiniModelList;
  }

  bool isThereNextPage(String next) {
    if (next == null)
      return false;
    else
      return true;
  }
}
