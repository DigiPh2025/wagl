import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/custom_widget/cust_back_button.dart';
import 'package:wagl/login/login_view.dart';
import '../custom_widget/check_internet.dart';
import '../custom_widget/cust_button.dart';
import '../custom_widget/cust_container.dart';
import '../custom_widget/cust_text.dart';
import '../custom_widget/cust_text_field.dart';
import '../custom_widget/custom_loading_popup.dart';
import '../register/register_controller.dart';
import '../register/register_view.dart';
import '../util/SizeConfig.dart';
import 'login_controller.dart';

class ResetNewPasswordView extends StatelessWidget {
  var loginController = Get.put(LoginController());

  ResetNewPasswordView({super.key});

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
                          name:
                              "Please create new password for ${loginController.resetUserController.text.toString()}",
                          size: 1.6,
                          colors: colorGrey,
                          textAlign: TextAlign.start,
                          fontWeightName: FontWeight.w600),
                      SizedBox(height: 2 * SizeConfig.heightMultiplier),
                      TextFieldWidget(
                        labelText: "Password",
                        widthSize: 100,
                        hintText: "Password",
                        isObscureText: true,
                        textEditingController:
                            loginController.passwordController,
                        onChange: (value) {
                          loginController.validation(3);
                          loginController.checkText(
                              loginController.passwordController.text
                                  .toString(),
                              false);
                        },
                      ),
                      SizedBox(height: 2 * SizeConfig.heightMultiplier),
                      TextFieldWidget(
                        labelText: "Confirm password",
                        widthSize: 100,
                        hintText: "Confirm password",
                        isObscureText: true,
                        textEditingController:
                            loginController.confirmPasswordController,
                        onChange: (value) {
                          loginController.validation(3);
                          loginController.checkText(
                              loginController.confirmPasswordController.text
                                  .toString(),
                              false);
                        },
                      ),
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
                      loginController.confirmPassword != ''
                          ? CustContainer(
                              borderColor: Colors.red,
                              labelColor: colorWhite,
                              label: loginController.confirmPassword,
                              iconPath: "assets/icons/failed_1.png",
                            )
                          : Container(),
                      SizedBox(height: 1 * SizeConfig.heightMultiplier),

                      CustButton(
                        // preIconPath: "assets/icons/enter_icon.png",
                        name: "Confirm",
                        size: 1.8,
                        btnColor: loginController.confirmPassword == ''
                            ? colorPrimary
                            : colorPrimaryLight,
                        fontColor: colorBlack,
                        onSelected: () {
                          ConnectionChecker.checkConnection(
                            context: context,
                            onConnected: () async {
                              loginController.validation(3);
                              if (loginController.confirmPassword == "") {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CustomLoadingPopup());
                                final result =
                                    await loginController.resetNewPassword();
                                Navigator.pop(context);
                                if (loginController.updatedStatus) {
                                  loginController.cleanData();
                                  Get.offAll(LoginView());
                                } else {
                                  var snackdemo = SnackBar(
                                    content: CustText(
                                        name:
                                            "Something went wrong, please try again",
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
                            },
                          );
                        },
                        width: 100,
                        height: 6,
                      ),
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
