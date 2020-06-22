import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatefulWidget {
  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: <Widget>[
              Opacity(
                opacity: 1,
                child: Image.asset(
                  'assets/icons/notification.png',
                  scale: 3,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "عقارات جديدة",
                            style: TextStyle(color: Color(0xFF363636)),
                          ),
                          Row(
                            children: <Widget>[
                              Text("01:44AM"),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFB151)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                      Text(
                        "العقار متاح ولدينا معروض اخر في منظقة نجران",
                        style: TextStyle(color: Color(0xFF707070)),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
