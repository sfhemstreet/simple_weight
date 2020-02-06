import 'package:simple_weight/utils/time_convert.dart';

/// Calorie class for DB
class CalorieData {
  String time;
  int calories;
  String dayOfWeek;
  int _hoursSinceEpoch;

  CalorieData({int calories, String time,  String dayOfWeek, int hoursSinceEpoch}){
    this.calories = calories;

    this.time = time == null ? TimeConvert().getFormattedString() : time;

    this._hoursSinceEpoch = hoursSinceEpoch == null ? 
      (time == null ? TimeConvert().getHoursSinceEpoch() : TimeConvert().stringToHoursSinceEpoch(time))
      : hoursSinceEpoch;

    this.dayOfWeek = dayOfWeek == null ? 
      (time == null ? TimeConvert().getWeekDay() : TimeConvert().getWeekdayFromFormattedString(time))
      : dayOfWeek;
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'calories': calories,
      'day_of_week': dayOfWeek,
      'hours_since_epoch': _hoursSinceEpoch,
    };
  }

  factory CalorieData.fromMap(Map<String, dynamic> json) => new CalorieData(
    time: json["time"],
    calories: json["calories"],
    dayOfWeek: json['day_of_week'],
    hoursSinceEpoch: json['hours_since_epoch'],
  );
}