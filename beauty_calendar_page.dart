import 'package:apartment_manage/calendar/beauty_calendar_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class BeautyCalendarPage extends StatefulWidget {
  @override
  _BeautyCalendarPageState createState() => _BeautyCalendarPageState();
}

class _BeautyCalendarPageState extends State<BeautyCalendarPage> {

  var beautyCalendarCore = BeautyCalendarCore.getInstance(5,false);

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
        padding: EdgeInsets.fromLTRB(3,10,5,10),
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
    print(beautyCalendarCore.getHeaders());
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
    Map<String,List<String>> map=beautyCalendarCore.createCalendarData();
    var keys=map.keys;
    var list=List<Widget>();
    for (var key in keys) {
      var list2=map[key].map((item) => getItemContainer(item)).toList();
      list.addAll(list2);
    }
    return list;
  }

  Widget getItemContainer(String item) {
    var itemArr=["",""];
    String dateStr="";
    if(item.isNotEmpty){
      if(item.contains(",")){
        itemArr=item.split(",");
        dateStr=itemArr[0];
      }
      if(item.contains("-")){
        itemArr[0]=itemArr[0].split("-")[2].padLeft(2,"0");//day
      }
    }

    final String date=dateStr;
    if(date==beautyCalendarCore.getCurDate()){
      return getCurDate(itemArr,date);
    }
    return GestureDetector(
          onTap: (){
            //在这编写你的日历选择事件,当选中了某个日历，你想怎么处理就在这里操作
            print(date);
          },
          child: Container(
          alignment: Alignment.center,
          child: Column(children: <Widget>[
            Expanded(
              child: Text(
                itemArr[0].isNotEmpty?itemArr[0]:item,
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
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

  Widget getCurDate(List<String> date,final String curDate){
   return GestureDetector(
          onTap: (){
            //在这编写你的日历选择事件,当选中了某个日历，你想怎么处理就在这里操作
            print(curDate);
          },
          child: Container(
          decoration: BoxDecoration(color: Color.fromARGB(-37, 0, 202, 226),borderRadius:BorderRadius.circular(8)),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
            Expanded(
              child: Text(
                date[0],
                style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Text(
                date[1],
                style: TextStyle(fontSize: 10,color: Colors.white),
              ),
            ),
          ])),
    );
  }
}
