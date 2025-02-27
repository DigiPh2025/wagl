import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/custom_widget/cust_button_with_icon.dart';
import 'package:wagl/custom_widget/cust_button_with_icon_last.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import 'package:wagl/register/additional_details_controller.dart';

import '../custom_widget/check_internet.dart';
import '../custom_widget/cust_container.dart';
import '../custom_widget/cust_text_field.dart';
import '../custom_widget/custom_loading_popup.dart';
import '../login/login_controller.dart';
import '../login/login_view.dart';
import '../util/SizeConfig.dart';
import 'about_you.dart';
import 'register_controller.dart';

class RegisterView extends StatelessWidget {
  var registerController = Get.put(RegisterController());

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: colorBlack,
        body: GetBuilder<RegisterController>(
          init: RegisterController(),
          builder: (controller) => Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
                    "assets/background/login_bg1.png",
                    fit: BoxFit.fill,
                    height: 15 * SizeConfig.heightMultiplier,
                    width: 50 * SizeConfig.widthMultiplier,
                  ),
                  Image.asset(
                    "assets/background/login_bg2.png",
                    fit: BoxFit.fill,
                    height: 15 * SizeConfig.heightMultiplier,
                    width: 100 * SizeConfig.widthMultiplier,
                  ),
                ],
              ),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 2 * SizeConfig.widthMultiplier),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2 * SizeConfig.heightMultiplier),
                      CustText(
                        name: "Sign up",
                        size: 3.5,
                        colors: colorWhite,
                        textAlign: TextAlign.start,
                        fontWeightName: FontWeight.w900,
                        maxLine: 2,
                      ),
                      SizedBox(height: 2 * SizeConfig.heightMultiplier),
                      CustText(
                          name:
                              "Create a profile, follow other accounts, make your own Wagls, and more.",
                          size: 1.4,
                          colors: colorGrey,
                          textAlign: TextAlign.start,
                          fontWeightName: FontWeight.w500,
                          maxLine: 2),
                      SizedBox(height: 2 * SizeConfig.heightMultiplier),
                      TextFieldWidget(
                        labelText: "Email address",
                        widthSize: 100,
                        hintText: "Email address",
                        textEditingController:
                            registerController.emailTextController,
                        isObscureText: false,
                        onChange: (value) {
                          registerController.checkText(registerController
                              .emailTextController.text
                              .toString());
                        },
                      ),
                      registerController.userEmail != ''
                          ? CustContainer(
                              borderColor: Colors.red,
                              labelColor: colorWhite,
                              label: registerController.userEmail,
                              iconPath: "assets/icons/failed_1.png",
                            )
                          : Container(),
                      SizedBox(height: 2 * SizeConfig.heightMultiplier),
                      TextFieldWidget(
                        labelText: "Password",
                        widthSize: 100,
                        hintText: "Password",
                        isObscureText: true,
                        textEditingController:
                            registerController.passwordController,
                        onChange: (value) {
                          registerController.checkText(registerController
                              .emailTextController.text
                              .toString());
                        },
                      ),
                      SizedBox(height: 2 * SizeConfig.heightMultiplier),
                      TextFieldWidget(
                        labelText: "Confirm password",
                        widthSize: 100,
                        hintText: "Confirm password",
                        isObscureText: true,
                        textEditingController:
                            registerController.confirmPassController,
                        onChange: (value) {
                          registerController.checkText(registerController
                              .emailTextController.text
                              .toString());
                        },
                      ),
                      registerController.confirmPassword != ''
                          ? CustContainer(
                              borderColor: Colors.red,
                              labelColor: colorWhite,
                              label: registerController.confirmPassword,
                              iconPath: "assets/icons/failed_1.png",
                            )
                          : Container(),
                      SizedBox(height: 1 * SizeConfig.heightMultiplier),
                      Row(
                        children: [
                          SizedBox(
                            width: 45 * SizeConfig.widthMultiplier,
                            child: Divider(
                              color: borderColor,
                              endIndent: 2 * SizeConfig.widthMultiplier,
                              thickness: 1,
                            ),
                          ),
                          CustText(
                              name: "OR",
                              size: 1.4,
                              colors: colorGreyLight2,
                              fontWeightName: FontWeight.w700),
                          SizedBox(
                            height: 6 * SizeConfig.heightMultiplier,
                            width: 45 * SizeConfig.widthMultiplier,
                            child: Divider(
                              height: 10 * SizeConfig.heightMultiplier,
                              color: borderColor,
                              indent: 2 * SizeConfig.widthMultiplier,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      CustButtonIcon(
                          preIconPath: "assets/icons/facebook_icon.png",
                          name: "Continue with Facebook",
                          size: 1.6,
                          btnColor: c_blue,
                          fontColor: colorWhite,
                          onSelected: () {
                            var facebookLoginStatus =
                                registerController.signInWithFacebook();
                            print("object $facebookLoginStatus");
                          }),
                      SizedBox(
                        height: 2 * SizeConfig.heightMultiplier,
                      ),
                      GestureDetector(
                        onTap: () async {
                          registerController.signOut();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CustomLoadingPopup());
                          if (await CheckInternet.checkInternet()) {
                            User? user =
                                await registerController.signInWithGoogle();

                            final result =
                                await registerController.signUp(user!.email);
                            Navigator.pop(context);
                            if (registerController.isLoading == false) {
                              registerController.cleanData();
                              var homeController =
                                  Get.put(AdditionalDetailsController());
                              Get.offAll(() => RegisterAboutView());
                            } else {
                              var snackdemo = SnackBar(
                                content: CustText(
                                    name: registerController.msg,
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
                                  name: "Please check your internet connection",
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
                        },
                        child: Container(
                            width: double.maxFinite,
                            height: 6 * SizeConfig.heightMultiplier,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: colorWhite,
                                  width: 0.10 * SizeConfig.widthMultiplier),
                              color: colorBlack,
                              borderRadius: BorderRadius.all(Radius.circular(
                                1.5 * SizeConfig.imageSizeMultiplier,
                              )),
                              shape: BoxShape.rectangle,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 2.0 * SizeConfig.widthMultiplier),
                                  child: Image.asset(
                                    "assets/icons/google_icon.png",
                                    fit: BoxFit.fill,
                                    height: 3 * SizeConfig.heightMultiplier,
                                    width: 6 * SizeConfig.widthMultiplier,
                                  ),
                                ),
                                CustText(
                                    name: "Continue with Google",
                                    colors: colorWhite,
                                    size: 1.6,
                                    fontWeightName: FontWeight.w700),
                                SizedBox(
                                  width: 7 * SizeConfig.widthMultiplier,
                                ),
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 2 * SizeConfig.heightMultiplier,
                      ),
                      Platform.isIOS?CustButtonIcon(
                          preIconPath: "assets/icons/apple_icon.png",
                          name: "Continue with Apple",
                          size: 1.6,
                          btnColor: colorBlack_2,
                          fontColor: colorWhite,
                          onSelected: () async {
                            registerController.signOut();
                            if (await CheckInternet.checkInternet()) {
                              User? user =
                                  await registerController.signInWithApple();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CustomLoadingPopup());
                              if (user != null ||
                                  user?.emailVerified != null) {
                                final result = await registerController
                                    .signUp(user!.email);
                                if (registerController.isLoading == false) {
                                  Navigator.pop(context);
                                  registerController.cleanData();
                                  var homeController =
                                      Get.put(AdditionalDetailsController());
                                  Get.offAll(() => RegisterAboutView());
                                } else {
                                  Navigator.pop(context);
                                  var snackdemo = SnackBar(
                                    content: CustText(
                                        name: registerController.msg,
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
                                      name: "Login with apple Unsuccessfull.",
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
                          }):Container(),
                      SizedBox(
                        height: 2 * SizeConfig.heightMultiplier,
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  'By continuing, you are setting up a Wagl account and agree to our ',
                              style: TextStyle(
                                fontFamily: "Gilroy",
                                fontWeight: FontWeight.w500,
                                color: colorGrey,
                                fontSize: 1.4 * SizeConfig.textMultiplier,
                              ),
                            ),
                            TextSpan(
                              text: 'User Agreement',
                              style: TextStyle(
                                fontFamily: "Gilroy",
                                fontWeight: FontWeight.w500,
                                color: colorWhite,
                                fontSize: 1.6 * SizeConfig.textMultiplier,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text: ' and ',
                              style: TextStyle(
                                fontFamily: "Gilroy",
                                fontWeight: FontWeight.w500,
                                color: colorGrey,
                                fontSize: 1.4 * SizeConfig.textMultiplier,
                              ),
                            ),
                            TextSpan(
                              text: 'Privacy Policy.',
                              style: TextStyle(
                                fontFamily: "Gilroy",
                                fontWeight: FontWeight.w500,
                                color: colorWhite,
                                fontSize: 1.6 * SizeConfig.textMultiplier,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2 * SizeConfig.heightMultiplier,
                      ),
                      CustButtonIconLast(
                          preIconPath: "assets/icons/register_icon.png",
                          name: "Sign up",
                          size: 1.85,
                          btnColor: registerController.isValidEmail
                              ? colorPrimary
                              : colorPrimaryLight,
                          fontColor: colorBlack,
                          onSelected: () async {
                            print("here");
                            registerController.validation();
                            if (registerController.isValidEmail) {
                              if (await CheckInternet.checkInternet()) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CustomLoadingPopup());
                                final result =
                                    await registerController.signUp(1);
                                Navigator.pop(context);
                                if (registerController.isLoading == false) {
                                  registerController.cleanData();
                                  var homeController =
                                      Get.put(AdditionalDetailsController());
                                  Get.offAll(() => RegisterAboutView());
                                } else {
                                  var snackdemo = SnackBar(
                                    content: CustText(
                                        name: registerController.msg,
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
                          }),
                      SizedBox(
                        height: 2 * SizeConfig.heightMultiplier,
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Already a Waglr? ',
                              style: TextStyle(
                                fontFamily: "Gilroy",
                                fontWeight: FontWeight.w500,
                                color: colorWhite,
                                fontSize: 1.6 * SizeConfig.textMultiplier,
                              ),
                            ),
                            TextSpan(
                              text: 'Log in',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  var loginController =
                                      Get.put(LoginController());
                                  loginController.cleanData();
                                  Get.offAll(LoginView());
                                },
                              style: TextStyle(
                                fontFamily: "Gilroy",
                                fontWeight: FontWeight.w500,
                                color: colorWhite,
                                fontSize: 1.6 * SizeConfig.textMultiplier,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
