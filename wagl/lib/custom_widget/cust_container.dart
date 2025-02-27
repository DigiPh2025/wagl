import 'package:flutter/material.dart';
import 'package:wagl/custom_widget/cust_text.dart';

import '../util/SizeConfig.dart';
import 'colorsC.dart';

class CustContainer extends StatelessWidget {
  var  assest, label, borderColor,iconPath,labelColor;

  CustContainer({@required this.borderColor, super.key,@required this.label,@required this.iconPath,@required this.labelColor });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top: 1.0*SizeConfig.heightMultiplier),
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          border: Border.all(
              color: borderColor, width: 0.10 * SizeConfig.widthMultiplier),
          color: colorBlack,
          borderRadius: BorderRadius.all(Radius.circular(
            10 * SizeConfig.imageSizeMultiplier,
          )),
          shape: BoxShape.rectangle,
        ),
             child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 1.5*SizeConfig.widthMultiplier,vertical: 1*SizeConfig.heightMultiplier),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  iconPath,
                  width: 4* SizeConfig.widthMultiplier,
                  height: 2 * SizeConfig.heightMultiplier,
                  fit: BoxFit.fill,
                ),
                SizedBox(width: 2*SizeConfig.widthMultiplier,),
                CustText(name: label, size: 1.4, colors: labelColor, textAlign: TextAlign.start, fontWeightName: FontWeight.w500,)
              ]),
        ),
      ),
    );
  }
}
