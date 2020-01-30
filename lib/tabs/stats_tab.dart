import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/database/calorie_data.dart';
import 'package:simple_weight/database/weight_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:simple_weight/utils/time_convert.dart';


class StatsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final _weights = Provider.of<List<WeightData>>(context);
    final _calories = Provider.of<List<CalorieData>>(context);

    List<Widget> _children = [];

    if(_calories == null || _weights == null){
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
        Padding( 
          padding: EdgeInsets.all(8),
          child: StatsGraph(_weights, _calories),
        )
      );
    }
    
    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text('Calories'),
        ),
        SliverPadding( 
          padding: EdgeInsets.all(10),
          sliver: SliverList( 
            delegate: SliverChildListDelegate(_children),
          ),
        ),
      ],
    );
  }
}

class StatsGraph extends StatefulWidget {
  final List<WeightData> weightData;
  final List<CalorieData> calorieData;

  StatsGraph(this.weightData, this.calorieData);

  @override 
  _StatsGraphState createState() => _StatsGraphState();
}

class _StatsGraphState extends State<StatsGraph> {
  DateTime _selectedTime;
  Map<String, num> _selectedMeasurements;

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime time;
    final measurements = <String, num>{};

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

  @override
  Widget build(BuildContext context) {
    // Convert data into GraphData so the TimeSeries graph can use them (requires DateTime instead of String for 'time' field).
    final formattedWeights = widget.weightData.map((weight) => 
      GraphData(
        time: weight.time, 
        number: weight.weight)
      ).toList();

    final formattedCalories = widget.calorieData.map((calorie) => 
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
    
    return Column(
      children: [
        SizedBox( 
          height: 350,
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
        SelectedData(
          time: _selectedTime, 
          measurements: _selectedMeasurements
        ),
      ],
    );
  }
}

/// Displays data from tapped area of graph.
class SelectedData extends StatelessWidget {
  String time;
  Map<String, num> measurements;

  SelectedData({DateTime time, Map<String, num> measurements}){
    this.time = time != null ? new TimeConvert().toFormattedString(time) : null;
    this.measurements = measurements;
  }

  @override 
  Widget build(BuildContext context){
    List<Widget> children = [];
    if (time != null) {
      children.add(
        Padding(
          padding: EdgeInsets.only(bottom: 7.0),
          child: Text(time, style: TextStyle(fontWeight: FontWeight.bold),),
        ),
      );

      measurements?.forEach((String series, num value) {
        children.add(Text('${series}: ${value}'));
      });
    }
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Padding( 
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
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
    this.time = new TimeConvert().toDateTime(time);
  }
}