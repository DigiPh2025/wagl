import 'package:flutter/material.dart';
import '../util/SizeConfig.dart';
import 'colorsC.dart';


class ToggleButton extends StatelessWidget {

  var flag;
  final Function(bool) onSelected;

  ToggleButton({
    @required this.flag,
    required this.onSelected,
  });
  @override
  Widget build(BuildContext context) {
    print("flag------------------>> : $flag");
    return flag?GestureDetector(
      onTap:() {
        onSelected(false);
      },
      child: Container(
        width: 10 * SizeConfig.widthMultiplier,
        height: 6 * SizeConfig.widthMultiplier,
        decoration: BoxDecoration(
          color: colorPrimary,
          border: Border.all(
            color: colorPrimary,
            width: 0.8 * SizeConfig.widthMultiplier,
          ),
          borderRadius: BorderRadius.all(Radius.circular(
            5 * SizeConfig.imageSizeMultiplier,
          )),
          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding:  EdgeInsets.only(left: 4 * SizeConfig.widthMultiplier),
          child: Container(
            width: 6 * SizeConfig.widthMultiplier,
            height: 4 * SizeConfig.widthMultiplier,

            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Image.asset(fit: BoxFit.contain,"assets/icons/true_icon.png"),
          ),
        )
      ),
    ):
    GestureDetector(
      onTap:() {
        onSelected(true);
      },
      child: Container(
          width: 10 * SizeConfig.widthMultiplier,
          height: 6 * SizeConfig.widthMultiplier,
          decoration: BoxDecoration(
            color: borderColor,
            border: Border.all(
              color: borderColor,
              width: 0.8 * SizeConfig.widthMultiplier,
            ),
            borderRadius: BorderRadius.all(Radius.circular(
              5 * SizeConfig.imageSizeMultiplier,
            )),
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding:  EdgeInsets.only(right: 4 * SizeConfig.widthMultiplier),
            // padding:  EdgeInsets.only(top: 1 * SizeConfig.widthMultiplier,bottom: 1 * SizeConfig.widthMultiplier,left: 1 * SizeConfig.widthMultiplier,right: 5 * SizeConfig.widthMultiplier),
            child: Container(
              width: 5 * SizeConfig.widthMultiplier,
              height: 5 * SizeConfig.widthMultiplier,
              decoration: BoxDecoration(
                color: colorGrey,
                shape: BoxShape.circle,
              ),
              child: Image.asset(fit: BoxFit.contain,"assets/icons/false_icon.png"),
            ),
          )
      ),
    );
  }
}
