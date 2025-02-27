import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wagl/custom_widget/cust_appbar.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import 'package:wagl/home/home_page.dart';

import '../custom_widget/blur_back_button.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_text_field.dart';
import '../discover/discover_controller.dart';
import '../discover/profile_search_view.dart';
import '../profile/profile_controller.dart';
import '../util/SizeConfig.dart';
import 'follower_controller.dart';

class FollowerView extends StatelessWidget {
  String userName;
  int userId;
  int totalFollower;
  int totalFollowing;
  final FollowerController followerController = Get.put(FollowerController());

  FollowerView({super.key, required this.userName,required this.userId,required this.totalFollower,required this.totalFollowing});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Followers and Following
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: GetBuilder<FollowerController>(
              init: FollowerController(),
              builder: (controller) {
                return Column(
                  children: [
                Container(
                height: 7 * SizeConfig.heightMultiplier,
                  decoration:  const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      // stops: [0.9,0.8],
                      end: Alignment.topCenter,
                      colors: [colorBlack_2, colorBlack],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: CustBackButton()),
                        CustTextBold(
                            name: "@$userName",
                            size: 1.6,
                            colors: colorWhite,
                            textAlign: TextAlign.center,
                            fontWeightName: FontWeight.w700),
                        /*SizedBox(
              width: 7 * SizeConfig.widthMultiplier,
            ),*/
                        Container(
                          width: 5 * SizeConfig.widthMultiplier,
                        ),
                      ],
                    ),
                  ),
                ),
                    TabBar(
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                      tabs: [
                        Padding(
                          padding:  EdgeInsets.symmetric(vertical: 2.0*SizeConfig.heightMultiplier),
                          child: CustText(
                              name: "$totalFollower followers",
                              size: 1.5,
                              colors: colorWhite,

                              fontWeightName: FontWeight.w500),
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(vertical: 2.0*SizeConfig.heightMultiplier),
                          child: CustText(
                              name: "$totalFollowing following",
                              size: 1.5,
                              colors: colorWhite,
                              fontWeightName: FontWeight.w500),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Followers List

                          RefreshIndicator(
                            color: colorPrimary,
                            backgroundColor: colorBlack_2,
                            onRefresh: () async {
                              return await followerController
                                  .getFollowerUserList(userId);
                            },
                            child: Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 2.0*SizeConfig.widthMultiplier),
                              child: Column(
                                children: [
                                  SizedBox(height: 2*SizeConfig.heightMultiplier,),
                                  TextFieldWidget(
                                    labelText: "",
                                    hintText: "Search follower",
                                    textEditingController: followerController
                                        .searchFollowerController,
                                    widthSize: 99,
                                    isObscureText: false,
                                    onChange: (value) {
                                      // controller.searchQuery = value;
                                      // controller.fetchSearchResults(value);
                                      followerController.searchFollower(value);
                                    },
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.all(
                                          1.5 * SizeConfig.widthMultiplier),
                                      child: Image.asset(
                                          "assets/icons/search_icon.png",
                                          fit: BoxFit.contain,
                                          color: colorWhite),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: followerController
                                          .followerUserList!.length,
                                      itemBuilder: (context, index) {
                                        bool isFollows=followerController
                                            .followerUserList[index].attributes?.followersId?.data?.attributes?.isFollow??true;

                                        final user = followerController
                                            .followerUserList![index]
                                            .attributes!
                                            .followersId!
                                            .data!
                                            .attributes!
                                            .username;
                                        final name =
                                            "${followerController.followerUserList![index].attributes!.followersId!.data!.attributes!.firstName} ${followerController.followerUserList![index].attributes!.followersId!.data!.attributes!.lastName}";
                                        return GestureDetector(
                                          onTap: () async {
                                            print("object here is the index $index ${followerController
                                                .followerUserList![index]
                                                .attributes!
                                                .followersId!
                                                .data!.id}");
                                            var profileController = Get.put(ProfileController());
                                            var discoverController = Get.put(DiscoverController());
                                            discoverController.updateLoaders();
                                            int userId=followerController
                                                .followerUserList![index]
                                                .attributes!
                                                .followersId!
                                                .data!.id!;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (_) =>  ProfileSearchView(id: userId)),
                                            );
                                            // Get.to(() => ProfileSearchView(id: userId));
                                            profileController.getUsersWagl(userId);
                                            discoverController.getProfileDetails(userId);
                                            await discoverController.getUsersWagl(userId);

                                          },
                                          child: Column(
                                            children: [
                                              ListTile(
                                                leading: Container(
                                                  width:
                                                      10 * SizeConfig.widthMultiplier,
                                                  height:
                                                      10 * SizeConfig.heightMultiplier,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: followerController
                                                                  .followerUserList[
                                                                      index]
                                                                  .attributes!
                                                                  .followersId!
                                                                  .data!
                                                                  .attributes!
                                                                  .profilePic!
                                                                  .data !=
                                                              null
                                                          ? NetworkImage(
                                                              followerController
                                                                  .followerUserList[
                                                                      index]
                                                                  .attributes!
                                                                  .followersId!
                                                                  .data!
                                                                  .attributes!
                                                                  .profilePic!
                                                                  .data!
                                                                  .attributes!
                                                                  .url!)
                                                          : const AssetImage(
                                                                  "assets/images/no_profile.png")
                                                              as ImageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                title: CustText(
                                                    name: user,
                                                    size: 1.5,
                                                    colors: colorWhite,
                                                    fontWeightName: FontWeight.w500),
                                                subtitle: CustText(
                                                    name: name,
                                                    size: 1.3,
                                                    colors: colorWhite,
                                                    fontWeightName: FontWeight.w500),
                                                trailing: Container(height: 1,width: 1,)/*GestureDetector(
                                                  onTap: (){
                                                    followerController.updateFollowing(followerController
                                                        .followerUserList![index]
                                                        .attributes!
                                                        .followersId!
                                                        .data!.id!,!isFollows,true,index);
                                                    profileController.getUsersWagl(userId);
                                                  },
                                                  child: Container(
                                                    width:
                                                        25 * SizeConfig.widthMultiplier,
                                                    height:
                                                        5 * SizeConfig.heightMultiplier,
                                                    decoration: BoxDecoration(
                                                      color: followerController
                                                              .followerUserList.isNotEmpty
                                                          ? colorBlack
                                                          : colorBlack_2,
                                                      border: Border.all(
                                                          color: followerController
                                                                  .followerUserList
                                                                  .isNotEmpty
                                                              ? colorBlack_2
                                                              : colorBlack_2,
                                                          width: 0.25 *
                                                              SizeConfig.widthMultiplier),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(
                                                        2 *
                                                            SizeConfig
                                                                .imageSizeMultiplier,
                                                      )),
                                                      shape: BoxShape.rectangle,
                                                    ),
                                                    child: Center(
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal: 2.0 *
                                                                SizeConfig
                                                                    .widthMultiplier),
                                                        child: CustText(
                                                            name: followerController
                                                                    .followerUserList
                                                                    .isNotEmpty
                                                                ? "Unfollow"
                                                                : "Follow",
                                                            size: 1.6,
                                                            colors: followerController
                                                                    .followerUserList
                                                                    .isNotEmpty
                                                                ? colorWhite
                                                                : colorPrimary,
                                                            fontWeightName:
                                                                FontWeight.w800),
                                                      ),
                                                    ),
                                                  ),
                                                ),*/
                                              ),
                                              SizedBox(
                                                  // height: 0.5*SizeConfig.heightMultiplier,
                                                  child: Divider(
                                                      color: borderColor,
                                                      height: 1,
                                                      thickness: 2,
                                                      endIndent: 0,
                                                      indent: 0)),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Following List
                          RefreshIndicator(
                            color: colorPrimary,
                            backgroundColor: colorBlack_2,
                            onRefresh: () async {
                              await followerController.getFollowerUserList(userId);
                              return await followerController
                                  .getFollowingList(0);
                            },
                            child: Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 2.0*SizeConfig.widthMultiplier),
                              child: Column(
                                children: [
                                  SizedBox(height: 2*SizeConfig.heightMultiplier,),
                                  TextFieldWidget(
                                    labelText: "",
                                    hintText: "Search following",
                                    textEditingController: followerController
                                        .searchFollowingController,
                                    widthSize: 99,
                                    isObscureText: false,
                                    onChange: (value) {
                                      // controller.searchQuery = value;
                                      // controller.fetchSearchResults(value);
                                      followerController.searchFollowing(value);
                                    },
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.all(
                                          1.5 * SizeConfig.widthMultiplier),
                                      child: Image.asset(
                                          "assets/icons/search_icon.png",
                                          fit: BoxFit.contain,
                                          color: colorWhite),
                                    ),
                                  ),
                                  followerController.followingUsers.isEmpty
                                      ? Container()
                                      : Expanded(
                                          child: ListView.builder(
                                            itemCount: followerController
                                                .followingUsers!.length,
                                            itemBuilder: (context, index) {
                                              String user = "";
                                              String name = "";
                                              if (followerController
                                                      .followingUsers![index]
                                                      .attributes!
                                                      .followersId !=
                                                  null) {
                                                user = followerController
                                                        .followingUsers![index]
                                                        .attributes!
                                                        .followersId!
                                                        .data!
                                                        .attributes!
                                                        .username ??
                                                    "";
                                                name =
                                                    "${followerController.followingUsers![index].attributes!.followersId!.data!.attributes!.firstName} ${followerController.followingUsers![index].attributes!.followersId!.data!.attributes!.lastName}";
                                              }
                                              bool isFollows=followerController
                                                  .followingUsers[index].attributes?.followersId?.data?.attributes?.isFollow??true;
                                              return GestureDetector(
                                               onTap: () async {
                                                 print("object here is the index $index ${followerController
                                                     .followingUsers![index]
                                                     .attributes!.followersId!
                                                     .data!.id}");
                                                 var profileController = Get.put(ProfileController());
                                                 var discoverController = Get.put(DiscoverController());
                                                 discoverController.clearData();
                                                 int followerId=followerController
                                                     .followingUsers![index]
                                                     .attributes!
                                                     .followersId!
                                                     .data!.id!;
                                                 Navigator.push(
                                                   context,
                                                   MaterialPageRoute(builder: (_) => ProfileSearchView(id: followerId)),
                                                 );

                                                 profileController.getUsersWagl(followerId);
                                                 discoverController.getProfileDetails(followerId);
                                                 await discoverController.getUsersWagl(followerId);
                                               },
                                                child: Column(
                                                  children: [
                                                    ListTile(
                                                      leading: Container(
                                                        width: 10 *
                                                            SizeConfig.widthMultiplier,
                                                        height: 10 *
                                                            SizeConfig.heightMultiplier,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          image: DecorationImage(
                                                            image: followerController
                                                                            .followingUsers[
                                                                                index]
                                                                            .attributes!
                                                                            .followersId !=
                                                                        null &&
                                                                    followerController
                                                                            .followingUsers[
                                                                                index]
                                                                            .attributes!
                                                                            .followersId!
                                                                            .data!
                                                                            .attributes!
                                                                            .profilePic!
                                                                            .data !=
                                                                        null
                                                                ? NetworkImage(
                                                                    followerController
                                                                            .followingUsers[
                                                                                index]
                                                                            .attributes
                                                                            ?.followersId
                                                                            ?.data
                                                                            ?.attributes
                                                                            ?.profilePic
                                                                            ?.data
                                                                            ?.attributes
                                                                            ?.url ??
                                                                        "")
                                                                : const AssetImage(
                                                                        "assets/images/no_profile.png")
                                                                    as ImageProvider,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      title: CustText(
                                                          name: user,
                                                          size: 1.5,
                                                          colors: colorWhite,
                                                          fontWeightName:
                                                              FontWeight.w500),
                                                      subtitle: CustText(
                                                          name: name,
                                                          size: 1.3,
                                                          colors: colorWhite,
                                                          fontWeightName:
                                                              FontWeight.w500),
                                                      trailing: GestureDetector(
                                                        onTap: (){
                                                          print("here is the follow");
                                                          followerController.updateFollowing(followerController
                                                              .followingUsers![index]
                                                              .attributes!
                                                              .followersId!
                                                              .data!.id!,!isFollows,false,index);
                                                        },
                                                        child: Container(
                                                          width: 25 *
                                                              SizeConfig.widthMultiplier,
                                                          height: 5 *
                                                              SizeConfig.heightMultiplier,
                                                          decoration: BoxDecoration(
                                                            color: isFollows
                                                                ? colorBlack
                                                                : colorBlack_2,
                                                            border: Border.all(
                                                                color: isFollows
                                                                    ? colorBlack_2
                                                                    : colorBlack_2,
                                                                width: 0.25 *
                                                                    SizeConfig
                                                                        .widthMultiplier),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                              2 *
                                                                  SizeConfig
                                                                      .imageSizeMultiplier,
                                                            )),
                                                            shape: BoxShape.rectangle,
                                                          ),
                                                          child: Center(
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal: 2.0 *
                                                                      SizeConfig
                                                                          .widthMultiplier),
                                                              child: CustText(
                                                                  name: isFollows
                                                                      ? "Unfollow"
                                                                      : "Follow",
                                                                  size: 1.6,
                                                                  colors: isFollows
                                                                      ? colorWhite
                                                                      : colorPrimary,
                                                                  fontWeightName:
                                                                      FontWeight.w800),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      // height: 0.5*SizeConfig.heightMultiplier,
                                                        child: Divider(
                                                            color: borderColor,
                                                            height: 1,
                                                            thickness: 2,
                                                            endIndent: 0,
                                                            indent: 0)),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
