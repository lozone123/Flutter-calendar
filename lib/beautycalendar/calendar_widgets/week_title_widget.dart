import 'package:flutter/material.dart';

class WeekTitleWidget extends StatelessWidget {
  //显示星期几,这里是顶部显示星期几的布局，这里你可以随便定义修改
  final String weekTitle;

  const WeekTitleWidget(this.weekTitle,{Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Text(
          weekTitle,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );;
  }
}
