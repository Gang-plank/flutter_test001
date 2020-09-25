import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test001/common/global.dart';
import 'package:test001/config/models.dart';

class MyInfoPage extends StatefulWidget {
  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  TextEditingController _controllerUsername =
      new TextEditingController(text: currentUser.username);
  TextEditingController _controllerPhone =
      new TextEditingController(text: currentUser.phone);
  TextEditingController _controllerGender =
      new TextEditingController(text: currentUser.gender);
  var date;
  _showDatePicker() async {
    date = await showDatePicker(
        context: context,
        initialDate: DateTime(2000),
        firstDate: DateTime(1950),
        lastDate: DateTime(2020));
    setState(() {
      currentUser.birthday = date.toString().split(' ')[0];
    });
  }

  _saveInfo() {
    String _username = _controllerUsername.text;
    String _phone = _controllerPhone.text;
    //String _gender = _controllerGender.text;
    if (_username.isEmpty || _username.length > 15) {
      Fluttertoast.showToast(
        msg: "请输入正确的用户名",
      );
      return;
    }
    if (_phone.isEmpty || _phone.length < 10 || _phone.length > 15) {
      Fluttertoast.showToast(
        msg: "请输入正确的手机号",
      );
      return;
    }
    /* if(_gender!='男'||_gender!='女'){
      Fluttertoast.showToast(
        msg: "请输入性别",
      );
      return;
    } */
    _saveInfoReq();
  }

  Future _saveInfoReq() async {
    Dio dio = Dio();

    dio.options..baseUrl = 'http://10.0.3.2:5000';
    try {
      // 发起请求
      Response response = await dio.post('/user/info',
          data: FormData.fromMap({
            "phone": _controllerPhone.text.trim(),
            "username": _controllerUsername.text.trim(),
            "gender": _controllerGender.text.trim(),
            "birthday": date.toString().split(' ')[0],
          }));

      if (response.statusCode == 200) {
        UserEntity user = UserEntity.fromJson(response.data);
        print(response.statusCode);
        if (user.errorCode == 0) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userPhone', user.data.phone);
          prefs.setString('user', jsonEncode(user.data.toJson()));
          currentUser = user.data;
          print(currentUser.toJson());
          Fluttertoast.showToast(msg: "保存成功");
        } else {
          Fluttertoast.showToast(msg: "保存失败：${user.errorMsg}");
        }
      } else {
        Fluttertoast.showToast(msg: "保存失败：${response.statusCode}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "无网络连接");
    }
  }

  @override
  Widget build(BuildContext context) {
    //昵称框
    final _usernameWidget = TextFormField(
      controller: _controllerUsername,
      decoration: InputDecoration(
        labelText: '昵称',
        labelStyle: TextStyle(color: Colors.black54),
        contentPadding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 10.0),
        border:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      ),
    );

    //手机号框
    final _phoneWidget = TextFormField(
      controller: _controllerPhone,
      keyboardType: TextInputType.phone,
      enabled: false,
      decoration: InputDecoration(
        labelText: '手机号',
        labelStyle: TextStyle(color: Colors.black54),
        contentPadding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 10.0),
        border:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      ),
    );

    final _genderWidget = TextFormField(
      controller: _controllerGender,
      decoration: InputDecoration(
        labelText: '性别',
        labelStyle: TextStyle(color: Colors.black54),
        contentPadding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 10.0),
        border:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      ),
    );

    final _birthdayWidget = InkWell(
      onTap: () {
        _showDatePicker();
      },
      child: Container(
        padding: EdgeInsets.all(10),
        width: double.maxFinite,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                child: Text(
              '生日',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.black54,
              ),
            )),
            Container(
                child: Text(
               currentUser.birthday=='null'?'点击以设置':currentUser.birthday,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.black,
              ),
            ))
          ],
        ),
      ),
    );
    final _saveButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        onPressed: () {
          //保存信息
          _saveInfo();
        },
        padding: EdgeInsets.all(12),
        color: Colors.black,
        child: Text('保存', style: TextStyle(color: Colors.white)),
      ),
    );
    return Scaffold(
      appBar: AppBar(title: Text('个人信息')),
      body: Center(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
            ),
            SizedBox(
              height: 20,
            ),
            _usernameWidget,
            SizedBox(
              height: 20,
            ),
            _phoneWidget,
            SizedBox(
              height: 20,
            ),
            _genderWidget,
            SizedBox(
              height: 20,
            ),
            _birthdayWidget,
            SizedBox(
              height: 10,
            ),
            _saveButton
          ],
        ),
      ),
    );
  }
}
