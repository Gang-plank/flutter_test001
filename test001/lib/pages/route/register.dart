import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test001/common/global.dart';
import 'package:test001/config/models.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _controllerUsername = new TextEditingController();
  TextEditingController _controllerPhone = new TextEditingController();
  TextEditingController _controllerPwd = new TextEditingController();
  TextEditingController _controllerRePwd = new TextEditingController();

  Future _registerReq() async {
    Dio dio = Dio();

    dio.options..baseUrl = MY_API;
    try {
      // 发起请求
      Response response = await dio.post('/user/register',
          data: FormData.fromMap({
            "username": _controllerUsername.text.trim(),
            "phone": _controllerPhone.text.trim(),
            "password": _controllerPwd.text.trim(),
          }));

      if (response.statusCode == 200) {
        UserEntity user = UserEntity.fromJson(response.data);
        if (user.errorCode == 0) {
          Fluttertoast.showToast(msg: "注册成功");
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop();
          });
        } else {
          Fluttertoast.showToast(msg: "注册失败：${user.errorMsg}");
        }
      } else {
        Fluttertoast.showToast(msg: "注册失败：${response.statusCode}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "无网络连接");
    }
  }

  void _register() {
    String _phone = _controllerPhone.text;
    String _password = _controllerPwd.text;
    String _rePassword = _controllerRePwd.text;
    if (_phone.isEmpty || _phone.length < 10 || _phone.length > 15) {
      Fluttertoast.showToast(
        msg: "请输入正确的手机号",
      );
      return;
    }
    if (_password.isEmpty || _password.length < 6) {
      Fluttertoast.showToast(msg: "密码至少6位");
      return;
    }
    if (_rePassword.isEmpty || _rePassword.length < 6) {
      Fluttertoast.showToast(msg: "确认密码");
      return;
    }
    if (_password != _rePassword) {
      Fluttertoast.showToast(msg: "密码不一致");
      return;
    }
    _registerReq();
  }

  @override
  Widget build(BuildContext context) {
    //昵称框
    final _usernameWidget = TextFormField(
      controller: _controllerUsername,
      autofocus: false,
      decoration: InputDecoration(
        icon: Icon(Icons.person, color: Colors.grey),
        hintText: '昵称',
        contentPadding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 10.0),
        border:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      ),
    );
    //登录框
    final _phoneWidget = TextFormField(
      controller: _controllerPhone,
      keyboardType: TextInputType.phone,
      autofocus: false,
      decoration: InputDecoration(
        icon: Icon(Icons.phone, color: Colors.grey),
        hintText: '手机号',
        contentPadding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 10.0),
        border:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      ),
    );

    //密码框
    final _passwordWidget = TextFormField(
      controller: _controllerPwd,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
          icon: Icon(
            Icons.lock_open,
            color: Colors.grey,
          ),
          hintText: '密码',
          contentPadding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 10.0),
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black26)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black))),
    );

    //确认密码框
    final _rePasswordWidget = TextFormField(
      controller: _controllerRePwd,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
          icon: Icon(Icons.lock_outline, color: Colors.grey),
          hintText: '确认密码',
          contentPadding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 10.0),
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black26)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black))),
    );

    //按钮
    final registerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        onPressed: () {
          //push新路由
          //zhuce
          //新函数
          _register();
        },
        padding: EdgeInsets.all(12),
        color: Colors.black,
        child: Text('注册', style: TextStyle(color: Colors.white)),
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
              "注册",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30.0),
            _usernameWidget,
            SizedBox(height: 28.0),
            _phoneWidget,
            SizedBox(height: 28.0),
            _passwordWidget,
            SizedBox(height: 28.0),
            _rePasswordWidget,
            SizedBox(height: 24.0),
            registerButton,
          ],
        ),
      ),
    );
  }
}
