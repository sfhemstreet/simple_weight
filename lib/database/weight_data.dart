import 'package:simple_weight/utils/time_convert.dart';

/// Weight class for DB
class WeightData {
  String time;
  num weight;
  int _hoursSinceEpoch;

  WeightData({num weight, String time}){
    this.weight = weight;
    this.time = time == null ? TimeConvert().getFormattedString() : time;
    this._hoursSinceEpoch = time == null ? TimeConvert().getHoursSinceEpoch() : TimeConvert().stringToHoursSinceEpoch(time);
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'weight': weight,
      'hours_since_epoch': _hoursSinceEpoch
    };
  }

  factory WeightData.fromMap(Map<String, dynamic> json) => new WeightData(
    time: json["time"],
    weight: json["weight"]
  );
}