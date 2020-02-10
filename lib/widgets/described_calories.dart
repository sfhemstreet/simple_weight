import 'package:flutter/cupertino.dart';
import 'package:simple_weight/styles/styles.dart';

class DescribedCalories extends StatelessWidget{

  DescribedCalories({Key key, this.description, this.calories, this.max = 1600}) : super(key: key);
  final String description;
  final int calories;
  final int max;

  Widget build(BuildContext context){

    final Color color = calories > max || calories < 0 ? CupertinoColors.destructiveRed : CupertinoColors.activeBlue;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: description, style: Styles.descriptor),
          TextSpan(text: '$calories', style: TextStyle(color: color),),
        ],
      ),
    );  
  }
}