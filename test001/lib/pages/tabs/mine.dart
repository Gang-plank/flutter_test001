
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test001/common/global.dart';
import '../route/my_Info.dart';
import '../route/history.dart';

class MineModel {
  String assets;
  String title;
  bool isDownDivider;

  MineModel({this.assets, this.title, this.isDownDivider});
}

class MineApi {
  static List<MineModel> mock() {
    List<MineModel> _mineModels = [];
    _mineModels.add(MineModel(
        assets: "assets/images/person.png", title: "个人信息", isDownDivider: false));
    _mineModels.add(MineModel(
        assets: "assets/images/history.png", title: "历史记录", isDownDivider: true));
    _mineModels.add(MineModel(
        assets: "assets/images/exit.png", title: "退出登录", isDownDivider: true));
    return _mineModels;
  }
}

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  List<MineModel> _mineModels = [];

  @override
  void initState() {
    /// 模拟初始化数据
    super.initState();
    _mineModels.addAll(MineApi.mock());
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    list.add(_mineAccountItem()); //头部，头像那部分
    list.add(Container(
      //头部与下面选项的背景色部分
      height: 10,
      color: Color(BG_COLOR),
    ));
    _mineModels.forEach((o) {
      //每个选项，逐一构建
      list.add(_mineItem(assets: o.assets, title: o.title));
      if (o.isDownDivider) {
        list.add(Container(
          //选项间的背景色部分
          height: 10,
          color: Color(BG_COLOR),
        ));
      } else {
        list.add(Divider(
          //选项间的横线
          height: 1,
          color: Colors.grey[400],
          indent: 60,
        ));
      }
    });
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        color: Color(BG_COLOR),
        child: Column(
          children: list,
        ),
      ),
    );
  }

  Widget _mineItem({String assets, String title}) {
    //各个选项
    return InkWell(
      child: Container(
        color: Colors.white,
        width: double.maxFinite,
        padding: EdgeInsets.only(bottom: 7, top: 7),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, //将主轴空白位置进行均分，排列子元素，首尾没有空隙
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  //这个container装图标
                  padding:
                      EdgeInsets.only(left: 10, right: 20, bottom: 7, top: 7),
                  child: Image.asset(
                    assets,
                    height: 30,
                    width: 30,
                  ),
                ),
                Container(
                  //这个container装文字
                  child: Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black87),
                  ),
                )
              ],
            ),
            Container(
              //这个container装箭头
              padding: EdgeInsets.only(right: 10, left: 8),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 15,
              ),
            )
          ],
        ),
      ),
      onTap: () async {
        switch (title) {
          case '个人信息':
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MyInfoPage();
              }));
            }
            break;
          case '历史记录':
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HistoryPage();
              }));
            }
            break;
          case '退出登录':
            {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('userPhone');
              prefs.remove('user');
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/BeginPage', (Route<dynamic> route) => false);
            }
            break;
        }
      },
    );
  }

  /// 我的账号的信息 包括头像 名称 id 那部分
  Widget _mineAccountItem() {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 25, bottom: 20, right: 50),
      width: double.maxFinite,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                   CachedNetworkImage(
                      imageUrl: currentUser.avatar,
                      fit: BoxFit.cover,
                      height: 60,
                      width: 60,
                    ), 
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  currentUser.username, //用户昵称
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(right: 40),
                      child: Text(
                        currentUser.phone, //用户ID
                        style: TextStyle(color: Colors.grey, fontSize: 17),
                      ),
                    ),
                  ]),
            ],
          )
        ],
      ),
    );
  }
}




  Future<Null> loadCache() async {
    Directory tempDir = await getTemporaryDirectory();
      double value = await _getTotalSizeOfFilesInDir(tempDir);
      tempDir.list(followLinks: false,recursive: true).listen((file){
          //打印每个缓存文件的路径
        print(file.path);
      });
      print('临时目录大小: ' + value.toString());
      String _cacheSizeStr = _renderSize(value);
      print(_cacheSizeStr);
      /* setState(() {
        _cacheSizeStr = _renderSize(value);  // _cacheSizeStr用来存储大小的值
      }); */
  }

    Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
         int length = await file.length();
         return double.parse(length.toString());
    }
   if (file is Directory) {
         final List<FileSystemEntity> children = file.listSync();
         double total = 0;
         if (children != null)
              for (final FileSystemEntity child in children)
                total += await _getTotalSizeOfFilesInDir(child);
         return total;
      }
      return 0;
  }

    _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = List()
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

  void _clearCache() async {
    Directory tempDir = await getTemporaryDirectory();
      //删除缓存目录
      await delDir(tempDir);
      await loadCache();
      Fluttertoast.showToast(msg: '清除缓存成功');
  }
  ///递归方式删除目录
  Future<Null> delDir(FileSystemEntity file) async {
    if (file is Directory) {
            final List<FileSystemEntity> children = file.listSync();
            for (final FileSystemEntity child in children) {
              await delDir(child);
            }
          }
      await file.delete();
  }