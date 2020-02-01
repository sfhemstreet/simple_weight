import 'package:simple_weight/utils/time_convert.dart';

/// Calorie class for DB
class CalorieData {
  String time;
  int calories;
  int _hoursSinceEpoch;

  CalorieData({int calories, String time}){
    this.calories = calories;
    this.time = time == null ? new TimeConvert().getFormattedString() : time;
    this._hoursSinceEpoch = time == null ? TimeConvert().getHoursSinceEpoch() : TimeConvert().stringToHoursSinceEpoch(time);
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'calories': calories,
      'hours_since_epoch': _hoursSinceEpoch
    };
  }

  factory CalorieData.fromMap(Map<String, dynamic> json) => new CalorieData(
    time: json["time"],
    calories: json["calories"]
  );
}