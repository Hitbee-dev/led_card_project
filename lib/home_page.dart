import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:led_display_flutter/menu_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));

    /// 상태바 색상 변경
    return Scaffold(
      body: MenuPage(),
    );
  }
}
