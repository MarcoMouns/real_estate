import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:realestate/I10n/app_localizations.dart';
import 'package:realestate/chat/List_of_chats.dart';
import 'package:realestate/models/categories.dart';
import 'package:realestate/models/cities.dart';
import 'package:realestate/models/map_products.dart';
import 'package:realestate/models/produc_mini_model.dart';
import 'package:realestate/pages/product/add_product.dart';
import 'package:realestate/pages/product/product_details.dart';
import 'package:realestate/services/get_categories.dart';
import 'package:realestate/services/get_cities.dart';
import 'package:realestate/services/get_mini_product.dart';
import 'package:realestate/services/post_views.dart';
import 'package:realestate/widgets/home_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'options/callUs.dart';
import 'options/favorites.dart';
import 'options/notifications.dart';
import 'options/profile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPage = 0;
  int apiPage = 1;
  int categoryId = 0;

  bool _isVisible = true;
  bool fromTwoWeeksAgoBool = false;
  bool isThereNextPage = true;
  bool isLoadingNewData = false;
  bool isZoomControlsEnabled = true;
  bool isZoomGesturesEnabled = true;
  bool isLoading = true;
  bool showCitiesOnMap = false;

  String bedDropdownValue;
  String bathDropdownValue;

  ScrollController _hideButtonController;

  StreamController<double> controller = StreamController<double>.broadcast();

  List<String> numberOfBedsList = List<String>();
  List<String> numberOfBathsList = List<String>();
  List<ProductMiniModel> productMiniModelList = List<ProductMiniModel>();
  List<CategoriesModel> categoriesModel = List<CategoriesModel>();
  List<MapProductsModel> mapProductsModelList = List<MapProductsModel>();
  List<Marker> _productMarkers = <Marker>[];
  List<Marker> _citiesMarkers = <Marker>[];
  List<CitiesModel> citiesModelList = List<CitiesModel>();

  var selectedRange = RangeValues(0, 1000000);

  Position position;

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  final pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.705260, 46.691267),
    zoom: 14.4746,
  );
  CameraPosition _kCity;

  Completer<GoogleMapController> _controller = Completer();

  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();

  unFocus() {
    searchNode.unfocus();
  }

  getCategories() async {
    categoriesModel = await GetCategories().getCategories();
    categoriesModel.insert(
        0,
        CategoriesModel(
          id: 0,
          name: 'كل المتاح',
          color: 0xFFC0C0C0,
        ));
  }

  getMiniProducts(
      {String search,
      int categoryID,
      double lat,
      double long,
      int numberOfRooms,
      int numberOfBaths,
      double startPrice,
      double endPrice,
      bool fromTwoWeeksAgo}) async {
    productMiniModelList = await GetMiniProduct().getMiniProduct(
      apiPage,
      search: search,
      categoryID: categoryID,
      lat: lat,
      long: long,
      numberOfRooms: numberOfRooms,
      numberOfBaths: numberOfBaths,
      startPrice: startPrice,
      endPrice: endPrice,
      fromTwoWeeksAgo: fromTwoWeeksAgo,
    );
    isLoading = false;
    setState(() {});
    print(productMiniModelList.length);
    isThereNextPage = GetMiniProduct.isThereNextPagebool;
    try {
      position = await getCurrentLocation();
    } catch (e) {}
    _kGooglePlex = CameraPosition(
      target: LatLng(position == null ? 0.0 : position.latitude,
          position == null ? 0.0 : position.longitude),
      zoom: 14.4746,
    );
    await initCitiesMarkers();
    await initProductMarkers();
    print('**************************** $isThereNextPage');
  }

  getMoreMiniProducts(
      {String search,
      int categoryID,
      double lat,
      double long,
      int numberOfRooms,
      int numberOfBaths,
      double startPrice,
      double endPrice,
      bool fromTwoWeeksAgo}) async {
    List<ProductMiniModel> productMiniModelListNew = List<ProductMiniModel>();
    if (isThereNextPage == true) {
      apiPage++;
      productMiniModelListNew = await GetMiniProduct().getMiniProduct(
        apiPage,
        search: search,
        categoryID: categoryID,
        lat: lat,
        long: long,
        numberOfRooms: numberOfRooms,
        numberOfBaths: numberOfBaths,
        startPrice: startPrice,
        endPrice: endPrice,
        fromTwoWeeksAgo: fromTwoWeeksAgo,
      );
      isThereNextPage = GetMiniProduct.isThereNextPagebool;
      productMiniModelList.addAll(productMiniModelListNew);
    }
    isLoadingNewData = false;
    setState(() {});
  }

  getMapProducts({int cityId = 1}) async {
    mapProductsModelList = await GetMiniProduct().getMapProducts(cityId);
    setState(() {});
  }

  getCities() async {
    citiesModelList = await GetCities().getCities();
  }

  Future<Uint8List> getBytesFromCanvas(
      int width, int height, String text) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.blue;
    final Radius radius = Radius.circular(50.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: '$text',
      style: TextStyle(fontSize: 25.0, color: Colors.white),
    );
    painter.layout();
    painter.paint(
        canvas,
        Offset((width * 0.5) - painter.width * 0.5,
            (height * 0.5) - painter.height * 0.5));
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data.buffer.asUint8List();
  }

  initCitiesMarkers() async {
    citiesModelList.forEach((element) async {
      GoogleMapController controller = await _controller.future;
      Uint8List markerIcon =
          await getBytesFromCanvas(200, 100, "${element.name}");
      _citiesMarkers.add(
        Marker(
          markerId: MarkerId('${element.id}'),
          position: LatLng(element.lat, element.long),
          icon: BitmapDescriptor.fromBytes(markerIcon),
          onTap: () {
            isZoomControlsEnabled = true;
            isZoomGesturesEnabled = true;
            showCitiesOnMap = false;
            print(isZoomControlsEnabled);
            print(isZoomGesturesEnabled);
            print(showCitiesOnMap);
            _kCity = CameraPosition(
                target: LatLng(element.lat, element.long), zoom: 14.0);
            controller.animateCamera(CameraUpdate.newCameraPosition(_kCity));
            setState(() {});
          },
          infoWindow: InfoWindow(title: '${element.name}'),
        ),
      );
    });
  }

  initProductMarkers() async {
    mapProductsModelList.forEach((element) async {
      Uint8List markerIcon =
          await getBytesFromCanvas(200, 100, "${element.price}");
      _productMarkers.add(Marker(
          markerId: MarkerId('${element.id}'),
          position: LatLng(element.lat, element.long),
          icon: BitmapDescriptor.fromBytes(markerIcon),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductDetails(element.id),
            ));
          },
          infoWindow: InfoWindow(title: '${element.price}')));
    });
  }

  goToACity() {
    showCitiesOnMap = true;
    setState(() {});
  }

  Future<Position> getCurrentLocation() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  bool onWillPop() {
    if (pageController.page.round() == pageController.initialPage)
      return true;
    else {
      pageController.previousPage(
        duration: Duration(milliseconds: 200),
        curve: Curves.linear,
      );
    }
  }

  String fullName;
  String token = "";

  getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    if (token.isNotEmpty) {
      fullName = prefs.getString('name');
      print(token);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getName();
    getCategories();
    getMiniProducts();
    getMapProducts();
    getCities();
    for (int i = 0; i <= 20; i++) {
      numberOfBedsList.add('$i');
      numberOfBathsList.add('$i');
    }
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() async {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        _isVisible = false;
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        _isVisible = true;
      }

      if (_hideButtonController.position.pixels ==
          _hideButtonController.position.maxScrollExtent) {
        setState(() {
          isLoadingNewData = true;
        });
        getMoreMiniProducts(
          search: searchController.text,
          categoryID: categoryId,
          numberOfRooms:
              bedDropdownValue == null ? 0 : int.parse(bedDropdownValue),
          numberOfBaths:
              bathDropdownValue == null ? 0 : int.parse(bathDropdownValue),
          startPrice: selectedRange.start,
          endPrice: selectedRange.end,
          fromTwoWeeksAgo: fromTwoWeeksAgoBool,
        );
      }
      if (_isVisible == null) _isVisible = true;
      // setState(() {});
      controller.sink.add(1.0);
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
  }

  ///******************homepage in pageViewr******************
  Widget homePage() {
    return SingleChildScrollView(
        controller: _hideButtonController,
        child: GestureDetector(
          onTap: () => unFocus(),
          child: Column(
            children: <Widget>[
              //Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
              Material(
                elevation: 1,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      )),
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          controller: searchController,
                          focusNode: searchNode,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            apiPage = 1;
                            getMiniProducts(search: searchController.text);
                          },
                          decoration: InputDecoration(
                              suffixIcon: searchController.text.isEmpty
                                  ? null
                                  : InkWell(
                                      onTap: () {
                                        searchController.clear();
                                        getMiniProducts();
                                        unFocus();
                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                      ),
                                    ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 0.0,
                                vertical: 0.0,
                              ),
                              prefixIcon: InkWell(
                                onTap: () {
                                  apiPage = 1;
                                  getMiniProducts(
                                      search: searchController.text);
                                },
                                child: Image.asset(
                                  'assets/icons/search.png',
                                  scale: 3.5,
                                ),
                              ),
                              filled: true,
                              fillColor: Color(0xFFF2F3F5),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Color(0xFFF2F3F5)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Color(0xFFF2F3F5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              hintText:
                                  "${AppLocalizations.of(context).translate('search')}"),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categoriesModel.length,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                isLoading = true;
                                setState(() {});
                                apiPage = 1;
                                categoryId = categoriesModel[index].id;
                                await getMiniProducts(
                                    search: searchController.text,
                                    categoryID: categoriesModel[index].id);
                                isLoading = false;
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                height: 50,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 20,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        color:
                                            Color(categoriesModel[index].color),
                                      ),
                                    ),
                                    Text('${categoriesModel[index].name}')
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: productMiniModelList.length,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: InkWell(
                            onTap: () {
                              PostViews()
                                  .postViews(productMiniModelList[index].id);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductDetails(
                                    productMiniModelList[index].id),
                              ));
                            },
                            child: HomeCard(
                              id: productMiniModelList[index].id,
                              title: productMiniModelList[index].title,
                              price: productMiniModelList[index].price,
                              size: productMiniModelList[index].size,
                              time: Localizations.localeOf(context)
                                          .languageCode ==
                                      "en"
                                  ? productMiniModelList[index].timeEn
                                  : productMiniModelList[index].timeAr,
                              numberOfRooms:
                                  productMiniModelList[index].numberOfRooms,
                              numberOfBathRooms:
                                  productMiniModelList[index].numberOfBathRooms,
                              address: productMiniModelList[index].address,
                              photo: productMiniModelList[index].photo,
                              categoryColor:
                                  productMiniModelList[index].categoryColor,
                            ),
                          ),
                        );
                      },
                    ),
              isLoadingNewData
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
            ],
          ),
        ));
  }

  ///*****************Filter Dialog***************

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('فلتر'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 35,
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categoriesModel.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: InkWell(
                                onTap: () {
                                  categoryId = categoriesModel[index].id;
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      border: Border.all(
                                          color: Color(
                                              categoriesModel[index].color),
                                          width: 2)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${categoriesModel[index].name}",
                                    style: TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ));
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                    ),
                    InkWell(
                      onTap: () async {
                        position = await getCurrentLocation();
                        setState(() {});
                        print(position);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border:
                              Border.all(color: Color(0xFFCCCCCC), width: 2),
                          color: position == null
                              ? Colors.transparent
                              : Colors.blue,
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                            ),
                            Image.asset(
                              'assets/icons/pin.png',
                              scale: 4,
                              color: Color(0xFFF99743),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                            ),
                            Text(
                              "${AppLocalizations.of(context).translate('currentLocation')}",
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/icons/bed.png',
                              scale: 4,
                              color: Color(0xFFF99743),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                            ),
                            Text(
                                "${AppLocalizations.of(context).translate('bedroomNumber')}"),
                          ],
                        ),
                        Container(
                          width: 60,
                          height: 30,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            border: Border.all(color: Color(0xFFCCCCCC)),
                          ),
                          alignment: Alignment.center,
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: bedDropdownValue,
                            hint: Text('0'),
                            icon: Image.asset(
                              'assets/icons/downArrow.png',
                              scale: 5,
                            ),
                            iconSize: 24,
                            underline: SizedBox(),
                            style: TextStyle(
                              color: Colors.deepPurple,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                bedDropdownValue = newValue;
                                print(bedDropdownValue);
                              });
                            },
                            items: numberOfBedsList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/icons/bath.png',
                              scale: 4,
                              color: Color(0xFFF99743),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                            ),
                            Text(
                                "${AppLocalizations.of(context).translate('bathroomNumber')}"),
                          ],
                        ),
                        Container(
                          width: 60,
                          height: 30,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            border: Border.all(color: Color(0xFFCCCCCC)),
                          ),
                          alignment: Alignment.center,
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: bathDropdownValue,
                            hint: Text('0'),
                            icon: Image.asset(
                              'assets/icons/downArrow.png',
                              scale: 5,
                            ),
                            iconSize: 24,
                            underline: SizedBox(),
                            style: TextStyle(
                              color: Colors.deepPurple,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                bathDropdownValue = newValue;
                                print(bathDropdownValue);
                              });
                            },
                            items: numberOfBathsList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          color: Colors.orange,
                          size: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                        ),
                        Text(
                            "${AppLocalizations.of(context).translate('price')}")
                      ],
                    ),
                    RangeSlider(
                      values: selectedRange,
                      divisions: 1000,
                      min: 0,
                      max: 1000000,
                      labels: RangeLabels(
                          '${selectedRange.start}', '${selectedRange.end}'),
                      onChanged: (RangeValues newRange) {
                        setState(() {
                          selectedRange = newRange;
                        });
                      },
                    ),
                    Row(
                      children: <Widget>[
                        CupertinoSwitch(
                          value: fromTwoWeeksAgoBool,
                          onChanged: (bool value) {
                            setState(() {
                              fromTwoWeeksAgoBool = value;
                            });
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                        ),
                        Text(
                          "${AppLocalizations.of(context).translate('adDurationSwitch')}",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    Text('Would you like to approve of this message?'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('موافق'),
                  onPressed: () {
                    apiPage = 1;
                    getMiniProducts(
                      search: searchController.text,
                      categoryID: categoryId,
                      numberOfRooms: bedDropdownValue == null
                          ? 0
                          : int.parse(bedDropdownValue),
                      numberOfBaths: bathDropdownValue == null
                          ? 0
                          : int.parse(bathDropdownValue),
                      startPrice: selectedRange.start,
                      endPrice: selectedRange.end,
                      lat: position == null ? 0 : position.latitude,
                      long: position == null ? 0 : position.longitude,
                      fromTwoWeeksAgo: fromTwoWeeksAgoBool,
                    );
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('رجوع'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// *************************Scaffold***********************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            bottomLeft: Radius.circular(40),
          ),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            SizedBox(
              height: 125,
              child: DrawerHeader(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                    )),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    Image.asset(
                      'assets/images/person.png',
                      scale: 5,
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    Text('${fullName ?? "مستخدم جديد"}'),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text("${AppLocalizations.of(context).translate('home')}"),
              leading: Image.asset(
                'assets/icons/home.png',
                scale: 3.5,
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Home(),
                ));
              },
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Divider(
                thickness: 1,
              ),
            ),
            ListTile(
              title: Text("${AppLocalizations.of(context).translate('newAd')}"),
              leading: Image.asset(
                'assets/icons/ad.png',
                scale: 3.5,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddProductScreen(),
                ));
              },
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Divider(
                thickness: 1,
              ),
            ),
            ListTile(
              title: Text(
                  "${AppLocalizations.of(context).translate('mamlakaArea')}"),
              leading: Image.asset(
                'assets/icons/country.png',
                scale: 3.5,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Divider(
                thickness: 1,
              ),
            ),
            ListTile(
              title: Text("${AppLocalizations.of(context).translate('chat')}"),
              leading: Image.asset(
                'assets/icons/chat.png',
                scale: 3.5,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ListOfChatsClass(true),
                ));
              },
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Divider(
                thickness: 1,
              ),
            ),
//            ListTile(
//              title: Text("${AppLocalizations.of(context).translate('aboutApp')}"),
//              leading: Image.asset(
//                'assets/icons/aboutApp.png',
//                scale: 3.5,
//              ),
//              onTap: () {
//                Navigator.of(context).pop();
//              },
//            ),
//            SizedBox(
//              width: MediaQuery.of(context).size.width * 0.65,
//              child: Divider(
//                thickness: 1,
//              ),
//            ),
            ListTile(
              title:
                  Text("${AppLocalizations.of(context).translate('callUs')}"),
              leading: Image.asset(
                'assets/icons/phoneHolder.png',
                scale: 3.5,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CallUs(),
                ));
              },
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Divider(
                thickness: 1,
              ),
            ),
            ListTile(
              title: Text(
                  "${AppLocalizations.of(context).translate('favorites')}"),
              leading: Image.asset(
                'assets/icons/roundStar.png',
                scale: 1.7,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Favorites(),
                ));
              },
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Divider(
                thickness: 1,
              ),
            ),
            ListTile(
              title:
                  Text("${AppLocalizations.of(context).translate('setting')}"),
              leading: Image.asset(
                'assets/icons/star.png',
                scale: 3.5,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Profile(),
                ));
              },
            ),
          ],
        )),
      ),
      appBar: AppBar(
        elevation: 0.0,
        leading: InkWell(
          onTap: () => _drawerKey.currentState.openDrawer(),
          child: Image.asset('assets/icons/drawer.png', scale: 3),
        ),
        title: Text("نفذ"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              position = null;
              setState(() {});
              _showMyDialog();
            },
            icon: Icon(
              Icons.filter_list,
              color: Colors.orange,
              size: 30,
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Notifications(),
            )),
            child: Image.asset(
              'assets/icons/bell.png',
              scale: 3.7,
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          WillPopScope(
            onWillPop: () => Future.sync(onWillPop),
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                homePage(),
                GoogleMap(
                  mapType: MapType.normal,
                  markers: showCitiesOnMap
                      ? Set<Marker>.of(_citiesMarkers)
                      : Set<Marker>.of(_productMarkers),
                  zoomControlsEnabled: isZoomControlsEnabled,
                  zoomGesturesEnabled: isZoomGesturesEnabled,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  onCameraMove: (position) {
                    print(position.zoom);
                    if (position.zoom < 9) {
                      isZoomControlsEnabled = false;
                      isZoomGesturesEnabled = false;
                      showCitiesOnMap = true;
                      setState(() {});
                    } else if (position.zoom == 14) {
                      isZoomControlsEnabled = true;
                      isZoomGesturesEnabled = true;
                      showCitiesOnMap = false;
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: controller.stream,
            builder: (context, snapshot) {
              return Visibility(
                visible: _isVisible,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: 10),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.37,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
//                      boxShadow: currentPage == 0
//                          ? [
//                              BoxShadow(
//                                color: Colors.grey,
//                                blurRadius: 1.0,
//                              ),
//                            ]
                      //                         : null,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              pageController.jumpToPage(
                                0,
//                                                duration: Duration(
//                                                    milliseconds:
//                                                    500),
//                                                curve:
//                                                Cubic(1, 1, 1, 1),
                              );
                              setState(() {
                                currentPage = 0;
                              });
                            },
                            child: Container(
                              width: 60,
                              height: 46,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(27)),
                                color: _isVisible == true && currentPage == 0
                                    ? Color(0xFFF99743)
                                    : _isVisible == true && currentPage != 0
                                        ? Colors.transparent
                                        : Colors.transparent,
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.dehaze,
                                color: _isVisible == true && currentPage == 0
                                    ? Colors.white
                                    : _isVisible == true && currentPage != 0
                                        ? Color(0xFF6C6C6C)
                                        : Color(0xFF6C6C6C),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              pageController.jumpToPage(
                                1,
//                                                duration: Duration(
//                                                    milliseconds:
//                                                    500),
//                                                curve:
//                                                Cubic(1, 1, 1, 1),
                              );
                              setState(() {
                                currentPage = 1;
                              });
                            },
                            child: Container(
                              width: 65,
                              height: 46,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(27)),
                                color: _isVisible == true && currentPage == 1
                                    ? Color(0xFFF99743)
                                    : _isVisible == true && currentPage != 1
                                        ? Colors.transparent
                                        : Colors.transparent,
                              ),
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/icons/pin.png',
                                scale: 3,
                                color: _isVisible == true && currentPage == 1
                                    ? Colors.white
                                    : _isVisible == true && currentPage != 1
                                        ? Color(0xFF6C6C6C)
                                        : Color(0xFF6C6C6C),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
