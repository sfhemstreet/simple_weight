import 'package:intl/intl.dart';

/// Use this to convert DateTime into String and String into DateTime so everything is the same everywhere.
class TimeConvert {

  String getFormattedString(){
    final String stringTime = DateFormat.yMMMMd('en_US').format(DateTime.now());
    return stringTime;
  }

  // Use this to store the day in the DB
  int getHoursSinceEpoch(){
    final daysSinceEpoch = DateTime.now().millisecondsSinceEpoch ~/ 1000 ~/ 60 ~/ 60;
    return daysSinceEpoch;
  }

  // Use this to convert DB stored time into String
  String hoursSinceEpochToString(int hoursSinceEpoch){
    final dateTime = DateTime.fromMillisecondsSinceEpoch(hoursSinceEpoch * 1000 * 60 * 60);
    final stringTime = dateTimeToFormattedString(dateTime);
    return stringTime;
  }

  /// Converts DateTime to the string format used in this app
  String dateTimeToFormattedString(DateTime time){
    final String stringTime = DateFormat.yMMMMd('en_US').format(time);
    return stringTime;
  }

  int stringToHoursSinceEpoch(String timeString){
    final DateTime dateTime = stringToDateTime(timeString);
    final int hoursSinceEpoch = dateTime.millisecondsSinceEpoch ~/ 1000 ~/ 60 ~/ 60;
    return hoursSinceEpoch;
  }

  /// Converts the string format used in this app into DateTime 
  DateTime stringToDateTime(String time){
    // Month is index 0 to the first blank space
    final String month = time.substring(0, time.indexOf(' '));
    // Day is index of first blank space + 1 to the index of the ','
    final day = int.tryParse(time.substring(time.indexOf(' '),time.indexOf(','))) ?? 1;
    // Year is index of ',' + 2 to the end of the string
    final year = int.tryParse(time.substring((time.indexOf(',') + 2))) ?? 2020;

    //debugPrint(month);
    //debugPrint(day.toString());
    //debugPrint(year.toString());

    switch(month){
      case 'January':
        return DateTime(year, 1, day);
      case 'February':
        return DateTime(year, 2, day);
      case 'March':
        return DateTime(year, 3, day);
      case 'April':
        return DateTime(year, 4, day);
      case 'May':
        return DateTime(year, 5, day);
      case 'June':
        return DateTime(year, 6, day);
      case 'July':
        return DateTime(year, 7, day);
      case 'August':
        return DateTime(year, 8, day);
      case 'September': 
        return DateTime(year, 9, day);
      case 'October': 
        return DateTime(year, 10, day);
      case 'November':
        return DateTime(year, 11, day); 
      case 'December':
        return DateTime(year, 12, day);  
      default: 
        return DateTime(year, 1, day); 
    }
  }
}