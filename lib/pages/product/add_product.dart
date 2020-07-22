import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realestate/I10n/app_localizations.dart';
import 'package:realestate/models/categories.dart';
import 'package:realestate/models/facade.dart';
import 'package:realestate/pages/home.dart';
import 'package:realestate/services/add_product.dart';
import 'package:realestate/services/get_categories.dart';
import 'package:realestate/services/get_facades.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  int categoryId;
  int facadeId;
  int numberOfBeds;
  int numberOfBaths;
  int loungesNumber;
  int floorNumber;

  String bedDropdownValue;
  String frontDropdownValue;
  String bathDropdownValue;
  String loungesDropdownValue;
  String floorDropdownValue;
  String token;
  String adType = "";

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

  List<String> numberOfBedsList = List<String>();
  List<String> numberOfBathsList = List<String>();
  List<String> loungesList = List<String>();
  List<String> floorList = List<String>();
  List<CategoriesModel> categoriesModel = List<CategoriesModel>();
  List<FacadeModel> facadeModelList = List<FacadeModel>();

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
  List<File> _images = List<File>();
  File video;
  final picker = ImagePicker();

  VideoPlayerController _videoPlayerController;

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

  getLocation() async {
    try {
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
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
      if (_images.isNotEmpty) {
        if (_images.asMap()[index] == null) {
          print('in add');
          _images.add(File(pickedFile.path));
        } else {
          print('in insert');
          _images[index] = File(pickedFile.path);
        }
      } else
        _images.add(File(pickedFile.path));
      print(index);
      setState(() {});
    }
  }

  validate(BuildContext context) async {
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
      String response = await AddProduct().addProduct(
        token: token,
        title: titleController.text,
        address: addressController.text,
        categoryId: categoryId,
        lat: position.latitude,
        long: position.longitude,
        area: areaController.text,
        numberOfBeds: numberOfBeds == null ? 0 : numberOfBeds,
        numberOfBaths: numberOfBaths == null ? 0 : numberOfBaths,
        lounges: loungesNumber == null ? 0 : loungesNumber,
        floorNumber: floorNumber == null ? 0 : floorNumber,
        streetWide: streetWideController.text,
        facade: facadeId,
        description: contentController.text,
        price: priceController.text,
        images: _images,
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
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkToken();
    getData();
    for (int i = 1; i <= 20; i++) {
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
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(27),
                  bottomLeft: Radius.circular(20)),
              child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(27),
                        bottomLeft: Radius.circular(20)),
                    color: Colors.white,
                  ),
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    title: Text(
                        '${AppLocalizations.of(context).translate(
                            'addNewAd')}'),
                    centerTitle: true,
                  )),
            ),
          ),
        ),
        body: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            :
        token.isEmpty ? Center(child: Text("please log in"),) :
        Builder(
          builder: (context) {
            return SingleChildScrollView(
              child: GestureDetector(
                onTap: () => unFocus(),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery
                                .of(context)
                                .padding
                                .top)),
                    SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.9,
                      child: TextField(
                        controller: titleController,
                        focusNode: titleNode,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 0,
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                BorderSide(color: Color(0xFFB9B9B9))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                BorderSide(color: Color(0xFFB9B9B9))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.blue)),
                            hintText:
                            "${AppLocalizations.of(context).translate(
                                'title')}"),
                      ),
                    ),
                    titleError
                        ? Text(
                      '${AppLocalizations.of(context).translate(
                          'titleErrorMsg')}',
                      style: TextStyle(color: Colors.red),
                    )
                        : Container(),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.9,
                      child: TextField(
                        controller: addressController,
                        focusNode: addressNode,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 0,
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                BorderSide(color: Color(0xFFB9B9B9))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                BorderSide(color: Color(0xFFB9B9B9))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.blue)),
                            hintText:
                            "${AppLocalizations.of(context).translate(
                                'address')}"),
                      ),
                    ),
                    addressError
                        ? Text(
                        '${AppLocalizations.of(context).translate(
                            'addressErrorMsg')}',
                        style: TextStyle(color: Colors.red))
                        : Container(),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.9,
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
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5)),
                            Text(
                              adType.isEmpty ?
                              "${AppLocalizations.of(context).translate(
                                  'adType')}" : "$adType",
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
                        ? Text(
                        '${AppLocalizations.of(context).translate(
                            'categoryErrorMsg')}',
                        style: TextStyle(color: Colors.red))
                        : Container(),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: InkWell(
                        onTap: () => getLocation(),
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.9,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: Color(0xFFCCCCCC)),
                            color: positionError
                                ? Colors.transparent
                                : Colors.blue,
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
                                "${AppLocalizations.of(context).translate(
                                    'currentLocation')}",
                                style: TextStyle(color: Color(0xFFACB1C0)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    positionTextError
                        ? Text(
                        '${AppLocalizations.of(context).translate(
                            'locationErrorMsg')}',
                        style: TextStyle(color: Colors.red))
                        : Container(),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF4F5F8),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                              Text(
                                  '${AppLocalizations.of(context).translate(
                                      'area')}')
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.2,
                                child: TextField(
                                  controller: areaController,
                                            focusNode: areaNode,
                                            keyboardType: TextInputType.number,
                                            enableInteractiveSelection: false,
                                            maxLength: 6,
                                            decoration: InputDecoration(
                                                hintText: "0", counterText: ""),
                                          ),
                              ),
                              Text("متر")
                            ],
                          ),
                        ],
                      ),
                    ),
                    areaError
                        ? Text(
                        '${AppLocalizations.of(context).translate(
                            'areaErrorMsg')}',
                        style: TextStyle(color: Colors.red))
                        : Container(),
                    Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                Text(
                                    '${AppLocalizations.of(context).translate(
                                        'front')}')
                              ],
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.4,
                              height: 30,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(12)),
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
                      padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                              Text(
                                  '${AppLocalizations.of(context).translate(
                                      'bedroomNumber')}')
                            ],
                          ),
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.2,
                            height: 30,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(12)),
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
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      onTap: () =>
                                      numberOfBeds = int.parse(value),
                                    );
                                  }).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                Text(
                                    '${AppLocalizations.of(context).translate(
                                        'bathroomNumber')}')
                              ],
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.2,
                              height: 30,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(12)),
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
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        onTap: () =>
                                        numberOfBaths = int.parse(value),
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
                      padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                              Text(
                                  '${AppLocalizations.of(context).translate(
                                      'lounges')}')
                            ],
                          ),
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.2,
                            height: 30,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(12)),
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
                              items: loungesList.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      onTap: () =>
                                      loungesNumber = int.parse(value),
                                    );
                                  }).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                Text(
                                    '${AppLocalizations.of(context).translate(
                                        'streetWidth')}')
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.2,
                                  child: TextField(
                                    controller: streetWideController,
                                    focusNode: streetWideNode,
                                    keyboardType: TextInputType.number,
                                    enableInteractiveSelection: false,
                                    maxLength: 6,
                                    decoration: InputDecoration(
                                        hintText: "0", counterText: ""),
                                  ),
                                ),
                                Text("م")
                              ],
                            ),
                          ],
                        )),
                    streetWideError
                        ? Text(
                        '${AppLocalizations.of(context).translate(
                            'streetWideErrorMsg')}',
                        style: TextStyle(color: Colors.red))
                        : Container(),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF4F5F8),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                              Text(
                                  '${AppLocalizations.of(context).translate(
                                      'floorNumber')}')
                            ],
                          ),
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.3,
                            height: 40,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(12)),
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
                              items: floorList.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      onTap: () =>
                                      floorNumber = int.parse(value),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                Text(
                                    '${AppLocalizations.of(context).translate(
                                        'price')}')
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.3,
                                  child: TextField(
                                    controller: priceController,
                                    focusNode: priceNode,
                                    enableInteractiveSelection: false,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        hintText: "0", counterText: ""),
                                  ),
                                ),
                                Text("درهم")
                              ],
                            ),
                          ],
                        )),
                    priceError
                        ? Text(
                        '${AppLocalizations.of(context).translate(
                            'priceErrorMsg')}',
                        style: TextStyle(color: Colors.red))
                        : Container(),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.9,
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
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                BorderSide(color: Color(0xFFB9B9B9))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                BorderSide(color: Color(0xFFB9B9B9))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.blue)),
                            hintText:
                            "${AppLocalizations.of(context).translate(
                                'realEstateDescription')}"),
                      ),
                    ),
                    contentError
                        ? Text(
                        '${AppLocalizations.of(context).translate(
                            'contentErrorMsg')}',
                        style: TextStyle(color: Colors.red))
                        : Container(),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    ConstrainedBox(
                      constraints:
                      BoxConstraints(maxHeight: 150, minHeight: 100.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: 11,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        itemBuilder: (context, index) {
                          if (index == 0)
                            return InkWell(
                              onTap: () => getVideo(),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    height: 100,
                                    margin:
                                    EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        border: Border.all(
                                            color: Color(0xFFB9B9B9)),
                                        color: Color(0xFFF3F3F3)),
                                    alignment: Alignment.center,
                                    child: _videoPlayerController == null
                                        ? Image.asset(
                                      'assets/icons/video.png',
                                      scale: 3,
                                    )
                                        : _videoPlayerController
                                        .value.initialized
                                        ? AspectRatio(
                                      aspectRatio:
                                      _videoPlayerController
                                          .value.aspectRatio,
                                      child: Stack(
                                        alignment:
                                        Alignment.bottomCenter,
                                        children: <Widget>[
                                          VideoPlayer(
                                              _videoPlayerController),
                                          _PlayPauseOverlay(
                                              controller:
                                              _videoPlayerController),
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
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft:
                                            Radius.circular(10),
                                            bottomRight:
                                            Radius.circular(10),
                                          )),
                                      child: Text(
                                        "تغير الفيديو",
                                        style: TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          else
                            return InkWell(
                              onTap: () => getPhoto(index - 1),
                              child: Column(
                                children: <Widget>[
                                  Container(),
                                  Container(
                                    width: 100,
                                    height: 100,
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        border: Border.all(
                                            color: Color(0xFFB9B9B9)),
                                        color: Color(0xFFF3F3F3)),
                                    alignment: Alignment.center,
                                    child: _images.asMap()[index - 1] == null
                                        ? Image.asset(
                                      'assets/icons/image.png',
                                      scale: 3,
                                    )
                                        : Image.file(_images[index - 1]),
                                  )
                                ],
                              ),
                            );
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    isUploadLoading ?
                    Center(child: CircularProgressIndicator(),) :
                    InkWell(
                      onTap: () => validate(context),
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.8,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                            color: Color(0xFF0D986A),
                            borderRadius:
                            BorderRadius.all(Radius.circular(20))),
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
        )
    );
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
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
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
