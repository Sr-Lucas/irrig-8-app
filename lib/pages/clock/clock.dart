import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

class Clock extends StatelessWidget {

  final Duration timer;

  Clock({this.timer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IRRI8 - TIMER"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: SlideCountdownClock(
            duration: timer??Duration(minutes: 0),
            slideDirection: SlideDirection.Up,
            separator: "-",
            textStyle: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            separatorTextStyle: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            onDone: () {

            },
          ),
        ),
      ),
    );
  }
}
