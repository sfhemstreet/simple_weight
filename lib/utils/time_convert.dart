import 'package:intl/intl.dart';

/// Use this to convert DateTime into String and String into DateTime so everything is the same everywhere.
class TimeConvert {

  /// Converts DateTime to the string format used in this app
  String toFormattedString(DateTime time){
    final String stringTime = new DateFormat.yMMMMd('en_US').format(time);
    return stringTime;
  }

  /// Converts the string format used in this app to DateTime 
  DateTime toDateTime(String time){
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
        return new DateTime(year, 1, day);
      case 'February':
        return new DateTime(year, 2, day);
      case 'March':
        return new DateTime(year, 3, day);
      case 'April':
        return new DateTime(year, 4, day);
      case 'May':
        return new DateTime(year, 5, day);
      case 'June':
        return new DateTime(year, 6, day);
      case 'July':
        return new DateTime(year, 7, day);
      case 'August':
        return new DateTime(year, 8, day);
      case 'September': 
        return new DateTime(year, 9, day);
      case 'October': 
        return new DateTime(year, 10, day);
      case 'November':
        return new DateTime(year, 11, day); 
      case 'December':
        return new DateTime(year, 12, day);  
      default: 
        return new DateTime(year, 1, day); 
    }
  }
}