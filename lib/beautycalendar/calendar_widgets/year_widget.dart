import 'package:flutter/material.dart';

class YearWidget extends StatelessWidget {
  final String year;

  const YearWidget(this.year,{Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(year.toString() + "年");
  }
}
