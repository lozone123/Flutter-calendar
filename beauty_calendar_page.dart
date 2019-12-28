import 'package:apartment_manage/calendar/beauty_calendar_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class BeautyCalendarPage extends StatefulWidget {
  final bool isShowLunar; //是否显示农历，true显示
  final int showMonth; //显示多少个月
  final Color curDateBgColor; //今天日期的背景颜色
  final Color curDateTextColor; //今天日期的文字颜色
  final Color bothSideTextColor; //两边的文字颜色值

  BeautyCalendarPage(this.isShowLunar, this.showMonth,
      this.curDateBgColor, this.curDateTextColor, this.bothSideTextColor);

  @override
  _BeautyCalendarPageState createState() => _BeautyCalendarPageState();
}

class _BeautyCalendarPageState extends State<BeautyCalendarPage> {

  BeautyCalendarCore beautyCalendarCore;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    beautyCalendarCore=BeautyCalendarCore.getInstance(widget.showMonth,widget.isShowLunar);
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
            children: getHeader()),
      ),
      Expanded(
        child: GridView.count(
          //水平子Widget之间间距
          crossAxisSpacing: 6.0,
          //垂直子Widget之间间距
          mainAxisSpacing: 30.0,
          //GridView内边距
          padding: EdgeInsets.all(10.0),
          //一行的Widget数量
          crossAxisCount: 7,
          //子Widget宽高比例
          childAspectRatio: 0.8,
          //子Widget列表
          children: getWidgets(),
        ),
      )
    ]));
  }

//头部
  List<Widget> getHeader() {
    return beautyCalendarCore
        .getHeaders()
        .map((item) => getHeaderWidget(item))
        .toList();
  }

  Widget getHeaderWidget(String item) {
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

//日历内容
  List<Widget> getWidgets() {
    Map<String, List<String>> map = beautyCalendarCore.createCalendarData();
    var keys = map.keys;
    var list = List<Widget>();
    for (var key in keys) {
      var list2 = map[key].map((item) => getItemContainer(item)).toList();
      list.addAll(list2);
    }
    return list;
  }

  bool isExpireDate = true;
  int index = -1;

  Widget getItemContainer(String item) {
    var itemArr = ["", ""];
    String dateStr = "";
    if (item.isNotEmpty) {
      if (item.contains(",")) {
        itemArr = item.split(",");
        dateStr = itemArr[0];
      }
      if (item.contains("-")) {
        itemArr[0] = itemArr[0].split("-")[2].padLeft(2, "0"); //day
      }
    }
    index++;
    final String date = dateStr;
    if (date == beautyCalendarCore.getCurDate()) {
      isExpireDate = false;
      return getCurDateWidget(itemArr, date);
    } else {
      if (isExpireDate && item.contains(',')) {
        return getExpiredDateWidget(itemArr, date);
      } else {
        if ((index % 7 == 0 || index % 7== 6) && item.contains(",")) {
          return getBothSideDateWidget(itemArr, date);
        }
      }
    }

    return GestureDetector(
      onTap: () {
        //在这编写你的日历选择事件,当选中了某个日历，你想怎么处理就在这里操作
        //print(date);
        Navigator.of(context).pop({"date":date});
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

  Widget getCurDateWidget(List<String> date, final String curSelDate) {
    return GestureDetector(
      onTap: () {
        //在这编写你的日历选择事件,当选中了某个日历，你想怎么处理就在这里操作
        //print(curSelDate);
         Navigator.of(context).pop({"date":curSelDate});
      },
      child: Container(
          decoration: BoxDecoration(
              color: widget.curDateBgColor,
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
                        color: widget.curDateTextColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    date[1],
                    style:
                        TextStyle(fontSize: 10, color: widget.curDateTextColor),
                  ),
                ),
              ])),
    );
  }

  Widget getExpiredDateWidget(List<String> date, final String curSelDate) {
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

  Widget getBothSideDateWidget(List<String> date, final String curSelDate) {
    return GestureDetector(
      onTap: () {
        //print(curSelDate);
         Navigator.of(context).pop({"date":curSelDate});
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
                  color: widget.bothSideTextColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              date[1],
              style: TextStyle(fontSize: 10, color: widget.bothSideTextColor),
            ),
          ),
        ]),
      ),
    );
  }
}
