import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:realestate/I10n/app_localizations.dart';
import 'package:realestate/models/categories.dart';
import 'package:realestate/services/get_categories.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String bedDropdownValue;
  String frontDropdownValue;
  String bathDropdownValue;
  String loungesDropdownValue;
  String floorDropdownValue;
  bool isLoading = true;

  List<String> numberOfBedsList = List<String>();
  List<String> frontList = List<String>();
  List<String> numberOfBathsList = List<String>();
  List<String> loungesList = List<String>();
  List<String> floorList = List<String>();
  List<CategoriesModel> categoriesModel = List<CategoriesModel>();
  List<Text> categories = List<Text>();

  TextEditingController contentController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController streetWideController = TextEditingController();

  FocusNode contentNode = FocusNode();
  FocusNode areaNode = FocusNode();
  FocusNode streetWideNode = FocusNode();

  bool positionError = true;
  bool positionErrorText = false;

  unFocus() {
    contentNode.unfocus();
    areaNode.unfocus();
    streetWideNode.unfocus();
  }

  getCategories() async {
    categoriesModel = await GetCategories().getCategories();
    categoriesModel.forEach((element) {
      categories.add(Text("${element.name}"));
    });
  }

  getLocation() async {
    Position position;
    try {
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      positionError = false;
    } catch (e) {
      print('position error');
      positionError = true;
      if (mounted) setState(() {});
    }
  }

  getData() async {
    await getCategories();
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    for (int i = 1; i <= 20; i++) {
      numberOfBedsList.add('$i');
      frontList.add('$i');
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
                  title: Text(
                      '${AppLocalizations.of(context).translate('addNewAd')}'),
                  centerTitle: true,
                )),
          ),
        ),
      ),
      body: isLoading ? Center(child: CircularProgressIndicator(),) :
      SingleChildScrollView(
        child: GestureDetector(
          onTap: () => unFocus(),
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .padding
                  .top)),
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
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Text(
                        "${AppLocalizations.of(context).translate('adType')}",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                  children: categories,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: InkWell(
                  onTap: () => getLocation(),
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,
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
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.2,
                          child: TextField(
                            controller: areaController,
                            focusNode: areaNode,
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
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.4,
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
                          items: frontList.map<DropdownMenuItem<String>>((String value) {
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.2,
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
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.2,
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.2,
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
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.2,
                            child: TextField(
                              controller: streetWideController,
                              focusNode: streetWideNode,
                              decoration: InputDecoration(hintText: "0"),
                            ),
                          ),
                          Text("م")
                        ],
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.3,
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
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
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
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Color(0xFFB9B9B9))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Color(0xFFB9B9B9))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.blue)),
                      hintText: "${AppLocalizations.of(context).translate('realEstateDescription')}"),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return InkWell(
                        onTap: null,
                        child: Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: Color(0xFFB9B9B9)),
                              color: Color(0xFFF3F3F3)
                          ),
                          alignment: Alignment.center,
                          child: Image.asset('assets/icons/video.png', scale: 3,),
                        ),
                      );
                    else
                      return InkWell(
                        onTap: null,
                        child: Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: Color(0xFFB9B9B9)),
                              color: Color(0xFFF3F3F3)
                          ),
                          alignment: Alignment.center,
                          child: Image.asset('assets/icons/image.png', scale: 3,),
                        ),
                      );
                  },
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              InkWell(
                onTap: null,
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.8,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: Color(0xFF0D986A),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  alignment: Alignment.center,
                  child: Text("${AppLocalizations.of(context).translate('save')}", style: TextStyle(color: Colors.white),),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
