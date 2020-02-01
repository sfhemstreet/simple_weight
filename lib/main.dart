import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/database/weight_data.dart';
import 'package:simple_weight/database/calorie_data.dart';
import 'package:simple_weight/models/calorie_model.dart';
import 'package:simple_weight/models/weight_model.dart';
import 'package:simple_weight/simple_weight.dart';

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
            debugPrint('Stream Provider error - weight');
            debugPrint(obj);
            return List<WeightData>();
          },
        ),
        // Streams Calorie Data stored in DB
        StreamProvider<List<CalorieData>>( 
          create:(_) => CalorieModel().calorieStream,
          catchError: (context, obj){
            debugPrint('Stream Provider error - calories');
            debugPrint(obj);
            return List<CalorieData>();
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
        child: CupertinoApp(
          title: 'Simple Weight',
          debugShowCheckedModeBanner: false,
          home: SimpleWeight(),
          /*
          builder: (BuildContext context, Widget child){
            Brightness brightness = MediaQuery.platformBrightnessOf(context);

            Color primaryColor = brightness == Brightness.dark ? 
              CupertinoColors.activeBlue : CupertinoColors.activeBlue;

            Color primaryContrastingColor = brightness == Brightness.dark ? 
              CupertinoColors.white : CupertinoColors.black;


            return CupertinoTheme(
              data: CupertinoThemeData(
                brightness: brightness,
                primaryColor: primaryColor,
                primaryContrastingColor: primaryContrastingColor,
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
              child: child,
            );
          }
          */
        ),
      ),
    );
  }
}
