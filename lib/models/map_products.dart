class MapProductsModel {
  int id;
  double price;
  double lat;
  double long;

  MapProductsModel({this.id, this.price, this.lat, this.long});

  factory MapProductsModel.fromApi(Map<String, dynamic> parsedJson) {
    return MapProductsModel(
      id: parsedJson['id'],
      price: parsedJson['price'],
      lat: parsedJson['latitude'],
      long: parsedJson['longitude'],
    );
  }
}
