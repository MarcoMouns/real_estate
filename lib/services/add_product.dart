import 'dart:io';

import 'package:dio/dio.dart';

class AddProduct {
  final String url = "http://api.naffeth.com/";
  final String product = "product/";

  Future addProduct(
      {String title,
      String price,
      String address,
      int categoryId,
      double lat,
      double long,
      String area,
      int facade,
      int city,
      int numberOfBeds = 0,
      int numberOfBaths = 0,
      int lounges = 0,
      String streetWide,
      int floorNumber = 0,
      String description,
      List<File> images,
      File video,
      String token}) async {
    Response response;
    List<MultipartFile> multipartFilePhotosList = List<MultipartFile>();
    if (images.isNotEmpty)
      images.forEach((photo) async {
        multipartFilePhotosList
            .add(MultipartFile.fromFileSync("${photo.path}"));
      });

    FormData formData = FormData.fromMap({
      "title": "$title",
      "description": "$description",
      "address": "$address",
      "price": "$price",
      "size": "$area",
      "floor": "$floorNumber",
      "streetWidth": "$streetWide",
      "numberOfRooms": "$numberOfBeds",
      "numberOfBathRooms": "$numberOfBeds",
      "numberOfLivingRooms": "$lounges",
      "latitude": "$lat",
      "longitude": "$long",
      "video": video == null ? null : await MultipartFile.fromFile(video.path),
      "category": "$categoryId",
      "facade": facade,
      "photos": multipartFilePhotosList,
      "city": "$city"
    });

    try {
      response = await Dio().post("$url$product",
          data: formData,
          options: Options(
              headers: {HttpHeaders.authorizationHeader: "Bearer $token"}));
      print(response.data);
      return 'success';
    } on DioError catch (e) {
      print('error from add product => ${e.response.data}');
      return "${e.response.data}";
    }
  }
}
