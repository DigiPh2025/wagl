import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import 'package:wagl/profile/profile_controller.dart';
import 'package:wagl/util/SizeConfig.dart';
import '../custom_widget/Strings.dart';
import '../custom_widget/check_internet.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_appbar.dart';
import '../custom_widget/cust_button_with_icon_last.dart';
import '../custom_widget/toggle_button.dart';

class NotificationSettingsView extends StatelessWidget {
  String titleName;
  var profileController = Get.put(ProfileController());

  NotificationSettingsView({required this.titleName,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorBlack,
        body: GetBuilder<ProfileController>(
          init: ProfileController(),
          builder: (controller) => SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    CustAppbar(title: titleName),
                    SizedBox(height: 1 *SizeConfig.heightMultiplier,),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 2.0*SizeConfig.widthMultiplier),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: borderColor,
                                  width: 2,
                                ),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(2 * SizeConfig.widthMultiplier))),
                            child: Padding(
                              padding: EdgeInsets.all(3 * SizeConfig.widthMultiplier),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustText(
                                      name: "Receive updates via email",
                                      size: 1.6,
                                      colors: colorWhite,
                                      fontWeightName: FontWeight.w500),
                                  ToggleButton(
                                      flag: profileController.emailNotification,
                                      onSelected: (flags) {
                                        profileController.updateNotificationType(
                                            flags, 1);
                                        // print("flag if:: $flags ");
                                      })
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 1 *SizeConfig.heightMultiplier,),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: borderColor,
                                  width: 2,
                                ),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(2 * SizeConfig.widthMultiplier))),
                            child: Padding(
                              padding: EdgeInsets.all(3 * SizeConfig.widthMultiplier),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustText(
                                      name: "Receive updates via push notifications",
                                      size: 1.6,
                                      colors: colorWhite,
                                      fontWeightName: FontWeight.w500),
                                  ToggleButton(
                                      flag: profileController.pushNotification,
                                      onSelected: (flags) {
                                        profileController.updateNotificationType(flags, 2);
                                        // print("flag if:: $flags ");
                                      })
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 2.0*SizeConfig.widthMultiplier),
                  child: Column(
                    children: [
                      CustButtonIconLast(
                          name: updateString,
                          size: 1.8,
                          btnColor: colorPrimary,
                          fontColor: colorBlack,
                          onSelected: () {

                            ConnectionChecker.checkConnection(
                              context: context,
                              onConnected: () async {

                               var resilt= await profileController.updateNotification();
                               Get.back();
                                var snackdemo = SnackBar(
                                  content: CustText(
                                      name: "Details Updated Successfully !",
                                      size: 1.4,
                                      colors: colorBlack,
                                      fontWeightName: FontWeight.w600),
                                  backgroundColor: colorPrimary,
                                  elevation: 10,
                                  duration: Duration(seconds: 3),
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.all(5),
                                  shape: BeveledRectangleBorder(),
                                );

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackdemo);
                              },
                            );

                          },
                          preIconPath: "assets/icons/refresh_icon.png"),
                      SizedBox(height: 3*SizeConfig.heightMultiplier,)
                    ],
                  ),
                ),

              ],
            ),
          ),
        ));
  }
}
