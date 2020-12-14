import 'package:flutter/material.dart';
import 'package:rili/beautycalendar/beauty_calendar_config.dart';
import 'package:rili/beautycalendar/beauty_calendar_factory.dart';
import 'package:rili/beautycalendar/beauty_calendar_show_type.dart';
import 'package:rili/beautycalendar/calendar_state.dart';

class CalendarTest extends StatefulWidget {
  @override
  _CalendarTestState createState() => _CalendarTestState();
}

class _CalendarTestState extends State<CalendarTest> {
 
  @override
  Widget build(BuildContext context) {
    BeautyCalendarConfig _beautyCalendarConfig = BeautyCalendarConfig();
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          width: double.infinity,
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text("日历1(单选)"),
                onPressed: () async {
                  CalendarState.clearAllData();
                  _beautyCalendarConfig.isSingleSelect=true;
                  _beautyCalendarConfig.isRangSelect=false;
                  _beautyCalendarConfig.isClockOff=false;
                  var factory = BeautyCalendarFactory(
                      context,
                      BeautyCalendarShowType.NewPage,
                      _beautyCalendarConfig, (String date) {
                    print(date);
                  });
                  factory.show();
                },
              ),
              RaisedButton(
                child: Text("日历2(支持范围选择)"),
                onPressed: () async {
                  CalendarState.clearAllData();
                  _beautyCalendarConfig.isSingleSelect=false;
                  _beautyCalendarConfig.isRangSelect=true;
                  _beautyCalendarConfig.isClockOff=false;
                  var factory = BeautyCalendarFactory(
                      context,
                      BeautyCalendarShowType.NewPage,
                      _beautyCalendarConfig, (String date) {
                    print(date);
                  },onSelectDateMap: (Map date){
                    print(date);
                  });
                  factory.show();
                },
              ),
              RaisedButton(
                child: Text("日历3(签到)"),
                onPressed: () async {
                  CalendarState.clearAllData();
                  _beautyCalendarConfig.isSingleSelect=false;
                  _beautyCalendarConfig.isRangSelect=false;
                  _beautyCalendarConfig.isClockOff=true;
                  var factory = BeautyCalendarFactory(
                      context,
                      BeautyCalendarShowType.NewPage,
                      _beautyCalendarConfig, (String date) {
                    print(date);
                  });
                  factory.show();
                },
              ),
              //-----------底部弹出-------------
              RaisedButton(
                child: Text("日历1(单选)-底部弹出"),
                onPressed: () async {
                  CalendarState.clearAllData();
                  _beautyCalendarConfig.isSingleSelect=true;
                  _beautyCalendarConfig.isRangSelect=false;
                  _beautyCalendarConfig.isClockOff=false;
                  var factory = BeautyCalendarFactory(
                      context,
                      BeautyCalendarShowType.PullUp,
                      _beautyCalendarConfig, (String date) {
                    print(date);
                  });
                  factory.show();
                },
              ),
              RaisedButton(
                child: Text("日历2(支持范围选择)-底部弹出"),
                onPressed: () async {
                  CalendarState.clearAllData();
                  _beautyCalendarConfig.isSingleSelect=false;
                  _beautyCalendarConfig.isRangSelect=true;
                  _beautyCalendarConfig.isClockOff=false;
                  var factory = BeautyCalendarFactory(
                      context,
                      BeautyCalendarShowType.PullUp,
                      _beautyCalendarConfig, (String date) {
                    print(date);
                  },onSelectDateMap: (Map date){
                    print(date);
                  });
                  factory.show();
                },
              ),
              RaisedButton(
                child: Text("日历3(签到)-底部弹出"),
                onPressed: () async {
                  CalendarState.clearAllData();
                  _beautyCalendarConfig.isSingleSelect=false;
                  _beautyCalendarConfig.isRangSelect=false;
                  _beautyCalendarConfig.isClockOff=true;
                  var factory = BeautyCalendarFactory(
                      context,
                      BeautyCalendarShowType.PullUp,
                      _beautyCalendarConfig, (String date) {
                    print("选中的日期："+date);
                  });
                  factory.show();
                },
              ),
            ],
          ),
        ));
  }
}
