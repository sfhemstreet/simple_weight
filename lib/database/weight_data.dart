import 'package:simple_weight/utils/time_convert.dart';

/// Weight class for DB
class WeightData {
  // Time is a string in MMM DD, YYYY format (ie Jan 3, 2020)
  String time;
  num weight;
  String dayOfWeek;
  int _hoursSinceEpoch;

  WeightData({num weight, String time, String dayOfWeek, int hoursSinceEpoch}){
    this.weight = weight;

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
      'weight': weight,
      'day_of_week': dayOfWeek,
      'hours_since_epoch': _hoursSinceEpoch,
    };
  }

  factory WeightData.fromMap(Map<String, dynamic> json) => new WeightData(
    time: json["time"],
    weight: json["weight"],
    dayOfWeek: json['day_of_week'],
    hoursSinceEpoch: json['hours_since_epoch'],
  );
}