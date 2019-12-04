import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:irrig_8_app/pages/informacoes/informacoes.dart';
import 'package:irrig_8_app/pages/irrigador/irrigador.dart';
import 'package:irrig_8_app/widgets/home_screen_buttom.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'consts.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Irrig8",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Consts.primaryColor,
        backgroundColor: Consts.backgroundColor,
        accentColor: Consts.primaryColor,
        buttonColor: Consts.buttomColor,
        splashColor: Colors.green[200],
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            title: TextStyle(
            color: Colors.white,
            fontSize: 21
            )
          ),
          iconTheme: IconThemeData(
            color: Colors.white
          )
        )
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {

  static const platform = const MethodChannel("blue_channel");

  @override
  Widget build(BuildContext context) {

    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);

    const Color TEXT_COLOR = Consts.textColor;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "IRRIG-8",
          style: TextStyle(color: TEXT_COLOR),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.bluetooth),
            onPressed: (){
              platform.invokeMethod("connect");
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Opacity(
            opacity: 0.4,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/background_art.png",
                scale: 0.1,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              HomeScreenButtom(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Irrigador()
                  ));
                },
                buttonWidget: Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                  Icon(FontAwesomeIcons.water, color: TEXT_COLOR, size: 30,),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("IRRIGADOR", style: TextStyle(color: TEXT_COLOR, fontSize: 20),),
                  )
                ]),
              ),
              Visibility(
                visible: false,
                child: HomeScreenButtom(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Informacoes()
                    ));
                  },
                  buttonWidget: Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                    Icon(Icons.info_outline, color: TEXT_COLOR, size: 20,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("INFORMAÇÕES", style: TextStyle(color: TEXT_COLOR, fontSize: 20),),
                    )
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
