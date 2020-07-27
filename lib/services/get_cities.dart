import 'package:dio/dio.dart';
import 'package:realestate/models/cities.dart';

class GetCities {
  final String url = "http://api.naffeth.com//";
  final String city = "city/";

  Future<List<CitiesModel>> getCities() async {
    Response response;
    List<CitiesModel> citiesModelList = List<CitiesModel>();
    try {
      response = await Dio().get("$url$city");
      List data = response.data;
      data.forEach((element) {
        citiesModelList.add(CitiesModel.fromJson(element));
      });
    } on DioError catch (e) {
      print('error in get cities => ${e.response.data}');
    }
    return citiesModelList;
  }
}
