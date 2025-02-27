import 'package:flutter/material.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import '../util/SizeConfig.dart';

class CustButtonIconLast extends StatelessWidget {
  var name, size, btnColor, fontColor, preIconPath, postIcon;
  final Function() onSelected;

  CustButtonIconLast({
    @required this.name,
    @required this.size,
    required this.btnColor,
    required this.fontColor,
    required this.onSelected,
    @required this.preIconPath,
  });

  @override
  Widget build(BuildContext context) {
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
              SizedBox(
                width: 7 * SizeConfig.widthMultiplier,
              ),
              CustText(name:name,
                  size:size ,
                  fontWeightName: FontWeight.w800,
                  colors:fontColor ,
              ),
              Padding(
                padding:
                EdgeInsets.only(right: 1.0 * SizeConfig.widthMultiplier),
                child: Image.asset(
                  preIconPath,
                  fit: BoxFit.contain,
                  height: 8 * SizeConfig.heightMultiplier,
                  width: 11 * SizeConfig.widthMultiplier,
                ),
              ),
            ],
          )),
    );
  }
}
