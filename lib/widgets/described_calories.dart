import 'package:flutter/cupertino.dart';
import 'package:simple_weight/styles/styles.dart';

Widget describedCalories({String description, int calories, int max = 1600}){
  final color = calories > max || calories < 0 ? CupertinoColors.destructiveRed : CupertinoColors.activeBlue;

  return RichText(
    text: TextSpan(
      children: [
        TextSpan(text: description, style: Styles.descriptor),
        TextSpan(text: '$calories', style: TextStyle(color: color),),
      ],
    ),
  );
}