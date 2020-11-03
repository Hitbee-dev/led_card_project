import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:led_display_flutter/menu_page.dart';
import 'package:led_display_flutter/size.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  static DateTime currentBackPressTime;

  _isEnd() {
    DateTime now = DateTime.now();
    if(currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      _globalKey.currentState..hideCurrentSnackBar()..showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text("종료하시려면 한번 더 누르세요."),
        ));
      return false;
    }
    return true;
  }
  /// BackButton 연속 2번 누를 시 종료 Event

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));

    if (size == null) size = MediaQuery.of(context).size;
    /// 상태바 색상 변경
    return WillPopScope(
      onWillPop: () async {
        bool result = _isEnd();
        return await Future.value(result);
      },
      child: Scaffold(
        key: _globalKey,
        body: MenuPage(),
      ),
    );
  }
}
