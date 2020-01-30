import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:simple_weight/models/weight_model.dart';
import 'package:simple_weight/icons/scale_icon.dart';
import 'package:simple_weight/widgets/weight_list.dart';

/// Tab for viewing weight history and inputting weight
class WeightsTab extends StatefulWidget{
  WeightsTab({Key key}):super(key: key); 
  @override 
  _WeightsTabState createState() => _WeightsTabState();
}

class _WeightsTabState extends State<WeightsTab> {
  // Minimum weight input allowed 
  static const int MIN_WEIGHT = 99;
  num _weight = 0;
  
  final TextEditingController _weightController = new TextEditingController();
  final WeightModel _weightModel = new WeightModel();

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

  void _onSubmitWeight(){
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
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text('Weight'),
        ),
        SliverPadding( 
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 100),
          sliver: SliverList( 
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: CupertinoTextField(
                    placeholder: "Enter Weight for Today",
                    autocorrect: false,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.done,
                    controller: _weightController,
                    onChanged: (text) => _onChangeWeight(text), 
                    textAlign: TextAlign.center,
                  ),
                ),
                CupertinoButton.filled(
                  child: Text('Submit Weight') ,
                  onPressed: () => _onSubmitWeight(),
                  padding: EdgeInsets.all(10.0),
                ),
              ], 
            ),
          ),
        ),
        WeightList(),
      ]
    );
  }
}

