import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:simple_weight/models/weight_model.dart';
import 'package:simple_weight/icons/scale_icon.dart';
import 'package:simple_weight/styles/styles.dart';
import 'package:simple_weight/settings/settings_page.dart';
import 'package:simple_weight/utils/constants.dart';
import 'package:simple_weight/widgets/view_average_weight_lost_per_week.dart';
import 'package:simple_weight/widgets/view_total_weight_loss.dart';
import 'package:simple_weight/widgets/weight_list.dart';

/// Tab for viewing weight history and inputting weight
class WeightsTab extends StatefulWidget{
  @override 
  _WeightsTabState createState() => _WeightsTabState();
}

class _WeightsTabState extends State<WeightsTab> {
  
  num _weight = 0;
  
  final TextEditingController _weightController = new TextEditingController();
  final WeightModel _weightModel = new WeightModel();

  void _onChangeWeight(String text){
    // Input will always be text, parse to num if possible
    num weightInput = num.tryParse(text) ?? 0;

    if(weightInput >= Constants.MIN_WEIGHT && weightInput <= Constants.MAX_WEIGHT){
      setState(() {
        _weight = weightInput;
      });
    }
    else{
      setState(() {
        _weight = 0;
      });
    }
  }

  void _onSubmitWeight(){
    if(_weight >= Constants.MIN_WEIGHT && _weight <= Constants.MAX_WEIGHT){
      // Make sure _weight has only one decimal space (ie 165.3) 
      final num parsedWeight = num.parse(_weight.toStringAsFixed(1));
      // Add weight to model so entire app knows the new weight
      _weightModel.addTodaysWeight(parsedWeight);
      _weightController.clear();
      
      setState(() {
        _weight = 0;
      });
    }
  }

  void _pushSettings(BuildContext context){
    Navigator.push(context, CupertinoPageRoute(
      builder: (context) => SettingsPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {

    // Configure gradient settings for Dark and Light Modes
    final Brightness brightness = MediaQuery.platformBrightnessOf(context);

    final List<Color> gradient = brightness == Brightness.dark ? Styles.darkGradient : Styles.lightGradient;

    final Color containerColor = brightness == Brightness.dark ? Color.fromRGBO(0, 0, 0, 0.7) : Color.fromRGBO(255, 255, 255, 0.7);

    return Container(
      decoration: BoxDecoration(  
        gradient: LinearGradient(colors: gradient),
      ),
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text('Weight'),
            trailing: CupertinoButton(
              onPressed: () => _pushSettings(context),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              minSize: 20,
              child: Icon(CupertinoIcons.settings),
            ),
            heroTag: "Weights Tab",
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
                Container(
                  color: containerColor,
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  child: Column(  
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Overall Weight Loss:", style: TextStyle(color: CupertinoColors.inactiveGray, fontSize: 12)),
                          ViewTotalWeightLoss(),
                        ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Avg Loss Per Week:", style: TextStyle(color: CupertinoColors.inactiveGray, fontSize: 12)),
                          ViewAverageWeeklyWeightLoss(),
                        ]
                      ),
                    ],
                  ),
                ),
                Container(
                  color: containerColor, 
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
                        child: Text('Submit Weight', style: Styles.buttonTextStyle), 
                        onPressed: () => _onSubmitWeight(),
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 36),
                        minSize: 25,
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
      ),
    );
  }
}

