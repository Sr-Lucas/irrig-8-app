import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class BottomSheetListTile extends StatelessWidget {
  final String headerText;
  final String percentageValue;
  final String moneyValue;
  final Color color;
  final Widget moreInfoWidget;
  final Function onTapShowMoreInfo;
  final Icon icon1;
  final Icon icon2;

  final bool percentageVisibility;
  final bool moneyVisibility;

  BottomSheetListTile({
    this.color,
    this.headerText,
    this.percentageValue,
    this.moneyValue,
    this.moreInfoWidget,
    this.onTapShowMoreInfo,
    this.percentageVisibility,
    this.moneyVisibility, this.icon1, this.icon2
  });

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: InkWell(
        onTap: onTapShowMoreInfo,
        child: Container(
          height: 40.0,
          color: color??Colors.blue,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                headerText??"HEADER",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(<Widget>[
          Visibility(
            visible: moneyVisibility??true,
            child: ListTile(
              title: Text(
                moneyValue??"000.000,00",
                style: _getTextFieldStyleForNumbers(),
              ),
              leading: CircleAvatar(
                child: icon1??Text("ml", style: TextStyle(color: Colors.white)),
                backgroundColor: color??Colors.blue,
              ),
            ),
          ),
          Visibility(
            visible: percentageVisibility??true,
            child: ListTile(
              title: Text(
                percentageValue??"000" + " %",
                style: _getTextFieldStyleForNumbers(),
              ),
              leading: CircleAvatar(
                child: icon2??Text("%", style: TextStyle(color: Colors.white)),
                backgroundColor: color??Colors.blue,
              ),
            ),
          ),
          moreInfoWidget??Container()
        ]),
      ),
    );
  }

  TextStyle _getTextFieldStyleForNumbers() => TextStyle(
    fontSize: 20,
  );

}
