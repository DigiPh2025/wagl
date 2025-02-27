import 'package:flutter/material.dart';
import '../util/SizeConfig.dart';
import 'colorsC.dart';

class CustButton1 extends StatelessWidget {
  var name, size, btnColor, fontColor, icon,preIconPath;
  bool flag=false;
  final Function(bool) onSelected;

  CustButton1({
    @required this.name,
    @required this.size,
    required this.btnColor,
    required this.fontColor,
    required this.flag,
    required this.onSelected,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return GestureDetector(
      onTap: () {
        onSelected(true);
      },
      child: Container(
        width: double.maxFinite,
        height: 6 * SizeConfig.heightMultiplier,
        decoration: BoxDecoration(
          border: Border.all(
              color: colorWhite, width: 0.51 * SizeConfig.widthMultiplier),
          color: btnColor,
          borderRadius: BorderRadius.all(Radius.circular(
            1.5 * SizeConfig.imageSizeMultiplier,
          )),
          shape: BoxShape.rectangle,
        ),
        child: flag?Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Image.asset(
                preIconPath,
                width: 10 * SizeConfig.widthMultiplier,
                height: 10 * SizeConfig.heightMultiplier,
              ),
            ),
            Text(name,
                style: TextStyle(
                    fontFamily: "Gilroy",
                    color: fontColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 1.7 * SizeConfig.textMultiplier/scaleFactor)),
            Container(
              child: Image.asset(
                preIconPath,
                width: 10 * SizeConfig.widthMultiplier,
                height: 10 * SizeConfig.heightMultiplier,
              ),
            ),
          ],
        ):Row(
          children: [],
        ),
      ),
    );
  }
}
