import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wagl/create_wagl/categories_tag_view.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/custom_widget/custom_loading_popup.dart';
import 'package:wagl/register/invite_friends_view.dart';
import '../custom_widget/color_loader.dart';
import '../custom_widget/cust_text.dart';
import '../home/home_controller.dart';
import '../home/home_page.dart';
import '../profile/profile_controller.dart';
import '../util/SizeConfig.dart';
import 'additional_details_controller.dart';
import 'categories_view.dart';
import 'follow_list_model.dart';

class FollowFriendView extends StatelessWidget {
  var additionalDetailsController = Get.put(AdditionalDetailsController());

  FollowFriendView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: colorBlack,
            body: GetBuilder<AdditionalDetailsController>(
              init: AdditionalDetailsController(),
              builder: (controller) => Container(
                height: 100 *SizeConfig.heightMultiplier,
                // color: Colors.red,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: 100 * SizeConfig.widthMultiplier,
                        height: 25 * SizeConfig.heightMultiplier,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black, Colors.transparent],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.8 * SizeConfig.widthMultiplier),
                      child: Column(
                        children: [
                          Center(
                            child: additionalDetailsController.isLoading
                                ? CustomLoadingPopup()
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          height:
                                              1 * SizeConfig.heightMultiplier),
                                      Container(

                                        height: 9 * SizeConfig.heightMultiplier,
                                        width: 100*SizeConfig.widthMultiplier,
                                        child: CustText(
                                            name:
                                            "Connect with people you already know",
                                            size: 3.3,
                                            colors: colorWhite,
                                            textAlign: TextAlign.start,
                                            fontWeightName: FontWeight.w900),
                                      ),
                                      SizedBox(
                                          height:
                                              1 * SizeConfig.heightMultiplier),
                                      SizedBox(
                                        // height: 5 * SizeConfig.heightMultiplier,
                                        width: 100 * SizeConfig.widthMultiplier,
                                        child: CustText(
                                            name:
                                            "Sed posuere consectetur est at lobortis. Etiam porta sem malesuada magna mollis euismod.",
                                            size: 1.6,
                                            colors: colorGrey,
                                            textAlign: TextAlign.justify,
                                            fontWeightName: FontWeight.w500),
                                      ),

                                    ],
                                  ),
                          ),
                          SizedBox(height: 1 * SizeConfig.heightMultiplier),
                          Container(
                            height: 72 * SizeConfig.heightMultiplier,
                            width: 100 * SizeConfig.widthMultiplier,
                            child: FutureBuilder<List<User>>(
                              future: additionalDetailsController.futureUsers,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (snapshot.hasData) {
                                  final users = snapshot.data!;
                                  return SingleChildScrollView(
                                    child: ListView.builder(
                                      itemCount: users.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
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
                                                              .selectedItemList[
                                                          index]);
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 100 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  color: Colors.transparent,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          8.0),
                                                              child: users[index]
                                                                          .profilePic !=
                                                                      null
                                                                  ? Container(
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
                                                                          image: NetworkImage(users[index]
                                                                              .profilePic!
                                                                              .url) as ImageProvider,
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        ),
                                                                      ), /*Image.network(
                                                                users[index].profilePic!.url,
                                                                width: 8 * SizeConfig.widthMultiplier,
                                                                height: 4 * SizeConfig.heightMultiplier,
                                                                fit: BoxFit.fill,
                                                              ):*/
                                                                    )
                                                                  : Image.asset(
                                                                      width: 10 *
                                                                          SizeConfig
                                                                              .widthMultiplier,
                                                                      height: 5 *
                                                                          SizeConfig
                                                                              .heightMultiplier,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      "assets/images/no_profile.png",
                                                                    ),
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
                                                                    "@${users[index].username}",
                                                                size: 1.6,
                                                                colors:
                                                                    colorWhite,
                                                                fontWeightName:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                              CustText(
                                                                name:
                                                                    "${users[index].firstName} ${users[index].lastName}",
                                                                size: 1.4,
                                                                colors:
                                                                    colorGrey,
                                                                fontWeightName:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          additionalDetailsController
                                                              .updateFollows(
                                                                  index,
                                                                  !additionalDetailsController
                                                                          .selectedFollows[
                                                                      index],
                                                                  users[index]
                                                                      .id);
                                                        },
                                                        child: Container(
                                                      decoration:
                                                      BoxDecoration(
                                                      color: additionalDetailsController
                                                          .selectedFollows[
                                                        index]
                                                        ? colorBlack
                                                        : colorBlack_2,
                                                        border: Border.all(
                                                            color: additionalDetailsController
                                                                .selectedFollows[
                                                            index]
                                                                ? colorBlack_2
                                                                : colorBlack_2,
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
                                                    name: additionalDetailsController
                                                        .selectedFollows[
                                                    index]
                                                        ? "Unfollow"
                                                        : "Follow",
                                                    size: 1.6,
                                                    colors: additionalDetailsController
                                                        .selectedFollows[
                                                    index]
                                                        ? colorWhite
                                                        : colorPrimary,
                                                    fontWeightName:
                                                    FontWeight
                                                        .w800),
                                              ),
                                            ),
                                          ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: 5,
                                                    child: Divider(
                                                        color: borderColor,
                                                        height: 1,
                                                        thickness: 2,
                                                        endIndent: 0,
                                                        indent: 0)),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return Center(child: Text('No users found'));
                                }
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if(additionalDetailsController.permissionDenied){
                                    Get.to(() => CategoriesView());
                                  }
                                  else{
                                    Get.to(() => InviteFriendsView());
                                  }

                                },
                                child: Container(
                                  width: 46 * SizeConfig.widthMultiplier,
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
                                  var profileController =
                                  Get.put(ProfileController());
                                  await profileController.getProfileDetails(0);
                                  // homeController.onItemTapped(0);

                                  Get.offAll(() => MyHomePage());
                                  final HomeController homeController = Get.put(HomeController());
                                  // homeController.onItemTapped(0);
                                },
                                child: Container(
                                  width: 46 * SizeConfig.widthMultiplier,
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
                    )
                  ],
                ),
              ),
            )));
  }
}
