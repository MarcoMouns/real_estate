class ProductModel {
  int id;
  int categoryColor;
  String facadeName;
  int facadeId;
  int views;
  int cityId;
  String cityName;
  ProductCreator productCreator;
  List<Photos> photosList;
  String title;
  String description;
  String address;
  double price;
  int area;
  int floor;
  int streetWidth;
  int numberOfRooms;
  int numberOfBathRooms;
  int numberOfLivingRooms;
  double latitude;
  double longitude;
  String video;
  int category;
  String categoryName;
  String date;
  bool favored;

  ProductModel(
      {this.id,
      this.cityId,
      this.cityName,
      this.facadeId,
      this.categoryColor,
      this.categoryName,
      this.facadeName,
      this.views,
      this.productCreator,
      this.photosList,
      this.title,
      this.description,
      this.address,
      this.price,
      this.area,
      this.floor,
      this.streetWidth,
    this.numberOfRooms,
    this.numberOfBathRooms,
    this.numberOfLivingRooms,
    this.latitude,
    this.longitude,
    this.video,
    this.category,
    this.date,
    this.favored});

  factory ProductModel.fromApi(Map<String, dynamic> parsedJson) {
    List<Photos> photosList = List<Photos>();
    List data = parsedJson['photos'];
    data.forEach((element) {
      photosList.add(Photos.fromApi(element));
    });

    return ProductModel(
      id: parsedJson['id'],
      cityId: parsedJson['city'],
      cityName: parsedJson['CityName'],
      facadeId: parsedJson['facade'],
      categoryColor: int.parse(parsedJson['categoryColor']),
      categoryName: parsedJson['categoryName'],
      facadeName: parsedJson['facadeName'],
      views: parsedJson['views'],
      favored: parsedJson['favored'],
      productCreator: ProductCreator.fromApi(parsedJson['creatorData']),
      photosList: photosList,
      title: parsedJson['title'],
      description: parsedJson['description'],
      address: parsedJson['address'],
      price: parsedJson['price'],
      area: parsedJson['size'],
      floor: parsedJson['floor'],
      streetWidth: parsedJson['streetWidth'],
      numberOfRooms: parsedJson['numberOfRooms'],
      numberOfBathRooms: parsedJson['numberOfBathRooms'],
      numberOfLivingRooms: parsedJson['numberOfLivingRooms'],
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
      category: parsedJson['category'],
      video: parsedJson['video'] ?? "",
      date: parsedJson['created'],
    );
  }
}

class Photos {
  int id;
  String photo;

  Photos({this.id, this.photo});

  factory Photos.fromApi(Map<String, dynamic> parsedJson) {
    return Photos(
      id: parsedJson['id'],
      photo: parsedJson['photo'],
    );
  }
}

class ProductCreator {
  int id;
  String name;
  String mobile;
  String photo;

  ProductCreator({this.name, this.mobile, this.photo, this.id});

  factory ProductCreator.fromApi(Map<String, dynamic> parsedJson) {
    return ProductCreator(name: parsedJson['name'], photo: parsedJson['photo'], mobile: parsedJson['mobile'],
        id: parsedJson['id']
    );
  }
}
