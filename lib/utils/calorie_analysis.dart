import 'package:simple_weight/database/calorie_data.dart';
import 'package:simple_weight/utils/time_convert.dart';

class CalorieAnalysis {
  final List<CalorieData> calorieData;
  int _averageCaloricIntake;
  int _weekendAvg;
  int _weekdayAvg;
  CalorieData _minIntake;
  CalorieData _maxIntake;

  CalorieAnalysis(this.calorieData){
    _runAnalysis();
  }

  int get averageIntake => _averageCaloricIntake;

  int get weekendAverage => _weekendAvg;

  int get weekdayAverage => _weekdayAvg;

  CalorieData get minCalorie => _minIntake;

  CalorieData get maxCalorie => _maxIntake;

  /// Average caloric intake, avg weekend / weekday caloric intake, min/max caloric intake
  void _runAnalysis(){

    String today = TimeConvert().getFormattedString(); 

    int totalSum = 0;
    int totalLength = calorieData.length;

    int weekdaySum = 0;
    int weekdayLength = 0;

    int weekendSum = 0;
    int weekendLength = 0;

    CalorieData min = calorieData[0];
    CalorieData max = calorieData[0];

    for(int i = 0; i < calorieData.length; i++){
      final CalorieData c = calorieData[i];
      final String dayOfWeek = c.dayOfWeek;

      // Calc total sum
      totalSum += c.calories;
      // Calc weekday sum
      if(dayOfWeek != "Saturday" && dayOfWeek != "Sunday"){
        weekdaySum += c.calories;
        weekdayLength++;
      }
      // Calc weekend sum
      if(dayOfWeek == "Saturday" || dayOfWeek == "Sunday"){
        weekendSum += c.calories;
        weekendLength++;
      }
      // Calc min
      if(c.calories < min.calories){
        // Min calories could be today, which is incomplete data. 
        if(c.time != today){
          min = c;
        }
      }
      // Calc max
      if(c.calories > max.calories){
        max = c;
      }
    }

    // Do not divide by zero
    _averageCaloricIntake = totalLength > 0 ? totalSum ~/ totalLength : totalSum;
    _weekdayAvg = weekdayLength > 0 ? weekdaySum ~/ weekdayLength : weekdaySum;
    _weekendAvg = weekendLength > 0 ? weekendSum ~/ weekendLength : weekendSum;
    _minIntake = min;
    _maxIntake = max;
  }
}