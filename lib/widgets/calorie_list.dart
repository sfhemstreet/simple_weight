import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/database/calorie_data.dart';
import 'package:simple_weight/styles/styles.dart';
import 'package:simple_weight/utils/time_convert.dart';

/// Renders a sliver list of all calories in Database
class CalorieList extends StatelessWidget {
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

            final Color bottomBorderColor = index + 1 == allCalorieData.length ? CupertinoColors.separator : Color.fromRGBO(0, 0, 0, 0); 

            // Configure gradient settings for Dark and Light Modes
            final Brightness brightness = MediaQuery.platformBrightnessOf(context);

            final Color containerColor = brightness == Brightness.dark ? Styles.darkContainerOpaque : Styles.lightContainerOpaque;

            return Container(
              decoration: BoxDecoration(
                color: containerColor,
                border: Border(
                  top: BorderSide(
                    color: CupertinoColors.separator
                  ),
                  bottom: BorderSide(
                    color: bottomBorderColor,
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
                      Text(item.calories.toString()),
                      Text(timeText, style: TextStyle(color: CupertinoColors.inactiveGray),),
                    ],
                  ),
                  Text(trailingText, style: TextStyle(color: color)),
                ],
              ),
            );
          },
          childCount: allCalorieData.length,
        ),
      ),
    );
  }
}
