import 'package:flutter/material.dart';
import 'package:led_display_flutter/group_cheer_page.dart';
import 'package:led_display_flutter/solo_cheer_page.dart';
import 'package:url_launcher/url_launcher.dart';

class SideMenu extends StatelessWidget {
  final double menuWidth;

  const SideMenu({Key key, this.menuWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: menuWidth,
        child: Container(
          color: Colors.grey[900],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Align(
                  alignment: Alignment.center,
                  child: Text("LED Menu",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),

              /// LED Menu
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: 2.0,
                  width: menuWidth,
                  color: Colors.white,
                ),
              ),

              /// Line
              ListTile(
                leading: Icon(
                  Icons.group_add,
                  color: Colors.white,
                ),
                title: InkWell(
                  child: Container(
                    child: Text(
                      "단체응원",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return GroupCheerPage();
                  }));
                  // Scaffold.of(context).showSnackBar(SnackBar(content: Text('tap'),));  // SnackBar = 밑에 알림뜨는 거
                },
              ),

              /// Group Cheer
              ListTile(
                leading: Icon(
                  Icons.group,
                  color: Colors.white,
                ),
                title: InkWell(
                  child: Container(
                    child: Text(
                      "개인응원",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return SoloCheerPage();
                  }));
                  // Scaffold.of(context).showSnackBar(SnackBar(content: Text('tap'),));  // SnackBar = 밑에 알림뜨는 거
                },
              ),

              /// Solo Cheer
              ListTile(
                leading: Icon(
                  Icons.bluetooth_searching,
                  color: Colors.white,
                ),
                title: Text("블루투스", style: TextStyle(color: Colors.white)),
              ),

              /// ColorMode
              ListTile(
                leading: Icon(
                  Icons.bug_report,
                  color: Colors.white,
                ),
                title: Text("테스트", style: TextStyle(color: Colors.white)),
              ),

              /// TestMode
              Expanded(
                child: Container(),
              ),

              /// 공백
              ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                title: InkWell(
                  child: Container(
                    child: Text(
                      "나가기",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                onTap: () {
                  // Scaffold.of(context).showSnackBar(SnackBar(content: Text('tap'),));  // SnackBar = 밑에 알림뜨는 거
                },
              ),

              /// Log Out
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: 2.0,
                  width: menuWidth,
                  color: Colors.white,
                ),
              ),

              /// Line
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text("개인정보 처리방침",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: Colors.grey[200])),
                ),
                onTap: _embeddedURL,
              ),

              /// 개인정보 처리방침
            ],
          ),
        ),
      ),
    );
  }

  _embeddedURL() async {
    const embedded_software_lab =
        "https://sites.google.com/site/hnuesw/link/privacy";
    if (await canLaunch(embedded_software_lab)) {
      await launch(embedded_software_lab,
          forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $embedded_software_lab';
    }
  }
}
