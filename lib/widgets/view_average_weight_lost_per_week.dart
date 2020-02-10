import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/database/weight_data.dart';
import 'package:simple_weight/utils/time_convert.dart';

/// Displays average weekly weight loss or gain in Text widget, gives color (and '+') accordingly.
class ViewAverageWeeklyWeightLoss extends StatelessWidget {

  @override 
  Widget build(BuildContext context){
    final List<WeightData> weights = Provider.of<List<WeightData>>(context);

    if(weights == null || weights.length < 2){
      return Text('0');
    }

    DateTime startWeek = TimeConvert().stringToDateTime(weights[0].time);
    num startWeight = weights[0].weight;
    num numOfWeeks = 0;
    num runningSum = 0;

    for(int i = 0; i < weights.length; i++){
      DateTime day = TimeConvert().stringToDateTime(weights[i].time);

      Duration difference = day.difference(startWeek);

      if(difference.inDays >= 7){
        numOfWeeks++;
        runningSum = runningSum + (weights[i].weight - startWeight);
        startWeight = weights[i].weight;

        //print(runningSum);
      }
    }

    if(numOfWeeks == 0){
      return Text("0", style: TextStyle(color: CupertinoColors.activeBlue));
    }

    final num avgLoss = runningSum / numOfWeeks;
    final String avgLossText = avgLoss == 0 ? avgLoss.toString() : avgLoss.toStringAsFixed(1);
    
    final String text = avgLoss > 0 ? "+" + avgLossText : avgLossText;
    final Color color = avgLoss <= 0 ? CupertinoColors.activeBlue : CupertinoColors.destructiveRed;

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 250),
      child: Text(text, style: TextStyle(color: color), key: ValueKey(avgLoss)),
    );
  }
}