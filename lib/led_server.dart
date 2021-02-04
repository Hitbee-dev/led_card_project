import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_ip/get_ip.dart';
import 'package:shared_preferences/shared_preferences.dart';

LEDServerState pageState;

class LEDServer extends StatefulWidget {
  @override
  LEDServerState createState() {
    pageState = LEDServerState();
    return pageState;
  }
}

class LEDServerState extends State<LEDServer> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int seatnum = 1;
  String localIP = "";
  int port = 9870;
  List<MessageItem> items = List<MessageItem>();

  TextEditingController ipCon = TextEditingController();
  TextEditingController msgCon = TextEditingController();

  Socket ledSocket;

  @override
  void initState() {
    super.initState();
    getIP();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadServerIP();
    });
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
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(title: Text("LED SERVER"), centerTitle: true),
        body: Column(
          children: <Widget>[
            ipInfoArea(),
            connectArea(),
            messageListArea(),
            submitArea(),
          ],
        ));
  }

  Widget ipInfoArea() {
    return Card(
      child: ListTile(
        dense: true,
        leading: Text("My IP"),
        title: Text(localIP),
      ),
    );
  }

  Widget connectArea() {
    return Card(
      child: ListTile(
        dense: true,
        leading: Text("Server IP"),
        title: TextField(
          controller: ipCon,
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              isDense: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(color: Colors.grey[300]),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(color: Colors.grey[400]),
              ),
              filled: true,
              fillColor: Colors.grey[50]),
        ),
        trailing: RaisedButton(
          child: Text((ledSocket != null) ? "Disconnect" : "Connect"),
          onPressed:
              (ledSocket != null) ? disconnectFromServer : connectToServer,
        ),
      ),
    );
  }

  Widget messageListArea() {
    return Expanded(
      child: ListView.builder(
          reverse: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            MessageItem item = items[index];
            return Container(
              alignment: (item.owner == localIP)
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: (item.owner == localIP)
                        ? Colors.blue[100]
                        : Colors.grey[200]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      (item.owner == localIP) ? "Client" : "Server",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      item.content,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget submitArea() {
    return Card(
      child: ListTile(
        title: TextField(
          controller: msgCon,
        ),
        trailing: IconButton(
          icon: Icon(Icons.send),
          color: Colors.blue,
          disabledColor: Colors.grey,
          onPressed: (ledSocket != null) ? submitMessage : null,
        ),
      ),
    );
  }

  void connectToServer() async {
    print("Destination Address: ${ipCon.text}");
    _storeServerIP();

    Socket.connect(ipCon.text, port, timeout: Duration(seconds: 5))
        .then((socket) {
      setState(() {
        ledSocket = socket;
      });

      showSnackBarWithKey(
          "Connected to ${socket.remoteAddress.address}:${socket.remotePort}");
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

    ledSocket.close();
    setState(() {
      ledSocket = null;
    });
  }

  void sendMessage(String message) {
    int seatnum = int.parse(message);
    String parseseat;
    String resultseatnum;
    if (seatnum > -1 && seatnum < 10) {
      parseseat = seatnum.toString();
      resultseatnum = "0" + parseseat;
    } else {
      resultseatnum = message;
    }
    ledSocket.write(resultseatnum);
  }

  void _storeServerIP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("serverIP", ipCon.text);
  }

  void _loadServerIP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      ipCon.text = sp.getString("serverIP");
    });
  }

  void submitMessage() {
    if (msgCon.text.isEmpty) return;
    setState(() {
      items.insert(0, MessageItem(localIP, msgCon.text));
    });
    sendMessage(msgCon.text);
    msgCon.clear();
  }

  showSnackBarWithKey(String message) {
    scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Done',
          onPressed: () {},
        ),
      ));
  }
}

class MessageItem {
  String owner;
  String content;

  MessageItem(this.owner, this.content);
}
