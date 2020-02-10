import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/database/weight_data.dart';
import 'package:simple_weight/database/calorie_data.dart';
import 'package:simple_weight/models/calorie_model.dart';
import 'package:simple_weight/models/weight_model.dart';
import 'package:simple_weight/simple_weight.dart';
import 'package:simple_weight/styles/styles.dart';
import 'package:simple_weight/utils/constants.dart';
import 'package:simple_weight/widgets/restart_widget.dart';

import 'models/calorie_target_model.dart';
import 'models/weight_target_model.dart';

void main() => runApp(MyApp());

/// Provides Data Streams to entire app and enables tap out gesture control
class MyApp extends StatelessWidget{
  @override 
  Widget build(BuildContext context){
    return MultiProvider( 
      providers: [
        // Streams Weight data stored in DB
        StreamProvider<List<WeightData>>( 
          create:(_) => WeightModel().weightStream,
          catchError: (context, obj){
            print('Stream Provider error - weight');
            print(obj);
            return List<WeightData>();
          },
        ),
        // Streams Calorie Data stored in DB
        StreamProvider<List<CalorieData>>( 
          create:(_) => CalorieModel().calorieStream,
          catchError: (context, obj){
            print('Stream Provider error - calories');
            print(obj);
            return List<CalorieData>();
          },
        ),
        // Streams the current set Calorie Target 
        StreamProvider<CalorieTarget>(
          create:(_) => CalorieTargetModel().calorieTargetStream,
          initialData: new CalorieTarget(Constants.DEFAULT_CALORIE_TARGET),
          catchError: (context, obj){
            print('Stream Provider error - calorie target');
            print(obj);
            return new CalorieTarget(Constants.DEFAULT_CALORIE_TARGET);
          },
        ),
        // Streams the current set Goal Weight 
        StreamProvider<WeightTarget>(
          create:(_) => WeightTargetModel().weightTargetStream,
          initialData: new WeightTarget(Constants.DEFAULT_GOAL_WEIGHT),
          catchError: (context, obj){
            print('Stream Provider error - weight target');
            print(obj);
            return new WeightTarget(Constants.DEFAULT_GOAL_WEIGHT);
          },
        ),
      ],
      // So the user can get out of a keyboard by tapping anywhere outside the keyboard.
      child: GestureDetector(  
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        // Restart widget allows us to sert new key into CupertinoApp, restarting entire widget tree.
        // This is used only when user deletes all their data, so we don't have side effects from left over state.
        child: RestartWidget(
          child: CupertinoApp(
            title: 'Simple Weight',
            debugShowCheckedModeBanner: false,
            home: SimpleWeight(),
            builder: (BuildContext context, Widget child){

              // Configure theme color settings for Dark and Light Modes
              final Brightness brightness = MediaQuery.platformBrightnessOf(context);

              final Color textColor = brightness == Brightness.dark ?
                CupertinoColors.white : CupertinoColors.black;

              final Color primaryColor = brightness == Brightness.dark ? 
                CupertinoColors.activeBlue : CupertinoColors.activeBlue;

              final Color primaryContrastingColor = brightness == Brightness.dark ? 
                CupertinoColors.white : CupertinoColors.black;

              final Color barBackgroundColor = brightness == Brightness.dark ?
                Styles.darkBarBackground : Styles.lightBarBackground;

              final Color scaffoldBackgroundColor = brightness == Brightness.dark ? 
                CupertinoColors.black : CupertinoColors.white;

              return CupertinoTheme(
                data: CupertinoThemeData(
                  brightness: brightness,
                  primaryColor: primaryColor,
                  primaryContrastingColor: primaryContrastingColor,
                  barBackgroundColor: barBackgroundColor,
                  scaffoldBackgroundColor: scaffoldBackgroundColor,
                  textTheme: CupertinoTextThemeData(  
                    primaryColor: primaryColor,
                    textStyle: TextStyle(
                      color: primaryContrastingColor,
                    ),
                    navActionTextStyle: TextStyle(
                      color: primaryContrastingColor,
                    ),
                    actionTextStyle: TextStyle(
                      color: primaryContrastingColor,
                    ),
                  ),
                ),
                child: DefaultTextStyle.merge(
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                  ), 
                  child: child,
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}



