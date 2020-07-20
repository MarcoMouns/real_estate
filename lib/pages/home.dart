import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:realestate/I10n/app_localizations.dart';
import 'package:realestate/pages/product/add_product.dart';
import 'package:realestate/pages/product/product_details.dart';
import 'package:realestate/widgets/home_card.dart';

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
  bool _isVisible = true;
  bool _lights = false;
  String bedDropdownValue;
  String bathDropdownValue;
  ScrollController _hideButtonController;
  StreamController<double> controller = StreamController<double>.broadcast();
  List<String> numberOfBedsList = List<String>();
  List<String> numberOfBathsList = List<String>();
  var selectedRange = RangeValues(0, 1000000);

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  Completer<GoogleMapController> _controller = Completer();

  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();

  unFocus() {
    searchNode.unfocus();
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

  @override
  void initState() {
    super.initState();
    for (int i = 1; i <= 20; i++) {
      numberOfBedsList.add('$i');
      numberOfBathsList.add('$i');
    }
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() async {
      if (_hideButtonController.position.userScrollDirection == ScrollDirection.reverse) {
        _isVisible = false;
      }
      if (_hideButtonController.position.userScrollDirection == ScrollDirection.forward) {
        _isVisible = true;
      }

      //TODO:: implement pagination
//      if (_hideButtonController.position.pixels ==
//          _hideButtonController.position.maxScrollExtent) {
//        setState(() {
//          isLoadingNewData = true;
//        });
//        getMoreData();
//      }
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
    return Column(
      children: <Widget>[
        //Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
        Expanded(
          flex: 1,
          child: Material(
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
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 0.0,
                            vertical: 0.0,
                          ),
                          prefixIcon: Image.asset(
                            'assets/icons/search.png',
                            scale: 3.5,
                          ),
                          filled: true,
                          fillColor: Color(0xFFF2F3F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xFFF2F3F5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xFFF2F3F5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                          hintText: "${AppLocalizations.of(context).translate('search')}"),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  SizedBox(
                    height: 30,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 20,
                                height: 5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Colors.grey,
                                ),
                              ),
                              Text('كل المتاح')
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: ListView.builder(
            controller: _hideButtonController,
            itemCount: 5,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProductDetails(),
                    ));
                  },
                  child: HomeCard(),
                ),
              );
            },
          ),
        )
      ],
    );
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.65,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: InkWell(
                                onTap: null,
                                child: Container(
                                  width: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      border: Border.all(color: Color(0xFFCCCCCC), width: 2)
                                  ),
                                  alignment: Alignment.center,
                                  child: Text("كل المتاح", style: TextStyle(fontSize: 14),),
                                ),
                              )
                          );
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5),),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.65,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: Color(0xFFCCCCCC), width: 2)
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.symmetric(horizontal: 5),),
                          Image.asset('assets/icons/pin.png', scale: 4, color: Color(0xFFF99743),),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 5),),
                          Text(
                            "${AppLocalizations.of(context).translate('currentLocation')}", style: TextStyle(fontSize: 18),)
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset('assets/icons/bed.png', scale: 4, color: Color(0xFFF99743),),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 5),),
                            Text("${AppLocalizations.of(context).translate('bedroomNumber')}"),
                          ],
                        ),
                        Container(
                          width: 60,
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
                            icon: Image.asset('assets/icons/downArrow.png', scale: 5,),
                            iconSize: 24,
                            underline: SizedBox(),
                            style: TextStyle(color: Colors.deepPurple,),
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
                                  value, textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15),),
                              );
                            }).toList(),
                          ),
                        ),

                      ],
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset('assets/icons/bath.png', scale: 4, color: Color(0xFFF99743),),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 5),),
                            Text("${AppLocalizations.of(context).translate('bathroomNumber')}"),
                          ],
                        ),
                        Container(
                          width: 60,
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
                            icon: Image.asset('assets/icons/downArrow.png', scale: 5,),
                            iconSize: 24,
                            underline: SizedBox(),
                            style: TextStyle(color: Colors.deepPurple,),
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
                                  value, textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15),),
                              );
                            }).toList(),
                          ),
                        ),

                      ],
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5),),
                    Row(
                      children: <Widget>[
                        Icon(Icons.monetization_on, color: Colors.orange, size: 20,),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 5),),
                        Text("${AppLocalizations.of(context).translate('price')}")
                      ],
                    ),
                    RangeSlider(
                      values: selectedRange,
                      divisions: 1000,
                      min: 0,
                      max: 1000000,
                      labels: RangeLabels('${selectedRange.start}', '${selectedRange.end}'),
                      onChanged: (RangeValues newRange) {
                        setState(() {
                          selectedRange = newRange;
                        });
                      },
                    ),
                    Row(
                      children: <Widget>[
                        CupertinoSwitch(
                          value: _lights,
                          onChanged: (bool value) {
                            setState(() {
                              _lights = value;
                            });
                          },
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                        Text("${AppLocalizations.of(context).translate('adDurationSwitch')}", style: TextStyle(
                            fontSize: 18),)
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
        width: MediaQuery
            .of(context)
            .size
            .width * 0.8,
        height: MediaQuery
            .of(context)
            .size
            .height,
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
                    Text('محمد احمد'),
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
              title: Text("${AppLocalizations.of(context).translate('mamlakaArea')}"),
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
              title: Text("${AppLocalizations.of(context).translate('aboutApp')}"),
              leading: Image.asset(
                'assets/icons/aboutApp.png',
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
              title: Text("${AppLocalizations.of(context).translate('callUs')}"),
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
              title: Text("${AppLocalizations.of(context).translate('favorites')}"),
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
              title: Text("${AppLocalizations.of(context).translate('setting')}"),
              leading: Image.asset(
                'assets/icons/star.png',
                scale: 3.5,
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Profile(),)
                );
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
            onPressed: () => _showMyDialog(),
            icon: Icon(
              Icons.filter_list,
              color: Colors.orange,
              size: 30,
            ),
          ),
          InkWell(
            onTap: () =>
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Notifications(),)
                ),
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
              children: <Widget>[
                homePage(),
                Center(
                  child: Icon(
                    Icons.map,
                    size: 50,
                  ),
                )
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
                      padding: EdgeInsets.symmetric(horizontal: 10),
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
                                    : _isVisible == true && currentPage != 0 ? Color(0xFF6C6C6C) : Color(0xFF6C6C6C),
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
                                borderRadius: BorderRadius.all(Radius.circular(27)),
                                color: _isVisible == true && currentPage == 1
                                    ? Color(0xFFF99743)
                                    : _isVisible == true && currentPage != 1 ? Colors.transparent : Colors.transparent,
                              ),
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/icons/pin.png',
                                scale: 3,
                                color: _isVisible == true && currentPage == 1
                                    ? Colors.white
                                    : _isVisible == true && currentPage != 1 ? Color(0xFF6C6C6C) : Color(0xFF6C6C6C),
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
