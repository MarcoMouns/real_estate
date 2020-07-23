class CitiesModel {
  int id;
  String name;
  double lat;
  double long;

  CitiesModel({this.id, this.name, this.lat, this.long});

  factory CitiesModel.fromJson(Map<String, dynamic> parsedJson){
    return CitiesModel(
      id: parsedJson['id'],
      name: parsedJson['name'],
      lat: parsedJson['latitude'],
      long: parsedJson['longitude'],
    );
  }
}