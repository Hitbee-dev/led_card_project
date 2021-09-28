import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:led_display_flutter/group_cheer_page.dart';
import 'package:led_display_flutter/home_page.dart';
import 'package:led_display_flutter/solo_cheer_page.dart';

import 'display_output_real_server.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  // 120hz 주사율에서도 부드럽게 동작하도록
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, //Debug 표시를 보이지 않음
        home: HomePage(),
        routes: <String, WidgetBuilder>{
          '/grouppage': (BuildContext context) => GroupCheerPage(),
          '/solopage': (BuildContext context) => SoloCheerPage(),
        } // BackStack 관리
        );
  }
}
