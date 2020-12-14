import 'package:flutter/material.dart';

class MonthWidget extends StatelessWidget {
  final int month;

  const MonthWidget(this.month,{Key key, }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(month.toString(),
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      Text("月", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
    ],);
  }
}
