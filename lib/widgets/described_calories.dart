import 'package:flutter/cupertino.dart';

Widget describedCalories({String description, int calories}){
  final color = calories > 1600 || calories < 0 ? CupertinoColors.destructiveRed : CupertinoColors.activeBlue;

  return Padding(
    padding: EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(description),
        Text('$calories', style: TextStyle(color: color),),
      ],
    ),
  );
}