
import 'lunar_calendar.dart';

class BeautyCalendarCore {
  var headers = ["日", "一", "二", "三", "四", "五", "六"];

  final int showMonths; //要显示多少个月的日历
  final bool isShowLunar; //是否显示农历

  BeautyCalendarCore.getInstance(this.showMonths, this.isShowLunar);

  List<String> getHeaders() {
    return headers;
  }

  Map<String, List<String>> createCalendarData() {
    var lunarCalendar = LunarCalendar();

    var calendarMap = <String, List<String>>{};

    var nowDate = getNow();
    int curYear = nowDate.year;
    int curMonth = nowDate.month;
    int totalMonth = curMonth;

    for (int i = 0; i < showMonths; i++) {
      var calendar = List<String>();
      int month = ((curMonth + i) % 12) == 0 ? 12 : ((curMonth + i) % 12);
      int year = curYear + (totalMonth > 12 ? totalMonth ~/ 12 : 0);
      totalMonth++;
      int day;
      int week = getWeekdayOfMonth(year, month, 1);
      int daysOfMonth = getDaysOfMonth(year, month);

      for (int j = 0; j < daysOfMonth; j++) {
        //不是星期天，则补空白
        if (week != 7 && j == 0) {
          calendar.addAll(fillSpace(week));
        }
        day = j + 1;
        String item;
        if (isShowLunar) {
          item =
              "$year-${month.toString().padLeft(2, "0")}-${day.toString().padLeft(2, "0")},${lunarCalendar.getLunarDate(year, month, day, false)}";
        } else {
          item =
              "$year-${month.toString().padLeft(2, "0")}-${day.toString().padLeft(2, "0")},";
        }

        calendar.add(item);
      }
      //在末尾补空白,补满一行
      calendar.addAll(fillSpace((7 - calendar.length % 7) % 7));

      String key = "$year-$month";
      calendarMap[key] = calendar;
    }

    return calendarMap;
  }

  List<String> fillSpace(int count) {
    var space = List<String>();
    for (var i = 0; i < count; i++) {
      space.add(" ");
    }
    return space;
  }

  //是否为闰年
  bool isLeapYear(year) {
    if (year % 100 == 0 && year % 400 == 0) {
      return true;
    } else
      return year % 100 != 0 && year % 4 == 0;
  }

  //一个月当中有多少天
  int getDaysOfMonth(int year, int month) {
    int daysOfMonth;
    switch (month) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        daysOfMonth = 31;
        break;
      case 4:
      case 6:
      case 9:
      case 11:
        daysOfMonth = 30;
        break;
      case 2:
        if (isLeapYear(year)) {
          daysOfMonth = 29;
        } else {
          daysOfMonth = 28;
        }
    }
    return daysOfMonth;
  }

  DateTime getEndDate(String beginDate, String endDate, int showMonths) {
    var beginDateTime = DateTime.parse(beginDate);

    //每次最多只显示0-12个月
    if (showMonths <= 0 || showMonths > 12) {
      throw Exception("每次最多只能显示1-12个月");
    }

    var begins = beginDate.split("-");
    int year = int.parse(begins[0]);
    int month = int.parse(begins[1]);
    int day = int.parse(begins[2]);

    var days = getDaysOfMonth(year, month);
    var totalDays = days - day+1;
    //print("开始显示的天数：" + totalDays.toString());
    //要减1个月，因为第一个月已经计算
    if(showMonths-1>0){
      for (var i = 0; i < showMonths - 1; i++) {
        if (month + 1 > 12) {
          //如果月份大于12个月，要在年份上加一年
          month = 1;
          year += 1;
        }
        days = getDaysOfMonth(year, month);
        totalDays += days;
      }
    }

    //print("总共要显示的天数:" + totalDays.toString());
    var newEndDateTime = beginDateTime.add(Duration(days: totalDays));
    if (endDate != null && endDate.isNotEmpty) {
      var endDateTime = DateTime.parse(endDate);
      if (compare(newEndDateTime, endDateTime)) {
        //如果加上了总共要显示的月份大于设置的结束日期的话，那么就只显示到结束日期的月份
      } else {
        endDateTime = newEndDateTime;
      }
      return endDateTime;
    }
    return newEndDateTime;
  }

  //求星期几
  int getWeekdayOfMonth(int year, month, day) {
    var d3 = new DateTime(year, month, day);
    return d3.weekday;
  }

  bool isDateCorrect(String date) {
    if (!date.contains("-") || date.split("-").length != 3) {
      return false;
    }
    try {
      //日期能转换成功就说明是正确的日期
      DateTime.parse(date);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  bool isDateRangeCorrect(String beginDate, String endDate) {
    var isCorrect = isDateCorrect(beginDate);
    var isCorrect2 = isDateCorrect(endDate);
    if (isCorrect && isCorrect2) {
      var diff = DateTime.parse(beginDate).difference(DateTime.parse(endDate));
      if (diff.inDays >= 0) {
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

  Duration getDuration(String beginDate, String endDate) {
    return DateTime.parse(beginDate).difference(DateTime.parse(endDate));
  }

  //比较两个日期的大小，如果date1大于date2就返回true
  bool compare(DateTime date1, DateTime date2) {
    var duration = date1.difference(date2);
    if (duration.inDays > 0)
      return true;
    else
      return false;
  }

  DateTime getNow() {
    var now = new DateTime.now();
    return now;
  }

  String getCurDate() {
    var now = getNow();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  String dateFormat(DateTime dateTime){
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
  }
}
