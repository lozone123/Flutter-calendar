import 'package:flutter/material.dart';

import '../calendar_state.dart';

class CalendarFloatActionButton extends StatefulWidget {
  const CalendarFloatActionButton({Key key}) : super(key: key);

  @override
  CalendarFloatActionButtonState createState() =>
      CalendarFloatActionButtonState();
}

class CalendarFloatActionButtonState extends State<CalendarFloatActionButton> {
  var txt = "共10晚";

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: RawMaterialButton(
        constraints:const BoxConstraints(maxWidth:double.infinity, minHeight: 36.0),
        fillColor: Colors.deepOrange,
        splashColor: Colors.orange,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("确定", style: TextStyle(color: Colors.white,fontSize: 18)),
              SizedBox(
                width: 8.0,
              ),
              PulseAnimator(
                //动画效果
                child: Text(
                  txt,
                  style: TextStyle(color: Colors.white,fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop({"beginDate":CalendarState.beginDate,"endDate":CalendarState.endDate});
        },
        //点击事件
        shape: const StadiumBorder(), //添加圆角
      ),
    );
  }

  void updateText(String str) {
    if(txt==str)return;
    setState(() {
      txt = str;
    });
  }
}

class PulseAnimator extends StatefulWidget {
  final Widget child;

  const PulseAnimator({Key key, this.child}) : super(key: key);

  @override
  _PulseAnimatorState createState() => _PulseAnimatorState();
}

class _PulseAnimatorState extends State<PulseAnimator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.5, end: 1.0).animate(_controller),
      child: widget.child,
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
}
