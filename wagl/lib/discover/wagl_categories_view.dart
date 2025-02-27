import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/custom_widget/create_post_wagl.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import 'package:wagl/home/main_screen.dart';
import 'package:wagl/profile/profile_controller.dart';
import 'package:wagl/util/ApiClient.dart';
import 'package:wagl/util/SizeConfig.dart';

import '../custom_widget/blur_back_button.dart';
import '../custom_widget/check_internet.dart';
import '../custom_widget/custom_loading_popup.dart';
import '../home/all_wagl_model.dart';
import '../home/home_page.dart';
import '../home/waglStoryView.dart';
import 'categories_model_discover.dart';
import 'discover_controller.dart';

class CategoriesWaglView extends StatelessWidget {
  List<Data>? categoriesData = [];
  List<DataWagl>? categoryWagls = [];

  int categoryIndex = 0;

  var discoverController = Get.put(DiscoverController());

  CategoriesWaglView(
      {super.key,
      required this.categoriesData,
      required this.categoryWagls,
      required this.categoryIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBlack,
      body: SafeArea(
        child: categoriesData!.isEmpty
            ? Center(child: const CircularProgressIndicator())
            : GetBuilder<DiscoverController>(
                init: DiscoverController(),
                builder: (profileController) => CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(
                            // height: 40 * SizeConfig.heightMultiplier,
                            height: discoverController.isDiscard
                                ? 25 * SizeConfig.heightMultiplier
                                : 40 * SizeConfig.heightMultiplier,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  // clipBehavior: Clip.antiAlias,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    heightFactor: discoverController.isDiscard
                                        ? 1.0
                                        : 1.0,
                                    child: Image.network(
                                        "${categoriesData![categoryIndex].attributes!.categoryImage!.data!.attributesImage!.url}",
                                        height: discoverController.isClipped
                                            ? 43 * SizeConfig.heightMultiplier
                                            : 43 * SizeConfig.heightMultiplier,
                                        width: 100 * SizeConfig.widthMultiplier,
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                Positioned(
                                    top: 0,
                                    child: Container(
                                      width: 100 * SizeConfig.widthMultiplier,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 60,
                                              blurStyle: BlurStyle.normal,
                                              color: colorBlackShadow,
                                              offset: Offset.zero,
                                              spreadRadius: 10 *
                                                  SizeConfig.heightMultiplier),
                                        ],
                                      ),
                                    )),
                                Positioned(
                                    bottom: 0,
                                    child: Container(
                                      width: 100 * SizeConfig.widthMultiplier,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 60,
                                              blurStyle: BlurStyle.normal,
                                              color: colorBlackShadow,
                                              offset: Offset.zero,
                                              spreadRadius: 5 *
                                                  SizeConfig.heightMultiplier),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  height: 45 * SizeConfig.heightMultiplier,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 100 * SizeConfig.widthMultiplier,
                                        height:
                                            18 * SizeConfig.heightMultiplier,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Stack(
                                              children: [
                                                SizedBox(
                                                  height: 13 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  width: 100 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Image.asset(
                                                          "assets/images/hexa_black.png",
                                                          height: 13 *
                                                              SizeConfig
                                                                  .heightMultiplier,
                                                          width: 30 *
                                                              SizeConfig
                                                                  .widthMultiplier,
                                                          fit: BoxFit.fill),
                                                      SvgPicture.network(
                                                          categoriesData![
                                                                  categoryIndex]
                                                              .attributes!
                                                              .categoryIcon!
                                                              .data![0]
                                                              .attributes!
                                                              .url
                                                              .toString(),
                                                          color: colorPrimary,
                                                          width: 1.8 *
                                                              SizeConfig
                                                                  .widthMultiplier,
                                                          fit: BoxFit.fill,
                                                          height: 1.8 *
                                                              SizeConfig
                                                                  .heightMultiplier),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  color: Colors.transparent,
                                                  height: 13.5 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  width: 100 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      CustTextBold(
                                                          name:
                                                              "${categoriesData![categoryIndex].attributes!.categoryName}",
                                                          size: 2.0,
                                                          colors: colorWhite,
                                                          fontWeightName:
                                                              FontWeight.w500,
                                                          maxLine: 3),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                2 * SizeConfig.widthMultiplier,
                                            vertical: 1 *
                                                SizeConfig.heightMultiplier),
                                        child: CustCreateWaglPost(
                                            onSelected: () async {
                                          {
                                            homeController
                                                .currentSelectedMedia = null;
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        CustomLoadingPopup());
                                            var images = await homeController
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
                                                                  index: 0),
                                                    ))
                                                : ();
                                          }
                                        }, isDiscard: (value) {
                                          discoverController
                                              .updateDiscardValue(value);
                                          discoverController
                                              .updateImageSize(true);
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 2 * SizeConfig.heightMultiplier,
                                  left: 3 * SizeConfig.widthMultiplier,
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: const CustBackButton()),
                                ),
                                Positioned(
                                  top: 2 * SizeConfig.heightMultiplier,
                                  right: 3 * SizeConfig.widthMultiplier,
                                  // Positioned at the bottom
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/wagl_icon.svg",
                                            color: colorWhite,
                                            height: 3.0 *
                                                SizeConfig.heightMultiplier,
                                            fit: BoxFit.contain,
                                          ),
                                          SizedBox(
                                            width:
                                                2 * SizeConfig.widthMultiplier,
                                          ),
                                          CustText(
                                              name:
                                                  "${ApiClient.formatNumber(discoverController.categoriesListItems[categoryIndex].attributes!.totalWagls ?? 0)} +",
                                              size: 1.6,
                                              colors: colorWhite,
                                              fontWeightName: FontWeight.w700),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns in the grid
                        mainAxisSpacing: 0.5 * SizeConfig.heightMultiplier,
                        crossAxisSpacing: 1 * SizeConfig.widthMultiplier,
                        // crossAxisSpacing: 10,
                        childAspectRatio: 0.65,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        childCount: categoryWagls!.length,
                        (BuildContext context, int index) {
                          return categoryWagls!.isEmpty
                              ? Center(
                                  child: CustText(
                                      name: "No result Found",
                                      size: 1.4,
                                      colors: colorWhite,
                                      textAlign: TextAlign.center,
                                      fontWeightName: FontWeight.w500),
                                )
                              : Stack(
                                  children: [
                                    Center(
                                      child:( categoryWagls![index].attributes!.thumbnail==null)&&/*(categoryWagls![index].attributes!.media!.data!
                                        ..sort((a, b) {
                                          final number1 = int.tryParse(a.attributesMedia?.name?.split('_')[0] ?? '') ?? 0;
                                          final number2 = int.tryParse(b.attributesMedia?.name?.split('_')[0] ?? '') ?? 0;
                                          return number1.compareTo(number2); // Ascending order
                                        }))[0]
                                          .attributesMedia!
                                          .ext ==
                                          ".mp4"*/
                                          (categoryWagls![index]
                                              .attributes!
                                              .media!
                                              .data![0]
                                              .attributesMedia!
                                              .ext ==
                                              ".mp4" ||categoryWagls![index]
                                          .attributes!
                                          .media!
                                          .data![0]
                                          .attributesMedia!
                                          .ext ==
                                          ".mov"||categoryWagls![index]
                                          .attributes!
                                          .media!
                                          .data![0]
                                          .attributesMedia!
                                          .ext ==
                                          ".hevc")
                                          ? GestureDetector(
                                          onTap: () async {
                                            print(
                                                "here is the issue");

                                            ConnectionChecker
                                                .checkConnection(
                                              context: context,
                                              onConnected:
                                                  () async {
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
                                                  // Fetch category tags and update story index
                                                  await discoverController.getCategoryTagsWagls(
                                                    categoriesData![categoryIndex].id,
                                                    index,
                                                  );

                                                  await homeController.updateStoryIndex(index);

                                                  print("here is the wagl index ${index}");
                                                  print("categories to main screen | ${index}");

                                                  // Update the home controller
                                                  homeController.update();

                                                  // Navigate to the next screen
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) => WaglScreen(
                                                        waglData: discoverController.categoryWaglItems,
                                                        waglIndex: index,
                                                        isDiscover: true,
                                                        isSaved: false,
                                                      ),
                                                    ),
                                                  );

                                                  print("here is the issue ${categoryWagls![index].id}");
                                                } catch (e) {
                                                  print("Error during operation: $e");
                                                } finally {
                                                  // Dismiss the loading dialog
                                                  if (dialogContext != null && Navigator.canPop(dialogContext!)) {
                                                    Navigator.pop(dialogContext!);
                                                  }
                                                }
                                              },
                                            );
                                          },
                                              child: Container(
                                                color: Colors.black,
                                                child: SvgPicture.asset(
                                                  "assets/icons/no_thumbnail.svg",
                                                  color: colorWhite,
                                                  width: 10 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  height: 10 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                ),
                                              ))
                                          : Image.network(
                                            /*categoryWagls![index].attributes!.thumbnail==null&&(categoryWagls![index].attributes!.media!.data!
                                          ..sort((a, b) {
                                            final number1 = int.tryParse(a.attributesMedia?.name?.split('_')[0] ?? '') ?? 0;
                                            final number2 = int.tryParse(b.attributesMedia?.name?.split('_')[0] ?? '') ?? 0;
                                            return number1.compareTo(number2); // Ascending order
                                          }))[0]
                                                          .attributesMedia!
                                                          .ext ==
                                                      ".mp4"*/categoryWagls![index].attributes!.thumbnail!=null
                                                  ? categoryWagls![index]
                                                      .attributes!
                                                      .thumbnail!
                                                      .attributes!
                                                      .url!
                                                  : categoryWagls![index]
                                                          .attributes!
                                                          .media!
                                                          .data![0]
                                                          .attributesMedia!
                                                          .formats
                                                          ?.small
                                                          ?.url! ??
                                                      categoryWagls![index]
                                                          .attributes!
                                                          .media!
                                                          .data![0]
                                                          .attributesMedia!
                                                          .url!,
                                              fit: BoxFit.fill,
                                              // height: 100 *
                                              //     SizeConfig.heightMultiplier,
                                              width: 100 *
                                                  SizeConfig.widthMultiplier,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return GestureDetector(
                                                      onTap: () async {
                                                        print(
                                                            "here is the issue");

                                                        ConnectionChecker
                                                            .checkConnection(
                                                          context: context,
                                                          onConnected:
                                                              () async {
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
                                                              // Fetch category tags and update story index
                                                              await discoverController.getCategoryTagsWagls(
                                                                categoriesData![categoryIndex].id,
                                                                index,
                                                              );

                                                              await homeController.updateStoryIndex(index);

                                                              print("here is the wagl index ${index}");
                                                              print("categories to main screen | ${index}");

                                                              // Update the home controller
                                                              homeController.update();

                                                              // Navigate to the next screen
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (_) => WaglScreen(
                                                                    waglData: discoverController.categoryWaglItems,
                                                                    waglIndex: index,
                                                                    isDiscover: true,
                                                                    isSaved: false,
                                                                  ),
                                                                ),
                                                              );

                                                              print("here is the issue ${categoryWagls![index].id}");
                                                            } catch (e) {
                                                              print("Error during operation: $e");
                                                            } finally {
                                                              // Dismiss the loading dialog
                                                              if (dialogContext != null && Navigator.canPop(dialogContext!)) {
                                                                Navigator.pop(dialogContext!);
                                                              }
                                                            }
                                                          },
                                                        );
                                                      },
                                                      child:
                                                          child); // Image is loaded, show the image
                                                } else {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                          : null,
                                                      color: colorPrimary,
                                                      backgroundColor:
                                                          backgroundLightColor,
                                                    ),
                                                  ); // Image is loading, show the loader
                                                }
                                              },
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                return  Container(
                                                  color: Colors.black,
                                                  child: SvgPicture.asset(
                                                    "assets/icons/no_thumbnail.svg",
                                                    color: colorWhite,
                                                    width: 10 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    height: 10 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                  ),
                                                ); // Handle error
                                                // return Text('Failed to load image'); // Handle error
                                              },
                                            ),
                                    ),
                                    Positioned(
                                        top: 0,
                                        child: Container(
                                          width:
                                              50 * SizeConfig.widthMultiplier,
                                          decoration: const BoxDecoration(

                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 20,
                                                  blurStyle: BlurStyle.normal,
                                                  color: colorBlackShadow,
                                                  offset: Offset.zero,
                                                  spreadRadius: 20),
                                            ],
                                          ),
                                        )),
                                    Positioned(
                                        bottom: 0,
                                        child: Container(
                                          width:
                                              50 * SizeConfig.widthMultiplier,
                                          decoration: const BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 20,
                                                  blurStyle: BlurStyle.normal,
                                                  color: colorBlackShadow,
                                                  offset: Offset.zero,
                                                  spreadRadius: 20),
                                            ],
                                          ),
                                        )),
                                    Positioned(
                                        bottom: 1 * SizeConfig.heightMultiplier,
                                        left: 2 * SizeConfig.widthMultiplier,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 4 *
                                                  SizeConfig
                                                      .imageSizeMultiplier,
                                              //radius of avatar
                                              backgroundColor:
                                                  Colors.transparent,
                                              //color

                                              // child: ClipOval(child:  profileController.savedWagl![index].attributes!.waglId!.data!.attributes!.userDetails!.data?.attributes?.profilePicData?.data==null?Image.asset("assets/images/no_profile.png"):Image.network("${profileController.savedWagl![index].attributes!.waglId!.data!.attributes!.userDetails!.data!.attributes!.profilePicData?.data?.attributes?.url}")),
                                              child: ClipOval(
                                                  child: categoryWagls![index]
                                                              .attributes
                                                              ?.userId
                                                              ?.data
                                                              ?.attributes
                                                              ?.profilePicData
                                                              ?.data ==
                                                          null
                                                      ? Image.asset(
                                                          "assets/images/no_profile.png")
                                                      : Image.network(
                                                          "${categoryWagls![index].attributes?.userId?.data?.attributes?.profilePicData?.data?.attributes?.url}")),
                                            ),
                                            SizedBox(
                                              width: 1 *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            CustTextBold(
                                              name:
                                                  "@${categoryWagls![index].attributes?.userId?.data?.attributes?.username ?? ""}",
                                              colors: colorWhite,
                                              size: 1.4,
                                              fontWeightName: FontWeight.w500,
                                            ),
                                          ],
                                        )),
                                    Positioned(
                                        top: 1 * SizeConfig.heightMultiplier,
                                        left: 2 * SizeConfig.widthMultiplier,
                                        child: CustText(
                                          name:
                                          categoryWagls![index].attributes!.interestedCategories!.data!.isNotEmpty? "${categoryWagls![index].attributes?.interestedCategories?.data?[0].attributesMedia?.categoryName ?? ""}":"",
                                          colors: colorWhite,
                                          size: 1.4,
                                          fontWeightName: FontWeight.w500,
                                        )),
                                    Positioned(
                                        top: 1 * SizeConfig.heightMultiplier,
                                        right: 2 * SizeConfig.widthMultiplier,
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 5 *
                                                    SizeConfig.widthMultiplier,
                                                height: 1.5 *
                                                    SizeConfig.heightMultiplier,
                                                child: SvgPicture.asset(
                                                  "assets/icons/eye_icon.svg",
                                                  fit: BoxFit.contain,
                                                )),
                                            SizedBox(
                                              width: 0.5 *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            CustText(
                                                name: ApiClient.formatNumber(
                                                    categoryWagls![index]
                                                            .attributes!
                                                            .totalViews ??
                                                        0),
                                                size: 1.4,
                                                colors: colorWhite,
                                                textAlign: TextAlign.left,
                                                fontWeightName:
                                                    FontWeight.w500),
                                            SizedBox(
                                              width: 3 *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            Container(
                                                width: 5 *
                                                    SizeConfig.widthMultiplier,
                                                height: 2 *
                                                    SizeConfig.heightMultiplier,
                                                child: SvgPicture.asset(
                                                  "assets/icons/like_icon.svg",
                                                  fit: BoxFit.contain,
                                                )),
                                            SizedBox(
                                              width: 0.5 *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            CustText(
                                                name: ApiClient.formatNumber(
                                                    categoryWagls![index]
                                                            .attributes!
                                                            .totalLikes ??
                                                        0),
                                                size: 1.4,
                                                colors: colorWhite,
                                                textAlign: TextAlign.left,
                                                fontWeightName:
                                                    FontWeight.w500),
                                          ],
                                        )),
                                    Positioned(
                                      bottom: 0,
                                      right: 1 * SizeConfig.widthMultiplier,
                                      child: Row(
                                        children: [
                                          ApiClient.checkVideoCount(
                                                  categoryWagls!, index)
                                              ? Container(
                                                  width: 7 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  height: 7 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  decoration: BoxDecoration(
                                                      color: colorPrimary,
                                                      shape: BoxShape.circle),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(1.0 *
                                                        SizeConfig
                                                            .widthMultiplier),
                                                    child: Image.asset(
                                                      "assets/icons/video_image.png",
                                                      fit: BoxFit.scaleDown,
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          SizedBox(
                                            width:
                                                2 * SizeConfig.widthMultiplier,
                                          ),
                                          ApiClient.checkImageCount(
                                                  categoryWagls!, index)
                                              ? Container(
                                                  width: 7 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  height: 7 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  decoration: BoxDecoration(
                                                      color: colorPrimary,
                                                      shape: BoxShape.circle),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(1.0 *
                                                        SizeConfig
                                                            .widthMultiplier),
                                                    child: Image.asset(
                                                      "assets/icons/multiple_image.png",
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ))
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                        },
                        // Adjust the number of items in the grid
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
