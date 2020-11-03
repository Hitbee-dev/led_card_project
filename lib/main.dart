import 'package:flutter/material.dart';
import 'package:led_display_flutter/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Debug 표시를 보이지 않음
      home: HomePage(),
    );
  }
}