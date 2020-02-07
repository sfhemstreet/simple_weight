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
    fontSize: 14,
  );

  static const Color lightBarBackground = Color.fromRGBO(225, 238, 253, 0.7);

  static const Color darkBarBackground = Color.fromRGBO(43, 43, 43, 0.7);

  static const Color darkContainer = Color.fromRGBO(0, 0, 0, 0.6);
  
  static const Color lightContainer = Color.fromRGBO(255, 255, 255, 0.6);

  static const Color darkContainerOpaque = Color.fromRGBO(0, 0, 0, 0.4);

  static const Color lightContainerOpaque = Color.fromRGBO(255, 255, 255, 0.4);

  static const List<Color> darkGradient = <Color>[
      CupertinoColors.black,
      Color.fromRGBO(0, 17, 103, 0.3),
      Color.fromRGBO(57, 0, 58, 0.4),
      Color.fromRGBO(27, 51, 3, 0.3),
      Color.fromRGBO(36, 4, 4, 0.5),
      Color.fromRGBO(53, 22, 86, 0.5),
    ]; 

  static const List<Color> darkerGradient = <Color>[
      Color.fromRGBO(0, 17, 103, 0.1),
      Color.fromRGBO(57, 0, 58, 0.01),
      Color.fromRGBO(27, 51, 3, 0.01),
      Color.fromRGBO(36, 4, 4, 0.01),
      Color.fromRGBO(53, 22, 86, 0.02),
    ]; 

  static const List<Color> lightGradient = <Color>[
      Color.fromRGBO(8, 96, 95, 0.2),
      Color.fromRGBO(23, 126, 137, 0.1),
      Color.fromRGBO(89, 131, 129, 0.1),
      Color.fromRGBO(142, 107, 149, 0.1),
      Color.fromRGBO(162, 173, 89, 0.3),
    ];

  
}