import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/custom_widget/cust_button_with_icon_last.dart';
import 'package:wagl/custom_widget/cust_text.dart';

import '../util/SizeConfig.dart';

class CustBackButton extends StatelessWidget {
  const CustBackButton({super.key});


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
          1.5 * SizeConfig.imageSizeMultiplier),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 4 * SizeConfig.heightMultiplier,
          width: 8.5 * SizeConfig.widthMultiplier,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 0.5 * SizeConfig.widthMultiplier,
            ),
            borderRadius: BorderRadius.circular(
                1.5 * SizeConfig.imageSizeMultiplier),
            shape: BoxShape.rectangle,
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
              "assets/icons/back_icon.svg",
              color: colorWhite),
        ),
      ),
    );
  }
}
