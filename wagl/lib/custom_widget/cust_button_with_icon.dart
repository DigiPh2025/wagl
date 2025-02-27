import 'package:flutter/material.dart';
import '../util/SizeConfig.dart';

class CustButtonIcon extends StatelessWidget {
  var name, size, btnColor, fontColor, preIconPath, postIcon;
  final Function() onSelected;

  CustButtonIcon({
    @required this.name,
    @required this.size,
    required this.btnColor,
    required this.fontColor,
    required this.onSelected,
    @required this.preIconPath,
  });

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return GestureDetector(
      onTap: () {
        onSelected();
      },
      child: Container(
          width: double.maxFinite,
          height: 6 * SizeConfig.heightMultiplier,
          decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.all(Radius.circular(
              1.5 * SizeConfig.imageSizeMultiplier,
            )),
            shape: BoxShape.rectangle,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 2.0 * SizeConfig.widthMultiplier),
                child: Image.asset(
                  preIconPath,
                  fit: BoxFit.fill,
                  height: 3 * SizeConfig.heightMultiplier,
                  width: 6 * SizeConfig.widthMultiplier,
                ),
              ),
              Text(name,
                  style: TextStyle(
                      fontFamily: "Gilroy",
                      color: fontColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 1.7 * SizeConfig.textMultiplier/scaleFactor)),
              SizedBox(
                width: 7 * SizeConfig.widthMultiplier,
              ),
            ],
          )),
    );
  }
}
