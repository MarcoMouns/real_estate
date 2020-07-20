class FacadeModel {
  int id;
  String name;

  FacadeModel({this.id, this.name});

  factory FacadeModel.fromApi(Map<String, dynamic> parsedJson) {
    return FacadeModel(
      id: parsedJson['id'] ?? 0,
      name: parsedJson['name'] ?? 'unTitled',
    );
  }
}
