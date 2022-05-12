// ignore_for_file: no_leading_underscores_for_local_identifiers

extension SDateTime on DateTime {
  String toDateString(DatetimeSeparator sep, {bool fillZero = true}) {
    int year = this.year;
    int month = this.month;
    int day = this.day;

    if (sep == DatetimeSeparator.chinese) {
      return "$year年$month月$day日";
    }

    if (sep == DatetimeSeparator.dot) {
      if (fillZero) {
        String _month = month < 10 ? "0$month" : month.toString();
        String _day = month < 10 ? "0$day" : day.toString();
        return "$year.$_month.$_day";
      }
      return "$year.$month.$day";
    }

    if (sep == DatetimeSeparator.slash) {
      if (fillZero) {
        String _month = month < 10 ? "0$month" : month.toString();
        String _day = month < 10 ? "0$day" : day.toString();
        return "$year/$_month/$_day";
      }
      return "$year/$month/$day";
    }

    return "";
  }
}

enum DatetimeSeparator { chinese, dot, slash }
