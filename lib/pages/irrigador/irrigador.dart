import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:irrig_8_app/consts.dart';
import 'package:irrig_8_app/pages/clock/clock.dart';

class Irrigador extends StatefulWidget {

  @override
  _IrrigadorState createState() => _IrrigadorState();
}

class _IrrigadorState extends State<Irrigador> {
  bool _automatica;
  bool _aDistancia;
  double percent;

  TextEditingController _timerController;
  TextEditingController _automaticaController;

  static const platform = const MethodChannel("blue_channel");

  @override
  void initState() {
    super.initState();
    _automatica = false;
    _aDistancia = false;
    _timerController = TextEditingController();
    _automaticaController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IRRIG8 - IRRIGADOR"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          getContainer(
            height: 430,
            child: Column(
              children: <Widget>[
                Text(
                  "Irrigação à distância:",
                  style: TextStyle(color: Consts.textColor, fontSize: 25),
                ),
                SizedBox(height: 20),
                Switch(
                  onChanged: (value) {
                    _aDistancia = value;
                    if(value) {
                      platform.invokeMethod("turnOn");
                    } else {
                      platform.invokeMethod("turnOff");
                    }
                    value = !value;
                    setState(() {});
                  },
                  value: _aDistancia,
                  activeColor: Colors.red,
                ),
              ],
            ),
          ),

          getContainer(
            height: 1090,
            child: Column(
              children: <Widget>[
                Text(
                  "Irrigação AUTOMATICA:",
                  style: TextStyle(color: Consts.textColor, fontSize: 25),
                ),
                SizedBox(height: 20),
                Switch(
                  onChanged: (value) {
                    _automatica = value;
                    if(value) {
                      platform.invokeMethod("turnOnAutomatic", {
                        "percent":_automaticaController.text
                      });
                    } else {
                      platform.invokeMethod("turnOffAutomatic");
                    }
                    value = !value;
                    setState(() {});
                  },
                  value: _automatica??false,
                  activeColor: Colors.red,
                ),
                SizedBox(height: 20),
                Container(
                  color: Colors.white,
                  width: ScreenUtil.getInstance().width/5,
                  margin: EdgeInsets.only(bottom: 15),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _automaticaController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        focusColor: Colors.red,
                      suffix: Text("%")
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  color: Colors.white,
                  width: ScreenUtil.getInstance().width/5,
                  margin: EdgeInsets.only(bottom: 15),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _timerController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      focusColor: Colors.red
                    ),
                  ),
                ),
                FlatButton(
                  color: Colors.red,
                  onPressed: (){
                    if(_timerController.text.isNotEmpty)
                      platform.invokeMethod(
                        'setTimer',
                          {
                            "time":_timerController.text
                          }
                      );

                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Clock(timer: Duration(
                        seconds: int.parse(_timerController.text.isEmpty?"0":_timerController.text)
                      ),)
                    ));

                  },
                  child: Text("DEFINIR TIMER", style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  getContainer({Widget child, int height, double padding}) => Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        padding: EdgeInsets.all(padding ?? 10),
        height: ScreenUtil.getInstance().setHeight(height),
        decoration: BoxDecoration(
          color: Consts.buttomColor,
          border: Border.all(color: Colors.green[200], width: 5)
        ),
        child: child,
      );
}
