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
import 'package:wagl/home/home_controller.dart';
import 'package:wagl/login/verify_password_view.dart';
import 'package:wagl/register/register_view.dart';
import 'package:wagl/util/ApiClient.dart';
import '../custom_widget/check_internet.dart';
import '../custom_widget/cust_container.dart';
import '../custom_widget/cust_text_field.dart';
import '../custom_widget/custom_loading_popup.dart';
import '../home/home_page.dart';
import '../home/main_screen.dart';
import '../profile/profile_controller.dart';
import '../register/about_you.dart';
import '../register/additional_details_controller.dart';
import '../register/register_controller.dart';
import '../util/SizeConfig.dart';
import '../util/custom_dialog.dart';
import 'login_controller.dart';

class LoginView extends StatelessWidget {
  var loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: colorBlack,
        body: GetBuilder<LoginController>(
          init: LoginController(),
          builder: (controller) => Stack(
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
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 2 * SizeConfig.widthMultiplier),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2.0 * SizeConfig.widthMultiplier),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2 * SizeConfig.heightMultiplier),
                        CustText(
                            name: "Login",
                            size: 3.5,
                            colors: colorWhite,
                            textAlign: TextAlign.start,
                            fontWeightName: FontWeight.w900),
                        SizedBox(height: 3 * SizeConfig.heightMultiplier),
                        TextFieldWidget(
                            labelText: "Email address",
                            widthSize: 100,
                            hintText: "Email address",
                            textEditingController:
                                loginController.userNameController,
                            isObscureText: false,
                            onChange: (value) {
                              loginController.checkText(
                                  loginController.userNameController.text
                                      .toString(),
                                  true);
                            }),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier),
                        TextFieldWidget(
                          labelText: "Password",
                          widthSize: 100,
                          hintText: "Password",
                          isObscureText: true,
                          textEditingController:
                              loginController.passwordController,
                          onChange: (value) {
                            loginController.checkText(
                                loginController.passwordController.text
                                    .toString(),
                                false);
                          },
                        ),
                        loginController.userPassword != ''
                            ? CustContainer(
                                borderColor: Colors.red,
                                label: loginController.userPassword,
                                labelColor: colorWhite,
                                iconPath: "assets/icons/failed_1.png",
                              )
                            : Container(),
                        loginController.userEmail != ''
                            ? CustContainer(
                                borderColor: Colors.red,
                                label: loginController.userEmail,
                                labelColor: colorWhite,
                                iconPath: "assets/icons/failed_1.png",
                              )
                            : Container(),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier),
                        GestureDetector(
                          onTap: () {
                            var loginController = Get.put(LoginController());
                            loginController.cleanData();
                            Get.to(
                              () => VerifyOtpView(),
                            );
                          },
                          child: Text(
                            "Forgot password",
                            style: TextStyle(
                              fontFamily: "Gilroy",
                              fontWeight: FontWeight.w500,
                              color: colorWhite,
                              fontSize: 1.6 * SizeConfig.textMultiplier/scaleFactor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 6 * SizeConfig.heightMultiplier,
                              width: 43 * SizeConfig.widthMultiplier,
                              child: Divider(
                                height: 10 * SizeConfig.heightMultiplier,
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
                              width: 43 * SizeConfig.widthMultiplier,
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
                              loginController.cleanData();
                              loginController.signInWithFacebook();
                            }),
                        SizedBox(
                          height: 2 * SizeConfig.heightMultiplier,
                        ),
                        GestureDetector(
                          onTap: () async {
                            loginController.signOut();

                            print("object");
                            User? user =
                                await loginController.signInWithGoogle();
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomLoadingPopup());
                            if (user != null) {
                              // Successfully signed in
                              print("Successfully signed in");
                              if (await CheckInternet.checkInternet()) {
                             /*   showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CustomLoadingPopup());*/
                                final result =
                                    await loginController.login(user.email);
                                Navigator.pop(context);
                                if (loginController.isVerified == true) {
                                  print(
                                      "Here is the varifies Status = ${loginController.isVerified}");
                                  var profileController =
                                      Get.put(ProfileController());
                                  await profileController.getProfileDetails(0);
                                  var homeController =
                                      Get.put(HomeController());
                                  homeController.getAllWagls(1,
                                      profileController.selectedCategoriesList);
                                await  Get.offAll(() => MyHomePage());
                                  homeController.onBottomOptionTapped(4);
                                  user.delete();
                                  loginController.updateFcmToken(
                                      "${ApiClient.box.read("authToken")}");
                                                   loginController.cleanData();
                                }

                                /*else if(loginController.isVerified==false){
                                  var registerController = Get.put(RegisterController());
                                  registerController.cleanData();
                                  final result = await registerController.signUp(user.email);
                                  print("Here  is the email  ${user.email}");
                                  if(registerController.isValidRegistration){
                                    print("object To the Registration Screen");
                                    Get.to(()=>RegisterAboutView());
                                    loginController.updateFcmToken("${ApiClient.box.read("authToken")}");
                                  }else if(ApiClient.box.read("authToken")!=""){
                                    print("object To the HomeScreen Screen");
                                    var profileController = Get.put(ProfileController());
                                    await profileController.getProfileDetails(0);
                                    Get.to(()=>MyHomePage());
                                    loginController.updateFcmToken("${ApiClient.box.read("authToken")}");
                                  }else{
                                  print("object To the HomeScreen Screen");
                                  var profileController = Get.put(ProfileController());
                                  await  profileController.getProfileDetails(0);
                                  Get.to(()=>MyHomePage());
                                  loginController.updateFcmToken("${ApiClient.box.read("authToken")}");
                                  loginController.cleanData();
                                  user.delete();
                                }
                                }*/
                                print(
                                    "Here is the varifies Status = ${loginController.isVerified}");
                                var snackdemo = SnackBar(
                                  content: CustText(
                                      name: loginController.userEmail,
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
                            } else {
                              var snackdemo = SnackBar(
                                content: CustText(
                                    name: 'Login with google unsuccessfully.',
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
                              print('Sign in failed $user');
                            }

                          },
                          child: Container(
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                        Platform.isIOS?Column(
                          children: [
                            CustButtonIcon(
                                preIconPath: "assets/icons/apple_icon.png",
                                name: "Continue with Apple",
                                size: 1.6,
                                btnColor: colorBlack_2,
                                fontColor: colorWhite,
                                onSelected: () {
                                  loginController.cleanData();
                                  loginController.signInWithApple();
                                }),
                            SizedBox(
                              height: 1 * SizeConfig.heightMultiplier,
                            ),
                          ],
                        ):Container(),

                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'By continuing, you agree to our ',
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
                                  fontSize: 1.4 * SizeConfig.textMultiplier,
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
                                  fontSize: 1.4 * SizeConfig.textMultiplier,
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
                            preIconPath: "assets/icons/enter_icon.png",
                            name: "Log in",
                            size: 1.8,
                            btnColor: loginController.isValidEmail &&
                                    loginController.isValidPass
                                ? colorPrimary
                                : colorPrimaryLight,
                            fontColor: colorBlack,
                            onSelected: () async {
                              print("Here ${ApiClient.box.read("authToken")}");
                              loginController.validation(1);
                              // Get.offAll(MyHomePage());
                              if (loginController.userEmail == "" &&
                                  loginController.userPassword == "") {
                                {
                                  if (await CheckInternet.checkInternet()) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CustomLoadingPopup());
                                    final result =
                                        await loginController.login(1);
                                    loginController.getFcmToken();
                                    Navigator.pop(context);
                                    if (loginController.isVerified == true) {
                                      print(
                                          "Here is the varifies Status = ${loginController.isVerified}");
                                      var profileController =
                                          Get.put(ProfileController());
                                      await profileController
                                          .getProfileDetails(0);
                                      var homeController =
                                          Get.put(HomeController());
                                      Get.offAll(() => MyHomePage());
                                      loginController.cleanData();
                                    } else {
                                      /*   print("Here is the varifies Status = ${loginController.isVerified}");
                                      var snackdemo = SnackBar(
                                        content: CustText(
                                            name: "Invalid Email or Password !",
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
                                          .showSnackBar(snackdemo);*/
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
                              }
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
                                text: 'Sign up',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    var registerController =
                                        Get.put(RegisterController());
                                    registerController.cleanData();
                                    Get.to(() => RegisterView());
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
