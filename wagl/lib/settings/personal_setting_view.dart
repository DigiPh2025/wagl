import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/custom_widget/cust_button_with_icon_last.dart';
import 'package:wagl/settings/settings_controller.dart';
import '../custom_widget/Strings.dart';
import '../custom_widget/check_internet.dart';
import '../custom_widget/cust_appbar.dart';
import '../custom_widget/cust_calendar.dart';
import '../custom_widget/cust_text.dart';
import '../custom_widget/cust_text_field.dart';
import '../custom_widget/custom_loading_popup.dart';
import '../profile/profile_controller.dart';
import '../util/SizeConfig.dart';

class PersonalSettingsView extends StatelessWidget {
  String titleName;
  var settingController = Get.put(SettingController());

  PersonalSettingsView({required this.titleName, super.key});

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorBlack,
        body: GetBuilder<SettingController>(
          init: SettingController(),
          builder: (controller) => SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 1.8 * SizeConfig.widthMultiplier),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustAppbar(title: personalDetails),
                  SizedBox(
                    height: 2 * SizeConfig.heightMultiplier,
                  ),
                  TextFieldWidget(
                    labelText: firstName,
                    widthSize: 100,
                    hintText: firstName,
                    textEditingController:
                        settingController.firstNameController,
                    isObscureText: false,
                    onChange: (value) {},
                  ),
                  SizedBox(
                    height: 2 * SizeConfig.heightMultiplier,
                  ),
                  TextFieldWidget(
                    labelText: lastName,
                    widthSize: 100,
                    hintText: lastName,
                    textEditingController: settingController.lastNameController,
                    isObscureText: false,
                    onChange: (value) {},
                  ),
                  SizedBox(
                    height: 2 * SizeConfig.heightMultiplier,
                  ),
                  TextFieldWidget(
                    labelText: userName,
                    widthSize: 100,
                    hintText: userName,
                    textEditingController: settingController.userNameController,
                    isObscureText: false,
                    onChange: (value) {},
                  ),
                  SizedBox(
                    height: 2 * SizeConfig.heightMultiplier,
                  ),
                  CustText(
                    name: "Date of birth",
                    size: 1.6,
                    colors: colorWhite,
                    fontWeightName: FontWeight.w500,
                  ),
                  SizedBox(height: 1 * SizeConfig.heightMultiplier),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DayPicker(
                          controller: SettingController()),
                      MonthPicker(
                          controller: SettingController()),
                      YearsPicker(
                          controller: SettingController()),
                    ],
                  ),
                  SizedBox(
                    height: 2 * SizeConfig.heightMultiplier,
                  ),
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
                    child: DropdownButtonFormField<String>(
                      // menuMaxHeight: 50,
                      icon: Padding(
                        padding: EdgeInsets.only(
                            bottom: 3.5 * SizeConfig.widthMultiplier),
                        child: const Icon(Icons.keyboard_arrow_down_rounded),
                      ),
                      iconSize: 25,
                      iconDisabledColor: colorWhite,
                      iconEnabledColor: colorWhite,
                      decoration: InputDecoration(
                        fillColor: colorBackground,
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
                          name: settingController.gender,
                          size: 1.4,
                          fontWeightName: FontWeight.w500,
                          colors: colorWhite),
                      dropdownColor: colorBlack_2,
                      onChanged: (String? newValue) {
                        settingController.gender = newValue!;
                      },
                      items: <String>['Male', 'Female', 'Other']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Center(
                            child: Text(
                              value,
                              style: TextStyle(
                                fontFamily: "Gilroy",
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 1.4 * SizeConfig.textMultiplier/scaleFactor,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 2 * SizeConfig.heightMultiplier,
                  ),
                  TextFieldWidget(
                    labelText: locationName,
                    widthSize: 100,
                    hintText: locationName,
                    textEditingController: settingController.locationNameController,
                    isObscureText: false,

                    onChange: (value) {

                    },
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
                    child: DropdownButtonFormField<String>(
                      // menuMaxHeight: 50,
                      icon: Padding(
                        padding: EdgeInsets.only(
                            bottom: 3.5 * SizeConfig.widthMultiplier),
                        child: const Icon(Icons.keyboard_arrow_down_rounded),
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
                        fillColor: colorBackground,
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
                          name: settingController.pronouns,
                          size: 1.4,
                          fontWeightName: FontWeight.w500,
                          colors: colorWhite),
                      dropdownColor: colorBlack_2,
                      onChanged: (String? newValue) {
                        settingController.pronouns = newValue!;
                      },
                      items: <String>['He/His', 'She/Her', 'They/Them', 'Other']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Center(
                            child: Text(
                              value,
                              style: TextStyle(
                                fontFamily: "Gilroy",
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 1.4 * SizeConfig.textMultiplier/scaleFactor,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 2 * SizeConfig.heightMultiplier,
                  ),
                  Row(
                    children: [
                      CustText(
                          name: bio,
                          size: 1.4,
                          colors: colorWhite,
                          fontWeightName: FontWeight.w600)
                    ],
                  ),
                  SizedBox(
                    height: 1 * SizeConfig.heightMultiplier,
                  ),
                  TextField(
                    maxLines: 8,
                    style: TextStyle(
                      fontFamily: "Gilroy",
                      color: colorWhite,
                      fontWeight: FontWeight.w500,
                      fontSize: 1.6 * SizeConfig.textMultiplier/scaleFactor,
                    ),
                    controller: settingController.bioTextController,
                    cursorColor: colorWhite,
                    obscureText: false,
                    onTap: () {
                      // FocusManager.instance.notifyListeners();
                    },
                    onTapOutside: (Value) {
                      print("ASDASDAS");
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onChanged: (value) {},
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      filled: true,
                      counterText: "",
                      contentPadding: EdgeInsets.only(
                        top: 2 * SizeConfig.heightMultiplier,
                        left: 2 * SizeConfig.widthMultiplier,
                        right: 2 * SizeConfig.widthMultiplier,
                      ),
                      fillColor: colorBackground,
                      /*contentPadding: new EdgeInsets.symmetric(
                                              vertical:
                                              2 * SizeConfig.widthMultiplier,
                                              horizontal:
                                              2 * SizeConfig.widthMultiplier),*/
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            2 * SizeConfig.widthMultiplier),
                        borderSide: const BorderSide(
                          color: colorPrimary,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            2 * SizeConfig.widthMultiplier),
                        borderSide: const BorderSide(
                          color: borderColor,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            2 * SizeConfig.widthMultiplier),
                        borderSide: const BorderSide(
                          color: colorPrimary,
                          // width: 2.0,
                        ),
                      ),
                      hintText: bio,
                      hintStyle: TextStyle(
                        fontFamily: "Gilroy",
                        color: colorWhite,
                        fontSize: 1.2 * SizeConfig.textMultiplier/scaleFactor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2 * SizeConfig.heightMultiplier,
                  ),
                  CustButtonIconLast(
                      name: updateString,
                      size: 1.8,
                      btnColor: colorPrimary,
                      fontColor: colorBlack,
                      onSelected: () async {
                        if (await CheckInternet.checkInternet()) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CustomLoadingPopup());
                          final result =
                              await settingController.updateUserDetails();
                          Navigator.pop(context);
                          if (settingController.updatedStatus == true) {
                            var profileController = Get.put(ProfileController());
                            await profileController.getProfileDetails(0);
                            Get.back();
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
                          ScaffoldMessenger.of(context).showSnackBar(snackdemo);
                        }
                      },
                      preIconPath: "assets/icons/refresh_icon.png"),
                  SizedBox(
                    height: 2 * SizeConfig.heightMultiplier,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
