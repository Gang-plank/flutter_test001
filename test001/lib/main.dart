import 'package:base_library/base_library.dart';
import 'package:flutter/material.dart';
import 'config/constant.dart';
import 'pages/navigationbar.dart';
import 'pages/route/begin.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';

List<CameraDescription> cameras = [];

/* void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  cameras = await availableCameras();
  runApp(MyApp());
} */

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await SpUtil.getInstance();
    cameras = await availableCameras();
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
    setInitDir(initStorageDir: true);
    init();
  }

  void init() {
    //    DioUtil.openDebug();
    Options options = DioUtil.getDefOptions();
    options.baseUrl = Constant.server_address;
    String cookie = SpUtil.getString(BaseConstant.keyAppToken);
    if (ObjectUtil.isNotEmpty(cookie)) {
      Map<String, dynamic> _headers = new Map();
      _headers["Cookie"] = cookie;
      options.headers = _headers;
    }
    HttpConfig config = new HttpConfig(options: options);
    DioUtil().setConfig(config);
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e("sp is init ${SpUtil.isInitialized()}");
    return MaterialApp(
      routes: {
        BaseConstant.routeMain: (ctx) => NavigationBar(),
        BaseConstant.routeLogin: (ctx) => BeginPage(),
      },
      title: 'Flutter Demo',
      theme: new ThemeData(
        primaryColor:Colors.white
      ),

      home:/* NavigationBar(),  */Util.isLogin() ? NavigationBar():BeginPage(),
    );
  }
}



void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');