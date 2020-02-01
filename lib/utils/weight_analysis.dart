import 'package:simple_weight/database/weight_data.dart';

class WeightAnalysis {
  num _averageWeight;
  num _overallWeightLoss;
  WeightData _minWeight;
  WeightData _maxWeight;

  WeightAnalysis(List<WeightData> weightData){
    runAnalysis(weightData);
  }

  num get averageWeight => _averageWeight;

  num get overallWeightLoss => _overallWeightLoss;

  WeightData get minWeight => _minWeight;

  WeightData get maxWeight => _maxWeight;
  
  runAnalysis(List<WeightData> weightData){
    num sum = 0;
    WeightData min = weightData[0];
    WeightData max = weightData[0];

    for(int i = 0; i < weightData.length; i++){
      WeightData w = weightData[i];
      // Calc sum
      sum += w.weight;
      //Find min
      if(w.weight < min.weight){
        min = w;
      }
      //Find max
      if(w.weight > max.weight){
        max = w;
      }
    }

    _averageWeight = sum / weightData.length;
    _minWeight = min;
    _maxWeight = max;

    final num start = weightData[0].weight;
    final num end = weightData[weightData.length - 1].weight;
     
    _overallWeightLoss = end - start;
  }
}