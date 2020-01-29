import 'package:flutter/cupertino.dart';
import 'package:simple_weight/icons/scale_icon.dart';
import 'package:simple_weight/icons/silverware_icon.dart';
import 'package:simple_weight/icons/stats_icon.dart';
import 'package:simple_weight/tabs/weights_tab.dart';
import 'package:simple_weight/tabs/calories_tab.dart';
import 'package:simple_weight/tabs/stats_tab.dart';

class SimpleWeight extends StatelessWidget{
  @override  
  Widget build(BuildContext context){
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(StatsIcon.loss),
            title: Text('Stats'),
          ),
          BottomNavigationBarItem(
            icon: Icon(SilverwareIcon.cutlery),
            title: Text('Calories'),
          ),
          BottomNavigationBarItem(
            icon: Icon(ScaleIcon.weight),
            title: Text('Weight'),
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index){
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: StatsTab(),
              );
            });
          case 1:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: CaloriesTab(),
              );
            });
          case 2:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: WeightsTab(),
              );
            });
        }
      },
    );
  }
}