import 'package:flutter/material.dart';

import 'package:rili/beautycalendar/calendar_event.dart';

import '../../calendar_state.dart';

class ClockSelectedDayWidget extends StatefulWidget {
  final List<String> date;
  final String dateStr;
  final OnSelectedEvent onSelected;

  const ClockSelectedDayWidget(this.date, this.dateStr, {Key key, this.onSelected})
      : super(key: key);

  @override
  _SelectedDayWidgetState createState() => _SelectedDayWidgetState();
}

class _SelectedDayWidgetState extends State<ClockSelectedDayWidget> {
  var offStage = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(CalendarState.clockList.contains(widget.dateStr)){
      offStage=false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //在这编写你的日历选择事件,当选中了某个日历，你想怎么处理就在这里操作
        offStage = !offStage;

        if(!offStage){
          CalendarState.clockList.add(widget.dateStr);
        }else{
          CalendarState.clockList.remove(widget.date);
        }
        setState(() {
        });
        widget.onSelected?.call(widget.dateStr);
      },
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
            offStage
                ? SizedBox.shrink()
                : Positioned(
                    top: 4,
                    child: Icon(
                      Icons.done,
                      color: Colors.green,
                      size: 36,
                    ))
          ])),
    );
  }
}
