import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/custom_widget/custom_loading_popup.dart';
import 'package:wagl/register/additional_details_view.dart';
import '../custom_widget/cust_text.dart';
import '../util/SizeConfig.dart';
import 'additional_details_controller.dart';
import 'invite_friends_view.dart';

class UpdateCategoriesView extends StatelessWidget {
  var additionalDetailsController = Get.put(AdditionalDetailsController());

  UpdateCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
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
                  additionalDetailsController.categoriesList.isEmpty?CustomLoadingPopup():SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.8 * SizeConfig.widthMultiplier),
                      child: Column(
                        children: [
                          Center(
                            child: additionalDetailsController.isLoading
                                ? const CircularProgressIndicator()
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          height:
                                              5 * SizeConfig.heightMultiplier),
                                      CustText(
                                          name:
                                              "Update categories that you are interested in?",
                                          size: 3.5,
                                          colors: colorWhite,
                                          textAlign: TextAlign.start,
                                          fontWeightName: FontWeight.w900),
                                      SizedBox(
                                          height:
                                              2 * SizeConfig.heightMultiplier),
                                      CustText(
                                          name:
                                              "Tell us more about what you are interested in. Sed posuere consectetur est at lobortis. Etiam porta sem malesuada magna mollis euismod.",
                                          size: 1.6,
                                          colors: colorGrey,
                                          textAlign: TextAlign.left,
                                          fontWeightName: FontWeight.w500),
                                      SizedBox(
                                          height:
                                              2 * SizeConfig.heightMultiplier),
                                      Wrap(
                                        spacing: 1 * SizeConfig.widthMultiplier,
                                        runSpacing: 4.0,
                                        children: List.generate(
                                            additionalDetailsController
                                                .categories.data.length, (index) {
                                          String name =
                                              additionalDetailsController
                                                  .categories.data[index].attributes.categoryName;
                                          return GestureDetector(
                                            onTap: () {
                                                additionalDetailsController
                                                    .onNameTap(index);

                                            },
                                            child: Chip(
                                              label: Text(
                                                name,
                                                style: TextStyle(
                                                  fontFamily: "Gilroy",
                                                  color: additionalDetailsController
                                                          .selectedCategoriesIndex
                                                          .contains(index)
                                                      ? colorBlack
                                                      : colorWhite,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 1.6 *
                                                      SizeConfig.textMultiplier,
                                                ),
                                              ),
                                              backgroundColor:
                                                  additionalDetailsController
                                                          .selectedCategoriesIndex
                                                          .contains(index)
                                                      ? colorWhite
                                                      : backgroundLightColor,
                                              avatar: Container(
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: borderColor,
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(1 *
                                                      SizeConfig
                                                          .widthMultiplier),
                                                  child: SvgPicture.network(
                                                      additionalDetailsController.categories.data[index].attributes.categoryImage!.data.attributes.url,
                                                      color: additionalDetailsController
                                                              .selectedCategoriesIndex
                                                              .contains(index)
                                                          ? colorPrimary
                                                          : colorWhite),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                          ),
                          SizedBox(height: 3 * SizeConfig.heightMultiplier),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.back();
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
                                 await additionalDetailsController.sendCategories();
                                 await additionalDetailsController.updateUserInfo();
                                  Get.back();
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
                                          name: "Update",
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
