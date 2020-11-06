import 'dart:ui';

import 'package:flutter/material.dart';

class GroupCheerPage extends StatefulWidget {
  const GroupCheerPage({Key key}) : super(key: key);

  @override
  _GroupCheerPageState createState() => _GroupCheerPageState();
}

class _GroupCheerPageState extends State<GroupCheerPage> {
  final _c = TextEditingController();

  @override
  void initState() {
    super.initState();
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
              title: Text("단체응원"),
              centerTitle: true,
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // _appbar(),
                Expanded(
                    child: _home_screen()
                )
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _nfccheer(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      height: 75,
                      width: 2.0,
                      color: Colors.white,
                    ),
                  ),
                  _qrcheer(),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, bottom: 30),
                child: Container(
                  height: 2.0,
                  width: 300,
                  color: Colors.white,
                ),
              ),
              _seatinfo(),
              Expanded(flex: 1, child: Container()),
              // 맨 밑에 회사 정보를 표기하기 위한 빈 공간 채우기
              _companyinfo(),
            ],
          ),
        ));
  }

  Column _nfccheer() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        height: 75,
        width: 75,
        child: IconButton(
          icon: Image.asset("assets/images/nfc.png"),
        ),
      ),
      Container(
        child: Text("NFC TAG",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white)),
      )
    ]);
  }

  Column _qrcheer() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        height: 75,
        width: 75,
        child: IconButton(
          icon: Image.asset("assets/images/qrcode.png"),
        ),
      ),
      Container(
        child: Text("QR CODE",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white)),
      )
    ]);
  }

  Row _seatinfo() {

    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 75,
          width: 75,
          child: IconButton(
            icon: Image.asset("assets/images/seat.png"),
          ),
        ),
        Container(
            height: 50,
            width: 100,
            child: TextField(
              style: TextStyle(fontSize: 18, color: Colors.white),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white,width: 2.0)
                  ),
                  labelText: "좌석번호",
                  labelStyle: TextStyle(fontSize: 20, color: Colors.white),
                ),
              keyboardType: TextInputType.number,
              controller: _c,
            ),
          ),
        Container(
          child: IconButton(
            icon: Icon(Icons.send, color: Colors.white),
            onPressed: () {
              setState(() {
                _c.text = "";
              });
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