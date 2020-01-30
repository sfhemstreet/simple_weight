import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/database/weight_data.dart';

/// Renders a sliver list of all weights in Database
class WeightList extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    final List<WeightData> allWeightData = Provider.of<List<WeightData>>(context);

    if(allWeightData == null){
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
            final int currIndex = (allWeightData.length -1) - index;
            final WeightData item = allWeightData[currIndex];
            final WeightData prevItem = currIndex > 0 ? allWeightData[currIndex - 1] : null;
            final num weightDiff = currIndex > 0 ? item.weight - prevItem.weight : 0;
            final String trailingText = weightDiff > 0 ? "+" + weightDiff.toStringAsFixed(1) : weightDiff.toStringAsFixed(1);
            final Color color = weightDiff <= 0 ? CupertinoColors.activeBlue : CupertinoColors.destructiveRed;

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
                      Text(item.weight.toString()),
                      Text(item.time, style: TextStyle(color: CupertinoColors.inactiveGray),),
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

