import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import 'package:wagl/home/main_screen.dart';
import 'package:wagl/profile/profile_controller.dart';
import 'package:wagl/util/ApiClient.dart';
import 'package:wagl/util/SizeConfig.dart';

import '../custom_widget/custom_loading_popup.dart';
import '../home/all_wagl_model.dart';
import '../home/home_page.dart';

class WaglPost extends StatelessWidget {
  List<DataWagl>? userData = [];
  int userId;
  var userCategoriesList;

  var profileController = Get.put(ProfileController());

  WaglPost({super.key, @required this.userData,@required this.userCategoriesList,required this.userId});


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (profileController) => userData!.isEmpty?Container():GridView.builder(
        itemCount: userData!.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (BuildContext context, int index) {
          print("jereraklsdjf ${userData!.length}");

          return /*profileController
              .userWagl!.isEmpty?Container(color: Colors.red,width: 100,height: 100,):*/
              Stack(
            children: [
              Center(
                child: userData![index].attributes!.thumbnail==null&&userData![index]
                    .attributes!
                    .media!
                    .data![0]
                    .attributesMedia!
                    .ext ==
                    ".mp4"?GestureDetector(
                    onTap: () async {
                      print("here is the Tappped $userId");

                      // Store a reference to the current dialog context
                      BuildContext? dialogContext;

                      // Show a loading dialog
                      showDialog(
                        context: context,
                        // barrierDismissible: false, // Prevent dismissal by tapping outside
                        builder: (BuildContext context) {
                          dialogContext = context; // Assign the dialog's context
                          return CustomLoadingPopup();
                        },
                      );


                      // Perform the asynchronous operation
                      final result = await homeController.getAllWagls(userId, userCategoriesList);

                      // Proceed to navigation after operation completes
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WaglScreen(
                            waglData: homeController.storyItems,
                            isDiscover: false,
                            isSaved: false,
                            userId: userId,
                          ),
                        ),
                      );
                      homeController.handlePageViewChanged(index, false, false, index);
                      if (dialogContext != null && Navigator.canPop(dialogContext!)) {
                        Navigator.pop(dialogContext!);
                      }
                    },
                    child: Container(color:Colors.black,child: SvgPicture.asset("assets/icons/no_thumbnail.svg",color:colorWhite,width: 10*SizeConfig.widthMultiplier,height: 10*SizeConfig.heightMultiplier,),)):Image.network(
                  userData![index]
                      .attributes!
                      .media!
                      .data![0]
                      .attributesMedia!
                      .ext ==
                      ".mp4"||userData![index]
                      .attributes!
                      .media!
                      .data![0]
                      .attributesMedia!
                      .ext ==
                      ".mkv"||userData![index]
                      .attributes!
                      .media!
                      .data![0]
                      .attributesMedia!
                      .ext ==
                      ".mov"||userData![index]
                      .attributes!
                      .media!
                      .data![0]
                      .attributesMedia!
                      .ext ==
                      ".hevc"
                      ? userData![index].attributes!.thumbnail!.attributes!.url!
                      : userData![index]
                      .attributes!
                      .media!
                      .data![0]
                      .attributesMedia!
                      .formats?.small?.url ?? userData![index]
                      .attributes!
                      .media!
                      .data![0]
                      .attributesMedia!
                      .url!,
                  fit: BoxFit.fill,
                  // height: 100*SizeConfig.heightMultiplier,
                  width: 100*SizeConfig.widthMultiplier,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return GestureDetector(
                         /* onTap: () async {
                            print("here is the Tappped  $userId");
                            // homeController.changeTabIndex(0);
                            // homeController.updateWaglIndex(index);
                            showDialog(context: context, builder: (BuildContext context) => CustomLoadingPopup());
                            final result =  await homeController.getAllWagls(userId,userCategoriesList);
                            // final result =  await profileController.getUsersWagl(userId);
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) =>  HomeView(waglData: homeController.storyItems,isDiscover: false,isSaved:false ,)),
                            );
                        *//*    Get.to(()=>HomeView(waglData: homeController.storyItems,isDiscover: false,isSaved:false ,));*//*
                            homeController.handlePageViewChanged(index,false,false,index);
                            // Get.to(() => MyHomePage());

                            print("here is the here is the Tappped");
                          },*/

                          onTap: () async {
                            print("here is the Tappped $userId");

                            // Store a reference to the current dialog context
                            BuildContext? dialogContext;

                            // Show a loading dialog
                            showDialog(
                              context: context,
                              // barrierDismissible: false, // Prevent dismissal by tapping outside
                              builder: (BuildContext context) {
                                dialogContext = context; // Assign the dialog's context
                                return CustomLoadingPopup();
                              },
                            );


                              // Perform the asynchronous operation
                              final result = await homeController.getAllWagls(userId, userCategoriesList);

                              // Proceed to navigation after operation completes
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => WaglScreen(
                                    waglData: homeController.storyItems,
                                    isDiscover: false,
                                    isSaved: false,
                                    userId: userId,
                                  ),
                                ),
                              );
                              homeController.handlePageViewChanged(index, false, false, index);
                            if (dialogContext != null && Navigator.canPop(dialogContext!)) {
                              Navigator.pop(dialogContext!);
                            }


                            print("here is the here is the Tappped");
                          },
                          child: child); // Image is loaded, show the image
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
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
                    return GestureDetector(
                        onTap: () async {
                          print("here is the Tappped $userId");

                          // Store a reference to the current dialog context
                          BuildContext? dialogContext;

                          // Show a loading dialog
                          showDialog(
                            context: context,
                            // barrierDismissible: false, // Prevent dismissal by tapping outside
                            builder: (BuildContext context) {
                              dialogContext = context; // Assign the dialog's context
                              return CustomLoadingPopup();
                            },
                          );


                          // Perform the asynchronous operation
                          final result = await homeController.getAllWagls(userId, userCategoriesList);

                          // Proceed to navigation after operation completes
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WaglScreen(
                                waglData: homeController.storyItems,
                                isDiscover: false,
                                isSaved: false,
                                userId: userId,
                              ),
                            ),
                          );
                          homeController.handlePageViewChanged(index, false, false, index);
                          if (dialogContext != null && Navigator.canPop(dialogContext!)) {
                            Navigator.pop(dialogContext!);
                          }
                        },
                        child: Container(color:Colors.black,child: SvgPicture.asset("assets/icons/no_thumbnail.svg",color:colorWhite,width: 10*SizeConfig.widthMultiplier,height: 10*SizeConfig.heightMultiplier,),)); // Handle error
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
                            spreadRadius: 10),
                      ],
                    ),
                  )),
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: 100 * SizeConfig.widthMultiplier,
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
                  top: 2,
                  right: 3,
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
                              ApiClient.formatNumber(userData![index].attributes!.totalViews ?? 0),
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
                          ApiClient.formatNumber(userData![index].attributes!.totalLikes ?? 0),
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
                      // Text("${ApiClient.checkVideoCount( userData!,index)}"),
                     /* userData![index]
                          .attributes!
                          .media!
                          .data![0].attributesMedia!.ext==".mp4"*/
                      ApiClient.checkVideoCount( userData!,index)
                          ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                width: 7 * SizeConfig.widthMultiplier,
                                height: 7 * SizeConfig.heightMultiplier,
                                decoration: BoxDecoration(
                                    color: colorPrimary, shape: BoxShape.circle),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      1.0 * SizeConfig.widthMultiplier),
                                  child: Image.asset(
                                    "assets/icons/video_image.png",
                                    fit: BoxFit.scaleDown,
                                  ),
                                )),
                          )
                          : Container(),
                      // SizedBox(
                      //   width: 2 * SizeConfig.widthMultiplier,
                      // ),
                      // Text("${ApiClient.checkImageCount( userData!,index)}"),
                      /*userData![index]
                          .attributes!
                          .media!
                          .data!.length>1*/
                      ApiClient.checkImageCount( userData!,index)
                          ? Container(
                              width: 7 * SizeConfig.widthMultiplier,
                              height: 7 * SizeConfig.heightMultiplier,
                              decoration: const BoxDecoration(
                                  color: colorPrimary, shape: BoxShape.circle),
                              child: Padding(
                                padding: EdgeInsets.all(
                                    1.0 * SizeConfig.widthMultiplier),
                                child: Image.asset(
                                  "assets/icons/multiple_image.png",
                                  fit: BoxFit.contain,
                                ),
                              ))
                          : Container(),
                    ],
                  ))
            ],
          );
        },
      ),
    );
  }
}
