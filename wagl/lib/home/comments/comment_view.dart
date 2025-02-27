import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import 'package:wagl/home/home_controller.dart';
import 'package:wagl/profile/profile_controller.dart';
import 'package:wagl/util/ApiClient.dart';

import '../../custom_widget/Strings.dart';
import '../../custom_widget/colorsC.dart';
import '../../custom_widget/cust_text_field.dart';
import '../../custom_widget/custom_loading_popup.dart';
import '../../custom_widget/hexa_outline_widget.dart';
import '../../discover/discover_controller.dart';
import '../../discover/profile_search_view.dart';
import '../../util/SizeConfig.dart';
import '../home_page.dart';

class CommentSectionView extends StatelessWidget {
  // final BuildContext parentContext;
  //  final int index;
  final int waglId;
  final bool isHomeScreen;

  CommentSectionView({
    //  required this.parentContext,
    //   required this.index,
    required this.isHomeScreen,
    Key? key,
    required this.waglId,
  }) : super(key: key);
  bool _keyboardVisible = false;
  var homeController = Get.put(Get.put(HomeController()));

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

          return GestureDetector(
            onTap: () {
              homeController.getCommentWagls(waglId);
              print("Opening the viewInsets bottom ${MediaQuery.of(context).viewInsets.bottom} ");
              print("Opening the heightMultiplier sheet ${32*SizeConfig.heightMultiplier} ");
              homeController.commentTextController.clear();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  homeController.updateKeybroadSize(
                      MediaQuery.of(context).viewInsets.bottom);
                  double offset = 9.0*SizeConfig.heightMultiplier; // An offset value you use in your calculation
                  double adjustedPadding = max(0, homeController.keyBroadSize - offset);

                  return DraggableScrollableSheet(
                    expand: false,
                    initialChildSize:
                        homeController.keyBroadSize != 0 ? 0.89 : 0.75,
                    minChildSize: 0.3,
                    shouldCloseOnMinExtent: true,
                    maxChildSize: 0.9,
                    builder: (context, scrollController) {
                      return GetBuilder<HomeController>(
                        init: HomeController(),
                        builder: (controller) => Container(
                          color: colorBackground,
                          padding: EdgeInsets.only(

                            bottom: adjustedPadding,
                          ),
                          child: Stack(
                            children: [
                              Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 3 * SizeConfig.heightMultiplier),
                                    child: Container(
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
                                  ),
                                  Image.asset(
                                    "assets/background/dailog_bg.png",
                                    width: 100 * SizeConfig.widthMultiplier,
                                    height: 10 * SizeConfig.heightMultiplier,
                                    fit: BoxFit.fill,
                                  ),
                                  /*  Padding(
                                        padding: EdgeInsets.only(
                                            top:
                                                10 * SizeConfig.heightMultiplier),
                                        child: SizedBox(
                                          height: 5 * SizeConfig.heightMultiplier,
                                          width: 100 * SizeConfig.widthMultiplier,
                                          child: Divider(
                                            color: borderColor,
                                            indent:
                                                3 * SizeConfig.widthMultiplier,
                                            endIndent:
                                                3 * SizeConfig.widthMultiplier,
                                            thickness: 1,
                                          ),
                                        ),
                                      ),*/
                                ],
                              ),
                              // Container(
                              //   decoration: const BoxDecoration(
                              //     shape: BoxShape.rectangle,
                              //     color: colorBlack2Light,
                              //     borderRadius: BorderRadius.all(
                              //       Radius.circular(50),
                              //     ),
                              //   ),
                              //   height: 0.7 * SizeConfig.heightMultiplier,
                              //   width: 12.5 * SizeConfig.widthMultiplier,
                              // ),
                              homeController.commentData.isNotEmpty
                                  ? Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0 *
                                        SizeConfig.heightMultiplier,
                                    bottom:  7*SizeConfig.heightMultiplier),
                                      child: ListView.builder(
                                        controller: scrollController,
                                        itemCount:
                                            homeController.commentData.length,
                                        itemBuilder: (context, index) {
                                          print(
                                              "Here is the _keyboardVisible :: ${_keyboardVisible}          ${homeController.commentData.length}");

                                          return homeController
                                                  .commentData.isEmpty
                                              ? Container()
                                              : GestureDetector(
                                                  onTap: () async {
                                                    var commentUserId =
                                                        homeController
                                                            .commentData[index]
                                                            .attributes!
                                                            .userId!
                                                            .data!
                                                            .id;
                                                    if (ApiClient.box
                                                            .read("userId") !=
                                                        commentUserId) {
                                                      print(
                                                          "here commentUserId $commentUserId");
                                                      print("here $index");
                                                      print(
                                                          "here $commentUserId");
                                                      print("here $index");
                                                      ////////////////////////////////////////////
                                                      var profileController =
                                                          Get.put(
                                                              ProfileController());

                                                      /*   var result =await  profileController
                                                        .getUsersWagl(
                                                        commentUserId);*/
                                                      profileController
                                                          .getFollowersList();
                                                      print(
                                                          "here $commentUserId");
                                                      print(
                                                          "here ProfileSearchView $index");

                                                      var discoverController =
                                                          Get.put(
                                                              DiscoverController());
                                                      discoverController
                                                          .updateLoaders();
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                ProfileSearchView(
                                                                    id: commentUserId!)),
                                                      );
                                                      await discoverController
                                                          .getProfileDetails(
                                                              commentUserId);
                                                      await discoverController
                                                          .getUsersWagl(
                                                              commentUserId);
                                                      Get.back();
                                                    } else {
                                                      print("here is the click on self ");
                                                      homeController.onBottomOptionTapped(4);
                                                      homeController.update();
                                                    }
                                                    print("here is the click on self ");
                                                    // Get.to(() => ProfileSearchView(id:commentUserId!));

                                                    ///////////////////////////////////////////
                                                    /*      var commentData =
                                                        homeController
                                                            .commentData[index]
                                                            .attributes!;
                                                    if (homeController
                                                            .commentData[index]
                                                            .attributes!
                                                            .userId!
                                                            .data!
                                                            .id ==
                                                        ApiClient.box
                                                            .read("userId")) {
                                                      Get.back();
                                                      profileController
                                                          .updateProfilePage(
                                                              false);

                                                      homeController
                                                          .changeTabIndex(4);
                                                    } else {
                                                      print(
                                                          "here ===>${commentData.userId!.data!.id!}");
                                                      var profileController =
                                                          Get.put(
                                                              ProfileController());

                                                      profileController
                                                          .getFollowersList();
                                                      var result =
                                                          await profileController
                                                              .getUsersWagl(
                                                              commentData
                                                                      .userId!.data!.id!);
                                                      profileController
                                                          .getFollowersList();

                                                      print("here $index");
                                                      profileController
                                                          .getUsersWagl(
                                                          commentData
                                                                  .userId!.data!.id!);
                                                      var discoverController =
                                                          Get.put(
                                                              DiscoverController());
                                                      discoverController
                                                          .clearData();
                                                      Get.to(() =>
                                                          ProfileSearchView(
                                                              id: commentData.userId!.data!.id!));
                                                      discoverController
                                                          .getProfileDetails(
                                                          commentData
                                                                  .userId);
                                                      await discoverController
                                                          .getUsersWagl(
                                                          commentData
                                                                  .userId);
                                                    }*/
                                                  },
                                                  child: Container(
                                                    width: 100 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    color: Colors.transparent,
                                                    child: ListTile(
                                                      title: Row(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width: 10 *
                                                                    SizeConfig
                                                                        .widthMultiplier,
                                                                height: 5 *
                                                                    SizeConfig
                                                                        .heightMultiplier,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image:
                                                                      DecorationImage(
                                                                    image: homeController.commentData[index].attributes!.userId!.data !=
                                                                            null
                                                                        ? homeController.commentData[index].attributes!.userId!.data!.attributes!.profilePicData!.data ==
                                                                                null
                                                                            ? AssetImage(
                                                                                "assets/images/no_profile.png")
                                                                            : NetworkImage("${homeController.commentData[index].attributes!.userId!.data!.attributes!.profilePicData!.data!.attributes!.url}")
                                                                                as ImageProvider
                                                                        : AssetImage(
                                                                            "assets/images/no_profile.png"),
                                                                    // Use NetworkImage for network images
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 2 *
                                                                      SizeConfig
                                                                          .widthMultiplier),
                                                              Container(
                                                                color: Colors.transparent,
                                                                width: 78*SizeConfig.widthMultiplier,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        CustText(
                                                                            name: homeController
                                                                                .commentData[
                                                                            index]
                                                                                .attributes!
                                                                                .userId!
                                                                                .data!
                                                                                .attributes!
                                                                                .username!,
                                                                            size: 1.5,
                                                                            colors:
                                                                            colorWhite,
                                                                            fontWeightName:
                                                                            FontWeight
                                                                                .w500),
                                                                        Padding(
                                                                          padding:  EdgeInsets.symmetric(horizontal: 1.0*SizeConfig.widthMultiplier),
                                                                          child: SvgPicture.asset(
                                                                            "assets/icons/dot_icon.svg",
                                                                            height: 0.8 *
                                                                                SizeConfig
                                                                                    .heightMultiplier,
                                                                            width: 0.5 *
                                                                                SizeConfig
                                                                                    .widthMultiplier,
                                                                            fit: BoxFit
                                                                                .contain,
                                                                            color:
                                                                            colorWhite,
                                                                          ),
                                                                        ),

                                                                        CustText(
                                                                            name: homeController.timeAgo(homeController
                                                                                .commentData[
                                                                            index]
                                                                                .attributes!.publishedAt!),
                                                                            size: 1.5,
                                                                            colors:
                                                                            colorGreyLight2,
                                                                            fontWeightName:
                                                                            FontWeight
                                                                                .w500),
                                                                      ],
                                                                    ),
                                                                    CustText(
                                                                        name: homeController
                                                                            .commentData[
                                                                                index]
                                                                            .attributes!
                                                                            .commentText,
                                                                        size: 1.8,
                                                                        colors:
                                                                            colorWhite,
                                                                        fontWeightName:
                                                                            FontWeight
                                                                                .w500),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                        },
                                      ),
                                    )
                                  : Container(
                                      height: 0,
                                    ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  // color: Colors.red,
                                  height: 8 * SizeConfig.heightMultiplier,
                                  color: colorBackground,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 8 * SizeConfig.widthMultiplier,
                                          height:
                                              6 * SizeConfig.heightMultiplier,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: profileController
                                                          .profileImgUrl ==
                                                      ""
                                                  ? AssetImage(
                                                          "assets/images/no_profile.png")
                                                      as ImageProvider
                                                  : NetworkImage(
                                                      profileController
                                                          .profileImgUrl),

                                              // Use NetworkImage for network images
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2 * SizeConfig.widthMultiplier,
                                        ),
                                        TextFieldWidget(
                                          labelText: "",
                                          hintText:
                                              "What would you like to say?",
                                          textEditingController: homeController
                                              .commentTextController,
                                          widthSize: 86,
                                          isObscureText: false,
                                          onChange: (value) {
                                            homeController.dragCommentBox();
                                            print(
                                                "print() ${homeController.commentTextController.text}");
                                          },
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              print("here comment send");
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              homeController
                                                          .commentTextController
                                                          .text
                                                          .toString() ==
                                                      ""
                                                  ? ()
                                                  : homeController.postComment(
                                                      homeController
                                                          .commentTextController
                                                          .text
                                                          .toString(),
                                                      waglId);
                                            },
                                            child: Container(
                                              height: 3 *
                                                  SizeConfig.heightMultiplier,
                                              width: 5 *
                                                  SizeConfig.widthMultiplier,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(1.5 *
                                                        SizeConfig
                                                            .widthMultiplier),
                                                color: homeController
                                                            .commentTextController
                                                            .text
                                                            .toString() ==
                                                        ""
                                                    ? borderColor
                                                    : colorPrimary,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(0.7 *
                                                    SizeConfig
                                                        .heightMultiplier),
                                                child: SvgPicture.asset(
                                                  "assets/icons/sent_icon_svg.svg",
                                                  color: homeController
                                                              .commentTextController
                                                              .text
                                                              .toString() ==
                                                          ""
                                                      ? colorWhite
                                                      : colorBlack,
                                                ),
                                              ),
                                            ),
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
                      );
                    },
                  );
                },
              );
            },
            child: HezaOutline(
              iconPath: "assets/icons/comment_icon.png",
            ),
          );
        });
  }
}
