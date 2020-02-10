import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/database/calorie_data.dart';
import 'package:simple_weight/styles/styles.dart';
import 'package:simple_weight/utils/time_convert.dart';

/// Renders a sliver list of all calories in Database
class AnimatedCalorieList extends StatefulWidget {

  @override
  _AnimatedCalorieListState createState() => _AnimatedCalorieListState();
}

class _AnimatedCalorieListState extends State<AnimatedCalorieList> {

  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey<SliverAnimatedListState>();
  List<ListItem> _list = List<ListItem>();
  Map<String, int> _indexMap = Map<String, int>();

  SliverAnimatedListState get _animatedList => _listKey.currentState;


  // Used to build an item after it has been removed from the list. This
  // method is needed because a removed item remains visible until its
  // animation has completed (even though it's gone as far this ListModel is
  // concerned). The widget will be used by the
  // [AnimatedListState.removeItem] method's
  // [AnimatedListRemovedItemBuilder] parameter.
  Widget _buildRemovedItem(Widget item, BuildContext context, animation){
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
      child: item,
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
      sliver: SliverAnimatedList(
        key: _listKey,
        initialItemCount: _list.length,
        itemBuilder: (BuildContext context, int index, Animation<double> animation){

          if(_list.length == 0){
            for(int i = 0; i < allCalorieData.length ; i++){
              final prevCalories = i > 0 ? allCalorieData[i - 1].calories : 0;
              final data = allCalorieData[i];
              final Widget listItem = ListItem(item: data, prevCalories: prevCalories);
              _list.insert(i, listItem);
              _animatedList.insertItem(i);
              _indexMap[data.time] = i;
            }
          } 
          else {
            for(int i = 0; i < allCalorieData.length; i++){
              final data = allCalorieData[i];
              final prevCalories = i > 0 ? allCalorieData[i - 1].calories : 0;
              final Widget listItem = ListItem(item: data, prevCalories: prevCalories);

              // check if item is in _list
              final bool isInList = _indexMap.containsKey(data.time);

              if(isInList){
                final int removalIndex = _indexMap[data.time];
                final ListItem removed = _list[removalIndex];
                _animatedList.removeItem(removalIndex,
                  (BuildContext context, Animation<double> animation) => 
                    _buildRemovedItem(removed, context, animation),
                );
                _list.insert(i, listItem);
                _animatedList.insertItem(removalIndex);
              } else {
                _list.insert(i, listItem);
                _animatedList.insertItem(_list.length);
                _indexMap[data.time] = i;
              }
            }
          }


          return SizeTransition(
            axis: Axis.vertical,
            sizeFactor: animation,
            child: _list[index],
          );
        },
      ),
    );
  }
}





class ListItem extends StatelessWidget {
  const ListItem({
    Key key,
    @required this.item,
    @required this.prevCalories,
  })  : assert(prevCalories != null),
        assert(item != null),
        super(key: key);

  final CalorieData item;
  final int prevCalories;

  Widget build(BuildContext context){

    final num calorieDiff = item.calories - prevCalories;

    final String trailingText = calorieDiff > 0 ? "+" + calorieDiff.toString() : calorieDiff.toString();

    final Color color = calorieDiff <= 0 ? CupertinoColors.activeBlue : CupertinoColors.destructiveRed;

    final String timeText = TimeConvert().isStringToday(item.time) ? 
      "Today, ${item.time}" : "${item.dayOfWeek}, ${item.time}";

    //final Color bottomBorderColor = index + 1 == allCalorieData.length ? CupertinoColors.separator : Color.fromRGBO(0, 0, 0, 0); 

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
          // bottom: BorderSide(
          //   color: bottomBorderColor,
          // ),
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
  }
}