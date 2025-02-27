import 'package:flutter/material.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import '../util/SizeConfig.dart';

class CustButton extends StatelessWidget {
  var name, size, btnColor, fontColor, width, height;
  final Function() onSelected;

  CustButton({
    @required this.name,
    required this.width,
    required this.height,
    @required this.size,
    required this.btnColor,
    required this.fontColor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelected();
      },
      child: Container(
          width: width*SizeConfig.widthMultiplier,
          height: height * SizeConfig.heightMultiplier,
          decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.all(Radius.circular(
              2 * SizeConfig.imageSizeMultiplier,
            )),
            shape: BoxShape.rectangle,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustText(name: name,
                  size: 1.7,
                  fontWeightName:  FontWeight.w700,
                  colors: fontColor,
                  ),
            ],
          )),
    );
  }
}
