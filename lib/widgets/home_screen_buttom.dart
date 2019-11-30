import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreenButtom extends StatelessWidget {

  final Widget buttonWidget;
  final Function onTap;

  HomeScreenButtom({this.buttonWidget, this.onTap});

  @override
  Widget build(BuildContext context) {

    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);

    return InkWell(
      onTap: onTap,
      child: Container(
          height: ScreenUtil.getInstance().setHeight(650),
          width: ScreenUtil.getInstance().setWidth(650),
          margin: EdgeInsets.all(15),
          alignment: Alignment.center,
          child: buttonWidget,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green[200], width: 2),
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(255, 0, 200, 83),
          ),
      ),
    );
  }
}
