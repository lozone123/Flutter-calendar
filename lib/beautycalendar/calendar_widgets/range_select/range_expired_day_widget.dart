import 'package:flutter/material.dart';

class RangeExpiredDayWidget extends StatefulWidget {

  final List<String> itemArr; //值为["01","初三"]这样
  
  RangeExpiredDayWidget({Key key, this.itemArr}) : super(key: key);

  @override
  _RangeExpiredDayWidgetState createState() => _RangeExpiredDayWidgetState();
}

class _RangeExpiredDayWidgetState extends State<RangeExpiredDayWidget>{
  final Color grayColor = Color(0xffdddddd);

  @override
   void initState() {
     // TODO: implement initState
     super.initState();

   }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Stack(children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  widget.itemArr[0],
                  style: TextStyle(fontSize: 18,color: grayColor, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.itemArr[1],
                  style: TextStyle(fontSize: 10,color: grayColor,),
                ),
              ],
            ),
          ),
        ]));
  }
}
