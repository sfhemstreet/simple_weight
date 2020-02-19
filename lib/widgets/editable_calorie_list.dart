import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/database/calorie_data.dart';
import 'package:simple_weight/models/calorie_model.dart';
import 'package:simple_weight/styles/styles.dart';
import 'package:simple_weight/utils/constants.dart';
import 'package:simple_weight/utils/time_convert.dart';
import 'package:simple_weight/widgets/swipable_item.dart';

/// Renders a sliver list of all calories in Database
class EditableCalorieList extends StatelessWidget {

  void _pushDeleteItem(BuildContext context, CalorieData item) async {
    await showCupertinoModalPopup<void>(
      context: context, 
      builder: (BuildContext context){
        return CupertinoActionSheet( 
          title: Text("Delete Calorie Data for ${item.time}"),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: (){
                CalorieModel().deleteCalories(item);
                Navigator.of(context).pop();
              }, 
              child: Text("Delete"),
              isDestructiveAction: true,
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        );   
      }
    );
  }
  

  void _pushEditItem(BuildContext context, CalorieData item) async {
    int newCalories = item.calories;
    // Configure gradient settings for Dark and Light Modes
    final Brightness brightness = MediaQuery.platformBrightnessOf(context);

    await showCupertinoModalPopup<void>(
      context: context, 
      builder: (BuildContext context){
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return CupertinoActionSheet( 
              title: Text("Edit Calories for ${item.time}"),
              message: Row(
                mainAxisAlignment: MainAxisAlignment.center,  
                children: <Widget>[
                  CupertinoButton(
                    onPressed: (){
                      if(newCalories >= 100){
                        setState(() {
                          newCalories -= 100;
                        });
                      }
                    },
                    child: Icon(CupertinoIcons.minus_circled)
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 150),
                      child: Text(
                        '$newCalories', 
                        style: Styles.biggerText.copyWith(color: brightness == Brightness.dark ? CupertinoColors.white : CupertinoColors.darkBackgroundGray),
                        key: ValueKey(newCalories),
                      ),
                      transitionBuilder: (Widget child, Animation<double> animation) => 
                        ScaleTransition(scale: animation, child: child),
                    ),
                  ),
                  CupertinoButton(
                    onPressed: (){
                      if(newCalories + 100 <= Constants.MAX_CALORIES){
                        setState(() {
                          newCalories = newCalories + 100;
                        });
                      }
                    },
                    child: Icon(CupertinoIcons.add_circled)
                  ),
                ],
              ),
              actions: <Widget>[
                CupertinoActionSheetAction(
                  onPressed: (){
                    if(item.calories != newCalories){
                      final CalorieData c = new CalorieData(
                        calories: newCalories, 
                        time: item.time, 
                        dayOfWeek: item.dayOfWeek
                      );
                      CalorieModel().insertCalories(c);
                    }
                    Navigator.of(context).pop();
                  }, 
                  child: Text("Update")
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
            ); 
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context){
    final List<CalorieData> allCalorieData = Provider.of<List<CalorieData>>(context);

    if(allCalorieData == null){
      return SliverPadding(
        padding: const EdgeInsets.only(top: 100),
        sliver: SliverToBoxAdapter(
          child: Center(
            child: CupertinoActivityIndicator(),
          )
        ),
      );
    }

    if(allCalorieData.length == 0){
      return SliverPadding(
        padding: const EdgeInsets.only(top: 130),
        sliver: SliverToBoxAdapter(
          child: Center( 
            child: Text("Keep Track of Calories!", style: Styles.biggerText,),
          ),
        ),
      );
    }

    return SliverSafeArea(
      top: false,
      minimum: EdgeInsets.only(bottom: 83),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index){
            // Last weight must go on top, this reverses the list
            final int currIndex = allCalorieData.length > 0 ? (allCalorieData.length - 1) - index : 0;

            final CalorieData item = allCalorieData[currIndex];

            final CalorieData prevItem = currIndex > 0 ? allCalorieData[currIndex - 1] : null;

            final num calorieDiff = currIndex > 0 ? item.calories - prevItem.calories : 0;

            final String trailingText = calorieDiff > 0 ? "+" + calorieDiff.toString() : calorieDiff.toString();

            final Color color = calorieDiff <= 0 ? CupertinoColors.activeBlue : CupertinoColors.destructiveRed;

            final String timeText = TimeConvert().isStringToday(item.time) ? 
              "Today, ${item.time}" : "${item.dayOfWeek}, ${item.time}";

            final Color bottomBorderColor = CupertinoColors.separator.withOpacity(0.1); 

            // Configure gradient settings for Dark and Light Modes
            final Brightness brightness = MediaQuery.platformBrightnessOf(context);

            final Color containerColor = brightness == Brightness.dark ? Styles.darkContainerOpaque : Styles.lightContainerOpaque;

            return SwipableItem(
              backgroundColor: containerColor,
              items: <ActionItem>[
                ActionItem(
                  icon: Icon(CupertinoIcons.pencil),
                  onPress: () => _pushEditItem(context, item),
                  backgroudColor: Color.fromRGBO(0, 0, 0, 0),
                ),
                ActionItem(
                  icon: Icon(CupertinoIcons.delete_simple),
                  onPress: () => _pushDeleteItem(context, item),
                  backgroudColor: Color.fromRGBO(0, 0, 0, 0),
                ),
              ],
              child: Container(
                margin: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0),
                  border: Border(
                    top: BorderSide(
                      color: bottomBorderColor,
                    ),
                    bottom: BorderSide(
                      color: bottomBorderColor,
                    ),
                    left: BorderSide(
                      color: CupertinoColors.separator
                    ),
                    right: BorderSide(
                      color: CupertinoColors.separator
                    ),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 250),
                          child: Text(item.calories.toString(), key: ValueKey(item.calories))
                        ),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 250),
                          child: Text(timeText, style: TextStyle(color: CupertinoColors.inactiveGray), key: ValueKey(timeText))
                        ),
                      ],
                    ),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 250),
                      child: Text(trailingText, style: TextStyle(color: color), key: ValueKey(trailingText)),
                    ),
                  ],
                ),
              ),
            );
          },
          childCount: allCalorieData.length,
        ),
      ),
    );
  }
}
