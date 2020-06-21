import 'package:flutter/material.dart';
import 'package:realestate/I10n/app_localizations.dart';

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

  List<String> numberOfBedsList = List<String>();
  List<String> frontList = List<String>();
  List<String> numberOfBathsList = List<String>();
  List<String> loungesList = List<String>();
  List<String> floorList = List<String>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                  title: Text('${AppLocalizations.of(context).translate('addNewAd')}'),
                  centerTitle: true,
                )),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
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
                      "${AppLocalizations.of(context).translate('adType')}",
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
                children: <Widget>[
                  Text("villa"),
                  Text("apartment"),
                  Text("lack"),
                  Text("building"),
                  Text("land"),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: InkWell(
                onTap: null,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: Color(0xFFCCCCCC))),
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
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: TextField(
                          decoration: InputDecoration(hintText: "0"),
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
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
