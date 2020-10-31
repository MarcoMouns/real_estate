import 'package:flutter/material.dart';

class HomeCard extends StatefulWidget {
  int id;
  String title;
  double price;
  int size;
  String time;
  int numberOfRooms;
  int numberOfBathRooms;
  String address;
  String photo;
  int categoryColor;

  HomeCard(
      {this.id,
      this.title,
      this.price,
      this.size,
      this.time,
      this.numberOfRooms,
      this.numberOfBathRooms,
      this.address,
      this.photo,
      this.categoryColor});

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
        height: MediaQuery.of(context).size.height * 0.21,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12))),
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
                      image: NetworkImage("${widget.photo}"),
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
                      Text("${widget.title}",softWrap: true,),
                      Row(
                        children: <Widget>[
                          Text("${widget.time}",softWrap: true,),
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
                  Text("${widget.price} درهم "),
                  Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                  Row(
                    children: <Widget>[
                      Text("${widget.numberOfRooms}"),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                      Image.asset(
                        'assets/icons/bed.png',
                        scale: 3.3,
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 7)),
                      Text("${widget.numberOfBathRooms}"),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Image.asset(
                        'assets/icons/bath.png',
                        scale: 3.3,
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 7)),
                      Text("${widget.size}"),
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
                        color: Color(widget.categoryColor),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.5,
                        child: Text('${widget.address}',
                          overflow: TextOverflow.ellipsis,),
                      )
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
