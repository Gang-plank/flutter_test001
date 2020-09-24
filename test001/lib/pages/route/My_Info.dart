import 'package:flutter/material.dart';
import 'package:test001/common/global.dart';
import 'package:test001/pages/navigationbar.dart';

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

  _showDatePicker() async {
    var date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1970),
        lastDate: DateTime(2050));
    setState(() {
      currentUser.birthday = date;
    });
  }

  _saveInfo() async{

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
      autofocus: false,
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
              currentUser.birthday == null
                  ? '点击以设置'
                  : currentUser.birthday.toString().split(" ")[0],
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
        onPressed: () {//保存信息
          _saveInfo();
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue,
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
