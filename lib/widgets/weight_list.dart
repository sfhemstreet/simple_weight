import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/database/weight_data.dart';
import 'package:simple_weight/utils/time_convert.dart';

/// Renders a sliver list of all weights in Database
class WeightList extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    final List<WeightData> allWeightData = Provider.of<List<WeightData>>(context);

    if(allWeightData == null){
      return SliverPadding(
        padding: const EdgeInsets.only(top: 100),
        sliver: SliverToBoxAdapter(
          child: Center(
            child: CupertinoActivityIndicator(),
          )
        ),
      );
    }

    if(allWeightData.length == 0){
      return SliverPadding(
        padding: const EdgeInsets.only(top: 100),
        sliver: SliverToBoxAdapter(
          child: Center( 
            child: Text("Keep Track of Weight!"),
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
            final int currIndex = allWeightData.length > 0 ? (allWeightData.length -1) - index : 0;

            final WeightData item = allWeightData[currIndex];
            
            final WeightData prevItem = currIndex > 0 ? allWeightData[currIndex - 1] : null;

            final num weightDiff = currIndex > 0 ? item.weight - prevItem.weight : 0;

            final String trailingText = weightDiff > 0 ? "+" + weightDiff.toStringAsFixed(1) : weightDiff.toStringAsFixed(1);

            final Color color = weightDiff <= 0 ? CupertinoColors.activeBlue : CupertinoColors.destructiveRed;

            final String timeText = TimeConvert().isStringToday(item.time) ? 
              "Today, ${item.time}" : "${item.dayOfWeek}, ${item.time}";

            final Color bottomBorderColor = index + 1 == allWeightData.length ? CupertinoColors.separator : Color.fromRGBO(0, 0, 0, 0); 

            // Configure gradient settings for Dark and Light Modes
            final Brightness brightness = MediaQuery.platformBrightnessOf(context);

            final Color containerColor = brightness == Brightness.dark ? Color.fromRGBO(0, 0, 0, 0.5) : Color.fromRGBO(255, 255, 255, 0.5);
            

            return Container(
              decoration: BoxDecoration(
                color: containerColor,
                border: Border(
                  top: BorderSide(
                    color: CupertinoColors.separator
                  ),
                  bottom: BorderSide(
                    color: bottomBorderColor
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
                      Text(item.weight.toString()),
                      Text(timeText, style: TextStyle(color: CupertinoColors.inactiveGray),),
                    ],
                  ),
                  Text(trailingText, style: TextStyle(color: color)),
                ],
              ),
            );
          },
          childCount: allWeightData.length,
        ),
      ),
    );
  }
}

