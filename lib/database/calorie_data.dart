import 'package:simple_weight/utils/time_convert.dart';

/// Calorie class for DB
class CalorieData {
  String time;
  int calories;

  CalorieData({int calories, String time}){
    this.calories = calories;
    this.time = time == null ? new TimeConvert().toFormattedString(new DateTime.now()) : time;
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'calories': calories,
    };
  }

  factory CalorieData.fromMap(Map<String, dynamic> json) => new CalorieData(
    time: json["time"],
    calories: json["calories"]
  );
}