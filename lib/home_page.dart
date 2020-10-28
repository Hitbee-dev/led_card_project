import 'dart:io';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int gchcount = 0;
  int sochcount = 0;
  String gch = "assets/images/gch1.png";
  String soch = "assets/images/soch1.png";

  @override
  Widget build(BuildContext context) {
    return Container(
      //컨테이너로 감싼다.
      decoration: BoxDecoration(
          //decoration 을 준다.
          image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.fitWidth)),
      child: Scaffold(
        backgroundColor: Colors.transparent, //스캐폴드에 백그라운드를 투명하게 한다.
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text('LED Display APP'),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(
                Icons.list,
                color: Colors.white,
              ),
              onPressed: () {}),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 250),
          child: _cheerbutton(),
        ),
      ),
    );
  }

  Row _cheerbutton() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Container(
        height: 150.0,
        width: 200,
        child: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: IconButton(
            icon: Image.asset(gch),
            onPressed: () {
              setState(() {
                if (gchcount == 0) {
                  gch = "assets/images/gch2.png";
                  gchcount++;
                } else {
                  gch = "assets/images/gch1.png";
                  gchcount--;
                }
              });
            },
          ),
        ),
      ),
      Container(
        height: 150.0,
        width: 200,
        child: Padding(
          padding: const EdgeInsets.only(right: 30),
          child: IconButton(
            icon: Image.asset(soch),
            onPressed: () {
              setState(() {
                if (sochcount == 0) {
                  soch = "assets/images/soch2.png";
                  sochcount++;
                } else {
                  soch = "assets/images/soch1.png";
                  sochcount--;
                }
              });
            },
          ),
        ),
      ),
        ]);
  }
}
