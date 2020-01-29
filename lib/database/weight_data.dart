import 'package:simple_weight/utils/time_convert.dart';

/// Weight class for DB
class WeightData {
  String time;
  num weight;

  WeightData({num weight, String time}){
    this.weight = weight;
    this.time = time == null ? new TimeConvert().toFormattedString(new DateTime.now()) : time;
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'weight': weight,
    };
  }

  factory WeightData.fromMap(Map<String, dynamic> json) => new WeightData(
    time: json["time"],
    weight: json["weight"]
  );
}