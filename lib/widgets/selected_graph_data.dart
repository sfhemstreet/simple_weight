import "package:flutter/cupertino.dart";
import 'package:simple_weight/styles/styles.dart';
import 'package:simple_weight/utils/time_convert.dart';


/// Displays data from tapped area of graph.
class SelectedGraphData extends StatelessWidget {
  final DateTime time;
  final Map<String, num> measurements;

  SelectedGraphData(Key key,{this.time, this.measurements}) : super(key: key);

  @override 
  Widget build(BuildContext context){
    
    List<Widget> children = [];
    
    if (time != null) {
      children.add(
        Text(TimeConvert().dateTimeToFormattedString(time))
      );

      measurements?.forEach((String series, num value) {
        children.add(
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: '$series: ', style: Styles.descriptor),
                TextSpan(text: '$value', style: DefaultTextStyle.of(context).style),
              ],
            ),
          ),
        );
      });
    } else {
      children.add(Text(" "));
    }
    
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}