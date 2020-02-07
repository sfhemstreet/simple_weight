import 'package:flutter/cupertino.dart';
import 'package:simple_weight/styles/styles.dart';

class ListButton extends StatelessWidget{
  final Function onPressed;
  final Widget child;

  ListButton({@required this.onPressed, @required this.child});

  @override
  Widget build(BuildContext context){

    // Configure gradient settings for Dark and Light Modes
    final Brightness brightness = MediaQuery.platformBrightnessOf(context);

    final Color containerColor = brightness == Brightness.dark ? Styles.darkContainer : Styles.lightContainer;

    return Container(
      decoration: BoxDecoration(
        color: containerColor,
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.separator
          ),
        ),
      ),
      padding: EdgeInsets.all(10),
      child: CupertinoButton(
        onPressed: onPressed,
        child: child
      ),
    );
  }
} 