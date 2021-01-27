import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/date_symbol_data_local.dart';
import 'package:test001/common/global.dart';
import 'package:test001/common/questionData.dart';

import 'package:camera/camera.dart';
import 'package:test001/main.dart';
import 'package:test001/pages/route/result.dart';

enum RecordPlayState {
  record,
  recording,
  finished,
  play,
  playing,
}

class PictureTestPage extends StatefulWidget {
  @override
  _PictureTestPageState createState() => _PictureTestPageState();
}

class _PictureTestPageState extends State<PictureTestPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  /*-----------------声明变量-----------------------------*/
  AnimationController _animatedController;
  RecordPlayState _state = RecordPlayState.record;

  StreamSubscription _recorderSubscription;
  StreamSubscription _playerSubscription;

  FlutterSoundRecorder flutterSound;
  String _recorderTxt = '00:00';

  double _dbLevel = 0.0;
  FlutterSoundRecorder recorderModule = FlutterSoundRecorder();
  FlutterSoundPlayer playerModule = FlutterSoundPlayer();

  var _path = "";
  var _duration = 0.0;
  var _maxLength = 59.0;
  var size;
  var _question = "即将开始测试";
  var _rndNum;

  CameraController controller;
  String videoPath; //视频保存路径
  VoidCallback videoPlayerListener;
  Future<void> _initializeControllerFuture;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  /*---------------------------@override  initState-----------------------*/
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    init();
    _getQuestionData();
    // 监听APP状态改变，是否在前台
    controller =
        CameraController(cameras[1], ResolutionPreset.max, enableAudio: false);
    _initializeControllerFuture = controller.initialize();

    _animatedController = AnimationController(vsync: this)
      ..drive(Tween(begin: 0, end: 1))
      ..duration = Duration(milliseconds: 300);
  }

  Future<void> _initializeExample(bool withUI) async {
    await playerModule.closeAudioSession();

    await playerModule.openAudioSession(
        focus: AudioFocus.requestFocusTransient,
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker);

    await playerModule.setSubscriptionDuration(Duration(milliseconds: 30));
    await recorderModule.setSubscriptionDuration(Duration(milliseconds: 30));
    initializeDateFormatting();
  }

  Future<void> init() async {
    recorderModule.openAudioSession(
      focus: AudioFocus.requestFocusTransient,
      category: SessionCategory.playAndRecord,
      mode: SessionMode.modeDefault,
      device: AudioDevice.speaker,
    );
    await _initializeExample(false);
  }

  @override
  void dispose() {
    super.dispose();
    _cancelRecorderSubscriptions();
    _cancelPlayerSubscriptions();
    _releaseFlauto();
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 如果APP不在在前台
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // 在前台

    }
  }

/*----------------------------------Widget build--------------------*/
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          '图片测试',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _pictureShow(),
          Container(
            height: size.height * 0.3,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Center(
                child: FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the Future is complete, display the preview
                      return _cameraPreviewWidget();
                    } else {
                      // Otherwise, display a loading indicator
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
          ),
          _timeShow(),
          Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: _actionShow(),
          ),
        ],
      ),
    );
  }

  /*---------------------------------------录像-------------------------------------*/
  /// 展示预览窗口
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      print(controller);
      print(controller.value.isInitialized);
      return Text(
        '摄像头初始化失败',
        style: TextStyle(
          color: Colors.tealAccent,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: 1,
        child: ClipOval(
          child: Transform.scale(
            scale: 1 / controller.value.aspectRatio,
            child: Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: CameraPreview(controller),
              ),
            ),
          ),
        ),
      );
    }
  }

  //定义showInSnackBar
  // void showInSnackBar(String message) {
  //   _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  // }

  // 开始录制视频
  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) {
      if (mounted) setState(() {});
      //if (filePath != null) showInSnackBar('正在保存视频于 $filePath');
    });
  }

  // 终止视频录制
  void onStopButtonPressed() {
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      //showInSnackBar('视频保存在: $videoPath');
    });
  }

  //开始录像
  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      //showInSnackBar('摄像头获取失败');
      return null;
    }

    // 确定视频保存的路径
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      // 如果正在录制，则直接返回
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      //_showCameraException(e);
      print(e);
      return null;
    }
    return filePath;
  }

  //停止录像
  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      //_showCameraException(e);
      return null;
    }
  }

  //相机出错showInSnackBar
  // void _showCameraException(CameraException e) {
  //   logError(e.code, e.description);
  //   showInSnackBar('Error: ${e.code}\n${e.description}');
  // }

  //展示图片
  Widget _pictureShow() {
    return Container(
      height: 200,
      width: size.width,
      child: Center(
        child: Image.asset(
          "assets/images/test.jpg", //默认用户头像
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  //初始化问题
  _getQuestionData() {
    _rndNum = Random().nextInt(14) + 1;
    _question = questionData[_rndNum];
  }

  //显示时间
  Widget _timeShow() {
    return Column(
      children: [
        Container(
          width: double.maxFinite,
          height: 60, 
          alignment: Alignment.center,
          child: Text(
            _recorderTxt.substring(0, 5),
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
        CustomPaint(
          size: Size(double.maxFinite, 50),
          painter:
              LCPainter(amplitude: _dbLevel / 2, number: 30 - _dbLevel ~/ 20),
        ),
      ],
    );
  }

  //显示控制按钮
  Widget _actionShow() {
    var _width = size.width - 30; //container的宽度在上面以指明距离设备宽度是15，所以这里是30
    var _height = _width * 0.2;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.teal,
      ),
      height: _height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Offstage(
                //重录按钮，用offstage判断显示
                offstage: _state == RecordPlayState.finished ? false : true,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _state = RecordPlayState.record;
                      _path = "";
                      _recorderTxt = "00:00";
                      _dbLevel = 0.0;
                    });
                  },
                  child: Container(
                    width: _width / 2,
                    padding: EdgeInsets.all(1),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(1),
                          child: Icon(Icons.replay,
                              color: Colors.white, size: 30.0),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            '重录',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Offstage(
                offstage: _state == RecordPlayState.finished ? true : false,
                child: InkWell(
                  //三个按钮中间的一个
                  onTap: () {
                    if (_state == RecordPlayState.record &&
                        controller != null &&
                        controller.value.isInitialized &&
                        !controller.value.isRecordingVideo) {
                      _startRecorder();
                      _animatedController.forward();
                    } else if (_state == RecordPlayState.recording) {
                      _stopRecorder();
                      _animatedController.reverse();
                    }
                  },
                  child: Container(
                    width: _width / 2,
                    padding: EdgeInsets.all(1),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: AnimatedIcon(
                            icon: AnimatedIcons.play_pause,
                            progress: _animatedController,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                        Container(
                          width: _width / 2,
                          alignment: Alignment.center,
                          child: Text(
                            _state == RecordPlayState.record ? "开始" : "结束",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Offstage(
                //完成按钮，用offstage判断显示
                offstage: _state == RecordPlayState.finished ? false : true,
                child: InkWell(
                  onTap: () {
                    // showLoadingDialog(); //showloading框
                    // _voiceUpload().then((testResult) async {
                    //   //发送请求
                    //   Navigator.of(context).pop(); //pop掉loading框
                    //   bool t = await showResultDialog(testResult);//显示测试结果
                    //   print(t);
                    //   if (t == true)
                    //     setState(() {
                    //       _getQuestionData();
                    //     });
                    // });
                    showLoadingDialog(); //showloading框    }
                    _voiceUpload().then((testResult) {
                      if (testResult == null) {
                        Navigator.of(context).pop(); //pop掉loading框
                        Fluttertoast.showToast(msg: '服务器出错');
                      } else {
                        Navigator.of(context).pop(); //pop掉loading框
                        Navigator.of(context).pushReplacement(
                          //push 结果，替换路由栈
                          MaterialPageRoute(
                            builder: (context) =>
                                ResultPage(result: testResult),
                          ),
                        );
                      }
                    });
                  },
                  child: Container(
                    width: _width / 2,
                    padding: EdgeInsets.all(1),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        Container(
                          width: _width / 2,
                          alignment: Alignment.center,
                          child: Text(
                            "完成",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  ///加载中
  showLoadingDialog() {
    showDialog(
      context: context,
      //barrierDismissible: false, //点击遮罩不关闭对话框
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 26.0),
                child: Text("正在测试，请稍后..."),
              ),
            ],
          ),
        );
      },
    );
  }

  //网络请求
  Future _voiceUpload() async {
    Dio dio = new Dio();
    dio.options..baseUrl = MY_API;

    Map<String, dynamic> map = Map();
    map["testPhone"] = currentUser.phone;
    map["voiceFile"] = await MultipartFile.fromFile(_path);
    map["videoFile"] = await MultipartFile.fromFile(videoPath);
    FormData formData = FormData.fromMap(map);

    try {
      Response response = await dio.post(
        '/questionTest', data: formData,

        ///这里是发送请求回调函数
        ///[progress] 当前的进度
        ///[total] 总进度
        onSendProgress: (int progress, int total) {
          //print("当前进度是 $progress 总进度是 $total");
          print((progress / total * 100).toStringAsFixed(0) + "%");
        },
      );
      //_testResult= response.data;
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  Future<bool> showResultDialog(var result) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, //点击遮罩不关闭对话框
      builder: (context) {
        return AlertDialog(
          title: Text("测试结果"),
          content: Text("本次测试结果：$result"),
          actions: <Widget>[
            FlatButton(
              child: Text("确定"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

/*------------------------------------录音-------------------------------------------*/
  /// 开始录音
  _startRecorder() async {
    try {
      await _initializeControllerFuture;
      onVideoRecordButtonPressed();
      await PermissionHandler()
          .requestPermissions([PermissionGroup.microphone]);
      PermissionStatus status = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.microphone);
      if (status != PermissionStatus.granted) {
        EasyLoading.showToast("未获取到麦克风权限");
        throw RecordingPermissionException("未获取到麦克风权限");
      }
      print('===>  获取了权限');
      Directory tempDir = await getTemporaryDirectory();
      var time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      String path =
          '${tempDir.path}/${recorderModule.slotNo}-$time${ext[Codec.pcm16WAV.index]}';
      print(path);
      print('===>  准备开始录音');
      await recorderModule.startRecorder(
        toFile: path,
        codec: Codec.pcm16WAV,
        bitRate: 16000,
        sampleRate: 16000, //模型要求采样率为16000
      );
      print('===>  开始录音');

      /// 监听录音
      _recorderSubscription = recorderModule.onProgress.listen((e) {
        if (e != null && e.duration != null) {
          DateTime date = new DateTime.fromMillisecondsSinceEpoch(
              e.duration.inMilliseconds,
              isUtc: true);
          String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
          if (date.second >= _maxLength) {
            _stopRecorder();
          }
          setState(() {
            _recorderTxt = txt.substring(0, 5);
            _dbLevel = e.decibels;
            print("当前振幅：$_dbLevel");
          });
        }
      });
      this.setState(() {
        _state = RecordPlayState.recording;
        _path = path;
        print("path == $path");
      });
    } catch (err) {
      setState(() {
        _stopRecorder();
        _state = RecordPlayState.record;
        _cancelRecorderSubscriptions();
        print(err);
      });
    }
  }

  /// 结束录音
  _stopRecorder() async {
    try {
      onStopButtonPressed();
      await recorderModule.stopRecorder();
      print('stopRecorder');
      _cancelRecorderSubscriptions();
      _getDuration();
    } catch (err) {
      print('stopRecorder error: $err');
    }
    setState(() {
      _dbLevel = 0.0;
      _state = RecordPlayState.finished;
    });
  }

  /// 取消录音监听
  void _cancelRecorderSubscriptions() {
    if (_recorderSubscription != null) {
      _recorderSubscription.cancel();
      _recorderSubscription = null;
    }
  }

  /// 取消播放监听
  void _cancelPlayerSubscriptions() {
    if (_playerSubscription != null) {
      _playerSubscription.cancel();
      _playerSubscription = null;
    }
  }

  /// 释放录音和播放
  Future<void> _releaseFlauto() async {
    try {
      await playerModule.closeAudioSession();
      await recorderModule.closeAudioSession();
    } catch (e) {
      print('Released unsuccessful');
      print(e);
    }
  }

  /// 获取录音文件秒数
  Future<void> _getDuration() async {
    Duration d = await flutterSoundHelper.duration(_path);
    _duration = d != null ? d.inMilliseconds / 1000.0 : 0.00;
    print("_duration == $_duration");
    var minutes = d.inMinutes;
    var seconds = d.inSeconds % 60;
    var millSecond = d.inMilliseconds % 1000 ~/ 10;
    _recorderTxt = "";
    if (minutes > 9) {
      _recorderTxt = _recorderTxt + "$minutes";
    } else {
      _recorderTxt = _recorderTxt + "0$minutes";
    }

    if (seconds > 9) {
      _recorderTxt = _recorderTxt + ":$seconds";
    } else {
      _recorderTxt = _recorderTxt + ":0$seconds";
    }
    if (millSecond > 9) {
      _recorderTxt = _recorderTxt + ":$millSecond";
    } else {
      _recorderTxt = _recorderTxt + ":0$millSecond";
    }
    print(_recorderTxt);
    setState(() {});
  }
}

/*---------------------------------------------------------------------------------------*/
class LCPainter extends CustomPainter {
  final double amplitude;
  final int number;
  LCPainter({this.amplitude = 100.0, this.number = 20});
  @override
  void paint(Canvas canvas, Size size) {
    var centerY = 0.0;
    var width = size.width / number;

    for (var a = 0; a < 1; a++) {
      var path = Path();
      path.moveTo(0.0, centerY);
      var i = 0;
      while (i < number) {
        path.cubicTo(width * i, centerY, width * (i + 1),
            centerY + amplitude - a * (30), width * (i + 2), centerY);
        path.cubicTo(width * (i + 2), centerY, width * (i + 3),
            centerY - amplitude + a * (30), width * (i + 4), centerY);
        i = i + 4;
      }
      canvas.drawPath(
          path,
          Paint()
            ..color = a == 0 ? Colors.blue : Colors.grey.withAlpha(50)
            ..strokeWidth = a == 0 ? 3.0 : 2.0
            ..maskFilter = MaskFilter.blur(
              BlurStyle.solid,
              5,
            )
            ..style = PaintingStyle.stroke);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
