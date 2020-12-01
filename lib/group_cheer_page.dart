import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_ip/get_ip.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:shared_preferences/shared_preferences.dart';

import 'led_server.dart';

class GroupCheerPage extends StatefulWidget {
  const GroupCheerPage({Key key}) : super(key: key);

  @override
  _GroupCheerPageState createState() => _GroupCheerPageState();
}

class _GroupCheerPageState extends State<GroupCheerPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<dynamic> result = ValueNotifier(null);
  String saved_seat_data = "";
  Uint8List bytes = Uint8List(0);
  TextEditingController seatnumber;

  String localIP = "";
  String serverIP = "203.247.38.123";
  int port = 9870;
  // TextEditingController ipCon = TextEditingController();
  // TextEditingController msgCon;
  Socket ledSocket;

  List<MessageItem> items = List<MessageItem>();

  @override
  void initState() {
    super.initState();
    getIP();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadServerIP();
    });
    this.seatnumber = new TextEditingController();
    // this.msgCon = new TextEditingController();
  }

  @override
  void dispose() {
    disconnectFromServer();
    super.dispose();
  }

  void getIP() async {
    var ip = await GetIp.ipAddress;
    setState(() {
      localIP = ip;
    });
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
            key: scaffoldKey,
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
                ipInfoArea(),
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
        padding: const EdgeInsets.only(top: 170),
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

  Widget ipInfoArea() {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: Card(
        child: ListTile(
          dense: true,
          leading: Text("Device IP"),
          title: Text(localIP),
        ),
      ),
    );
  }

  Column _nfccheer() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        height: 75,
        width: 75,
        child: IconButton(
          icon: Image.asset("assets/images/nfc.png"),
          onPressed: () {
            _loading();
            _tagRead();
          }
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

  Widget _loading() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pop(context);
        });
        /// Dialog 언제 꺼지게 할지 Setting
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)
          ),
          content: SizedBox(
            height: 200,
            child: Center(
              child: SizedBox(
                child: new CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation(Colors.black),
                  strokeWidth: 5.0,
                ),
                height: 50.0,
                width: 50.0,
              ),
            ),
          ),
        );
      },
    );
  }

  void _tagRead() {
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      // print(tag.data["ndef"]["cachedMessage"]["records"][0]["payload"]);
      // var list = new List.from(tag.data["ndef"]["cachedMessage"]["records"][0]["payload"]);
      // print(list);
      // UnmodifiableUint8ListView(tag.data["ndef"]["cachedMessage"]["records"][0]["payload"]);
      // print(result.value);
      NfcManager.instance.stopSession();
    });
  }
  // TODO List = Payload Data 가져오는 방법 찾기

  Column _qrcheer() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        height: 75,
        width: 75,
        child: IconButton(
            icon: Image.asset("assets/images/qrcode.png"),
          onPressed: _scan,
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

  Future _scan() async {
    String barcode = await scanner.scan();
    this.seatnumber.text = barcode;
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
            child: TextFormField(
              style: TextStyle(fontSize: 18, color: Colors.white),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0)
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0)
                ),
                labelText: "좌석번호",
                labelStyle: TextStyle(fontSize: 20, color: Colors.white),
              ),
              keyboardType: TextInputType.number,
              onSaved: (String value) {
                saved_seat_data = value;
              },
              controller: this.seatnumber,
            ),
          ),
          Container(
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: () {
                setState(() {
                  if(seatnumber.text == "") {
                    Fluttertoast.showToast(
                        msg: "좌석번호를 입력해주세요.",
                        backgroundColor: Colors.white,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1
                    );
                  } else {
                    if(ledSocket != null) {
                      Fluttertoast.showToast(
                          msg: "이미 서버에 연결되어 있습니다.\n기존 서버가 종료됩니다.",
                          backgroundColor: Colors.white,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1
                      );
                      disconnectFromServer();
                    } else {
                      connectToServer();
                    }
                  }
                });
              },
            ),
          )
        ]);
  }

  void connectToServer() async {
    print("Destination Address: ${serverIP}");
    _storeServerIP();

    Socket.connect(serverIP, port, timeout: Duration(seconds: 5))
        .then((socket) {
      setState(() {
        ledSocket = socket;
        (ledSocket != null) ? submitMessage() : null;
      });

      showSnackBarWithKey(
          "Server : ${socket.remoteAddress.address}:${socket.remotePort} 연결되었습니다.");
      socket.listen(
            (onData) {
          print(String.fromCharCodes(onData).trim());
          setState(() {
            items.insert(
                0,
                MessageItem(ledSocket.remoteAddress.address,
                    String.fromCharCodes(onData).trim()));
          });
        },
        onDone: onDone,
        onError: onError,
      );
    }).catchError((e) {
      showSnackBarWithKey(e.toString());
    });
  }

  void onDone() {
    showSnackBarWithKey("Connection has terminated.");
    disconnectFromServer();
  }

  void onError(e) {
    print("onError: $e");
    showSnackBarWithKey(e.toString());
    disconnectFromServer();
  }

  void disconnectFromServer() {
      print("disconnectFromServer");
      Fluttertoast.showToast(
          msg: "서버가 종료되었습니다.",
          backgroundColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1
      );
      ledSocket.close();
      setState(() {
        ledSocket = null;
      });
  }

  void sendMessage(String message) {
    ledSocket.write("$message\n");
  }

  void _storeServerIP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("serverIP", serverIP);
  }

  void _loadServerIP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      serverIP = sp.getString("serverIP");
    });
  }

  void submitMessage() {
    if (seatnumber.text.isEmpty) return;
    setState(() {
      items.insert(0, MessageItem(localIP, seatnumber.text));
    });
    sendMessage(seatnumber.text);
    seatnumber.clear();
  }

  showSnackBarWithKey(String message) {
    scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: '확인',
          onPressed: (){},
        ),
      ));
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

class MessageItem {
  String owner;
  String content;

  MessageItem(this.owner, this.content);
}