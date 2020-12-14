import 'package:flutter/material.dart';

import '../../calendar_state.dart';

class NormalDayWidget extends StatefulWidget {
  final List<String> itemArr;//值为["01","初三"]这样
  final String date;  //是一个完整的日期,例：2020-07-30

  const NormalDayWidget({Key key, this.itemArr, this.date}) : super(key: key);
  @override
  _NormalDayWidgetState createState() => _NormalDayWidgetState();
}

class _NormalDayWidgetState extends State<NormalDayWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //在这编写你的日历选择事件,当选中了某个日历，你想怎么处理就在这里操作
        CalendarState.selectDate=widget.date;
        Navigator.of(context).pop({"date": widget.date});
      },
      child: Container(
          alignment: Alignment.center,
          child: Column(children: <Widget>[
            Expanded(
              child: Text(
                widget.itemArr[0],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Text(
                widget.itemArr[1],
                style: TextStyle(fontSize: 10),
              ),
            ),
          ])),
    );
  }
}
