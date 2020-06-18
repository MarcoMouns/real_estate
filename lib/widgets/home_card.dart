import 'package:flutter/material.dart';

class HomeCard extends StatefulWidget {
  @override
  _HomeCardState createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1.5,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.19,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(12))),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.225,
              height: MediaQuery.of(context).size.height * 0.145,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  image: DecorationImage(
                      image: NetworkImage("https://r-cf.bstatic.com/images/hotel/max1024x768/233/233853949.jpg"),
                      fit: BoxFit.cover)),
              margin: EdgeInsets.only(left: 10),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("فيلا للبيع"),
                      Row(
                        children: <Widget>[
                          Text(("9 دقيقة")),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Color(0xFFFFB151),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 1)),
                  Text("150 ريال-  سنوي"),
                  Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                  Row(
                    children: <Widget>[
                      Text("3"),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Image.asset(
                        'assets/icons/bed.png',
                        scale: 3.3,
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 7)),
                      Text("2"),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Image.asset(
                        'assets/icons/bath.png',
                        scale: 3.3,
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 7)),
                      Text("1500"),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Image.asset(
                        'assets/icons/roomArea.png',
                        scale: 3.3,
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                  Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/icons/pin.png',
                        scale: 4.5,
                        color: Color(0xFFFD797F),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Text('فيلا للبيع')
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
