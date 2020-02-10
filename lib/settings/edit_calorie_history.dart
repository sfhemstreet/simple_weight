import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/database/calorie_data.dart';
import 'package:simple_weight/models/calorie_model.dart';
import 'package:simple_weight/styles/styles.dart';
import 'package:simple_weight/utils/constants.dart';
import 'package:simple_weight/utils/time_convert.dart';
import 'package:simple_weight/icons/silverware_icon.dart';
import 'package:simple_weight/widgets/simple_weight_date_picker.dart';


/// Page for editting or adding past daily calorie totals
class EditCalorieHistory extends StatefulWidget{
  @override 
  _EditCalorieHistoryState createState() => _EditCalorieHistoryState();
}

class _EditCalorieHistoryState extends State<EditCalorieHistory> {
  
  final CalorieModel _calorieModel = CalorieModel();

  CalorieData _selectedDateData;
  bool _hasPrevCalories = false;
  int _calorieInput;
  bool _hasUpdated = false;

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

      // Display popup alert if new calorie input is overriding prevously recorded one.
      if(_hasPrevCalories){
        // Check if user wants to override prevous record 
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

      _selectedDateData.calories = _calorieInput;
      _calorieModel.insertCalories(_selectedDateData);
      
      // makes submit button go away
      setState(() {
        _selectedDateData = null;
        _calorieInput = null;
        _hasUpdated = true;
      });
    }
  }
  
  @override 
  Widget build(BuildContext context){

    final _calories = Provider.of<List<CalorieData>>(context);
    final Map<String, num> calorieMap = new Map<String, num>();

    // List to be added to SliverChildListDelegate
    List<Widget> _children = List<Widget>();

    // Configure gradient settings for Dark and Light Modes
    final Brightness brightness = MediaQuery.platformBrightnessOf(context);

    final List<Color> gradient = brightness == Brightness.dark ? Styles.darkGradient : Styles.lightGradient;

    // Only show loading widget if calorie data is not in yet.
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

      

      // Place all data into Map, so Calendar Popup can display
      // prevoulsy recorded calories, or if no calories were recorded
      // for any selected day.
      for(CalorieData c in _calories){
        calorieMap[c.time] = c.calories;
      }

      // Page explaination 
      _children.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Forgot to record a meal? No problem!"),
            Text("Add or edit calories for past dates here."),
          ],
        ),
      );
        
      // Select Date Button And Calender Popup 
      _children.add(
        CupertinoButton( 
          child: Text("Select A Date", style: Styles.biggerText,),
          onPressed: () async {
            // get rid of checkmark if already submitted prev calories
            setState(() {
              _hasUpdated = false;
            });
            // Returns the selected date and any calorie data prevously record
            // at that date. If no date was selected this will be null.
            final CalorieData dateData = await showCupertinoDialog<CalorieData>(
              context: context,
              builder: (BuildContext context){
                // Temp vars for displaying weight data 
                String tempDate = TimeConvert().getFormattedString();
                num tempCalories = calorieMap[tempDate];

                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Displays a DatePicker for user to select date 
                        SimpleWeightDatePicker((DateTime date){
                            tempDate = TimeConvert().dateTimeToFormattedString(date);
                            setState(() => tempCalories = calorieMap[tempDate]);
                          },
                        ),
                        // Displays Action sheet showing if date selected already has weight 
                        // and options to cancel or select the date.
                        CupertinoActionSheet(
                          title: AnimatedSwitcher(
                            duration: Duration(milliseconds: 200),
                            child: tempCalories == null ? 
                              Text("No calories were recorded on this date") 
                              : 
                              Row(
                                key: ValueKey(DateTime.now().millisecondsSinceEpoch),
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Calories recorded on this date: "),
                                  Text(
                                    tempCalories.toString(), 
                                    style: TextStyle(color: brightness == Brightness.dark ? CupertinoColors.white : CupertinoColors.darkBackgroundGray),
                                  ),
                                ],
                              ),
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
            // If user selected a date, store it, also sets _hasPrevCalories 
            // so we can show popup warning later
            if(dateData != null){
              setState((){
                _selectedDateData = dateData;
                _hasPrevCalories = dateData.calories == null ? false : true;
              });  
            }
          },
        ),
      );

      // adds Input for calories and submit button, only shows after user has selected a date.
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
                    "Previously recorded calories: " + _selectedDateData.calories.toString() : ""
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
                  child: Text('Submit Calories', style: Styles.buttonTextStyle) ,
                  onPressed: () => _onSubmitCalories(context),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 50),
                  minSize: 20,
                ),
              ],
            ),
          ),
        );
      }

      
      _children.add(
        AnimatedOpacity( 
          duration: Duration(milliseconds: 1000),
          opacity: _hasUpdated ? 1 : 0,
          child: Padding(
            padding: const EdgeInsets.only(top: 90.0),
            child: Center(
              child: Icon(CupertinoIcons.check_mark_circled_solid, size: 30, color: CupertinoColors.activeGreen,),
            ),
          ),
        ),
      );
      
    }

    return CupertinoPageScaffold(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topRight,
            colors: gradient,
          ),
        ),
        child: CustomScrollView(
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
        ),
      ),
    );
  }
}