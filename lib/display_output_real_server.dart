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
  String hexResult = "0xff000000";

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
    final int minusNum = 16777216;
    String hexString = "";
    String hexCode = "0xff";
    int QueueResult = 0;

    QueueResult = minusNum - int.parse(ColorData); // 16777216 - 들어온 값
    hexString = QueueResult.toRadixString(16);//들어온 값(10진수) -> 16진수로변환)
    if(hexString.length == 6) {
      hexResult = hexCode + hexString;
    } else if(hexString.length == 5) {
      hexResult = hexCode + "0" + hexString;
    } else if(hexString.length == 4) {
      hexResult = hexCode + "00" + hexString;
    } else if(hexString.length == 3) {
      hexResult = hexCode + "000" + hexString;
    } else if(hexString.length == 2) {
      hexResult = hexCode + "0000" + hexString;
    } else if(hexString.length == 1) {
      hexResult = hexCode + "00000" + hexString;
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
    return Scaffold(
      backgroundColor: Color(int.parse(hexResult)),
    );
  }
}
