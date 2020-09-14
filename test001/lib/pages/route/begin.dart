import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class BeginPage extends StatefulWidget {
  @override
  _BeginPageState createState() => new _BeginPageState();
}

class _BeginPageState extends State<BeginPage> {
  Widget body() {
    var buttons = [
      SizedBox(
        width: 120,
        height: 60,
        child: RaisedButton(
          //为什么要设置左右padding，因为如果不设置，那么会挤压文字空间
          padding: EdgeInsets.symmetric(horizontal: 8),
          //文字颜色
          textColor: Colors.black87,
          //按钮颜色
          color: Colors.blueGrey,
          //画圆角
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          //如果使用FlatButton，必须初始化onPressed这个方法
          onPressed: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LoginPage();
          })),
          child: Text(
            '登录',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      SizedBox(
        width: 120,
        height: 60,
        child: RaisedButton(
          //为什么要设置左右padding，因为如果不设置，那么会挤压文字空间
          padding: EdgeInsets.symmetric(horizontal: 8),
          //文字颜色
          textColor: Colors.black87,
          //按钮颜色
          color: Colors.blueGrey,
          //画圆角
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onPressed: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RegisterPage();
          })),
          child: Text(
            '注册',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: buttons,
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bodyMain = new Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/begin.png'), fit: BoxFit.cover)),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: body(),
    );

    return new Scaffold(body: bodyMain);
  }
}
