import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/database/weight_data.dart';
import 'package:simple_weight/utils/time_convert.dart';

/// Displays total weight loss or gain in Text widget, gives color (and '+') accordingly.
class ViewTotalWeightLoss extends StatelessWidget {

  @override 
  Widget build(BuildContext context){
    final List<WeightData> weights = Provider.of<List<WeightData>>(context);

    if(weights == null || weights.length < 2){
      return Text('');
    }

    final num start = weights[0].weight;
    final num end = weights[weights.length - 1].weight;
    final loss = end - start;
    
    final String text = loss > 0 ? "+" + loss.toStringAsFixed(1) : loss.toStringAsFixed(1);
    final Color color = loss <= 0 ? CupertinoColors.activeBlue : CupertinoColors.destructiveRed;

    return Text(text, style: TextStyle(color: color));
  }
}
/*
/// Displays total weight loss or gain in Text widget, gives color (and '+') accordingly.
class ViewLastWeekWeightLoss extends StatelessWidget {

  @override 
  Widget build(BuildContext context){
    final List<WeightData> weights = Provider.of<List<WeightData>>(context);

    if(weights == null || weights.length < 2){
      return Text('');
    }

    final DateTime today = DateTime.now();

    for(WeightData w in weights){
      final DateTime pastDay = TimeConvert().stringToDateTime(w.time);

    }
    
    final String text = loss > 0 ? "+" + loss.toStringAsFixed(1) : loss.toStringAsFixed(1);
    final Color color = loss <= 0 ? CupertinoColors.activeBlue : CupertinoColors.destructiveRed;

    return Text(text, style: TextStyle(color: color));
  }
}
*/