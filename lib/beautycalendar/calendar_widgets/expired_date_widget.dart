import 'package:flutter/material.dart';

class ExpiredDateWidget extends StatelessWidget {
  final List<String> date;
  final Color grayColor = Color(0xffdddddd);

  ExpiredDateWidget( this.date,{Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(children: <Widget>[
        Expanded(
          child: Text(
            date[0],
            style: TextStyle(
                fontSize: 18, color: grayColor, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            date[1],
            style: TextStyle(fontSize: 10, color: grayColor),
          ),
        ),
      ]),
    );
  }
}
