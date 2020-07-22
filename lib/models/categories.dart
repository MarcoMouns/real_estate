class CategoriesModel {
  int id;
  String name;
  int color;

  CategoriesModel({this.id, this.name, this.color});

  factory CategoriesModel.fromJson(Map<String, dynamic> parsedJson) {
    return CategoriesModel(
      id: parsedJson['id'] ?? 0,
      name: parsedJson['name'] ?? 'unTitled',
      color: int.parse(parsedJson['color']) ?? 0xFFC0C0C0,
    );
  }
}
