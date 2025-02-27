import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/custom_widget/cust_button_with_icon_last.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import 'package:wagl/settings/settings_controller.dart';
import 'package:wagl/util/SizeConfig.dart';

import '../custom_widget/Strings.dart';
import '../custom_widget/cust_appbar.dart';


class LegalSettingsView extends StatelessWidget {
  String titleName;
   LegalSettingsView({required this.titleName,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorBlack,
        body: GetBuilder<SettingController>(
          init: SettingController(),
          builder: (controller) => SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    CustAppbar(title: legal),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 2.0*SizeConfig.widthMultiplier),
                      child: Column(
                        children: [
                          CustRow("assets/icons/info_icon.png", terms),
                          CustRow( "assets/icons/lock_icon.png", privacyPolicy),
                        ],
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ),
        ));
  }

  Widget CustRow(String iconPath, String title) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 1 * SizeConfig.widthMultiplier),
              child: Row(
                children: [
                  Image.asset(iconPath,
                      width: 10 * SizeConfig.widthMultiplier,
                      height: 5 * SizeConfig.heightMultiplier,
                      fit: BoxFit.fill),
                  SizedBox(
                    width: 2 * SizeConfig.widthMultiplier,
                  ),
                  CustText(
                      name: title,
                      size: 1.6,
                      colors: colorWhite,
                      fontWeightName: FontWeight.w700),
                ],
              ),
            ),
            Image.asset("assets/icons/right_arrow_icon.png",
                width: 6 * SizeConfig.widthMultiplier,
                height: 1.5 * SizeConfig.heightMultiplier,
                fit: BoxFit.contain),
          ],
        ),
        const Divider(
          color: borderColor,
          thickness: 1,
        ),
      ],
    );
  }
}
