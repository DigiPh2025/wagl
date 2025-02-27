import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/register/categories_view.dart';
import '../custom_widget/cust_text.dart';
import '../util/SizeConfig.dart';
import 'additional_details_controller.dart';
import 'friends_follow_view.dart';

class InviteFriendsView extends StatelessWidget {
  var additionalDetailsController = Get.put(AdditionalDetailsController());

  InviteFriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: colorBlack,
            body: GetBuilder<AdditionalDetailsController>(
              init: AdditionalDetailsController(),
              builder: (controller) => Container(
                height: 95*SizeConfig.heightMultiplier,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 1.8 * SizeConfig.widthMultiplier),
                        child: Column(
                          children: [
                            Center(
                              child: additionalDetailsController.isLoading
                                  ? CircularProgressIndicator(
                                color: colorPrimary,
                                strokeWidth:
                                0.5 * SizeConfig.widthMultiplier,
                              )
                                  : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height:
                                      1 * SizeConfig.heightMultiplier),
                                  SizedBox(
                                    height:
                                    4 * SizeConfig.heightMultiplier,
                                    child:  CustText(
                                        name: "Invite your friends",
                                        size: 3.5,
                                        colors: colorWhite,
                                        textAlign: TextAlign.start,
                                        fontWeightName: FontWeight.w900),),

                                  SizedBox(
                                      height:
                                      1 * SizeConfig.heightMultiplier),
                                  SizedBox(
                                    height:
                                    5 * SizeConfig.heightMultiplier,
                                    width: 100*SizeConfig.widthMultiplier,
                                    child: CustText(
                                        name:
                                        "Sed posuere consectetur est at lobortis. Etiam porta sem malesuada magna mollis euismod.",
                                        size: 1.6,
                                        colors: colorGrey,
                                        textAlign: TextAlign.justify,
                                        fontWeightName: FontWeight.w500) ,),

                                ],
                              ),
                            ),
                            SizedBox(height: 1 * SizeConfig.heightMultiplier),
                            Container(
                              height: 64 * SizeConfig.heightMultiplier,
                              width: 100 * SizeConfig.widthMultiplier,
                              child: additionalDetailsController
                                  .phoneName.isEmpty?Center(child: CustText(name: "Please give permissions from setting to access the contacts",colors: c_white,size: 1.4,fontWeightName: FontWeight.w600),):ListView.builder(
                                  itemCount: additionalDetailsController
                                      .phoneName.length,
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          print("Tapped");
                                          additionalDetailsController
                                              .toggleSelection(
                                              index,
                                              !additionalDetailsController
                                                  .selectedItemList[index]);
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 100 * SizeConfig.widthMultiplier,
                                              // color: Colors.red,
                                              color: Colors.transparent,
                                              child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets.only(
                                                                bottom: 8.0),
                                                            child: Image.asset(
                                                                width: 10 *
                                                                    SizeConfig
                                                                        .widthMultiplier,
                                                                height: 5 *
                                                                    SizeConfig
                                                                        .heightMultiplier,
                                                                fit: BoxFit.fill,
                                                                "assets/images/no_profile.png"),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 3 *
                                                              SizeConfig
                                                                  .widthMultiplier,
                                                        ),
                                                        Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            CustText(
                                                                name:
                                                                "@${additionalDetailsController.phoneName[index]}",
                                                                size: 1.6,
                                                                colors: colorWhite,
                                                                fontWeightName:
                                                                FontWeight.w800),
                                                            CustText(
                                                                name: additionalDetailsController
                                                                    .phoneName[
                                                                index],
                                                                size: 1.4,
                                                                colors: colorGrey,
                                                                fontWeightName:
                                                                FontWeight.w500),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    GestureDetector(
                                                      onTap: (){
                                                        Share.share('Invite ${additionalDetailsController.phoneName[index]} to the wagl community');
                                                      },
                                                      child: Container(
                                                        decoration:
                                                        BoxDecoration(
                                                          color: /*additionalDetailsController
                                                      .selectedFollows[
                                                  index]
                                                      ? colorBlack
                                                      :*/ colorBlack_2,
                                                          border: Border.all(
                                                              color: /*additionalDetailsController
                                                          .selectedFollows[
                                                      index]
                                                          ? colorBlack_2
                                                          : */colorBlack_2,
                                                              width: 0.25 *
                                                                  SizeConfig
                                                                      .widthMultiplier),
                                                          borderRadius:
                                                          BorderRadius
                                                              .all(Radius
                                                              .circular(
                                                            2 *
                                                                SizeConfig
                                                                    .imageSizeMultiplier,
                                                          )),
                                                          shape: BoxShape
                                                              .rectangle,
                                                        ),
                                                        height: 4 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                        child: Center(
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal: 3.0 *
                                                                    SizeConfig
                                                                        .widthMultiplier),
                                                            child: CustText(
                                                                name: /*additionalDetailsController
                                                            .selectedFollows[
                                                        index]
                                                            ? "Unfollow"
                                                            : */"Invite",
                                                                size: 1.6,
                                                                colors:/* additionalDetailsController
                                                            .selectedFollows[
                                                        index]
                                                            ? colorWhite
                                                            : */colorPrimary,
                                                                fontWeightName:
                                                                FontWeight
                                                                    .w800),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    /* Checkbox(
                                              shape:
                                                  ContinuousRectangleBorder(),
                                              value:
                                                  additionalDetailsController
                                                          .selectedItemList[
                                                      index],
                                              activeColor: colorPrimary,
                                              checkColor: colorBlack,
                                              onChanged: (value) {
                                                additionalDetailsController
                                                    .toggleSelection(
                                                        index, value!);
                                                print("object There");
                                                additionalDetailsController.checktrueValue();
                                              },
                                            )*/
                                                  ]),
                                            ),
                                            SizedBox(height:5,child: Divider(color: borderColor,height: 1,thickness: 2,endIndent: 0,indent: 0)),
                                          ],
                                        ),
                                      ),
                                    );

                                  }),
                            ),
                            GestureDetector(
                              onTap: (){
                                additionalDetailsController.isFriendsSelected?Get.to(()=>FollowFriendView()):();
                              },
                              child: Container(
                                width: double.maxFinite,
                                height: 6 * SizeConfig.heightMultiplier,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: additionalDetailsController.isFriendsSelected?colorPrimary:colorBlack2Light,
                                      width: 0.20 * SizeConfig.widthMultiplier),
                                  color: colorBlack,
                                  borderRadius: BorderRadius.all(Radius.circular(
                                    1.5 * SizeConfig.imageSizeMultiplier,
                                  )),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Center(
                                    child: CustText(
                                      name: "Send invite",
                                      size: 1.6,
                                      colors: additionalDetailsController.isFriendsSelected?colorWhite:colorBlack2Light,
                                      fontWeightName: FontWeight.w600,
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 2 * SizeConfig.heightMultiplier,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.off(CategoriesView());
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
                                  onTap: (){
                                    Get.to(()=>FollowFriendView());
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
                    ),

                  ],
                ),
              ),
            )));
  }
}
