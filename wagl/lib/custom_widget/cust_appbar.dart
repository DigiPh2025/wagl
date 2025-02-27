import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../util/SizeConfig.dart';
import 'colorsC.dart';
import 'cust_back_button.dart';
import 'cust_text.dart';

class CustAppbar extends StatelessWidget {
  String title;
  var icon;

   CustAppbar({required this.title,@required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 7 * SizeConfig.heightMultiplier,
      decoration:  const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          // stops: [0.9,0.8],
          end: Alignment.topCenter,
          colors: [colorBlack_2, colorBlack],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustBackButton(),
            CustText(
                name: title,
                size: 1.6,
                colors: colorWhite,
                textAlign: TextAlign.center,
                fontWeightName: FontWeight.w700),
            /*SizedBox(
              width: 7 * SizeConfig.widthMultiplier,
            ),*/
        icon==true?GestureDetector(
          onTap: (){
            print("here is back tpped");
            // Get.back();
            // Get.back();
            Navigator.pop(context);
            Navigator.pop(context);
            print("here is back tpped 2");
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
                    "assets/icons/close_svg.svg",
                    color: colorWhite,
                  ),
                ),
              ),
        ):Container(),
          ],
        ),
      ),
    );
  }
}
