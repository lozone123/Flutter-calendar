import 'package:flutter/material.dart';

import 'package:rili/beautycalendar/calendar_event.dart';

import '../../calendar_state.dart';

///在选中的日期范围中间部分的控件，样式不一样
class InSelectedDayWidget extends StatefulWidget {
  final List<String> date;
  final String dateStr;
  final OnSelectedEvent onSelected;

  const InSelectedDayWidget(this.date, this.dateStr, {Key key, this.onSelected})
      : super(key: key);

  @override
  _InSelectedDayWidgetState createState() => _InSelectedDayWidgetState();
}

class _InSelectedDayWidgetState extends State<InSelectedDayWidget> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          decoration: BoxDecoration(
              color: Color(0xffb2f1f6), borderRadius: BorderRadius.circular(8)),
          alignment: Alignment.center,
          child: Stack(children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    widget.date[0],
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.date[1],
                    style: TextStyle(fontSize: 10, color: Color(0xffffffff)),
                  ),
                ],
              ),
            ),
          ])),
    );
  }
}
