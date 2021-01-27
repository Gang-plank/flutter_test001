import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test001/common/global.dart';
import 'package:test001/common/models.dart';
import 'package:test001/pages/route/history.dart';
import 'package:test001/pages/route/questionTest.dart';
import 'package:test001/pages/route/result.dart';
import 'package:test001/pages/route/pictureTest.dart';
import 'pages/navigationbar.dart';
import 'pages/route/begin.dart';
import 'package:camera/camera.dart';


Future<void> main() async {
  try {
    //初始化部分
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    //验证登录部分
    SharedPreferences prefs = await SharedPreferences.getInstance();
    checkLogin = prefs.getString('userPhone');
    if (checkLogin != null) {
      currentUser = UserData.fromJson(jsonDecode(prefs.getString('user')));
      print(currentUser.toJson());
    }
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => checkLogin == null ? BeginPage() : NavigationBar(),
        //'/':(context) => QuestionTestPage(),
        //'/':(context) => HistoryPage(), 
        //'/':(context) => ResultPage(),

        "/NavigationBar": (context) => NavigationBar(),
        "/BeginPage": (context) => BeginPage(),
      },
      title: '抑郁症测试',
      theme: new ThemeData(primaryColor: Colors.white),
    );
  }
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');
