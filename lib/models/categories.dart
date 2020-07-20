class CategoriesModel {
  int id;
  String name;
  String color;

  CategoriesModel({this.id, this.name, this.color});

  factory CategoriesModel.fromJson(Map<String, dynamic> parsedJson) {
    return CategoriesModel(
      id: parsedJson['id'] ?? 0,
      name: parsedJson['name'] ?? 'unTitled',
      color: parsedJson['color'] ?? 'C0C0C0',
    );
  }
}
