import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/database/calorie_data.dart';
import 'package:simple_weight/database/weight_data.dart';
import 'package:simple_weight/settings/settings_page.dart';
import 'package:simple_weight/styles/styles.dart';
import 'package:simple_weight/widgets/selected_graph_data.dart';
import 'package:simple_weight/widgets/stats_info_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:simple_weight/utils/time_convert.dart';
import 'package:simple_weight/utils/weight_analysis.dart';
import 'package:simple_weight/utils/calorie_analysis.dart';


/// Displays timeline graph of weight history and calorie history,
/// as well as general info on weight and calorie ie averages, min / max, etc.
class StatsTab extends StatefulWidget {
  @override 
  _StatsTabState createState() => _StatsTabState();
}

class _StatsTabState extends State<StatsTab>{
  
  // These hold data of tapped area on graph (selection)
  DateTime _selectedTime;
  Map<String, num> _selectedMeasurements = Map<String, num>();


  void _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime time;
    final Map<String, num> measurements = Map<String, num>();

    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.time;
      
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measurements[datumPair.series.displayName] = datumPair.datum.number;
      });
    }

    setState(() {
      _selectedTime = time;
      _selectedMeasurements = measurements;
    });
  }

  void _pushSettings(BuildContext context){
    Navigator.push(context, CupertinoPageRoute(
      builder: (BuildContext context) => SettingsPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    
    // All Weight and Calorie Data, these are required for everything 
    final List<WeightData> _weights = Provider.of<List<WeightData>>(context);
    final List<CalorieData> _calories = Provider.of<List<CalorieData>>(context);

    // Children for SliverListDelegate 
    // Holds Graph, Selected Data, and StatsInfoChart, or loading bar, or "No data" text
    List<Widget> _children = List<Widget>();

    // Configure gradient settings for Dark and Light Modes
    final Brightness brightness = MediaQuery.platformBrightnessOf(context);

    final List<Color> gradient = brightness == Brightness.dark ? Styles.darkGradient : Styles.lightGradient;

    // Still getting data show loading sign
    if(_calories == null || _weights == null){
      _children.add(
        Container( 
          decoration: BoxDecoration(  
            gradient: RadialGradient(
              colors: gradient,
              focalRadius: 0,
            ),
          ),
          padding: EdgeInsets.all(8),
          child: Center(
            child: SizedBox( 
              height: 340.0,
              child: CupertinoActivityIndicator(),
            ),
          ),
        )
      );
    }
    // Data comes up empty, show Text 
    else if(_calories.length == 0 || _weights.length == 0){
      _children.add(
        Container(
          padding: EdgeInsets.only(
            top: 250,
            bottom: 250,
          ),
          decoration: BoxDecoration(  
            gradient: SweepGradient(
              colors: gradient,
              tileMode: TileMode.repeated,
              endAngle: math.pi * 0.01,
            ),
          ),
          child: Center(
            child: Center(
              child: Text("Add Calorie and Weight Data!", style: Styles.biggerText,),
            ),
          ),
        )
      );
    }
    // We have Data, add Graph, SelectedGraphData, and StatsInfoChart to _children
    else{
      // Convert data into GraphData so the TimeSeries graph 
      // can use them (requires DateTime instead of String for 'time' field).
      final formattedWeights = _weights.map((weight) => 
        GraphData(
          time: weight.time, 
          number: weight.weight)
        ).toList();

      final formattedCalories = _calories.map((calorie) => 
        GraphData(
          time: calorie.time, 
          number: calorie.calories)
        ).toList();
      
      // These are the lines being drawn on the graph
      final _seriesLineData = <charts.Series<GraphData, DateTime>>[
        charts.Series(
          data: formattedWeights,
          id: 'Weight',
          domainFn: (GraphData weight, _) => weight.time,
          measureFn: (GraphData weight, _) => weight.number,
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(CupertinoColors.activeBlue),
        ),
        // The set attribute below makes the calories data
        // line up with secondary Y axis, which shows calorie numbers.
        charts.Series(
          data: formattedCalories,
          id: "Calories",
          domainFn: (GraphData calorie, _) => calorie.time,
          measureFn: (GraphData calorie, _) => calorie.number,
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(CupertinoColors.activeGreen),
        )..setAttribute(charts.measureAxisIdKey, 'secondaryMeasureAxisId'),
      ];
      
      // Display graph, graph must be given size by parent
      _children.add(
        SizedBox( 
          height: 470.0,
          //width: 300,
          child: charts.TimeSeriesChart(
            _seriesLineData,
            defaultRenderer: charts.LineRendererConfig(includeArea: false, stacked: false, includePoints: true),
            animate: false,
            primaryMeasureAxis: charts.NumericAxisSpec(
              tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false, desiredTickCount: 10)
            ),
            secondaryMeasureAxis: charts.NumericAxisSpec(
              tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false, desiredTickCount: 10)
            ),
            behaviors: [  
              charts.SeriesLegend(),
              charts.ChartTitle(
                'Date',
                behaviorPosition: charts.BehaviorPosition.bottom,
                titleOutsideJustification:charts.OutsideJustification.middleDrawArea
              ),
              charts.ChartTitle(
                'Weight',
                behaviorPosition: charts.BehaviorPosition.start,
                titleOutsideJustification: charts.OutsideJustification.middleDrawArea
              ),
              charts.ChartTitle(
                'Calories',
                behaviorPosition: charts.BehaviorPosition.end,
                titleOutsideJustification: charts.OutsideJustification.middleDrawArea
              ),
              charts.PanAndZoomBehavior(),
            ],
            selectionModels: [
              charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                changedListener: _onSelectionChanged,
              )
            ],
          ),
        ),
      );

      // SelectedGraphData 
      // Displays row of data from tapped point on graph
      _children.add(
        SelectedGraphData(
          time: _selectedTime, 
          measurements: _selectedMeasurements
        ),
      );

      // Analysis Classes are required for the StatsInfoChart below
      final weightAnalysis = WeightAnalysis(_weights);
      final calorieAnalysis = CalorieAnalysis(_calories);

      // StatsInfoChart
      // Displays general weight and calorie stats 
      _children.add( 
        StatsInfoChart(weightAnalysis, calorieAnalysis),
      );
    }
    
    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text('Stats'),
          trailing: CupertinoButton(
            onPressed: () => _pushSettings(context),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            minSize: 20,
            child: Icon(CupertinoIcons.settings),
          ),
          heroTag: "Stats Tab",
        ),
        SliverList( 
          delegate: SliverChildListDelegate(_children),
        ),
      ],
    );
  }
}


/// Series data type for TimeLine graph
/// Converts String time to DateTime so data works in TimeLine graph.
class GraphData {
  DateTime time;
  num number;

  GraphData({String time, num number}){
    this.number = number;
    this.time = TimeConvert().stringToDateTime(time);
  }
}