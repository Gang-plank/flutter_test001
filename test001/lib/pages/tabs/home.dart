import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:test001/common/global.dart';
import '../route/chart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StaggeredGridView.count(
        crossAxisCount: 1,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: <Widget>[
          _buildTile(
            Stack(
              alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '您好！' + currentUser.username,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 22.0,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    '今天心情如何？\n要进行测试吗？',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildTile(
            Stack(
              alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '最近测试',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 22.0),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('测试类型：问答测试',
                      style: TextStyle(color: Colors.black45)),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text('测试日期：2020-11-12',
                      style: TextStyle(color: Colors.black45)),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('测试分数：16', style: TextStyle(fontSize: 24)),
                      Text('测试结果：中度抑郁', style: TextStyle(fontSize: 24))
                    ],)
              ],
            ),
          ),
          _buildTile(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '历史曲线(近7次测试)',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 22.0,
                  ),
                ),
                Container(
                  child: LineChartSample2(),
                ),
              ],
            ),
          ),
          _buildTile(
            Container(
              width: 50,
              height: 50,
              child: Text('TODO:文章'),
            ),
          ),
        ],
        staggeredTiles: [
          StaggeredTile.extent(1, 100.0),
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(1, 270.0),
          StaggeredTile.extent(1, 240.0),
        ],
      ),
    );
  }
}

Widget _buildTile(Widget child) {
  return Material(
    elevation: 1.0, //阴影
    borderRadius: BorderRadius.circular(18.0),
    shadowColor: Color(0x802196F3),
    child: Padding(
      padding: EdgeInsets.all(10.0),
      child: child,
    ),
  );
}
