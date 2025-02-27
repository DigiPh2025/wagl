import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:wagl/custom_widget/blur_back_button.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import 'package:wagl/login/login_view.dart';
import 'package:wagl/onbroading/onbroading_controller.dart';
import 'package:wagl/register/register_view.dart';
import '../custom_widget/cust_button.dart';
import '../custom_widget/indicator_widget.dart';
import '../util/SizeConfig.dart';

class OnbroadingView extends StatelessWidget {
  var onbroadingController = Get.put(OnbroadingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBlack,
      body: GetBuilder<OnbroadingController>(
        init: OnbroadingController(),
        builder: (controller) => Stack(
          // fit: StackFit.expand,
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              'assets/images/onbroading_bg.png',
              fit: BoxFit.fill,
              height: 100 * SizeConfig.heightMultiplier,
              width: 100 * SizeConfig.widthMultiplier,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/images/design1.png',
                  fit: BoxFit.fill,
                  height: 40 * SizeConfig.heightMultiplier,
                  width: 70 * SizeConfig.widthMultiplier,
                ),
              ],
            ),
            Positioned(
              top: 10*SizeConfig.heightMultiplier,
              left: 0,
              child: onbroadingController.currentPageIndex!=0?Row(
                children: [
                  SizedBox(
                    width:2 * SizeConfig.widthMultiplier,
                  ),
                  GestureDetector(
                    onTap: (){
                      onbroadingController.updateCurrentPageIndex(
                          onbroadingController.currentPageIndex - 1);
                    },
                    child: CustBackButton(),
                  ),
                ],
              ):Container(),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height:15 * SizeConfig.heightMultiplier,
                ),
                SizedBox(
                  height: 10 * SizeConfig.heightMultiplier,
                ),
                SizedBox(
                  width: 100 * SizeConfig.widthMultiplier,
                  height: 50 * SizeConfig.heightMultiplier,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: 100 * SizeConfig.widthMultiplier,
                            height: 30 * SizeConfig.heightMultiplier,
                          ),
                          Container(
                            width: 100 * SizeConfig.widthMultiplier,
                            height: 20 * SizeConfig.heightMultiplier,
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 100,
                                  blurStyle: BlurStyle.normal,
                                  color: Colors.black,
                                  offset: Offset.zero,
                                  spreadRadius: 10,
                                ),
                              ],
                              // gradient: LinearGradient(
                              //   begin: Alignment.topCenter,
                              //   end: Alignment.bottomCenter,
                              //   colors: [
                              //     Colors.black38,
                              //     Colors.transparent,
                              //   ],
                              // ),
                            ),
                          ),
                        ],
                      ),
                      onbroadingController.isLoading
                          ? Container()
                          : PageView(
                              controller:
                                  onbroadingController.pageViewController,
                              onPageChanged:
                                  onbroadingController.handlePageViewChanged,
                              children: [
                                _buildPageContent(
                                  onbroadingController.welcomeModel
                                      .dataFields[0].attributes!.title
                                      .toString(),
                                  onbroadingController.welcomeModel
                                      .dataFields[0].attributes!.description
                                      .toString(),
                                  'assets/icons/wagl_onbroading.png',
                                ),
                                _buildPageContent(
                                  onbroadingController.welcomeModel
                                      .dataFields[1].attributes!.title
                                      .toString(),
                                  onbroadingController.welcomeModel
                                      .dataFields[1].attributes!.description
                                      .toString(),
                                  'assets/icons/wagl_onbroading1.png',
                                ),
                                _buildPageContent(
                                  onbroadingController.welcomeModel
                                      .dataFields[2].attributes!.title
                                      .toString(),
                                  onbroadingController.welcomeModel
                                      .dataFields[2].attributes!.description
                                      .toString(),
                                  'assets/icons/wagl_onbroading2.png',
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
                SizedBox(height: 2 * SizeConfig.heightMultiplier),
                IndicatorWidget(
                    index: onbroadingController.currentPageIndex + 1,
                    count: onbroadingController.welcomePageCount),
                SizedBox(height: 2 * SizeConfig.heightMultiplier),
                onbroadingController.currentPageIndex != 2
                    ? Column(
                        children: [
                          CustButton(
                            name: "Next",
                            width: 95,
                            height: 6,
                            size: 1.8,
                            fontColor: colorBlack,
                            btnColor: colorPrimary,
                            onSelected: () {
                              if (onbroadingController.currentPageIndex == 2) {
                                return;
                              }
                              onbroadingController.updateCurrentPageIndex(
                                  onbroadingController.currentPageIndex + 1);
                            },
                          ),
                          SizedBox(
                            height: 2 * SizeConfig.heightMultiplier,
                          ),
                          CustButton(
                            name: "Skip",
                            width: 95,
                            height: 6,
                            size: 1.8,
                            fontColor: c_white,
                            btnColor: colorBlack_2,
                            onSelected: () {
                              print("asdasd");
                              Get.offAll(LoginView());
                            },
                          ),
                          SizedBox(
                            height: 3 * SizeConfig.heightMultiplier,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: 9 * SizeConfig.heightMultiplier,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.0 * SizeConfig.widthMultiplier),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => RegisterView());
                                  },
                                  child: Container(
                                    width: 45 * SizeConfig.widthMultiplier,
                                    height: 6 * SizeConfig.heightMultiplier,
                                    decoration: BoxDecoration(
                                      color: colorPrimary,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(
                                        1.5 * SizeConfig.imageSizeMultiplier,
                                      )),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Center(
                                        child: CustText(
                                            size: 1.6,
                                            fontWeightName: FontWeight.w700,
                                            name: "Sign up",
                                            colors: colorBlack)),
                                  ),
                                ),
                                SizedBox(
                                  width: 5 * SizeConfig.widthMultiplier,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.offAll(LoginView());
                                  },
                                  child: Container(
                                    width: 45 * SizeConfig.widthMultiplier,
                                    height: 6 * SizeConfig.heightMultiplier,
                                    decoration: BoxDecoration(
                                      color: colorBlack_2,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(
                                        1.5 * SizeConfig.imageSizeMultiplier,
                                      )),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Center(
                                        child: CustText(
                                            size: 1.6,
                                            fontWeightName: FontWeight.w700,
                                            name: "Log in",
                                            colors: colorWhite)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2 * SizeConfig.heightMultiplier,
                          ),
                        ],
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(String text, String desc, String imagePath) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7 * SizeConfig.widthMultiplier),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 5 * SizeConfig.heightMultiplier),
          Image.asset(
            imagePath,
            fit: BoxFit.fitHeight,
            height: 25 * SizeConfig.heightMultiplier,
            width: 50 * SizeConfig.widthMultiplier,
          ),
          Stack(
            children: [
              CustText(
                name: text,
                size: 2.8,
                colors: colorWhite,
                textAlign: TextAlign.center,
                fontWeightName: FontWeight.w800,
              ),
            ],
          ),
          SizedBox(height: 2 * SizeConfig.heightMultiplier),
          CustText(
            name: desc,
            size: 1.6,
            colors: colorGrey,
            textAlign: TextAlign.center,
            fontWeightName: FontWeight.w800,
          ),
        ],
      ),
    );
  }
}
