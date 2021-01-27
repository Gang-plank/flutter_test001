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
    getHistoryData().then((v) {
      setState(() {
        dataList = v['data'].toList();
      });
    });
  }

  Future getHistoryData() async {
    Dio dio = Dio();
    dio.options..baseUrl = MY_API;
    try {
      Response response = await dio.post('/testHistory',
          data: FormData.fromMap({
            "phone": currentUser.phone,
          }));
      return response.data;
    } catch (e) {
      return print(e);
    }
  }

  Widget _listWidget() {
    List<Widget> _tiles = []; //先建一个数组用于存放循环生成的widget
    for (var item in dataList) {
      _tiles.add(
        new Card(
          margin: EdgeInsets.all(10), //卡片间距
          child: Container(
              padding: EdgeInsets.all(20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('测试时间：'+item['testDate'], style: TextStyle(fontSize: 15)),
                    Text('测试结果：'+item['score'], style: TextStyle(fontSize: 15)),
                  ])),
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
                "正在加载...",
                textAlign: TextAlign.center,
              ),
            )
          : SingleChildScrollView(
              child: _listWidget(),
            ),
    );
  }
}
