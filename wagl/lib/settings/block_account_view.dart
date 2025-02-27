import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/custom_widget/cust_button_with_icon_last.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import 'package:wagl/login/login_view.dart';
import 'package:wagl/settings/notification_settings_view.dart';
import 'package:wagl/settings/personal_setting_view.dart';
import 'package:wagl/settings/settings_controller.dart';
import 'package:wagl/util/ApiClient.dart';
import 'package:wagl/util/SizeConfig.dart';

import '../custom_widget/Strings.dart';
import '../custom_widget/cust_appbar.dart';


class BlockedAccountView extends StatelessWidget {
  String titleName;
  var settingController = Get.put(SettingController());
   BlockedAccountView({required this.titleName,super.key});

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
                    CustAppbar(title: titleName),
                    RefreshIndicator(
                        color: colorPrimary,
                        backgroundColor: colorBlack_2,
                      onRefresh: (){
                        return settingController.getBlockUserList();
                      },
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 2.0*SizeConfig.widthMultiplier),
                          child: CustRow("assets/icons/help_icon.png", faqs),
                        )),

                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget CustRow(String iconPath, String title) {
    return Container(
      height:88  * SizeConfig.heightMultiplier,
      width: 100 * SizeConfig.widthMultiplier,
      child:settingController.blockUserList.isEmpty?Center(child: CustText(name: "Empty block user list", size: 1.5, colors: colorWhite, fontWeightName: FontWeight.w600),): ListView.builder(
        itemCount: settingController.blockUserList.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding:  EdgeInsets.symmetric(horizontal: 2.0*SizeConfig.widthMultiplier),
            child: GestureDetector(
              onTap: () {
                print("Tapped");

                settingController.toggleSelection(
                  index,
                  !settingController.selectedItemList[index],
                );
              },
              child: Column(
                children: [
                  Container(
                    width: 100 * SizeConfig.widthMultiplier,
                    height: 7*SizeConfig.heightMultiplier,
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8 *
                                  SizeConfig
                                      .widthMultiplier,
                              height: 4 *
                                  SizeConfig
                                      .heightMultiplier,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: settingController.blockUserList[index].attributes?.blockId?.data?.attributes?.profilePic?.data?.attributes?.url ==
                                      null
                                      ? AssetImage(
                                      "assets/images/no_profile.png")
                                      : NetworkImage(
                                      settingController.blockUserList[index].attributes!.blockId!.data!.attributes!.profilePic!.data!.attributes!.url!)
                                  /* : AssetImage("assets/images/no_profile.png")*/
                                  as ImageProvider,
                                  // Use NetworkImage for network images
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            /*Container(
                              decoration: BoxDecoration(shape: BoxShape.circle),

                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Center(
                                  child:  ==null?Image.asset("assets/icons/no_image.png",width:
                                  5 * SizeConfig.widthMultiplier,
                                    height:
                                    2 * SizeConfig.heightMultiplier,
                                    // color: colorBlack,
                                    fit: BoxFit.fill,):Image.network(
                                    ,
                                    width:
                                    5 * SizeConfig.widthMultiplier,
                                    height:
                                    4 * SizeConfig.heightMultiplier,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),*/
                            SizedBox(width: 3 * SizeConfig.widthMultiplier),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustText(
                                  name: "@${settingController.blockUserList[index].attributes?.blockId?.data?.attributes?.username ??"No user found"}",
                                  size: 1.6,
                                  colors: colorWhite,
                                  fontWeightName: FontWeight.w800,
                                ),
                                CustText(
                                  name: "${settingController.blockUserList[index].attributes?.blockId?.data?.attributes?.firstName??""} ${settingController.blockUserList[index].attributes?.blockId?.data?.attributes?.lastName??""} ",
                                  size: 1.4,
                                  colors: colorGrey,
                                  fontWeightName: FontWeight.w500,
                                ),
                              ],
                            ),

                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            settingController.updateFollows(
                              index,
                              !settingController.selectedFollows[index],
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: settingController.selectedFollows[index]
                                  ? colorBlack2Light
                                  : colorBlack_2,
                              border: Border.all(
                                color: colorBlack_2,
                                width: 0.25 * SizeConfig.widthMultiplier,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(2 * SizeConfig.imageSizeMultiplier),
                              ),
                            ),
                            height: 4 * SizeConfig.heightMultiplier,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3.0 * SizeConfig.widthMultiplier,
                                ),
                                child: CustText(
                                  name: settingController.selectedFollows[index]
                                      ? "Block"
                                      : "Unblock",
                                  size: 1.5,
                                  colors: settingController.selectedFollows[index]
                                      ? colorWhite
                                      : colorPrimary,
                                  fontWeightName: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                    child: Divider(
                      color: borderColor,
                      height: 1,
                      thickness: 2,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
