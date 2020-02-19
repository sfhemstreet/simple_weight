import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/database/weight_data.dart';
import 'package:simple_weight/icons/scale_icon.dart';
import 'package:simple_weight/models/weight_model.dart';
import 'package:simple_weight/styles/styles.dart';
import 'package:simple_weight/utils/constants.dart';
import 'package:simple_weight/utils/time_convert.dart';
import 'package:simple_weight/widgets/swipable_item.dart';

/// Renders a sliver list of all weights in Database
class EditableWeightList extends StatelessWidget {

  void _pushEditItem(BuildContext context, WeightData item) async {
    WeightData _weight = new WeightData(time: item.time, weight: item.weight);

    await showCupertinoModalPopup<void>(
      context: context, 
      builder: (BuildContext context){
        return StatefulBuilder(builder: 
        (context, setState){

          final screenHeight = MediaQuery.of(context).size.height;
          double bottomPadding = 150;

          if(screenHeight > 680){
            bottomPadding = 230;
          }

          return CupertinoActionSheet(
            title: Text("Edit Weight: ${item.weight} on ${item.time}"),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50),
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
                        onChanged: (text){
                          // Input will always be text, parse to num if possible
                          num newWeight = num.tryParse(text) ?? 0;
                          
                          if(newWeight >= Constants.MIN_WEIGHT && newWeight <= Constants.MAX_WEIGHT){
                            setState(() {
                              _weight.weight = newWeight;
                            });
                          }
                        }, 
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        CupertinoButton(
                          child: Text('Cancel') ,
                          onPressed: () => Navigator.of(context).pop(),
                        ),

                        CupertinoButton(
                          child: Text('Submit Weight') ,
                          onPressed: () async {
                            
                            final num checkWeight = num.parse(_weight.weight.toStringAsFixed(1));

                            if(checkWeight >= Constants.MIN_WEIGHT && checkWeight <= Constants.MAX_WEIGHT){
                              _weight.weight = checkWeight;
                              WeightModel().insertWeight(_weight);
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                        
                      ],
                    ),
                  ],
                ),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
          );
        });
        
    });
  }

  void _pushDeleteItem(BuildContext context, WeightData item) async {
    await showCupertinoModalPopup<void>(
      context: context, 
      builder: (BuildContext context){
        return CupertinoActionSheet( 
          title: Text("Delete Weight Data for ${item.time}"),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: (){
                WeightModel().deleteWeight(item);
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
        padding: const EdgeInsets.only(top: 150),
        sliver: SliverToBoxAdapter(
          child: Center( 
            child: Text("Keep Track of Weight!", style: Styles.biggerText,),
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
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 150),
                          child: Text(item.weight.toString(), key: ValueKey(item.weight))
                        ),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 150),
                          child: Text(timeText, style: TextStyle(color: CupertinoColors.inactiveGray), key: ValueKey(timeText)),
                        ),
                      ],
                    ),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 150),
                      child: Text(trailingText, style: TextStyle(color: color), key: ValueKey(trailingText)),
                    ),
                  ],
                ),
              ),
            );
          },
          childCount: allWeightData.length,
        ),
      ),
    );
  }
}
