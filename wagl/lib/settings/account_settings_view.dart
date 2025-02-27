import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:wagl/custom_widget/Strings.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/settings/settings_controller.dart';
import 'package:wagl/util/SizeConfig.dart';

import '../custom_widget/check_internet.dart';
import '../custom_widget/cust_appbar.dart';
import '../custom_widget/cust_button_with_icon_last.dart';
import '../custom_widget/cust_container.dart';
import '../custom_widget/cust_text.dart';
import '../custom_widget/cust_text_field.dart';
import '../custom_widget/custom_loading_popup.dart';
import '../custom_widget/toggle_button.dart';
import '../login/login_view.dart';
import '../profile/profile_controller.dart';
import '../util/ApiClient.dart';

class AccountSettingsView extends StatelessWidget {
  String titleName;

  AccountSettingsView({required this.titleName, super.key});

  var settingController = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: colorBlack,
      body: GetBuilder<SettingController>(
          init: SettingController(),
          builder: (controller) => SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustAppbar(title: accountSettings),
                    SizedBox(
                      height: 3 * SizeConfig.heightMultiplier,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.0 * SizeConfig.widthMultiplier),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: borderColor,
                                  width: 0.25 * SizeConfig.widthMultiplier),
                              color: colorBlack,
                              borderRadius: BorderRadius.all(Radius.circular(
                                2 * SizeConfig.imageSizeMultiplier,
                              )),
                              shape: BoxShape.rectangle,
                            ),
                            width: double.maxFinite,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.0 * SizeConfig.heightMultiplier,
                                  horizontal: 3 * SizeConfig.widthMultiplier),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustText(
                                      name: "Private account",
                                      colors: colorWhite,
                                      fontWeightName: FontWeight.w600,
                                      size: 1.6),
                                  ToggleButton(
                                      flag: settingController.isPrivateAccount,
                                      onSelected: (flags) {

                                        ConnectionChecker.checkConnection(
                                          context: context,
                                          onConnected: () {
                                            settingController
                                                .updateAccountType(flags);
                                          },
                                        );

                                        // print("flag if:: $flags ");
                                      })
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2 * SizeConfig.heightMultiplier,
                          ),
                          CustText(
                              name:
                                  "When your account is public, your profile and posts can be seen by everyone, on or off Instagram, even if they don’t have an Instagram account. When your account is private, only the followers that you approve can see what you share.",
                              size: 1.5,
                              colors: colorGrey,
                              textAlign: TextAlign.start,
                              fontWeightName: FontWeight.w500),
                          SizedBox(
                            height: 2 * SizeConfig.heightMultiplier,
                          ),
                          SizedBox(
                            height: 2 * SizeConfig.heightMultiplier,
                            width: 100 * SizeConfig.widthMultiplier,
                            child: Divider(
                              color: borderColor,
                              indent: 0 * SizeConfig.widthMultiplier,
                              endIndent: 0 * SizeConfig.widthMultiplier,
                              thickness: 1,
                            ),
                          ),
                          SizedBox(
                            height: 2 * SizeConfig.heightMultiplier,
                          ),
                          CustText(
                              name: "Linked accounts",
                              colors: colorWhite,
                              fontWeightName: FontWeight.w600,
                              size: 1.6),
                          SizedBox(
                            height: 2 * SizeConfig.heightMultiplier,
                          ),
                          Container(
                              width: double.maxFinite,
                              height: 6 * SizeConfig.heightMultiplier,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: colorWhite,
                                    width: 0.25 * SizeConfig.widthMultiplier),
                                color: colorBlack,
                                borderRadius: BorderRadius.all(Radius.circular(
                                  1.5 * SizeConfig.imageSizeMultiplier,
                                )),
                                shape: BoxShape.rectangle,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 2.0 *
                                                SizeConfig.widthMultiplier),
                                        child: Image.asset(
                                          "assets/icons/google_icon.png",
                                          fit: BoxFit.fill,
                                          height:
                                              3 * SizeConfig.heightMultiplier,
                                          width: 6 * SizeConfig.widthMultiplier,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3 * SizeConfig.widthMultiplier,
                                      ),
                                      CustText(
                                          name: "Google",
                                          colors: colorWhite,
                                          size: 1.6,
                                          fontWeightName: FontWeight.w700),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        settingController.updateLinkedAccount(
                                            !settingController.accountLinked);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey,
                                              width: 0.25 *
                                                  SizeConfig.widthMultiplier),
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(
                                            2 * SizeConfig.imageSizeMultiplier,
                                          )),
                                          shape: BoxShape.rectangle,
                                        ),
                                        height: 4 * SizeConfig.heightMultiplier,
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 3.0 *
                                                    SizeConfig.widthMultiplier),
                                            child: CustText(
                                                name: settingController
                                                        .accountLinked
                                                    ? "Connect"
                                                    : "Disconnect",
                                                size: 1.6,
                                                colors: colorWhite,
                                                fontWeightName:
                                                    FontWeight.w800),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                          SizedBox(
                            height: 8 * SizeConfig.heightMultiplier,
                            width: 100 * SizeConfig.widthMultiplier,
                            child: Divider(
                              color: borderColor,
                              indent: 0 * SizeConfig.widthMultiplier,
                              endIndent: 0 * SizeConfig.widthMultiplier,
                              thickness: 1,
                            ),
                          ),
                          CustText(
                              name: "Update password",
                              colors: colorWhite,
                              fontWeightName: FontWeight.w600,
                              size: 1.6),
                          SizedBox(height: 2 * SizeConfig.heightMultiplier),
                          TextFieldWidget(
                            labelText: "Current password",
                            widthSize: 100,
                            hintText: "Current password",
                            isObscureText: true,
                            textEditingController:
                                settingController.oldPasswordController,
                            onChange: (value) {
                              settingController.checkText(settingController
                                  .oldPasswordController.text
                                  .toString());
                            },
                          ),
                          SizedBox(height: 2 * SizeConfig.heightMultiplier),
                          TextFieldWidget(
                              labelText: "New password",
                              widthSize: 100,
                              hintText: "New password",
                              isObscureText: true,
                              textEditingController:
                                  settingController.newConfirmPassController,
                              onChange: (value) {}),
                          SizedBox(height: 2 * SizeConfig.heightMultiplier),
                          TextFieldWidget(
                            labelText: "Repeat New password",
                            widthSize: 100,
                            hintText: "Repeat new password",
                            isObscureText: true,
                            textEditingController:
                                settingController.confirmPassController,
                            onChange: (value) {
                              settingController.checkText(settingController
                                  .oldPasswordController.text
                                  .toString());
                            },
                          ),
                          SizedBox(height: 1 * SizeConfig.heightMultiplier),
                          settingController.confirmPassword != ''
                              ? CustContainer(
                                  borderColor: Colors.red,
                                  labelColor: colorWhite,
                                  label: settingController.confirmPassword,
                                  iconPath: "assets/icons/failed_1.png",
                                )
                              : Container(),
                          SizedBox(
                            height: 2 * SizeConfig.heightMultiplier,
                          ),
                          CustButtonIconLast(
                              name: updateString,
                              size: 1.8,
                              btnColor: colorPrimary,
                              fontColor: colorBlack,
                              onSelected: () async {
                                settingController.validation();

                                if (settingController.confirmPassword == '') {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          CustomLoadingPopup());
                                  if (await CheckInternet.checkInternet()) {
                                    /* final result =
                            await settingController.updateUserDetails();
                            */
                                    var sd =
                                        await settingController.updateOldPass();
                                    if (settingController.updatedStatus ==
                                        true) {
                                      Get.back();
                                      Get.back();
                                      var snackdemo = SnackBar(
                                        content: CustText(
                                            name:
                                                "Password Changes Successfully. ",
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
                                    } else {
                                      Get.back();
                                      var snackdemo = SnackBar(
                                        content: CustText(
                                            name:
                                                "Incorrect old password, try again !",
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
                                    }
                                  } else {
                                    var snackdemo = SnackBar(
                                      content: CustText(
                                          name:
                                              "Please check your internet connection",
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
                                  }
                                }
                                /* showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomLoadingPopup());*/
                              },
                              preIconPath: "assets/icons/refresh_icon.png"),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 2 * SizeConfig.heightMultiplier,
                                horizontal: 1 * SizeConfig.widthMultiplier),
                            child: CustButtonIconLast(
                                name: "Delete acount",
                                size: 1.8,
                                btnColor: colorBlack_2,
                                fontColor: colorWhite,
                                onSelected: () async {

                                  showDialog(
                                    context:
                                    context,
                                    builder:
                                        (BuildContext
                                    context) {
                                      return Container(
                                        /* height: 25 * SizeConfig.heightMultiplier,
                                                                  width: 100 * SizeConfig.widthMultiplier,
                                                                  color: colorWhite,*/
                                        child: Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10.0),
                                            ),
                                            backgroundColor: Colors.transparent,
                                            child: Container(
                                              decoration:
                                              const BoxDecoration(color: colorBlack, borderRadius: BorderRadius.all(Radius.circular(16))),
                                              height:
                                              28 * SizeConfig.heightMultiplier,
                                              width:
                                              100 * SizeConfig.widthMultiplier,
                                              child:
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Stack(children: [
                                                  Positioned(
                                                    right: 2 * SizeConfig.widthMultiplier,
                                                    top: 2* SizeConfig.heightMultiplier,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Get.back();
                                                      },
                                                      child: Container(
                                                        width: 8 * SizeConfig.widthMultiplier,
                                                        height: 5 * SizeConfig.heightMultiplier,
                                                        decoration: const BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: colorGreyDark,
                                                        ),
                                                        child: Center(child: Icon(Icons.close_rounded, color: Colors.white, size: 4 * SizeConfig.imageSizeMultiplier)),
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 3 * SizeConfig.heightMultiplier,
                                                      ),
                                                      CustText(name: "Delete account", size: 1.8, colors: colorWhite, fontWeightName: FontWeight.w600),
                                                      SizedBox(
                                                        height: 5 * SizeConfig.heightMultiplier,
                                                        width: 100 * SizeConfig.widthMultiplier,
                                                        child: Divider(
                                                          height: 3 * SizeConfig.heightMultiplier,
                                                          color: borderColor,
                                                          endIndent: 2 * SizeConfig.widthMultiplier,
                                                          thickness: 1,
                                                        ),
                                                      ),
                                                      SizedBox(width: 60 * SizeConfig.widthMultiplier, child: CustText(name: "Are you sure you want to delete your account?", size: 1.6, colors: colorWhite, fontWeightName: FontWeight.w500, textAlign: TextAlign.center)),
                                                      const Spacer(),
                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                        GestureDetector(
                                                          onTap: () async {
                                                            ConnectionChecker.checkConnection(
                                                              context: context,
                                                              onConnected: () async {
                                                                await settingController.deleteAccount();
                                                                if (settingController.isAccountDelete) {
                                                                  var snackdemo = SnackBar(
                                                                    content: CustText(
                                                                      name:
                                                                      "Delete Account Successfully.",
                                                                      size: 1.4,
                                                                      colors: colorBlack,
                                                                      fontWeightName: FontWeight.w600,
                                                                    ),
                                                                    backgroundColor: colorPrimary,
                                                                    elevation: 10,
                                                                    duration: Duration(seconds: 3),
                                                                    behavior: SnackBarBehavior.floating,
                                                                    margin: EdgeInsets.all(5),
                                                                    shape: BeveledRectangleBorder(),
                                                                  );
                                                                  ScaffoldMessenger.of(context)
                                                                      .showSnackBar(snackdemo);
                                                                  Get.offAll(() => LoginView());
                                                                } else {
                                                                  var snackdemo = SnackBar(
                                                                    content: CustText(
                                                                      name:
                                                                      "Delete Account Unsuccessfully",
                                                                      size: 1.4,
                                                                      colors: colorBlack,
                                                                      fontWeightName: FontWeight.w600,
                                                                    ),
                                                                    backgroundColor: colorPrimary,
                                                                    elevation: 10,
                                                                    duration: Duration(seconds: 3),
                                                                    behavior: SnackBarBehavior.floating,
                                                                    margin: EdgeInsets.all(5),
                                                                    shape: BeveledRectangleBorder(),
                                                                  );
                                                                  ScaffoldMessenger.of(context)
                                                                      .showSnackBar(snackdemo);
                                                                }
                                                              },
                                                            );
                                                           /* showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return Dialog(
                                                                  backgroundColor: Colors.transparent,
                                                                  child: Stack(
                                                                    alignment: Alignment.topCenter,
                                                                    children: [
                                                                      SvgPicture.asset(
                                                                        "assets/icons/cust_dialog.svg",
                                                                        fit: BoxFit.fill,
                                                                        // color: Colors.transparent,
                                                                        height: 25 * SizeConfig.heightMultiplier,
                                                                        width: 100 * SizeConfig.widthMultiplier,
                                                                      ),
                                                                      Container(
                                                                          height: 23 * SizeConfig.heightMultiplier,
                                                                          width: 100 * SizeConfig.widthMultiplier,
                                                                          child: Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 10 * SizeConfig.heightMultiplier,
                                                                              ),
                                                                              CustText(name: "Your Wagl was deleted successfully", size: 1.8, colors: colorWhite, fontWeightName: FontWeight.w600),
                                                                              const Spacer(),
                                                                              Padding(
                                                                                padding: EdgeInsets.symmetric(horizontal: 2 * SizeConfig.widthMultiplier),
                                                                                child: GestureDetector(
                                                                                  onTap: () {
                                                                                   *//* Get.back();
                                                                                    Get.back();
                                                                                    if(waglData.isEmpty){
                                                                                      Get.back();
                                                                                    }*//*
                                                                                  },
                                                                                  child: Container(
                                                                                    height: 6 * SizeConfig.heightMultiplier,
                                                                                    width: 100 * SizeConfig.widthMultiplier,
                                                                                    decoration: BoxDecoration(color: colorBlack_2, border: Border.all(width: 1, color: colorBlack_2), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                                                    child: Center(child: CustText(name: "Okay", fontWeightName: FontWeight.w500, size: 1.6, colors: colorWhite)),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            );*/
                                                            // profileController.getUsersWagl(userId);
                                                          },
                                                          child: Container(
                                                            height: 6 * SizeConfig.heightMultiplier,
                                                            width: 36 * SizeConfig.widthMultiplier,
                                                            decoration: BoxDecoration(color: colorBlack, border: Border.all(width: 1, color: colorPrimary), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                            child: Center(child: CustText(name: "Yes, delete", fontWeightName: FontWeight.w500, size: 1.6, colors: colorWhite)),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.pop(context);

                                                          },
                                                          child: Container(
                                                            height: 6 * SizeConfig.heightMultiplier,
                                                            width: 36 * SizeConfig.widthMultiplier,
                                                            decoration: BoxDecoration(color: colorBlack_2, border: Border.all(width: 1, color: colorBlack_2), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                            child: Center(child: CustText(name: "No, cancel", fontWeightName: FontWeight.w500, size: 1.6, colors: colorWhite)),
                                                          ),
                                                        )
                                                      ]),
                                                      SizedBox(
                                                        height: 2 * SizeConfig.heightMultiplier,
                                                      )
                                                    ],
                                                  )
                                                ]),
                                              ),
                                            )),
                                      );
                                    },
                                  );
                                },
                                preIconPath:
                                    "assets/icons/delete_icon_white.png"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
    ));
  }
}
