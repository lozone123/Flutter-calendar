import 'package:rili/beautycalendar/calendar_widgets/range_select/UpdateWidgetInterface.dart';
import 'package:flutter/material.dart';

import 'package:rili/beautycalendar/calendar_event.dart';

import '../../calendar_state.dart';

class RangeSelectedDayWidget extends StatefulWidget {
  final List<String> date;
  final String dateStr;
  final OnSelectedEvent onSelected;

  const RangeSelectedDayWidget(this.date, this.dateStr, {Key key, this.onSelected})
      : super(key: key);

  @override
  _SelectedDayWidgetState createState() => _SelectedDayWidgetState();
}

class _SelectedDayWidgetState extends State<RangeSelectedDayWidget> {

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
              color: Color(0xff00CAE2), borderRadius: BorderRadius.circular(8)),
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
