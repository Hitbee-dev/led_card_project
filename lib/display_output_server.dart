import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:led_display_flutter/size.dart';

class DisplayOutPutServer extends StatefulWidget {
  var queuedata = List<dynamic>();
  DisplayOutPutServer({Key key,this.queuedata}) : super(key: key);

  @override
  _DisplayOutPutServerState createState() => _DisplayOutPutServerState();
}

class _DisplayOutPutServerState extends State<DisplayOutPutServer> {
  var QueueDataList = List<dynamic>();
  int ColorCount = 0;
  String QueueSet;


  @override
  void initState() {
    super.initState();
    QueueDataList = widget.queuedata;
    for(int i=0; i<QueueDataList.length; i++) {
      // 배열의 길이를 같게 해주기위해 복사
      if((i+4)%5 == 0) {
        QueueColorResult(i);
      }
      print(QueueDataList);
    }
  }

  @override
  void dispose() {
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
    if(QueueDataList[i] == 16777216) {
      ColorCount = 0; // black
    } else if(QueueDataList[i] == 16738666) {
      ColorCount = 1;
    } else if(QueueDataList[i] == 16150519) {
      ColorCount = 2;
    } else if(QueueDataList[i] == 2555649) {
      ColorCount = 3;
    } else if(QueueDataList[i] == 65519) {
      ColorCount = 4;
    } else if(QueueDataList[i] == 256) {
      ColorCount = 5;
    } else if(QueueDataList[i] == "null") {
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