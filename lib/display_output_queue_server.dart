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
  _DisplayOutPutQueueServerState createState() => _DisplayOutPutQueueServerState();
}

class _DisplayOutPutQueueServerState extends State<DisplayOutPutQueueServer> {
  var QueueDataList = List<dynamic>();
  int ColorCount = 0;
  int iRunTime = 0;
  int StartRunTime = 0;
  int RunCount = 0;
  String sRunTime = "";
  Timer timer;



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
        // QueueDataList = widget.queuedata;
        if ((RunCount + 4) % 5 == 0) {
          QueueColorResult(RunCount);
          timer.cancel();
          Timer.run(() {
            return setTimer(iRunTime);
          });
        } else if ((RunCount + 2) % 5 == 0) {
          (QueueDataList[RunCount] == "null") ? timer.cancel() : iRunTime = QueueDataList[RunCount];
          timer.cancel();
          Timer.run(() {
            return setTimer(iRunTime);
          });
        } else {
          iRunTime = 0;
          timer.cancel();
          if(RunCount+1 == QueueDataList.length) {
            timer.cancel();
          } else {
            Timer.run(() {
              return setTimer(iRunTime);
            });
          }
        }
        // (RunCount+1 == QueueDataList.length) ? timer.cancel() : RunCount++; //무한 run방지
        if(RunCount+1 == QueueDataList.length) {
          timer.cancel();
        } else {
          RunCount++;
        }
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
    if (QueueDataList[i] == 16777216) {
      ColorCount = 0; // black
    } else if (QueueDataList[i] == 16738666) {
      ColorCount = 1;
    } else if (QueueDataList[i] == 16150519) {
      ColorCount = 2;
    } else if (QueueDataList[i] == 2555649) {
      ColorCount = 3;
    } else if (QueueDataList[i] == 65519) {
      ColorCount = 4;
    } else if (QueueDataList[i] == 256) {
      ColorCount = 5;
    } else if (QueueDataList[i] == "null") {
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
