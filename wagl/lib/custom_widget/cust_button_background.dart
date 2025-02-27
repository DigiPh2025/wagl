import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../util/SizeConfig.dart';
import 'colorsC.dart';

class CustBgButton extends StatelessWidget {
  String iconPath;
  final Function onSelected;
  var height;
  var width;

  CustBgButton({super.key,
    required this.onSelected,
    required this.iconPath,
    required this.height,
    required this.width,

  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelected();
      },
      child: Container(
        height: height*SizeConfig.heightMultiplier,
        width: width*SizeConfig.widthMultiplier,
        decoration: BoxDecoration(
          color: colorBlack_2,
          borderRadius: BorderRadius.all(Radius.circular(
            1.5 * SizeConfig.imageSizeMultiplier,
          )),
          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical:1.0* SizeConfig.heightMultiplier,
              horizontal:1 * SizeConfig.widthMultiplier,
          ),
          child: SvgPicture.asset(
           iconPath,
            color: colorWhite,
          ),
        ),
      ),
    );
  }
}
