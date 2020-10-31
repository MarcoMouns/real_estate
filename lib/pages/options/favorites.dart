import 'package:flutter/material.dart';
import 'package:realestate/I10n/app_localizations.dart';
import 'package:realestate/models/produc_mini_model.dart';
import 'package:realestate/pages/options/profile.dart';
import 'package:realestate/pages/product/add_product.dart';
import 'package:realestate/pages/product/product_details.dart';
import 'package:realestate/services/userFavorite.dart';
import 'package:realestate/widgets/home_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home.dart';
import 'callUs.dart';
import 'notifications.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  bool isLoading = true;

  List<ProductMiniModel> productMiniModelList = List<ProductMiniModel>();

  getUserFavorite() async {
    productMiniModelList = await UserFavorite().getUserFavorite();
    isLoading = false;
    setState(() {});
  }

  String fullName;
  String token = "";

  getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    if (token.isNotEmpty) {
      fullName = prefs.getString('name');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getName();
    getUserFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
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
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10)),
                          Image.asset(
                            'assets/images/person.png',
                            scale: 5,
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10)),
                          Text('$fullName'),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                        "${AppLocalizations.of(context).translate('home')}"),
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
                    title: Text(
                        "${AppLocalizations.of(context).translate('newAd')}"),
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
                    title: Text(
                        "${AppLocalizations.of(context).translate('chat')}"),
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
                    title: Text(
                        "${AppLocalizations.of(context).translate('aboutApp')}"),
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
                    title: Text(
                        "${AppLocalizations.of(context).translate('callUs')}"),
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
                    title: Text(
                        "${AppLocalizations.of(context).translate('setting')}"),
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
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    Image.asset(
                      'assets/icons/roundStar.png',
                      scale: 1,
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Text(
                        "${AppLocalizations.of(context).translate('favorites')}"),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    productMiniModelList.isEmpty
                        ? Text(
                            "${AppLocalizations.of(context).translate('noFavorite')}")
                        : ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: productMiniModelList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => ProductDetails(
                                          productMiniModelList[index].id),
                                    ));
                                  },
                                  child: HomeCard(
                                    id: productMiniModelList[index].id,
                                    title: productMiniModelList[index].title,
                                    price: productMiniModelList[index].price,
                                    size: productMiniModelList[index].size,
                                    time: productMiniModelList[index].time,
                                    numberOfRooms: productMiniModelList[index]
                                        .numberOfRooms,
                                    numberOfBathRooms:
                                        productMiniModelList[index]
                                            .numberOfBathRooms,
                                    address:
                                        productMiniModelList[index].address,
                                    photo: productMiniModelList[index].photo,
                                    categoryColor: productMiniModelList[index]
                                        .categoryColor,
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          );
  }
}
