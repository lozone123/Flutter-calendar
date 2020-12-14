import 'dart:ui';

class BeautyCalendarConfig{
   bool isShowLunar=true; //是否显示农历，true显示
   int showMonth=2; //显示多少个月,如果设置为0，而且endDate不为空，那么就显示beginDate到endDate整个范围的日历
   Color curDateBgColor=Color(0xff00CAE2); //今天日期的背景颜色
   Color curDateTextColor=Color(0xffffffff); //今天日期的文字颜色
   Color bothSideTextColor=Color(0xff00CAE2); //两边的文字颜色值
   String beginDate; //从什么日期开始展示,如果没有设置，那么从今天开始的日期显示,格式:xxxx-xx-xx(例：2020-08-09)
   String endDate; //结束日期,格式:xxxx-xx-xx(例：2020-08-09)
   bool isSingleSelect=false; //是否只是单选某个日期，这是默认的选项
   bool isRangSelect=true;//支持范围选择
   bool isClockOff=false;//打卡，isSingleSelect，isRangSelect，isRangSelect只能三选一
}