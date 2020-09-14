import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'tabs/home.dart';
import 'tabs/mine.dart';
import 'tabs/starttest.dart';


const IconFont = "appIconFont";


class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar>
    with AutomaticKeepAliveClientMixin {  //切换页面后不会清除上一个页面的缓存
  int _currentIndex = 0;   //当前是第几个导航item
  DateTime _lastPressedTime; //给上次点击返回计时

  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {  
  super.build(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(

      appBar: AppBar(title: Text('demo')),

      body: WillPopScope(
          onWillPop: () {   //导航返回拦截-----
            if (_lastPressedTime == null ||
                DateTime.now().difference(_lastPressedTime) >
                    Duration(seconds: 1)) {
              Fluttertoast.showToast(
                fontSize: 16.0,
                msg: "再按一次退出程序",
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                backgroundColor: Colors.grey,
                gravity: ToastGravity.BOTTOM,
              );
              _lastPressedTime = DateTime.now();
              return Future.value(false);
            }
            return Future.value(true);
          },              //导航返回拦截-----

          child: PageView(   //可滚动列表组件，默认横向
            physics: NeverScrollableScrollPhysics(),  //ban了用户滑动界面来切换，只能点击底部导航item
            controller: _controller,
            children: <Widget>[
              HomePage(),
              StartTestPage(),
              MyPage(),
            ],
          )),

      bottomNavigationBar: BottomNavigationBar(    //导航栏
          currentIndex: _currentIndex,
          onTap: (index) {
            _controller.animateToPage(index,     //滑动的动画效果
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.grey[100],
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              title: Text('test'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('me'),
            )
          ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
