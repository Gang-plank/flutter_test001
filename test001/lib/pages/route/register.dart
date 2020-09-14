import 'package:base_library/base_library.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test001/config/models.dart';
import 'package:test001/config/user_repository.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Image.asset(
            Util.getImgPath("begin"),
            package: BaseConstant.packageBase,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          new UserRegisterBody()
        ],
      ),
    );
  }
}

class UserRegisterBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controllerPhone = new TextEditingController();
    TextEditingController _controllerPwd = new TextEditingController();
    TextEditingController _controllerRePwd = new TextEditingController();
    UserRepository userRepository = new UserRepository();

    void _userRegister() {
      String phone = _controllerPhone.text;
      String password = _controllerPwd.text;
      String passwordRe = _controllerRePwd.text;
      if (phone.isEmpty || phone.length < 6) {
        Util.showSnackBar(context, phone.isEmpty ? "请输入手机号" : "请输入正确的手机号");
        return;
      }
      if (password.isEmpty || password.length < 6) {
        Util.showSnackBar(context, password.isEmpty ? "请输入密码" : "密码至少6位");
        return;
      }
      if (passwordRe.isEmpty || passwordRe.length < 6) {
        Util.showSnackBar(context, passwordRe.isEmpty ? "请确认输入密码" : "密码至少6位");
        return;
      }
      if (password != passwordRe) {
        Util.showSnackBar(context, "密码不一致");
        return;
      }

      RegisterReq req = new RegisterReq(phone, password);
      userRepository.register(req).then((UserModel model) {
        LogUtil.e("RegisterResp: ${model.toString()}");
        Util.showSnackBar(context, "注册成功～");
        Observable.just(1).delay(new Duration(milliseconds: 500)).listen((_) {
          RouteUtil.goMain(context);
        });
      }).catchError((error) {
        LogUtil.e("RegisterResp error: ${error.toString()}");
        Util.showSnackBar(context, error.toString());
      });
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
                hintText: '手机号',
              ),
              Gaps.vGap10,
              LoginItem(
                controller: _controllerPwd,
                prefixIcon: Icons.lock,
                hintText: '密码',
              ),
              Gaps.vGap10,
              LoginItem(
                controller: _controllerRePwd,
                prefixIcon: Icons.lock,
                hintText: '确认密码',
              ),
              new RoundButton(
                text: '注册',
                margin: EdgeInsets.only(top: 20),
                onPressed: () {
                  _userRegister();
                },
              ),
            ],
          ),
        )),
      ],
    );
  }
}
