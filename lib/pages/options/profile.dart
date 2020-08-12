import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realestate/I10n/AppLanguage.dart';
import 'package:realestate/I10n/app_localizations.dart';
import 'package:realestate/models/produc_mini_model.dart';
import 'package:realestate/pages/auth/login.dart';
import 'package:realestate/pages/product/add_product.dart';
import 'package:realestate/pages/product/edit_product.dart';
import 'package:realestate/pages/product/product_details.dart';
import 'package:realestate/services/getUserProduct.dart';
import 'package:realestate/widgets/home_card.dart';
import 'package:realestate/widgets/logout_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home.dart';
import 'callUs.dart';
import 'change_profile.dart';
import 'favorites.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  Widget popUp() {
    var appLanguage = Provider.of<AppLanguage>(context);
    return CupertinoActionSheet(
      title: new Text('اللغه'),
      message: new Text('اختر اللغه'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: new Text('English'),
          onPressed: () {
            appLanguage.changeLanguage(Locale("en"));
            Navigator.of(context).pop();
          },
        ),
        CupertinoActionSheetAction(
          child: new Text('Arabic'),
          onPressed: () {
            appLanguage.changeLanguage(Locale("ar"));
            Navigator.of(context).pop();
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: new Text('رجوع'),
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context, 'Cancel');
        },
      ),
    );
  }

  String fullName;
  String token = "";
  String photo;
  bool isLoading = true;

  List<ProductMiniModel> productMiniModelList = List<ProductMiniModel>();

  getUserProducts() async {
    productMiniModelList = await GetUserProduct().getProduct();
    isLoading = false;
    setState(() {});
  }

  getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    if (token.isNotEmpty) {
      fullName = prefs.getString('name');
      photo = prefs.getString('photo');

      print(fullName);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
    getUserProducts();
  }

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
                    photo == null
                        ? Image.asset(
                            'assets/images/person.png',
                            scale: 5,
                          )
                        : CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(photo),
                          ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    Text('$fullName'),
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
              title:
                  Text("${AppLocalizations.of(context).translate('aboutApp')}"),
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
          InkWell(
            onTap: () =>
            token.isEmpty ?
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login(),))
                :
            showDialog(
                context: context,
                builder: (BuildContext context) => LogoutDialog()),
            child: Image.asset(
              'assets/icons/back.png',
              scale: 3.7,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              photo == null ?
              Image.asset(
                'assets/images/person.png',
                scale: 4,
              ) :
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(photo),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Text('${fullName ?? "مستخدم جديد"}'),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    onTap: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChangeProfile(),
                        )),
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/icons/edit.png',
                          scale: 3.5,
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                        Text(
                            "${AppLocalizations.of(context).translate(
                                'editProfile')}"),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) => popUp()),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.language,
                          color: Color(0xFF363636),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                        Text(
                            "${AppLocalizations.of(context).translate(
                                'changeLang')}"),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Text("${AppLocalizations.of(context).translate('realEstate')}"),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              productMiniModelList.isEmpty
                  ? Text("${AppLocalizations.of(context).translate('noAds')}")
                  : ListView.builder(
                primary: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: productMiniModelList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              EditProductScreen(productMiniModelList[index].id),
                        ));
                      },
                      child: HomeCard(
                        id: productMiniModelList[index].id,
                        title: productMiniModelList[index].title,
                        price: productMiniModelList[index].price,
                        size: productMiniModelList[index].size,
                        time: productMiniModelList[index].time,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
