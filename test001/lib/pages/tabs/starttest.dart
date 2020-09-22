import 'package:flutter/material.dart';
import 'package:test001/pages/route/voice_test.dart';
import '../route/video_test.dart';

class StartTestPage extends StatefulWidget {
  @override
  _StartTestPageState createState() => _StartTestPageState();
}

class _StartTestPageState extends State<StartTestPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 200,
          padding: EdgeInsets.all(10),
          child: Text(
            '这是引导文字和使用指导',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                width: 100,
                height: 100,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return VoiceTestPage();
                    }));
                  },
                  color: Colors.blue,
                  padding: const EdgeInsets.all(20),
                  shape: CircleBorder(),
                  child: Text(
                    "开始语音测试",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                height: 100,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CameraExampleHome();
                    }));
                  },
                  color: Colors.blue,
                  padding: const EdgeInsets.all(20),
                  shape: CircleBorder(),
                  child: Text(
                    "开始视频测试",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ])
      ],
    );
  }
}
