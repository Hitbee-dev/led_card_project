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
  _DisplayOutPutRealServerState createState() =>
      _DisplayOutPutRealServerState();
}

class _DisplayOutPutRealServerState extends State<DisplayOutPutRealServer> {
  String QueueData = "";
  String CutData = "";
  String ColorData = "";
  int ColorCount = 0;

  @override
  void initState() {
    super.initState();
    QueueData = widget.realdata;
    CutData = QueueData;
    RealSD(CutData);
    QueueColorResult(ColorData);
    // print("Data : ${CutData}");
  }

  void RealSD(CutData) {
    String RealData = CutData.substring(3);
    ColorData = RealData;
    return CutData;
  }

  void QueueColorResult(ColorData) {
    if (ColorData == "16777216") {
      ColorCount = 0; // black
    } else if (ColorData == "16738666") {
      ColorCount = 1;
    } else if (ColorData == "16150519") {
      ColorCount = 2;
    } else if (ColorData == "2555649") {
      ColorCount = 3;
    } else if (ColorData == "65519") {
      ColorCount = 4;
    } else if (ColorData == "256") {
      ColorCount = 5;
    } else if (ColorData == "null") {
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
