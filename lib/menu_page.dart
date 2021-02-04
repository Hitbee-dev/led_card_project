import 'package:flutter/material.dart';
import 'package:led_display_flutter/home_screen.dart';
import 'package:led_display_flutter/side_menu.dart';
import 'package:led_display_flutter/size.dart';

const duration = Duration(milliseconds: 300);

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final menuWidth = size.width / 2;

  /// MenuPage가 나올 크기 지정
  MenuStatus _menuStatus = MenuStatus.closed;
  double bodyXPos = 0;
  double menuXPos = -size.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          /// 화면 전체를 이동시키기 위해 Stack으로 감싸준다.
          children: <Widget>[
            AnimatedContainer(
                duration: duration,
                curve: Curves.easeInOutCubic,
                child: HomeScreen(onMenuChanged: () {
                  setState(() {
                    _menuStatus = (_menuStatus == MenuStatus.closed)
                        ? MenuStatus.opened
                        : MenuStatus.closed;

                    switch (_menuStatus) {
                      case MenuStatus.opened:
                        bodyXPos = menuWidth;
                        menuXPos = size.width - menuWidth * 2;
                        break;
                      case MenuStatus.closed:
                        bodyXPos = 0;
                        menuXPos = -size.width;
                        break;
                    }
                  });
                }),
                transform: Matrix4.translationValues(bodyXPos, 0, 0)),
            AnimatedContainer(
              duration: duration,
              curve: Curves.easeInOutCubic,
              transform: Matrix4.translationValues(menuXPos, 0, 0),
              child: SideMenu(menuWidth: menuWidth),
            ),

            /// Positioned는 Stack안에서만 사용된다.(포지션 값)
            /// ProfileBody()보다 아래에 있어야 나중에 실행되므로 덮을 수 있다.
          ],
        ));
  }
}

enum MenuStatus { opened, closed }
