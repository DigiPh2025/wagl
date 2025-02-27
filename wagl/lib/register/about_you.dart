import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:wagl/custom_widget/Strings.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/register/additional_details_view.dart';
import 'package:wagl/register/register_controller.dart';

import '../custom_widget/check_internet.dart';
import '../custom_widget/cust_button.dart';
import '../custom_widget/cust_container.dart';
import '../custom_widget/cust_text.dart';
import '../custom_widget/cust_text_field.dart';
import '../custom_widget/custom_loading_popup.dart';
import '../util/SizeConfig.dart';
import 'additional_details_controller.dart';

class RegisterAboutView extends StatelessWidget {
  var additionalDetailsController = Get.put(AdditionalDetailsController());

  RegisterAboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return SafeArea(
        child: Scaffold(
            // resizeToAvoidBottomInset: false,
            backgroundColor: colorBlack,
            body: GetBuilder<AdditionalDetailsController>(
              init: AdditionalDetailsController(),
              builder: (controller) => Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
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
                          horizontal: 1.8 * SizeConfig.widthMultiplier),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5 * SizeConfig.heightMultiplier),
                          CustText(
                              name: "About you",
                              size: 3.5,
                              colors: colorWhite,
                              textAlign: TextAlign.start,
                              fontWeightName: FontWeight.w900),
                          SizedBox(height: 2 * SizeConfig.heightMultiplier),
                          CustText(
                              name:
                                  "Hey there! To know you better tell us more about yourself. Fill the following details to proceed further.",
                              size: 1.6,
                              colors: colorGrey,
                              textAlign: TextAlign.justify,
                              fontWeightName: FontWeight.w500),
                          SizedBox(height: 2 * SizeConfig.heightMultiplier),
                          TextFieldWidget(
                            labelText: "$firstName*",
                            widthSize: 100,
                            textEditingController:
                                additionalDetailsController.firstNameController,
                            hintText: "${firstName}",
                            isObscureText: false,
                            onChange: (value) {
                              additionalDetailsController.validationNames();
                            },
                          ),
                          additionalDetailsController.fName != ''
                              ? CustContainer(
                                  borderColor: Colors.red,
                                  labelColor: colorWhite,
                                  label: additionalDetailsController.fName,
                                  iconPath: "assets/icons/failed_1.png",
                                )
                              : Container(),
                          SizedBox(height: 2 * SizeConfig.heightMultiplier),
                          TextFieldWidget(
                            labelText: "Last name*",
                            widthSize: 100,
                            hintText: "Last name",
                            textEditingController:
                                additionalDetailsController.lastNameController,
                            isObscureText: false,
                            onChange: (value) {
                              additionalDetailsController.validationNames();
                            },
                          ),
                          additionalDetailsController.lName != ''
                              ? CustContainer(
                                  labelColor: colorWhite,
                                  borderColor: Colors.red,
                                  label: additionalDetailsController.lName,
                                  iconPath: "assets/icons/failed_1.png",
                                )
                              : Container(),
                          SizedBox(height: 2 * SizeConfig.heightMultiplier),
                          TextFieldWidget(
                            labelText: "$userName*",
                            widthSize: 100,
                            hintText: userName,
                            textEditingController:
                            additionalDetailsController.userNameController,
                            isObscureText: false,
                            onChange: (value) async {
                              await additionalDetailsController.checkUsernameApi(value.toString());
                              additionalDetailsController.validationNames();
                            },
                          ),
                          additionalDetailsController.userName != ''
                              ? CustContainer(
                            borderColor: Colors.red,
                            labelColor: colorWhite,
                            label: additionalDetailsController.userName,
                            iconPath: "assets/icons/failed_1.png",
                          )
                              : Container(),
/////////////////////////////////////////////////////////////////////
                          SizedBox(height: 2 * SizeConfig.heightMultiplier),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                  width: 100 * SizeConfig.widthMultiplier,
                                  child: CustText(
                                    name: "$contactNumber*",
                                    size: 1.6,
                                    colors: colorWhite,
                                    fontWeightName: FontWeight.w600,
                                    textAlign: TextAlign.start,
                                  )),
                              SizedBox(height: 1 * SizeConfig.heightMultiplier),
                              Container(
                                height: 5.5 * SizeConfig.heightMultiplier,
                                width: 100 * SizeConfig.widthMultiplier,
                                decoration: BoxDecoration(
                                  color: colorBackground,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(2 * SizeConfig.widthMultiplier)),
                                ),
                                child: Center(
                                  child: TextField(
                                    keyboardType: TextInputType.phone,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: "Gilroy",
                                      color: colorWhite,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 1.6 * SizeConfig.textMultiplier/scaleFactor,
                                    ),
                                    controller:  additionalDetailsController.contactNoController,
                                    cursorColor: colorWhite,
                                    obscureText: false,
maxLength: 10,
                                    onTapOutside: (Value) {

                                      FocusManager.instance.primaryFocus?.unfocus();
                                    },
                                    onChanged: (value) {
                                      additionalDetailsController.validationNames();
                                    },
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      contentPadding: EdgeInsets.only(
                                        top: -0.5 * SizeConfig.widthMultiplier,
                                        left: 2 * SizeConfig.widthMultiplier,
                                        right: 2 * SizeConfig.widthMultiplier,
                                      ),
                                      constraints: BoxConstraints.tightFor(
                                          height: 5.5 * SizeConfig.heightMultiplier),
                                      fillColor: colorPrimary,
                                      /*contentPadding: new EdgeInsets.symmetric(
                                              vertical:
                                              2 * SizeConfig.widthMultiplier,
                                              horizontal:
                                              2 * SizeConfig.widthMultiplier),*/
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(2 * SizeConfig.widthMultiplier),
                                        borderSide: const BorderSide(
                                          color: colorPrimary,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(2 * SizeConfig.widthMultiplier),
                                        borderSide: const BorderSide(
                                          color: borderColor,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(2 * SizeConfig.widthMultiplier),
                                        borderSide: const BorderSide(
                                          color: colorPrimary,
                                          // width: 2.0,
                                        ),
                                      ),
                                      hintText: contactNumber,

                                      hintStyle: TextStyle(
                                        fontFamily: "Gilroy",
                                        color: colorGrey,
                                        fontSize: 1.6 * SizeConfig.textMultiplier/scaleFactor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          additionalDetailsController.isValidContactNo != ''
                              ? CustContainer(
                            borderColor: Colors.red,
                            labelColor: colorWhite,
                            label: additionalDetailsController.isValidContactNo,
                            iconPath: "assets/icons/failed_1.png",
                          )
                              : Container(),

                          SizedBox(height: 2 * SizeConfig.heightMultiplier),
                          CustButton(
                            name: "Next",
                            size: 1.8,
                            width: 95,
                            height: 6,
                            btnColor: additionalDetailsController.allNames
                                ? colorPrimary
                                : colorPrimaryLight,
                            fontColor: colorBlack,
                            onSelected: () async {
                              {
                                additionalDetailsController.validation();
                                if (additionalDetailsController.fName == "" &&
                                    additionalDetailsController.lName == "" &&
                                    additionalDetailsController.userName ==
                                        ""&&additionalDetailsController.isValidContactNo ==
                                    "") {
                                  print("Go to Next Page");
                                  if (await CheckInternet.checkInternet()) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CustomLoadingPopup());
                                    final result =
                                        await additionalDetailsController.updateUserDetails(1);
                                    Navigator.pop(context);
                                    if (additionalDetailsController.updatedStatus == true) {
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
                                      additionalDetailsController.cleanData();
                                      additionalDetailsController.fetchNames();
                                      Get.to(()=>AdditionalDetailsView());
                                    } else {
                                      var snackdemo = SnackBar(
                                        content: CustText(
                                            name: "Please try again! ",
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
                              }
                            },
                          ),
                          SizedBox(height: 10 * SizeConfig.heightMultiplier),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}
