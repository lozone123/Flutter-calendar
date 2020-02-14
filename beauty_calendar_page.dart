import 'package:apartment_manage/calendar/beauty_calendar_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import 'beauty_calendar2_core.dart';

class BeautyCalendar2Page extends StatefulWidget {
  final BeatutyCalendarConfig _config;

  BeautyCalendar2Page(this._config);

  @override
  _BeautyCalendar2PageState createState() => _BeautyCalendar2PageState();
}

class _BeautyCalendar2PageState extends State<BeautyCalendar2Page> {
  BeautyCalendar2Core beautyCalendarCore;

  @override
  void initState() {
    super.initState();

    beautyCalendarCore = BeautyCalendar2Core.getInstance(
        widget._config.showMonth, widget._config.isShowLunar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("选择日期"),
      ),
      body: getBody(),
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
      Expanded(child: CustomScrollView(slivers: createDaysOfMonthWidgets()))
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
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Text(
          item,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

//每个月份详细展示
  List<Widget> createDaysOfMonthWidgets() {
    Map<String, List<String>> map = beautyCalendarCore.createCalendarData();
    var keys = map.keys;
    var list = List<Widget>();
    String prevKey;
    var i = 0;
    for (var key in keys) {
      var datePiece = key.split("-");
      prevYear = prevKey == null ? datePiece[0] : prevKey.split("-")[0];
      prevKey = key;
      var children2 = <Widget>[
        showYear(datePiece, i++),
        Text(datePiece[1],
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        Text("月", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ];
      var monthTitle = SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: children2,
          ),
        ),
      );
      list.add(monthTitle);

      var daysOfWidget = SliverGrid(
        delegate:
            SliverChildBuilderDelegate((BuildContext buildContext, int index) {
          return createDayWidget(map[key][index]);
        }, childCount: map[key].length),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
      );
      list.add(daysOfWidget);
    }

    return list;
  }

  String prevYear;
  Widget showYear(List<String> date, int i) {
    var nowyear = beautyCalendarCore.getNow().year;
    //如果不是今年开始则要展示年份
    if (i == 0 && prevYear != nowyear.toString()) {
      return Text(date[0].substring(2) + "年");
    } else {
      if (prevYear != date[0]) {
        return Text(date[0].substring(2) + "年");
      }
    }
    return Text("");
  }

  bool isExpireDate = true;
  //创建每一天的控件
  Widget createDayWidget(String item) {
    var itemArr = ["", ""]; //day,农历
    String dateStr = "";
    if (item.isNotEmpty) {
      if (item.contains(",")) {
        //包含农历
        itemArr = item.split(",");
        dateStr = itemArr[0];
      }
      if (item.contains("-")) {
        //显示day
        itemArr[0] = itemArr[0].split("-")[2].padLeft(2, "0");
      }
    }
    final String date = dateStr;
    //当前日期
    if (date == beautyCalendarCore.getCurDate()) {
      isExpireDate = false;
      return createCurDateWidget(itemArr, date);
    } else {
      //过期日期,包含逗号说明数据格式是正确的
      if (isExpireDate && item.contains(',')) {
        return createExpiredDateWidget(itemArr, date);
      } else {
        //两边的日期
        if (item.contains(",")) {
          var datelist = dateStr.split("-");
          var week = beautyCalendarCore.getWeekdayOfMonth(
              int.parse(datelist[0]), int.parse(datelist[1]), int.parse(datelist[2]));
          if (week == 7 || week == 6) {
            return createBothSideDateWidget(itemArr, date);
          }
        }
      }
    }

    return GestureDetector(
      onTap: () {
        //在这编写你的日历选择事件,当选中了某个日历，你想怎么处理就在这里操作
        Navigator.of(context).pop({"date": date});
      },
      child: Container(
          alignment: Alignment.center,
          child: Column(children: <Widget>[
            Expanded(
              child: Text(
                itemArr[0].isNotEmpty ? itemArr[0] : item,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Text(
                itemArr[1],
                style: TextStyle(fontSize: 10),
              ),
            ),
          ])),
    );
  }

//生成今天的日期，主要是今天的日期显示的样式不一样
  Widget createCurDateWidget(List<String> date, final String curSelDate) {
    return GestureDetector(
      onTap: () {
        //在这编写你的日历选择事件,当选中了某个日历，你想怎么处理就在这里操作
        Navigator.of(context).pop({"date": curSelDate});
      },
      child: Container(
          decoration: BoxDecoration(
              color: widget._config.curDateBgColor,
              borderRadius: BorderRadius.circular(8)),
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Text(
                    date[0],
                    style: TextStyle(
                        fontSize: 18,
                        color: widget._config.curDateTextColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    date[1],
                    style: TextStyle(
                        fontSize: 10, color: widget._config.curDateTextColor),
                  ),
                ),
              ])),
    );
  }

  Widget createExpiredDateWidget(List<String> date, final String curSelDate) {
    final Color grayColor = Color(0xffdddddd);

    return Container(
      alignment: Alignment.center,
      child: Column(children: <Widget>[
        Expanded(
          child: Text(
            date[0],
            style: TextStyle(
                fontSize: 18, color: grayColor, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            date[1],
            style: TextStyle(fontSize: 10, color: grayColor),
          ),
        ),
      ]),
    );
  }

  //生成两边的日期的样式，只要是两边显示的日期颜色不一样
  Widget createBothSideDateWidget(List<String> date, final String curSelDate) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop({"date": curSelDate});
      },
      child: Container(
        alignment: Alignment.center,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Expanded(
            child: Text(
              date[0],
              style: TextStyle(
                  fontSize: 18,
                  color: widget._config.bothSideTextColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              date[1],
              style: TextStyle(
                  fontSize: 10, color: widget._config.bothSideTextColor),
            ),
          ),
        ]),
      ),
    );
  }
}
