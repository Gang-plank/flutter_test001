


import 'package:camera/camera.dart';
import 'package:test001/config/models.dart';

const int THEME_COLOR = 0xffebebeb;
const int BG_COLOR = 0xffededed;

const String MY_API='http://10.0.3.2:5000';

List<CameraDescription> cameras = [];

String checkLogin = '';
UserData currentUser;