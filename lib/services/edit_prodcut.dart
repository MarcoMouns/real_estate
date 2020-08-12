import 'dart:io';

import 'package:dio/dio.dart';

class EditProduct {
  final String url = "http://api.naffeth.com/";
  final String product = "product/";

  Future editProduct({
    String title,
    String price,
    String address,
    String streetWide,
    String area,
    String description,
    String token,
    int categoryId,
    int facade,
    int city,
    int numberOfBeds = 0,
    int numberOfBaths = 0,
    int lounges = 0,
    int floorNumber = 0,
    double lat,
    double long,
    List<File> images,
    File video,
    int productId,
  }) async {
    Map<String, dynamic> map = Map<String, dynamic>();

    List<MultipartFile> multipartFilePhotosList = List<MultipartFile>();

    print(productId);
    if (title != null) map.putIfAbsent("title", () => title);
    if (price != null) map.putIfAbsent("price", () => price);
    if (address != null) map.putIfAbsent("address", () => address);
    if (area != null) map.putIfAbsent("size", () => area);
    if (description != null) map.putIfAbsent("description", () => description);
    if (streetWide != null) map.putIfAbsent("streetWidth", () => streetWide);

    if (categoryId != null) map.putIfAbsent("category", () => categoryId);
    if (facade != null) map.putIfAbsent("facade", () => facade);
    if (city != null) map.putIfAbsent("city", () => city);
    if (numberOfBeds != null) map.putIfAbsent("numberOfRooms", () => numberOfBeds);
    if (numberOfBaths != null) map.putIfAbsent("numberOfBathRooms", () => numberOfBaths);
    if (lounges != null) map.putIfAbsent("numberOfLivingRooms", () => lounges);
    if (floorNumber != null) map.putIfAbsent("floor", () => floorNumber);
    if (lat != null) map.putIfAbsent("latitude", () => lat);
    if (long != null) map.putIfAbsent("longitude", () => long);
    if (video != null) map.putIfAbsent("video", () => MultipartFile.fromFileSync(video.path));

    if (images.isNotEmpty) {
      images.forEach((photo) async {
        multipartFilePhotosList.add(MultipartFile.fromFileSync("${photo.path}"));
        print(photo.path);
      });
      map.putIfAbsent("photos", () => multipartFilePhotosList);
    }

    FormData formData = FormData.fromMap(map);
    Response response;

    map.forEach((key, value) {
      print(key);
      print(value);
    });

    print(formData.length);

    try {
      response =
          await Dio().patch("$url$product$productId/", data: formData, options: Options(headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));
      print(response.data);
      return 'success';
    } on DioError catch (e) {
      print('error in edit product => ${e.response.data}');
    }
  }
}
