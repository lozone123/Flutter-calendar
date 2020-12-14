import 'package:rili/beautycalendar/calendar_state.dart';
import 'package:flutter/material.dart';

class BothSideWidget extends StatefulWidget {
  final List<String> date;
  final String dateStr;

  const BothSideWidget(this.date, this.dateStr,{Key key}) : super(key: key);
  @override
  _BothSideWidgetState createState() => _BothSideWidgetState();
}

class _BothSideWidgetState extends State<BothSideWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CalendarState.selectDate=widget.dateStr;
        Navigator.of(context).pop({"date": widget.dateStr});
      },
      child: Container(
        alignment: Alignment.center,
        child:
        Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Expanded(
            child: Text(
              widget.date[0],
              style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff00CAE2),
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              widget.date[1],
              style: TextStyle(
                  fontSize: 10, color: Color(0xff00CAE2),)
            ),
          ),
        ]),
      ),
    );
  }
}
