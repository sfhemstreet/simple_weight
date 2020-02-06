import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/database/calorie_data.dart';
import 'package:simple_weight/models/calorie_model.dart';
import 'package:simple_weight/styles/styles.dart';
import 'package:simple_weight/utils/constants.dart';
import 'package:simple_weight/utils/time_convert.dart';
import 'package:simple_weight/icons/silverware_icon.dart';

class EditCalorieHistory extends StatefulWidget{
  @override 
  _EditCalorieHistoryState createState() => _EditCalorieHistoryState();
}

class _EditCalorieHistoryState extends State<EditCalorieHistory> {
  
  final CalorieModel _calorieModel = CalorieModel();

  CalorieData _selectedDateData;
  bool _hasPrevCalories = false;
  int _calorieInput;

  void _onEditCalories(String text){
    // Input will always be text, parse to num if possible
    num calorieInput = num.tryParse(text) ?? 0;

    if(calorieInput >= 0){
      setState(() {
        _calorieInput = calorieInput;
      });
    }
  }

  void _onSubmitCalories(BuildContext context) async {
    if(_calorieInput != null && _calorieInput >= 0 && _calorieInput <= Constants.MAX_CALORIES){

      // Display popup alert if new weight is overriding prevWeight.
      if(_hasPrevCalories){
        bool willOverride = await showCupertinoDialog<bool>(
          context: context,
          builder: (BuildContext context){
            return CupertinoAlertDialog(
              title: Text("${_selectedDateData.time} has previously recorded calories, ${_selectedDateData.calories}.\n"),
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
      _selectedDateData.calories = _calorieInput;
      // Add weight to model so entire app knows the enw weight
      _calorieModel.insertCalories(_selectedDateData);
      
      // makes submit button go away
      setState(() {
        _selectedDateData = null;
        _calorieInput = null;
      });
    }
  }
  
  @override 
  Widget build(BuildContext context){

    final _calories = Provider.of<List<CalorieData>>(context);
    final Map<String, num> calorieMap = new Map<String, num>();

    // List to be added to SliverChildListDelegate
    List<Widget> _children = List<Widget>();

    if(_calories == null){
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

      for(CalorieData c in _calories){
        calorieMap[c.time] = c.calories;
      }

      _children.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Missed a day? No problem!"),
            Text("Add or edit calories for past dates here."),
          ],
        ),
      );
        
      _children.add(
        CupertinoButton( 
          child: Text("Select A Date", style: Styles.biggerText,),
          onPressed: () async {
            final CalorieData dateData = await showCupertinoDialog<CalorieData>(
              context: context,
              builder: (BuildContext context){
                // Temp vars for displaying weight data 
                String tempDate = TimeConvert().getFormattedString();
                num tempCalories = calorieMap[tempDate];

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
                              setState(() => tempCalories = calorieMap[tempDate]);
                            },
                          ),
                        ),
                        // Displays Action sheet showing if date selected already has weight 
                        // and options to cancel or select the date.
                        CupertinoActionSheet(
                          title: Text(tempCalories == null ? 
                            "No calories were recorded on this date" : "Recorded calorie intake on this date was " + tempCalories.toString()
                          ),
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                              onPressed: () => Navigator.of(context).pop(CalorieData(time: tempDate, calories: tempCalories)),
                              child: Text("Edit Calories on Selected Date"),
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
                _hasPrevCalories = dateData.calories == null ? false : true;
              });  
            }
          },
        ),
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
                  padding: EdgeInsets.only(bottom: _hasPrevCalories ? 10 : 0),
                  child: Text(_hasPrevCalories ? 
                    "Previously recorded calories were " + _selectedDateData.calories.toString() : ""
                  ),
                ),
                Padding(  
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                  child: CupertinoTextField(
                    prefix: Padding( 
                      padding: EdgeInsets.all(4),
                      child: Icon(SilverwareIcon.cutlery, color: CupertinoColors.inactiveGray,),
                    ),
                    placeholder: "Enter Calories",
                    autofocus: true,
                    autocorrect: false,
                    keyboardType: TextInputType.numberWithOptions(decimal: false),
                    textInputAction: TextInputAction.done,
                    onChanged: (text) => _onEditCalories(text), 
                    textAlign: TextAlign.center,
                  ), 
                ),
                CupertinoButton.filled(
                  child: Text('Submit Weight', style: Styles.buttonTextStyle) ,
                  onPressed: () => _onSubmitCalories(context),
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
          largeTitle: Text('Edit Calorie History'),
          heroTag: "Edit Calorie History",
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