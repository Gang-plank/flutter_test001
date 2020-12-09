import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test001/common/global.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List dataList;
  @override
  void initState() {
    super.initState();
    getHistoryData().then((value) {
      setState(() {
        dataList = value['data'].toList();
      });
    });
  }

  Future getHistoryData() async {
    Dio dio = Dio();
    dio.options..baseUrl = MY_API;
    try {
      Response response = await dio
          .get('/testdata', queryParameters: {'phone': currentUser.phone});
      return response.data;
    } catch (e) {
      return print(e);
    }
  }

  Widget _listWidget() {
    List<Widget> _tiles = []; //先建一个数组用于存放循环生成的widget
    for (var item in dataList) {
      _tiles.add(
        new Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(item['date'], style: TextStyle(fontSize: 28)),
                    subtitle: Text(item['score']),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Column(children: _tiles);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('历史记录'),
      ),
      body: dataList == null
          ? Container(
              alignment: Alignment.center,
              child: Text(
                "正在加载",
                textAlign: TextAlign.center,
              ),
            )
          : SingleChildScrollView(
              child: _listWidget(),
            ),
    );
  }
}
