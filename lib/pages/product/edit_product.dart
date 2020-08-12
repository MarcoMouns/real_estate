import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realestate/I10n/app_localizations.dart';
import 'package:realestate/models/categories.dart';
import 'package:realestate/models/cities.dart';
import 'package:realestate/models/facade.dart';
import 'package:realestate/models/product_model.dart';
import 'package:realestate/pages/home.dart';
import 'package:realestate/services/edit_prodcut.dart';
import 'package:realestate/services/get_categories.dart';
import 'package:realestate/services/get_cities.dart';
import 'package:realestate/services/get_facades.dart';
import 'package:realestate/services/get_product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class EditProductScreen extends StatefulWidget {
  final int productId;

  EditProductScreen(this.productId);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  int categoryId;
  int cityId;
  int facadeId;
  int numberOfBeds;
  int numberOfBaths;
  int loungesNumber;
  int floorNumber;
  int newCityId;
  int newCategoryId;
  int newFacadeId;

  double newLat;
  double newLong;

  String bedDropdownValue;
  String frontDropdownValue;
  String bathDropdownValue;
  String loungesDropdownValue;
  String floorDropdownValue;
  String token;
  String adType = "";
  String city = "";
  String newTitle;
  String newAddress;
  String newAdType;
  String newLocation;
  String newArea;
  String newNumberOfRooms;
  String newNumberOfBathRoom;
  String newNumberOfLivingRoom;
  String newStreetWidth;
  String newFloorNumber;
  String newPrice;
  String newDesc;

  bool isLoading = true;
  bool positionError = true;
  bool positionTextError = false;
  bool categoryTextError = false;
  bool areaError = false;
  bool streetWideError = false;
  bool titleError = false;
  bool addressError = false;
  bool contentError = false;
  bool priceError = false;
  bool isUploadLoading = false;
  bool cityError = false;

//  bool isTitleChanged = false;
//  bool isAddressChanged = false;
//  bool isAdTypeChanged =false;
//  bool isCityChanged = false;
//  bool isMapLocationChanged = false;
//  bool isAreaChanged = false;
//  bool isFascadChanged = false;
//  bool isNumberOfRoomsChanged = false;
//  bool isNumberOfBathsChanged = false;
//  bool isNumberOfLivingRoomChanged = false;
//  bool isStreetWidthChanged = false;
//  bool isFloorNumberChanged = false;
//  bool isPriceChanged = false;
//  bool isDescChanged = false;
//  bool isVideoChanged = false;
//  bool isPhotosChanged = false;

  List<String> numberOfBedsList = List<String>();
  List<String> numberOfBathsList = List<String>();
  List<String> loungesList = List<String>();
  List<String> floorList = List<String>();
  List<CategoriesModel> categoriesModel = List<CategoriesModel>();
  List<FacadeModel> facadeModelList = List<FacadeModel>();
  List<CitiesModel> citiesModelList = List<CitiesModel>();
  List<File> _assetImages = List<File>();
  List<Photos> _networkImages = List<Photos>();

  TextEditingController titleController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController streetWideController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  FocusNode contentNode = FocusNode();
  FocusNode areaNode = FocusNode();
  FocusNode streetWideNode = FocusNode();
  FocusNode titleNode = FocusNode();
  FocusNode addressNode = FocusNode();
  FocusNode priceNode = FocusNode();

  Position position;

  File video;

  final picker = ImagePicker();

  PickResult selectedPlace;

  VideoPlayerController _videoPlayerController;

  ProductModel productModel;

  unFocus() {
    contentNode.unfocus();
    areaNode.unfocus();
    streetWideNode.unfocus();
    titleNode.unfocus();
    addressNode.unfocus();
    priceNode.unfocus();
  }

  checkToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token') ?? "";
    print('token => $token');
  }

  getCategories() async {
    categoriesModel = await GetCategories().getCategories();
  }

  getFacade() async {
    facadeModelList = await GetFacade().getFacade();
  }

  getCities() async {
    citiesModelList = await GetCities().getCities();
  }

  getLocation() async {
    try {
      position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      positionError = false;
    } catch (e) {
      print('position error');
      positionError = true;
    }
    if (mounted) setState(() {});
  }

  getVideo() async {
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      video = File(pickedFile.path);
      _videoPlayerController = VideoPlayerController.file(
        video,
      );
      _videoPlayerController.addListener(() {
        if (mounted) setState(() {});
      });
      _videoPlayerController.setLooping(true);
      _videoPlayerController.initialize();
      setState(() {});
    }
  }

  getPhoto(int index) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (_assetImages.isNotEmpty) {
        ///we use asMap as if the index is null it doesn`t cause an error as list is non-nullable
        if (_assetImages.asMap()[index] == null) {
          print('in add');
          _assetImages.add(File(pickedFile.path));
        } else {
          print('in insert');
          _assetImages[index] = File(pickedFile.path);
        }
      } else
        _assetImages.add(File(pickedFile.path));
      print(index);
      setState(() {});
    }
  }

  validate(BuildContext context) async {
    if (titleController.text != productModel.title) newTitle = titleController.text;
    if (addressController.text != productModel.address) newAddress = addressController.text;
    if (areaController.text != productModel.area.toString()) newArea = areaController.text;
    if (streetWideController.text != productModel.streetWidth.toString()) newStreetWidth = streetWideController.text;
    if (priceController.text != productModel.price.toString()) newPrice = priceController.text;
    if (contentController.text != productModel.description) newDesc = contentController.text;
    if (facadeId != null && facadeId != productModel.facadeId) newFacadeId = facadeId;
    if (bedDropdownValue != productModel.numberOfRooms.toString()) newNumberOfRooms = bedDropdownValue;
    if (bathDropdownValue != productModel.numberOfBathRooms.toString()) newNumberOfBathRoom = bathDropdownValue;
    if (loungesDropdownValue != productModel.numberOfLivingRooms.toString()) newNumberOfLivingRoom = loungesDropdownValue;
    if (floorDropdownValue != productModel.floor.toString()) newFloorNumber = floorDropdownValue;
    if (cityId != productModel.cityId) newCityId = cityId;
    if (categoryId != productModel.category) newCategoryId = categoryId;
    if (position.latitude != productModel.latitude && position.longitude != productModel.longitude) {
      newLat = position.latitude;
      newLong = position.latitude;
    }

    if (position == null)
      positionTextError = true;
    else
      positionTextError = false;
    if (categoryId == null)
      categoryTextError = true;
    else
      categoryTextError = false;
    if (areaController.text.isEmpty)
      areaError = true;
    else
      areaError = false;
    if (streetWideController.text.isEmpty)
      streetWideError = true;
    else
      streetWideError = false;
    if (titleController.text.isEmpty)
      titleError = true;
    else
      titleError = false;
    if (addressController.text.isEmpty)
      addressError = true;
    else
      addressError = false;
    if (contentController.text.isEmpty)
      contentError = true;
    else
      contentError = false;
    if (priceController.text.isEmpty)
      priceError = true;
    else
      priceError = false;
    if (city.isEmpty)
      cityError = true;
    else
      cityError = false;
    if (position != null &&
        categoryId != null &&
        areaController != null &&
        streetWideController.text.isNotEmpty &&
        titleController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        contentController.text.isNotEmpty &&
        priceController.text.isNotEmpty) {
      isUploadLoading = true;
      setState(() {});
      String response = await EditProduct().editProduct(
        productId: productModel.id,
        token: token,
        title: newTitle,
        address: newAddress,
        city: newCityId,
        categoryId: newCategoryId,
        lat: newLat,
        long: newLong,
        area: newArea,
        numberOfBeds: newNumberOfRooms == null ? newNumberOfRooms : int.parse(newNumberOfRooms),
        numberOfBaths: newNumberOfBathRoom == null ? newNumberOfBathRoom : int.parse(newNumberOfBathRoom),
        lounges: newNumberOfLivingRoom == null ? newNumberOfLivingRoom : int.parse(newNumberOfLivingRoom),
        floorNumber: newFloorNumber == null ? newFloorNumber : int.parse(newFloorNumber),
        streetWide: newStreetWidth,
        facade: newFacadeId,
        description: newDesc,
        price: newPrice,
        images: _assetImages,
        video: video,
      );
      if (response == 'success') {
        isUploadLoading = false;
        final snackBar = SnackBar(content: Text('upload complete'));
// Find the Scaffold in the widget tree and use it to show a SnackBar.
        Scaffold.of(context).showSnackBar(snackBar);
        setState(() {});
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Home(),
        ));
      } else {
        isUploadLoading = false;
        final snackBar = SnackBar(content: Text('$response'));
// Find the Scaffold in the widget tree and use it to show a SnackBar.
        Scaffold.of(context).showSnackBar(snackBar);
        setState(() {});
      }
    }
    setState(() {});
  }

  getData() async {
    await getCategories();
    await getFacade();
    await getCities();
    await getProductDetails();
    isLoading = false;
    setState(() {});
  }

  getProductDetails() async {
    productModel = await GetProduct().getProduct(widget.productId);
    titleController.text = productModel.title;
    addressController.text = productModel.address;
    areaController.text = productModel.area.toString();
    streetWideController.text = productModel.streetWidth.toString();
    priceController.text = productModel.price.toString();
    contentController.text = productModel.description;
    if (productModel.facadeName.isNotEmpty && productModel.facadeName != null) frontDropdownValue = productModel.facadeName;
    bedDropdownValue = productModel.numberOfRooms.toString();
    bathDropdownValue = productModel.numberOfBathRooms.toString();
    loungesDropdownValue = productModel.numberOfLivingRooms.toString();
    floorDropdownValue = productModel.floor.toString();
    cityId = productModel.cityId;
    categoryId = productModel.category;
    position = Position(longitude: productModel.longitude, latitude: productModel.latitude);
    if (productModel.facadeId != null) facadeId = productModel.facadeId;
    if (productModel.facadeName.isNotEmpty) frontDropdownValue = productModel.facadeName;
    adType = productModel.categoryName;
    city = productModel.cityName;
    if (productModel.photosList[0].id != 0) _networkImages = productModel.photosList;

    List<String> photos = List<String>();
    if (productModel.video.isNotEmpty && productModel.video != null) {
      _videoPlayerController = VideoPlayerController.network('${productModel.video}')
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          if (mounted) setState(() {});
        });
      _videoPlayerController.setLooping(true);
    }
    productModel.photosList.forEach((element) {
      photos.add(element.photo);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkToken();
    getData();
    for (int i = 0; i <= 20; i++) {
      numberOfBedsList.add('$i');
      numberOfBathsList.add('$i');
      loungesList.add('$i');
      floorList.add('$i');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 65),
          child: SafeArea(
            child: Material(
              elevation: 1,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(27), bottomLeft: Radius.circular(20)),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(27), bottomLeft: Radius.circular(20)),
                    color: Colors.white,
                  ),
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    title: Text('${AppLocalizations.of(context).translate('editProduct')}'),
                    centerTitle: true,
                  )),
            ),
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : token.isEmpty
                ? Center(
                    child: Text("please log in"),
                  )
                : Builder(
                    builder: (context) {
                      return SingleChildScrollView(
                        child: GestureDetector(
                          onTap: () => unFocus(),
                          child: Column(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: TextField(
                                  controller: titleController,
                                  focusNode: titleNode,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 25,
                                        vertical: 0,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: Color(0xFFB9B9B9))),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: Color(0xFFB9B9B9))),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: Colors.blue)),
                                      hintText: "${AppLocalizations.of(context).translate('title')}"),
                                ),
                              ),
                              titleError
                                  ? Text(
                                      '${AppLocalizations.of(context).translate('titleErrorMsg')}',
                                      style: TextStyle(color: Colors.red),
                                    )
                                  : Container(),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: TextField(
                                  controller: addressController,
                                  focusNode: addressNode,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 25,
                                        vertical: 0,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: Color(0xFFB9B9B9))),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: Color(0xFFB9B9B9))),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: Colors.blue)),
                                      hintText: "${AppLocalizations.of(context).translate('address')}"),
                                ),
                              ),
                              addressError
                                  ? Text('${AppLocalizations.of(context).translate('addressErrorMsg')}', style: TextStyle(color: Colors.red))
                                  : Container(),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
//              height: MediaQuery.of(context).size.height * 0.05,
//              decoration: BoxDecoration(
//                borderRadius: BorderRadius.all(Radius.circular(20)),
//                border: Border.all(color: Color(0xFFCCCCCC))
//              ),
                                child: ExpansionTile(
                                  trailing: Image.asset(
                                    'assets/icons/downArrow.png',
                                    scale: 4,
                                  ),
                                  title: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/icons/ad.png',
                                        scale: 4,
                                        color: Color(0xFFF99743),
                                      ),
                                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                      Text(
                                        adType.isEmpty ? "${AppLocalizations.of(context).translate('adType')}" : "$adType",
                                        style: TextStyle(fontSize: 18),
                                      )
                                    ],
                                  ),
                                  children: categoriesModel.map((value) {
                                    return InkWell(
                                      onTap: () {
                                        categoryId = value.id;
                                        adType = value.name;
                                        setState(() {});
                                      },
                                      child: Text("${value.name}"),
                                    );
                                  }).toList(),
                                ),
                              ),
                              categoryTextError
                                  ? Text('${AppLocalizations.of(context).translate('categoryErrorMsg')}', style: TextStyle(color: Colors.red))
                                  : Container(),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
//              height: MediaQuery.of(context).size.height * 0.05,
//              decoration: BoxDecoration(
//                borderRadius: BorderRadius.all(Radius.circular(20)),
//                border: Border.all(color: Color(0xFFCCCCCC))
//              ),
                                child: ExpansionTile(
                                  trailing: Image.asset(
                                    'assets/icons/downArrow.png',
                                    scale: 4,
                                  ),
                                  title: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/icons/ad.png',
                                        scale: 4,
                                        color: Color(0xFFF99743),
                                      ),
                                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                      Text(
                                        city.isEmpty ? "${AppLocalizations.of(context).translate('cityText')}" : "$city",
                                        style: TextStyle(fontSize: 18),
                                      )
                                    ],
                                  ),
                                  children: citiesModelList.map((value) {
                                    return InkWell(
                                      onTap: () {
                                        cityId = value.id;
                                        city = value.name;
                                        setState(() {});
                                      },
                                      child: Text("${value.name}"),
                                    );
                                  }).toList(),
                                ),
                              ),
                              cityError
                                  ? Text('${AppLocalizations.of(context).translate('cityErrorMsg')}', style: TextStyle(color: Colors.red))
                                  : Container(),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: InkWell(
                                  onTap: () async {
                                    await getLocation();
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) {
//                                return PlacePicker(
//                                  apiKey: "AIzaSyCYPXlLrEHISDyVdJ1C9zSEBH1bQfiXJfo",
//                                  initialPosition: LatLng(position.latitude, position.longitude),
//                                  useCurrentLocation: true,
//                                  //usePlaceDetailSearch: true,
//                                  onPlacePicked: (result) {
//                                    selectedPlace = result;
//                                    Navigator.of(context).pop();
//                                    setState(() {});
//                                  },
//                                  //forceSearchOnZoomChanged: true,
//                                  //automaticallyImplyAppBarLeading: false,
//                                  //autocompleteLanguage: "ko",
//                                  //region: 'au',
//                                  //selectInitialPosition: true,
//                                  // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
//                                  //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
//                                  //   return isSearchBarFocused
//                                  //       ? Container()
//                                  //       : FloatingCard(
//                                  //           bottomPosition: 0.0,    // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
//                                  //           leftPosition: 0.0,
//                                  //           rightPosition: 0.0,
//                                  //           width: 500,
//                                  //           borderRadius: BorderRadius.circular(12.0),
//                                  //           child: state == SearchingState.Searching
//                                  //               ? Center(child: CircularProgressIndicator())
//                                  //               : RaisedButton(
//                                  //                   child: Text("Pick Here"),
//                                  //                   onPressed: () {
//                                  //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
//                                  //                     //            this will override default 'Select here' Button.
//                                  //                     print("do something with [selectedPlace] data");
//                                  //                     Navigator.of(context).pop();
//                                  //                   },
//                                  //                 ),
//                                  //         );
//                                  // },
//                                  // pinBuilder: (context, state) {
//                                  //   if (state == PinState.Idle) {
//                                  //     return Icon(Icons.favorite_border);
//                                  //   } else {
//                                  //     return Icon(Icons.favorite);
//                                  //   }
//                                  // },
//                                );
//                              },
//                            ),
//                          );
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      border: Border.all(color: Color(0xFFCCCCCC)),
                                      color: positionError ? Colors.transparent : Colors.blue,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Image.asset(
                                          'assets/icons/pin.png',
                                          scale: 4,
                                          color: Color(0xFFF99743),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                        ),
                                        Text(
                                          "${AppLocalizations.of(context).translate('currentLocation')}",
                                          style: TextStyle(color: Color(0xFFACB1C0)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              positionTextError
                                  ? Text('${AppLocalizations.of(context).translate('locationErrorMsg')}', style: TextStyle(color: Colors.red))
                                  : Container(),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFF4F5F8),
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Image.asset(
                                          'assets/icons/roomArea.png',
                                          scale: 4,
                                          color: Color(0xFFF99743),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 5),
                                        ),
                                        Text('${AppLocalizations.of(context).translate('area')}')
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.2,
                                          child: TextField(
                                            controller: areaController,
                                            focusNode: areaNode,
                                            keyboardType: TextInputType.number,
                                            enableInteractiveSelection: false,
                                            maxLength: 6,
                                            decoration: InputDecoration(hintText: "0", counterText: ""),
                                          ),
                                        ),
                                        Text("متر")
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              areaError
                                  ? Text('${AppLocalizations.of(context).translate('areaErrorMsg')}', style: TextStyle(color: Colors.red))
                                  : Container(),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Image.asset(
                                            'assets/icons/compass.png',
                                            scale: 4,
                                            color: Color(0xFFF99743),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 5),
                                          ),
                                          Text('${AppLocalizations.of(context).translate('front')}')
                                        ],
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        height: 30,
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
                                          border: Border.all(color: Color(0xFFCCCCCC)),
                                        ),
                                        alignment: Alignment.center,
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          value: frontDropdownValue,
                                          hint: Text('الوجه الغربية'),
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
                                              frontDropdownValue = newValue;
                                              print(frontDropdownValue);
                                            });
                                          },
                                          items: facadeModelList.map((value) {
                                            return DropdownMenuItem(
                                              value: value.name,
                                              child: Text(
                                                value.name,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              onTap: () => facadeId = value.id,
                                            );
                                          }).toList()

//                          frontList.map<DropdownMenuItem<String>>((String value) {
//                            return DropdownMenuItem<String>(
//                              value: value,
//                              child: Text(
//                                value,
//                                textAlign: TextAlign.center,
//                                style: TextStyle(fontSize: 15),
//                              ),
//                            );
//                          }).toList()
                                          ,
                                        ),
                                      ),
                                    ],
                                  )),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFF4F5F8),
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Row(
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
                                        Text('${AppLocalizations.of(context).translate('bedroomNumber')}')
                                      ],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.2,
                                      height: 30,
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                        items: numberOfBedsList.map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            onTap: () => numberOfBeds = int.parse(value),
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Row(
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
                                          Text('${AppLocalizations.of(context).translate('bathroomNumber')}')
                                        ],
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.2,
                                        height: 30,
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                          items: numberOfBathsList.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              onTap: () => numberOfBaths = int.parse(value),
                                            );
                                          }).toList(),
                                        ),
                                      )
                                    ],
                                  )),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFF4F5F8),
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Image.asset(
                                          'assets/icons/sofa.png',
                                          scale: 4,
                                          color: Color(0xFFF99743),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 5),
                                        ),
                                        Text('${AppLocalizations.of(context).translate('lounges')}')
                                      ],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.2,
                                      height: 30,
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                        border: Border.all(color: Color(0xFFCCCCCC)),
                                      ),
                                      alignment: Alignment.center,
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        value: loungesDropdownValue,
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
                                            loungesDropdownValue = newValue;
                                            print(loungesDropdownValue);
                                          });
                                        },
                                        items: loungesList.map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            onTap: () => loungesNumber = int.parse(value),
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Image.asset(
                                            'assets/icons/street.png',
                                            scale: 4,
                                            color: Color(0xFFF99743),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 5),
                                          ),
                                          Text('${AppLocalizations.of(context).translate('streetWidth')}')
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.2,
                                            child: TextField(
                                              controller: streetWideController,
                                              focusNode: streetWideNode,
                                              keyboardType: TextInputType.number,
                                              enableInteractiveSelection: false,
                                              maxLength: 6,
                                              decoration: InputDecoration(hintText: "0", counterText: ""),
                                            ),
                                          ),
                                          Text("م")
                                        ],
                                      ),
                                    ],
                                  )),
                              streetWideError
                                  ? Text('${AppLocalizations.of(context).translate('streetWideErrorMsg')}', style: TextStyle(color: Colors.red))
                                  : Container(),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFF4F5F8),
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Image.asset(
                                          'assets/icons/building.png',
                                          scale: 4,
                                          color: Color(0xFFF99743),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 5),
                                        ),
                                        Text('${AppLocalizations.of(context).translate('floorNumber')}')
                                      ],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      height: 40,
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                        border: Border.all(color: Color(0xFFCCCCCC)),
                                      ),
                                      alignment: Alignment.center,
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        value: floorDropdownValue,
                                        hint: Text('دور اول'),
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
                                            floorDropdownValue = newValue;
                                            print(floorDropdownValue);
                                          });
                                        },
                                        items: floorList.map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            onTap: () => floorNumber = int.parse(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.monetization_on,
                                            color: Colors.orange,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 5),
                                          ),
                                          Text('${AppLocalizations.of(context).translate('price')}')
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            child: TextField(
                                              controller: priceController,
                                              focusNode: priceNode,
                                              enableInteractiveSelection: false,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(hintText: "0", counterText: ""),
                                            ),
                                          ),
                                          Text("درهم")
                                        ],
                                      ),
                                    ],
                                  )),
                              priceError
                                  ? Text('${AppLocalizations.of(context).translate('priceErrorMsg')}', style: TextStyle(color: Colors.red))
                                  : Container(),
                              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: TextField(
                                  controller: contentController,
                                  focusNode: contentNode,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                      filled: true,
                                      focusColor: Color(0xFFF3F3F3),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 25,
                                        vertical: 15,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: Color(0xFFB9B9B9))),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: Color(0xFFB9B9B9))),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: Colors.blue)),
                                      hintText: "${AppLocalizations.of(context).translate('realEstateDescription')}"),
                                ),
                              ),
                              contentError
                                  ? Text('${AppLocalizations.of(context).translate('contentErrorMsg')}', style: TextStyle(color: Colors.red))
                                  : Container(),
                              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                              SizedBox(
                                height: 150,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () => getVideo(),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              width: 100,
                                              height: 100,
                                              margin: EdgeInsets.symmetric(horizontal: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                                  border: Border.all(color: Color(0xFFB9B9B9)),
                                                  color: Color(0xFFF3F3F3)),
                                              alignment: Alignment.center,
                                              child: _videoPlayerController == null
                                                  ? Image.asset(
                                                      'assets/icons/video.png',
                                                      scale: 3,
                                                    )
                                                  : _videoPlayerController.value.initialized
                                                      ? AspectRatio(
                                                          aspectRatio: _videoPlayerController.value.aspectRatio,
                                                          child: Stack(
                                                            alignment: Alignment.bottomCenter,
                                                            children: <Widget>[
                                                              VideoPlayer(_videoPlayerController),
                                                              Stack(
                                                                children: <Widget>[
                                                                  AnimatedSwitcher(
                                                                    duration: Duration(milliseconds: 50),
                                                                    reverseDuration: Duration(milliseconds: 200),
                                                                    child: _videoPlayerController.value.isPlaying
                                                                        ? SizedBox.shrink()
                                                                        : Container(
                                                                            color: Colors.black26,
                                                                            child: Center(
                                                                              child: Icon(
                                                                                Icons.play_arrow,
                                                                                color: Colors.white,
                                                                                size: 100.0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      _videoPlayerController.value.isPlaying
                                                                          ? _videoPlayerController.pause()
                                                                          : _videoPlayerController.play();
                                                                      setState(() {});
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Image.asset(
                                                          'assets/icons/video.png',
                                                          scale: 3,
                                                        ),
                                            ),
                                            _videoPlayerController == null
                                                ? Container()
                                                : InkWell(
                                                    onTap: () => getVideo(),
                                                    child: Container(
                                                      width: 100,
                                                      padding: EdgeInsets.symmetric(vertical: 5),
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius: BorderRadius.only(
                                                            bottomLeft: Radius.circular(10),
                                                            bottomRight: Radius.circular(10),
                                                          )),
                                                      child: Text(
                                                        "تغير الفيديو",
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(maxHeight: 150, minHeight: 100.0),
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: _networkImages.length,
                                          padding: EdgeInsets.symmetric(horizontal: 5),
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: <Widget>[
                                                InkWell(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        width: 100,
                                                        height: 100,
                                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(20),
                                                            topRight: Radius.circular(20),
                                                          ),
                                                          border: Border.all(color: Color(0xFFB9B9B9)),
                                                          color: Color(0xFFF3F3F3),
                                                          image: DecorationImage(
                                                            image: NetworkImage(
                                                              '${_networkImages[index].photo}',
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    Response response;
                                                    try {
                                                      response = await Dio().delete("http://api.naffeth.com/deletePhoto",
                                                          data: {"image": "${_networkImages[index].id}"},
                                                          options: Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"}));
                                                      print(response.data);
                                                    } on DioError catch (e) {
                                                      print('error in delete photo => ${e.response.data}');
                                                    }
                                                    _networkImages.removeAt(index);
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    padding: EdgeInsets.symmetric(vertical: 5),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius: BorderRadius.only(
                                                          bottomLeft: Radius.circular(10),
                                                          bottomRight: Radius.circular(10),
                                                        )),
                                                    child: Text(
                                                      "مسح الصوره",
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(maxHeight: 150, minHeight: 100.0),
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: 11 - _networkImages.length,
                                          padding: EdgeInsets.symmetric(horizontal: 5),
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () => getPhoto(index),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(),
                                                      Container(
                                                        width: 100,
                                                        height: 100,
                                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                                        decoration: BoxDecoration(
                                                          borderRadius: _assetImages.asMap()[index] != null
                                                              ? BorderRadius.only(
                                                                  topLeft: Radius.circular(20),
                                                                  topRight: Radius.circular(20),
                                                                )
                                                              : BorderRadius.all(Radius.circular(20)),
                                                          border: Border.all(color: Color(0xFFB9B9B9)),
                                                          color: Color(0xFFF3F3F3),
                                                          image: DecorationImage(
                                                            image: _assetImages.asMap()[index] == null
                                                                ? AssetImage(
                                                                    'assets/icons/image.png',
                                                                  )
                                                                : FileImage(_assetImages[index]),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                _assetImages.asMap()[index] == null
                                                    ? Container()
                                                    : InkWell(
                                                        onTap: () {
                                                          _assetImages.removeAt(index);
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          width: 100,
                                                          padding: EdgeInsets.symmetric(vertical: 5),
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                              color: Colors.red,
                                                              borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius.circular(10),
                                                                bottomRight: Radius.circular(10),
                                                              )),
                                                          child: Text(
                                                            "مسح الصوره",
                                                            style: TextStyle(color: Colors.white),
                                                          ),
                                                        ),
                                                      )
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                              isUploadLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : InkWell(
                                      onTap: () => validate(context),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.8,
                                        padding: EdgeInsets.symmetric(vertical: 15),
                                        decoration: BoxDecoration(color: Color(0xFF0D986A), borderRadius: BorderRadius.all(Radius.circular(20))),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${AppLocalizations.of(context).translate('save')}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                              Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                            ],
                          ),
                        ),
                      );
                    },
                  ));
  }
}
