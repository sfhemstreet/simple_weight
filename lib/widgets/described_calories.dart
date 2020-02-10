import 'package:flutter/cupertino.dart';
import 'package:simple_weight/styles/styles.dart';

class DescribedCalories extends StatelessWidget{

  DescribedCalories({Key key, this.description, this.calories, this.max = 1600}) : super(key: key);
  final String description;
  final int calories;
  final int max;

  Widget build(BuildContext context){

    final Color color = calories > max || calories < 0 ? CupertinoColors.destructiveRed : CupertinoColors.activeBlue;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(description, style: Styles.descriptor),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 150),
          child: Text('$calories', style: TextStyle(color: color), key: ValueKey(calories)),
        ),
      ],
    );  
  }
}