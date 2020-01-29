import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/models/weight_model.dart';

/// Tab for viewing weight history and inputting weight
class WeightsTab extends StatefulWidget{
  @override 
  _WeightsTabState createState() => _WeightsTabState();
}

class _WeightsTabState extends State<WeightsTab> {
  // Minimum weight input allowed 
  static const int MIN_WEIGHT = 99;
  num _weight = 0;
  
  TextEditingController _weightController = new TextEditingController();
  WeightModel _weightModel = new WeightModel();

  void _onChangeWeight(String text){
    // Input will always be text, parse to num if possible
    num newWeight = num.tryParse(text) ?? 0;

    if(newWeight > MIN_WEIGHT){
      setState(() {
        _weight = newWeight;
      });
    }
    else{
      setState(() {
        _weight = 0;
      });
    }
  }

  void _onSubmitWeight(BuildContext context){
    if(_weight > MIN_WEIGHT){
      // Make sure _weight has only one decimal space (ie 165.3) 
      final num newWeight = num.parse(_weight.toStringAsFixed(1));
      // Add weight to model so entire app knows the enw weight
      _weightModel.addWeight(newWeight);
      // clear the input area 
      _weightController.clear();
      // makes submit button go away
      setState(() {
        _weight = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
  
    return CustomScrollView(
      slivers: const <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text('Weight'),
        ),
      ],
    ); 
  }
}