import 'package:intl/intl.dart';

/// Use this to convert DateTime into String and String into DateTime so everything is the same everywhere.
class TimeConvert {

  bool isStringToday(String stringTime){
    String today = getFormattedString();
    if(today == stringTime){
      return true;
    }
    else{
      return false;
    }
  }

  String getFormattedString(){
    final DateTime now = DateTime.now();
    final String stringTime = dateTimeToFormattedString(now);
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
    // The keeper of truth, this DateFormat is king 
    final String stringTime = DateFormat.yMMMd('en_US').format(time);
    return stringTime;
  }

  int stringToHoursSinceEpoch(String timeString){
    final DateTime dateTime = stringToDateTime(timeString);
    final int hoursSinceEpoch = dateTime.millisecondsSinceEpoch ~/ 1000 ~/ 60 ~/ 60;
    return hoursSinceEpoch;
  }

  String getWeekdayFromFormattedString(String time){
    DateTime dateTime = stringToDateTime(time);
    int dayOfWeek = dateTime.weekday;

    switch(dayOfWeek){
      case 1:
        return "Monday";
      case 2: 
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5: 
        return "Friday";
      case 6:
        return "Saturday";
      case 7: 
        return "Sunday";
      default:
        return "";
    }
  }

  /// Converts the string format used in this app into DateTime 
  DateTime stringToDateTime(String time){
    // Month is index 0 to the first blank space
    final String month = time.substring(0, time.indexOf(' '));
    // Day is index of first blank space + 1 to the index of the ','
    final day = int.tryParse(time.substring(time.indexOf(' '),time.indexOf(','))) ?? 1;
    // Year is index of ',' + 2 to the end of the string
    final year = int.tryParse(time.substring((time.indexOf(',') + 2))) ?? 2020;

    // print(month);
    // print(day.toString());
    // print(year.toString());

    switch(month){
      case 'Jan':
        return DateTime(year, 1, day);
      case 'Feb':
        return DateTime(year, 2, day);
      case 'Mar':
        return DateTime(year, 3, day);
      case 'Apr':
        return DateTime(year, 4, day);
      case 'May':
        return DateTime(year, 5, day);
      case 'Jun':
        return DateTime(year, 6, day);
      case 'Jul':
        return DateTime(year, 7, day);
      case 'Aug':
        return DateTime(year, 8, day);
      case 'Sep': 
        return DateTime(year, 9, day);
      case 'Oct': 
        return DateTime(year, 10, day);
      case 'Nov':
        return DateTime(year, 11, day); 
      case 'Dec':
        return DateTime(year, 12, day);  
      default: 
        return DateTime(year, 1, day); 
    }
  }
}