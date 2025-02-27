import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/custom_widget/create_post_wagl.dart';
import 'package:wagl/custom_widget/cust_back_button.dart';
import 'package:wagl/discover/discover_controller.dart';
import 'package:wagl/discover/profile_search_view.dart';
import 'package:wagl/discover/wagl_categories_view.dart';
import 'package:wagl/util/SizeConfig.dart';
import 'package:wagl/discover/search_model.dart';
import '../custom_widget/cust_text.dart';
import '../custom_widget/cust_text_field.dart';
import '../custom_widget/custom_loading_popup.dart';
import '../home/home_page.dart';
import '../home/main_screen.dart';
import '../home/waglStoryView.dart';
import '../util/ApiClient.dart';

class TabSearchView extends StatelessWidget {
  var discoverController = Get.put(DiscoverController());

  TabSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<DiscoverController>(
          init: DiscoverController(),
          builder: (controller) {
            return Scaffold(
              backgroundColor: colorBlack,
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustBackButton(),
                        SizedBox(
                          width: 1.5 * SizeConfig.widthMultiplier,
                        ),
                        TextFieldWidget(
                          labelText: "",
                          hintText: "Search Wagls, accounts, and more",
                          textEditingController:
                              discoverController.searchTextController,
                          widthSize: 87,
                          isObscureText: false,
                          onChange: (value) {
                            // discoverController.search(value);
                            discoverController.search(value);
                          },

                          suffixIcon: GestureDetector(
                            onTap: () {
                              discoverController.clearData();
                              // Get.back();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(
                                  2 * SizeConfig.widthMultiplier),
                              child: Image.asset(
                                  discoverController
                                          .searchTextController.text.isEmpty
                                      ? "assets/icons/search_icon.png"
                                      : "assets/icons/close_icon.png",
                                  fit: BoxFit.contain,
                                  color: colorWhite),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1*SizeConfig.heightMultiplier,),
                    DefaultTabController(
                      length: 4,
                      child: Container(
                        height: 80 * SizeConfig.heightMultiplier,
                        child: Column(
                          children: [
                            TabBar  (
                              indicator: UnderlineTabIndicator(
                                borderSide: BorderSide(
                                    color: Colors.white, width: 1.0),
                              ),
                              isScrollable: true,
                              labelPadding: EdgeInsets.symmetric(
                                  horizontal:
                                      2.5 * SizeConfig.heightMultiplier),
                              automaticIndicatorColorAdjustment: true,
                              tabs: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          1.5 * SizeConfig.heightMultiplier),
                                  child: CustText(
                                      name: "Wagls",
                                      size: 1.4,
                                      colors: colorWhite,
                                      fontWeightName: FontWeight.w500),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          1.5 * SizeConfig.heightMultiplier),
                                  child: CustText(
                                      name: "Account",
                                      size: 1.4,
                                      colors: colorWhite,
                                      fontWeightName: FontWeight.w500),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          1.5 * SizeConfig.heightMultiplier),
                                  child: CustText(
                                      name: "Good tags",
                                      size: 1.4,
                                      colors: colorWhite,
                                      fontWeightName: FontWeight.w500),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          1.5 * SizeConfig.heightMultiplier),
                                  child: CustText(
                                      name: "Category tags",
                                      size: 1.4,
                                      colors: colorWhite,
                                      fontWeightName: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(height: 1*SizeConfig.heightMultiplier,),
                            CustCreateWaglPost(
                                onSelected: () async {
                                  {
                                    homeController
                                        .currentSelectedMedia =
                                    null;
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext
                                        context) =>
                                            CustomLoadingPopup());
                                    var images =
                                    await homeController
                                        .pickImages();
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context);
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
                                          StoryDesignerScreen(
                                              mediaPath:
                                              homeController
                                                  .currentSelectedMedia!,
                                              index:
                                              0),
                                        ))
                                        : ();
                                  }
                                }, isDiscard: (value) {
                              discoverController
                                  .updateDiscardValue(value);
                              discoverController.updateImageSize(true);
                            },
                            ),
                            Expanded(
                              child: TabBarView(children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          2.0 * SizeConfig.heightMultiplier),
                                  child: CustText(
                                      name: "",
                                      size: 1.5,
                                      colors: colorWhite,
                                      fontWeightName: FontWeight.w500),
                                ),
                                ListView.builder(
                                  itemCount:
                                      discoverController.userList.length,
                                  itemBuilder: (context, index) {
                                    print(
                                        "here is the length ${discoverController.userList.length}");
                                    var result =
                                        discoverController.userList[index];
                                    return GestureDetector(
                                      onTap: () async {
                                        if (result.id !=
                                            ApiClient.box.read("userId")) {
                                          discoverController.clearData();
                                          int userId = result.id;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) =>  ProfileSearchView(id: userId)),
                                          );
                                         /* Get.to(() =>
                                              ProfileSearchView(id: userId));*/
                                          profileController
                                              .getUsersWagl(userId);
                                          discoverController
                                              .getProfileDetails(userId);
                                          await discoverController
                                              .getUsersWagl(userId);
                                        } else {
                                          homeController.onBottomOptionTapped(4);
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 1 *
                                                SizeConfig.heightMultiplier,
                                          ),
                                          Container(
                                            color: Colors.transparent,
                                            child: Row(
                                              children: [
                                                result.attributes
                                                            .profilePic !=
                                                        null
                                                    ? CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(result
                                                                .attributes
                                                                .profilePic!
                                                                .url), // Replace with actual image
                                                      )
                                                    : const CircleAvatar(
                                                        foregroundImage:
                                                            AssetImage(
                                                                "assets/images/no_profile.png")),
                                                Container(
                                                  width: 2.5 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                ),
                                                Container(
                                                  width: 82 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          CustText(
                                                              name: result
                                                                  .attributes
                                                                  .username,
                                                              size: 1.4,
                                                              colors:
                                                                  colorWhite,
                                                              fontWeightName:
                                                                  FontWeight
                                                                      .w600),
                                                          Row(
                                                            children: [
                                                              CustText(
                                                                  name:
                                                                      "${result.attributes.firstName} ${result.attributes.lastName}",
                                                                  size: 1.4,
                                                                  colors:
                                                                      colorGreyLight2,
                                                                  fontWeightName:
                                                                      FontWeight
                                                                          .w600),
                                                              SizedBox(
                                                                  width: 2 *
                                                                      SizeConfig
                                                                          .widthMultiplier),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            8.0),
                                                                child:
                                                                    Container(
                                                                  width: 5.0,
                                                                  height: 5.0,
                                                                  decoration: const BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color:
                                                                          colorGreyLight2),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 2 *
                                                                      SizeConfig
                                                                          .widthMultiplier),
                                                              CustText(
                                                                  name:
                                                                      "${result.attributes.totalFollowers} followers",
                                                                  size: 1.4,
                                                                  colors:
                                                                      colorGreyLight2,
                                                                  fontWeightName:
                                                                      FontWeight
                                                                          .w600),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      result.id ==
                                                              ApiClient.box
                                                                  .read(
                                                                      "userId")
                                                          ? Container()
                                                          : GestureDetector(
                                                              onTap: () {
                                                                discoverController.updateFollows(
                                                                    !result
                                                                        .attributes
                                                                        .following,
                                                                    index,
                                                                    result);
                                                              },
                                                              child:
                                                                  Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: result
                                                                          .attributes
                                                                          .following
                                                                      ? colorBlack
                                                                      : colorBlack_2,
                                                                  border: Border.all(
                                                                      color: result.attributes.following
                                                                          ? colorBlack_2
                                                                          : colorBlack_2,
                                                                      width: 0.25 *
                                                                          SizeConfig.widthMultiplier),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
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
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            3.0 * SizeConfig.widthMultiplier),
                                                                    child: CustText(
                                                                        name: result.attributes.following
                                                                            // name: discoverController.isFollows
                                                                            ? "Unfollow"
                                                                            : "Follow",
                                                                        size: 1.6,
                                                                        colors: result.attributes.following ? colorWhite : colorPrimary,
                                                                        fontWeightName: FontWeight.w800),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 1 *
                                                SizeConfig.heightMultiplier,
                                          ),
                                          Divider(
                                            color: borderColor,
                                            // indent: 2 * SizeConfig.widthMultiplier,
                                            // endIndent: 2 * SizeConfig.widthMultiplier,
                                            thickness: 1,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                ListView.builder(
                                    itemCount:
                                        discoverController.goodTagList.length,
                                    itemBuilder: (context, index) {
                                      print(
                                          "here is the length ${discoverController.searchResults.length}");
                                      var result =
                                          controller.goodTagList[index];

                                      return GestureDetector(
                                        onTap: () async {
                                          print(
                                              "here is thhe  iD ${result.id}");
                                          await discoverController
                                              .getGoodTagWagls(result.id);
                                          homeController.updateStoryIndex(0);
                                          homeController.update();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) =>  WaglScreen(
                                              waglData: discoverController
                                                  .goodTagWaglItems,
                                              waglIndex: 0,
                                              isDiscover: true,isSaved: false,
                                            )),
                                          );
                                   /*       Get.to(() => HomeView(
                                                waglData: discoverController
                                                    .goodTagWaglItems,
                                                waglIndex: 0,
                                                isDiscover: true,isSaved: false,
                                              ));*/
                                        },
                                        child: Container(
                                          width: 100 *
                                              SizeConfig.widthMultiplier,
                                          color: Colors.transparent,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 1 *
                                                    SizeConfig
                                                        .heightMultiplier,
                                              ),
                                              Container(
                                                height: 4 *
                                                    SizeConfig
                                                        .heightMultiplier,
                                                child: Row(
                                                  children: [
                                                    SvgPicture.network(
                                                        result
                                                            .attributes
                                                            .image!
                                                            .data!
                                                            .attributes
                                                            .url,
                                                        color: colorPrimary),
                                                    SizedBox(
                                                      width: 2.5 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                    ),
                                                    CustText(
                                                        name: result
                                                            .attributes.name,
                                                        size: 1.4,
                                                        colors: colorWhite,
                                                        fontWeightName:
                                                            FontWeight.w500),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 1 *
                                                    SizeConfig
                                                        .heightMultiplier,
                                              ),
                                              Divider(
                                                color: borderColor,
                                                // indent: 2 * SizeConfig.widthMultiplier,
                                                // endIndent: 2 * SizeConfig.widthMultiplier,
                                                thickness: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                ListView.builder(
                                  itemCount: discoverController
                                      .categoriesList.length,
                                  itemBuilder: (context, index) {
                                    print(
                                        "here is the length ${discoverController.categoriesList.length}");
                                    var result =
                                        controller.categoriesList[index];

                                    return GestureDetector(
                                      onTap: () async {
                                        print("here is the CategoryData ");
                                        var result1 = await discoverController
                                            .getAllCategory();
                                        var result2 = await discoverController
                                            .getCategoryData(result.id);
                                        var result3 = await discoverController
                                            .getCategoryWagls(result.id);
                                        discoverController
                                            .updateImageSize(false);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => CategoriesWaglView(
                                            categoriesData: discoverController
                                                .categoriesItemSearched,
                                            categoryIndex: 0,
                                            categoryWagls: discoverController
                                                .searchCategoryWagls,
                                            // id:result.id,
                                          ),),
                                        );
                                      /*  Get.to(
                                          () => CategoriesWaglView(
                                            categoriesData: discoverController
                                                .categoriesItemSearched,
                                            categoryIndex: 0,
                                            categoryWagls: discoverController
                                                .searchCategoryWagls,
                                            // id:result.id,
                                          ),
                                        );*/
                                      },
                                      child: Container(
                                        width:
                                            100 * SizeConfig.widthMultiplier,
                                        color: Colors.transparent,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 1 *
                                                  SizeConfig.heightMultiplier,
                                            ),
                                            Container(
                                              height: 4 *
                                                  SizeConfig.heightMultiplier,
                                              // color: Colors.red,
                                              child: Row(
                                                children: [
                                                  Image.network(
                                                      result
                                                                  .attributes
                                                                  .categoryIcon!
                                                                  .data !=
                                                              null
                                                          ? result
                                                              .attributes
                                                              .categoryIcon!
                                                              .data!
                                                              .attributes
                                                              .url
                                                          : "",
                                                      height: 4 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      width: 8 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                      fit: BoxFit.fill),
                                                  SizedBox(
                                                    width: 2.5 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                  ),
                                                  CustText(
                                                      name: result.attributes
                                                          .categoryName,
                                                      size: 1.4,
                                                      colors: colorWhite,
                                                      fontWeightName:
                                                          FontWeight.w500),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 1 *
                                                  SizeConfig.heightMultiplier,
                                            ),
                                            Divider(
                                              color: borderColor,
                                              // indent: 2 * SizeConfig.widthMultiplier,
                                              // endIndent: 2 * SizeConfig.widthMultiplier,
                                              thickness: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ]),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _buildCategoryTile(String categoryName, String url) {
    return Column(
      children: [
        SizedBox(
          height: 1 * SizeConfig.heightMultiplier,
        ),
        Container(
          height: 4 * SizeConfig.heightMultiplier,
          // color: Colors.red,
          child: Row(
            children: [
              Image.network(url,
                  height: 4 * SizeConfig.heightMultiplier,
                  width: 8 * SizeConfig.widthMultiplier,
                  fit: BoxFit.fill),
              SizedBox(
                width: 2.5 * SizeConfig.widthMultiplier,
              ),
              CustText(
                  name: categoryName,
                  size: 1.4,
                  colors: colorWhite,
                  fontWeightName: FontWeight.w500),
            ],
          ),
        ),
        SizedBox(
          height: 1 * SizeConfig.heightMultiplier,
        ),
        Divider(
          color: borderColor,
          // indent: 2 * SizeConfig.widthMultiplier,
          // endIndent: 2 * SizeConfig.widthMultiplier,
          thickness: 1,
        ),
      ],
    );
  }

/*  Widget _buildUserTile(SearchUser user, int index,context) {
    return Container(
      width: 100 * SizeConfig.widthMultiplier,
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () async {
          if (user.id != ApiClient.box.read("userId")) {
            discoverController.clearData();
            int userId = user.id;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) =>  ProfileSearchView(id: userId)),
            );
            // Get.to(() => ProfileSearchView(id: userId));
            profileController.getUsersWagl(userId);
            discoverController.getProfileDetails(userId);
            await discoverController.getUsersWagl(userId);
          } else {
            homeController.isOwnProfile = false;
            profileController.updateProfilePage(false);
            homeController.updateProfilePage(false);
            homeController.changeTabIndex(4);
          }
        },
        child: Column(
          children: [
            SizedBox(
              height: 1 * SizeConfig.heightMultiplier,
            ),
            Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  user.attributes.profilePic != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(user.attributes
                              .profilePic!.url), // Replace with actual image
                        )
                      : const CircleAvatar(
                          foregroundImage:
                              AssetImage("assets/images/no_profile.png")),
                  Container(
                    width: 2.5 * SizeConfig.widthMultiplier,
                  ),
                  Container(
                    width: 82 * SizeConfig.widthMultiplier,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustText(
                                name: user.attributes.username,
                                size: 1.4,
                                colors: colorWhite,
                                fontWeightName: FontWeight.w600),
                            Row(
                              children: [
                                CustText(
                                    name:
                                        "${user.attributes.firstName} ${user.attributes.lastName}",
                                    size: 1.4,
                                    colors: colorGreyLight2,
                                    fontWeightName: FontWeight.w600),
                                SizedBox(width: 2 * SizeConfig.widthMultiplier),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Container(
                                    width: 5.0,
                                    height: 5.0,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: colorGreyLight2),
                                  ),
                                ),
                                SizedBox(width: 2 * SizeConfig.widthMultiplier),
                                CustText(
                                    name:
                                        "${user.attributes.totalFollowers} followers",
                                    size: 1.4,
                                    colors: colorGreyLight2,
                                    fontWeightName: FontWeight.w600),
                              ],
                            ),
                          ],
                        ),
                        user.id == ApiClient.box.read("userId")
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  discoverController.updateFollows(
                                      !user.attributes.following, index, user);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: user.attributes.following
                                        ? colorBlack
                                        : colorBlack_2,
                                    border: Border.all(
                                        color: user.attributes.following
                                            ? colorBlack_2
                                            : colorBlack_2,
                                        width:
                                            0.25 * SizeConfig.widthMultiplier),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(
                                      2 * SizeConfig.imageSizeMultiplier,
                                    )),
                                    shape: BoxShape.rectangle,
                                  ),
                                  height: 4 * SizeConfig.heightMultiplier,
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              3.0 * SizeConfig.widthMultiplier),
                                      child: CustText(
                                          name: user.attributes.following
                                              // name: discoverController.isFollows
                                              ? "Unfollow"
                                              : "Follow",
                                          size: 1.6,
                                          colors: user.attributes.following
                                              ? colorWhite
                                              : colorPrimary,
                                          fontWeightName: FontWeight.w800),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 1 * SizeConfig.heightMultiplier,
            ),
            Divider(
              color: borderColor,
              // indent: 2 * SizeConfig.widthMultiplier,
              // endIndent: 2 * SizeConfig.widthMultiplier,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }*/

  Widget _buildGoodTag(String goodTag, String url) {
    return Column(
      children: [
        SizedBox(
          height: 1 * SizeConfig.heightMultiplier,
        ),
        Container(
          height: 4 * SizeConfig.heightMultiplier,
          child: Row(
            children: [
              SvgPicture.network(url, color: colorPrimary),
              SizedBox(
                width: 2.5 * SizeConfig.widthMultiplier,
              ),
              CustText(
                  name: goodTag,
                  size: 1.4,
                  colors: colorWhite,
                  fontWeightName: FontWeight.w500),
            ],
          ),
        ),
        SizedBox(
          height: 1 * SizeConfig.heightMultiplier,
        ),
        Divider(
          color: borderColor,
          // indent: 2 * SizeConfig.widthMultiplier,
          // endIndent: 2 * SizeConfig.widthMultiplier,
          thickness: 1,
        ),
      ],
    );
  }

  Widget _buildSuggestionTile(String suggestion) {
    return GestureDetector(
      onTap: () {
        print("here is the _buildSuggestionTile_buildSuggestionTile ");
        Get.to(() => TabSearchView());
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: 5 * SizeConfig.heightMultiplier,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: colorBlack_2),
                  child: Padding(
                    padding: EdgeInsets.all(3 * SizeConfig.widthMultiplier),
                    child: Image.asset(
                      "assets/icons/search_icon.png",
                    ),
                  )),
              SizedBox(width: 2 * SizeConfig.widthMultiplier),
              Container(
                // height: 7*SizeConfig.heightMultiplier,
                width: 78 * SizeConfig.widthMultiplier,
                child: Row(
                  children: [
                    CustText(
                        name: "Search for",
                        size: 1.5,
                        colors: colorGrey,
                        fontWeightName: FontWeight.w600),
                    CustText(
                        name:
                            " \"${discoverController.searchTextController.text}\"",
                        size: 1.5,
                        colors: c_white,
                        fontWeightName: FontWeight.w600),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
