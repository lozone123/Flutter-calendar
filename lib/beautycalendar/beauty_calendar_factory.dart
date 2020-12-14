import 'package:rili/beautycalendar/beauty_calendar_page.dart';
import 'package:rili/beautycalendar/beauty_calendar_config.dart';
import 'package:rili/beautycalendar/beauty_calendar_show_type.dart';
import 'package:rili/beautycalendar/calendar_pages/beauty_calendar_pullup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'calendar_event.dart';

typedef SelectDateCallback = void Function(String date); //当选择好日期之后返回用户选择的日期

class BeautyCalendarFactory {
  final BeautyCalendarShowType _showType;
  final BeautyCalendarConfig _beautyCalendarConfig;
  final BuildContext _context;

  SelectDateCallback _onSelectDate;
  SelectDateCallbackWithMap _onSelectDateMap;
  Widget _calendarWidget;

  factory BeautyCalendarFactory(
      BuildContext context,
      BeautyCalendarShowType showType,
      BeautyCalendarConfig beautyCalendarConfig,
      SelectDateCallback onSelectDate,
      {SelectDateCallbackWithMap onSelectDateMap}) {
    return BeautyCalendarFactory._internal(
        context, showType, beautyCalendarConfig, onSelectDate, onSelectDateMap);
  }

  BeautyCalendarFactory._internal(this._context, this._showType,
      this._beautyCalendarConfig, this._onSelectDate, this._onSelectDateMap);

  void show() {
    switch (_showType) {
      case BeautyCalendarShowType.NewPage:
        _calendarWidget =
            BeautyCalendarPage(_beautyCalendarConfig, _onSelectDate);
        _navigatorTo();
        break;
      case BeautyCalendarShowType.PullUp:
        _calendarWidget = BeautyCalendarPullUpPage(_beautyCalendarConfig,_onSelectDate);
        _pullUp(); //从底部滑出
        break;
      default:
        break;
    }
  }

  //跳转到新的页面
  _navigatorTo() async {
    var selectDate = await Navigator.of(_context).push(
        MaterialPageRoute(builder: (BuildContext context) => _calendarWidget));
    this._onSelectDate?.call(selectDate != null ? selectDate["date"] : "");
    this._onSelectDateMap?.call(selectDate);
  }

  //从底部弹出
  _pullUp() async {
    var selectDate = await showModalBottomSheet(
        context: _context,
        builder: (BuildContext context) {
          return _calendarWidget;
        });
    this._onSelectDate?.call(selectDate != null ? selectDate["date"] : "");
    this._onSelectDateMap?.call(selectDate);
  }
}
