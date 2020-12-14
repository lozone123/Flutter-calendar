import 'package:rili/beautycalendar/calendar_state.dart';
import 'package:flutter/material.dart';

import 'package:rili/beautycalendar/calendar_event.dart';

class ClockNormalDayWidget extends StatefulWidget {
  final List<String> itemArr; //值为["01","初三"]这样
  final String date; //是一个完整的日期,例：2020-07-30
  final OnSelectedEvent onSelected;

  const ClockNormalDayWidget({
    Key key,
    this.itemArr,
    this.date,
    this.onSelected,
  }) : super(key: key);

  @override
  _ClockNormalDayWidgetState createState() => _ClockNormalDayWidgetState();
}

class _ClockNormalDayWidgetState extends State<ClockNormalDayWidget> {
   var offStage = true;

   @override
   void initState() {
     // TODO: implement initState
     super.initState();
     if(CalendarState.clockList.contains(widget.date)){
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
          CalendarState.clockList.add(widget.date);
        }else{
          CalendarState.clockList.remove(widget.date);
        }

        setState(() {
        });

        widget.onSelected?.call(widget.date);
      },
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
            offStage
                ? SizedBox.shrink()
                : Positioned(
                    top:4,
                    child: Icon(
                      Icons.done,
                      color: Colors.green,
                      size: 36,
                    ))
          ])),
    );
  }
}
