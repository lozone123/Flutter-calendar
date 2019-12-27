import 'beauty_lunar_calendar.dart';

class BeautyCalendarCore {
  var headers = ["日", "一", "二", "三", "四", "五", "六"];

  int showMonths = 1; //要显示多少个月的日历
  bool isShowLunar = true; //是否显示农历

  BeautyCalendarCore();

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
    int lastYear=curYear;

    for (int i = 0; i < showMonths; i++) {
      var calendar = List<String>();
      int month = ((curMonth + i) % 12) == 0 ? 12 : ((curMonth + i) % 12);
      int year = curYear + (totalMonth > 12 ? totalMonth ~/ curMonth : 0);
      totalMonth++;
      int day;
      int week = getWeekdayOfMonth(year, month);
      int daysOfMonth = getDaysOfMonth(year, month);

      //在每个月份的开始显示月份
      calendar.add("$month月");
      if (year != lastYear) {
        calendar.add("$year".substring(2) + "年");
        lastYear=year;
      } else {
        calendar.add(" ");
      }
      calendar.addAll(fillSpace(5));

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

      String key = "$year$month";
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

  //某月第一天为星期几
  int getWeekdayOfMonth(int year, month) {
    var d3 = new DateTime(year, month, 1);
    return d3.weekday;
  }

  DateTime getNow() {
    var now = new DateTime.now();
    return now;
  }

  String getCurDate(){
    var now=getNow();
    return "${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}";
  }
}
