import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/database/calorie_data.dart';
import 'package:simple_weight/database/weight_data.dart';
import 'package:simple_weight/styles/styles.dart';
import 'package:simple_weight/settings/settings_page.dart';
import 'package:simple_weight/widgets/stats_info_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:simple_weight/utils/time_convert.dart';

class StatsTab extends StatefulWidget {
  @override 
  _StatsTabState createState() => _StatsTabState();
}

class _StatsTabState extends State<StatsTab>{
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
      builder: (context) => SettingsPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    
    final List<WeightData> _weights = Provider.of<List<WeightData>>(context);
    final List<CalorieData> _calories = Provider.of<List<CalorieData>>(context);

    List<Widget> _children = List<Widget>();

    if(_calories == null || _weights == null){
      _children.add(
        Padding( 
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
    else{
      // Convert data into GraphData so the TimeSeries graph can use them (requires DateTime instead of String for 'time' field).
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
      
      final _seriesLineData = List<charts.Series<GraphData, DateTime>>();
      
      _seriesLineData.add(
        charts.Series(
          data: formattedWeights,
          id: 'Weight',
          domainFn: (GraphData weight, _) => weight.time,
          measureFn: (GraphData weight, _) => weight.number,
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(CupertinoColors.activeBlue),
        )
      );

      // The set attribute makes it line up with secondary Y axis showing calorie numbers
      _seriesLineData.add(
        charts.Series(
          data: formattedCalories,
          id: "Calories",
          domainFn: (GraphData calorie, _) => calorie.time,
          measureFn: (GraphData calorie, _) => calorie.number,
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(CupertinoColors.activeGreen),
        )..setAttribute(charts.measureAxisIdKey, 'secondaryMeasureAxisId'),
      );
      
      _children.add(
        SizedBox( 
          height: 470.0,
          width: 300,
          child: charts.TimeSeriesChart(
            _seriesLineData,
            defaultRenderer: charts.LineRendererConfig(includeArea: false, stacked: true, includePoints: true),
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

      // Displays row of data from tapped point on graph
      _children.add(
        SelectedData(
          time: _selectedTime, 
          measurements: _selectedMeasurements
        ),
      );

      // Displays general weight and calorie stats 
      _children.add( 
        StatsInfoChart(
          weightData: _weights, 
          calorieData: _calories
        ),
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

/// Displays data from tapped area of graph.
class SelectedData extends StatelessWidget {
  final DateTime time;
  final Map<String, num> measurements;

  SelectedData({this.time, this.measurements});

  @override 
  Widget build(BuildContext context){
    List<Widget> children = [];
    
    if (time != null) {
      children.add(
        Text(TimeConvert().dateTimeToFormattedString(time))
      );

      measurements?.forEach((String series, num value) {
        children.add(
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: '$series: ', style: Styles.descriptor),
                TextSpan(text: '$value', style: DefaultTextStyle.of(context).style),
              ],
            ),
          ),
        );
      });
    } else {
      children.add(Text(" "));
    }
    
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

/// Graph needs to know whats Series it needs, convert WeightData and CalorieData to this.
class GraphData {
  DateTime time;
  num number;

  GraphData({String time, num number}){
    this.number = number;
    this.time = TimeConvert().stringToDateTime(time);
  }
}