import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/custom_widget/cust_back_button.dart';
import 'package:wagl/login/login_view.dart';
import 'package:wagl/login/reset_new_password_view.dart';
import 'package:wagl/util/ApiClient.dart';
import '../custom_widget/check_internet.dart';
import '../custom_widget/cust_button.dart';
import '../custom_widget/cust_button_with_icon.dart';
import '../custom_widget/cust_button_with_icon_last.dart';
import '../custom_widget/cust_container.dart';
import '../custom_widget/cust_text.dart';
import '../custom_widget/cust_text_field.dart';
import '../register/register_controller.dart';
import '../register/register_view.dart';
import '../util/SizeConfig.dart';
import 'login_controller.dart';

class VerifyOtpView extends StatelessWidget {
  var loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
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
                              ? "We have sent an passcode to the email of ${loginController.resetUserController.text.toString()}. Please check mail."
                              : "Enter the email address associated with your Wagl account, and we’ll send you an email with instructions for how to reset your password.",
                          size: 1.6,
                          colors: colorGrey,
                          textAlign: TextAlign.start,
                          fontWeightName: FontWeight.w600),
                      loginController.isMailSend? SizedBox(height: 3 * SizeConfig.heightMultiplier):Container(),
                      loginController.isMailSend?  CustText(
                          name:
                             "Enter passcode",size: 1.6,
                          colors: colorGrey,
                          textAlign: TextAlign.start,
                          fontWeightName: FontWeight.w600):Container(),


                      SizedBox(height: 3 * SizeConfig.heightMultiplier),
                      loginController.isMailSend? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(5, (index) {
                          return Container(
                            width: 14*SizeConfig.widthMultiplier,
                            height: 14*SizeConfig.widthMultiplier,
                            decoration: BoxDecoration(
                              color: colorBackground,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(2 * SizeConfig.widthMultiplier)),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: TextField(
                              cursorColor: Colors.white,
                              controller: loginController.otpControllers[index],
                              focusNode: loginController.focusNodes[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Gilroy",
                                color: colorWhite,
                                fontWeight: FontWeight.w500,
                                fontSize:2.0 * SizeConfig.textMultiplier/scaleFactor,
                              ),
                              keyboardType: TextInputType.numberWithOptions(decimal: false,signed: false),
                              maxLength: 1,
                              decoration: InputDecoration(
                                counterText: "",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: colorBlack2Shadow),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(2 * SizeConfig.widthMultiplier)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: colorPrimary),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(2 * SizeConfig.widthMultiplier)),
                                ),

                              ),

                              onChanged: (value) => loginController.updateOtp(value, index),
                            ),
                          );
                        }),
                      ):Container(),
                      loginController.isMailSend? SizedBox(height: 3 * SizeConfig.heightMultiplier):Container(),

                      loginController.isMailSend==false?TextFieldWidget(
                        labelText: "Email address",
                        widthSize: 100,
                        hintText: "Email address",
                        textEditingController:
                            loginController.resetUserController,
                        isObscureText: false,
                        onChange: (value) async {
                          loginController.checkEmail(loginController.resetUserController.text.toString());
                        },
                      ):Container(),
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
                      loginController.isMailSend==false
                          ? CustButton(
                              name: "Send password reset",
                              size: 1.8,
                          width: 95,
                          height: 6,
                              btnColor: loginController.isValidEmailPass?colorPrimary:colorPrimaryLight,
                              fontColor: colorBlack,
                              onSelected: () {

                                ConnectionChecker.checkConnection(
                                  context: context,
                                  onConnected: () async {
                                    loginController.validation(2);
                                    if(loginController.resetUserPassword==""){
                                     var result= await loginController.sendResetMail(true);
                                     var snackdemo = SnackBar(
                                       content: CustText(
                                           name:
                                           "${loginController.errorMessage}",
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
                                );

                              })
                          : CustButton(
                              // preIconPath: "assets/icons/enter_icon.png",
                              name: "Confirm",
                              size: 1.8,
                              btnColor: loginController.confirmOtp.length==5?colorPrimary:colorPrimaryLight,
                              fontColor: colorBlack,
                              onSelected: () {

                                if(loginController.isMailSend){
                                  String otp = loginController.getOtp();
                                  print("Entered OTP: $otp");
                                  if(otp.length==5){
                                  print("ResetNewPasswordViewResetNewPasswordView");
                                  Get.to(()=>ResetNewPasswordView());
                                  }else{
                                    var snackdemo = SnackBar(
                                      content: CustText(
                                          name:
                                          "Please enter the valid passcode",
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
                                // Get.offAll(LoginView());
                              }, width: 100,
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
                                fontSize: 1.6 * SizeConfig.textMultiplier/scaleFactor,
                              ),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  var registerController =
                                  Get.put(RegisterController());
                                  registerController.cleanData();
                                  Get.put(()=>RegisterView());
                                },
                              text: 'Sign up',
                              style: TextStyle(
                                fontFamily: "Gilroy",
                                fontWeight: FontWeight.w500,
                                     color: colorWhite,
                                fontSize: 1.6 * SizeConfig.textMultiplier/scaleFactor,
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
