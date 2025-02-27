import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/custom_widget/create_post_wagl.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import 'package:wagl/custom_widget/cust_text_shadow.dart';
import 'package:wagl/home/main_screen.dart';
import 'package:wagl/home/product_wagl_view.dart';
import 'package:wagl/home/report_view.dart';
import 'package:wagl/home/waglStoryView.dart';
import 'package:wagl/profile/profile_controller.dart';
import 'package:wagl/util/SizeConfig.dart';
import '../create_wagl/create_wagl_controller.dart';
import '../create_wagl/create_wagl_view.dart';
import '../custom_widget/check_internet.dart';
import '../custom_widget/color_loader.dart';
import '../custom_widget/custom_loading_popup.dart';
import '../custom_widget/hexa_outline_widget.dart';
import '../custom_widget/readmore_widget.dart';
import '../discover/discover_controller.dart';
import '../discover/profile_search_view.dart';
import '../discover/wagl_categories_view.dart';
import '../util/ApiClient.dart';
import 'all_wagl_model.dart';
import 'comments/comment_view.dart';
import 'home_controller.dart';
import 'home_model.dart';
import 'home_page.dart';
import 'home_wagl_model.dart';

class HomeWaglScreen extends StatelessWidget {
  int waglIndex = 0;
  var homeController = Get.put(HomeController());
  final ScrollController _scrollController = ScrollController();

  HomeWaglScreen({super.key, @required waglIndex});

  @override
  Widget build(BuildContext context) {
    // homeController.getAllWagls();
    homeController.requestPermissions();
    // homeController.updateCurrentPageIndex(0);
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorBlack,
        resizeToAvoidBottomInset: false,
        body: GetBuilder<HomeController>(
            init: HomeController(),
            builder: (controller) => RefreshIndicator(
                  color: colorPrimary,
                  backgroundColor: colorBlack_2,
                  onRefresh: () async {
                    if (await CheckInternet.checkInternet()) {
                      return homeController.getHomeFeedWagl();
                    } else {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          backgroundColor: colorBlack_2,
                          title: Row(
                            children: [
                              Icon(Icons.info_outline),
                              SizedBox(
                                width: 2 * SizeConfig.widthMultiplier,
                              ),
                              CustText(
                                  name: 'No internet connection !',
                                  size: 1.8,
                                  colors: colorWhite,
                                  fontWeightName: FontWeight.w600,
                                  textAlign: TextAlign.start),
                            ],
                          ),
                          content: Padding(
                            padding: EdgeInsets.only(
                                right: 3.0 * SizeConfig.widthMultiplier,
                                top: 2 * SizeConfig.heightMultiplier),
                            child: CustText(
                                name:
                                    'Please check your internet connection and try again.',
                                size: 1.5,
                                colors: colorWhite,
                                fontWeightName: FontWeight.w900),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: CustText(
                                  name: 'Cancel',
                                  size: 1.6,
                                  colors: colorWhite,
                                  fontWeightName: FontWeight.w600),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: CustText(
                                  name: 'Ok',
                                  size: 1.6,
                                  colors: colorWhite,
                                  fontWeightName: FontWeight.w600),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: homeController.isWaglLoading ||
                          homeController.homeWaglStoryItems.isEmpty

                      ?  homeController.isWaglLoading
                      ? Center(child: ColorLoader())
                      : Column(
                  children: [
                    Expanded(
                      child: Container(
                        // color: Colors.red,
                        height: 80 * SizeConfig.heightMultiplier,
                        child: RefreshIndicator(
                          onRefresh: () {
                            return homeController.getHomeFeedWagl();
                          },
                          child: ListView(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.0 * SizeConfig.widthMultiplier,
                            ),
                            children: [
                              SizedBox(height: 30*SizeConfig.heightMultiplier,),
                              CustCreateWaglPost(
                                onSelected: () async {
                                  // Clear any existing selected media
                                  homeController.currentSelectedMedia = null;

                                  // Show a loading dialog while images are being picked
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) =>

                                    CustomLoadingPopup(),
                                  );

                                  // Pick images
                                  var images = await homeController.pickImages();
                                  Navigator.pop(context); // Dismiss the loading dialog

                                  // Navigate to StoryDesignerScreen if media is selected
                                  if (homeController.currentSelectedMedia != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StoryDesignerScreen(
                                          mediaPath: homeController.currentSelectedMedia!,
                                          index: 0,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                isDiscard: (value) {
                                  homeController.updateDiscardValue(value);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )

                : PageView.builder(
                      controller: homeController.pageViewController,
                          // onPageChanged: homeController.handlePageViewChanged,
                          scrollDirection: Axis.vertical,
                          scrollBehavior: ScrollBehavior(),
                          onPageChanged: (index) {
                            homeController.homeWaglStoryItems[storyViewIndex].controller.pause();
                            // homeController.homeWaglStoryItems[storyViewIndex].controller.value.duration();
                            homeController.handleMainPageViewChanged(index);
                          },
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: homeController.homeWaglStoryItems.length,
                          itemBuilder: (itemBuilderContext, index) {
                            final personStories =
                                homeController.homeWaglStoryItems[index];
                            double screenWidth =
                                100 * SizeConfig.widthMultiplier;
                            // double segmentWidth = (screenWidth - (personStories.stories.length - (0.5*SizeConfig.widthMultiplier)) * (0*SizeConfig.widthMultiplier)) / personStories.stories.length;
                            double segmentWidth = (screenWidth -
                                ((personStories.stories.length) *
                                    (3 * SizeConfig.widthMultiplier)));
                            segmentWidth =
                                segmentWidth / personStories.stories.length;

                            return Stack(
                              children: [
                                StoryView(
                                  inline: true,

                                  onStoryShow: (value) {

                                    int index =
                                        personStories.stories.indexOf(value);
                                    homeController.storyViewShowIndex(index);

                                    print("here is the index $index \n \n personStories.stories.indexOf(value) ${personStories.stories.indexOf(value)} \n\n  currentIndexStoryView== ${homeController.currentIndexStoryView}\n\n");
                                  },
                                  onComplete: () {},
                                  /* onVerticalSwipeComplete: (value) {
                                Direction? direction;
                                direction = value;
                                if (direction == Direction.up) {
                                  print("Here is the direction call");
                                  homeController.updateWaglIndex(
                                      storyViewIndex + 1);
                                } else if (direction == Direction.up) {
                                  homeController.updateWaglIndex(
                                      storyViewIndex - 1);
                                }
                              },*/

                                  storyItems: personStories.stories,
                                  progressPosition: ProgressPosition.top,
                                  repeat: false,

                                  controller: homeController
                                      .homeWaglStoryItems[index].controller,
                                  // indicatorForegroundColor: Colors.transparent,
                                  // indicatorColor: Colors.transparent,
                                ),
                            /*    Positioned(
                                  top: 1*SizeConfig.heightMultiplier,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                        personStories.stories.length,
                                        (indexSegment) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                1 * SizeConfig.widthMultiplier),
                                        child: Container(
                                          width: segmentWidth,
                                          height:
                                              0.3 * SizeConfig.heightMultiplier,
                                          decoration: BoxDecoration(
                                            color: indexSegment <=
                                                    homeController
                                                        .currentIndexStoryView
                                                ? Colors.white
                                                : Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),*/
                                Positioned(
                                  top: 0,
                                  child: Container(
                                    width: 100 * SizeConfig.widthMultiplier,
                                    // height: 10 * SizeConfig.heightMultiplier,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 2 * SizeConfig.heightMultiplier),
                                      child: Row(children: [
                                        SizedBox(
                                          width: 2 *
                                              SizeConfig.imageSizeMultiplier,
                                        ),
                                        GestureDetector(
                                          /*onTap: () async {

                                            print("here is am navigating using bottom bar ");
                                            if (ApiClient.box.read("userId") !=
                                                personStories.userId) {
                                              var profileController =
                                                  Get.put(ProfileController());

                                              profileController
                                                  .getFollowersList();
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) =>
                                                      CustomLoadingPopup());
                                              var result =
                                              await profileController
                                                  .getUsersWagl(
                                                  personStories
                                                      .userId!);


                                              profileController
                                                  .getFollowersList();
                                              print(
                                                  "here ${personStories.userId}");
                                              print("here $index");
                                              profileController.getUsersWagl(
                                                  personStories.userId);
                                              var discoverController =
                                                  Get.put(DiscoverController());
                                              discoverController.clearData();

                                              discoverController
                                                  .getProfileDetails(
                                                      personStories.userId);
                                              await discoverController
                                                  .getUsersWagl(
                                                      personStories.userId);
                                              // Get.back();
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (_) => ProfileSearchView(
                                                    id: personStories.userId!)),
                                              );

                                            } else {
                                              homeController.isOwnProfile =
                                                  false;
                                              profileController
                                                  .updateProfilePage(false);

                                              homeController.changeTabIndex(4);
                                            }
                                            */ /*    Get.to(()=>VideoPage());*/ /*
                                          },*/
                                          onTap: () async {
                                            print(
                                                "Navigating using bottom bar");

                                            if (ApiClient.box.read("userId") !=
                                                personStories.userId) {
                                              // Store a reference to the dialog's context

                                              try {
                            /*
                                                var profileController = Get.put(
                                                    ProfileController());*/
                                                var discoverController =
                                                    Get.put(
                                                        DiscoverController());
                                                discoverController.updateLoaders();
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        ProfileSearchView(
                                                            id: personStories
                                                                .userId!),
                                                  ),
                                                );
                                                // Fetch and update required data
                                                // Clear existing data and fetch new profile details
                                                await discoverController
                                                    .getProfileDetails(
                                                        personStories.userId);
                                                await discoverController
                                                    .getUsersWagl(
                                                        personStories.userId);

                                                // Navigate to the profile search view

                                              } catch (e) {
                                                print(
                                                    "Error during navigation: $e");
                                              }
                                            } else {
                                              // Handle case where the user is navigating to their own profile
                                              /*homeController.isOwnProfile =
                                                  false;
                                              profileController
                                                  .updateProfilePage(false);*/
                                              homeController.onBottomOptionTapped(4);
                                              homeController.update();
                                            }
                                          },
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 8 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  height: 4 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,

                                                    image: DecorationImage(
                                                      image: personStories
                                                                  .profileImage ==
                                                              null
                                                          ? AssetImage(
                                                              "assets/images/no_profile.png")
                                                          : NetworkImage(
                                                                  "${homeController.homeWaglStoryItems[index].profileImage}")
                                                              /* : AssetImage("assets/images/no_profile.png")*/
                                                              as ImageProvider,
                                                      // Use NetworkImage for network images
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 3 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                ),

                                                CustTextShadow(
                                                    name: homeController
                                                        .homeWaglStoryItems[
                                                            index]
                                                        .username,
                                                    size: 1.6,
                                                    colors: colorWhite,
                                                    textAlign: TextAlign.start,
                                                    fontWeightName:
                                                        FontWeight.w600)
                                                /*   CustText(
                                                    name: homeController
                                                        .homeWaglStoryItems[
                                                            index]
                                                        .username,
                                                    size: 1.6,
                                                    colors: colorWhite,
                                                    fontWeightName:
                                                        FontWeight.w800)*/
                                              ],
                                            ),
                                          ),
                                        ),
                                        ApiClient.box.read("userId") !=
                                                personStories.userId
                                            ? Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 2 *
                                                            SizeConfig
                                                                .widthMultiplier),
                                                    child: Container(
                                                      width: 1 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                      height: 1 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                   /* onTap:
                                                        homeController
                                                                .isProcessing
                                                            ? null
                                                            : () {
                                                                if (homeController
                                                                    .isProcessing) {
                                                                  print(
                                                                      "\n\n Processing");
                                                                } else {
                                                                  homeController.updateFollower(
                                                                      index,
                                                                      personStories
                                                                          .userId!,
                                                                      !homeController.checkedFollowedUser(
                                                                          homeController
                                                                              .homeWaglStoryItems[index]
                                                                              .userId!,
                                                                          index),
                                                                      false,
                                                                      false);
                                                                }
                                                              },*/
                                                    onTap:() async {
                                                      var result =await homeController.updateFollowerHome(index,!personStories.isFollows,personStories.userId);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey,
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
                                                        shape:
                                                            BoxShape.rectangle,
                                                      ),
                                                      height: 4 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      child: Center(
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 3.0 *
                                                                      SizeConfig
                                                                          .widthMultiplier),
                                                          child: CustTextShadow(
                                                            name: /*homeController.checkedFollowedUser(
                                                                    homeController
                                                                        .homeWaglStoryItems[
                                                                            index]
                                                                        .userId!,
                                                                    index)*/
                                                            homeController.homeWaglStoryItems[index].isFollows
                                                                ? "Following"
                                                                : "Follow",
                                                            size: 1.5,
                                                            fontWeightName:
                                                                FontWeight.w600,
                                                            // colors:colorWhite,
                                                          ),
                                                          /* CustText(
                                                              name: homeController.checkedFollowedUser(
                                                                      homeController
                                                                          .homeWaglStoryItems[
                                                                              index]
                                                                          .userId!,
                                                                      index)
                                                                  ? "Following"
                                                                  : "Follow",
                                                              size: 1.6,
                                                              colors:
                                                                  colorWhite,
                                                              fontWeightName:
                                                                  FontWeight
                                                                      .w800),*/
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : Container(),
                                      ]),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    bottom: 0,
                                    child: Container(
                                      width: 100 * SizeConfig.widthMultiplier,
                                      height: 20 * SizeConfig.heightMultiplier,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black,
                                            Colors.transparent
                                          ],
                                        ),
                                      ),
                                    )),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    width: 100 * SizeConfig.widthMultiplier,
                                    height: 50 * SizeConfig.heightMultiplier,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [

                                        Container(
                                          width: 80 * SizeConfig.widthMultiplier,

                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 2.0 * SizeConfig.widthMultiplier,
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                if (personStories.location != " Add locations" &&
                                                    personStories.location!.trim().isNotEmpty)
                                                  Flexible(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        text: personStories.location,
                                                        children: [
                                                          if (personStories.location!.length > 20) // Limit location text
                                                            TextSpan(
                                                              text: " ...",
                                                              style: TextStyle(
                                                                color: Colors.white, // Highlight for read more
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                      maxLines: 1, // Display only 1 line
                                                      overflow: TextOverflow.ellipsis, // Handle overflow
                                                      style: TextStyle(
                                                        fontSize: 1.2 * SizeConfig.textMultiplier,
                                                        color: colorWhite,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                if (personStories.location != " Add locations" &&
                                                    personStories.location!.trim().isNotEmpty)
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 1 * SizeConfig.heightMultiplier,
                                                    ),
                                                    child: Container(
                                                      width: 1 * SizeConfig.widthMultiplier,
                                                      height: 1 * SizeConfig.heightMultiplier,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 1 * SizeConfig.widthMultiplier,
                                                  ),
                                                  child: CustText(
                                                    name: "${personStories.views ?? "0"} views",
                                                    fontWeightName: FontWeight.w500,
                                                    size: 1.4,
                                                    colors:colorWhite ,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(
                                          height:
                                              0.5 * SizeConfig.heightMultiplier,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            // color: Colors.transparent, // Ensure background is set or transparent
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                Colors.black87,
                                                // Colors.black,
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4.0 *
                                                    SizeConfig.widthMultiplier),
                                            child: Container(

                                              width:
                                                  100 * SizeConfig.widthMultiplier,
                                              child: Padding(
                                                padding: EdgeInsets.only(right: 20*SizeConfig.widthMultiplier),
                                                child: ReadMoreText(
                                                  trimLines: 2,
                                                  textColor: colorWhite,
                                                  text: personStories.description ??
                                                      "",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          color: colorBlack,                                          height:
                                              1 * SizeConfig.heightMultiplier,
                                        ),
                                        Container(
                                          height: homeController
                                                      .homeWaglStoryItems[index]
                                                      .categoryData
                                                      .isEmpty &&
                                                  homeController
                                                      .homeWaglStoryItems[index]
                                                      .goodTagData
                                                      .isEmpty
                                              ? 0 * SizeConfig.heightMultiplier
                                              : 4 * SizeConfig.heightMultiplier,

                                          /* decoration:  BoxDecoration(
                                            color: Colors.transparent,
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 60,
                                                  blurStyle: BlurStyle.normal,
                                                  color: colorBlackShadow,
                                                  offset: Offset.zero,
                                                  spreadRadius: 2*SizeConfig.heightMultiplier),
                                            ],
                                          ),*/
                                          child: Container(
                                            color: colorBlack,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: ListView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    controller: _scrollController,
                                                    children: [
                                                      ...homeController
                                                          .homeWaglStoryItems[
                                                              index]
                                                          .categoryData
                                                          .map((categoriesTag) =>
                                                              buildCategoriesTag(
                                                                  categoriesTag,
                                                                  context))
                                                          .toList(),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                8.0),
                                                        child: homeController
                                                                    .homeWaglStoryItems[
                                                                        index]
                                                                    .goodTagData!
                                                                    .isNotEmpty &&
                                                                homeController
                                                                    .homeWaglStoryItems[
                                                                        index]
                                                                    .categoryData
                                                                    .isNotEmpty
                                                            ? SvgPicture.asset(
                                                                "assets/icons/dot_icon.svg",
                                                                height: 1 *
                                                                    SizeConfig
                                                                        .heightMultiplier,
                                                                width: 2 *
                                                                    SizeConfig
                                                                        .widthMultiplier,
                                                                fit: BoxFit
                                                                    .contain,
                                                                color:
                                                                    colorGreyLight2,
                                                              )
                                                            : Container(),
                                                      ),
                                                      ...homeController
                                                          .homeWaglStoryItems[
                                                              index]
                                                          .goodTagData
                                                          .map((tag) =>
                                                              buildGoodTags(index,
                                                                  tag, context))
                                                          .toList(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          color: colorBlack
                                          ,
                                          height:
                                              2.8 * SizeConfig.heightMultiplier,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 10 * SizeConfig.heightMultiplier,
                                  child: Container(
                                    width: 15 * SizeConfig.widthMultiplier,
                                    height: 40 * SizeConfig.heightMultiplier,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              /*  homeController.updateIsLikeFlag( homeController
                                              .checkedLikedPost(
                                              homeController
                                                  .wagls![index].id));*/
                                              // homeController.homeWaglStoryItems[storyViewIndex].controller.dispose();

                                              print(
                                                  "\n\n if {consition} ${homeController.homeWaglStoryItems[index].liked} \n\n");
                                              await homeController
                                                  .likeWaglHomePage(
                                                      homeController
                                                          .homeWaglStoryItems[
                                                              index]
                                                          .waglId,
                                                      index,
                                                      !homeController
                                                          .homeWaglStoryItems[
                                                              index]
                                                          .liked);
                                            },
                                            child: HezaOutline(
                                              iconPath: homeController
                                                      .homeWaglStoryItems[index]
                                                      .liked
                                                  ? "assets/icons/like_icon.png"
                                                  : "assets/icons/unlike_icon.png",
                                              /* iconPath: homeController
                                                  .storyItems[index].liked
                                              ? "assets/icons/like_icon.png"
                                              : "assets/icons/unlike_icon.png",*/
                                            ),
                                          ),
                                          SizedBox(
                                            height: 0.5 *
                                                SizeConfig.heightMultiplier,
                                          ),
                                          CustText(
                                            name: homeController
                                                .homeWaglStoryItems[index].likes
                                                .toString() /*"${homeController.incrementStringNumber(homeController
                                            .storyItems[index].likes,homeController
                                            .storyItems[index].liked)}"*/
                                            ,
                                            size: 1.6,
                                            colors: colorWhite,
                                            fontWeightName: FontWeight.w700,
                                          ),
                                          SizedBox(
                                            height:
                                                1 * SizeConfig.heightMultiplier,
                                          ),
                                          CommentSectionView(
                                            waglId: homeController
                                                .homeWaglStoryItems[index]
                                                .waglId!,
                                            isHomeScreen: true,
                                            // parentContext: context,
                                          ),
                                          SizedBox(
                                            height: 0.5 *
                                                SizeConfig.heightMultiplier,
                                          ),
                                          CustText(
                                            name: personStories.totalComments
                                                .toString(),
                                            size: 1.6,
                                            colors: colorWhite,
                                            fontWeightName: FontWeight.w700,
                                          ),
                                          SizedBox(
                                            height:
                                                1 * SizeConfig.heightMultiplier,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              await homeController.saveHomeWagl(
                                                  homeController
                                                      .homeWaglStoryItems[index]
                                                      .waglId,
                                                  index,
                                                  !homeController
                                                      .homeWaglStoryItems[index]
                                                      .saved);
                                            },
                                            child: HezaOutline(
                                              iconPath: homeController
                                                      .homeWaglStoryItems[index]
                                                      .saved
                                                  ? "assets/icons/unsaved_icon.png"
                                                  : "assets/icons/saved_icon.png",
                                            ),
                                          ),
                                          SizedBox(
                                            height: 0.5 *
                                                SizeConfig.heightMultiplier,
                                          ),
                                          CustText(
                                            name:
                                                "${homeController.homeWaglStoryItems[index].totalSaved}",
                                            size: 1.6,
                                            colors: colorWhite,
                                            fontWeightName: FontWeight.w700,
                                          ),
                                          SizedBox(
                                            height:
                                                1 * SizeConfig.heightMultiplier,
                                          ),
                                          homeController
                                                      .homeWaglStoryItems[index]
                                                      .productId !=
                                                  null
                                              ? GestureDetector(
                                                  onTap: () async {
                                                    var discoverController =
                                                        Get.put(
                                                            DiscoverController());
                                                    if (await CheckInternet
                                                        .checkInternet()) {
                                                      // Store a reference to the dialog's context
                                                      BuildContext?
                                                          dialogContext;

                                                      // Show a loading dialog
                                                      showDialog(
                                                        context: context,
                                                        // barrierDismissible: false, // Prevent user from dismissing the dialog
                                                        builder: (BuildContext
                                                            context) {
                                                          dialogContext =
                                                              context; // Save dialog context for dismissal
                                                          return CustomLoadingPopup();
                                                        },
                                                      );

                                                      try {
                                                        // Clear existing data before fetching new data
                                                        discoverController
                                                            .clearData();

                                                        // Fetch data for the selected category
                                                        final result =
                                                            await discoverController
                                                                .getAllProductWagls(
                                                          homeController
                                                              .homeWaglStoryItems[
                                                                  index]
                                                              .productId!
                                                              .id,
                                                        );

                                                        // Navigate to the next screen with the fetched data
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                ProductWaglView(
                                                              categoriesData:
                                                                  discoverController
                                                                      .categoriesListItems,
                                                              categoryIndex:
                                                                  index,
                                                              productId:
                                                                  homeController
                                                                      .homeWaglStoryItems[
                                                                          index]
                                                                      .productId!
                                                                      .id,
                                                              categoryWagls:
                                                                  discoverController
                                                                      .categoryWagls,
                                                              productCount:
                                                                  homeController
                                                                      .homeWaglStoryItems[
                                                                          index]
                                                                      .productId!
                                                                      .waglCount!,
                                                              productPic:
                                                                  homeController
                                                                      .homeWaglStoryItems[
                                                                          index]
                                                                      .productId!
                                                                      .productPic!
                                                                      .url,
                                                              productName:
                                                                  homeController
                                                                      .homeWaglStoryItems[
                                                                          index]
                                                                      .productId!
                                                                      .name!,
                                                            ),
                                                          ),
                                                        );

                                                        // Update controller values after navigation
                                                        discoverController
                                                            .updateDiscardValue(
                                                                false);
                                                        discoverController
                                                            .updateImageSize(
                                                                false);
                                                      } catch (e) {
                                                        print(
                                                            "Error during operation: $e");
                                                      } finally {
                                                        // Dismiss the loading dialog
                                                        if (dialogContext !=
                                                                null &&
                                                            Navigator.canPop(
                                                                dialogContext!)) {
                                                          Navigator.pop(
                                                              dialogContext!);
                                                        }
                                                      }
                                                    } else {
                                                      // Show a no-internet alert dialog
                                                      showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                          backgroundColor:
                                                              colorBlack_2,
                                                          title: Row(
                                                            children: [
                                                              Icon(Icons
                                                                  .info_outline),
                                                              SizedBox(
                                                                  width: 2 *
                                                                      SizeConfig
                                                                          .widthMultiplier),
                                                              CustText(
                                                                name:
                                                                    'No internet connection!',
                                                                size: 1.8,
                                                                colors:
                                                                    colorWhite,
                                                                fontWeightName:
                                                                    FontWeight
                                                                        .w600,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                              ),
                                                            ],
                                                          ),
                                                          content: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              right: 3.0 *
                                                                  SizeConfig
                                                                      .widthMultiplier,
                                                              top: 2 *
                                                                  SizeConfig
                                                                      .heightMultiplier,
                                                            ),
                                                            child: CustText(
                                                              name:
                                                                  'Please check your internet connection and try again.',
                                                              size: 1.5,
                                                              colors:
                                                                  colorWhite,
                                                              fontWeightName:
                                                                  FontWeight
                                                                      .w900,
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context,
                                                                      'Cancel'),
                                                              child: CustText(
                                                                name: 'Cancel',
                                                                size: 1.6,
                                                                colors:
                                                                    colorWhite,
                                                                fontWeightName:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context,
                                                                      'OK'),
                                                              child: CustText(
                                                                name: 'OK',
                                                                size: 1.6,
                                                                colors:
                                                                    colorWhite,
                                                                fontWeightName:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }

                                                    // Check connection and handle any related actions
                                                  },
                                                  child: Container(
                                                    width: 11 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    height: 6 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                      "assets/icons/heza_icon.png",
                                                    ))),
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        ClipPath(
                                                          clipper:
                                                              HexagonClipperProduct(),
                                                          child: Container(
                                                            width: 10 *
                                                                SizeConfig
                                                                    .widthMultiplier,
                                                            height: 5.5 *
                                                                SizeConfig
                                                                    .heightMultiplier,
                                                            child: ClipRRect(
                                                              child:
                                                                  BackdropFilter(
                                                                      filter: ImageFilter.blur(
                                                                          sigmaX:
                                                                              2.0,
                                                                          sigmaY:
                                                                              2.0),
                                                                      child:
                                                                          Container(
                                                                        color:
                                                                            colorWhite,
                                                                      )),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(

                                                          child: Center(
                                                            child: homeController
                                                                        .homeWaglStoryItems[
                                                                            index]
                                                                        .productId!
                                                                        .productPic ==
                                                                    null
                                                                ? Image.asset(
                                                                    "assets/icons/no_image.png",
                                                                    width: 6 *
                                                                        SizeConfig
                                                                            .widthMultiplier,
                                                                    height: 2 *
                                                                        SizeConfig
                                                                            .heightMultiplier,
                                                                    // color: colorBlack,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  )
                                                                : Image.network(
                                                                    homeController
                                                                        .homeWaglStoryItems[
                                                                            index]
                                                                        .productId!
                                                                        .productPic!
                                                                        .url!,
                                                                    width: 5 *
                                                                        SizeConfig
                                                                            .widthMultiplier,
                                                                    height: 4 *
                                                                        SizeConfig
                                                                            .heightMultiplier,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                            top: 0,
                                                            right: 0,
                                                            child: Container(
                                                              height: 2.2 *
                                                                  SizeConfig
                                                                      .heightMultiplier,
                                                              width: 5 *
                                                                  SizeConfig
                                                                      .widthMultiplier,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color:
                                                                      colorBlack),
                                                              child: Center(
                                                                  child: CustText(
                                                                      name:
                                                                          "${homeController.homeWaglStoryItems[index].productId!.waglCount}",
                                                                      size: 1.4,
                                                                      colors:
                                                                          colorWhite,
                                                                      fontWeightName:
                                                                          FontWeight
                                                                              .w800)),
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          GestureDetector(
                                            onTap: () {
                                              homeController.reportDetails();
                                              homeController.clearReportData();
                                              showModalBottomSheet<void>(
                                                context: context,
                                                backgroundColor:
                                                    backgroundDialog,
                                                builder:
                                                    (BuildContext context) {
                                                  return SizedBox(
                                                    height: 32 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    width: 100 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    child: Stack(
                                                      children: <Widget>[
                                                        Positioned(
                                                            top: 0,
                                                            child: Image.asset(
                                                              "assets/background/dailog_bg.png",
                                                              width: 100 *
                                                                  SizeConfig
                                                                      .widthMultiplier,
                                                              height: 10 *
                                                                  SizeConfig
                                                                      .heightMultiplier,
                                                              fit: BoxFit.fill,
                                                            )),
                                                        Positioned(
                                                          top: 3 *
                                                              SizeConfig
                                                                  .heightMultiplier,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  color:
                                                                      colorBlack2Light,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            50),
                                                                  ),
                                                                ),
                                                                height: 0.7 *
                                                                    SizeConfig
                                                                        .heightMultiplier,
                                                                width: 12.5 *
                                                                    SizeConfig
                                                                        .widthMultiplier,
                                                              ),
                                                              SizedBox(
                                                                height: 6 *
                                                                    SizeConfig
                                                                        .widthMultiplier,
                                                              ),
                                                              CustText(
                                                                name:
                                                                    "Wagl options",
                                                                size: 2.0,
                                                                colors:
                                                                    colorWhite,
                                                                fontWeightName:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                              SizedBox(
                                                                height: 4 *
                                                                    SizeConfig
                                                                        .widthMultiplier,
                                                              ),
                                                              SizedBox(
                                                                height: 5 *
                                                                    SizeConfig
                                                                        .heightMultiplier,
                                                                width: 100 *
                                                                    SizeConfig
                                                                        .widthMultiplier,
                                                                child: Divider(
                                                                  color:
                                                                      borderColor,
                                                                  indent: 3 *
                                                                      SizeConfig
                                                                          .widthMultiplier,
                                                                  endIndent: 3 *
                                                                      SizeConfig
                                                                          .widthMultiplier,
                                                                  thickness: 1,
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  if (personStories
                                                                          .userId !=
                                                                      ApiClient
                                                                          .box
                                                                          .read(
                                                                              "userId")) {
                                                                    print(
                                                                        "here is the wagl screen ");
                                                                    Navigator.pop(
                                                                        context);
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
                                                                              personStories.waglId!,
                                                                              personStories.userId!,
                                                                              false);
                                                                        });
                                                                  } else {
                                                                    // Get.back();
                                                                    Navigator.pop(
                                                                        context);
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return Container(
                                                                          /* height: 25 * SizeConfig.heightMultiplier,
                                                                          width: 100 * SizeConfig.widthMultiplier,
                                                                          color: colorWhite,*/
                                                                          child: Dialog(
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                              ),
                                                                              backgroundColor: Colors.transparent,
                                                                              child: Container(
                                                                                decoration: BoxDecoration(color: colorBlack, borderRadius: BorderRadius.all(Radius.circular(16))),
                                                                                height: 28 * SizeConfig.heightMultiplier,
                                                                                width: 100 * SizeConfig.widthMultiplier,
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Stack(children: [
                                                                                    Positioned(
                                                                                      right: 2 * SizeConfig.widthMultiplier,
                                                                                      top: 1 * SizeConfig.heightMultiplier,
                                                                                      child: GestureDetector(
                                                                                        onTap: () {
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: Container(
                                                                                          width: 9 * SizeConfig.widthMultiplier,
                                                                                          height: 5 * SizeConfig.heightMultiplier,
                                                                                          decoration: const BoxDecoration(
                                                                                            shape: BoxShape.circle,
                                                                                            color: colorGreyDark,
                                                                                          ),
                                                                                          child: Icon(Icons.close_rounded, color: Colors.white, size: 5 * SizeConfig.imageSizeMultiplier),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Column(
                                                                                      children: [
                                                                                        SizedBox(
                                                                                          height: 3 * SizeConfig.heightMultiplier,
                                                                                        ),
                                                                                        CustText(name: "Delete wagl", size: 1.8, colors: colorWhite, fontWeightName: FontWeight.w600),
                                                                                        SizedBox(
                                                                                          height: 5 * SizeConfig.heightMultiplier,
                                                                                          width: 100 * SizeConfig.widthMultiplier,
                                                                                          child: Divider(
                                                                                            height: 3 * SizeConfig.heightMultiplier,
                                                                                            color: borderColor,
                                                                                            endIndent: 2 * SizeConfig.widthMultiplier,
                                                                                            thickness: 1,
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(width: 60 * SizeConfig.widthMultiplier, child: CustText(name: "Are you sure you want to delete your Wagl?", size: 1.6, colors: colorWhite, fontWeightName: FontWeight.w500, textAlign: TextAlign.center)),
                                                                                        Spacer(),
                                                                                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                                                          GestureDetector(
                                                                                            onTap: () async {
                                                                                              Navigator.pop(context);
                                                                                              // Navigator.pop(context1);
                                                                                              homeController.deleteWagl(personStories.waglId!, false, false);
                                                                                              homeController.homeWaglStoryItems.removeAt(index);
                                                                                              // homeController.getHomeFeedWagl();

                                                                                              showDialog(
                                                                                                context: context,
                                                                                                builder: (BuildContext context) {
                                                                                                  return Dialog(
                                                                                                    backgroundColor: Colors.transparent,
                                                                                                    child: Stack(
                                                                                                      alignment: Alignment.topCenter,
                                                                                                      children: [
                                                                                                        SvgPicture.asset(
                                                                                                          "assets/icons/cust_dialog.svg",
                                                                                                          fit: BoxFit.fill,
                                                                                                          // color: Colors.transparent,
                                                                                                          height: 25 * SizeConfig.heightMultiplier,
                                                                                                          width: 100 * SizeConfig.widthMultiplier,
                                                                                                        ),
                                                                                                        Container(
                                                                                                            height: 23 * SizeConfig.heightMultiplier,
                                                                                                            width: 100 * SizeConfig.widthMultiplier,
                                                                                                            child: Column(
                                                                                                              children: [
                                                                                                                SizedBox(
                                                                                                                  height: 10 * SizeConfig.heightMultiplier,
                                                                                                                ),
                                                                                                                CustText(name: "Your Wagl was deleted successfully", size: 1.8, colors: colorWhite, fontWeightName: FontWeight.w600),
                                                                                                                Spacer(),
                                                                                                                Padding(
                                                                                                                  padding: EdgeInsets.symmetric(horizontal: 2 * SizeConfig.widthMultiplier),
                                                                                                                  child: GestureDetector(
                                                                                                                    onTap: () {
                                                                                                                      Navigator.pop(context);
                                                                                                                    },
                                                                                                                    child: Container(
                                                                                                                      height: 6 * SizeConfig.heightMultiplier,
                                                                                                                      width: 100 * SizeConfig.widthMultiplier,
                                                                                                                      decoration: BoxDecoration(color: colorBlack_2, border: Border.all(width: 1, color: colorBlack_2), borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                                                      child: Center(child: CustText(name: "Okay", fontWeightName: FontWeight.w500, size: 1.6, colors: colorWhite)),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            )),
                                                                                                      ],
                                                                                                    ),
                                                                                                  );
                                                                                                },
                                                                                              );
                                                                                            },
                                                                                            child: Container(
                                                                                              height: 6 * SizeConfig.heightMultiplier,
                                                                                              width: 36 * SizeConfig.widthMultiplier,
                                                                                              decoration: BoxDecoration(color: colorBlack, border: Border.all(width: 1, color: colorPrimary), borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                              child: Center(child: CustText(name: "Yes, delete", fontWeightName: FontWeight.w500, size: 1.6, colors: colorWhite)),
                                                                                            ),
                                                                                          ),
                                                                                          GestureDetector(
                                                                                            onTap: () {
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                            child: Container(
                                                                                              height: 6 * SizeConfig.heightMultiplier,
                                                                                              width: 36 * SizeConfig.widthMultiplier,
                                                                                              decoration: BoxDecoration(color: colorBlack_2, border: Border.all(width: 1, color: colorBlack_2), borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                              child: Center(child: CustText(name: "No, cancel", fontWeightName: FontWeight.w500, size: 1.6, colors: colorWhite)),
                                                                                            ),
                                                                                          )
                                                                                        ]),
                                                                                        SizedBox(
                                                                                          height: 2 * SizeConfig.heightMultiplier,
                                                                                        )
                                                                                      ],
                                                                                    )
                                                                                  ]),
                                                                                ),
                                                                              )),
                                                                        );
                                                                      },
                                                                    );
                                                                  }
                                                                },
                                                                child: personStories
                                                                            .userId ==
                                                                        ApiClient
                                                                            .box
                                                                            .read("userId")
                                                                    ? Column(
                                                                        children: [
                                                                          GestureDetector(
                                                                            /* onTap:
                                                                                () async {
                                                                              showDialog(context: context, builder: (BuildContext context) => CustomLoadingPopup());
                                                                              var createWaglController = Get.put(CreateWaglController());
                                                                              createWaglController.clearData();
                                                                              await createWaglController.getGoodTag();
                                                                              createWaglController.getProducts();
                                                                              await createWaglController.getCategoryTag();
                                                                              Navigator.pop(context);
                                                                              await createWaglController.getEditWaglDataHome(homeController.homeWaglStoryItems[index]);
                                                                              Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (_) => CreateWaglView(
                                                                                          isEdit: true,
                                                                                        )),
                                                                              );
                                                                              // Get.to(()=>CreateWaglView(isEdit: true,)) ;
                                                                            },*/
                                                                            onTap:
                                                                                () async {
                                                                              // Store a reference to the dialog's context
                                                                              BuildContext? dialogContext;

                                                                              // Show the loading dialog
                                                                              showDialog(
                                                                                context: context,
                                                                                barrierDismissible: false,
                                                                                // Prevent accidental dismissal
                                                                                builder: (BuildContext context) {
                                                                                  dialogContext = context; // Save dialog context for dismissal
                                                                                  return CustomLoadingPopup();
                                                                                },
                                                                              );

                                                                              try {
                                                                                // Initialize the controller and clear data
                                                                                var createWaglController = Get.put(CreateWaglController());
                                                                                createWaglController.clearData();

                                                                                // Perform async operations
                                                                                await createWaglController.getGoodTag();
                                                                                createWaglController.getProducts();
                                                                                await createWaglController.getCategoryTag();
                                                                              var result =await createWaglController.getEditWaglDataHome(
                                                                                  homeController.homeWaglStoryItems[index],
                                                                                );
                                                                                Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (_) => CreateWaglView(
                                                                                      isEdit: true,
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              } catch (e) {
                                                                                print("Error during operation:SS: $e");
                                                                              } finally {
                                                                                // Dismiss the loading dialog
                                                                                if (dialogContext != null && Navigator.canPop(dialogContext!)) {
                                                                                  Navigator.pop(dialogContext!);
                                                                                }
                                                                              }
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              width: 90 * SizeConfig.widthMultiplier,
                                                                              child: Container(
                                                                                  width: double.maxFinite,
                                                                                  height: 6 * SizeConfig.heightMultiplier,
                                                                                  decoration: BoxDecoration(
                                                                                    color: colorBlack_2,
                                                                                    borderRadius: BorderRadius.all(Radius.circular(
                                                                                      1.5 * SizeConfig.imageSizeMultiplier,
                                                                                    )),
                                                                                    shape: BoxShape.rectangle,
                                                                                  ),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: EdgeInsets.only(left: 5.0 * SizeConfig.widthMultiplier),
                                                                                        child: CustText(
                                                                                          name: "Edit",
                                                                                          size: 1.8,
                                                                                          fontWeightName: FontWeight.w800,
                                                                                          colors: colorWhite,
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsets.all(4 * SizeConfig.widthMultiplier),
                                                                                        child: Image.asset(
                                                                                          "assets/icons/edit_icon_logo.png",
                                                                                          height: 5 * SizeConfig.heightMultiplier,
                                                                                          width: 9 * SizeConfig.widthMultiplier,
                                                                                          fit: BoxFit.contain,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  )),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                1 * SizeConfig.heightMultiplier,
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                90 * SizeConfig.widthMultiplier,
                                                                            child: Container(
                                                                                width: double.maxFinite,
                                                                                height: 6 * SizeConfig.heightMultiplier,
                                                                                decoration: BoxDecoration(
                                                                                  color: colorBlack_2,
                                                                                  borderRadius: BorderRadius.all(Radius.circular(
                                                                                    1.5 * SizeConfig.imageSizeMultiplier,
                                                                                  )),
                                                                                  shape: BoxShape.rectangle,
                                                                                ),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: EdgeInsets.only(left: 5.0 * SizeConfig.widthMultiplier),
                                                                                      child: CustText(
                                                                                        name: "Delete",
                                                                                        size: 1.8,
                                                                                        fontWeightName: FontWeight.w800,
                                                                                        colors: colorWhite,
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.all(3 * SizeConfig.widthMultiplier),
                                                                                      child: Image.asset(
                                                                                        "assets/icons/delete_icon_png.png",
                                                                                        height: 6 * SizeConfig.heightMultiplier,
                                                                                        width: 11 * SizeConfig.widthMultiplier,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                )),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : Container(
                                                                        width: 90 *
                                                                            SizeConfig.widthMultiplier,
                                                                        child: Container(
                                                                            width: double.maxFinite,
                                                                            height: 6 * SizeConfig.heightMultiplier,
                                                                            decoration: BoxDecoration(
                                                                              color: colorBlack_2,
                                                                              borderRadius: BorderRadius.all(Radius.circular(
                                                                                1.5 * SizeConfig.imageSizeMultiplier,
                                                                              )),
                                                                              shape: BoxShape.rectangle,
                                                                            ),
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 5.0 * SizeConfig.widthMultiplier),
                                                                                  child: CustText(
                                                                                    name: "Report",
                                                                                    size: 1.8,
                                                                                    fontWeightName: FontWeight.w800,
                                                                                    colors: colorWhite,
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.all(1.5 * SizeConfig.widthMultiplier),
                                                                                  child: Image.asset(
                                                                                    "assets/icons/flag_icon.png",
                                                                                    height: 8 * SizeConfig.heightMultiplier,
                                                                                    width: 11 * SizeConfig.widthMultiplier,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )),
                                                                      ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              width: 10*SizeConfig.widthMultiplier,
                                              height: 3*SizeConfig.heightMultiplier,
                                              color: Colors.transparent,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 1 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    height: 1 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Container(
                                                    width: 1 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    height: 1 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Container(
                                                    width: 1 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    height: 1 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ]),
                                  ),
                                ),
                              ],
                            );
                          }),
                )),
      ),
    );
  }

  Widget buildCategoriesTag(InterestedCategory tag, context) {
    return GestureDetector(
      onTap: () async {
        print("here is the CategoryData ");

        BuildContext? dialogContext;

        // Show the loading dialog
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent accidental dismissal
          builder: (BuildContext context) {
            dialogContext = context; // Save dialog context for later dismissal
            return CustomLoadingPopup();
          },
        );
        try {
          var discoverController = Get.put(DiscoverController());
          var result1 = await discoverController.getAllCategory();
          var result2 = await discoverController.getCategoryData(tag.id);
          var result3 = await discoverController.getCategoryWagls(tag.id);
          discoverController.updateImageSize(false);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CategoriesWaglView(
                      categoriesData: discoverController.categoriesItemSearched,
                      categoryIndex: 0,
                      categoryWagls: discoverController.searchCategoryWagls,
                      // id:result.id,
                    )),
          );
        } catch (e) {
          print("Error during operation: $e");
        } finally {
          // Dismiss the loading dialog
          if (dialogContext != null && Navigator.canPop(dialogContext!)) {
            Navigator.pop(dialogContext!);
          }
        }
        /* Get.to(() => CategoriesWaglView(
              categoriesData: discoverController.categoriesItemSearched,
              categoryIndex: 0,
              categoryWagls: discoverController.searchCategoryWagls,
              // id:result.id,
            ));*/
      },
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: 1 * SizeConfig.widthMultiplier),
        decoration: BoxDecoration(
          color: borderColor,
          borderRadius: BorderRadius.all(Radius.circular(
            5.5 * SizeConfig.imageSizeMultiplier,
          )),
          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 1.0 * SizeConfig.heightMultiplier,
              horizontal: 3 * SizeConfig.widthMultiplier),
          child: Center(
            child: CustText(
              name: tag.categoryName!.toUpperCase(),
              size: 1.4,
              colors: colorWhite,
              fontWeightName: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGoodTags(int index, GoodTag tag, context) {
    return GestureDetector(
      /*onTap: () async {
        print("here is the tag ${tag.id}");
        showDialog(
            context: context,
            builder: (BuildContext context) => CustomLoadingPopup());
        var discoverController = Get.put(DiscoverController());
        await discoverController.getGoodTagWagls(tag.id);
        homeController.updateStoryIndex(0);
        homeController.update();
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => HomeView(
                    waglData: discoverController.goodTagWaglItems,
                    waglIndex: 0,
                    isDiscover: false,
                    isSaved: false,
                  )),
        );

      },*/
        onTap: () async {
          // Store a reference to the dialog's context
          BuildContext? dialogContext;

          // Show the loading dialog
          showDialog(
            context: context,
            barrierDismissible: false, // Prevent accidental dismissal
            builder: (BuildContext context) {
              dialogContext = context; // Save dialog context for later dismissal
              return CustomLoadingPopup();
            },
          );

          try {
            print("here is the tag ${tag.id}");
            var discoverController = Get.put(DiscoverController());

            // Perform async operations
            await discoverController.getGoodTagWagls(tag.id);
            homeController.updateStoryIndex(0);
            homeController.update();

            // Navigate to the next screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WaglScreen(
                  waglData: discoverController.goodTagWaglItems,
                  waglIndex: 0,
                  isDiscover: false,
                  isSaved: false,

                ),
              ),
            );
          } catch (e) {
            print("Error during operation: $e");
          } finally {
            // Dismiss the loading dialog
            if (dialogContext != null && Navigator.canPop(dialogContext!)) {
              Navigator.pop(dialogContext!);
            }
          }
        },
        child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: 1 * SizeConfig.widthMultiplier),
        decoration: BoxDecoration(
          border: Border.all(
              color: colorBlack2Light, width: 0.3 * SizeConfig.widthMultiplier),
          borderRadius: BorderRadius.all(Radius.circular(
            5.5 * SizeConfig.imageSizeMultiplier,
          )),
          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                  height: 10 * SizeConfig.heightMultiplier,
                  child: /*tag.image!.ext == ".svg"
                    ? */
                      SvgPicture.network(
                    tag.image!.url!,
                    width: 4 * SizeConfig.widthMultiplier,
                    height: 3 * SizeConfig.heightMultiplier,
                    color: colorPrimary,
                    fit: BoxFit.contain,
                  )
                  /*: Image.network(
                  // homeController.wagls![index].attributes!.goodTags!.data![tagIndex].attributes!.image!.data!.attributes!.url,
                  tag.image!.url!,
                  width: 5 * SizeConfig.widthMultiplier,
                  height: 3 * SizeConfig.heightMultiplier,
                ),*/
                  ),
              SizedBox(
                width: 2 * SizeConfig.widthMultiplier,
              ),
              Center(
                child: CustText(
                  name: tag.name,
                  size: 1.4,
                  colors: colorWhite,
                  fontWeightName: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 2 * SizeConfig.widthMultiplier,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
