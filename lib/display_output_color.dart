import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:led_display_flutter/size.dart';

class DisplayOutPutColor extends StatefulWidget {
  final Color getcolor;
  const DisplayOutPutColor({Key key,this.getcolor}) : super(key: key);

  @override
  _DisplayOutPutColorState createState() => _DisplayOutPutColorState();
}

class _DisplayOutPutColorState extends State<DisplayOutPutColor> {
  Color setcolor;

  @override
  void initState() {
    super.initState();
    setcolor = widget.getcolor;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: size.width,
        height: size.height,
        child: Scaffold(
          backgroundColor: setcolor,
        ),
      ),
    );
  }
}
