import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:led_display_flutter/size.dart';

class DisplayOutPutQueueServer extends StatefulWidget {
  var queuedata = List<dynamic>();

  DisplayOutPutQueueServer({Key key, this.queuedata}) : super(key: key);

  @override
  _DisplayOutPutQueueServerState createState() =>
      _DisplayOutPutQueueServerState();
}

class _DisplayOutPutQueueServerState extends State<DisplayOutPutQueueServer> {
  var QueueDataList = List<dynamic>();
  int ColorCount = 0;
  int iRunTime = 0;
  int StartRunTime = 0;
  int RunCount = 0;
  String sRunTime = "";
  Timer timer;
  String hexResult = "0xff000000";

  @override
  void initState() {
    super.initState();
    QueueDataList = widget.queuedata;
    StartRunTime = QueueDataList[2];
    iRunTime = StartRunTime;
    setTimer(iRunTime);
  }

  void setTimer(iRunTime) {
    Timer.periodic(Duration(milliseconds: iRunTime), (timer) {
      setState(() {
        if ((RunCount + 4) % 5 == 0) {
          QueueColorResult(RunCount);
          timer.cancel();
          Timer.run(() {
            return setTimer(iRunTime);
          });
        } else if ((RunCount + 2) % 5 == 0) {
          (QueueDataList[RunCount] == "null")
              ? timer.cancel()
              : iRunTime = QueueDataList[RunCount];
          timer.cancel();
          Timer.run(() {
            return setTimer(iRunTime);
          });
        } else {
          iRunTime = 0;
          timer.cancel();
          if (RunCount + 1 == QueueDataList.length) {
            timer.cancel();
          } else {
            Timer.run(() {
              return setTimer(iRunTime);
            });
          }
        }
        (RunCount + 1 == QueueDataList.length) ? timer.cancel() : RunCount++; //무한 run방지
        print("StartRunTime : ${StartRunTime}");
        print("RunCount : ${RunCount}");
        print("Length : ${QueueDataList.length}");
        print(iRunTime);
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: size.width,
        height: size.height,
        child: _queue_color(context),
      ),
    );
  }

  void QueueColorResult(int i) {
    final int minusNum = 16777216;
    String hexString = "";
    String hexCode = "0xff";
    int QueueResult = 0;

    QueueResult = minusNum - QueueDataList[i]; // 16777216 - 들어온 값
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

  Widget _queue_color(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse(hexResult)),
    );
  }
}
