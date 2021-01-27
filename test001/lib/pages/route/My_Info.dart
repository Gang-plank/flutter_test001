import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test001/common/global.dart';
import 'package:test001/common/models.dart';

/*等后端服务器还需要改很多
用户默认头像的逻辑
api的更改
性别生日的debug
*/

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
      new TextEditingController(text: currentUser.gender==null?'保密':currentUser.gender);
  var date;
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Widget defaultImage = Stack(
    children: <Widget>[
      Align(
          // 默认头像图片放在左上方。
          alignment: Alignment.topLeft,
          child: ClipOval(
            child: CachedNetworkImage(
                      imageUrl: currentUser.avatar,
                      fit: BoxFit.cover,
                      height: 120,
                      width: 120,
                    ), 
          ),),
      Align(
        // 编辑头像图片放在右下方。
        alignment: Alignment.bottomRight,
        child: Image.asset(
          'assets/images/add.png',
          fit: BoxFit.contain,
          height: 30.0,
        ),
      ),
    ],
  );
  Widget ovalImage(File image) {
    return ClipOval(
      child: Image.file(
        image,
        fit: BoxFit.cover,
        height: 120.0,
        width: 120.0,
      ),
    );
  }

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
    _saveInfoReq();
  }

  Future _saveInfoReq() async {
    Dio dio = Dio();

    dio.options..baseUrl = MY_API;

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
      Fluttertoast.showToast(msg: "程序出错");
    }
  }

  @override
  Widget build(BuildContext context) {
    //头像
    final _avatarWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: getImage,
          child: Container(
            padding: EdgeInsets.all(10),
            width: 120,
            height: 120,
            child: defaultImage, //_image == null ? defaultImage : ovalImage(_image),  
          ),
        )
      ],
    );

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
              currentUser.birthday == null ? '保密' : currentUser.birthday,
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
            _avatarWidget,
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
