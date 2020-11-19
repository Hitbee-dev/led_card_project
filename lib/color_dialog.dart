import 'package:flutter/material.dart';
import 'package:led_display_flutter/solo_cheer_page.dart';

class ColorDialog extends StatefulWidget {
  final bool isSwitch;
  const ColorDialog({Key key,this.isSwitch}) : super(key: key);

  @override
  _ColorDialogState createState() => _ColorDialogState();
}

class _ColorDialogState extends State<ColorDialog> {

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
              title: Text("LED Color Select"),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Container(
                child: _color_card(context),
              ),
            ),
        ),
      ),
    );
  }

  Widget _color_card(BuildContext context) {
    final titles = [
      "연빨",
      "빨강",
      "연주",
      "주황",
      "연노",
      "노랑",
      "연연",
      "연두",
      "초록",
      "민트",
      "연하",
      "하늘",
      "연파",
      "파랑",
      "연남",
      "남색",
      "연보",
      "보라"
    ];

    final colors = [
      Colors.redAccent,
      Colors.red,
      Colors.orangeAccent,
      Colors.orange,
      Colors.yellow,
      Colors.yellowAccent,
      Colors.lightGreenAccent,
      Colors.lightGreen,
      Colors.green,
      Colors.greenAccent,
      Colors.lightBlueAccent,
      Colors.lightBlue,
      Colors.blue,
      Colors.blueAccent,
      Colors.indigoAccent,
      Colors.indigo,
      Colors.deepPurpleAccent,
      Colors.deepPurple,
    ];

    return ListView.builder(
      itemCount: titles.length,
      itemBuilder: (context, index) {
        return Card(
          color: colors[index],
          child: ListTile(
            title: Text(titles[index], style: TextStyle(color: colors[index])),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SoloCheerPage(getcolor: colors[index]),
                  /// SoloCheerPage <- colors[index] Send to getcolor
                ),
              );
            },
          ),
        );
      },
    );
  }
}
