import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:wagl/create_wagl/create_wagl_controller.dart';
import 'package:wagl/create_wagl/create_wagl_view.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import 'package:wagl/home/home_page.dart';
import 'package:wagl/home/product_wagl_view.dart';
import 'package:wagl/home/report_view.dart';
import 'package:wagl/profile/profile_controller.dart';
import 'package:wagl/util/SizeConfig.dart';
import '../custom_widget/check_internet.dart';
import '../custom_widget/custom_loading_popup.dart';
import '../custom_widget/hexa_outline_widget.dart';
import '../custom_widget/readmore_widget.dart';
import '../discover/discover_controller.dart';
import '../discover/profile_search_view.dart';
import '../discover/wagl_categories_view.dart';
import '../login/login_controller.dart';
import '../util/ApiClient.dart';
import 'all_wagl_model.dart';
import 'comments/comment_view.dart';
import 'home_controller.dart';
import 'home_model.dart';

class WaglScreen extends StatelessWidget {
  List<PersonStories> waglData = [];
  int waglIndex = 0;
  bool isDiscover = false;
  bool isSaved = false;
  int? userId;
  var homeController = Get.put(HomeController());
  final ScrollController _scrollController = ScrollController();

  WaglScreen({
    super.key,
    required this.waglData,
    @required waglIndex,
    required this.isDiscover,
    @required this.userId,
    required this.isSaved,
  });

  @override
  Widget build(BuildContext context) {
    homeController.getLikedWagls();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GetBuilder<HomeController>(
            init: HomeController(),
            builder: (controller) => RefreshIndicator(
                  color: colorPrimary,
                  backgroundColor: colorBlack_2,
                  onRefresh: () async {
                    ConnectionChecker.checkConnection(
                      context: context,
                      onConnected: () async {
                        var discoverController = Get.put(DiscoverController());
                        var profileController = Get.put(ProfileController());
                        if (isDiscover) {
                          homeController.getAllWagls(
                              1, discoverController.selectedUserCategoriesList);
                        } else if (isSaved) {
                          print("here is the saved wagl class");
                          var a = await profileController.getSavedPost();
                          homeController.update();
                        } else if (userId != null) {
                          profileController.getUsersWagl(userId);
                        } else {
                          homeController.getAllWagls(
                              1, profileController.selectedCategoriesList);
                        }
                      },
                    );
                  },
                  child: PageView.builder(
                      controller: homeController.pageViewController,
                      // onPageChanged: homeController.handlePageViewChanged,
                      scrollDirection: Axis.vertical,
                      scrollBehavior: const ScrollBehavior(),
                      onPageChanged: (index) {
                        waglData[storyViewIndex].controller.pause();
                        controller.handlePageViewChanged(
                            index, isDiscover, isSaved, index);
                        for (int i = 0; i < 10; i++) {
                          print(i);
                          print("here is the $index here is the call api");
                          waglData[storyViewIndex].controller.previous();
                        }
                        // waglData[index].controller.pause();
                      },
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: waglData.length,
                      itemBuilder: (itemBuilderContext, index) {
                        final personStories = waglData[index];
                        double screenWidth = 100 * SizeConfig.widthMultiplier;
                        double segmentWidth = (screenWidth -
                            ((personStories.stories.length) *
                                (3 * SizeConfig.widthMultiplier)));
                        segmentWidth =
                            segmentWidth / personStories.stories.length;
                        return Stack(
                          children: [
                            StoryView(
                              indicatorForegroundColor: Colors.white,
                              indicatorColor: Colors.grey,

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
                              onStoryShow: (value) {
                                int index = 0;
                                index = personStories.stories.indexOf(value);
                                homeController.storyViewShowIndex(index);
                              },
                              storyItems: personStories.stories,
                              progressPosition: ProgressPosition.top,
                              repeat: false,
                              /*      onStoryShow: (value,index){
                            print("value of onStoryShow ==> ${value.view} ,,,,, index =$index");
                            if(){
                              print("Videos ");
                            }
                          },*/
                              controller: waglData[index].controller,
                            ),
                            /*      Positioned(
                              top: 0.5*SizeConfig.heightMultiplier,
                              child:

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(personStories.stories.length, (indexSegment) {
                                return Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 1*SizeConfig.widthMultiplier),
                                  child: Container(
                                    width: segmentWidth,
                                    height: 0.3*SizeConfig.heightMultiplier,
                                    decoration: BoxDecoration(
                                      color: indexSegment <= homeController.currentIndexStoryView ? Colors.white : Colors.grey,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                );
                              }),
                            ),),*/
                            Positioned(
                              top: 1 * SizeConfig.heightMultiplier,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 100 * SizeConfig.widthMultiplier,
                                  height: 5 * SizeConfig.heightMultiplier,
                                  color: Colors.transparent,
                                  alignment: Alignment.topLeft,
                                  child: Row(children: [
                                    GestureDetector(
                                      /* onTap: () async {
                                        if (ApiClient.box.read("userId") !=
                                            personStories.userId) {
                                          var profileController =
                                              Get.put(ProfileController());
                                          profileController.getFollowersList();
                                          var result = await profileController
                                              .getUsersWagl(
                                                  personStories.userId!);
                                          profileController.getFollowersList();
                                          print("here ${personStories.userId}");
                                          print("here $index");
                                          profileController.getUsersWagl(
                                              personStories.userId);
                                          var discoverController =
                                              Get.put(DiscoverController());
                                          discoverController.getProfileDetails(
                                              personStories.userId);
                                          await discoverController.getUsersWagl(
                                              personStories.userId);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) =>  ProfileSearchView(
                                                id: personStories.userId!)),
                                          );
                                          // Get.to(() => ProfileSearchView(
                                          //     id: personStories.userId!));
                                          // profilecontroller.userAttributeIndex=index;
                                          // profilecontroller.userAttributeId=personStories.userId;
                                          homeController.isOwnProfile = false;
                                          profileController
                                              .updateProfilePage(false);
                                          homeController
                                              .updateProfilePage(false);
                                          homeController.changeTabIndex(4);
                                          */ /* Get.to(UserProfileView(
                                            userDetails: homeController
                                                .wagls![index]
                                                .attributes!
                                                .userId!
                                                .data!
                                                .attributes,
                                            id: personStories.userId!,
                                          ));*/ /*
                                        }
                                        */ /*    Get.to(()=>VideoPage());*/ /*
                                      },*/
                                      onTap: () async {
                                        if (ApiClient.box.read("userId") !=
                                            personStories.userId) {
                                          /* BuildContext? dialogContext;

                                          // Show the loading dialog
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            // Prevent accidental dismissal
                                            builder: (BuildContext context) {
                                              dialogContext =
                                                  context; // Save dialog context for later dismissal
                                              return CustomLoadingPopup();
                                            },
                                          );*/

                                          try {
                                            var profileController =
                                                Get.put(ProfileController());
                                            var discoverController =
                                                Get.put(DiscoverController());
                                            discoverController.updateLoaders();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    ProfileSearchView(
                                                  id: personStories.userId!,
                                                ),
                                              ),
                                            );
                                            // Fetch and update required data

                                            await profileController
                                                .getFollowersList();
                                            await discoverController
                                                .getProfileDetails(
                                                    personStories.userId);
                                            await discoverController
                                                .getUsersWagl(
                                                    personStories.userId);

                                            // Navigate to the next screen
                                            /* Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    ProfileSearchView(
                                                  id: personStories.userId!,
                                                ),
                                              ),
                                            );
*/
                                            // Update controllers and home state
                                          } catch (e) {
                                            print(
                                                "Error during onTap operation: $e");
                                          }
                                        } else {
                                          homeController
                                              .onBottomOptionTapped(4);
                                          homeController.update();
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            width:
                                                8 * SizeConfig.widthMultiplier,
                                            height:
                                                4 * SizeConfig.heightMultiplier,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: personStories
                                                            .profileImage ==
                                                        null
                                                    ? const AssetImage(
                                                        "assets/images/no_profile.png")
                                                    : NetworkImage(
                                                            "${waglData[index].profileImage}")
                                                        /* : AssetImage("assets/images/no_profile.png")*/
                                                        as ImageProvider,
                                                // Use NetworkImage for network images
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:
                                                3 * SizeConfig.widthMultiplier,
                                          ),
                                          CustText(
                                              name: waglData[index].username,
                                              size: 1.6,
                                              colors: colorWhite,
                                              fontWeightName: FontWeight.w800)
                                        ],
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
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: homeController
                                                        .isProcessing
                                                    ? null
                                                    : () async {
                                                        if (await CheckInternet
                                                            .checkInternet()) {
                                                          if (homeController
                                                              .isProcessing) {
                                                            print(
                                                                "\n\n Processing");
                                                          } else {
                                                            if (isDiscover) {
                                                              var discoverController =
                                                                  Get.put(
                                                                      DiscoverController());

                                                              homeController.updateFollower(
                                                                  index,
                                                                  personStories.userId!,
                                                                  !homeController.checkedFollowedUser(
                                                                      waglData[index].userId!,

                                                                      // .userId!,
                                                                      index),
                                                                  isDiscover,
                                                                  isSaved);
                                                              homeController
                                                                  .getHomeFeedWagl();
                                                            } else if (isSaved) {
                                                              var discoverController =
                                                                  Get.put(
                                                                      DiscoverController());
                                                              homeController.updateFollower(
                                                                  index,
                                                                  personStories.userId!,
                                                                  !homeController.checkedFollowedUser(
                                                                      waglData[index].userId!,
                                                                      // .userId!,
                                                                      index),
                                                                  isDiscover,
                                                                  isSaved);
                                                              homeController
                                                                  .getHomeFeedWagl();
                                                            } else {
                                                              homeController.updateFollower(
                                                                  index,
                                                                  personStories
                                                                      .userId!,
                                                                  !homeController.checkedFollowedUser(
                                                                      homeController
                                                                          .storyItems[
                                                                              index]
                                                                          .userId!,
                                                                      index),
                                                                  isDiscover,
                                                                  isSaved);
                                                            }
                                                          }
                                                        } else {
                                                          var snackdemo =
                                                              SnackBar(
                                                            content: CustText(
                                                                name:
                                                                    "Please check your internet connection",
                                                                size: 1.4,
                                                                colors:
                                                                    colorBlack,
                                                                fontWeightName:
                                                                    FontWeight
                                                                        .w600),
                                                            backgroundColor:
                                                                colorPrimary,
                                                            elevation: 10,
                                                            duration: Duration(
                                                                seconds: 3),
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                            margin:
                                                                EdgeInsets.all(
                                                                    5),
                                                            shape:
                                                                BeveledRectangleBorder(),
                                                          );
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  snackdemo);
                                                        }
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
                                                    shape: BoxShape.rectangle,
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
                                                      child: /*FutureBuilder<bool>(
                                                        future: homeController.getFollowersListGetApi(userId, index),
                                                        builder: (context, snapshot) {
                                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                                            return Center(child: CircularProgressIndicator());
                                                          } else if (snapshot.hasError) {
                                                            return Center(child: Text("Error: ${snapshot.error}"));
                                                          } else if (snapshot.hasData) {
                                                            // Use the boolean result to display appropriate content
                                                            if (snapshot.data!) {
                                                              return Center(child: Text("No Data Available"));
                                                            } else {
                                                              return Center(child: Text("Data is Available"));
                                                            }
                                                          } else {
                                                            return Center(child: Text("Unexpected Error"));
                                                          }
                                                        },
                                                      )*/
                                                          CustText(
                                                              name: homeController
                                                                      .checkedFollowedUser(
                                                                          waglData[index]
                                                                              .userId!,
                                                                          index)
                                                                  ? "Following"
                                                                  : "Follow",
                                                              size: 1.6,
                                                              colors:
                                                                  colorWhite,
                                                              fontWeightName:
                                                                  FontWeight
                                                                      .w800),
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
                                  height: 25 * SizeConfig.heightMultiplier,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 80 * SizeConfig.widthMultiplier,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              1.0 * SizeConfig.widthMultiplier,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (personStories.location !=
                                                    " Add locations" &&
                                                personStories.location!
                                                    .trim()
                                                    .isNotEmpty)
                                              Flexible(
                                                child: Text.rich(
                                                  TextSpan(
                                                    text:
                                                        personStories.location,
                                                    children: [
                                                      if (personStories
                                                              .location!
                                                              .length >
                                                          20) // Limit location text
                                                        TextSpan(
                                                          text: " ...",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            // Highlight for read more
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  maxLines: 1,
                                                  // Display only 1 line
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  // Handle overflow
                                                  style: TextStyle(
                                                    fontSize: 1.2 *
                                                        SizeConfig
                                                            .textMultiplier,
                                                    color: colorWhite,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            if (personStories.location !=
                                                    " Add locations" &&
                                                personStories.location!
                                                    .trim()
                                                    .isNotEmpty)
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 1 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                ),
                                                child: Container(
                                                  width: 1 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  height: 1 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 1 *
                                                    SizeConfig.widthMultiplier,
                                              ),
                                              child: CustText(
                                                name:
                                                    "${personStories.views ?? "0"} views",
                                                fontWeightName: FontWeight.w500,
                                                size: 1.4,
                                                colors: colorWhite,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0.5 * SizeConfig.heightMultiplier,
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
                                            horizontal: 2.0 *
                                                SizeConfig.widthMultiplier),
                                        child: SizedBox(
                                          width:
                                              100 * SizeConfig.widthMultiplier,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 20 *
                                                    SizeConfig.widthMultiplier),
                                            child: ReadMoreText(
                                              trimLines: 2,
                                              text: personStories.description ??
                                                  "",
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: colorBlack,
                                      height: 1 * SizeConfig.heightMultiplier,
                                    ),
                                    Container(
                                      height: 4 * SizeConfig.heightMultiplier,
                                      color: Colors.black,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              controller: _scrollController,
                                              children: [
                                                ...waglData[index]
                                                    .categoryData
                                                    .map((categoriesTag) =>
                                                        buildCategoriesTag(
                                                            categoriesTag,
                                                            context))
                                                    .toList(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: waglData[index]
                                                              .goodTagData!
                                                              .isNotEmpty ||
                                                          waglData[index]
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
                                                          fit: BoxFit.contain,
                                                          color:
                                                              colorGreyLight2,
                                                        )
                                                      : Container(),
                                                ),
                                                ...waglData[index]
                                                    .goodTagData
                                                    .map((tag) => buildGoodTags(
                                                        index, tag, context))
                                                    .toList(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      color: colorBlack,
                                      height: 2.9 * SizeConfig.heightMultiplier,
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
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: homeController.isProcessing
                                            ? null
                                            : () async {
                                                print(
                                                    "here is the discover HapticFeedback.lightImpact(); $isDiscover");
                                                /*  homeController.updateIsLikeFlag( homeController
                                              .checkedLikedPost(
                                              homeController
                                                  .wagls![index].id));*/
                                                print(
                                                    "\n\n if {consition} \n\n");

                                                await homeController.likeWagl(
                                                    homeController
                                                        .checkedLikedPost(
                                                            waglData[index]
                                                                .waglId),
                                                    waglData[index].waglId,
                                                    index,
                                                    !homeController
                                                        .checkedLikedPost(
                                                            waglData[index]
                                                                .waglId),
                                                    isDiscover,
                                                    isSaved);
                                                print(
                                                    "object${homeController.checkedLikedPost(waglData[index].liked)}");
                                              },
                                        child: HezaOutline(
                                          iconPath: homeController
                                                  .checkedLikedPost(
                                                      waglData[index].waglId)
                                              ? "assets/icons/like_icon.png"
                                              : "assets/icons/unlike_icon.png",
                                          /* iconPath: homeController
                                                  .storyItems[index].liked
                                              ? "assets/icons/like_icon.png"
                                              : "assets/icons/unlike_icon.png",*/
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            0.5 * SizeConfig.heightMultiplier,
                                      ),
                                      CustText(
                                        name: waglData[index]
                                            .likes
                                            .toString() /*"${homeController.incrementStringNumber(homeController
                                            .storyItems[index].likes,homeController
                                            .storyItems[index].liked)}"*/
                                        ,
                                        size: 1.6,
                                        colors: colorWhite,
                                        fontWeightName: FontWeight.w700,
                                      ),
                                      SizedBox(
                                        height: 1 * SizeConfig.heightMultiplier,
                                      ),
                                      CommentSectionView(
                                        waglId: waglData[index].waglId!,
                                        isHomeScreen: false,
                                        // parentContext: context,
                                      ),
                                      SizedBox(
                                        height:
                                            0.5 * SizeConfig.heightMultiplier,
                                      ),
                                      CustText(
                                        name: personStories.totalComments
                                            .toString(),
                                        size: 1.6,
                                        colors: colorWhite,
                                        fontWeightName: FontWeight.w700,
                                      ),
                                      SizedBox(
                                        height: 1 * SizeConfig.heightMultiplier,
                                      ),
                                      GestureDetector(
                                        onTap: homeController.isProcessing
                                            ? null
                                            : () async {
                                                await homeController.saveWagl(
                                                    homeController
                                                        .checkedSavedPost(
                                                            waglData[index]
                                                                .waglId),
                                                    waglData[index].waglId,
                                                    index,
                                                    !homeController
                                                        .checkedSavedPost(
                                                            waglData[index]
                                                                .waglId),
                                                    isDiscover,
                                                    isSaved);
                                              },
                                        child: HezaOutline(
                                          iconPath: homeController
                                                  .checkedSavedPost(
                                                      waglData[index].waglId)
                                              ? "assets/icons/unsaved_icon.png"
                                              : "assets/icons/saved_icon.png",
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            0.5 * SizeConfig.heightMultiplier,
                                      ),
                                      CustText(
                                        name: "${waglData[index].totalSaved}",
                                        size: 1.6,
                                        colors: colorWhite,
                                        fontWeightName: FontWeight.w700,
                                      ),
                                      SizedBox(
                                        height: 1 * SizeConfig.heightMultiplier,
                                      ),
                                      /*  Image.asset(
                                    "assets/icons/product_icon.png",
                                    width: 11 * SizeConfig.widthMultiplier,
                                    height: 6 * SizeConfig.heightMultiplier,
                                    fit: BoxFit.fill,
                                  ),*/
                                      waglData[index].productId != null
                                          ? GestureDetector(
                                              onTap: () async {
                                                var discoverController =
                                                    Get.put(
                                                        DiscoverController());
                                                if (await CheckInternet
                                                    .checkInternet()) {
                                                  // Store a reference to the dialog's context
                                                  BuildContext? dialogContext;

                                                  // Show a loading dialog
                                                  showDialog(
                                                    context: context,
                                                    // barrierDismissible: false, // Prevent user from dismissing the dialog
                                                    builder:
                                                        (BuildContext context) {
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
                                                      waglData[index]
                                                          .productId!
                                                          .data!
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
                                                          categoryIndex: index,
                                                          productPic:
                                                              waglData[index]
                                                                  .productId!
                                                                  .data!
                                                                  .attributes!
                                                                  .productPic!
                                                                  .data!
                                                                  .attributes!
                                                                  .url,
                                                          productId:
                                                              waglData[index]
                                                                  .productId!
                                                                  .data!
                                                                  .id,
                                                          productName:
                                                              waglData[index]
                                                                  .productId!
                                                                  .data!
                                                                  .attributes!
                                                                  .name,
                                                          productCount:
                                                              waglData[index]
                                                                  .productId!
                                                                  .data!
                                                                  .attributes!
                                                                  .waglCount,
                                                          categoryWagls:
                                                              discoverController
                                                                  .categoryWagls,
                                                        ),
                                                      ),
                                                    );

                                                    // Update controller values after navigation
                                                    discoverController
                                                        .updateDiscardValue(
                                                            false);
                                                    discoverController
                                                        .updateImageSize(false);
                                                  } catch (e) {
                                                    print(
                                                        "Error during operation: $e");
                                                  } finally {
                                                    // Dismiss the loading dialog
                                                    if (dialogContext != null &&
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
                                                            colors: colorWhite,
                                                            fontWeightName:
                                                                FontWeight.w600,
                                                            textAlign:
                                                                TextAlign.start,
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
                                                          colors: colorWhite,
                                                          fontWeightName:
                                                              FontWeight.w900,
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
                                                            colors: colorWhite,
                                                            fontWeightName:
                                                                FontWeight.w600,
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
                                                            colors: colorWhite,
                                                            fontWeightName:
                                                                FontWeight.w600,
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
                                                    SizeConfig.widthMultiplier,
                                                height: 6 *
                                                    SizeConfig.heightMultiplier,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                  "assets/icons/heza_icon.png",
                                                ))),
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    ClipPath(
                                                      clipper: HexagonClipper(),
                                                      child: Container(
                                                        width: 10 *
                                                            SizeConfig
                                                                .widthMultiplier,
                                                        height: 5.5 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                        child: ClipRRect(
                                                          child: BackdropFilter(
                                                              filter: ImageFilter
                                                                  .blur(
                                                                      sigmaX:
                                                                          2.0,
                                                                      sigmaY:
                                                                          2.0),
                                                              child: Container(
                                                                color:
                                                                    colorWhite,
                                                              )),
                                                        ),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: waglData[index]
                                                                  .productId!
                                                                  .data!
                                                                  .attributes!
                                                                  .productPic ==
                                                              null
                                                          ? Image.asset(
                                                              "assets/icons/no_image.png",
                                                              width: 5 *
                                                                  SizeConfig
                                                                      .widthMultiplier,
                                                              height: 2 *
                                                                  SizeConfig
                                                                      .heightMultiplier,
                                                              // color: colorBlack,
                                                              fit: BoxFit.fill,
                                                            )
                                                          : waglData[index]
                                                                      .productId!
                                                                      .data!
                                                                      .attributes!
                                                                      .productPic!
                                                                      .data ==
                                                                  null
                                                              ? Image.asset(
                                                                  "assets/icons/no_image.png",
                                                                  width: 5 *
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
                                                                  waglData[
                                                                          index]
                                                                      .productId!
                                                                      .data!
                                                                      .attributes!
                                                                      .productPic!
                                                                      .data!
                                                                      .attributes!
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
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color:
                                                                      colorBlack),
                                                          child: Center(
                                                              child: CustText(
                                                                  name:
                                                                      "${waglData[index].productId!.data!.attributes!.waglCount}",
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
                                          print(
                                              "here is  the media url ${waglData[index].media}");
                                          print("here is  the media url");
                                          homeController.reportDetails();
                                          homeController.clearReportData();
                                          showModalBottomSheet<void>(
                                            context: context,
                                            backgroundColor: backgroundDialog,
                                            builder: (BuildContext context) {
                                              return SizedBox(
                                                height: 32 *
                                                    SizeConfig.heightMultiplier,
                                                width: 100 *
                                                    SizeConfig.widthMultiplier,
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
                                                                Radius.circular(
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
                                                            colors: colorWhite,
                                                            fontWeightName:
                                                                FontWeight.w800,
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
                                                          personStories
                                                                      .userId ==
                                                                  ApiClient.box
                                                                      .read(
                                                                          "userId")
                                                              ? Column(
                                                                  children: [
                                                                    GestureDetector(
                                                                      /*onTap:
                                                                          () async {
                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            builder: (BuildContext context) =>
                                                                                CustomLoadingPopup());
                                                                        var createWaglController =
                                                                            Get.put(CreateWaglController());
                                                                        createWaglController
                                                                            .clearData();
                                                                        await createWaglController
                                                                            .getGoodTag();
                                                                        createWaglController
                                                                            .getProducts();
                                                                        await createWaglController
                                                                            .getCategoryTag();
                                                                        Navigator.pop(
                                                                            context);
                                                                        print(
                                                                            "here is the medias before ${waglData[index].media}");
                                                                        await createWaglController
                                                                            .getEditWaglData(waglData[index]);
                                                                        Navigator
                                                                            .push(
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
                                                                        BuildContext?
                                                                            dialogContext;

                                                                        // Show the loading dialog
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          barrierDismissible:
                                                                              true,
                                                                          // Prevent accidental dismissal
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            dialogContext =
                                                                                context; // Save the dialog context for dismissal
                                                                            return CustomLoadingPopup();
                                                                          },
                                                                        );

                                                                        try {
                                                                          // Initialize and clear data in the controller
                                                                          var createWaglController =
                                                                              Get.put(CreateWaglController());
                                                                          // print("Here is the medias before:::: ${waglData[index].media!.length}");
                                                                          createWaglController
                                                                              .clearData();

                                                                          // Perform the asynchronous operations
                                                                          await createWaglController
                                                                              .getGoodTag();
                                                                          createWaglController
                                                                              .getProducts(); // Assuming this doesn't need `await`
                                                                          await createWaglController
                                                                              .getCategoryTag();

                                                                          print(
                                                                              "Here is the medias before ${waglData[index].stories}");

                                                                          // Fetch edit wagl data
                                                                          print(
                                                                              "Here is the waglData[index].media!.length before ${waglData[index].media!.length}");
                                                                          var result =
                                                                              await createWaglController.getEditWaglData(waglData[index]);
                                                                          // Navigate to the next screen
                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (_) => CreateWaglView(isEdit: true),
                                                                            ),
                                                                          );
                                                                        } catch (e) {
                                                                          print(
                                                                              "Error during onTap operation: $e");
                                                                        } finally {
                                                                          // Dismiss the loading dialog
                                                                          if (dialogContext != null &&
                                                                              Navigator.canPop(dialogContext!)) {
                                                                            Navigator.pop(dialogContext!);
                                                                          }
                                                                        }
                                                                      },
                                                                      child:
                                                                          Container(
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
                                                                      height: 1 *
                                                                          SizeConfig
                                                                              .heightMultiplier,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        if (personStories.userId !=
                                                                            ApiClient.box.read("userId")) {
                                                                          print(
                                                                              "here is the wagl screen ");
                                                                          Navigator.pop(
                                                                              context);
                                                                          showModalBottomSheet(
                                                                              isScrollControlled: true,
                                                                              context: context,
                                                                              backgroundColor: backgroundDialog,
                                                                              builder: (context) {
                                                                                return ReportSectionView(personStories.waglId!, personStories.userId!, false);
                                                                              });
                                                                        } else {
                                                                          Navigator.pop(
                                                                              context);
                                                                          print(
                                                                              "hrtr is tapped 333333 ");
                                                                          showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
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
                                                                                      decoration: const BoxDecoration(color: colorBlack, borderRadius: BorderRadius.all(Radius.circular(16))),
                                                                                      height: 28 * SizeConfig.heightMultiplier,
                                                                                      width: 100 * SizeConfig.widthMultiplier,
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Stack(children: [
                                                                                          Positioned(
                                                                                            right: 2 * SizeConfig.widthMultiplier,
                                                                                            top: 2 * SizeConfig.heightMultiplier,
                                                                                            child: GestureDetector(
                                                                                              onTap: () {
                                                                                                print("here is the tapped 22222");
                                                                                                Navigator.pop(context);
                                                                                              },
                                                                                              child: Container(
                                                                                                width: 9 * SizeConfig.widthMultiplier,
                                                                                                height: 5 * SizeConfig.heightMultiplier,
                                                                                                decoration: const BoxDecoration(
                                                                                                  shape: BoxShape.circle,
                                                                                                  color: colorGreyDark,
                                                                                                ),
                                                                                                child: Center(child: Icon(Icons.close_rounded, color: Colors.white, size: 4 * SizeConfig.imageSizeMultiplier)),
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
                                                                                              const Spacer(),
                                                                                              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                                                                GestureDetector(
                                                                                                  onTap: () async {
                                                                                                    Navigator.pop(context);

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
                                                                                                                      CustText(name: "Your wagl deleted successfully", size: 1.8, colors: colorWhite, fontWeightName: FontWeight.w600),
                                                                                                                      const Spacer(),
                                                                                                                      Padding(
                                                                                                                        padding: EdgeInsets.symmetric(horizontal: 2 * SizeConfig.widthMultiplier),
                                                                                                                        child: GestureDetector(
                                                                                                                          onTap: () {
                                                                                                                            Navigator.pop(context);
                                                                                                                            if (waglData.isEmpty) {
                                                                                                                              // Navigator.pop(context);
                                                                                                                              homeController.onBottomOptionTapped(4);
                                                                                                                            }
                                                                                                                          },
                                                                                                                          child: Container(
                                                                                                                            height: 6 * SizeConfig.heightMultiplier,
                                                                                                                            width: 100 * SizeConfig.widthMultiplier,
                                                                                                                            decoration: BoxDecoration(color: colorBlack_2, border: Border.all(width: 1, color: colorBlack_2), borderRadius: const BorderRadius.all(Radius.circular(10))),
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
                                                                                                    print("hrtr is tapped 11111 ");
                                                                                                    homeController.deleteWagl(waglData[index].waglId, isDiscover, isSaved);
                                                                                                    waglData.removeAt(index);

                                                                                                    // profileController.getUsersWagl(userId);
                                                                                                  },
                                                                                                  child: Container(
                                                                                                    height: 6 * SizeConfig.heightMultiplier,
                                                                                                    width: 36 * SizeConfig.widthMultiplier,
                                                                                                    decoration: BoxDecoration(color: colorBlack, border: Border.all(width: 1, color: colorPrimary), borderRadius: const BorderRadius.all(Radius.circular(10))),
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
                                                                                                    decoration: BoxDecoration(color: colorBlack_2, border: Border.all(width: 1, color: colorBlack_2), borderRadius: const BorderRadius.all(Radius.circular(10))),
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
                                                                      child:
                                                                          Container(
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
                                                                    ),
                                                                    SizedBox(
                                                                      height: 1 *
                                                                          SizeConfig
                                                                              .heightMultiplier,
                                                                    ),
                                                                  ],
                                                                )
                                                              : Container(
                                                                  width: 90 *
                                                                      SizeConfig
                                                                          .widthMultiplier,
                                                                  child: GestureDetector(
                                                                    onTap: (){
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
                                                                    },
                                                                    child: Container(
                                                                        width: double.maxFinite,
                                                                        height: 6 * SizeConfig.heightMultiplier,
                                                                        decoration: BoxDecoration(
                                                                          color:
                                                                              colorBlack_2,
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(
                                                                            1.5 *
                                                                                SizeConfig.imageSizeMultiplier,
                                                                          )),
                                                                          shape: BoxShape
                                                                              .rectangle,
                                                                        ),
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Padding(
                                                                              padding:
                                                                                  EdgeInsets.only(left: 5.0 * SizeConfig.widthMultiplier),
                                                                              child:
                                                                                  CustText(
                                                                                name: "Report",
                                                                                size: 1.8,
                                                                                fontWeightName: FontWeight.w800,
                                                                                colors: colorWhite,
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding:
                                                                                  EdgeInsets.all(1.5 * SizeConfig.widthMultiplier),
                                                                              child:
                                                                                  Image.asset(
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
                                          width: 30,
                                          height: 40,
                                          color: Colors.transparent,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 1 *
                                                    SizeConfig.widthMultiplier,
                                                height: 1 *
                                                    SizeConfig.heightMultiplier,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white),
                                              ),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Container(
                                                width: 1 *
                                                    SizeConfig.widthMultiplier,
                                                height: 1 *
                                                    SizeConfig.heightMultiplier,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white),
                                              ),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Container(
                                                width: 1 *
                                                    SizeConfig.widthMultiplier,
                                                height: 1 *
                                                    SizeConfig.heightMultiplier,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white),
                                              ),
                                              const SizedBox(
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

  Widget buildCategoriesTag(CategoriesMedia tag, context) {
    return GestureDetector(
      /* onTap: () async {
        print("here is the CategoryData ");
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
        */ /* Get.to(() => CategoriesWaglView(
              categoriesData: discoverController.categoriesItemSearched,
              categoryIndex: 0,
              categoryWagls: discoverController.searchCategoryWagls,
              // id:result.id,
            ));*/ /*
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
          print("here is the CategoryData ");
          var discoverController = Get.put(DiscoverController());

          // Perform async operations
          var result1 = await discoverController.getAllCategory();
          var result2 = await discoverController.getCategoryData(tag.id);
          var result3 = await discoverController.getCategoryWagls(tag.id);

          // Update image size
          discoverController.updateImageSize(false);

          // Navigate to the next screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoriesWaglView(
                categoriesData: discoverController.categoriesItemSearched,
                categoryIndex: 0,
                categoryWagls: discoverController.searchCategoryWagls,
                // id:result.id,
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
              name: tag.attributesMedia!.categoryName!.toUpperCase(),
              size: 1.4,
              colors: colorWhite,
              fontWeightName: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGoodTags(int index, TagData tag, context) {
    return GestureDetector(
      /*  onTap: () async {
        print("here is the tag ${tag.id}");
        showDialog(
            context: context,
            builder: (BuildContext context) => CustomLoadingPopup());

        var discoverController = Get.put(DiscoverController());
        await discoverController.getGoodTagWagls(tag.id);
        homeController.updateStoryIndex(0);
        homeController.update();
        print(
            "here is the length from homescreen ${discoverController.goodTagWaglItems.length}");
        print(
            "here is the discription:: ${discoverController.goodTagWaglItems[0].description}");
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
        */ /*   Get.off(() => HomeView(
              waglData: discoverController.goodTagWaglItems,
              waglIndex: 0,
              isDiscover: false,
              isSaved: false,
            ));*/ /*
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

          // Perform async operations
          var discoverController = Get.put(DiscoverController());
          await discoverController.getGoodTagWagls(tag.id);
          homeController.updateStoryIndex(0);
          homeController.update();

          // Log retrieved data
          print(
              "here is the length from homescreen ${discoverController.goodTagWaglItems.length}");
          print(
              "here is the description:: ${discoverController.goodTagWaglItems[0].description}");

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
                child: tag.attributes!.image!.data!.attributes!.ext == ".svg"
                    ? SvgPicture.network(
                        tag.attributes!.image!.data!.attributes!.url,
                        width: 4 * SizeConfig.widthMultiplier,
                        height: 3 * SizeConfig.heightMultiplier,
                        color: colorPrimary,
                        fit: BoxFit.contain,
                      )
                    : Image.network(
                        // homeController.wagls![index].attributes!.goodTags!.data![tagIndex].attributes!.image!.data!.attributes!.url,
                        tag.attributes!.image!.data!.attributes!.url,
                        width: 5 * SizeConfig.widthMultiplier,
                        height: 3 * SizeConfig.heightMultiplier,
                      ),
              ),
              SizedBox(
                width: 2 * SizeConfig.widthMultiplier,
              ),
              Center(
                child: CustText(
                  name: tag.attributes!.name,
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
