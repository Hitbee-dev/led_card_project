import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:led_display_flutter/size.dart';

class DisplayOutPutRealServer extends StatefulWidget {
  String realdata;

  DisplayOutPutRealServer({Key key, this.realdata}) : super(key: key);

  @override
  _DisplayOutPutRealServerState createState() => _DisplayOutPutRealServerState();
}

class _DisplayOutPutRealServerState extends State<DisplayOutPutRealServer> {
  String QueueData = "";
  int ColorCount = 0;
  int iRunTime = 0;
  int StartRunTime = 0;
  int RunCount = 0;
  String sRunTime = "";
  Timer timer;



  @override
  void initState() {
    super.initState();
    QueueData = widget.realdata;
    print(QueueData);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // QueueDataOutPut();
    return SafeArea(
      child: Container(
        width: size.width,
        height: size.height,
        child: _queue_color(context),
      ),
    );
  }

  void QueueColorResult(int i) {
    if (QueueData == "16777216") {
      ColorCount = 0; // black
    } else if (QueueData == "16738666") {
      ColorCount = 1;
    } else if (QueueData == "16150519") {
      ColorCount = 2;
    } else if (QueueData == "2555649") {
      ColorCount = 3;
    } else if (QueueData == "65519") {
      ColorCount = 4;
    } else if (QueueData == "256") {
      ColorCount = 5;
    } else if (QueueData == "null") {
      ColorCount;
    } else {
      Fluttertoast.showToast(
          msg: "지정된 색상이 없습니다..",
          backgroundColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }

  Widget _queue_color(BuildContext context) {
    final colors = [
      Colors.black,
      Colors.green[700],
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.yellow,
    ];
    return Scaffold(
      backgroundColor: colors[ColorCount],
    );
  }
}
