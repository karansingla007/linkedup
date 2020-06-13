import 'package:date_format/date_format.dart';

class TimeUtil {
  ///Example format 26-Dec-2019 10:30 AM
  static String getDateAndTime(int epochInMilliSeconds) {
    return getDate(epochInMilliSeconds) +
        " " +
        getTimeIn12HourFormat(epochInMilliSeconds);
  }

  static String getDateAndTimeByDate(String date) {
    int epochInMilliSeconds = DateTime.parse(date).millisecondsSinceEpoch;
    return getDate(epochInMilliSeconds) +
        " " +
        getTimeIn12HourFormat(epochInMilliSeconds);
  }

  static int convertDateToTimeStamp(String date) {
    return DateTime.parse(date).millisecondsSinceEpoch;
  }

  static DateTime convertTimeStampToDate(int date) {
    return DateTime.fromMillisecondsSinceEpoch(date);
  }

  static int getCurrentEpochTimeStamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  ///Example format 26-Dec-2019
  static String getDate(int epochInMilliSeconds) {
    if (epochInMilliSeconds == null) {
      return '';
    }
    DateTime date =
        new DateTime.fromMillisecondsSinceEpoch(epochInMilliSeconds);
    return formatDate(date, [d, '-', M, '-', yyyy]);
  }

  static String getTimeIn12HourFormat(int epochInMilliSeconds) {
    if (epochInMilliSeconds == null) {
      return '';
    }
    DateTime date =
        new DateTime.fromMillisecondsSinceEpoch(epochInMilliSeconds);
    return formatDate(date, [hh, ':', nn, ' ', am]);
  }

  ///15:30
  static String getTimeIn24HourFormat(String date) {
    int epochInMilliSeconds = DateTime.parse(date).millisecondsSinceEpoch;

    if (epochInMilliSeconds == null) {
      return '';
    }
    DateTime dateTime =
        new DateTime.fromMillisecondsSinceEpoch(epochInMilliSeconds);
    String result = formatDate(dateTime, [
      HH,
      ':',
      nn,
    ]);
    return result;
  }
}
