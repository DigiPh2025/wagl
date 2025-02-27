import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/custom_widget/cust_button_with_icon_last.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import 'package:wagl/login/login_view.dart';
import 'package:wagl/settings/help_support_setting.dart';
import 'package:wagl/settings/legal_settings_view.dart';
import 'package:wagl/settings/notification_settings_view.dart';
import 'package:wagl/settings/personal_setting_view.dart';
import 'package:wagl/settings/settings_controller.dart';
import 'package:wagl/util/ApiClient.dart';
import 'package:wagl/util/SizeConfig.dart';

import '../custom_widget/Strings.dart';
import '../custom_widget/cust_appbar.dart';
import '../home/home_controller.dart';
import '../login/login_controller.dart';
import 'account_settings_view.dart';
import 'block_account_view.dart';

class SettingsView extends StatelessWidget {
   SettingsView({super.key});
var setttingController=Get.put(SettingController());

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
                    CustAppbar(title: settings),
                    GestureDetector(
                        onTap: () {
                          Get.to(() => PersonalSettingsView(
                                titleName: personalDetails,
                              ));
                        },
                        child: CustRow(
                            "assets/icons/user_icon.png", personalDetails)),
                    GestureDetector(
                        onTap: () {
                          setttingController.clearData();
                          Get.to(() => AccountSettingsView(titleName: accountSettings,));
                        },
                        child: CustRow(
                            "assets/icons/setting_icon.png", accountSettings)),
                    GestureDetector(
                        onTap: () {
                          Get.to(() => LegalSettingsView(
                                titleName: legal,
                              ));
                        },
                        child: CustRow("assets/icons/sheild_icon.png", legal)),
                    GestureDetector(
                        onTap: () {
                          Get.to(() => NotificationSettingsView(
                                titleName: notification,
                              ));
                        },
                        child: CustRow("assets/icons/notification_icon.png",
                            notification)),
                    GestureDetector(
                        onTap: () async {
                          await setttingController.getBlockUserList();
                          Get.to(() => BlockedAccountView(
                                titleName: blockedAccount,
                              ));
                        },
                        child: CustRow(
                            "assets/icons/hand_icon.png", blockedAccount)),
                    GestureDetector(
                        onTap: () {
                          Get.to(() => HelpSettingsView(
                                titleName: helpSupport,
                              ));
                        },
                        child:
                            CustRow("assets/icons/msg_icon.png", helpSupport)),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 2 * SizeConfig.heightMultiplier,
                      horizontal: 1 * SizeConfig.widthMultiplier),
                  child: CustButtonIconLast(
                      name: logout,
                      size: 1.8,
                      btnColor: colorBlack_2,
                      fontColor: colorWhite,
                      onSelected: () {
                        ApiClient.box.write('userName', "");
                        ApiClient.box.write("login", false);
                        setttingController.updateFcmToken();
                        final HomeController homeController = Get.put(HomeController());
                        homeController.onBottomOptionTapped(0);
                        homeController.handleMainPageViewChanged(0);
                        Get.offAll(() => LoginView());
                      },
                      preIconPath: "assets/icons/exit_icon.png"),
                ),
              ],
            ),
          ),
        ));
  }

  Widget CustRow(String iconPath, String title) {
    return Container(
      color: Colors.transparent,
      child: Column(
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
      ),
    );
  }
}
