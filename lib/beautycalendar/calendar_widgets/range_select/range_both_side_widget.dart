import 'package:rili/beautycalendar/CalendarUtil.dart';
import 'package:rili/beautycalendar/calendar_widgets/range_select/UpdateWidgetInterface.dart';
import 'package:rili/beautycalendar/calendar_widgets/range_select/range_selected_day_widget.dart';
import 'package:rili/beautycalendar/calendar_widgets/range_select/in_selected_day_widget.dart';
import 'package:flutter/material.dart';

import 'package:rili/beautycalendar/calendar_event.dart';

import '../../calendar_state.dart';

class RangeBothSideWidget extends StatefulWidget {
  final List<String> date;
  final String dateStr;
  final OnSelectedEvent onSelected;
  final VoidCallback onReload;

  const RangeBothSideWidget(this.date, this.dateStr, {Key key, this.onSelected, this.onReload})
      : super(key: key);

  @override
  _RangeBothSideWidgetState createState() => _RangeBothSideWidgetState();
}

class _RangeBothSideWidgetState extends State<RangeBothSideWidget>
    implements UpdateWidgetInterface {

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
        onTap: () {
          //在这编写你的日历选择事件,当选中了某个日历，你想怎么处理就在这里操作
          isSelected=!isSelected;
          isOnTap=true;
          refresh();
        },
        child: chooseWidget());
  }

  Widget chooseWidget() {

    var curDate = widget.dateStr;
    var curDateTime=DateTime.parse(widget.dateStr);
    DateTime beginDateTime;
    DateTime endDateTime;
    if(CalendarState.beginDate!=null && CalendarState.beginDate.isNotEmpty){
      beginDateTime=DateTime.parse(CalendarState.beginDate);
    }
    if(CalendarState.endDate!=null && CalendarState.endDate.isNotEmpty){
      endDateTime=DateTime.parse(CalendarState.endDate);
    }
    if(!isOnTap){
      //第一次加载
     return firstLoad(beginDateTime, endDateTime, curDateTime);
    }

    //这里判断是简单的刷新本控件，还是刷新整个日历
    if (isSelected) {

      //如果已经开始选择了一个范围，那么就重新选择,刷新整个日历
      if(CalendarState.beginDate != null && CalendarState.beginDate.isNotEmpty
         && CalendarState.endDate != null || CalendarState.endDate.isNotEmpty){
        CalendarState.beginDate=curDate;
        widget.onSelected?.call("开始日期:"+curDate);
        widget.onReload?.call();//刷新整个日历
        return SizedBox.shrink();
      }
      //选择第一个开始日期
      if (CalendarState.beginDate == null || CalendarState.beginDate.isEmpty) {
        CalendarState.beginDate = curDate;
        CalendarState.selectedWidget = this;
        widget.onSelected?.call("开始日期:"+curDate);
        return RangeSelectedDayWidget(widget.date, widget.dateStr);
      }
      //第二个日期，结束日期
      if (CalendarUtil.compare(
          DateTime.parse(curDate), DateTime.parse(CalendarState.beginDate))) {
        //如果选择的第二个日期大于第一个日期，那么就需要把第一个选择的日期重置，设置没有选中,在回调里刷新即可
        CalendarState.beginDate = curDate;
        CalendarState.selectedWidget.updateWidget();
        CalendarState.selectedWidget = this;
        return RangeSelectedDayWidget(widget.date, widget.dateStr);
      } else {
        //如果小于第一个日历，那么第一个就需要清除掉，等于重新选择
        CalendarState.beginDate = curDate;
        widget.onSelected?.call("结束日期:"+curDate);
        widget.onReload?.call();
      }
    }else{
      //取消选择，
      return getNormalWidget();
    }
  }

  void refresh(){
    //刷新本控件
    setState(() {
    });
  }

  Widget firstLoad(DateTime beginDateTime,DateTime endDateTime,DateTime curDateTime){
    //第一次加载
    if(CalendarState.beginDate!=null){
      if(CalendarState.beginDate==widget.dateStr){
        isSelected = true;
        return RangeSelectedDayWidget(widget.date, widget.dateStr);
      }
    }

    if(CalendarState.endDate!=null){
      if(CalendarState.endDate==widget.dateStr){
        isSelected=true;
        return RangeSelectedDayWidget(widget.date, widget.dateStr);
      }
    }

    //判断是否在中间的日期
    if(beginDateTime!=null && endDateTime!=null) {
      if (CalendarUtil.compare(curDateTime, beginDateTime) &&
          CalendarUtil.compare(endDateTime, curDateTime)) {
        return InSelectedDayWidget(widget.date,widget.dateStr);
      }
    }
    return getNormalWidget();
  }

  Widget getNormalWidget() {
    return Container(
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
                    color: Color(0xff00CAE2),
                    fontWeight: FontWeight.bold),
              ),
              Text(widget.date[1],
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xff00CAE2),
                  )),
            ],
          ),
        ),
      ]),
    );
  }

  @override
  void updateWidget() {
    // TODO: implement updateWidget
    setState(() {
      isSelected = !isSelected;
    });
  }

  @override
  void clearState() {
    // TODO: implement clearState
  }
}
