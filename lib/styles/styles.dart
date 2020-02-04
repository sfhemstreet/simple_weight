import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

abstract class Styles {

  static const Color bottonTextColor = CupertinoColors.white;

  static const Color buttonColor = CupertinoColors.activeBlue;

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 14,
    color: CupertinoColors.white,
  );

  static const TextStyle biggerText = TextStyle(
    fontSize: 22,
  );

  static const TextStyle smallText = TextStyle( 
    fontSize: 12,
  );

  static const TextStyle descriptor = TextStyle(
    color: CupertinoColors.inactiveGray, 
    fontSize: 13
  );
}