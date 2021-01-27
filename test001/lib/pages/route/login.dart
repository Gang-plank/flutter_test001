import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test001/common/global.dart';
import 'package:test001/common/models.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _controllerPhone = new TextEditingController();
  TextEditingController _controllerPwd = new TextEditingController();

  Future _loginReq() async {
    Dio dio = Dio();

    dio.options..baseUrl = MY_API;

    try {
      // 发起请求
      Response response = await dio.post('/user/login',
          data: FormData.fromMap({
            "phone": _controllerPhone.text.trim(),
            "password": _controllerPwd.text.trim(),
          }));

      if (response.statusCode == 200) {
        UserEntity user = UserEntity.fromJson(response.data);
        if (user.errorCode == 0) {
          //登录成功后 保存信息
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userPhone', user.data.phone);
          prefs.setString('user', jsonEncode(user.data.toJson()));
          currentUser=user.data;
          print(currentUser.toJson());
          /*  print(prefs.getString('user'));
          print(jsonDecode(prefs.getString('user')));
          UserData testm=UserData.fromJson(jsonDecode(prefs.getString('user')));
          print(testm.phone); */ //测试代码

          Fluttertoast.showToast(msg: "登录成功");

          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/NavigationBar', (Route<dynamic> route) => false);
          });
        } else {
          Fluttertoast.showToast(msg: '登录失败：${user.errorMsg}');
        }
      } else {
        Fluttertoast.showToast(msg: '网络请求异常：${response.statusCode}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "服务出错，无网络连接");
    }
  }

  void _login() {
    String _phone = _controllerPhone.text;
    String _password = _controllerPwd.text;
    if (_phone.isEmpty || _phone.length < 10) {
      Fluttertoast.showToast(
        msg: "请输入正确的手机号",
      );
      return;
    }
    if (_password.isEmpty || _password.length < 6) {
      Fluttertoast.showToast(msg: "请输入密码");
      return;
    }
    _loginReq();
  }

  @override
  Widget build(BuildContext context) {
    //登录框
    final phone = TextFormField(
      controller: _controllerPhone,
      keyboardType: TextInputType.phone,
      autofocus: false,
      decoration: InputDecoration(
          icon: Icon(Icons.phone, color: Colors.grey),
          hintText: '手机号',
          contentPadding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 10.0),
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black26)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black))),
    );

    //密码框
    final password = TextFormField(
      controller: _controllerPwd,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
          icon: Icon(Icons.lock, color: Colors.grey),
          hintText: '密码',
          contentPadding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 10.0),
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black26)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black))),
    );
    //登录按钮
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        onPressed: () {
          //跳路由
          _login();
        },
        padding: EdgeInsets.all(12),
        color: Colors.black,
        child: Text('登录', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 20.0),
          children: <Widget>[
            new Text(
              "登录",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 48.0),
            phone,
            SizedBox(height: 28.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
          ],
        ),
      ),
    );
  }
}
