import 'package:flutter/material.dart';
import 'package:base_library/base_library.dart';
import 'package:test001/config/models.dart';
import 'package:test001/config/user_repository.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Image.asset(
            Util.getImgPath("begin"), //登录页背景图
            package: BaseConstant.packageBase,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          new LoginBody()
        ],
      ),
    );
  }
}

class LoginBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controllerPhone = new TextEditingController();
    TextEditingController _controllerPwd = new TextEditingController();
    UserRepository userRepository = new UserRepository();

    UserModel userModel =
        SpUtil.getObj(BaseConstant.keyUserModel, (v) => UserModel.fromJson(v));
    _controllerPhone.text = userModel?.phone ?? "";

    void _userLogin() {
      String phone = _controllerPhone.text;
      String password = _controllerPwd.text;
      if (phone.isEmpty || phone.length != 11) {
        Util.showSnackBar(context, phone.isEmpty ? "请输入手机号" : "请输入正确的手机号");
        return;
      }
      if (password.isEmpty || password.length < 6) {
        Util.showSnackBar(context, phone.isEmpty ? "请输入密码" : "密码至少6位");
        return;
      }

      LoginReq req = new LoginReq(phone, password);
      userRepository.login(req);
    }

    return new Column(
      children: <Widget>[
        new Expanded(child: new Container()),
        new Expanded(
            child: new Container(
          margin: EdgeInsets.only(left: 20, top: 15, right: 20),
          child: new Column(
            children: <Widget>[
              LoginItem(
                controller: _controllerPhone,
                prefixIcon: Icons.person,
                hintText: "手机号",
              ),
              Gaps.vGap15,
              LoginItem(
                controller: _controllerPwd,
                prefixIcon: Icons.lock,
                hasSuffixIcon: true,
                hintText: "密码",
              ),
              new RoundButton(
                bgColor: Colors.blueGrey,
                text: "登录",
                margin: EdgeInsets.only(top: 20),
                onPressed: () {
                  _userLogin();
                },
              ),
            ],
          ),
        )),
      ],
    );
  }
}
