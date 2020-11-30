import 'dart:ui';
import 'package:gradient_text/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:led_display_flutter/color_dialog.dart';
import 'package:led_display_flutter/display_output_color.dart';

class SoloCheerPage extends StatefulWidget {
  final Color getcolor;
  const SoloCheerPage({Key key,this.getcolor}) : super(key: key);

  @override
  _SoloCheerPageState createState() => _SoloCheerPageState();
}

class _SoloCheerPageState extends State<SoloCheerPage> {
  final _c = TextEditingController();
  bool isSwitched = false;
  bool isLed = true;
  String ledstatus = "LED 시작";
  String ledstart = "LED 시작";
  String ledend = "LED 종료";
  String colorMode = "";
  String selectMode = "";
  String randomMode = "랜덤모드 실행중 - 비활성화";
  Color setcolor;

  @override
  void initState() {
    super.initState();
    setcolor = widget.getcolor;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        //컨테이너로 감싼다.
        decoration: BoxDecoration(
            //decoration 을 준다.
            image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.fill)),
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.transparent, //스캐폴드에 백그라운드를 투명하게 한다.
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text("개인응원"),
              centerTitle: true,
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // _appbar(),
                Expanded(child: _home_screen())
              ],
            )),
      ),
    );
  }

  Widget _home_screen() {
    return Padding(
        padding: const EdgeInsets.only(top: 200),
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Column(
            children: [
              _optionmode(),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                  height: 2.0,
                  width: 300,
                  color: Colors.white,
                ),
              ),
              _colorchange(),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Container(
                  height: 2.0,
                  width: 300,
                  color: Colors.white,
                ),
              ),
              _setstartend(),
              Expanded(flex: 1, child: Container()),
              // 맨 밑에 회사 정보를 표기하기 위한 빈 공간 채우기
              _companyinfo(),
            ],
          ),
        ));
  }

  Column _colorchange() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            "아래 박스를 클릭하여 색상을 선택 해 주세요.",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
          ),
        ),
      ),
      Container(
        height: 150,
        width: 300,
        child: RaisedButton(
          child: Text(colorMode,
            style: TextStyle(color: Colors.black, fontSize: 20)),
          color: setcolor,
          onPressed: _setactive
        ),
      )
    ]);
  }

  Row _optionmode() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        child: Text(
          "Select Mode",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      Container(
        child: Switch(
          value: isSwitched,
          onChanged: (value) {
            setState(() {
              isSwitched = value;
              // setcolor = widget.getcolor;
              if(isSwitched == false) {
                colorMode = selectMode;
                setcolor = widget.getcolor;
              } else {
                colorMode = randomMode;
                setcolor = Color(0xFF9E9E9E); // gray
              }
              // print(isSwitched);
            });
          },
          activeTrackColor: Colors.redAccent,
          activeColor: Colors.red,
        ),
      ),
      Container(
          child: GradientText(
        "Random Mode",
        gradient: LinearGradient(
          colors: [
            Colors.red,
            Colors.orange,
            Colors.yellow,
            Colors.green,
            Colors.blue,
            Colors.purple
          ]
        ),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        textAlign: TextAlign.center,
      ))
    ]);
  }

  _setactive() {
    if(isSwitched == false) {
      setState(() {
        Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return ColorDialog();
            })
        );
      });
    } else {
      return null;
    }
  }

  Row _setstartend() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Container(
        height: 50,
        width: 90,
        child: RaisedButton(
          child: Text(ledstatus, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          color: setcolor,
          onPressed: () {
            setState(() {
              if (isLed == true) {
                isLed = false;
                ledstatus = ledend;
                // Navigator.push(
                //     context,
                //     MaterialPageRoute<void>(builder: (BuildContext context) {
                //       return USB_Test();
                //     })
                // );
              } else {
                isLed = true;
                ledstatus = ledstart;
                // Navigator.push(
                //     context,
                //     MaterialPageRoute<void>(builder: (BuildContext context) {
                //       return USB_Test();
                //     })
                // );
              }
            });
          },
        ),
      ),
      Container(
        height: 50,
        width: 90,
        child: RaisedButton(
          child: Text("화면 시작", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          color: setcolor,
          onPressed: () {
            setState(() {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                    return DisplayOutPutColor(getcolor: setcolor,);
                  })
              );
            });
          },
        ),
      ),
      Container(
        height: 50,
        width: 70,
        child: RaisedButton(
          child: Text("닫기", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context); // 뒤로가기
          },
        ),
      )
    ]);
  }

  Widget _companyinfo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("(주)코포워드", style: TextStyle(color: Colors.white, fontSize: 11)),
          Text("대전광역시 서구 월평로 85 학산빌딩 415호",
              style: TextStyle(color: Colors.white, fontSize: 11)),
          Text("dev@cofoward.com",
              style: TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }
}
