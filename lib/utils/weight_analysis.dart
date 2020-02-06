import 'package:simple_weight/database/weight_data.dart';
import 'package:simple_weight/utils/time_convert.dart';

class WeightAnalysis {
  num _averageWeight;
  num _overallWeightLoss;
  num _averageWeightLossPerWeek;
  WeightData _minWeight;
  WeightData _maxWeight;

  WeightAnalysis(List<WeightData> weightData){
    runAnalysis(weightData);
  }

  num get averageWeightLossPerWeek => _averageWeightLossPerWeek;

  num get averageWeight => _averageWeight;

  num get overallWeightLoss => _overallWeightLoss;

  WeightData get minWeight => _minWeight;

  WeightData get maxWeight => _maxWeight;
  
  
  runAnalysis(List<WeightData> weightData){

    // Weekly Average Weight Loss Vars
    DateTime startWeek = TimeConvert().stringToDateTime(weightData[0].time);
    num startWeight = weightData[0].weight;
    num numOfWeeks = 0;
    num runningSum = 0;

    // Overall Average and Min Max Vars
    num totalSum = 0;
    WeightData min = weightData[0];
    WeightData max = weightData[0];

    for(int i = 0; i < weightData.length; i++){
      WeightData w = weightData[i];

      // Overall Average and Min Max Calc
      totalSum += w.weight;
      //Find min
      if(w.weight < min.weight){
        min = w;
      }
      //Find max
      if(w.weight > max.weight){
        max = w;
      }


      // Weekly Average Weight Loss Calc
      DateTime day = TimeConvert().stringToDateTime(weightData[i].time);

      Duration difference = day.difference(startWeek);

      if(difference.inDays >= 7){
        numOfWeeks++;
        runningSum = runningSum + (weightData[i].weight - startWeight);
        startWeight = weightData[i].weight;
      }
    }

    // DO NOT DIVIDE BY ZERO

    // Weekly Average Weight Loss 
    _averageWeightLossPerWeek = numOfWeeks > 0 ? runningSum / numOfWeeks : runningSum;
    

    // Average Weight and Min Max
    _averageWeight =  weightData.length > 0 ? totalSum / weightData.length: totalSum;
    _minWeight = min;
    _maxWeight = max;


    // Overall Weight Loss 
    final num start = weightData[0].weight;
    final num end = weightData.length > 0 ? weightData[weightData.length - 1].weight : weightData[0].weight;
    _overallWeightLoss = end - start;
  }
}