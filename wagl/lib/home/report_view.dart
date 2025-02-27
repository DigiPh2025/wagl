import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wagl/custom_widget/cust_button.dart';
import 'package:wagl/custom_widget/cust_button1.dart';
import 'package:wagl/home/home_controller.dart';

import '../custom_widget/check_internet.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_text.dart';
import '../custom_widget/custom_loading_popup.dart';
import '../custom_widget/custom_text_loading_popup.dart';
import '../util/SizeConfig.dart';
import 'home_page.dart';

class ReportSectionView extends StatelessWidget {
  int waglId;
  int userId;
  bool isUserReport;
  final HomeController homeController = Get.put(HomeController());

  ReportSectionView(this.waglId, this.userId,this.isUserReport, {super.key});

  bool _keyboardVisible = false;

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: _keyboardVisible ? 1 : 0.60,
            minChildSize: 0.3,
            maxChildSize: 1.0,
            builder: (context, scrollController) {
              return SizedBox(
                child: Stack(children: [
                  Positioned(
                      top: 0,
                      child: Image.asset(
                        "assets/background/dailog_bg.png",
                        width: 100 * SizeConfig.widthMultiplier,
                        height: 10 * SizeConfig.heightMultiplier,
                        fit: BoxFit.fill,
                      )),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 3 * SizeConfig.widthMultiplier,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: colorBlack2Light,
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                          height: 0.7 * SizeConfig.heightMultiplier,
                          width: 12.5 * SizeConfig.widthMultiplier,
                        ),
                        SizedBox(
                          height: 6 * SizeConfig.widthMultiplier,
                        ),
                        CustTextBold(
                          name: isUserReport?"Report profile":"Report",
                          size: 2.0,
                          colors: colorWhite,
                          fontWeightName: FontWeight.w500,
                        ),
                        SizedBox(
                          height: 0 * SizeConfig.heightMultiplier,
                        ),
                        SizedBox(
                          height: 5 * SizeConfig.heightMultiplier,
                          width: 100 * SizeConfig.widthMultiplier,
                          child: Divider(
                            color: borderColor,
                            indent: 3 * SizeConfig.widthMultiplier,
                            endIndent: 3 * SizeConfig.widthMultiplier,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                          child: Container(
                            width: 100 * SizeConfig.widthMultiplier,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustText(
                                    name: isUserReport?"Why are you reporting this user ?":"Why are you reporting this post?",
                                    size: 1.6,
                                    colors: colorWhite,
                                    fontWeightName: FontWeight.w600),
/*                                SizedBox(
                                    height: 2 * SizeConfig.heightMultiplier),
                                CustText(
                                    name:
                                        "${homeController.reportMessage.isNotEmpty?homeController.reportMessage[0].description:""}",
                                    size: 1.5,
                                    colors: colorGreyLight2,
                                    fontWeightName: FontWeight.w500),*/
                                SizedBox(
                                    height: 2 * SizeConfig.heightMultiplier),
                                Container(
                                  width: 100 * SizeConfig.widthMultiplier,
                                  height: 7 * SizeConfig.heightMultiplier,
                                  decoration: BoxDecoration(
                                      color: colorBlack_3,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: DropdownButtonFormField<String>(
                                    // menuMaxHeight: 50,
                                    icon: Padding(
                                      padding: EdgeInsets.only(
                                          bottom:
                                              3.5 * SizeConfig.widthMultiplier),
                                      child: const Icon(
                                          Icons.keyboard_arrow_down_rounded),
                                    ),
                                    iconSize: 25,
                                    iconDisabledColor: colorWhite,
                                    iconEnabledColor: colorWhite,

                                    decoration: InputDecoration(
                                      fillColor: colorBlack_3,
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: borderColor,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: borderColor,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    hint: CustText(
                                        name: homeController.reasonText,
                                        size: 1.4,
                                        fontWeightName: FontWeight.w500,
                                        colors: colorWhite),
                                    dropdownColor: colorBlack_2,
                                    onChanged: (String? newValue) {
                                      homeController
                                          .updateReportReason(newValue);
                                    },
                                    items: homeController.reportType
                                        .map<DropdownMenuItem<String>>(
                                            (reportType) {
                                      return DropdownMenuItem<String>(
                                        value: reportType.reason,
                                        child: Container(
                                          child: Center(
                                            child: CustText(
                                              name: reportType.reason!,
                                              fontWeightName: FontWeight.w500 ,
                                              colors: colorWhite,
                                              size: 1.5,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(
                                    height: 2 * SizeConfig.heightMultiplier),
                                homeController.reasonText == "Please select"
                                    ? Container()
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustText(
                                              name: "Additional information",
                                              size: 1.6,
                                              colors: colorWhite,
                                              fontWeightName: FontWeight.w600),
                                          TextField(
                                            maxLines:6,
                                            style: TextStyle(
                                              fontFamily: "Gilroy",
                                              color: colorWhite,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 1.6 *
                                                  SizeConfig.textMultiplier/scaleFactor,
                                            ),
                                            controller: homeController
                                                .reportTextController,
                                            cursorColor: colorWhite,
                                            obscureText: false,
                                            onTap: () {
                                              // FocusManager.instance.notifyListeners();
                                            },
                                            onChanged: (va) {
                                              if (va == "@") {
                                              } else {}
                                            },
                                            onTapOutside: (Value) {
                                              print("ASDASDAS");
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            textInputAction:
                                                TextInputAction.newline,
                                            decoration: InputDecoration(
                                              filled: true,
                                              counterText: "",
                                              contentPadding: EdgeInsets.only(
                                                top: 2 *
                                                    SizeConfig.heightMultiplier,
                                                left: 2 *
                                                    SizeConfig.widthMultiplier,
                                                right: 2 *
                                                    SizeConfig.widthMultiplier,
                                              ),
                                              fillColor: colorBackground,
                                              /*contentPadding: new EdgeInsets.symmetric(
                                                  vertical:
                                                  2 * SizeConfig.widthMultiplier,
                                                  horizontal:
                                                  2 * SizeConfig.widthMultiplier),*/
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2 *
                                                        SizeConfig
                                                            .widthMultiplier),
                                                borderSide: const BorderSide(
                                                  color: colorPrimary,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2 *
                                                        SizeConfig
                                                            .widthMultiplier),
                                                borderSide: const BorderSide(
                                                  color: colorGreyLight2,
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2 *
                                                        SizeConfig
                                                            .widthMultiplier),
                                                borderSide: const BorderSide(
                                                  color: colorPrimary,
                                                  // width: 2.0,
                                                ),
                                              ),
                                              hintText: homeController
                                                  .additionalDetailsText,
                                              hintStyle: TextStyle(
                                                fontFamily: "Gilroy",
                                                color: colorWhite,
                                                fontSize: 1.2 *
                                                    SizeConfig.textMultiplier/scaleFactor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                SizedBox(
                                  height: homeController.reasonText ==
                                          "Please select"
                                      ? 13 * SizeConfig.heightMultiplier
                                      : 2 * SizeConfig.heightMultiplier,
                                ),
                                CustButton(
                                  name: "Confirm",
                                  size: 1.5,
                                  btnColor: homeController.reasonText ==
                                          "Please select"
                                      ? colorPrimaryLight
                                      : colorPrimary,
                                  width: 100,
                                  height: 7,
                                  fontColor: colorBlack,
                                  onSelected: () {
                                    ConnectionChecker.checkConnection(
                                      context: context,
                                      onConnected: () {
                                        if (homeController.reasonText !=
                                            "Please select") {
                                          if(isUserReport){
                                            homeController
                                                .submitReport(
                                                userId,true);
                                          }else{
                                            homeController
                                                .submitReport(
                                                waglId,false);
                                          }

                                          Navigator.pop(context);
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              context: context,
                                              backgroundColor: backgroundDialog,
                                              builder: (context) {
                                                return DraggableScrollableSheet(
                                                    expand: false,
                                                    initialChildSize: 0.60,
                                                    minChildSize: 0.3,
                                                    maxChildSize: 1.0,
                                                    builder: (context,
                                                        scrollController) {
                                                      return SizedBox(
                                                          child: Stack(
                                                            children: [
                                                              Column(children: [
                                                                SizedBox(
                                                                  height: 3 *
                                                                      SizeConfig
                                                                          .widthMultiplier,
                                                                ),
                                                                Container(
                                                                  decoration:
                                                                  const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .rectangle,
                                                                    color:
                                                                    colorBlack2Light,
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                      Radius.circular(
                                                                          50),
                                                                    ),
                                                                  ),
                                                                  height: 0.7 *
                                                                      SizeConfig
                                                                          .heightMultiplier,
                                                                  width: 12.5 *
                                                                      SizeConfig
                                                                          .widthMultiplier,
                                                                ),
                                                                SizedBox(
                                                                  height: 6 *
                                                                      SizeConfig
                                                                          .widthMultiplier,
                                                                ),
                                                                CustTextBold(
                                                                  name:
                                                                  "Thanks for letting us know",
                                                                  size: 2.0,
                                                                  colors: colorWhite,
                                                                  fontWeightName:
                                                                  FontWeight.w500,
                                                                ),
                                                                SizedBox(
                                                                  height: 4 *
                                                                      SizeConfig
                                                                          .widthMultiplier,
                                                                ),
                                                                SizedBox(
                                                                  height: 5 *
                                                                      SizeConfig
                                                                          .heightMultiplier,
                                                                  width: 100 *
                                                                      SizeConfig
                                                                          .widthMultiplier,
                                                                  child: Divider(
                                                                    color: borderColor,
                                                                    indent: 3 *
                                                                        SizeConfig
                                                                            .widthMultiplier,
                                                                    endIndent: 3 *
                                                                        SizeConfig
                                                                            .widthMultiplier,
                                                                    thickness: 1,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 2 *
                                                                        SizeConfig
                                                                            .heightMultiplier),
                                                                CustText(
                                                                    name:
                                                                    "${homeController.reportMessage[0].description}",
                                                                    size: 1.5,
                                                                    colors:
                                                                    colorGreyLight2,
                                                                    fontWeightName:
                                                                    FontWeight
                                                                        .w500),
                                                                Spacer(),
                                                                CustButton(
                                                                  name: "Okay",
                                                                  size: 1.5,
                                                                  btnColor: homeController
                                                                      .reasonText ==
                                                                      "Please select"
                                                                      ? colorPrimaryLight
                                                                      : colorPrimary,
                                                                  fontColor: colorBlack,
                                                                  onSelected: () {

                                                                    Navigator.pop(context);
                                                                  },
                                                                  width: 98,
                                                                  height: 7,
                                                                ),
                                                                SizedBox(
                                                                    height: 2 *
                                                                        SizeConfig
                                                                            .heightMultiplier),
                                                              ]),
                                                            ],
                                                          ));
                                                    });
                                              });
                                        }
                                      },
                                    );

                                  },
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ]),
              );
            }));
  }
}
