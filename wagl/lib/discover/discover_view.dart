import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wagl/constPath.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/custom_widget/cust_text_field.dart';
import 'package:wagl/discover/profile_search_view.dart';
import 'package:wagl/discover/search_model.dart';
import 'package:wagl/discover/tab_search_view.dart';
import 'package:wagl/discover/wagl_categories_view.dart';
import 'package:wagl/discover/discover_controller.dart';
import 'package:wagl/home/home_page.dart';
import 'package:wagl/home/main_screen.dart';
import '../custom_widget/check_internet.dart';
import '../custom_widget/cust_text.dart';
import '../custom_widget/custom_loading_popup.dart';
import '../custom_widget/hexa_outcolor_widget.dart';
import '../custom_widget/hexa_outline_widget.dart';

// import '../home/home_wagl_model.dart';
import '../util/ApiClient.dart';
import '../util/SizeConfig.dart';
import 'discover_Categories_View.dart';

class DiscoverScreen extends StatelessWidget {
  var discoverController = Get.put(DiscoverController());

  DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Container(
      color: colorBlack,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: colorBlack,
          body: GetBuilder<DiscoverController>(
              init: DiscoverController(),
              builder: (controller) => RefreshIndicator(
                    color: colorPrimary,
                    backgroundColor: colorBlack_2,
                    onRefresh: discoverController.getAllCategory,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.5 * SizeConfig.widthMultiplier),
                      child: Column(
                        children: [
                         
                          TextField(
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: "Gilroy",
                              color: colorWhite,
                              fontWeight: FontWeight.w500,
                              fontSize: 1.6 * SizeConfig.textMultiplier/scaleFactor,
                            ),
                            controller:  discoverController.searchTextController,
                            cursorColor: colorWhite,
                            obscureText: false,
                           // focusNode: ,

                           /* onTapOutside: (vlu) {

                              FocusManager.instance.primaryFocus?.unfocus();
                            },*/
                            onChanged: (value) async {
                              if(await CheckInternet.checkInternet()){
                                discoverController.search(value);
                              }else{
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    backgroundColor: colorBlack_2,

                                    title:  Row(
                                      children: [
                                        Icon(Icons.info_outline),
                                        SizedBox(width: 2*SizeConfig.widthMultiplier,),
                                        CustText(name: 'No internet connection !',size: 1.8,colors: colorWhite,fontWeightName: FontWeight.w600,textAlign: TextAlign.start),
                                      ],
                                    ),
                                    content: Padding(
                                      padding:  EdgeInsets.only(right: 3.0*SizeConfig.widthMultiplier,top: 2*SizeConfig.heightMultiplier),
                                      child: CustText(name: 'Please check your internet connection and try again.',size: 1.5,colors: colorWhite,fontWeightName: FontWeight.w900),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'Cancel'),
                                        child: CustText(name: 'Cancel',size: 1.6,colors: colorWhite,fontWeightName: FontWeight.w600),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'OK'),
                                        child:CustText(name: 'OK',size: 1.6,colors: colorWhite,fontWeightName: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                );
                              }

                            },
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              counterText: "",
                              contentPadding: EdgeInsets.only(
                                top: -0.5 * SizeConfig.widthMultiplier,
                                left: 2 * SizeConfig.widthMultiplier,
                                right: 2 * SizeConfig.widthMultiplier,
                              ),
                              constraints: BoxConstraints.tightFor(
                                  height: 5.5 * SizeConfig.heightMultiplier),
                              fillColor: colorPrimary,
                              /*contentPadding: new EdgeInsets.symmetric(
                            vertical:
                            2 * SizeConfig.widthMultiplier,
                            horizontal:
                            2 * SizeConfig.widthMultiplier),*/
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(2 * SizeConfig.widthMultiplier),
                                borderSide: const BorderSide(
                                  color: colorPrimary,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(2 * SizeConfig.widthMultiplier),
                                borderSide: const BorderSide(
                                  color: borderColor,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(2 * SizeConfig.widthMultiplier),
                                borderSide: const BorderSide(
                                  color: colorPrimary,
                                  // width: 2.0,
                                ),
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding:
                                  EdgeInsets.all(1.5 * SizeConfig.widthMultiplier),
                                  child: Image.asset("assets/icons/search_icon.png",
                                      fit: BoxFit.contain, color: colorWhite),
                                ),
                              ),
                              hintText: "Search Wagls, accounts, and more",
                              hintStyle: TextStyle(
                                fontFamily: "Gilroy",
                                color: colorGrey,
                                fontSize: 1.6 * SizeConfig.textMultiplier/scaleFactor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1 * SizeConfig.heightMultiplier,
                          ),
                          Expanded(
                            child: discoverController
                                    .searchTextController.text.isNotEmpty
                                ? ListView.builder(
                                    itemCount:
                                        discoverController.searchResults.length,
                                    itemBuilder: (context, index) {
                                      print(
                                          "here is the length ${discoverController.searchResults.length}");
                                      var result = controller.searchResults[index];
                                      if (result is GoodTag) {
                                        return GestureDetector(


                                          onTap: () async {
                                            if (await CheckInternet.checkInternet()) {
                                              print("here is thhe  iD ${result.id}");
                                              await discoverController
                                                  .getGoodTagWagls(result.id);
                                              homeController.updateStoryIndex(0);
                                              homeController.update();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (_) =>   WaglScreen(
                                                  waglData: discoverController
                                                      .goodTagWaglItems,
                                                  waglIndex: 0,
                                                  isDiscover: true,
                                                  isSaved: false,
                                                )),
                                              );
                                           /*   Get.to(() => HomeView(
                                                waglData: discoverController
                                                    .goodTagWaglItems,
                                                waglIndex: 0,
                                                isDiscover: true,
                                                isSaved: false,
                                              ));*/

                                            }else{

                                              showDialog<String>(
                                                context: context,
                                                builder: (BuildContext context) => AlertDialog(
                                                  backgroundColor: colorBlack_2,

                                                  title:  Row(
                                                    children: [
                                                      Icon(Icons.info_outline),
                                                      SizedBox(width: 2*SizeConfig.widthMultiplier,),
                                                      CustText(name: 'No internet connection !',size: 1.8,colors: colorWhite,fontWeightName: FontWeight.w600,textAlign: TextAlign.start),
                                                    ],
                                                  ),
                                                  content: Padding(
                                                    padding:  EdgeInsets.only(right: 3.0*SizeConfig.widthMultiplier,top: 2*SizeConfig.heightMultiplier),
                                                    child: CustText(name: 'Please check your internet connection and try again.',size: 1.5,colors: colorWhite,fontWeightName: FontWeight.w900),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, 'Cancel'),
                                                      child: CustText(name: 'Cancel',size: 1.6,colors: colorWhite,fontWeightName: FontWeight.w600),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, 'OK'),
                                                      child:CustText(name: 'OK',size: 1.6,colors: colorWhite,fontWeightName: FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }

                                          },
                                          child: Container(

                                            color: Colors.transparent,
                                            child: _buildGoodTag(
                                                result.attributes.name,
                                                result.attributes.image!.data!
                                                    .attributes.url),
                                          ),
                                        );
                                      } else if (result is InterestedCategory) {
                                        return GestureDetector(
                                          onTap: () async {
                                            if (await CheckInternet.checkInternet()) {
                                              // Store a reference to the dialog's context
                                              print("here is the wagl Clicked");
                                              BuildContext? dialogContext;

                                              // Show the loading popup
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false, // Prevent dismissal by tapping outside
                                                builder: (BuildContext context) {
                                                  dialogContext = context; // Capture dialog context for later dismissal
                                                  return CustomLoadingPopup();
                                                },
                                              );

                                              try {
                                                // Perform the async operations sequentially
                                                var result1 = await discoverController.getAllCategory();
                                                var result2 = await discoverController.getCategoryData(result.id);
                                                var result3 = await discoverController.getCategoryWagls(result.id);

                                                discoverController.updateImageSize(false);

                                                // Navigate to the next screen
                                                Navigator.push(
                                                  context, // Use the main context for navigation
                                                  MaterialPageRoute(
                                                    builder: (_) => CategoriesWaglView(
                                                      categoriesData: discoverController.categoriesItemSearched,
                                                      categoryIndex: 0,
                                                      categoryWagls: discoverController.searchCategoryWagls,
                                                    ),
                                                  ),
                                                );
                                              } catch (e) {
                                                // Log any errors
                                                print("Error during operation: $e");
                                              } finally {
                                                // Always close the loading dialog if it is still active
                                                if (dialogContext != null && Navigator.canPop(dialogContext!)) {
                                                  Navigator.pop(dialogContext!);
                                                }
                                              }
                                            } else {
                                              // Show a no-internet alert dialog if no internet connection
                                              showDialog<String>(
                                                context: context,
                                                builder: (BuildContext context) => AlertDialog(
                                                  backgroundColor: colorBlack_2,
                                                  title: Row(
                                                    children: [
                                                      Icon(Icons.info_outline),
                                                      SizedBox(width: 2 * SizeConfig.widthMultiplier),
                                                      CustText(
                                                        name: 'No internet connection!',
                                                        size: 1.8,
                                                        colors: colorWhite,
                                                        fontWeightName: FontWeight.w600,
                                                        textAlign: TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                  content: Padding(
                                                    padding: EdgeInsets.only(
                                                      right: 3.0 * SizeConfig.widthMultiplier,
                                                      top: 2 * SizeConfig.heightMultiplier,
                                                    ),
                                                    child: CustText(
                                                      name: 'Please check your internet connection and try again.',
                                                      size: 1.5,
                                                      colors: colorWhite,
                                                      fontWeightName: FontWeight.w900,
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, 'Cancel'),
                                                      child: CustText(
                                                        name: 'Cancel',
                                                        size: 1.6,
                                                        colors: colorWhite,
                                                        fontWeightName: FontWeight.w600,
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, 'OK'),
                                                      child: CustText(
                                                        name: 'OK',
                                                        size: 1.6,
                                                        colors: colorWhite,
                                                        fontWeightName: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          },
                                          /* onTap: () async {

                                            if(await CheckInternet.checkInternet()){
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
                                                MaterialPageRoute(builder: (_) =>  CategoriesWaglView(
                                                  categoriesData: discoverController
                                                      .categoriesItemSearched,
                                                  categoryIndex: 0,
                                                  categoryWagls: discoverController
                                                      .searchCategoryWagls,
                                                  // id:result.id,
                                                )),
                                              );
                                       *//*       Get.to(
                                                    () => CategoriesWaglView(
                                                  categoriesData: discoverController
                                                      .categoriesItemSearched,
                                                  categoryIndex: 0,
                                                  categoryWagls: discoverController
                                                      .searchCategoryWagls,
                                                  // id:result.id,
                                                ),
                                              );*//*
                                            }
                                            else{

                                              showDialog<String>(
                                                context: context,
                                                builder: (BuildContext context) => AlertDialog(
                                                  backgroundColor: colorBlack_2,

                                                  title:  Row(
                                                    children: [
                                                      Icon(Icons.info_outline),
                                                      SizedBox(width: 2*SizeConfig.widthMultiplier,),
                                                      CustText(name: 'No internet connection !',size: 1.8,colors: colorWhite,fontWeightName: FontWeight.w600,textAlign: TextAlign.start),
                                                    ],
                                                  ),
                                                  content: Padding(
                                                    padding:  EdgeInsets.only(right: 3.0*SizeConfig.widthMultiplier,top: 2*SizeConfig.heightMultiplier),
                                                    child: CustText(name: 'Please check your internet connection and try again.',size: 1.5,colors: colorWhite,fontWeightName: FontWeight.w900),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, 'Cancel'),
                                                      child: CustText(name: 'Cancel',size: 1.6,colors: colorWhite,fontWeightName: FontWeight.w600),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, 'OK'),
                                                      child:CustText(name: 'OK',size: 1.6,colors: colorWhite,fontWeightName: FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }

                                          },*/
                                          child: Container(
                                            width: 96 * SizeConfig.widthMultiplier,
                                            color: Colors.transparent,
                                            child: Padding(
                                              padding:  EdgeInsets.symmetric(horizontal: 2.0*SizeConfig.widthMultiplier),
                                              child: _buildCategoryTile(
                                                  result.attributes.categoryName,
                                                  result.attributes.categoryIcon!
                                                              .data !=
                                                          null
                                                      ? result
                                                          .attributes
                                                          .categoryIcon!
                                                          .data!
                                                          .attributes
                                                          .url
                                                      : ""
                                                  /*  result.attributes.categoryIcon![0].data !=
                                                    null
                                                ? result.attributes.categoryIcon![0].data!
                                                    .attributes.url
                                                : ""*/
                                                  ),
                                            ),
                                          ),
                                        );
                                      } else if (result is SearchUser) {
                                        return _buildUserTile(result, index,context);
                                      }
                                      return _buildSuggestionTile(
                                          "controller.searchResults[index]",context);
                                    },
                                  )
                                : DiscoverCategoriesView(),
                          )
                        ],
                      ),
                    ),
                  )),
        ),
      ),
    );
  }

  Widget _buildGoodTag(String goodTag, String url) {
    return Container(
      width: 96 * SizeConfig.widthMultiplier,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 2.0*SizeConfig.widthMultiplier),
        child: Column(
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
        ),
      ),
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

  Widget _buildUserTile(SearchUser user, int index,context) {
    return Container(
      // width: 96 * SizeConfig.widthMultiplier,
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () async {
          if (user.id != ApiClient.box.read("userId")) {
            discoverController.clearData();
            int userId = user.id;
            // Get.to(() => ProfileSearchView(id: userId));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) =>  ProfileSearchView(id: userId)),
            );
            profileController.getUsersWagl(userId);
            discoverController.getProfileDetails(userId);
            await discoverController.getUsersWagl(userId);
          } else {
            homeController.onBottomOptionTapped(4);
          }
        },
        child: Column(
          children: [
            SizedBox(
              height: 1 * SizeConfig.heightMultiplier,
            ),
            Container(
              color: Colors.transparent,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 2.0*SizeConfig.widthMultiplier),
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
                      width: 2.0 * SizeConfig.widthMultiplier,
                    ),
                    Container(
                      width: 79 * SizeConfig.widthMultiplier,
                      // color: Colors.red,
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
                                  SizedBox(width: 1.5 * SizeConfig.widthMultiplier),
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
                                  onTap: () async {
                                    if(await CheckInternet.checkInternet()){
                                    discoverController.updateFollows(
                                    !user.attributes.following, index, user);
                                    }
                                    else{
                                    var snackdemo = SnackBar(
                                    content: CustText(
                                    name: "Please check your internet connection",
                                    size: 1.4,
                                    colors: colorBlack,
                                    fontWeightName: FontWeight.w600),
                                    backgroundColor: colorPrimary,
                                    elevation: 10,
                                    duration: Duration(seconds: 3),
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.all(5),
                                    shape: BeveledRectangleBorder(),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackdemo);
                                    }

                                  },
                                  child: Padding(
                                    padding:  EdgeInsets.only(right: 0.0*SizeConfig.widthMultiplier),
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
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
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
  }

  Widget _buildSuggestionTile(String suggestion,context) {
    return GestureDetector(
      onTap: () {
        print("here is the _buildSuggestionTile_buildSuggestionTile ");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) =>  TabSearchView()),
        );
        // Get.to(() => TabSearchView());
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 2.0*SizeConfig.widthMultiplier),
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
