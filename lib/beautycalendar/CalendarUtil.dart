class CalendarUtil{
  //比较两个日期的大小，如果date1大于date2就返回true
  static bool compare(DateTime date1, DateTime date2) {
    var duration = date1.difference(date2);
    if (duration.inDays > 0)
      return true;
    else
      return false;
  }
}