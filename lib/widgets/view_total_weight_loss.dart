import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/database/weight_data.dart';

/// Displays total weight loss or gain in Text widget, gives color (and '+') accordingly.
class ViewTotalWeightLoss extends StatelessWidget {

  @override 
  Widget build(BuildContext context){
    final List<WeightData> weights = Provider.of<List<WeightData>>(context);

    if(weights == null || weights.length < 2){
      return Text('0');
    }

    final num start = weights[0].weight;
    final num end = weights[weights.length - 1].weight;
    final num loss = end - start;

    final String lossText = loss == 0 ? loss.toStringAsFixed(0) : loss.toStringAsFixed(1);
    
    final String text = loss > 0 ? "+" + lossText : lossText;
    final Color color = loss <= 0 ? CupertinoColors.activeBlue : CupertinoColors.destructiveRed;

    return Text(text, style: TextStyle(color: color));
  }
}
