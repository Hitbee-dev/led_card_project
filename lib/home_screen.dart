import 'package:flutter/material.dart';

import 'menu_page.dart';

class HomeScreen extends StatefulWidget {
  final Function onMenuChanged;

  const HomeScreen({Key key, this.onMenuChanged}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  int gchcount = 0;
  int sochcount = 0;
  int exitcount = 0;
  String gch = "assets/images/gch1.png";
  String soch = "assets/images/soch1.png";
  String exit = "assets/images/exit1.png";
  AnimationController _iconAnimationController;

  @override
  void initState() {
    _iconAnimationController = AnimationController(vsync: this, duration: duration);
    super.initState();
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
        padding: const EdgeInsets.only(top: 250),
        child: Column(
          children: [
            _cheerbutton(),
            SizedBox(height: 30),
            _exitbutton(),
            Expanded(flex: 1, child: Container()),
            // 맨 밑에 회사 정보를 표기하기 위한 빈 공간 채우기
            _companyinfo(),
          ],
        ));
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
        height: 130,
        width: 180,
        child: Padding(
          padding: const EdgeInsets.only(right: 40),
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

  Row _exitbutton() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Container(
        height: 80,
        width: 270,
        child: IconButton(
          icon: Image.asset(exit),
          onPressed: () {
            setState(() {
              if (exitcount == 0) {
                exit = "assets/images/exit2.png";
                exitcount++;
              } else {
                exit = "assets/images/exit1.png";
                exitcount--;
              }
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
}
