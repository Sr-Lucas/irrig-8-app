import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:irrig_8_app/consts.dart';
import 'package:irrig_8_app/pages/informacoes/widgets/BottomSheetListTile.dart';

class Informacoes extends StatefulWidget {
  @override
  _InformacoesState createState() => _InformacoesState();
}

class _InformacoesState extends State<Informacoes> {

  static const platform = const MethodChannel("blue_channel");

  @override
  void initState() {
    super.initState();

    platform.setMethodCallHandler((MethodCall call) async {
      if(call.method == 'cbk') {
        print(call.arguments.toString());
      }
    });

  }


  Future<void> responseFromNativeCode() async {
    String response = "";
    try {
      final String result = await platform.invokeMethod('blue_channel');
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }

    print(response);
  }

  @override
  Widget build(BuildContext context) {
    platform.invokeMethod('info_bluth');
    return Scaffold(
      appBar: AppBar(
        title: Text("IRRIG8 - INFORMAÇÕES"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              String info = await platform.invokeMethod('info_bluth');
              print(info);
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 5),
          height: MediaQuery.of(context).size.height - 130,
          child: CustomScrollView(
            slivers: <Widget>[
              BottomSheetListTile(
                moneyVisibility: true,
                percentageVisibility: true,
                headerText: "UMIDADE RELATIVA DO AR",
                percentageValue: "10 %",
                moneyValue: "50 ml/m³",
                onTapShowMoreInfo: (){},
                color: Colors.green,
              ),
              BottomSheetListTile(
                moneyVisibility: true,
                percentageVisibility: true,
                headerText: "UMIDADE RELATIVA DO SOLO",
                moneyValue: "63 ml/m³",
                percentageValue: "10 %",
                onTapShowMoreInfo: (){},
                color: Colors.green,
              ),
              BottomSheetListTile(
                moneyVisibility: true,
                percentageVisibility: false,
                headerText: "TEMPERATURA DO AR",
                moneyValue: "7 ºC",
                icon1: Icon(FontAwesomeIcons.temperatureHigh, color: Colors.white,),
                onTapShowMoreInfo: (){},
                color: Colors.green,
              ),
            ],
          ),
        )
      ]),
    );
  }

  getContainer({Widget child, int height, double padding}) => Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        padding: EdgeInsets.all(padding ?? 10),
        height: ScreenUtil.getInstance().setHeight(height),
        decoration: BoxDecoration(color: Consts.buttomColor),
        child: child,
      );
}
