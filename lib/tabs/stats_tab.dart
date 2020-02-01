import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/database/calorie_data.dart';
import 'package:simple_weight/database/weight_data.dart';
import 'package:simple_weight/widgets/stats_graph.dart';
import 'package:simple_weight/widgets/stats_info_chart.dart';

class StatsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final List<WeightData> _weights = Provider.of<List<WeightData>>(context);
    final List<CalorieData> _calories = Provider.of<List<CalorieData>>(context);

    List<Widget> _children = [];

    if(_calories == null || _weights == null || _calories.length <= 0 || _weights.length <= 0){
      _children.add(
        Padding( 
          padding: EdgeInsets.all(8),
          child: Center(
            child: SizedBox( 
              height: 400,
              child: CupertinoActivityIndicator(),
            ),
          ),
        )
      );
    }
    else{
      _children.add(
        StatsGraph(weightData: _weights,calorieData: _calories),
      );
      _children.add( 
        StatsInfoChart(weightData: _weights, calorieData: _calories),
      );
    }
    
    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text('Stats'),
        ),
        SliverPadding( 
          padding: EdgeInsets.all(0),
          sliver: SliverList( 
            delegate: SliverChildListDelegate(_children),
          ),
        ),
      ],
    );
  }
}
