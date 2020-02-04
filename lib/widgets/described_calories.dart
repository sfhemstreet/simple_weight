import 'package:flutter/cupertino.dart';
import 'package:simple_weight/styles/styles.dart';

Widget describedCalories({String description, int calories}){
  final color = calories > 1600 || calories < 0 ? CupertinoColors.destructiveRed : CupertinoColors.activeBlue;

  return RichText(
    text: TextSpan(
      children: [
        TextSpan(text: description, style: Styles.descriptor),
        TextSpan(text: '$calories', style: TextStyle(color: color),),
      ],
    ),
  );
}