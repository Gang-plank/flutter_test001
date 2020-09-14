class Api {
 
  static const String user_register = "user/register"; //注册
  static const String user_login = "user/login"; //登录
  static const String user_logout = "user/logout"; //退出

  static String getPath({String path: '', int page, String resType: 'json'}) {
    StringBuffer sb = new StringBuffer(path);
    if (page != null) {
      sb.write('/$page');
    }
    if (resType != null && resType.isNotEmpty) {
      sb.write('/$resType');
    }
    return sb.toString();
  }
}
