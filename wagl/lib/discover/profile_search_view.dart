import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wagl/custom_widget/Strings.dart';
import 'package:wagl/discover/discover_controller.dart';
import 'package:wagl/home/home_page.dart';
import 'package:wagl/profile/post_view.dart';
import '../custom_widget/check_internet.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_button.dart';
import '../custom_widget/cust_button_background.dart';
import '../custom_widget/cust_text.dart';
import '../follower/follower_controller.dart';
import '../follower/follower_view.dart';
import '../home/report_view.dart';
import '../register/additional_details_controller.dart';
import '../register/update_categories_view.dart';
import '../settings/settings_view.dart';
import '../util/SizeConfig.dart';

class ProfileSearchView extends StatefulWidget {
  final int id;

  const ProfileSearchView({super.key, required this.id}); // Use this

  @override
  _ProfileSearchViewState createState() => _ProfileSearchViewState();
}

class _ProfileSearchViewState extends State<ProfileSearchView> {
  double get randHeight => Random().nextInt(100).toDouble();

  late List<Widget> _randomChildren = _randomHeightWidgets(context);
  var discoverController = Get.put(DiscoverController());

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
    return Scaffold(
      backgroundColor: colorBlack,
      body: SafeArea(
        child: GetBuilder<DiscoverController>(
          init: DiscoverController(),
          builder:
              (controller) => /*discoverController.userDetails == null
              ? Center(child: CircularProgressIndicator())
              : */
                  DefaultTabController(
            length: 2,
            child: NestedScrollView(
              headerSliverBuilder: (context, _) {
                return [
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        Container(
                          height: 16 * SizeConfig.heightMultiplier,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                colorBlack,
                                colorBlack,
                                colorBlack,
                                colorBlackLight
                              ],
                              tileMode: TileMode.repeated,
                            ),
                          ),
                        ),
                        RefreshIndicator(
                          color: colorPrimary,
                          backgroundColor: colorBlack_2,
                          onRefresh: () async {
                            // print("here is the Id ${widget.userDetails!.interestedCategories/*!.data![0].attributesMedia!.categoryName*/}");
                            await discoverController
                                .clearRecentCategoriesFilter(widget.id);
                            return discoverController
                                .getProfileDetails(widget.id);
                          },
                          child: SingleChildScrollView(
                            controller: discoverController.scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Padding(
                              padding: EdgeInsets.all(
                                  2 * SizeConfig.widthMultiplier),
                              child: discoverController.isProfileLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                      color: colorPrimary,
                                      strokeWidth:
                                          0.5 * SizeConfig.widthMultiplier,
                                    ))
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // CustBackButton(),
                                            Container(
                                              width: 10 *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            CustText(
                                                name:
                                                    "@${discoverController.userDetails!.username}",
                                                size: 1.6,
                                                colors: colorWhite,
                                                textAlign: TextAlign.center,
                                                fontWeightName:
                                                    FontWeight.w700),
                                            CustBgButton(
width: 10,
                                                height: 4,
                                                onSelected: () {
                                                  // Get.to(() => SettingsView());
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder:
                                                          (context) =>
                                                              Container(
                                                                color:
                                                                    colorBlack,
                                                                height: 34 *
                                                                    SizeConfig
                                                                        .heightMultiplier,
                                                                width: 100 *
                                                                    SizeConfig
                                                                        .widthMultiplier,
                                                                child: ListView
                                                                    .builder(
                                                                        itemCount: discoverController
                                                                            .optionList
                                                                            .length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                                  if (index==0){
                                                                                    // Get.back();
                                                                                    Navigator.pop(context);
                                                                                    homeController.reportDetails();
                                                                                    homeController.clearReportData();
                                                                                    showModalBottomSheet(
                                                                                        isScrollControlled:
                                                                                        true,
                                                                                        context:
                                                                                        context,
                                                                                        backgroundColor:
                                                                                        backgroundDialog,
                                                                                        builder:
                                                                                            (context) {
                                                                                          return ReportSectionView(
                                                                                              0,
                                                                                              discoverController.userDetails!.id,true);
                                                                                        });
                                                                                  }
                                                                                  else if(index==1){
                                                                                // Get.back();
                                                                                Navigator.pop(context);
                                                                                showModalBottomSheet(
                                                                                    isScrollControlled: true,
                                                                                    context: context,
                                                                                    backgroundColor: backgroundDialog,
                                                                                    builder: (context) {
                                                                                      return Container(
                                                                                        width: 100 * SizeConfig.widthMultiplier,
                                                                                        height: 50 * SizeConfig.heightMultiplier,
                                                                                        // color: Colors.red,
                                                                                        child: Stack(
                                                                                          alignment: Alignment.topCenter,
                                                                                          children: [
                                                                                            Positioned(
                                                                                                top: 0,
                                                                                                child: Image.asset(
                                                                                                  "assets/background/dailog_bg.png",
                                                                                                  width: 100 * SizeConfig.widthMultiplier,
                                                                                                  height: 10 * SizeConfig.heightMultiplier,
                                                                                                  fit: BoxFit.fill,
                                                                                                )),
                                                                                            Column(
                                                                                              children: [
                                                                                                SizedBox(
                                                                                                  height: 4 * SizeConfig.widthMultiplier,
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
                                                                                                  width: 10.5 * SizeConfig.widthMultiplier,
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 4 * SizeConfig.widthMultiplier,
                                                                                                ),
                                                                                                CustTextBold(
                                                                                                  name: "Block @${discoverController.userDetails!.username} ?",
                                                                                                  size: 2.0,
                                                                                                  colors: colorWhite,
                                                                                                  fontWeightName: FontWeight.w500,
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 5 * SizeConfig.widthMultiplier,
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
                                                                                                SizedBox(
                                                                                                    width: 90 * SizeConfig.widthMultiplier,
                                                                                                    height: 32 * SizeConfig.heightMultiplier,
                                                                                                    child: Column(
                                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        Container(
                                                                                                          width: 88 * SizeConfig.widthMultiplier,
                                                                                                          child: CustText(
                                                                                                            name: "This will also block any other accounts that they may have or create in the future",
                                                                                                            size: 1.5,
                                                                                                            colors: colorGreyLight2,
                                                                                                            fontWeightName: FontWeight.w500,
                                                                                                          ),
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          height: 5 * SizeConfig.widthMultiplier,
                                                                                                        ),
                                                                                                        Container(


                                                                                                          child: Row(
                                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                                            crossAxisAlignment:CrossAxisAlignment.center,
                                                                                                            children: [
                                                                                                              SvgPicture.asset(
                                                                                                                "assets/icons/dot_icon.svg",
                                                                                                                height: 1 *
                                                                                                                    SizeConfig
                                                                                                                        .heightMultiplier,
                                                                                                                width: 2 *
                                                                                                                    SizeConfig
                                                                                                                        .widthMultiplier,
                                                                                                                fit: BoxFit
                                                                                                                    .contain,
                                                                                                                color:colorPrimary,
                                                                                                              ),
                                                                                                              SizedBox(width: 2*SizeConfig.widthMultiplier,),
                                                                                                              Container(
                                                                                                                width: 85 * SizeConfig.widthMultiplier,
                                                                                                                height: 5 * SizeConfig.heightMultiplier,
                                                                                                                child: CustText(
                                                                                                                  name: "They won’t be able to message you or find your profile or content on Wagl",
                                                                                                                  size: 1.6,
                                                                                                                  colors: colorWhite,
                                                                                                                  fontWeightName: FontWeight.w600,
                                                                                                                ),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          height: 5 * SizeConfig.widthMultiplier,
                                                                                                        ),
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            SvgPicture.asset(
                                                                                                              "assets/icons/dot_icon.svg",
                                                                                                              height: 1 *
                                                                                                                  SizeConfig
                                                                                                                      .heightMultiplier,
                                                                                                              width: 2 *
                                                                                                                  SizeConfig
                                                                                                                      .widthMultiplier,
                                                                                                              fit: BoxFit
                                                                                                                  .contain,
                                                                                                              color:colorPrimary,
                                                                                                            ),
                                                                                                            SizedBox(width: 2*SizeConfig.widthMultiplier,),
                                                                                                            CustText(
                                                                                                              name: "They won’t be notified that you blocked them.",
                                                                                                              size: 1.6,
                                                                                                              colors: colorWhite,
                                                                                                              fontWeightName: FontWeight.w600,
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          height: 5 * SizeConfig.widthMultiplier,
                                                                                                        ),
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            SvgPicture.asset(
                                                                                                              "assets/icons/dot_icon.svg",
                                                                                                              height: 1 *
                                                                                                                  SizeConfig
                                                                                                                      .heightMultiplier,
                                                                                                              width: 2 *
                                                                                                                  SizeConfig
                                                                                                                      .widthMultiplier,
                                                                                                              fit: BoxFit
                                                                                                                  .contain,
                                                                                                              color:colorPrimary,
                                                                                                            ),
                                                                                                            SizedBox(width: 2*SizeConfig.widthMultiplier,),
                                                                                                            CustText(
                                                                                                              name: "You can unblock them at any time in settings",
                                                                                                              size: 1.6,
                                                                                                              colors: colorWhite,
                                                                                                              fontWeightName: FontWeight.w600,
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                        Spacer(),
                                                                                                        CustButton(name: "Block", size: 1.5, btnColor:colorPrimary, width: 100, height: 7, fontColor: colorBlack, onSelected: () async {
                                                                                                          // Get.back();
                                                                                                          ConnectionChecker.checkConnection(
                                                                                                            context: context,
                                                                                                            onConnected: () async {
                                                                                                              await discoverController.blockUserApi(widget.id);
                                                                                                            },
                                                                                                          );
                                                                                                          Navigator.pop(context);
                                                                                                        }),
                                                                                                        SizedBox(height: 2*SizeConfig.heightMultiplier,),
                                                                                                      ],
                                                                                                    ))
                                                                                              ],
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 6 * SizeConfig.widthMultiplier,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    });
                                                                              }

                                                                              else if(index==4){
                                                                                    Navigator.pop(context);
                                                                              }
                                                                              print("here is the index $index");

                                                                            },
                                                                            child: Container(
                                                                                color: Colors.transparent,
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    Center(
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.symmetric(vertical: 1.75 * SizeConfig.heightMultiplier),
                                                                                        child: CustText(name: discoverController.optionList[index], size: 1.5, colors: colorWhite, fontWeightName: FontWeight.w600),
                                                                                      ),
                                                                                    ),
                                                                                    Divider(
                                                                                      color: borderColor,
                                                                                      endIndent: 2 * SizeConfig.widthMultiplier,
                                                                                      thickness: 1,
                                                                                    ),
                                                                                  ],
                                                                                )),
                                                                          );
                                                                        }),
                                                              ));
                                                },
                                                iconPath:
                                                    "assets/icons/triple_dot.svg"),
                                          ],
                                        ),
                                        SizedBox(
                                          height:
                                              3 * SizeConfig.heightMultiplier,
                                          width:
                                              100 * SizeConfig.widthMultiplier,
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
                                                            // Dialog with Enlarged Profile Picture
                                                            Center(
                                                              child: Dialog(
                                                                shape: const CircleBorder(),
                                                                child: Container(
                                                                  width: 70*SizeConfig.widthMultiplier,
                                                                  height: 40*SizeConfig.heightMultiplier,
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape.circle, // Circular shape
                                                                    image: DecorationImage(
                                                                      image: discoverController.profileImg != null &&
                                                                          discoverController.userDetails!.profilePic != null
                                                                          ? NetworkImage(
                                                                          discoverController.userDetails!.profilePic!.url)
                                                                          : const AssetImage("assets/images/no_profile.png")
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
                                                        image: discoverController
                                                                        .profileImg !=
                                                                    null &&
                                                                discoverController
                                                                        .userDetails!
                                                                        .profilePic !=
                                                                    null
                                                            ? NetworkImage(
                                                                discoverController
                                                                    .userDetails!
                                                                    .profilePic!
                                                                    .url)
                                                            : const AssetImage(
                                                                    "assets/images/no_profile.png")
                                                                as ImageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                /*Positioned(
                                            bottom:
                                            -3 * SizeConfig.heightMultiplier,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet<void>(
                                                  context: context,
                                                  backgroundColor:
                                                  backgroundDialog,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CustomBottomSheet(
                                                      height: discoverController
                                                          .profileImg !=
                                                          null &&
                                                          discoverController
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
                                                      textColor: Colors.white,
                                                      child: Column(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () async {
                                                              await discoverController
                                                                  .get_image(
                                                                  ImageSource
                                                                      .gallery);
                                                              Get.back();
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
                                                            onTap: () async {
                                                              await discoverController
                                                                  .get_image(
                                                                  ImageSource
                                                                      .camera);
                                                              Get.back();
                                                            },
                                                            child: customRow(
                                                                "Take photo",
                                                                "assets/icons/camera_svg.svg"),
                                                          ),
                                                          SizedBox(
                                                              height: 2 *
                                                                  SizeConfig
                                                                      .heightMultiplier),
                                                          discoverController
                                                              .profileImg !=
                                                              null ||
                                                              discoverController
                                                                  .image !=
                                                                  null
                                                              ? GestureDetector(
                                                            onTap:
                                                                () async {
                                                              if (context
                                                                  .mounted) {
                                                                showDialog(
                                                                    context:
                                                                    context,
                                                                    builder:
                                                                        (BuildContext context) =>
                                                                        CustomLoadingPopup());
                                                              }
                                                              final result =
                                                              await discoverController
                                                                  .removeProfileImage();
                                                              Get.back();
                                                              Get.back();
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
                                                    SizeConfig.widthMultiplier,
                                                height: 10 *
                                                    SizeConfig.heightMultiplier,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 3,
                                                        style:
                                                        BorderStyle.solid)),
                                                child: Image.asset(
                                                    fit: BoxFit.contain,
                                                    "assets/icons/edit_icon.png"),
                                              ),
                                            ),
                                          ),*/
                                              ],
                                            ),
                                            SizedBox(
                                              width: 3 *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 61*SizeConfig.widthMultiplier,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                    children: [
                                                      buildStatRow(
                                                          "${discoverController.userDetails!.totalWagls ?? "0" /*attributes!.userId!.data!.attributes!.totalWagls*/}",
                                                          "wagls"),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          if (discoverController
                                                                  .userDetails!
                                                                  .accountType ==
                                                              "public") {

                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(builder: (_) => FollowerView(
                                                                userName: discoverController
                                                                    .userDetails
                                                                    ?.username ??
                                                                    "",
                                                                userId:
                                                                widget
                                                                    .id,
                                                                totalFollower:
                                                                discoverController.userDetails?.totalFollowers ??
                                                                    0,
                                                                totalFollowing:
                                                                discoverController.userDetails?.totalFollowing ??
                                                                    0,
                                                              )),
                                                            );
                                                            final FollowerController
                                                            followerController =
                                                            Get.put(
                                                                FollowerController());
                                                            await followerController
                                                                .getFollowerUserList(
                                                                widget.id);
                                                            await followerController
                                                                .getFollowingList(
                                                                widget.id);
                                                            /*Get.to(
                                                                () =>
                                                                    FollowerView(
                                                                      userName: discoverController
                                                                              .userDetails
                                                                              ?.username ??
                                                                          "",
                                                                      userId:
                                                                          widget
                                                                              .id,
                                                                      totalFollower:
                                                                          discoverController.userDetails?.totalFollowers ??
                                                                              0,
                                                                      totalFollowing:
                                                                          discoverController.userDetails?.totalFollowing ??
                                                                              0,
                                                                    ));*/
                                                          }
                                                        },
                                                        child: buildStatRow(
                                                            "${discoverController.userDetails!.totalFollowers}",
                                                            "followers"),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          if (discoverController
                                                                  .userDetails!
                                                                  .accountType ==
                                                              "public") {

                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(builder: (_) => FollowerView(
                                                                userName: discoverController
                                                                    .userDetails
                                                                    ?.username ??
                                                                    "",
                                                                userId:
                                                                widget
                                                                    .id,
                                                                totalFollower:
                                                                discoverController.userDetails?.totalFollowers ??
                                                                    0,
                                                                totalFollowing:
                                                                discoverController.userDetails?.totalFollowing ??
                                                                    0,
                                                              )),
                                                            );
                                                            final FollowerController
                                                            followerController =
                                                            Get.put(
                                                                FollowerController());
                                                            await followerController
                                                                .getFollowerUserList(
                                                                widget.id);
                                                            await followerController
                                                                .getFollowingList(
                                                                widget.id);
                                                           /* Get.to(
                                                                () =>
                                                                    );*/
                                                          }
                                                        },
                                                        child: buildStatRow(
                                                            "${discoverController.userDetails!.totalFollowing}",
                                                            "following"),
                                                      ),
                                                      buildStatRow(
                                                          // "${discoverController.totalViewCountUser}",
                                                          "${discoverController.userDetails!.totalViews}",
                                                          "views"),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 2 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                ),
                                               /* FutureBuilder<bool>(
                                                  future: discoverController.isFollowerApi(widget.id),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                      return Center(child: CircularProgressIndicator());
                                                    } else if (snapshot.hasError) {
                                                      return Center(child: Text('Error: ${snapshot.error}'));
                                                    } else if (snapshot.hasData) {
                                                      bool isFollower = snapshot.data ?? false;
                                                      return Center(
                                                        child: CustText(isFollower
                                                            ? "The user is a follower."
                                                            : "The user is not a follower.",size: 1.6,colors: 10),
                                                      )
                                                      ;
                                                    } else {
                                                      return Center(child: Text('Something went wrong.'));
                                                    }
                                                  },
                                                ),*/
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        // discoverController.isLoadingUpdate(true);
                                                        print("here is ${discoverController.isClicked} isClicked");
                                                        if(discoverController.isClicked){

                                                            var result = await discoverController
                                                                .updateFollower(
                                                                widget.id,
                                                                !discoverController
                                                                    .checkedFollowedUser(
                                                                    widget
                                                                        .id));

                                                            homeController.update();


                                                        }
else{
  print("here is the call");
                                                        }
                                                        // profileController.getUsersWagl(widget.id);
                                                      },
                                                      onDoubleTap: (){
                                                        print("Double Tap");
                                                      }
                                                      ,

                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 1),
                                                          color: colorBlack,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                            2 *
                                                                SizeConfig
                                                                    .imageSizeMultiplier,
                                                          )),
                                                          shape: BoxShape
                                                              .rectangle,
                                                        ),
                                                        width: 60 *
                                                            SizeConfig
                                                                .widthMultiplier,
                                                        height: 4.5 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                        child: Center(
                                                            child: discoverController.isLoading?Padding(
                                                              padding: const EdgeInsets.all(2.0),
                                                              child: const CircularProgressIndicator(color: colorPrimary,strokeWidth: 3,),
                                                            ):CustText(
                                                          name: discoverController
                                                                  .checkedFollowedUser(
                                                                      widget.id)
                                                              ? "Following"
                                                              : "Follow",
                                                          size: 1.8,
                                                          colors: colorWhite,
                                                          textAlign:
                                                              TextAlign.start,
                                                          fontWeightName:
                                                              FontWeight.w500,
                                                        )),
                                                      ),
                                                    ),

                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height:
                                              2 * SizeConfig.heightMultiplier,
                                        ),
                                        CustText(
                                            name:
                                                "${discoverController.userDetails!.firstName} ${discoverController.userDetails!.lastName}",
                                            size: 1.6,
                                            colors: colorWhite,
                                            textAlign: TextAlign.start,
                                            fontWeightName: FontWeight.w800),

                                        CustText(
                                            name: discoverController
                                                .userDetails!.bio,
                                            size: 1.5,
                                            colors: colorGrey,
                                            textAlign: TextAlign.start,
                                            fontWeightName: FontWeight.w500),
                                        discoverController
                                            .userDetails!.accountType ==
                                            "private"
                                            ? Container()
                                            :    Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height:
                                                  2 * SizeConfig.heightMultiplier,
                                            ),
                                            discoverController
                                                .userCategoriesList!.isEmpty
                                                ? Container()
                                                : CustText(
                                                name: "Recent categories",
                                                size: 1.6,
                                                colors: colorWhite,
                                                textAlign: TextAlign.start,
                                                fontWeightName:
                                                FontWeight.w800),
                                            discoverController
                                                .userDetails!.accountType ==
                                                "private"
                                                ? Container()
                                                : discoverController
                                                .userCategoriesList!.isEmpty
                                                ? Container()
                                                : SizedBox(
                                              height: 5 *
                                                  SizeConfig
                                                      .heightMultiplier,
                                              child: discoverController
                                                  .userCategoriesList!
                                                  .isNotEmpty
                                                  ? ListView.builder(
                                                  scrollDirection:
                                                  Axis.horizontal,
                                                  itemCount:
                                                  discoverController
                                                      .userCategoriesList!
                                                      .length,
                                                  itemBuilder:
                                                      (context,
                                                      index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        print(
                                                            "here is the tap");
                                                        discoverController
                                                            .getUserFilteredWaglsFromCategories(
                                                            index,
                                                            widget
                                                                .id);
                                                      },
                                                      child: Center(
                                                        child:
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal:
                                                              1.0 *
                                                                  SizeConfig.widthMultiplier),
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: discoverController.selectedUserCategoriesIndex.contains(index) ? colorPrimary : borderColor,
                                                                  borderRadius: BorderRadius.all(
                                                                    Radius.circular(10 * SizeConfig.imageSizeMultiplier),
                                                                  ),
                                                                  shape: BoxShape.rectangle),
                                                              child: Padding(
                                                                padding:
                                                                EdgeInsets.all(2.0 * SizeConfig.widthMultiplier),
                                                                child: CustText(
                                                                    name: discoverController.userCategoriesList![index].categoryName,
                                                                    size: 1.4,
                                                                    colors: discoverController.selectedUserCategoriesIndex.contains(index) ? colorBlack : colorWhite,
                                                                    fontWeightName: FontWeight.w700),
                                                              )),
                                                        ),
                                                      ),
                                                    );
                                                  })
                                                  : Container(),
                                            ),
                                          ],
                                        ),

                                        SizedBox(
                                          height:
                                              1 * SizeConfig.heightMultiplier,
                                        ),
                                        SizedBox(
                                          height: 1 * SizeConfig.heightMultiplier,
                                          width: 100 * SizeConfig.widthMultiplier,
                                          child: Divider(
                                            color: borderColor,
                                            thickness: 1.5,
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
                ];
              },
              body: discoverController.userDetails?.accountType == "private"
                  ? Container()
                  : discoverController.userWagls!.isEmpty?Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                       SizedBox(
                        height: 3 * SizeConfig.heightMultiplier,
                        width: 100 * SizeConfig.widthMultiplier,

                      ),
                      CustText(name: "No Wagls are available for this user.", size: 1.8, colors: colorWhite, fontWeightName: FontWeight.w600),
                    ],
                  ):Column(
                      children: <Widget>[
                        discoverController.isProfileWaglLoading
                            ? discoverController.isProfileLoading
                                ? Container()
                                : Center(
                                    child: CircularProgressIndicator(
                                    color: colorPrimary,
                                    strokeWidth:
                                        0.5 * SizeConfig.widthMultiplier,
                                  ))
                            : Expanded(
                                child: WaglPost(
                                  userCategoriesList: discoverController.selectedUserCategoriesList,
                                userData: discoverController.userWagls,
                                userId: widget.id,
                              )),

                        /* Expanded(
                    child: TabBarView(
                      children: [
                        WaglPost()
                      ],
                    ),
                  ),*/
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
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
    return Container(
      color: Colors.transparent,
      height:5*SizeConfig.heightMultiplier,

      child: Padding(
        padding: EdgeInsets.only(right: 4.5 * SizeConfig.widthMultiplier),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }
}
