import 'package:flutter/material.dart';
import 'package:flutter_seekbar/flutter_seekbar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:test001/common/global.dart';
import '../route/chart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<SectionTextModel> sectionTexts = [];

  @override
  void initState() {
    super.initState();
    sectionTexts.add(SectionTextModel(
        position: 1, text: 'great', progressColor: Colors.teal));
    sectionTexts.add(SectionTextModel(
        position: 10, text: 'good', progressColor: Colors.teal));
    sectionTexts.add(SectionTextModel(
        position: 20, text: 'bad', progressColor: Colors.teal));
  }

  @override
  Widget build(BuildContext context) {
    Widget aLPI = Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 13),
            width: 200,
            child: SeekBar(
              progresseight: 10,
              backgroundColor: Color(BG_COLOR),
              progressColor: Colors.teal,
              indicatorRadius: 10,
              showSectionText: true,
              sectionTexts: sectionTexts,
              sectionCount: 20,
              sectionTextMarginTop: 2,
              sectionDecimal: 0,
              sectionTextColor: Colors.black,
              sectionSelectTextColor: Colors.teal,
              sectionTextSize: 14,
              value: 50, //0到100，后期改回用户个人的数据
              isCanTouch: false,
            ),
          ),
        ],
      ),
    );
    return Scaffold(
      body: StaggeredGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: <Widget>[
          _buildTile(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Text(
                      '您好！'+currentUser.username+'  欢迎来到抑郁症测试APP',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                      ),
                    ),
                    SizedBox(height: 15,),
                    Text(
                      '您的平均测试结果及历史测试结果：',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                      ),
                    ),
                    SizedBox(height: 15,),
                    aLPI,
                  ],
                ),
              ],
            ),
          ),
          _buildTile(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Padding(padding: EdgeInsets.only(bottom: 16.0)),
                CircularPercentIndicator(
                  radius: 70.0,
                  lineWidth: 10.0,
                  animation: true,
                  percent: 0.7,
                  center: new Text(
                    "70.0%",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 10.0),
                  ),
                  footer: new Text(
                    "测试结果",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 10.0),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Colors.teal,
                ),
              ],
            ),
          ),
          _buildTile(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Padding(padding: EdgeInsets.only(bottom: 16.0)),
                SizedBox(
                   width: 75,
                height: 75,
                  child: LiquidCircularProgressIndicator(
                  value: 0.7, // Defaults to 0.5.
                  valueColor: AlwaysStoppedAnimation(Colors.blue), // Defaults to the current Theme's accentColor.
                  backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
                  borderColor: Colors.teal,
                  borderWidth: 5.0,
                  // direction: Axis.horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                  center: Text("70"),
                ),),
                
              ],
            ),
          ),
          _buildTile(LineChartSample2()),
        ],
        staggeredTiles: [
          StaggeredTile.extent(2, 200.0),
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(2, 240.0),
        ],
      ),
    );
  }
}

Widget _buildTile(Widget child) {
  return Material(
    elevation: 5.0,
    borderRadius: BorderRadius.circular(18.0),
    shadowColor: Colors.teal,
    child: Padding(
      padding: EdgeInsets.all(12.0),
      child: child,
    ),
  );
}
