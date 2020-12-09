import 'package:flutter/material.dart';
import 'package:test001/common/global.dart';
import 'package:test001/pages/route/voice_test.dart';
import '../route/video_test.dart';

class StartTestPage extends StatefulWidget {
  @override
  _StartTestPageState createState() => _StartTestPageState();
}

class _StartTestPageState extends State<StartTestPage> {
  final voiceTestButton = Padding(
    padding: const EdgeInsets.all(24.0),
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Material(
            color: Colors.teal,
            shape: CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.mic, color: Colors.white, size: 28.0),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 10.0)),
          Text('语音测试',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0)),
        ]),
  );
  final videoTestButton = Padding(
    padding: const EdgeInsets.all(24.0),
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Material(
              color: Colors.teal,
              shape: CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(Icons.face, color: Colors.white, size: 28.0),
              )),
          Padding(padding: EdgeInsets.only(bottom: 16.0)),
          Text('人脸测试',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0)),
        ]),
  );
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * 0.46,
            decoration: BoxDecoration(
              color: Colors.white,
              // image: DecorationImage(
              //   alignment: Alignment.centerLeft,
              //   image: AssetImage('assets/images/pilates.png'),
              // ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                //color: Colors.blue, //测试container效果
                height: 100, //通过这个container的高度改变文字和下方两个按钮的间距
                padding: EdgeInsets.all(5),
                child: Text(
                  '欢迎来到语音与微表情\n抑郁症研究测试',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                //color: Colors.pink, //测试container效果
                height: 200, //通过这个container的高度改变文字和下方两个按钮的间距
                padding: EdgeInsets.all(5),
                child: Text(
                  '请点击下方按钮开始任意一项测试',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Material(
                    elevation: 10.0,
                    borderRadius: BorderRadius.circular(12.0),
                    shadowColor: Colors.teal,
                    child: InkWell(
                      child: voiceTestButton,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return VoiceTestPage();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Material(
                    elevation: 14.0,
                    borderRadius: BorderRadius.circular(12.0),
                    shadowColor: Colors.teal,
                    child: InkWell(
                      child: videoTestButton,
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CameraExampleHome();
                        }));
                      },
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
