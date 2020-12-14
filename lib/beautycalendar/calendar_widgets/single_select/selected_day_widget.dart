import 'package:flutter/material.dart';

import '../../calendar_state.dart';

class SelectedDayWidget extends StatefulWidget {
  final List<String> date;
  final String dateStr;

  const SelectedDayWidget(this.date, this.dateStr,{Key key}) : super(key: key);
  @override
  _SelectedDayWidgetState createState() => _SelectedDayWidgetState();
}

class _SelectedDayWidgetState extends State<SelectedDayWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //在这编写你的日历选择事件,当选中了某个日历，你想怎么处理就在这里操作
        CalendarState.selectDate=widget.dateStr;
        Navigator.of(context).pop({"date": widget.dateStr});
      },
      child: Container(
          decoration: BoxDecoration(
              color: Color(0xff00CAE2),
              borderRadius: BorderRadius.circular(8)),
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.date[0],
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.date[1],
                    style: TextStyle(
                        fontSize: 10, color:Color(0xffffffff)),
                  ),
                ),
              ])),
    );
  }
}
