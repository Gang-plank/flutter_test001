import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class HistoricalTestData {
  DateTime time;
  int point;
  charts.Color barColor;
  HistoricalTestData(
    this.time,
    this.point,
  );
}

class LineChart extends StatelessWidget {
  final data = [
    new HistoricalTestData(new DateTime(2020, 7, 15), 12),
    new HistoricalTestData(new DateTime(2020, 7, 25), 15),
    new HistoricalTestData(new DateTime(2020, 8, 1), 19),
    new HistoricalTestData(new DateTime(2020, 8, 10), 14),
    new HistoricalTestData(new DateTime(2020, 8, 25), 26),
    new HistoricalTestData(new DateTime(2020, 9, 8), 58),
  ];

  _getSeriesData() {
    List<charts.Series<HistoricalTestData, DateTime>> series = [
      charts.Series(
          id: "HistoricalTest",
          data: data,
          domainFn: (HistoricalTestData series, _) => series.time,
          measureFn: (HistoricalTestData series, _) => series.point,
          colorFn: (HistoricalTestData series, _) =>
              charts.MaterialPalette.blue.shadeDefault)
    ];
    return series;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        height: MediaQuery.of(context).size.width*0.6,
        padding: EdgeInsets.all(10),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Historical data line chart",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: charts.TimeSeriesChart(
                    _getSeriesData(),
                    animate: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
