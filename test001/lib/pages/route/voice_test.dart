import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/date_symbol_data_local.dart';
import 'package:test001/common/global.dart';
import 'package:test001/common/questionData.dart';

enum RecordPlayState {
  record,
  recording,
  play,
  playing,
}

class VoiceTestPage extends StatefulWidget {
  VoiceTestPage({Key key}) : super(key: key);
  @override
  _VoiceTestPageState createState() => _VoiceTestPageState();
}

class _VoiceTestPageState extends State<VoiceTestPage> {
  RecordPlayState _state = RecordPlayState.record;

  StreamSubscription _recorderSubscription;
  StreamSubscription _playerSubscription;

  // StreamSubscription _dbPeakSubscription;
  FlutterSoundRecorder flutterSound;
  String _recorderTxt = '00:00:00';
  // String _playerTxt = '00:00:00';

  double _dbLevel = 0.0;
  FlutterSoundRecorder recorderModule = FlutterSoundRecorder();
  FlutterSoundPlayer playerModule = FlutterSoundPlayer();

  var _path = "";
  var _duration = 0.0;
  var _maxLength = 59.0;
  var size;
  var _question = "即将开始测试";
  var _rndNum;
  //var _testResult;

  @override
  void initState() {
    super.initState();
    init();
    _getQuestionData();
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
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '语音测试',
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _questionShow(),
            Column(
              children: [
                _timeShow(),
                SizedBox(height: 60,),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: _actionShow(),
                ),
              ],
            )
          ],
        ));
  }

  _getQuestionData() {
    _rndNum = Random().nextInt(14) + 1;
    _question = questionData[_rndNum];
  }

  Widget _questionShow() {
    return Container(
      height: 200,
      width: size.width,
      color: Colors.white,
      child: Center(
        child: Text(
          _question,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget _timeShow() {
    return Column(
      children: [
        Container(
          width: double.maxFinite,
          height: 60, //ScreenUtil().setHeight(120),
          alignment: Alignment.center,
          child: Text(
            _recorderTxt,
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
        SizedBox(
          height: 30, //ScreenUtil().setHeight(60)
        ),
        CustomPaint(
          size: Size(double.maxFinite, 50),
          painter:
              LCPainter(amplitude: _dbLevel / 2, number: 30 - _dbLevel ~/ 20),
        ),
      ],
    );
  }

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
                offstage: _state == RecordPlayState.play ||
                        _state == RecordPlayState.playing
                    ? false
                    : true,
                child: InkWell(
                  onTap: () {
                    setState(() async {
                      _state = RecordPlayState.record;
                      _path = "";
                      _recorderTxt = "00:00:00";
                      _dbLevel = 0.0;
                      await _stopPlayer();
                      _state = RecordPlayState.record;
                    });
                  },
                  child: Container(
                    width: _width / 3,
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
              InkWell(
                //三个按钮中间的一个
                onTap: () {
                  if (_state == RecordPlayState.record) {
                    _startRecorder();
                  } else if (_state == RecordPlayState.recording) {
                    _stopRecorder();
                  } else if (_state == RecordPlayState.play) {
                    _startPlayer();
                  } else if (_state == RecordPlayState.playing) {
                    _pauseResumePlayer();
                  }
                },
                child: Container(
                  width: _width / 3,
                  padding: EdgeInsets.all(1),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Icon(
                          _state == RecordPlayState.record
                              ? Icons.mic
                              : _state == RecordPlayState.recording
                                  ? Icons.settings_voice
                                  : _state == RecordPlayState.play
                                      ? Icons.play_circle_outline
                                      : Icons.pause_circle_outline,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                      Container(
                        width: _width / 3,
                        alignment: Alignment.center,
                        child: Text(
                          _state == RecordPlayState.record
                              ? "录音"
                              : _state == RecordPlayState.recording
                                  ? "结束"
                                  : _state == RecordPlayState.play
                                      ? "播放"
                                      : "暂停",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Offstage(
                //完成按钮，用offstage判断显示
                offstage: _state == RecordPlayState.play ||
                        _state == RecordPlayState.playing
                    ? false
                    : true,
                child: InkWell(
                  onTap: () {
                    showLoadingDialog(); //showloading框
                    _voiceUpload().then((testResult) async {
                      //发送请求
                      Navigator.of(context).pop(); //pop掉loading框
                      bool t=await showResultDialog(testResult);
                      print(t);
                      if (t == true) //显示测试结果
                        setState(() {
                          _rndNum = Random().nextInt(15) + 1;
                          _question = questionData[_rndNum];
                        });
                    });
                  },
                  child: Container(
                    width: _width / 3,
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
                          width: _width / 3,
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
      barrierDismissible: false, //点击遮罩不关闭对话框
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

  ///网络请求
  Future _voiceUpload() async {
    Dio dio = new Dio();
    dio.options..baseUrl = MY_API;

    Map<String, dynamic> map = Map();
    map["tPhone"] = currentUser.phone;
    map["voiceFile"] = await MultipartFile.fromFile(_path);
    FormData formData = FormData.fromMap(map);

    try {
      Response response = await dio.post(
        '/voiceTest', data: formData,

        ///这里是发送请求回调函数
        ///[progress] 当前的进度
        ///[total] 总进度
        onSendProgress: (int progress, int total) {
          //print("当前进度是 $progress 总进度是 $total");
          print((progress / total * 100).toStringAsFixed(0) + "%");
        },
      );
      //_testResult= response.data;
      return response.data['data'];
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

  /// 开始录音
  _startRecorder() async {
    try {
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
        sampleRate: 16000,  //模型要求采样率为16000
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
            _recorderTxt = txt.substring(0, 8);
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
      });
    }
  }

  /// 结束录音
  _stopRecorder() async {
    try {
      await recorderModule.stopRecorder();
      print('stopRecorder');
      _cancelRecorderSubscriptions();
      _getDuration();
    } catch (err) {
      print('stopRecorder error: $err');
    }
    setState(() {
      _dbLevel = 0.0;
      _state = RecordPlayState.play;
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

  /// 开始播放
  Future<void> _startPlayer() async {
    try {
      if (await _fileExists(_path)) {
        await playerModule.startPlayer(
            fromURI: _path,
            codec: Codec.pcm16WAV,
            whenFinished: () {
              print('==> 结束播放');
              _stopPlayer();
              setState(() {});
            });
      } else {
        EasyLoading.showToast("未找到文件路径");
        throw RecordingPermissionException("未找到文件路径");
      }

      _cancelPlayerSubscriptions();
      _playerSubscription = playerModule.onProgress.listen((e) {
        if (e != null) {
          // print("${e.duration} -- ${e.position} -- ${e.duration.inMilliseconds} -- ${e.position.inMilliseconds}");
          // DateTime date = new DateTime.fromMillisecondsSinceEpoch(
          //     e.position.inMilliseconds,
          //     isUtc: true);
          // String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);

          // this.setState(() {
          // this._playerTxt = txt.substring(0, 8);
          // });
        }
      });
      setState(() {
        _state = RecordPlayState.playing;
      });
      print('===> 开始播放');
    } catch (err) {
      print('==> 错误: $err');
    }
    setState(() {});
  }

  /// 结束播放
  Future<void> _stopPlayer() async {
    try {
      await playerModule.stopPlayer();
      print('===> 结束播放');
      _cancelPlayerSubscriptions();
    } catch (err) {
      print('==> 错误: $err');
    }
    setState(() {
      _state = RecordPlayState.play;
    });
  }

  /// 暂停/继续播放
  void _pauseResumePlayer() {
    if (playerModule.isPlaying) {
      playerModule.pausePlayer();
      _state = RecordPlayState.play;
      print('===> 暂停播放');
    } else {
      playerModule.resumePlayer();
      _state = RecordPlayState.playing;
      print('===> 继续播放');
    }
    setState(() {});
  }

  /// 判断文件是否存在
  Future<bool> _fileExists(String path) async {
    return await File(path).exists();
  }
}

class LCPainter extends CustomPainter {
  final double amplitude;
  final int number;
  LCPainter({this.amplitude = 100.0, this.number = 20});
  @override
  void paint(Canvas canvas, Size size) {
    var centerY = 0.0;
    var width = size.width / number;

    for (var a = 0; a < 4; a++) {
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
            ..color = a == 0 ? Colors.teal : Colors.blueGrey.withAlpha(50)
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
