import 'package:flutter/cupertino.dart';

///Cupertino DatePicker used in this App
class SimpleWeightDatePicker extends StatelessWidget{
  final Function _onDateChanged;

  SimpleWeightDatePicker(this._onDateChanged);

  @override
  Widget build(BuildContext context){

    // check to change timePicker to dark mode look
    Brightness brightness = MediaQuery.platformBrightnessOf(context);

    return Container(
      height: 200,
      child: CupertinoDatePicker(
        backgroundColor: brightness == Brightness.dark ? CupertinoColors.black : CupertinoColors.white,
        mode: CupertinoDatePickerMode.date,
        initialDateTime: DateTime.now(),
        minimumDate: DateTime(2020,1,1),
        maximumDate: DateTime.now(), 
        onDateTimeChanged: _onDateChanged,
      ),
    );
  }
}