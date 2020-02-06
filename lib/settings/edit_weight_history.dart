import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/database/weight_data.dart';
import 'package:simple_weight/models/weight_model.dart';
import 'package:simple_weight/styles/styles.dart';
import 'package:simple_weight/utils/constants.dart';
import 'package:simple_weight/utils/time_convert.dart';
import 'package:simple_weight/icons/scale_icon.dart';

class EditWeightHistory extends StatefulWidget{
  @override 
  _EditWeightHistoryState createState() => _EditWeightHistoryState();
}

class _EditWeightHistoryState extends State<EditWeightHistory> {

  final WeightModel _weightModel = WeightModel();

  WeightData _selectedDateData;
  bool _hasPrevWeight = false;
  num _weightInput;

  void _onEditWeight(String text){
    // Input will always be text, parse to num if possible
    num weightInput = num.tryParse(text) ?? 0;

    if(weightInput >= Constants.MIN_WEIGHT && weightInput <= Constants.MAX_WEIGHT){
      setState(() {
        _weightInput = weightInput;
      });
    }
  }

  void _onSubmitWeight(BuildContext context) async {
    if(_weightInput != null && _weightInput >= Constants.MIN_WEIGHT && _weightInput <= Constants.MAX_WEIGHT){

      // Display popup alert if new weight is overriding prevWeight.
      if(_hasPrevWeight){
        bool willOverride = await showCupertinoDialog<bool>(
          context: context,
          builder: (BuildContext context){
            return CupertinoAlertDialog(
              title: Text("${_selectedDateData.time} has a previously recorded weight, ${_selectedDateData.weight}.\n"),
              content: Text("Are you sure you want to change this?"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                CupertinoDialogAction(
                  child: Text("Yes"),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          }
        );

        if(!willOverride){
          return;
        }
      }

      // Make sure weight has only one decimal space (ie 165.3) 
      _selectedDateData.weight = num.parse(_weightInput.toStringAsFixed(1));
      // Add weight to model so entire app knows the enw weight
      _weightModel.insertWeight(_selectedDateData);
      
      // makes submit button go away
      setState(() {
        _selectedDateData = null;
        _weightInput = null;
      });
    }
  }
  
  @override 
  Widget build(BuildContext context){

    final _weights = Provider.of<List<WeightData>>(context);
    final Map<String, num> weightMap = new Map<String, num>();

    // List to be added to SliverChildListDelegate
    List<Widget> _children = List<Widget>();


    // _weights can be null, only show when its not null
    if(_weights == null){
      _children.add(
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: CupertinoActivityIndicator(),
          ),
        )
      );
    }
    else{

      for(WeightData w in _weights){
        weightMap[w.time] = w.weight;
      }

      _children.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Missed a day? No problem!"),
            Text("Add or edit weight for past dates here."),
          ],
        ),
      );
      
      _children.add(
        CupertinoButton( 
          child: Text("Select A Date", style: Styles.biggerText,),
          onPressed: () async {
            final WeightData dateData = await showCupertinoDialog<WeightData>(
              context: context,
              builder: (BuildContext context){
                // Temp vars for displaying weight data 
                String tempDate = TimeConvert().getFormattedString();
                num tempWeight = weightMap[tempDate];

                // check to change timePicker to dark mode look
                Brightness brightness = MediaQuery.platformBrightnessOf(context);

                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Displays a DatePicker for user to select date 
                        SizedBox(
                          height: 200,
                          child: CupertinoDatePicker(
                            backgroundColor: brightness == Brightness.dark ? CupertinoColors.black : CupertinoColors.white,
                            mode: CupertinoDatePickerMode.date,
                            initialDateTime: DateTime.now(),
                            minimumDate: DateTime(2020,1,1),
                            maximumDate: DateTime.now(),
                            // SetsState on tempWeight to display the recorded weight at the tempDate. 
                            onDateTimeChanged: (DateTime date){
                              tempDate = TimeConvert().dateTimeToFormattedString(date);
                              setState(() => tempWeight = weightMap[tempDate]);
                            },
                          ),
                        ),
                        // Displays Action sheet showing if date selected already has weight 
                        // and options to cancel or select the date.
                        CupertinoActionSheet(
                          title: Text(tempWeight == null ? 
                            "No weight was recorded on this date" : "Recorded weight on this date was " + tempWeight.toString()
                          ),
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                              onPressed: () => Navigator.of(context).pop(WeightData(time: tempDate, weight: tempWeight)),
                              child: Text("Select Date"),
                            )
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () => Navigator.of(context).pop(null),
                            child: Text("Cancel"),
                          ),
                        ),
                      ],
                    );
                  },
                ); 
              }
            );
            if(dateData != null){
              setState((){
                _selectedDateData = dateData;
                _hasPrevWeight = dateData.weight == null ? false : true;
              });  
            }
          },
        )
      );
        
      if(_selectedDateData != null){
        _children.add(
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(  
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Selected Date: " + _selectedDateData.time),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: _hasPrevWeight ? 10 : 0),
                  child: Text(_hasPrevWeight ? 
                    "Recorded weight on this date was " + _selectedDateData.weight.toString() : ""
                  ),
                ),
                Padding(  
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                  child: CupertinoTextField(
                    prefix: Padding( 
                      padding: EdgeInsets.all(4),
                      child: Icon(ScaleIcon.weight, color: CupertinoColors.inactiveGray,),
                    ),
                    placeholder: "Enter Weight",
                    autofocus: true,
                    autocorrect: false,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.done,
                    onChanged: (text) => _onEditWeight(text), 
                    textAlign: TextAlign.center,
                  ), 
                ),
                CupertinoButton.filled(
                  child: Text('Submit Weight', style: Styles.buttonTextStyle) ,
                  onPressed: () => _onSubmitWeight(context),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 50),
                  minSize: 20,
                ),
              ],
            ),
          ),
        );
      }
    }

    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text('Edit Weight History'),
          heroTag: "Edit Weights",
        ),
        SliverPadding(
          padding: EdgeInsets.only(top: 15),
          sliver: SliverList( 
            delegate: SliverChildListDelegate(_children),
          ),
        ),
      ],
    );
  }
}

