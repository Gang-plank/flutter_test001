import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:test001/common/global.dart';
import 'package:test001/common/questionData.dart';
import 'package:test001/common/models.dart';

class ResultPage extends StatefulWidget {
  ResultPage({Key key, this.result}) : super(key: key);
  final result; //定义一个result接受页面传值，要加final，否则提示@immutable

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  TestData testResult;
  @override
  Widget build(BuildContext context) {
    //TestEntity _myEntity = TestEntity.fromJson(widget.result); //开发调试，先给它初始化，到时再改回 //这个页面是成功后才弹出来的，再在这里设置查错略显冗余

    //testResult = _myEntity.data;  //开发调试，先给它初始化，到时再改回
    testResult = new TestData('7', '2021-01-15', '问答测试'); //开发调试，先给它初始化，到时再改回

    return Scaffold(
      appBar: AppBar(
        title: Text('测试结果'),
      ),
      body: StaggeredGridView.count(
        crossAxisCount: 1,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          _buildTile(
            Stack(
              alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    '本次测试得分',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 28.0),
                  ),
                ),
                Text(
                  testResult.score,
                  style: TextStyle(
                      color: Colors.black,
                      //fontWeight: FontWeight.w600,
                      fontSize: 36.0),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('测试类型：' + testResult.testType,
                      style: TextStyle(color: Colors.black45)),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text('测试日期：' + testResult.testDate,
                      style: TextStyle(color: Colors.black45)),
                ),
              ],
            ),
          ),
          _buildTile(
            Container(
              alignment: Alignment.center,
              width: 50,
              height: 50,
              child: Text(
                '属于轻度抑郁',
                style: TextStyle(
                    color: Colors.black,
                    //fontWeight: FontWeight.w600,
                    fontSize: 36.0),
              ),
            ),
          ),
          // _buildTile(
          //   Container(
          //     width: 50,
          //     height: 50,
          //     child: Text('TODO:文章'),
          //   ),
          // ),
        ],
        staggeredTiles: [
          StaggeredTile.extent(1, 200.0),
          StaggeredTile.extent(1, 150.0),
          //StaggeredTile.extent(1, 150.0),
        ],
      ),
    );
  }

  Widget _buildTile(Widget child) {
    return Material(
      elevation: 1.0, //阴影
      borderRadius: BorderRadius.circular(18.0),
      shadowColor: Colors.blueAccent,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }
}
