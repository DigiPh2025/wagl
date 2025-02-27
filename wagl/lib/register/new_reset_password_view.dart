import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/custom_widget/cust_back_button.dart';
import 'package:wagl/login/login_view.dart';
import 'package:wagl/util/ApiClient.dart';
import '../custom_widget/cust_button.dart';
import '../custom_widget/cust_button_with_icon.dart';
import '../custom_widget/cust_button_with_icon_last.dart';
import '../custom_widget/cust_container.dart';
import '../custom_widget/cust_text.dart';
import '../custom_widget/cust_text_field.dart';
import '../login/login_controller.dart';
import '../register/register_controller.dart';
import '../register/register_view.dart';
import '../util/SizeConfig.dart';

class NewRestPasswordView extends StatelessWidget {
  var loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: colorBlack,
        body: GetBuilder<LoginController>(
          init: LoginController(),
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
                    height: 20 * SizeConfig.heightMultiplier,
                    width: 60 * SizeConfig.widthMultiplier,
                  ),
                  Image.asset(
                    "assets/background/login_bg2.png",
                    fit: BoxFit.fill,
                    height: 15 * SizeConfig.heightMultiplier,
                    width: 100 * SizeConfig.widthMultiplier,
                  ),
                ],
              ),
              Row(
                children: [
                  Column(children: [
                    CustBackButton(),
                  ]),
                ],
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 1.5 * SizeConfig.heightMultiplier,
                      horizontal: 4 * SizeConfig.widthMultiplier),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustText(
                          name: "Reset password",
                          size: 3.6,
                          colors: colorWhite,
                          textAlign: TextAlign.start,
                          fontWeightName: FontWeight.w900),
                      SizedBox(height: 3 * SizeConfig.heightMultiplier),
                      CustText(
                          name: loginController.isMailSend
                              ? "We have sent an email to ${loginController.resetUserController.text.toString()} with instructions on how to reset your password."
                              : "Enter the email address associated with your Wagl account, and we’ll send you an email with instructions for how to reset your password.",
                          size: 1.6,
                          colors: colorGrey,
                          textAlign: TextAlign.start,
                          fontWeightName: FontWeight.w600),
                      SizedBox(height: 3 * SizeConfig.heightMultiplier),
                      loginController.isMailSend == false
                          ? TextFieldWidget(
                              labelText: "Email address",
                              widthSize: 100,
                              hintText: "Email address",
                              textEditingController:
                                  loginController.resetUserController,
                              isObscureText: false,
                              onChange: (value) async {
                                loginController.checkEmail(loginController
                                    .resetUserController.text
                                    .toString());
                                if (loginController.resetUserPassword == "" &&
                                    loginController
                                            .resetUserController.isBlank ==
                                        null) {
                                  print(
                                      "Here ===>> ${loginController.resetUserPassword}");
                                } else {
                                  print("false");
                                }
                              },
                            )
                          : Container(),
                      loginController.resetUserPassword != ''
                          ? CustContainer(
                              borderColor: Colors.red,
                              labelColor: colorWhite,
                              label: loginController.resetUserPassword,
                              iconPath: "assets/icons/failed_1.png",
                            )
                          : Container(),
                      SizedBox(
                        height: 1 * SizeConfig.heightMultiplier,
                      ),
                      loginController.isMailSend == false
                          ? CustButton(
                              name: "Send password reset",
                              size: 1.8,
                              width: 95,
                              height: 6,
                              btnColor: loginController.isValidEmailPass
                                  ? colorPrimary
                                  : colorPrimaryLight,
                              fontColor: colorBlack,
                              onSelected: () {
                                {
                                  loginController.validation(2);
                                  if (loginController.resetUserPassword == "") {
                                    // loginController.sendResetMail(true);
                                    Get.off(() => NewRestPasswordView());
                                  }
                                }
                              })
                          : CustButtonIconLast(
                              preIconPath: "assets/icons/enter_icon.png",
                              name: "Log in",
                              size: 1.8,
                              btnColor: colorPrimary,
                              fontColor: colorBlack,
                              onSelected: () {
                                Get.offAll(LoginView());
                              }),
                      SizedBox(
                        height: 2 * SizeConfig.heightMultiplier,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Don’t have an account? ',
                              style: TextStyle(
                                fontFamily: "Gilroy",
                                fontWeight: FontWeight.w500,
                                color: colorWhite,
                                fontSize: 1.6 * SizeConfig.textMultiplier,
                              ),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  var registerController =
                                      Get.put(RegisterController());
                                  registerController.cleanData();
                                  Get.offAll(() => RegisterView());
                                },
                              text: 'Sign up',
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
