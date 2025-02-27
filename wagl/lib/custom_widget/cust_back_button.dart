import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../util/SizeConfig.dart';
import 'colorsC.dart';

class CustBackButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: colorBlack_2,
          borderRadius: BorderRadius.all(Radius.circular(
            1.5 * SizeConfig.imageSizeMultiplier,
          ),),

          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 1.5 * SizeConfig.heightMultiplier,
              horizontal: 4 * SizeConfig.widthMultiplier),
          child: SvgPicture.asset(
            "assets/icons/back_icon.svg",
            color: colorWhite,
          ),
        ),
      ),
    );
  }
}
