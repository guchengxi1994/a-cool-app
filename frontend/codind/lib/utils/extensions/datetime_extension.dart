extension SDateTime on DateTime {
  String toDateString(DatetimeSeparator sep, {bool fillZero = true}) {
    int year = this.year;
    int month = this.month;
    int day = this.day;

    if (sep == DatetimeSeparator.chinese) {
      return year.toString() +
          "年" +
          month.toString() +
          "月" +
          day.toString() +
          "日";
    }

    if (sep == DatetimeSeparator.dot) {
      if (fillZero) {
        String _month = month < 10 ? "0" + month.toString() : month.toString();
        String _day = month < 10 ? "0" + day.toString() : day.toString();
        return year.toString() + "." + _month + "." + _day;
      }
      return year.toString() + "." + month.toString() + "." + day.toString();
    }

    if (sep == DatetimeSeparator.slash) {
      if (fillZero) {
        String _month = month < 10 ? "0" + month.toString() : month.toString();
        String _day = month < 10 ? "0" + day.toString() : day.toString();
        return year.toString() + "/" + _month + "/" + _day;
      }
      return year.toString() + "/" + month.toString() + "/" + day.toString();
    }

    return "";
  }
}

enum DatetimeSeparator { chinese, dot, slash }
