import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wagl/constPath.dart';
import 'package:wagl/custom_widget/create_post_wagl.dart';
import 'package:wagl/profile/post_view.dart';
import 'package:wagl/profile/profile_controller.dart';
import 'package:wagl/profile/saved_wagl.dart';
import 'package:wagl/util/ApiClient.dart';
import 'package:share_plus/share_plus.dart';
import '../custom_widget/Strings.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_button.dart';
import '../custom_widget/cust_button_background.dart';
import '../custom_widget/cust_dailog.dart';
import '../custom_widget/cust_text.dart';
import '../custom_widget/custom_loading_popup.dart';
import '../follower/follower_controller.dart';
import '../follower/follower_view.dart';
import '../home/home_page.dart';
import '../home/waglStoryView.dart';
import '../register/additional_details_controller.dart';
import '../register/update_categories_view.dart';
import '../settings/personal_setting_view.dart';
import '../settings/settings_view.dart';
import '../util/SizeConfig.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  double get randHeight => Random().nextInt(100).toDouble();

  late List<Widget> _randomChildren = _randomHeightWidgets(context);
  var profileController = Get.put(ProfileController());

  // Children with random heights - This can be replaced with any widgets you like
  List<Widget> _randomHeightWidgets(BuildContext context) {
    return List.generate(5, (index) {
      final height = randHeight.clamp(
        100.0,
        MediaQuery.of(context).size.width,
      );
      return Container(
        color: Colors.primaries[index],
        height: height,
        child: Text('Random Height Child ${index + 1}'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // profileController.getProfileDetails(0);
    // profileController.getUsersWagl(0);
    // print("profile Page Update here ${profileController.isOwnProfile}");

    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          print("Scaffold Update");
          print("profile Page Update here ${profileController.isOwnProfile}");

          /* if(!profileController.isOwnProfile) {
            print("Scaffold Update");
            print("UserProfileViewUserProfileView ${profileController.isOwnProfile}");
            return UserProfileView(userDetails: homeController
                .wagls![profileController.userAttributeIndex!]
                .attributes!
                .userId!
                .data!
                .attributes, id: profileController.userAttributeId!);
          }
*/
          return Scaffold(
            backgroundColor: colorBlack,
            body: GetBuilder<ProfileController>(builder: (controller) {
              return DefaultTabController(
                length: 2,
                child: NestedScrollView(
                  headerSliverBuilder: (context, _) {
                    print("Scaffold Update");
                    print(
                        "profile Page profile Page ${profileController.isOwnProfile}");
                    return [
                      SliverToBoxAdapter(
                        child: Stack(
                          children: [
                            Container(
                              height: 12.9 * SizeConfig.heightMultiplier,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    colorBlack,
                                    colorBlack,
                                    colorBlack,
                                    backgroundLightColor
                                  ],
                                  tileMode: TileMode.repeated,
                                ),
                              ),
                            ),
                            RefreshIndicator(
                              color: colorPrimary,
                              backgroundColor: colorBlack_2,
                              onRefresh: () {
                                profileController
                                    .clearRecentCategoriesFilter(0);
                                return profileController.getProfileDetails(0);
                              },
                              child: SingleChildScrollView(
                                controller: profileController.scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          2 * SizeConfig.widthMultiplier),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // CustBackButton(),
                                          Container(
                                            width:
                                                10 * SizeConfig.widthMultiplier,
                                          ),
                                          CustText(
                                              name:
                                                  "@${profileController.personProfileDetails?.username}" ??
                                                      "",
                                              size: 1.6,
                                              colors: colorWhite,
                                              textAlign: TextAlign.center,
                                              fontWeightName: FontWeight.w700),
                                          CustBgButton(
                                              height: 4,
                                              width: 10,
                                              onSelected: () {
                                                Get.to(() => SettingsView());
                                              },
                                              iconPath:
                                                  "assets/icons/settings_icon.svg")
                                        ],
                                      ),
                                      SizedBox(
                                        height: 3 * SizeConfig.heightMultiplier,
                                        width: 100 * SizeConfig.widthMultiplier,
                                        child: Divider(
                                          color: borderColor,
                                          thickness: 1.5,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Stack(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return Stack(
                                                        children: [
                                                          // Blurred Background
                                                          BackdropFilter(
                                                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                                            child: Container(
                                                              color: Colors.black.withOpacity(0.3), // Semi-transparent overlay
                                                            ),
                                                          ),
                                                          // Dialog with Profile Picture
                                                          Center(
                                                            child: Dialog(
                                                              shape: const CircleBorder(

                                                              ),
                                                              child: Container(
                                                                width: 70*SizeConfig.widthMultiplier,
                                                                height: 40*SizeConfig.heightMultiplier,
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape.circle, // Circular shape
                                                                  image: DecorationImage(
                                                                    image: profileController.image != null
                                                                        ? FileImage(profileController.image!)
                                                                        : (profileController.profileImg != null)
                                                                        ? NetworkImage(profileController.profileImgUrl)
                                                                        : AssetImage("assets/images/no_profile.png")
                                                                    as ImageProvider,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  width: 25 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  height: 12.5 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: profileController
                                                                  .image !=
                                                              null
                                                          ? FileImage(
                                                              profileController
                                                                  .image!)
                                                          : (profileController
                                                                      .profileImg !=
                                                                  null)
                                                              ? NetworkImage(
                                                                  profileController
                                                                      .profileImgUrl)
                                                              : AssetImage(
                                                                      "assets/images/no_profile.png")
                                                                  as ImageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: -3 *
                                                    SizeConfig.heightMultiplier,
                                                right: 0,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet<void>(
                                                      context: context,
                                                      backgroundColor:
                                                          backgroundDialog,
                                                      builder: (BuildContext
                                                          context) {
                                                        return CustomBottomSheet(
                                                          height: profileController
                                                                          .profileImg !=
                                                                      null &&
                                                                  profileController
                                                                          .image !=
                                                                      null
                                                              ? 45
                                                              : 35,
                                                          title: "Edit picture",
                                                          content: Image.asset(
                                                            "assets/icons/flag_icon.png",
                                                            height: 8 *
                                                                SizeConfig
                                                                    .heightMultiplier,
                                                            width: 11 *
                                                                SizeConfig
                                                                    .widthMultiplier,
                                                          ),
                                                          backgroundColor:
                                                              Colors.grey,
                                                          textColor:
                                                              Colors.white,
                                                          child: Column(
                                                            children: [
                                                              GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  await profileController
                                                                      .get_image(
                                                                          ImageSource
                                                                              .gallery);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: customRow(
                                                                    "Choose from Library",
                                                                    "assets/icons/gallery_svg.svg"),
                                                              ),
                                                              SizedBox(
                                                                  height: 2 *
                                                                      SizeConfig
                                                                          .heightMultiplier),
                                                              GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  await profileController
                                                                      .get_image(
                                                                          ImageSource
                                                                              .camera);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: customRow(
                                                                    "Take photo",
                                                                    "assets/icons/camera_svg.svg"),
                                                              ),
                                                              SizedBox(
                                                                  height: 2 *
                                                                      SizeConfig
                                                                          .heightMultiplier),
                                                              profileController
                                                                              .profileImg !=
                                                                          null ||
                                                                      profileController
                                                                              .image !=
                                                                          null
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        if (context
                                                                            .mounted) {
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) => CustomLoadingPopup());
                                                                        }
                                                                        final result =
                                                                            await profileController.removeProfileImage();
                                                                        Navigator.pop(
                                                                            context);
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: customRow(
                                                                          "Remove current picture",
                                                                          "assets/icons/delete_icon.svg"),
                                                                    )
                                                                  : Container(),
                                                              SizedBox(
                                                                  height: 2 *
                                                                      SizeConfig
                                                                          .heightMultiplier),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 8 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    height: 10 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Colors.black,
                                                            width: 3,
                                                            style: BorderStyle
                                                                .solid)),
                                                    child: Image.asset(
                                                        fit: BoxFit.contain,
                                                        "assets/icons/edit_icon.png"),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width:
                                                3 * SizeConfig.widthMultiplier,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 62 *
                                                    SizeConfig.widthMultiplier,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    buildStatRow(
                                                        // "${profileController.personalDetails!.isEmpty?"0":profileController.personalDetails?[0].attributes?.userId?.data?.attributes?.totalWagls ?? 0}",
                                                        "${profileController.personProfileDetails?.totalWagls ?? 0}",
                                                        "wagls"),
                                                    buildStatRow(
                                                        // "${profileController.personalDetails![0].attributes!.userId!.data!.attributes!.totalFollowers}",
                                                        // "${profileController.personalDetails!.isEmpty?"0":profileController.personalDetails?[0].attributes?.userId?.data?.attributes?.totalFollowers ?? 0}",
                                                        "${profileController.personProfileDetails?.totalFollowers ?? 0}",
                                                        "followers"),
                                                    buildStatRow(
                                                        // "${profileController.personalDetails![0].attributes!.userId!.data!.attributes!.totalFollowing}",
                                                        // "${profileController.personalDetails!.isEmpty?"0":profileController.personalDetails?[0].attributes?.userId?.data?.attributes?.totalFollowing ?? 0}",
                                                        "${profileController.personProfileDetails?.totalFollowing ?? 0}",
                                                        "following"),
                                                    buildStatRow(
                                                        // "${profileController.personalDetails![0].attributes!.userId!.data!.attributes!.totalViews}",
                                                        // "${ApiClient.formatNumber(profileController.personalTotalView) /*profileController.personProfileDetails?.totalViews ?? 0*/}",
                                                        "${profileController.personProfileDetails?.totalViews ?? 0}",
                                                        "views"),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2 *
                                                    SizeConfig.heightMultiplier,
                                              ),
                                              Row(
                                                children: [
                                                  CustButton(
                                                      name: "Edit profile",
                                                      height: 4.5,
                                                      width: 30,
                                                      size: 1.4,
                                                      btnColor: colorBlack_2,
                                                      fontColor: colorWhite,
                                                      onSelected: () async {
                                                        await profileController
                                                            .getProfileDetails(
                                                                0);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  PersonalSettingsView(
                                                                      titleName:
                                                                          personalDetails)),
                                                        );
                                                        /*  Get.to(() =>
                                                            PersonalSettingsView(
                                                                titleName:
                                                                    personalDetails));*/
                                                      }),
                                                  SizedBox(
                                                    width: 2 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                  ),
                                                  CustButton(
                                                      name: "Share profile",
                                                      height: 4.5,
                                                      width: 32,
                                                      size: 1.4,
                                                      btnColor: colorBlack_2,
                                                      fontColor: colorWhite,
                                                      onSelected: () {
                                                        // Get.to(()=>ListImages());
                                                        Share.share(
                                                            'Wagl share link after publishing on platform https://wagl.io/');
                                                      })
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2 * SizeConfig.heightMultiplier,
                                      ),
                                      CustText(
                                          name:
                                              "${profileController.personProfileDetails?.firstName ?? ""} ${profileController.personProfileDetails?.lastName ?? ""}",
                                          size: 1.6,
                                          colors: colorWhite,
                                          textAlign: TextAlign.start,
                                          fontWeightName: FontWeight.w800),

                                      (profileController
                                          .personProfileDetails?.bio.length??0)>3?Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 1 * SizeConfig.heightMultiplier,
                                              ),
                                              CustText(
                                              name: profileController
                                                      .personProfileDetails?.bio ??
                                                  "",
                                              size: 1.5,
                                              colors: colorGrey,
                                              textAlign: TextAlign.start,
                                              fontWeightName: FontWeight.w600),
                                            ],
                                          ):Container(),
                                      profileController
                                          .personalCategoriesList!.isEmpty
                                          ? Container()
                                          :Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 1 * SizeConfig.heightMultiplier,
                                          ),
                                          CustText(
                                              name: "Recent categories",
                                              size: 1.6,
                                              colors: colorWhite,
                                              textAlign: TextAlign.start,
                                              fontWeightName: FontWeight.w800),
                                          SizedBox(
                                            height: 5 *
                                                SizeConfig.heightMultiplier,
                                            child: profileController
                                                .personalCategoriesList!
                                                .isNotEmpty
                                                ? ListView.builder(
                                                scrollDirection:
                                                Axis.horizontal,
                                                itemCount: profileController
                                                    .personalCategoriesList!
                                                    .length,
                                                itemBuilder:
                                                    (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      print(
                                                          "here is the tap on id::${profileController.personalCategoriesList![index].id} and categories::${profileController.personalCategoriesList![index].categoryName}");
                                                      profileController
                                                          .getFilteredWaglsFromCategories(
                                                          index);
                                                    },
                                                    child: Center(
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal: 1.0 *
                                                                SizeConfig
                                                                    .widthMultiplier),
                                                        child: Container(
                                                            decoration:
                                                            BoxDecoration(
                                                                color: profileController.selectedCategoriesIndex.contains(index)
                                                                    ? colorPrimary
                                                                    : borderColor,
                                                                borderRadius: BorderRadius
                                                                    .all(
                                                                  Radius.circular(10 *
                                                                      SizeConfig.imageSizeMultiplier),
                                                                ),
                                                                shape:
                                                                BoxShape.rectangle),
                                                            child: Padding(
                                                              padding: EdgeInsets.all(2.0 *
                                                                  SizeConfig
                                                                      .widthMultiplier),
                                                              child: CustText(
                                                                  name: profileController
                                                                      .personalCategoriesList![
                                                                  index]
                                                                      .categoryName,
                                                                  size:
                                                                  1.4,
                                                                  colors: profileController.selectedCategoriesIndex.contains(index)
                                                                      ? colorBlack
                                                                      : colorWhite,
                                                                  fontWeightName:
                                                                  FontWeight.w700),
                                                            )),
                                                      ),
                                                    ),
                                                  );
                                                })
                                                : Container(),
                                          ),
                                          SizedBox(
                                            height: 1 *
                                                SizeConfig.heightMultiplier,
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                  body: profileController.personProfileDetails?.accountType ==
                              "private" &&
                          profileController.personProfileDetails?.id !=
                              ApiClient.box.read("userId")
                      ? Container()
                      : Column(
                          children: <Widget>[
                            TabBar(
                              indicatorSize: TabBarIndicatorSize.tab,
                              onTap: (value) async {
                                print("Here is the value $value");

                                if (value == 0) {
                                  print("here is saved api call ");
                                  profileController.getUsersWagl(0);
                                }
                                if (value == 1) {
                                  print("here is Post api call ");
                                  await profileController.getSavedPost();
                                }
                              },
                              indicator: UnderlineTabIndicator(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              tabs: [
                                Tab(
                                  icon: SvgPicture.asset(
                                    waglIconPath,
                                    width: 5.5 * SizeConfig.widthMultiplier,
                                    color: colorWhite,
                                    height: 3.5 * SizeConfig.heightMultiplier,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Tab(
                                  icon: SvgPicture.asset(
                                    "assets/icons/saved_wagl_svg.svg",
                                    width: 5.5 * SizeConfig.widthMultiplier,
                                    color: colorWhite,
                                    height: 3.0 * SizeConfig.heightMultiplier,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                            profileController.personProfileDetails
                                            ?.accountType ==
                                        "private" &&
                                    profileController
                                            .personProfileDetails!.id !=
                                        ApiClient.box.read("userId")
                                ? Container()
                                : Expanded(
                                    child: TabBarView(
                                      children: [
                                        profileController
                                                .personalDetails!.isEmpty
                                            ? SingleChildScrollView(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    // height: 10*SizeConfig.heightMultiplier,
                                                    // width: 100*SizeConfig.widthMultiplier,
                                                    child: CustCreateWaglPost(
                                                        onSelected: () async {
                                                          {
                                                            {
                                                              homeController
                                                                      .currentSelectedMedia =
                                                                  null;
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      CustomLoadingPopup());
                                                              var images =
                                                                  await homeController
                                                                      .pickImages();
                                                              // ignore: use_build_context_synchronously
                                                              Navigator.pop(
                                                                  context);
                                                              homeController
                                                                          .currentSelectedMedia !=
                                                                      null
                                                                  ? Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) => /*homeController.currentSelectedMedia == null
                          images==false ? CustomLoadingPopup()
                          : */
                                                                                StoryDesignerScreen(mediaPath: homeController.currentSelectedMedia!, index: 0),
                                                                      ))
                                                                  : ();
                                                            }
                                                          }
                                                        },
                                                        isDiscard: (value) {}),
                                                  ),
                                                ),
                                              )
                                            : Stack(
                                                children: [
                                                  WaglPost(
                                                      userData:
                                                          profileController
                                                              .personalDetails,
                                                      userId: 1,
                                                      userCategoriesList:
                                                          profileController
                                                              .selectedCategoriesList),
                                                  /*  Text("here is the widget.id ${1}"),*/
                                                ],
                                              ),
                                        SavedPost(),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                ),
              );
            }),
          );
        });
  }

  Widget customRow(String title, String imagepath) {
    return Container(
      width: 90 * SizeConfig.widthMultiplier,
      child: Container(
        width: double.maxFinite,
        height: 8 * SizeConfig.heightMultiplier,
        decoration: BoxDecoration(
            color: backgroundLightColor,
            borderRadius: BorderRadius.all(
              Radius.circular(2 * SizeConfig.imageSizeMultiplier),
            )),
        child: Row(
          children: [
            SizedBox(
              width: 5 * SizeConfig.widthMultiplier,
            ),
            Container(
              width: 5 * SizeConfig.widthMultiplier,
              height: 5 * SizeConfig.heightMultiplier,
              child: SvgPicture.asset(
                imagepath,
                color: colorWhite,
              ),
            ),
            SizedBox(
              width: 5 * SizeConfig.widthMultiplier,
            ),
            CustText(
                name: title,
                size: 1.8,
                colors: colorWhite,
                fontWeightName: FontWeight.w500)
          ],
        ),
      ),
    );
  }

  Widget buildStatRow(String value, String text) {
    return GestureDetector(
      onTap: () async {
        if (profileController.personProfileDetails!.accountType != "private" &&
            profileController.personProfileDetails!.id !=
                ApiClient.box.read("userId")) {
          /*  final FollowerController followerController = Get.put(FollowerController());
          await followerController.getFollowerUserList(0);
          await followerController.getFollowingList(0);
          Get.to(()=>FollowerView(userName:profileController.personProfileDetails!.username ??"",userId: 0,totalFollower:profileController.personProfileDetails?.totalFollowers??0,totalFollowing:profileController.personProfileDetails?.totalFollowing??0));
*/
        }

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => FollowerView(
                  userName:
                      profileController.personProfileDetails!.username ?? "",
                  userId: 0,
                  totalFollower:
                      profileController.personProfileDetails?.totalFollowers ??
                          0,
                  totalFollowing:
                      profileController.personProfileDetails?.totalFollowing ??
                          0)),
        );
        final FollowerController followerController =
            Get.put(FollowerController());
        await followerController.getFollowerUserList(0);
        await followerController.getFollowingList(0);
        // Get.to(()=>);
      },
      child: Container(
        color: Colors.transparent,
        height: 5 * SizeConfig.heightMultiplier,
        child: Padding(
          padding: EdgeInsets.only(right: 4.5 * SizeConfig.widthMultiplier),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustText(
                  name: value,
                  size: 1.6,
                  colors: colorPrimary,
                  fontWeightName: FontWeight.w800),
              CustText(
                  name: text,
                  size: 1.4,
                  colors: colorGrey,
                  fontWeightName: FontWeight.w500)
            ],
          ),
        ),
      ),
    );
  }
}
