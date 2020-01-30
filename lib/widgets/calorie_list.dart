import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/database/calorie_data.dart';

/// Renders a sliver list of all calories in Database
class CalorieList extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    final List<CalorieData> allCalorieData = Provider.of<List<CalorieData>>(context);

    if(allCalorieData == null){
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }

    return SliverSafeArea(
      top: false,
      minimum: EdgeInsets.only(bottom: 83),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index){
            // Last weight must go on top, this reverses the list
            final int currIndex = (allCalorieData.length -1) - index;
            final CalorieData item = allCalorieData[currIndex];
            final CalorieData prevItem = currIndex > 0 ? allCalorieData[currIndex - 1] : null;
            final num calorieDiff = currIndex > 0 ? item.calories - prevItem.calories : 0;
            final String trailingText = calorieDiff > 0 ? "+" + calorieDiff.toString() : calorieDiff.toString();
            final Color color = calorieDiff <= 0 ? CupertinoColors.activeBlue : CupertinoColors.destructiveRed;

            return Container(
              decoration: BoxDecoration(
                border: Border.fromBorderSide(BorderSide(color: CupertinoColors.opaqueSeparator)),
                color: CupertinoColors.secondarySystemBackground
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
                      Text(item.time, style: TextStyle(color: CupertinoColors.inactiveGray),),
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
