import 'package:rili/beautycalendar/beauty_calendar_config.dart';
import 'package:rili/beautycalendar/calendar_state.dart';
import 'package:rili/beautycalendar/calendar_widgets/range_select/range_normal_day_widget.dart';
import 'package:flutter/material.dart';

import 'package:rili/beautycalendar/calendar_event.dart';
import 'package:flutter/scheduler.dart';

import '../../CalendarUtil.dart';
import 'UpdateWidgetInterface.dart';
import 'in_selected_day_widget.dart';
import 'range_expired_date_widget.dart';
import 'range_selected_day_widget.dart';

class RangeMainWidget extends StatefulWidget {
  final List<String> itemArr; //值为["01","初三"]这样
  final String date; //是一个完整的日期,例：2020-07-30
  final OnSelectedEvent onSelected;
  final VoidCallback onReload;
  final bool selectedState;
  final BeautyCalendarConfig beautyCalendarConfig;

  const RangeMainWidget({
    Key key,
    this.itemArr,
    this.date,
    this.onSelected, this.onReload, this.selectedState, this.beautyCalendarConfig,
  }) : super(key: key);

  @override
  _RangeMainWidgetState createState() => _RangeMainWidgetState();
}

class _RangeMainWidgetState extends State<RangeMainWidget> implements UpdateWidgetInterface{
  var isSelected = false;
  var isOnTap=false;
  var needRefreshParentWidget=false;
  var needUpdateSelectedWidget=false;//需要刷新已选择的组件
  BeautyCalendarConfig _beautyCalendarConfig;
  var _isExpireDate=false;
  @override
   void initState() {
     // TODO: implement initState
     super.initState();
     if(widget.beautyCalendarConfig==null){
       _beautyCalendarConfig=BeautyCalendarConfig();
     }else{
       _beautyCalendarConfig=widget.beautyCalendarConfig;
     }
     if(CalendarState.dayViewMap==null){
         CalendarState.dayViewMap=new Map();
     }
     if(CalendarState.dayViewMap.containsKey(widget.date)){
       CalendarState.dayViewMap.remove(widget.date);
     }
     CalendarState.dayViewMap.putIfAbsent(widget.date, () => this);
  }

   //刷新整个日历
   void listenPageFinish(){
     WidgetsBinding.instance.addPostFrameCallback((_){
       final that=this;
       if(needRefreshParentWidget){
         CalendarState.selectedWidget = that;
         isOnTap=false;
         needRefreshParentWidget=false;
         widget.onReload?.call();
       }
     });
   }
   //刷新第一个选中的日期
   void listenPageFinishForUpdateSelectedWidget(){
    final that=this;
     WidgetsBinding.instance.addPostFrameCallback((_){
         if(needUpdateSelectedWidget){
           CalendarState.selectedWidget?.updateWidget();
         }
         CalendarState.selectedWidget = that;
         needUpdateSelectedWidget=false;
     });
   }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(_isExpireDate)return;
        //在这编写你的日历选择事件,当选中了某个日历，你想怎么处理就在这里操作
        //选择相同的日期，只在还没有选择结束日期的情况下判断
        if(CalendarState.endDate==null || CalendarState.endDate.isEmpty) {
          if (widget.date == CalendarState.beginDate) return;
        }
        isSelected=!isSelected;
        isOnTap=true;
        refresh();
        //print("on tap");
      },
      child: chooseWidget()
    );
  }

  Widget chooseWidget() {

    //print("chooseWidget method");

    var curDate = widget.date;
    var curDateTime=DateTime.parse(curDate);
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
      //print("第一次加载");
      return firstLoad(beginDateTime, endDateTime, curDateTime);
    }

    //这里判断是简单的刷新本控件，还是刷新整个日历
    if (isSelected) {

      //print(CalendarState.beginDate);
      //print(CalendarState.endDate);
      //如果已经开始选择了一个范围，那么就重新选择,刷新整个日历
      if(CalendarState.beginDate != null && CalendarState.beginDate.isNotEmpty
          && CalendarState.endDate != null && CalendarState.endDate.isNotEmpty){
        listenPageFinish();
        CalendarState.beginDate=curDate;
        CalendarState.endDate=null;
        widget.onSelected?.call("开始日期:"+curDate);
        needRefreshParentWidget=true;//刷新整个日历
        return RangeSelectedDayWidget(widget.itemArr, widget.date);
      }
      //选择第一个开始日期
      if (CalendarState.beginDate == null || CalendarState.beginDate.isEmpty) {
        //print("选择第一个开始日期");
        CalendarState.beginDate = curDate;
        CalendarState.selectedWidget = this;
        widget.onSelected?.call("开始日期:"+curDate);
        return RangeSelectedDayWidget(widget.itemArr, widget.date);
      }
      //第二个日期，endDate
      if (CalendarUtil.compare(DateTime.parse(CalendarState.beginDate),
          DateTime.parse(curDate))) {
        listenPageFinishForUpdateSelectedWidget();
        //如果endDate小于beginDate，那么就需要把第一个选择的日期重置，设置没有选中,在回调里刷新即可
        //print("第一个就需要清除掉"+curDate);
        CalendarState.beginDate = curDate;
        needUpdateSelectedWidget=true;
        return RangeSelectedDayWidget(widget.itemArr, widget.date);
      } else {
        listenPageFinish();
        //如果小于第一个日历，那么第一个就需要清除掉，等于重新选择
        CalendarState.endDate = curDate;
        //print("7777777777777:"+CalendarState.endDate);
        widget.onSelected?.call("结束日期:"+curDate);
        needRefreshParentWidget=true;//刷新整个日历
        isSelected=false;//这里要变回false，要不然这个控件别复用之后，即使重新加载整个日历逻辑会发生改变
        CalendarState.selectedWidget.clearState();
        return RangeSelectedDayWidget(widget.itemArr, widget.date);
      }
    }else{
      //print("取消选择");
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
//    print("----------------");
//    print(curDateTime);
//    print(beginDateTime);
//    print(endDateTime);

    //判断当前的日期是否是过期的日期
    if(isExpireDate()){
      return RangeExpiredDateWidget(widget.itemArr);
    }
    
    if(CalendarState.beginDate!=null){
      if(CalendarState.beginDate==widget.date){
        //print("RangeSelectedDayWidget");
        return RangeSelectedDayWidget(widget.itemArr, widget.date);
      }
    }

    if(CalendarState.endDate!=null){
      if(CalendarState.endDate==widget.date){
        //print("RangeSelectedDayWidget");
        return RangeSelectedDayWidget(widget.itemArr, widget.date);
      }
    }

    //判断是否在中间的日期
    if(beginDateTime!=null && endDateTime!=null) {
      if (CalendarUtil.compare(curDateTime, beginDateTime) &&
          CalendarUtil.compare(endDateTime, curDateTime)) {
        //print("InSelectedDayWidget");
        return InSelectedDayWidget(widget.itemArr,widget.date);
      }
    }
    return getNormalWidget();
  }

  bool isExpireDate(){
    if(_isExpireDate){
      return _isExpireDate;
    }
     //判断当前的日期是否是过期的日期
    var beginDateTemp=_beautyCalendarConfig.beginDate;
    if(beginDateTemp==null || beginDateTemp.isEmpty){
      beginDateTemp=getCurDate();
    }
    //如果设置的开始日期大于要显示的日期，说明要显示的日期是不可选的，是过期的
    if(CalendarUtil.compare(DateTime.parse(beginDateTemp), DateTime.parse(widget.date))){
      _isExpireDate=true;
      return true;
    }
    return false;
  }

  Widget getNormalWidget() {
    return RangeNormalDayWidget(itemArr:widget.itemArr,date:widget.date);
  }

  String getCurDate() {
    var now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  @override
  void updateWidget() {
    // TODO: implement updateWidget
    if(mounted){
      isOnTap=false;//清除状态要不然不是走firstload的逻辑
      //print("执行清除updateWidget"+widget.date);
      setState(() {
        //isSelected = !isSelected;
      });
    }
  }

  @override
  void clearState() {
    // TODO: implement clearState
    isSelected=false;
    isOnTap=false;
  }
}
