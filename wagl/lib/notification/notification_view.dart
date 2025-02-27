import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wagl/custom_widget/cust_appbar.dart';
import 'package:wagl/notification/notification_controller.dart';
import 'package:wagl/util/ApiClient.dart';

import '../custom_widget/check_internet.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_text.dart';
import '../custom_widget/custom_loading_popup.dart';
import '../discover/discover_controller.dart';
import '../discover/profile_search_view.dart';
import '../home/home_page.dart';
import '../home/main_screen.dart';
import '../profile/profile_controller.dart';
import '../util/SizeConfig.dart';

class NotificationView extends StatelessWidget {
  var notificationController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      init: NotificationController(),
      builder: (controller) => Container(
        height: 100*SizeConfig.heightMultiplier,
        child: Scaffold(
          backgroundColor: colorBlack,
          body: Column(
            children: [
              Container(
                height: 5.5 * SizeConfig.heightMultiplier,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    // stops: [0.9,0.8],
                    end: Alignment.topCenter,
                    colors: [backgroundLightColor, colorBlack],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: colorBlack_2,
                      //     borderRadius: BorderRadius.all(
                      //       Radius.circular(
                      //         1.5 * SizeConfig.imageSizeMultiplier,
                      //       ),
                      //     ),
                      //     shape: BoxShape.rectangle,
                      //   ),
                      //   child: Padding(
                      //     padding: EdgeInsets.symmetric(
                      //         vertical: 1.5 * SizeConfig.heightMultiplier,
                      //         horizontal: 4 * SizeConfig.widthMultiplier),
                      //     child: SvgPicture.asset(
                      //       "assets/icons/back_icon.svg",
                      //       color: colorWhite,
                      //     ),
                      //   ),
                      // ),

                      Center(
                        child: CustText(
                            name: "Notifications",
                            size: 1.6,
                            colors: colorWhite,
                            textAlign: TextAlign.center,
                            fontWeightName: FontWeight.w700),
                      ),

                    ],
                  ),
                ),
              ),
              RefreshIndicator(
                color: colorPrimary,
                backgroundColor: colorBlack_2,
                onRefresh: () async {
                  if (await CheckInternet.checkInternet()) {
                    return notificationController.getNotificationDetails();
                  } else {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: colorBlack_2,
                        title: Padding(
                          padding: EdgeInsets.all(5 * SizeConfig.widthMultiplier),
                          child: Row(
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
                        ),
                        content: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.0 * SizeConfig.widthMultiplier),
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
                child: Container(
                  height: 81 * SizeConfig.heightMultiplier,
                  width: 100 * SizeConfig.widthMultiplier,
                  child: notificationController.isLoading
                      ? Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: Container(
                                  height: 75 * SizeConfig.heightMultiplier,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: colorPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : notificationController.notificationList.isEmpty
                          ? Column(
                              children: [
                                Expanded(
                                    child: SingleChildScrollView(
                                        physics: AlwaysScrollableScrollPhysics(),
                                        child: Container(
                                            height:
                                                75 * SizeConfig.heightMultiplier,
                                            child: Center(
                                              child: CustText(
                                                  name:
                                                      "No new notifications yet",
                                                  size: 1.4,
                                                  colors: colorWhite,
                                                  fontWeightName:
                                                      FontWeight.w500),
                                            )))),
                              ],
                            )
                          : ListView.builder(
                              itemCount:
                                  notificationController.notificationList.length,
                              physics: AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    if (ApiClient.box.read("userId") ==
                                        notificationController
                                            .notificationList[index]
                                            .senderId!
                                            .id) {
                                      homeController.onBottomOptionTapped(4);
                                    } else {
                                      if (await CheckInternet.checkInternet()) {
                                        print("Tapped");
                                        print(
                                            "object here is the index $index ${notificationController.notificationList[index].senderId!.id}");
                                        var profileController =
                                            Get.put(ProfileController());
                                        var discoverController =
                                            Get.put(DiscoverController());
                                        discoverController.clearData();
                                        int followerId = notificationController
                                            .notificationList[index]
                                            .senderId!
                                            .id!;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => ProfileSearchView(
                                                  id: followerId)),
                                        );
                                        // Get.to(() => ProfileSearchView(id: followerId));
                                        profileController
                                            .getUsersWagl(followerId);
                                        discoverController
                                            .getProfileDetails(followerId);
                                        await discoverController
                                            .getUsersWagl(followerId);
                                      } else {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            backgroundColor: colorBlack_2,
                                            title: Row(
                                              children: [
                                                Icon(Icons.info_outline),
                                                SizedBox(
                                                  width: 2 *
                                                      SizeConfig.widthMultiplier,
                                                ),
                                                CustText(
                                                    name:
                                                        'No internet connection !',
                                                    size: 1.8,
                                                    colors: colorWhite,
                                                    fontWeightName:
                                                        FontWeight.w600,
                                                    textAlign: TextAlign.start),
                                              ],
                                            ),
                                            content: Padding(
                                              padding: EdgeInsets.only(
                                                  right: 3.0 *
                                                      SizeConfig.widthMultiplier,
                                                  top: 2 *
                                                      SizeConfig
                                                          .heightMultiplier),
                                              child: CustText(
                                                  name:
                                                      'Please check your internet connection and try again.',
                                                  size: 1.5,
                                                  colors: colorWhite,
                                                  fontWeightName:
                                                      FontWeight.w900),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'Cancel'),
                                                child: CustText(
                                                    name: 'Cancel',
                                                    size: 1.6,
                                                    colors: colorWhite,
                                                    fontWeightName:
                                                        FontWeight.w600),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context, 'OK'),
                                                child: CustText(
                                                    name: 'Ok',
                                                    size: 1.6,
                                                    colors: colorWhite,
                                                    fontWeightName:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 100 * SizeConfig.widthMultiplier,
                                        color: Colors.transparent,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 1 *
                                                    SizeConfig.widthMultiplier,
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 13 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    height: 8 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image: notificationController
                                                                    .notificationList[
                                                                        index]
                                                                    .senderId ==
                                                                null
                                                            ? AssetImage(
                                                                    "assets/images/no_profile.png")
                                                                as ImageProvider
                                                            : notificationController
                                                                        .notificationList[
                                                                            index]
                                                                        .senderId
                                                                        ?.profilePic
                                                                        ?.url !=
                                                                    null
                                                                ? NetworkImage(
                                                                    notificationController
                                                                        .notificationList[
                                                                            index]
                                                                        .senderId!
                                                                        .profilePic!
                                                                        .url!)
                                                                : const AssetImage(
                                                                        "assets/images/no_profile.png")
                                                                    as ImageProvider,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 2 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                  ),
                                                  SizedBox(
                                                    width: 61 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustText(
                                                            name:
                                                                "${notificationController.notificationList[index].description}",
                                                            size: 1.6,
                                                            colors: colorWhite,
                                                            fontWeightName:
                                                                FontWeight.w800),
                                                        CustText(
                                                            name: ApiClient.timeAgoConversion(
                                                                notificationController
                                                                    .notificationList[
                                                                        index]
                                                                    .createdAt!),
                                                            size: 1.4,
                                                            colors: colorGrey,
                                                            fontWeightName:
                                                                FontWeight.w500),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              notificationController
                                                              .notificationList[
                                                                  index]
                                                              .waglId ==
                                                          null &&
                                                      notificationController
                                                              .notificationList[
                                                                  index]
                                                              .senderId ==
                                                          null
                                                  ? Container()
                                                  : GestureDetector(
                                                      onTap: () async {
                                                        // homeController.updateWaglIndex(index);
                                                        BuildContext?
                                                            dialogContext;
                                                        var waglIndex = 0;
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
                                                          int profileWaglLength =
                                                              homeController
                                                                  .wagls!.length;
                                                          int notificationListLength =
                                                              notificationController
                                                                  .notificationList
                                                                  .length;
                                                          print(
                                                              'Here is the profileWaglLength  length ${profileWaglLength}');
                                                          print(
                                                              'Here is the notificationListLength  length ${notificationListLength}');
                                                          print(
                                                              'Here is the Id  length ${notificationController.notificationList[index].waglId!.id}');
                                                          for (int i = 0;
                                                              i < profileWaglLength;
                                                              i++) {
                                                            for (int j = 0;
                                                                j < notificationListLength;
                                                                j++) {
                                                              if (notificationController
                                                                      .notificationList[
                                                                          i]
                                                                      .waglId !=
                                                                  null) {
                                                                print(
                                                                    'Here is the id $index $i  $j notificationList ${notificationController.notificationList[index].waglId!.id}');

                                                                if (notificationController
                                                                        .notificationList[
                                                                            index]
                                                                        .waglId!
                                                                        .id ==
                                                                    homeController
                                                                        .wagls![i]
                                                                        .id) {
                                                                  waglIndex = i;
                                                                  print(
                                                                      "here is the index $i");
                                                                }
                                                              }
                                                            }
                                                          }
                                                          final result =
                                                              await homeController
                                                                  .getAllWagls(
                                                                      1,
                                                                      notificationController
                                                                          .userCategoriesList);
                                                          // final result =  await profileController.getUsersWagl(userId);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (_) =>
                                                                        WaglScreen(
                                                                          waglData:
                                                                              homeController.storyItems,
                                                                          isDiscover:
                                                                              false,
                                                                          isSaved:
                                                                              false,
                                                                        )),
                                                          );
                                                          // Get.to(()=>HomeView(waglData: homeController.storyItems,isDiscover: false,isSaved:false ,));
                                                          homeController
                                                              .handlePageViewChanged(
                                                                  waglIndex,
                                                                  false,
                                                                  false,
                                                                  index);
                                                          // Get.to(() => MyHomePage());
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
                                                        print(
                                                            "here is the here is the Tappped");
                                                      },
                                                      child: notificationController
                                                                  .notificationList[
                                                                      index]
                                                                  .waglId !=
                                                              null
                                                          ? Padding(
                                                              padding: EdgeInsets.only(
                                                                  left: 3.0 *
                                                                      SizeConfig
                                                                          .widthMultiplier),
                                                              child: (notificationController
                                                                  .notificationList[
                                                              index]
                                                                  .waglId
                                                                  ?.media?[
                                                              0]
                                                                  .ext ==
                                                                  ".mp4"||notificationController
                                                                  .notificationList[
                                                              index]
                                                                  .waglId
                                                                  ?.media?[
                                                              0]
                                                                  .ext ==
                                                                  ".hevc"|| notificationController
                                                                  .notificationList[
                                                              index]
                                                                  .waglId
                                                                  ?.media?[
                                                              0]
                                                                  .ext ==
                                                                  ".mov")&&
                                                                  notificationController
                                                                  .notificationList[index]
                                                                  .waglId!
                                                                  .thumbnail!.isNotEmpty
                                                                  ? Container(
                                                                width: 15 *
                                                                    SizeConfig
                                                                        .widthMultiplier,
                                                                height: 7 *
                                                                    SizeConfig
                                                                        .heightMultiplier,
                                                                decoration:
                                                                BoxDecoration(
                                                                  // shape: BoxShape.rectangle,
                                                                  borderRadius:
                                                                  BorderRadius.all(Radius.circular(0.8 *
                                                                      SizeConfig.heightMultiplier)),
                                                                  image:
                                                                  DecorationImage(
                                                                    image: NetworkImage(notificationController
                                                                        .notificationList[index]
                                                                        .waglId!
                                                                        .thumbnail![0]
                                                                        .url!),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              )
                                                                  : Container(
                                                                      width: 15 *
                                                                          SizeConfig
                                                                              .widthMultiplier,
                                                                      height: 7 *
                                                                          SizeConfig
                                                                              .heightMultiplier,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        // shape: BoxShape.rectangle,
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(0.8 *
                                                                                SizeConfig.heightMultiplier)),
                                                                        image:
                                                                            DecorationImage(
                                                                          image: NetworkImage(notificationController
                                                                              .notificationList[index]
                                                                              .waglId!
                                                                              .media![0]
                                                                              .url!),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                            )
                                                          : GestureDetector(
                                                              onTap: () async {
                                                                if (await CheckInternet
                                                                    .checkInternet()) {
                                                                  notificationController.updateFollower(
                                                                      index,
                                                                      notificationController
                                                                          .notificationList[
                                                                              index]
                                                                          .senderId!
                                                                          .id!,
                                                                      !notificationController
                                                                          .notificationList[
                                                                              index]
                                                                          .isFollow!);
                                                                } else {
                                                                  showDialog<
                                                                      String>(
                                                                    context:
                                                                        context,
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
                                                                            width:
                                                                                2 * SizeConfig.widthMultiplier,
                                                                          ),
                                                                          CustText(
                                                                              name:
                                                                                  'No internet connection !',
                                                                              size:
                                                                                  1.8,
                                                                              colors:
                                                                                  colorWhite,
                                                                              fontWeightName:
                                                                                  FontWeight.w600,
                                                                              textAlign: TextAlign.start),
                                                                        ],
                                                                      ),
                                                                      content:
                                                                          Padding(
                                                                        padding: EdgeInsets.only(
                                                                            right: 3.0 *
                                                                                SizeConfig
                                                                                    .widthMultiplier,
                                                                            top: 2 *
                                                                                SizeConfig.heightMultiplier),
                                                                        child: CustText(
                                                                            name:
                                                                                'Please check your internet connection and try again.',
                                                                            size:
                                                                                1.5,
                                                                            colors:
                                                                                colorWhite,
                                                                            fontWeightName:
                                                                                FontWeight.w900),
                                                                      ),
                                                                      actions: <Widget>[
                                                                        TextButton(
                                                                          onPressed: () => Navigator.pop(
                                                                              context,
                                                                              'Cancel'),
                                                                          child: CustText(
                                                                              name:
                                                                                  'Cancel',
                                                                              size:
                                                                                  1.6,
                                                                              colors:
                                                                                  colorWhite,
                                                                              fontWeightName:
                                                                                  FontWeight.w600),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed: () => Navigator.pop(
                                                                              context,
                                                                              'Ok'),
                                                                          child: CustText(
                                                                              name:
                                                                                  'Ok',
                                                                              size:
                                                                                  1.6,
                                                                              colors:
                                                                                  colorWhite,
                                                                              fontWeightName:
                                                                                  FontWeight.w600),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: notificationController
                                                                              .notificationList[index]
                                                                              .isFollow!
                                                                          ? colorBlack
                                                                          : colorBlack_2,
                                                                      border: Border.all(
                                                                          color: notificationController.notificationList[index].isFollow!
                                                                              ? colorBlack_2
                                                                              : colorBlack_2,
                                                                          width: 0.40 *
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
                                                                            name: notificationController.notificationList[index].isFollow!
                                                                                ? "Unfollow"
                                                                                : "Follow",
                                                                            size:
                                                                                1.6,
                                                                            colors: notificationController.notificationList[index].isFollow!
                                                                                ? colorWhite
                                                                                : colorPrimary,
                                                                            fontWeightName:
                                                                                FontWeight.w800),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 2 *
                                                                        SizeConfig
                                                                            .widthMultiplier,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                    ),
                                            ]),
                                      ),
                                      SizedBox(
                                          height: 5,
                                          child: Divider(
                                              color: borderColor,
                                              height: 1,
                                              thickness: 2,
                                              endIndent: 0,
                                              indent: 0)),
                                    ],
                                  ),
                                );
                              }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
