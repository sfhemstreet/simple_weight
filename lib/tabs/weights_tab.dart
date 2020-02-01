import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:simple_weight/models/weight_model.dart';
import 'package:simple_weight/icons/scale_icon.dart';
import 'package:simple_weight/widgets/edit_weight_history.dart';
import 'package:simple_weight/widgets/view_total_weight_loss.dart';
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
      // Add weight to model so entire app knows the new weight
      _weightModel.addTodaysWeight(newWeight);
      _weightController.clear();
      
      setState(() {
        _weight = 0;
      });
    }
  }

  void _pushEditPastWeights(BuildContext context){
    Navigator.push(context, CupertinoPageRoute(
      builder: (context) => EditWeightHistory(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text('Weight'),
        ),

        // Grid has 2 columns, 2 rows.
        // Left column displays Overall weight Loss and edit history button
        // Right column has the enter weight text field and enter weight button 
        SliverGrid( 
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0.0,
            crossAxisSpacing: 0.0, 
            childAspectRatio: 1.8,
          ),
          delegate: SliverChildListDelegate(
            [
              Padding( 
                padding: EdgeInsets.only(top: 14, bottom: 0, left: 10, right: 10),
                child: Column(  
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Overall Weight Loss:", style: TextStyle(color: CupertinoColors.inactiveGray, fontSize: 12)),
                        ViewTotalWeightLoss(),
                      ]
                    ),
                    // Button pushes Navi to EditWeightHistory 
                    CupertinoButton(
                      onPressed: () => _pushEditPastWeights(context),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      minSize: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget> [
                          Text("Edit Past Weights", style: TextStyle(fontSize: 12),),
                          Icon(CupertinoIcons.gear),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding( 
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: CupertinoTextField(
                        prefix: Padding( 
                          padding: EdgeInsets.all(4),
                          child: Icon(ScaleIcon.weight, color: CupertinoColors.inactiveGray,),
                        ),
                        placeholder: "Enter Weight",
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
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                      minSize: 20,
                    ),  
                  ],
                ),
              ),
            ],
          ),
        ),

        // Displays all weights below in a list
        WeightList(),
      ]
    );
  }
}

