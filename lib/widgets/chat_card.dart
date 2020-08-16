import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  final String name;
  final String image;
  final String date;
  final String time;

  ChatCard({@required this.name, @required this.image, @required this.date, @required this.time});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          '$image',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 18.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '$name',
                        style: TextStyle(fontSize: 20),
                      ),
//                      Row(
//                        children: <Widget>[
//                          Text(
//                            '$date',
//                            style: TextStyle(
//
//
//                              fontSize: 16,
//                              color: Color(0xff8A8A8A),
//                            ),
//                          ),
//                          SizedBox(width: 20.0),
//                          Text(
//                            '$time',
//                            style: TextStyle(
//
//
//                              fontSize: 16,
//                              color: Color(0xff8A8A8A),
//                            ),
//                          ),
//                        ],
//                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Divider(
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
