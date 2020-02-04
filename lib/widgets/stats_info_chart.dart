import 'package:flutter/cupertino.dart';
import 'package:simple_weight/database/calorie_data.dart';
import 'package:simple_weight/database/weight_data.dart';
import 'package:simple_weight/styles/styles.dart';
import 'package:simple_weight/utils/weight_analysis.dart';
import 'package:simple_weight/utils/calorie_analysis.dart';

class StatsInfoChart extends StatelessWidget{
  CalorieAnalysis calorieInfo;
  WeightAnalysis weightInfo;

  StatsInfoChart({List<WeightData> weightData, List<CalorieData> calorieData}){
    this.calorieInfo = CalorieAnalysis(calorieData);
    this.weightInfo = WeightAnalysis(weightData);
  }

  @override 
  Widget build(BuildContext context){
    final num overallWeightLoss = weightInfo.overallWeightLoss;
    final overallWeightLossText = overallWeightLoss > 0 ? "+" + overallWeightLoss.toStringAsFixed(1) : overallWeightLoss.toStringAsFixed(1);

    return Container(
      padding: EdgeInsets.only(top: 20, left: 6, right: 6, bottom: 100),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CupertinoColors.separator,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          
          // Calorie Stats 
          Padding(
            padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 2),
            child: Text(
              "Calories:", 
              style: TextStyle(decoration: TextDecoration.underline, decorationColor: CupertinoColors.inactiveGray),
            ),
          ),
          // Weekend WeekDay Average 
          Padding(
            padding: EdgeInsets.only(left:8.0, right: 8, top: 8, bottom: 4),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "Average Weekend:   ", style: Styles.descriptor),
                  TextSpan(text: "${calorieInfo.weekendAverage} calories", style: DefaultTextStyle.of(context).style),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:8.0, right: 8, top: 4, bottom: 4),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "Average Weekday:   ", style: Styles.descriptor),
                  TextSpan(text: "${calorieInfo.weekdayAverage} calories", style: DefaultTextStyle.of(context).style),
                ],
              ),
            ),
          ),
          // Min Max
          Padding(
            padding: EdgeInsets.only(left:8.0, right: 8, top: 4, bottom: 4),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "Lowest Calorie Day:    ", style: Styles.descriptor),
                  TextSpan(text: "${calorieInfo.minCalorie.calories}  ${calorieInfo.minCalorie.time}", style: DefaultTextStyle.of(context).style),
                ],
              ),
            ),
          ),
          // Min / Max Time
          Padding(
            padding: EdgeInsets.only(left:8.0, right: 8, top: 4, bottom: 8),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "Highest Calorie Day:   ", style: Styles.descriptor),
                  TextSpan(text: "${calorieInfo.maxCalorie.calories}  ${calorieInfo.maxCalorie.time}", style: DefaultTextStyle.of(context).style),
                ],
              ),
            ),
          ),

          // Weight Stats
          Padding(
            padding: EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 2),
            child: Text(
              "Weight:", 
              style: TextStyle(decoration: TextDecoration.underline, decorationColor: CupertinoColors.inactiveGray),
            ),
          ),
          // Overall Weight Loss,
          Padding(
            padding: EdgeInsets.only(left:8.0, right: 8, top: 8, bottom: 4),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "Overall Weight Loss:   ", style: Styles.descriptor),
                  TextSpan(text: "$overallWeightLossText", style: DefaultTextStyle.of(context).style),
                ],
              ),
            ),
          ),
          // Avg weight
          Padding(
            padding: EdgeInsets.only(left:8.0, right: 8, top: 4, bottom: 4),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "Average Weight:  ", style: Styles.descriptor),
                  TextSpan(text: "${weightInfo.averageWeight.toStringAsFixed(1)}", style: DefaultTextStyle.of(context).style),
                ],
              ),
            ),
          ),
          // Min / Max Weight
          Padding(
            padding: EdgeInsets.only(left:8.0, right: 8, top: 4, bottom: 4),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "Lowest Weight:    ", style: Styles.descriptor),
                  TextSpan(text: "${weightInfo.minWeight.weight}  ${weightInfo.minWeight.time}", style: DefaultTextStyle.of(context).style),
                ],
              ),
            ),
          ),
          // Min / Max dates
          Padding(
            padding: EdgeInsets.only(left:8.0, right: 8, top: 4, bottom: 8),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "Highest Weight:   ", style: Styles.descriptor),
                  TextSpan(text: "${weightInfo.maxWeight.weight}  ${weightInfo.maxWeight.time}", style: DefaultTextStyle.of(context).style),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
