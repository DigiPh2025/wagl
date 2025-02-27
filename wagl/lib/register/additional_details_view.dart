import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/custom_widget/toggle_button.dart';
import 'package:wagl/home/home_page.dart';
import 'package:wagl/register/about_you.dart';
import 'package:wagl/register/categories_view.dart';
import '../custom_widget/check_internet.dart';
import '../custom_widget/cust_calendar.dart';
import '../custom_widget/cust_container.dart';
import '../custom_widget/cust_text.dart';
import '../custom_widget/cust_text_field.dart';
import '../custom_widget/custom_loading_popup.dart';
import '../util/SizeConfig.dart';
import 'additional_details_controller.dart';
import 'google_map_view.dart';

class AdditionalDetailsView extends StatelessWidget {
  var additionalDetailsController = Get.put(AdditionalDetailsController());

  AdditionalDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
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
                              name: "Additional details",
                              size: 3.5,
                              colors: colorWhite,
                              textAlign: TextAlign.start,
                              fontWeightName: FontWeight.w900),
                          SizedBox(height: 2 * SizeConfig.heightMultiplier),
                          CustText(
                              name:
                                  "You can change this any time in settings.",
                              size: 1.6,
                              colors: colorGrey,
                              textAlign: TextAlign.justify,
                              fontWeightName: FontWeight.w500),
                          SizedBox(height: 2 * SizeConfig.heightMultiplier),
                          CustText(
                            name: "Date of birth",
                            size: 1.4,
                            colors: colorWhite,
                          ),
                          SizedBox(height: 1 * SizeConfig.heightMultiplier),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              DayPicker(
                                  controller:AdditionalDetailsController()),
                              MonthPicker(
                                  controller:AdditionalDetailsController()),
                              YearsPicker(
                                  controller:AdditionalDetailsController()),
                            ],
                          ),
                          SizedBox(height: 2 * SizeConfig.heightMultiplier),
                          CustText(
                            name: "Location",
                            size: 1.6,
                            colors: colorWhite,
                            fontWeightName: FontWeight.w500,
                          ),
                          SizedBox(height: 1 * SizeConfig.heightMultiplier),
                          additionalDetailsController.locationPermission?GestureDetector(
                            onTap: () async {
                             await additionalDetailsController.getCurrentLocation(context);

                              if(additionalDetailsController.locationPermission){
                                // additionalDetailsController.getCurrentLocation();
                                await additionalDetailsController.getLocation(false,"");
                                Get.to(() => GoogleMapView(1));
                              }
                            /*  additionalDetailsController.getCurrentLocation();
                              await additionalDetailsController.getLocation(false,"");
                              Get.to(() => GoogleMapView(1));*/
                            },
                            child: Container(
                              // height: 6 * SizeConfig.heightMultiplier,
                              width: 95 * SizeConfig.widthMultiplier,
                              // constraints: const BoxConstraints(
                              //   maxWidth: 500,
                              // ),
                              decoration: BoxDecoration(
                                color: colorBlack_3,
                                border: Border.all(
                                    color: borderColor,
                                    width: 0.25 * SizeConfig.widthMultiplier),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    2 * SizeConfig.widthMultiplier)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(
                                    2.0 * SizeConfig.widthMultiplier),
                                child: Stack(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustText(
                                        name: additionalDetailsController.selectedAddress,
                                        // name: "additionalDetailsController.selectedAddressadditionalDetailsController.selectedAddressadditionalDetailsController.selectedAddress",
                                        size: 1.6,
                                        colors: colorWhite,
                                        fontWeightName: FontWeight.w500,
                                        maxLine:6,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Image.asset(
                                          additionalDetailsController
                                                  .isAddressSelected
                                              ? "assets/icons/edit_icon_logo.png"
                                              : "assets/icons/search_icon.png",
                                          fit: BoxFit.contain,
                                          height: 3 * SizeConfig.heightMultiplier,
                                          width: 5 * SizeConfig.widthMultiplier,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ):
                          TextFieldWidget(
                              labelText: "",
                              widthSize: 100,
                              hintText: "Enter Location",
                              textEditingController:
                              additionalDetailsController.locationController,
                              isObscureText: false,
                              onChange: (value) {

                              }),
                          additionalDetailsController.fName != ''
                              ? CustContainer(
                                  borderColor: Colors.red,
                                  labelColor: colorWhite,
                                  label: additionalDetailsController.fName,
                                  iconPath: "assets/icons/failed_1.png",
                                )
                              : Container(),
                          SizedBox(height: 2 * SizeConfig.heightMultiplier),
                          CustText(
                            name: "Gender",
                            size: 1.6,
                            colors: colorWhite,
                            fontWeightName: FontWeight.w500,
                          ),
                          SizedBox(height: 1 * SizeConfig.heightMultiplier),
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
                                    bottom: 3.5 * SizeConfig.widthMultiplier),
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
                                  name: additionalDetailsController.genderDetails,
                                  size: 1.4,
                                  fontWeightName: FontWeight.w500,
                                  colors: colorWhite),
                              dropdownColor: colorBlack_2,
                              onChanged: (String? newValue) {
                                additionalDetailsController
                                    .updateGender(newValue);
                              },
                              items: <String>[
                                'Woman',
                                'Man',
                                'Non-binary',
                                'Other',
                                'Pefer not to say',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Container(
                                    child: Center(
                                      child: CustText(
                                        name: value,
                                        fontWeightName:FontWeight.w500 ,
                                        size: 1.4,
                                        colors: colorWhite,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 2 * SizeConfig.heightMultiplier),
                          CustText(
                            name: "Pronoun",
                            size: 1.6,
                            colors: colorWhite,
                            fontWeightName: FontWeight.w600,
                          ),
                          SizedBox(height: 0.5 * SizeConfig.heightMultiplier),
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
                                    bottom: 3.5 * SizeConfig.widthMultiplier),
                                child: const Icon(
                                    Icons.keyboard_arrow_down_rounded),
                              ),
                              iconSize: 25,
                              iconDisabledColor: colorWhite,
                              iconEnabledColor: colorWhite,

                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  fontFamily: "Gilroy",
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 1.4 * SizeConfig.textMultiplier/scaleFactor,
                                ),
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
                                  name: "${additionalDetailsController.pronounDetails}",
                                  size: 1.4,
                                  fontWeightName: FontWeight.w500,
                                  colors: colorWhite),
                              dropdownColor: colorBlack_2,
                              onChanged: (String? newValue) {
                                additionalDetailsController
                                    .updatePronoun(newValue);
                              },
                              items: <String>[
                                'He/His',
                                'She/Her',
                                'They/Them',
                                'Other',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Center(
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontFamily: "Gilroy",
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            1.4 * SizeConfig.textMultiplier/scaleFactor,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 2 * SizeConfig.heightMultiplier),
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
                            // height: 7 * SizeConfig.heightMultiplier,
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
                                      flag: additionalDetailsController
                                          .isPrivateAccount,
                                      onSelected: (flags) {
                                        additionalDetailsController
                                            .updateAccountType(flags);
                                        // print("flag if:: $flags ");
                                      })
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 2 * SizeConfig.heightMultiplier),
                          CustText(
                            name:
                                "When your account is public, your profile and posts can be seen by everyone, on or off Instagram, even if they don’t have an Instagram account. When your account is private, only the followers that you approve can see what you share.",
                            size: 1.6,
                            colors: colorGrey,
                            textAlign: TextAlign.justify,
                            fontWeightName: FontWeight.w500,
                          ),
                          SizedBox(height: 2 * SizeConfig.heightMultiplier),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => RegisterAboutView());
                                },
                                child: Container(
                                  width: 47 * SizeConfig.widthMultiplier,
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
                                          name: "Back",
                                          colors: colorWhite)),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                 if(additionalDetailsController.checkAdditionalDataFilled()){
                                   print("if ============  :");
                                   if (await CheckInternet.checkInternet()) {
                                     showDialog(
                                         context: context,
                                         builder: (BuildContext context) =>
                                             CustomLoadingPopup());
                                     final result =
                                     await additionalDetailsController
                                         .updateUserDetails(2);
                                     Navigator.pop(context);
                                     if (additionalDetailsController
                                         .updatedStatus ==
                                         true) {
                                       var snackdemo = SnackBar(
                                         content: CustText(
                                             name:
                                             "Details Updated Successfully !",
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

                                       await additionalDetailsController
                                           .fetchNames();
                                       Get.to(() => CategoriesView());
                                     } else {
                                       var snackdemo = SnackBar(
                                         content: CustText(
                                             name: "Please try again!",
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
                                 }else{
                                   print("else ============  :");
                                   var snackdemo = SnackBar(
                                     content: CustText(
                                         name:
                                         "Please enter valid data",
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
                                  width: 47 * SizeConfig.widthMultiplier,
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
                                          name: "Next",
                                          colors: colorBlack)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}
