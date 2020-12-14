import 'package:flutter/cupertino.dart';

import 'calendar_widgets/range_select/UpdateWidgetInterface.dart';
import 'calendar_widgets/range_select/range_main_widget.dart';

class CalendarState{

  //记住用户的一些操作、数据等,比如：选中的日期

  static String selectDate;//用户选中的日期

  static List<String> clockList=new List();//签到日期保存

  static String beginDate; //用户范围选择的开始日期
  static String endDate;  //用户范围选择的结束日期
  static UpdateWidgetInterface selectedWidget;//保存用户的选择的widget，用于局部刷新
  static Map<String,UpdateWidgetInterface> dayViewMap;//保存日历每个day widget用来局部刷新

  static void clearAllData(){
    selectDate="";
    beginDate="";
    endDate="";
    clockList.clear();
    selectedWidget=null;
  }

}