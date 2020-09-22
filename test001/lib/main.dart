import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test001/config/models.dart';
import 'pages/navigationbar.dart';
import 'pages/route/begin.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];

String phone='';
Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('userPhone'); 
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
        '/': (context) => phone==null?BeginPage():NavigationBar(),
        "/NavigationBar": (context) => NavigationBar(),
        "/BeginPage": (context) => BeginPage(),
      },
      title: 'Flutter Demo',
      theme: new ThemeData(primaryColor: Colors.white),
     // home: phone == null ? BeginPage() : NavigationBar()
    );
  }
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');
