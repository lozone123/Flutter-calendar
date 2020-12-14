import 'package:rili/beautycalendar/beauty_calendar_config.dart';
import 'package:rili/beautycalendar/calendar_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:rili/beautycalendar/calendar_widgets/single_select/normal_day_widget.dart';
import 'package:rili/beautycalendar/calendar_widgets/week_title_widget.dart';
import 'package:rili/beautycalendar/calendar_widgets/month_widget.dart';
import 'package:rili/beautycalendar/calendar_widgets/year_widget.dart';
import 'package:rili/beautycalendar/calendar_widgets/single_select/both_side_widget.dart';
import 'package:rili/beautycalendar/calendar_widgets/single_select/selected_day_widget.dart';
import 'package:rili/beautycalendar/calendar_widgets/expired_date_widget.dart';
import 'package:rili/beautycalendar/calendar_widgets/clock_off/clock_normal_day_widget.dart';
import 'package:rili/beautycalendar/calendar_widgets/range_select/range_main_widget.dart';

import 'CalendarUtil.dart';
import 'beauty_calendar_core.dart';
import 'calendar_event.dart';
import 'calendar_widgets/clock_off/clock_both_side_widget.dart';
import 'calendar_widgets/clock_off/clock_selected_day_widget.dart';
import 'calendar_widgets/calendar_float_action_button.dart';
import 'calendar_widgets/range_select/UpdateWidgetInterface.dart';
import 'lunar_calendar.dart';

class BeautyCalendarPage extends StatefulWidget {
  final BeautyCalendarConfig _config;
  final OnSelectedEvent onSelected;

  BeautyCalendarPage(this._config, this.onSelected);

  @override
  _BeautyCalendarPageState createState() => _BeautyCalendarPageState();
}

class _BeautyCalendarPageState extends State<BeautyCalendarPage> {
  BeautyCalendarCore beautyCalendarCore;
  LunarCalendar lunarCalendar = new LunarCalendar();
  String todayDate; //今天的日期
  double _initialScrollOffset = 0.0;
  ScrollController _scrollController;
  List<Widget> _listWidgets; //保存生成日历的组件，主要是为了动态加载下一个日历，要不然整个一刷新就从头开始了，状态不能保留
  int lastYear, lastMonth, lastDay; //最后显示的日期
  GlobalKey<CalendarFloatActionButtonState> _globalKeyFloatActionButton =
      new GlobalKey();

  @override
  void initState() {
    super.initState();

    beautyCalendarCore = BeautyCalendarCore.getInstance(
        widget._config.showMonth, widget._config.isShowLunar);

    CalendarState.dayViewMap = new Map();

    todayDate = beautyCalendarCore.getCurDate();
    //监听滚动，如果滚动到底部那么就加载下一个月份的日历
    //print("initState");
    _scrollController = new ScrollController();
    listenToScroll();
  }

  void listenToScroll() {
    _scrollController.addListener(() {
      int offset = _scrollController.position.pixels.toInt();
      //print("滑动距离$offset");
      // 如果滑动到底部，下拉加载更多的日历
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        var endDate = widget._config.endDate;
        var year = lastYear;
        var month = lastMonth;
        var day = lastDay;
        month++;
        if (month > 12) {
          month = 1;
          year++;
        }
        //从第一天开始，要不然判断会有误差
        var newDate = "$year-${month.toString().padLeft(2, '0')}-${"01"}";
        var newDateTime = DateTime.parse(newDate);

        if (endDate != null && endDate.isNotEmpty) {
          if (beautyCalendarCore.compare(
              newDateTime, DateTime.parse(endDate))) {
          } else {
            //如果新生成的日期没有大于限定的范围则继续生成下一个月份的日历视图,否则停止生成
            setLastDate(year, month, day);
            createEveryMonthView([year, month, day]);
          }
        } else {
          setLastDate(year, month, day);
          createEveryMonthView([year, month, day]);
        }
      }
    });
  }

  //当整个日历加载完成则判断是否用户已经选择了一个范围
  void listenCalendarPageFinish() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //print("listenCalendarPageFinish");
      //主要是为了更新悬浮按钮的多少晚的文字
      countRangeDays();
    });
  }

  //统计用户选择了多少天
  void countRangeDays() {
    if (CalendarState.beginDate != null &&
        CalendarState.beginDate.isNotEmpty &&
        CalendarState.endDate != null &&
        CalendarState.endDate.isNotEmpty) {
      var dur = beautyCalendarCore.getDuration(
          CalendarState.endDate, CalendarState.beginDate);
      var days = dur.inDays;
      String str = "(共$days晚)";
      _globalKeyFloatActionButton.currentState?.updateText(str);
    } else {
      _globalKeyFloatActionButton.currentState?.updateText("");
    }
  }

  void setLastDate(int year, int month, int day) {
    lastYear = year;
    lastMonth = month;
    lastDay = day;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
    _globalKeyFloatActionButton = null;
  }

  @override
  Widget build(BuildContext context) {
    //放到build里面，每次刷新都要监听
    listenCalendarPageFinish();
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("选择日期"),
        actions: [
          FlatButton(
            child: Text("确定",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(context).pop({
                "beginDate": CalendarState.beginDate,
                "endDate": CalendarState.endDate
              });
            },
          )
        ],
      ),
      body: getBody(),
      floatingActionButton: widget._config.isRangSelect
          ? CalendarFloatActionButton(key: _globalKeyFloatActionButton)
          : null,
    );
  }

  Widget getBody() {
    return Container(
        child: Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(3, 10, 5, 10),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: createWeekWidget()),
      ),
      Expanded(
          child: CustomScrollView(
              controller: _scrollController,
              slivers: _listWidgets ?? createDaysOfMonthWidgets()))
    ]));
  }

//显示星期几
  List<Widget> createWeekWidget() {
    return beautyCalendarCore
        .getHeaders()
        .map((item) => createWeekDetailWidget(item))
        .toList();
  }

  Widget createWeekDetailWidget(String item) {
    return WeekTitleWidget(item);
  }

  //每个月份详细展示
  List<Widget> createDaysOfMonthWidgets() {
    //print("createDaysOfMonthWidgets");
    var beginDate = widget._config.beginDate;
    if (beginDate != null && beginDate.isNotEmpty) {
      if (!beautyCalendarCore.isDateCorrect(beginDate))
        throw Exception("开始日期格式不正确,正确格式如：2020-01-22(xxxx-xx-xx)");
    } else {
      beginDate = beautyCalendarCore.getCurDate();
      widget._config.beginDate = beginDate;
    }

    var endDate = widget._config.endDate;
    if (endDate != null && endDate.isNotEmpty) {
      if (!beautyCalendarCore.isDateCorrect(endDate))
        throw Exception("结束日期格式不正确,正确格式如：2020-01-22(xxxx-xx-xx)");

      if (!beautyCalendarCore.isDateRangeCorrect(beginDate, endDate))
        throw Exception("开始日期不能大于结束日期");
    }
    var showMonths = widget._config.showMonth;
    var beginDateTime = DateTime.parse(beginDate);
    //获取最初要显示的结束日期
    DateTime endDateTime;
    if (showMonths == 0 && endDate != null && endDate.isNotEmpty) {
      //如果没有设置showMonths而且设置了endDate，那么就显示完到endDate
      endDateTime = DateTime.parse(endDate);
    } else {
      endDateTime =
          beautyCalendarCore.getEndDate(beginDate, endDate, showMonths);
    }

    if (widget._config.endDate == null) {
      //如果没有设置结束范围，那么就设置一个超大的范围显示
      widget._config.endDate = beautyCalendarCore
          .dateFormat(beginDateTime.add(Duration(days: 365 * 10)));
    }

    //print(endDateTime);

    var list = List<Widget>();
    int _prevYear;
    var i = 0;
    var year = beginDateTime.year,
        month = beginDateTime.month,
        day = beginDateTime.day;

    for (;;) {
      var datePiece = [year, month, day];
      var monthDays =
          beautyCalendarCore.getDaysOfMonth(datePiece[0], datePiece[1]);
      prevYear = _prevYear == null ? datePiece[0] : _prevYear;
      _prevYear = datePiece[0];
      //----begin显示月份---
      var monthTitle = SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [showYear(datePiece, i++), MonthWidget(month)],
          ),
        ),
      );

      list.add(monthTitle);
      //-----end显示月份------

      //--------显示每个月份的天数-------
      final int finalMonth = month; //这里使用final是因为还没加载完一个月份的天数month就会被改变了

      int week = beautyCalendarCore.getWeekdayOfMonth(year, month, 1);

      final finalWeek = week;

      var daysOfWidget = SliverGrid(
        delegate:
            SliverChildBuilderDelegate((BuildContext buildContext, int index) {
          if (index < finalWeek) {
            //对齐星期几，所以如果每个月的1号是星期几就要返回几个空的控件
            return SizedBox.shrink();
          }
          //这里index减week也就是日期变化从1号开始
          //print(year.toString()+finalMonth.toString()+(index-week).toString());
          return createDayWidget(year, finalMonth, index - week);
        }, childCount: monthDays + week),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7), //每行显示7天
      );

      list.add(daysOfWidget);
      //--------显示每个月份的天数----------
      month++;
      if (month > 12) {
        year++;
        month = 1;
      }

      var tempDate =
          DateTime.parse("$year-${month.toString().padLeft(2, '0')}-01");
      if (beautyCalendarCore.compare(tempDate, endDateTime)) {
        //当开始日期大于结束日期的时候就停止继续构建日期
        //print("$tempDate日期结束$endDateTime");
        setLastDate(endDateTime.year, endDateTime.month, endDateTime.day);
        break;
      }
    }

    //这是第一次加载生成的日历，加载下一个月的日历不会用到该方法，所以这里使用了等于赋值
    _listWidgets = list;
    return list;
  }

  void createEveryMonthView(List<int> datePiece) {
    var year = datePiece[0];
    var month = datePiece[1];
    var day = datePiece[2];
    var list = List<Widget>();
    //----begin显示月份---
    var monthTitle = SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [showYear(datePiece, 1), MonthWidget(month)],
        ),
      ),
    );
    list.add(monthTitle);
    //-----end显示月份------

    int week = beautyCalendarCore.getWeekdayOfMonth(year, month, 1);
    int monthDays = beautyCalendarCore.getDaysOfMonth(year, month);
    var daysOfWidget = SliverGrid(
      delegate:
          SliverChildBuilderDelegate((BuildContext buildContext, int index) {
        if (index < week) {
          //对齐星期几，所以如果每个月的1号是星期几就要返回几个空的控件
          return SizedBox.shrink();
        }
        //这里index减week也就是日期变化从1号开始
        return createDayWidget(year, month, index - week);
      }, childCount: monthDays + week),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7), //每行显示7天
    );

    list.add(daysOfWidget);
    //--------显示每个月份的天数----------
    _listWidgets.addAll(list);
    //刷新页面
    setState(() {});
  }

  int prevYear;

  Widget showYear(List<int> date, int i) {
    var nowyear = beautyCalendarCore.getNow().year;
    //如果不是今年则要展示年份
    var year = date[0].toString().substring(2);
    //最初第一个月份的展示，需要跟nowyear的年份来判断
    if (i == 0 && prevYear != nowyear) {
      return YearWidget(year);
    }
    //当滑动到第二年也要显示年份
    if (prevYear != date[0]) {
      return YearWidget(year);
    }

    return SizedBox.shrink();
  }

  var isExpireDate = true; //判断开始日期的前半部
  var isExpireDateEnd = false; //判断结束日期的后半部
  var oldBeginDate = "", oldEndDate = ""; //用来保存已刷新的日期

  void updatePartWidget(String beginDate, String endDate, bool isOldUpdate) {
//   print("-----------------------updatePartWidget");
//   print(beginDate);
//   print(endDate);
//   print(isOldUpdate);
    var dur = beautyCalendarCore.getDuration(endDate, beginDate);
    var days = dur.inDays;
    //print(days);
    //print("-----------------------updatePartWidget");
    var temp = DateTime.parse(beginDate);
    for (var i = 0; i < days; i++) {
      if (isOldUpdate) {
        days += 1;
        isOldUpdate = false;
      } else {
        temp = temp.add(Duration(days: 1));
      }
      var key = beautyCalendarCore.dateFormat(temp);
      if (CalendarState.dayViewMap.containsKey(key)) {
        var dayWidget = CalendarState.dayViewMap[key];
        dayWidget.updateWidget();
      }
    }
    countRangeDays();
  }

  //创建每一天的widget
  Widget createDayWidget(int year, month, int day) {
    day = day + 1;
    var itemArr = [day.toString(), ""]; //day,农历
    var monthStr = month.toString();
    var dayStr = day.toString();
    if (month <= 9) {
      monthStr = monthStr.padLeft(2, '0');
    }
    if (day <= 9) {
      dayStr = dayStr.padLeft(2, '0');
    }
    String dateStr = "$year-$monthStr-$dayStr";

    //是否显示农历
    if (widget._config.isShowLunar) {
      var lunar = lunarCalendar.getLunarDate(year, month, day, true);
      itemArr[1] = lunar;
    }

    //itemArr最后的值是[03,初三]这样
    final String date = dateStr;

    //如果是范围选择的话那么就直接返回这个控件就好了，这个控件有判断需要什么状态的组件
    if (widget._config.isRangSelect) {
      var rangeDayWidget = RangeMainWidget(
        itemArr: itemArr,
        date: date,
        onSelected: widget.onSelected,
        onReload: () {
          if (mounted) {
            print("calendar page refresh");
            if (CalendarState.dayViewMap.length > 0) {
              if (!checkRangeIsNullOrEmpty(oldBeginDate, oldEndDate)) {
                updatePartWidget(oldBeginDate, oldEndDate, true);
                oldBeginDate = "";
                oldEndDate = "";
              }
              if (!checkRangeIsNullOrEmpty(
                  CalendarState.beginDate, CalendarState.endDate)) {
                var beginDate = CalendarState.beginDate;
                var endDate = CalendarState.endDate;
                oldBeginDate = beginDate;
                oldEndDate = endDate;
                updatePartWidget(beginDate, endDate, false);
              }
            }
          }
        },
      );

      return rangeDayWidget;
    }

    //过期日期，不可选日期,灰色的日期
    if (checkIsExpireDate(date)) {
      return createExpiredDateWidget(itemArr);
    }

    //当显示的日期等于开始的日期就不在是不可点击的灰色了,开始的日期跟今天的日期不是同一个东西
    //需要区别对待
    // if (date == widget._config.beginDate) {
    //   //isExpireDate = false;
    //   //如果是今天当然日期则显示今天的组件
    //   if (isCurDate(date)) {
    //     return createCurDateWidget(itemArr, date);
    //   }
    //   //等于的还是要正常显示的
    //   return createNormalDay(itemArr, date);
    // }

    //放在这里主要是等于的日期还是要正常显示
    // var endDate = widget._config.endDate;
    // //如果设置有结束日期，后面的日期就显示灰色不可选
    // if (endDate != null && endDate.isNotEmpty) {
    //   if (date == endDate) {
    //     //isExpireDateEnd = true;
    //     //等于的还是要正常显示的
    //     return createNormalDay(itemArr, date);
    //   }
    // }

    
    //如果用户没有选择任何日期，那么就判断今天的日期为选中状态
    if (isCurDate(date)) return createCurDateWidget(itemArr, date);

    //两边的日期,如果是两边的日期则显示不同的样式
    var week = beautyCalendarCore.getWeekdayOfMonth(year, month, day);
    if (week == 7 || week == 6) {
      return createBothSideDateWidget(itemArr, date);
    }

    return createNormalDay(itemArr, date);
  }
  //判断是否是灰色的日期,不应该显示
  bool checkIsExpireDate(String date){
     //判断当前的日期是否是过期的日期
    var beginDateTemp=widget._config.beginDate;
    if(beginDateTemp==null || beginDateTemp.isEmpty){
      beginDateTemp=beautyCalendarCore.getCurDate();
    }
    var tempDate1=DateTime.parse(beginDateTemp);
    var tempDate2= DateTime.parse(date);
    //如果设置的开始日期大于要显示的日期，说明要显示的日期是不可选的，是过期的
    if(CalendarUtil.compare(tempDate1, tempDate2)){
      return true;
    }else{
      //或者大于设置的结束日期，也要变成灰色的，不可点击的
      if(widget._config.endDate!=null && widget._config.endDate.isNotEmpty){
        if(CalendarUtil.compare(tempDate2,DateTime.parse(widget._config.endDate))){
          return true;
        }
      }
    }
    return false;
  }

  //是否是今天的日期
  bool isCurDate(String date) {
    if (CalendarState.selectDate == null || CalendarState.selectDate.isEmpty) {
      if (date == todayDate) {
        if (todayDate == widget._config.beginDate) {
          isExpireDate = false;
        }
        return true;
      }
    } else {
      if (date == CalendarState.selectDate) return true;
    }
    return false;
  }

  Widget createNormalDay(List<String> itemArr, final String date) {
    //这里是正常的日期，不是特殊的日期，比如今天的日期或者选中的日期
    if (widget._config.isClockOff)
      return ClockNormalDayWidget(
        itemArr: itemArr,
        date: date,
        onSelected: widget.onSelected,
      );

    if (widget._config.isRangSelect)
      return RangeMainWidget(
        itemArr: itemArr,
        date: date,
        onSelected: widget.onSelected,
        onReload: () {},
      );

    return NormalDayWidget(itemArr: itemArr, date: date);
  }

  bool checkRangeIsNullOrEmpty(String beginDate, String endDate) {
    if (beginDate == null ||
        beginDate.isEmpty ||
        endDate == null ||
        endDate.isEmpty) {
      return true;
    }
    return false;
  }

//生成今天的日期widget，主要是今天的日期显示的样式不一样
  Widget createCurDateWidget(List<String> date, final String curSelDate) {
    if (widget._config.isClockOff)
      return ClockSelectedDayWidget(
        date,
        curSelDate,
        onSelected: widget.onSelected,
      );
    if (widget._config.isRangSelect)
      return RangeMainWidget(
        itemArr: date,
        date: curSelDate,
        onSelected: widget.onSelected,
        onReload: () {
          //setState(() {});
        },
      );
    return SelectedDayWidget(date, curSelDate);
  }

  Widget createExpiredDateWidget(List<String> date) {
    return ExpiredDateWidget(
      date,
    );
  }

  //生成两边的日期的样式，只要是两边显示的日期颜色不一样
  Widget createBothSideDateWidget(List<String> date, final String curSelDate) {
    if (widget._config.isClockOff)
      return ClockBothSideWidget(
        date,
        curSelDate,
        onSelected: widget.onSelected,
      );
    if (widget._config.isRangSelect)
      return RangeMainWidget(
        itemArr: date,
        date: curSelDate,
        onSelected: widget.onSelected,
        onReload: () {
          //setState(() {});
        },
      );
    return BothSideWidget(date, curSelDate);
  }
}
