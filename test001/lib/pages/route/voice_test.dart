import 'package:flutter/material.dart';

import 'package:flutter_plugin_record/index.dart';

class VoiceTestPage extends StatefulWidget {
  @override
  _VoiceTestPageState createState() => _VoiceTestPageState();
}

class _VoiceTestPageState extends State<VoiceTestPage> {
  startRecord() {
    print("开始录制");
  }

  stopRecord(String path, double audioTimeLength) {
    print("结束录制");
    print("音频文件位置" + path);
    print("音频录制时长" + audioTimeLength.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("语音测试"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              child: Card(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image.asset('images/begin.png'),
              )),
            ),
            new VoiceWidget(startRecord: startRecord, stopRecord: stopRecord),
          ],
        ),
      ),
    );
  }
}
