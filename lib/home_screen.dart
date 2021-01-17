import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:led_display_flutter/group_cheer_page.dart';
import 'package:led_display_flutter/size.dart';
import 'package:led_display_flutter/solo_cheer_page.dart';
import 'package:led_display_flutter/menu_page.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';

class HomeScreen extends StatefulWidget {
  final Function onMenuChanged;

  const HomeScreen({Key key, this.onMenuChanged}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  String gch = "assets/images/gch1.png";
  String soch = "assets/images/soch1.png";
  String exit = "assets/images/exit1.png";
  AnimationController _iconAnimationController;
  UsbPort _port;
  List<Widget> _ports = [];
  List<Widget> _serialData = [];
  StreamSubscription<String> _subscription;
  Transaction<String> _transaction;
  int _deviceId;
  TextEditingController _textController = TextEditingController();

  double mheight = size.height/5;

  @override
  void initState() {
    UsbSerial.usbEventStream.listen((UsbEvent event) {
      _getPorts();
    });

    _getPorts();
    _iconAnimationController = AnimationController(vsync: this, duration: duration);
    super.initState();
    _connectTo(null);
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
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
            backgroundColor: Colors.transparent, //스캐폴드에 백그라운드를 투명하게 한다.
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text("LED Display APP"),
              centerTitle: true,
              leading: IconButton(
                icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: _iconAnimationController),
                onPressed: () {
                  widget.onMenuChanged();
                  _iconAnimationController.status == AnimationStatus.completed
                      ? _iconAnimationController.reverse()
                      : _iconAnimationController.forward();
                },
              ),
            ),
            body: Column(
              // mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      padding: EdgeInsets.only(top: mheight),
      child: Container(
        child: Column(
          children: [
            _cheerbutton(),
            SizedBox(height: 30),
            _exitbutton(),
            _emptyline(),
            _usbconnect(),
            ..._ports,
            Expanded(flex: 1, child: Container()),
            // 맨 밑에 회사 정보를 표기하기 위한 빈 공간 채우기
            _companyinfo(),
          ],
        ),
      ),
    );
  }

  Padding _emptyline() {
    return Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              height: 2.0,
              width: size.width,
              color: Colors.white,
            ),
          );
  }

  Text _usbconnect() {
    return Text(
              _ports.length > 0
                  ? "LED STICK을 찾음"
                  : "LED STICK을 찾지못함",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white));
  }

  Row _cheerbutton() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Container(
        height: 130,
        width: 180,
        child: Padding(
          padding: const EdgeInsets.only(left: 40),
          child: IconButton(
            icon: Image.asset(gch),
            onPressed: () {
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                      return GroupCheerPage();
                    })
                );
              });
            },
          ),
        ),
      ),
      Container(
        height: 130,
        width: 180,
        child: Padding(
          padding: const EdgeInsets.only(right: 40),
          child: IconButton(
            icon: Image.asset(soch),
            onPressed: () {
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                      return SoloCheerPage();
                    })
                );
              });
            },
          ),
        ),
      ),
    ]);
  }

  Row _exitbutton() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
      Container(
        height: 80,
        width: 270,
        child: IconButton(
          icon: Image.asset(exit),
          onPressed: () {
            setState(() {

            });
          },
        ),
      ),
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

  Future<bool> _connectTo(device) async {
    _serialData.clear();

    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }

    if (_transaction != null) {
      _transaction.dispose();
      _transaction = null;
    }

    if (_port != null) {
      _port.close();
      _port = null;
    }

    if (device == null) {
      _deviceId = null;
      setState(() {});
      return true;
    }

    _port = await device.create();
    if (!await _port.open()) {
      setState(() {});
      return false;
    }

    _deviceId = device.deviceId;
    await _port.setDTR(true);
    await _port.setRTS(true);
    await _port.setPortParameters(
        115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    _transaction = Transaction.stringTerminated(
        _port.inputStream, Uint8List.fromList([13, 10]));

    _subscription = _transaction.stream.listen((String line) {
      setState(() {
        _serialData.add(Text(line));
        if (_serialData.length > 20) {
          _serialData.removeAt(0);
        }
      });
    });
  }

  void _getPorts() async {
    _ports = [];
    List<UsbDevice> devices = await UsbSerial.listDevices();
    print(devices);

    devices.forEach((device) {
      _ports.add(ListTile(
          leading: Icon(Icons.usb, color: Colors.white),
          title: Text(device.productName, style: TextStyle(color: Colors.white)),
          subtitle: Text(device.manufacturerName, style: TextStyle(color: Colors.white)),
          trailing: RaisedButton(
            child:
            Text(_deviceId == device.deviceId ? "연결끊기" : "연결"),
            onPressed: () {
              _connectTo(_deviceId == device.deviceId ? null : device)
                  .then((res) {
                _getPorts();
              });
            },
          )));
    });

    setState(() {
      print(_ports);
    });
  }
}
