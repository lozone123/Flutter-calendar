import 'package:flutter/material.dart';

import 'package:rili/beautycalendar/calendar_event.dart';

class RangeNormalDayWidget extends StatefulWidget {
  final List<String> itemArr; //值为["01","初三"]这样
  final String date; //是一个完整的日期,例：2020-07-30
  final OnSelectedEvent onSelected;
  final VoidCallback onReload;

  const RangeNormalDayWidget({
    Key key,
    this.itemArr,
    this.date,
    this.onSelected, this.onReload,
  }) : super(key: key);

  @override
  _RangeNormalDayWidgetState createState() => _RangeNormalDayWidgetState();
}

class _RangeNormalDayWidgetState extends State<RangeNormalDayWidget>{
  var isSelected = false;
  var isOnTap=false;

  @override
   void initState() {
     // TODO: implement initState
     super.initState();

   }

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
                    widget.itemArr[0],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.itemArr[1],
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ])),
    );
  }
}
