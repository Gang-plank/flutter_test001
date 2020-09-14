import 'package:flutter/material.dart';
import '../route/chart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      LineChart(),
      
    ]);
  }
}
