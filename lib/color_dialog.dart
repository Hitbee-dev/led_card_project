import 'package:flutter/material.dart';

class ColorDialog extends StatefulWidget {
  @override
  _ColorDialogState createState() => _ColorDialogState();
}

class _ColorDialogState extends State<ColorDialog> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(25),
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
              body: Container(
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
      "연초",
      "초록",
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
      Colors.greenAccent,
      Colors.green,
      Colors.blueAccent,
      Colors.blue,
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
            onTap: () {},
          ),
        );
      },
    );
  }
}
