import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import 'package:wagl/profile/profile_controller.dart';
import 'package:wagl/profile/saved_wagl_model.dart';
import 'package:wagl/util/ApiClient.dart';
import 'package:wagl/util/SizeConfig.dart';

import '../custom_widget/custom_loading_popup.dart';
import '../home/all_wagl_model.dart';
import '../home/home_page.dart';
import '../home/main_screen.dart';

class SavedPost extends StatelessWidget {
  var profileController = Get.put(ProfileController());

  SavedPost({super.key});

  @override
  Widget build(BuildContext context) {
    print(
        "here is the value ${profileController.savedWagl} ${profileController.savedWagl != null || profileController.savedWagl!.isNotEmpty}");
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) => profileController.savedWagl != null &&
              profileController.savedWagl!.isNotEmpty
          ? GridView.builder(
              itemCount: profileController.savedWagl!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (BuildContext context, int index) {
                return /*profileController
              .userWagl!.isEmpty?Container(color: Colors.red,width: 100,height: 100,):*/
                    Stack(
                  children: [
                    Center(
                      child: Image.network(
                        (profileController.savedWagl![index].attributes!.waglId!.data!.attributes!.media!.data!
                          ..sort((a, b) {
                            final number1 = int.tryParse(a.attributes?.name?.split('_')[0] ?? '') ?? 0;
                            final number2 = int.tryParse(b.attributes?.name?.split('_')[0] ?? '') ?? 0;
                            return number1.compareTo(number2); // Ascending order
                          }))[0].attributes!.ext ==".mp4"||(profileController.savedWagl![index].attributes!.waglId!.data!.attributes!.media!.data!
                          ..sort((a, b) {
                            final number1 = int.tryParse(a.attributes?.name?.split('_')[0] ?? '') ?? 0;
                            final number2 = int.tryParse(b.attributes?.name?.split('_')[0] ?? '') ?? 0;
                            return number1.compareTo(number2); // Ascending order
                          }))[0].attributes!.ext ==".mkv"||(profileController.savedWagl![index].attributes!.waglId!.data!.attributes!.media!.data!
                          ..sort((a, b) {
                            final number1 = int.tryParse(a.attributes?.name?.split('_')[0] ?? '') ?? 0;
                            final number2 = int.tryParse(b.attributes?.name?.split('_')[0] ?? '') ?? 0;
                            return number1.compareTo(number2); // Ascending order
                          }))[0].attributes!.ext ==".mov"||(profileController.savedWagl![index].attributes!.waglId!.data!.attributes!.media!.data!
                          ..sort((a, b) {
                            final number1 = int.tryParse(a.attributes?.name?.split('_')[0] ?? '') ?? 0;
                            final number2 = int.tryParse(b.attributes?.name?.split('_')[0] ?? '') ?? 0;
                            return number1.compareTo(number2); // Ascending order
                          }))[0].attributes!.ext ==".hevc"
                            ? profileController
                                .savedWagl![index]
                                .attributes!
                                .waglId!
                                .data!
                                .attributes!
                                .thumbnail!
                                .attributes!
                                .url!
                            : profileController
                                .savedWagl![index]
                                .attributes!
                                .waglId!
                                .data!
                                .attributes!
                                .media!
                                .data![0]
                                .attributes!
                                .url!,
                        // profileController.savedWagl![index].attributes!.waglId!.data!.attributes!.media!.data![0].attributes.urlattributes.attributesMedia!.ext==".mp4"?profileController.savedWagl![index].attributes!.thumbnail!.attributes!.url!:profileController.savedWagl![index].attributes!.media!.data![0].attributesMedia!.formats!.thumbnail!.url!,
                        /*profileController.savedWagl![index].attributes!.waglId!
                            .data!.attributes!.media!.data![0].attributes!.url!,*/
                        fit: BoxFit.fill,
                        width: 100*SizeConfig.widthMultiplier,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                         /*   return GestureDetector(
                                onTap: () async {
                                  // showDialog(context: context, builder: (BuildContext context) => CustomLoadingPopup());
                                  // final result =  await homeController.getAllWagls(userId);
                                  // Navigator.pop(context);
                                  // Get.to(()=>HomeView(waglData: homeController.storyItems));
                                  // homeController.handlePageViewChanged(index);
                                  // showDialog(context: context, builder: (BuildContext context) => CustomLoadingPopup());
                                  //
                                  // Navigator.pop(context);
                                  showDialog(context: context, builder: (BuildContext context) => CustomLoadingPopup());
                                  final result =  await homeController.getSavedWagls();
                                  Navigator.pop(context);

                                  print(
                                      "asdadads ${profileController.savedStoryItems.length}");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => HomeView(
                                      waglData:
                                      profileController.savedStoryItems,
                                      waglIndex: index,
                                      isDiscover: false,
                                      isSaved: true,
                                    )),
                                  );
                                 *//* Get.to(() => HomeView(
                                        waglData:
                                            profileController.savedStoryItems,
                                        waglIndex: index,
                                        isDiscover: false,
                                        isSaved: true,
                                      ));*//*
                                  homeController.handlePageViewChanged(index,false,true,index);
                                },
                                child:
                                    child); // Image is loaded, show the image*/
                            return GestureDetector(
                           /*   onTap: () async {
                                // Capture the current context
                                final currentContext = context;

                                // Show the loading popup
                                showDialog(
                                  context: currentContext,
                                  barrierDismissible: false, // Prevent dismissal by tapping outside
                                  builder: (BuildContext context) => CustomLoadingPopup(),
                                );

                                try {
                                  // Perform the async operation
                                  final result = await homeController.getSavedWagls();

                                  print("Saved items: ${profileController.savedStoryItems.length}");

                                  // Navigate to the next screen
                                  Navigator.push(
                                    currentContext,
                                    MaterialPageRoute(
                                      builder: (_) => HomeView(
                                        waglData: profileController.savedStoryItems,
                                        waglIndex: index,
                                        isDiscover: false,
                                        isSaved: true,
                                      ),
                                    ),
                                  );

                                  // Handle page view change
                                  homeController.handlePageViewChanged(index, false, true, index);
                                } catch (e) {
                                  // Log errors
                                  print("Error: $e");
                                } finally {
                                  // Always close the loading dialog
                                  if (Navigator.canPop(currentContext)) {
                                    Navigator.pop(currentContext);
                                  }
                                }
                              },*/
                              onTap: () async {
                                // Store a reference to the dialog's context
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
                                  // Perform the asynchronous operation
                                  final result = await homeController.getSavedWagls();

                                  print("Saved items: ${profileController.savedStoryItems.length}");

                                  // Navigate to the next screen
                                  Navigator.push(
                                    context, // Use the main context for navigation
                                    MaterialPageRoute(
                                      builder: (_) => WaglScreen(
                                        waglData: profileController.savedStoryItems,
                                        waglIndex: index,
                                        isDiscover: false,
                                        isSaved: true,
                                      ),
                                    ),
                                  );

                                  // Handle page view change
                                  homeController.handlePageViewChanged(index, false, true, index);
                                } catch (e) {
                                  // Log errors
                                  print("Error: $e");
                                } finally {
                                  // Always close the loading dialog if it is still active
                                  if (dialogContext != null && Navigator.canPop(dialogContext!)) {
                                    Navigator.pop(dialogContext!);
                                  }
                                }
                              },

                              child: child,
                            );

                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                color: colorPrimary,
                                backgroundColor: backgroundLightColor,
                              ),
                            ); // Image is loading, show the loader
                          }
                        },
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          // return Container(); // Handle error
                          return GestureDetector(
                              onTap: () async {
                                // Store a reference to the dialog's context
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
                                  // Perform the asynchronous operation
                                  final result = await homeController.getSavedWagls();

                                  print("Saved items: ${profileController.savedStoryItems.length}");

                                  // Navigate to the next screen
                                  Navigator.push(
                                    context, // Use the main context for navigation
                                    MaterialPageRoute(
                                      builder: (_) => WaglScreen(
                                        waglData: profileController.savedStoryItems,
                                        waglIndex: index,
                                        isDiscover: false,
                                        isSaved: true,
                                      ),
                                    ),
                                  );

                                  // Handle page view change
                                  homeController.handlePageViewChanged(index, false, true, index);
                                } catch (e) {
                                  // Log errors
                                  print("Error: $e");
                                } finally {
                                  // Always close the loading dialog if it is still active
                                  if (dialogContext != null && Navigator.canPop(dialogContext!)) {
                                    Navigator.pop(dialogContext!);
                                  }
                                }
                              },
                              child: Container(color:Colors.black,child: SvgPicture.asset("assets/icons/no_thumbnail.svg",color:colorWhite,width: 10*SizeConfig.widthMultiplier,height: 10*SizeConfig.heightMultiplier,),)); // Handle error
                        },
                      ),
                    ),
                    Positioned(
                        bottom: 0,

                        child: Container(
                          width: 50*SizeConfig.widthMultiplier,
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 15,
                                  blurStyle: BlurStyle.normal,
                                  color: colorBlack,
                                  offset: Offset.zero,
                                  spreadRadius: 20),
                            ],
                          ),

                        )),
                    Positioned(
                        bottom: 1*SizeConfig.heightMultiplier,
                        left: 1*SizeConfig.widthMultiplier,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 4*SizeConfig.imageSizeMultiplier, //radius of avatar
                              backgroundColor: Colors.transparent, //color
                              child: ClipOval(child: profileController.savedWagl![index].attributes!.waglId!.data!.attributes!.userDetails!.data?.attributes?.profilePicData?.data==null?Image.asset("assets/images/no_profile.png"):Image.network("${profileController.savedWagl![index].attributes!.waglId!.data!.attributes!.userDetails!.data!.attributes!.profilePicData?.data?.attributes?.url}")),

                            ),
                            SizedBox(width: 1*SizeConfig.widthMultiplier,),
                            CustTextBold(
                              name:
                              "@${profileController.savedWagl![index].attributes!.waglId!.data!.attributes!.userDetails!.data!.attributes!.username}",
                              colors: colorWhite,
                              size: 1.4,
                              fontWeightName: FontWeight.w500,
                            ),
                          ],
                        )),
                    Positioned(
                        top: 5,
                        right: 2,
                        child: Row(
                          children: [
                            Container(
                                width: 5 * SizeConfig.widthMultiplier,
                                height: 1.5 * SizeConfig.heightMultiplier,
                                child: SvgPicture.asset(
                                  "assets/icons/eye_icon.svg",
                                  fit: BoxFit.contain,
                                )),
                            SizedBox(
                              width: 1 * SizeConfig.widthMultiplier,
                            ),
                            CustText(
                                name:
                                    ApiClient.formatNumber(profileController.savedWagl![index].attributes!.waglId!.data!.attributes!.totalViews??0),
                                    // ApiClient.formatNumber(110000),
                                size: 1.4,
                                colors: colorWhite,
                                textAlign: TextAlign.left,
                                fontWeightName: FontWeight.w500),
                            SizedBox(
                              width: 2 * SizeConfig.widthMultiplier,
                            ),
                            Container(
                                width: 5 * SizeConfig.widthMultiplier,
                                height: 2 * SizeConfig.heightMultiplier,
                                child: SvgPicture.asset(
                                  "assets/icons/like_icon.svg",
                                  fit: BoxFit.contain,
                                )),
                            SizedBox(
                              width: 1 * SizeConfig.widthMultiplier,
                            ),
                            CustText(
                                name:
                                ApiClient.formatNumber(profileController.savedWagl![index].attributes!.waglId!.data!.attributes!.totalLikes??0),

                                size: 1.4,
                                colors: colorWhite,
                                textAlign: TextAlign.left,
                                fontWeightName: FontWeight.w500),
                          ],
                        )),
                    Positioned(
                        bottom: -5,
                        right: 5,
                        child: Row(
                          children: [
                           /* profileController
                                        .savedWagl![index]
                                        .attributes!
                                        .waglId!
                                        .data!
                                        .attributes!
                                        .media!
                                        .data!
                                        .length ==
                                    2*/
                            ApiClient.checkVideoCountSaved( profileController.savedWagl!,index)
                                ? Container(
                                    width: 7 * SizeConfig.widthMultiplier,
                                    height: 7 * SizeConfig.heightMultiplier,
                                    decoration: BoxDecoration(
                                        color: colorPrimary,
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          1.0 * SizeConfig.widthMultiplier),
                                      child: Image.asset(
                                        "assets/icons/video_image.png",
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ))
                                : Container(),


                            // Text("${A}"),
                            ApiClient.checkImageCountSaved( profileController.savedWagl!,index)
                                ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      width: 7 * SizeConfig.widthMultiplier,
                                      height: 7 * SizeConfig.heightMultiplier,
                                      decoration: BoxDecoration(
                                          color: colorPrimary,
                                          shape: BoxShape.circle),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            1.0 * SizeConfig.widthMultiplier),
                                        child: Image.asset(
                                          "assets/icons/multiple_image.png",
                                          fit: BoxFit.contain,
                                        ),
                                      )),
                                )
                                : Container(),
                          ],
                        )),

                  ],
                );
              },
            )
          : Padding(
              padding: EdgeInsets.only(top: 5.0 * SizeConfig.heightMultiplier),
              child: CustText(
                  name: "You haven’t saved any posts yet.",
                  size: 1.5,
                  colors: colorGreyLight2,
                  textAlign: TextAlign.center,
                  fontWeightName: FontWeight.w600),
            ),
    );
  }
}
