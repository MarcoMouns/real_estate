class ProductMiniModel {
  int id;
  String title;
  double price;
  int size;
  String timeAr;
  String timeEn;
  int numberOfRooms;
  int numberOfBathRooms;
  String address;
  String photo;
  int categoryColor;
  double lat;
  double long;

  ProductMiniModel({
    this.id,
    this.title,
    this.price,
    this.size,
    this.timeAr,
    this.timeEn,
    this.numberOfRooms,
    this.numberOfBathRooms,
    this.address,
    this.photo,
    this.categoryColor,
    this.long,
    this.lat,
  });

  factory ProductMiniModel.fromJson(Map<String, dynamic> parsedJson) {
    return ProductMiniModel(
      id: parsedJson['id'] ?? 0,
      title: parsedJson['title'] ?? 'unTitled',
      price: parsedJson['price'] ?? 0.0,
      size: parsedJson['size'] ?? 0.0,
      timeAr: parsedJson['time_ar'] ?? "unKnown",
      timeEn: parsedJson['time_en'] ?? "unKnown",
      numberOfRooms: parsedJson['numberOfRooms'] ?? 0,
      numberOfBathRooms: parsedJson['numberOfBathRooms'] ?? 0,
      address: parsedJson['address'] ?? "unKnown",
      photo: parsedJson['photo'] ??
          "https://top10cairo.com/wp-content/uploads/2020/05/Top-Best-Real-Estate-Companies-Agencies-Brokers-Cairo-Egypt.jpg",
      categoryColor: int.parse(parsedJson['categoryColor']) ?? 0xFFC0C0C0,
      long: parsedJson['longitude'],
      lat: parsedJson['latitude'],
    );
  }
}
