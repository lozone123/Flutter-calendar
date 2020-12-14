import 'package:flutter/material.dart';

class RangeExpiredDateWidget extends StatelessWidget {
  final List<String> date;
  final Color grayColor = Color(0xffdddddd);

  RangeExpiredDateWidget( this.date,{Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

return GestureDetector(
      child: Container(
          alignment: Alignment.center,
          child: Stack(children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    date[0],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: grayColor),
                  ),
                  Text(
                    date[1],
                    style: TextStyle(fontSize: 10,color: grayColor),
                  ),
                ],
              ),
            ),
          ])),
    );

    // return Container(
    //   alignment: Alignment.center,
    //   child: Column(children: <Widget>[
    //     Expanded(
    //       child: Text(
    //         date[0],
    //         style: TextStyle(
    //             fontSize: 18, color: grayColor, fontWeight: FontWeight.bold),
    //       ),
    //     ),
    //     Expanded(
    //       child: Text(
    //         date[1],
    //         style: TextStyle(fontSize: 10, color: grayColor),
    //       ),
    //     ),
    //   ]),
    // );
  }
}
