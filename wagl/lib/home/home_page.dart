import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wagl/create_wagl/create_wagl_view.dart';
import 'package:wagl/custom_widget/custom_loading_popup.dart';
import 'package:wagl/home/waglStoryView.dart';
import 'package:wagl/profile/profile_controller.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_text.dart';
import '../discover/discover_view.dart';
import '../notification/notification_view.dart';
import '../profile/profile_view.dart';
import '../util/SizeConfig.dart';
import 'home_controller.dart';
import 'main_home_wagl.dart';

final HomeController homeController = Get.put(HomeController());

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  ProfileController profileController = Get.put(ProfileController());


  @override
  void initState() {
    // TODO: implement initState
    homeController.getHomeFeedWagl();
    profileController.getProfileDetails(0);
    profileController.getUsersWagl(0);

    super.initState();
  }
  Future<bool> _onWillPop() async {
    final currentNavigatorState = homeController.navigatorKeys[homeController.selectedIndex].currentState;
    if (currentNavigatorState != null && currentNavigatorState.canPop()) {
      currentNavigatorState.pop();
      return false;
    }
    return true;
  }

  final List<Widget> children = [
    // HomeView(waglData:homeController.storyItems),
    // InstaProfilePage(),
    HomeWaglScreen(
      waglIndex: 0,
    ),
    DiscoverScreen(),
    CreateWaglView(isEdit: false),
    NotificationView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        color: colorBlack,
        child: SafeArea(
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: PageView(
                controller: homeController.pageController,
                physics: const NeverScrollableScrollPhysics(),
                // Prevent swipe navigation
                children: children.asMap().entries.map((entry) {
                  final index = entry.key;
                  final page = entry.value;
                  return Navigator(
                    key:homeController.navigatorKeys[index],
                    onGenerateRoute: (routeSettings) {
                      return MaterialPageRoute(
                        builder: (_) => page,
                      );
                    },
                  );
                }).toList(),
              ),
              /*   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Container(
              // alignment: Alignment.bottomCenter,
*//*isExtended: true,
              backgroundColor: Colors.transparent,
                onPressed:  () async {
                    homeController.currentSelectedMedia = null;
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomLoadingPopup());
                    var images = await homeController.pickImages();

                    Navigator.pop(context);

                    homeController.currentSelectedMedia != null
                        ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoryDesignerScreen(
                              mediaPath: homeController.currentSelectedMedia!, index: 0),
                        ))
                        : null;
                  },*//*
              child: Container(
                height: 15 * SizeConfig.heightMultiplier,
                width: 10 * SizeConfig.widthMultiplier,
                // color: Colors.red,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      height: 2 * SizeConfig.heightMultiplier,
                    ),
                    GestureDetector(
                      onTap: () async {
                        ///For Check permission..

                        if (await homeController.checkPermission()) {
                          homeController.currentSelectedMedia = null;
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CustomLoadingPopup());
                          var images = await homeController.pickImages();

                          Navigator.pop(context);

                          homeController.currentSelectedMedia != null
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StoryDesignerScreen(
                                        mediaPath:
                                            homeController.currentSelectedMedia!,
                                        index: 0),
                                  ))
                              : null;
                        } else {
                          print("permission ");
                        }
                      },
                      child: Container(
                        child: Image.asset("assets/icons/add_post.png",
                            width: 9 * SizeConfig.widthMultiplier,
                            height: 5 * SizeConfig.heightMultiplier,
                            fit: BoxFit.fill),
                      ),
                    ),
                    SizedBox(
                      height: 2 * SizeConfig.heightMultiplier,
                    ),
                    CustText(
                      name: "Create",
                      size: 1.4,
                      colors: colorWhite,
                      fontWeightName: FontWeight.w500,
                    ),
                    SizedBox(
                      height: 1 * SizeConfig.heightMultiplier,
                    ),
                  ],
                ),
              ),
            ),*/
           /*   bottomNavigationBar:
              GetBuilder<HomeController>(
                init: HomeController(),
                builder: (controller) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 11.5 * SizeConfig.heightMultiplier,
                        // color: colorBlack,
                        color: Colors.grey,
                        child: Padding(
                          padding:  EdgeInsets.only(bottom: 2 * SizeConfig.heightMultiplier),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: (){
                                  homeController.onItemTapped(0);
                                },
                                child: Container(
                                  width: 20 * SizeConfig.widthMultiplier,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[

                                      SvgPicture.asset(
                                        "assets/icons/home_icon.svg",
                                        color: homeController.selectedIndex ==0?colorPrimary:colorWhite,
                                        fit: BoxFit.fill,
                                        height: 3.5 * SizeConfig.heightMultiplier,
                                        width: 5 * SizeConfig.widthMultiplier,
                                      ),
                                      CustText(
                                        name: "Home",
                                        size: 1.4,
                                        colors: homeController.selectedIndex ==0?colorPrimary:colorWhite,
                                        fontWeightName: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  homeController.onItemTapped(1);
                                },
                                child: Container(
                                  width: 20 * SizeConfig.widthMultiplier,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        "assets/icons/discover_icon.svg",
                                        color: homeController.selectedIndex ==1?colorPrimary:colorWhite,
                                        fit: BoxFit.fill,
                                        height: 3.5 * SizeConfig.heightMultiplier,
                                        width: 5 * SizeConfig.widthMultiplier,
                                      ),
                                      CustText(
                                        name: "Discover",
                                        size: 1.4,
                                        colors: homeController.selectedIndex ==1?colorPrimary:colorWhite,
                                        fontWeightName: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 20 * SizeConfig.widthMultiplier,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[

                                    GestureDetector(
                                      onTap: () async {
                                        ///For Check permission..

                                        if (await homeController.checkPermission()) {
                                          homeController.currentSelectedMedia = null;
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CustomLoadingPopup());
                                          var images = await homeController.pickImages();

                                          Navigator.pop(context);

                                          homeController.currentSelectedMedia != null
                                              ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => StoryDesignerScreen(
                                                    mediaPath:
                                                    homeController.currentSelectedMedia!,
                                                    index: 0),
                                              ))
                                              : null;
                                        } else {
                                          print("permission ");
                                        }
                                      },
                                      child: Container(
                                        child: Image.asset("assets/icons/add_post.png",
                                            width: 10 * SizeConfig.widthMultiplier,
                                            height: 5.5 * SizeConfig.heightMultiplier,
                                            fit: BoxFit.fill),
                                      ),
                                    ),
                                    SizedBox(height: 1.6 * SizeConfig.heightMultiplier),
                                    CustText(
                                      name: "Create",
                                      size: 1.4,
                                      colors: colorWhite,
                                      fontWeightName: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  homeController.onItemTapped(3);

                                },
                                child: Container(
                                  width: 20 * SizeConfig.widthMultiplier,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[

                                      SvgPicture.asset(
                                        "assets/icons/notification_icon.svg",
                                        color: homeController.selectedIndex ==3?colorPrimary:colorWhite,
                                        fit: BoxFit.fill,
                                        height: 3.5 * SizeConfig.heightMultiplier,
                                        width: 5 * SizeConfig.widthMultiplier,
                                      ),
                                      CustText(
                                        name: "Notification",
                                        size: 1.4,
                                        colors: homeController.selectedIndex ==3?colorPrimary:colorWhite,
                                        fontWeightName: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  homeController.onItemTapped(4);
                                },
                                child: Container(
                                  width: 20 * SizeConfig.widthMultiplier,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        width: 6 * SizeConfig.widthMultiplier,
                                        height: 3.5 * SizeConfig.heightMultiplier,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: profileController.image != null
                                                ? FileImage(profileController.image!)
                                                : (profileController.profileImg != null)
                                                ? NetworkImage(profileController.profileImgUrl)
                                                : AssetImage("assets/images/no_profile.png")
                                            as ImageProvider,
                                            // Use NetworkImage for network images
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      CustText(
                                        name: "Profile",
                                        size: 1.4,
                                        colors: homeController.selectedIndex ==4?colorPrimary:colorWhite,
                                        fontWeightName: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],),
                        ),
                      ),
                    ],
                  );
                }
              )*/
              bottomNavigationBar: GetBuilder<HomeController>(
          init: HomeController(),
          builder: (controller) {
            return Container(
              height: 8.5 * SizeConfig.heightMultiplier,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  // Bottom Navigation Bar
                  Container(
                    height: 8.5 * SizeConfig.heightMultiplier,
                    color: bottomBarColor,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2 * SizeConfig.heightMultiplier),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Home Button
                          InkWell(
                            onTap: () {
                              homeController.onBottomOptionTapped(0);
                            },
                            child: Container(
                              width: 20 * SizeConfig.widthMultiplier,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    "assets/icons/home_icon.svg",
                                    color: homeController.selectedIndex == 0 ? colorPrimary : colorWhite,
                                    fit: BoxFit.fill,
                                    height: 3.5 * SizeConfig.heightMultiplier,
                                    width: 5 * SizeConfig.widthMultiplier,
                                  ),
                                  CustText(
                                    name: "Home",
                                    size: 1.4,
                                    colors: homeController.selectedIndex == 0 ? colorPrimary : colorWhite,
                                    fontWeightName: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Discover Button
                          InkWell(
                            onTap: () {
                              homeController.onBottomOptionTapped(1);
                            },
                            child: Container(
                              width: 20 * SizeConfig.widthMultiplier,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    "assets/icons/discover_icon.svg",
                                    color: homeController.selectedIndex == 1 ? colorPrimary : colorWhite,
                                    fit: BoxFit.fill,
                                    height: 3.5 * SizeConfig.heightMultiplier,
                                    width: 5 * SizeConfig.widthMultiplier,
                                  ),
                                  CustText(
                                    name: "Discover",
                                    size: 1.4,
                                    colors: homeController.selectedIndex == 1 ? colorPrimary : colorWhite,
                                    fontWeightName: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Spacer for Create Button
                          InkWell(
                              onTap: () async {
                                // homeController.onItemTapped(0);
                                print("Inkwellcalled ${ homeController.homeWaglStoryItems[storyViewIndex].controller.playbackNotifier.isPaused}");
                                if (await homeController.checkPermission()) {

                                print("here dispose 2 ${ homeController.homeWaglStoryItems[storyViewIndex].controller.playbackNotifier.isPaused}");
                                homeController.currentSelectedMedia = null;

                                showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                CustomLoadingPopup());
                                var images = await homeController.pickImages();
                                homeController.onBottomOptionTapped(4);
                                Navigator.pop(context);
                                // homeController.homeWaglStoryItems[storyViewIndex].controller.pause();
                                homeController.update();
                                print("here pause tapped 2");
                                print("here dispose 2 ${ homeController.homeWaglStoryItems[storyViewIndex].controller.playbackNotifier.isPaused}");
                                homeController.currentSelectedMedia != null
                                ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) => StoryDesignerScreen(
                                mediaPath:
                                homeController.currentSelectedMedia!,
                                index: 0),
                                ))

                                    : null;
                                homeController.homeWaglStoryItems[storyViewIndex].controller.pause();
                                homeController.onBottomOptionTapped(4);
                                print("here pause 3");
                                homeController.homeWaglStoryItems[storyViewIndex].controller.previous();
                                print("here dispose 2 ${ homeController.homeWaglStoryItems[storyViewIndex].controller.previous}");
                                } else {
                                  homeController.onBottomOptionTapped(0);
                                print("permission ");
                                }
                                // homeController.onItemTapped(0);
                              },
                              child: Container(width: 20 * SizeConfig.widthMultiplier,color: Colors.transparent,height: 20*SizeConfig.heightMultiplier,),),
                          // Notifications Button
                          InkWell(
                            onTap: () {
                              homeController.onBottomOptionTapped(3);
                            },
                            child: Container(
                              width: 20 * SizeConfig.widthMultiplier,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    "assets/icons/notification_icon.svg",
                                    color: homeController.selectedIndex == 3 ? colorPrimary : colorWhite,
                                    fit: BoxFit.fill,
                                    height: 3.5 * SizeConfig.heightMultiplier,
                                    width: 5 * SizeConfig.widthMultiplier,
                                  ),
                                  CustText(
                                    name: "Notifications",
                                    size: 1.4,
                                    colors: homeController.selectedIndex == 3 ? colorPrimary : colorWhite,
                                    fontWeightName: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Profile Button
                          InkWell(
                            onTap: () {
                              homeController.onBottomOptionTapped(4);
                            },
                            child: Container(
                              width: 20 * SizeConfig.widthMultiplier,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    width: 6 * SizeConfig.widthMultiplier,
                                    height: 3.5 * SizeConfig.heightMultiplier,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
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
                                  CustText(
                                    name: "Profile",
                                    size: 1.4,
                                    colors: homeController.selectedIndex == 4 ? colorPrimary : colorWhite,
                                    fontWeightName: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Create Button (Floating)
                  Positioned(
                    top: -1.5 * SizeConfig.heightMultiplier,
                    left: MediaQuery.of(context).size.width / 2 - (10 * SizeConfig.widthMultiplier),
                    child:Container(
                      width: 20 * SizeConfig.widthMultiplier,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[

                          GestureDetector(
                            onTap: () async {
                              ///For Check permission..
                              // homeController.homeWaglStoryItems[storyViewIndex].controller.previous();
                              // homeController.homeWaglStoryItems[storyViewIndex].controller.pause();
                              homeController.pauseWagl();

                              print("here pause 1");
                              homeController.update();
                              if (await homeController.checkPermission()) {

                                // print("here dispose 2 ${ homeController.homeWaglStoryItems[storyViewIndex].controller.playbackNotifier.isPaused}");
                                homeController.currentSelectedMedia = null;
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CustomLoadingPopup());
                                // homeController.onItemTapped(4);
                                var images = await homeController.pickImages();
                                Navigator.pop(context);
                                homeController.onBottomOptionTapped(0);
                                // homeController.homeWaglStoryItems[storyViewIndex].controller.pause();
                                homeController.update();
                                print("here pause 2");
                                // print("here dispose 2 ${ homeController.homeWaglStoryItems[storyViewIndex].controller.playbackNotifier.isPaused}");
                                homeController.onBottomOptionTapped(4);
                                if(homeController.currentSelectedMedia != null){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StoryDesignerScreen(
                                            mediaPath:
                                            homeController.currentSelectedMedia,
                                            index: 0),
                                      ));
                                  homeController.onBottomOptionTapped(4);
                                }
                                homeController.onBottomOptionTapped(4);

                                // homeController.homeWaglStoryItems[storyViewIndex].controller.pause();
                                print("here pause 3");
                                // homeController.homeWaglStoryItems[storyViewIndex].controller.previous();
                                // print("here dispose 2 ${ homeController.homeWaglStoryItems[storyViewIndex].controller.previous}");
                              } else {
                                homeController.onBottomOptionTapped(0);
                                print("permission ");
                              }
                              // homeController.onItemTapped(0);
                            },
                            child: Container(
                              child: Image.asset("assets/icons/add_post.png",
                                  width: 10 * SizeConfig.widthMultiplier,
                                  height: 5.5 * SizeConfig.heightMultiplier,
                                  fit: BoxFit.fill),
                            ),
                          ),
                          SizedBox(height: 1.0 * SizeConfig.heightMultiplier),
                          CustText(
                            name: "Create",
                            size: 1.4,
                            colors: colorWhite,
                            fontWeightName: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        )

            /*  BottomAppBar(
              color: colorBlack,
              height: 8 * SizeConfig.heightMultiplier,

              shape: const CircularNotchedRectangle(),
              notchMargin: 8.0,
              child: BottomNavigationBar(

                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                unselectedLabelStyle: TextStyle(
                  fontFamily: "Gilroy",
                  color: colorGrey,
                  fontWeight: FontWeight.w500,
                  fontSize: 1.4 * SizeConfig.textMultiplier,
                ),

                unselectedItemColor: Colors.white,
                selectedItemColor: colorPrimary,
                showUnselectedLabels: true,
                unselectedFontSize: 1.6 * SizeConfig.textMultiplier,
                selectedLabelStyle: TextStyle(
                  fontFamily: "Gilroy",
                  color: colorPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 1.5 * SizeConfig.textMultiplier,
                ),
                // fixedColor: colorBlack,
                backgroundColor: colorBlack,
                items: [
                  BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(
                      "assets/icons/home_icon.svg",
                      color: colorPrimary,
                      fit: BoxFit.fill,
                      height: 4 * SizeConfig.heightMultiplier,
                      width: 5 * SizeConfig.widthMultiplier,
                    ),
                    icon: SvgPicture.asset(
                      "assets/icons/home_icon.svg",
                      color: colorWhite,
                      fit: BoxFit.fill,
                      height: 4 * SizeConfig.heightMultiplier,
                      width: 5 * SizeConfig.widthMultiplier,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(
                      "assets/icons/discover_icon.svg",
                      color: colorPrimary,
                      fit: BoxFit.fill,
                      height: 4 * SizeConfig.heightMultiplier,
                      width: 5 * SizeConfig.widthMultiplier,
                    ),
                    icon: SvgPicture.asset(
                      "assets/icons/discover_icon.svg",
                      color: colorWhite,
                      fit: BoxFit.fill,
                      height: 4 * SizeConfig.heightMultiplier,
                      width: 5 * SizeConfig.widthMultiplier,
                    ),
                    label: 'Discover',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(
                      "assets/icons/notification_icon.svg Notification ",
                      color: colorPrimary,
                      fit: BoxFit.fill,
                      height: 4 * SizeConfig.heightMultiplier,
                      width: 5 * SizeConfig.widthMultiplier,
                    ),
                    icon: SvgPicture.asset(
                      "assets/icons/notification_icon.svg",
                      color: colorWhite,
                      fit: BoxFit.fill,
                      height: 4 * SizeConfig.heightMultiplier,
                      width: 5 * SizeConfig.widthMultiplier,
                    ),
                    label: 'Notification',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      width: 8 * SizeConfig.widthMultiplier,
                      height: 4 * SizeConfig.heightMultiplier,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: profileController.image != null
                              ? FileImage(profileController.image!)
                              : (profileController.profileImg != null)
                                  ? NetworkImage(profileController.profileImgUrl)
                                  : AssetImage("assets/images/no_profile.png")
                                      as ImageProvider,
                          // Use NetworkImage for network images
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    label: 'Profile',
                  ),
                ],
                type: BottomNavigationBarType.fixed,
              ),
            ),*/

          ),
        ),
      ),
    );
  }

/* @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorBlack,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          GetBuilder<HomeController>(builder: (homeController) {
        return GestureDetector(
          onTap: () async {

            homeController.currentSelectedMedia = null;
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomLoadingPopup());
            var images = await homeController.pickImages();

            Navigator.pop(context);
           */ /*  ImagePickerPlus picker = ImagePickerPlus(context);

            homeController.details = await picker.pickImage(
              source: ImageSource.gallery,
              multiImages: true,
              // multiSelection: true,

              galleryDisplaySettings: GalleryDisplaySettings(
                appTheme: AppTheme(
                    focusColor: Colors.white, primaryColor: Colors.black),
                cropImage: true,
                // callbackFunction: (value) => homeController.pickImages(value),
                // gridDelegate: _sliverGrid3Delegate(),
              ),

            );*/ /*
// homeController.pickImagesCustom();

*/ /*            print("Here is ${homeController.details!.selectedFiles.length}");
            print("Here is ${homeController.details!.selectedFiles.length}");*/ /*
            homeController.currentSelectedMedia != null
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => */ /*homeController.currentSelectedMedia == null
                      images==false ? CustomLoadingPopup()
                      : */ /*
                              StoryDesignerScreen(
                                  mediaPath:
                                      homeController.currentSelectedMedia!,
                                  index: 0),
                    ))
                : ();
            // if (homeController.details != null) await displayDetails(homeController.details,context);
            // homeController.updateImages();
          },
          child: Container(
            // height: 13*SizeConfig.heightMultiplier,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: Image.asset("assets/icons/add_post.png",
                      width: 9 * SizeConfig.widthMultiplier,
                      height: 5 * SizeConfig.heightMultiplier,
                      fit: BoxFit.fill),
                ),
                SizedBox(
                  height: 1 * SizeConfig.heightMultiplier,
                ),
                // Space between button and text
                CustText(
                  name: "Create",
                  size: 1.4,
                  colors: colorWhite,
                  fontWeightName: FontWeight.w500,
                ),
                SizedBox(
                  height: 1 * SizeConfig.heightMultiplier,
                ),
              ],
            ),
          ),
        );
      }),
      body: SafeArea(
        child: GetBuilder<HomeController>(
          builder: (homeController) {
            return children[homeController.selectedHomeIndex];
          },
        ),
      ),
      bottomNavigationBar: GetBuilder<HomeController>(
        builder: (homeController) {
          return Stack(
            children: [
              BottomNavigationBar(
                onTap: (index) {
                  if (index == 0) {
                    print("here you can update data");
                    // homeController.getAllWagls(0);
                    // homeController.getHomeFeedWagl();
                    // homeController.getHomeFeedWagl();
                    homeController.changeTabIndex(index);
                    profileController.updateProfilePage(true);
                  }
                  if (index == 1) {
                    print("here you can update data");
                    var discoverController = Get.put(Get.put(DiscoverController()));
                    discoverController.getAllCategory();
                    discoverController.updateSearch();
                  }
                  if (index == 3) {
                    print("here you can update data");
                    var notificationController =
                    Get.put(NotificationController());
                    notificationController.getNotificationDetails();
                  }
                  if (index == 4) {
                    print("here you can getUsersWagl data");
                    profileController.getProfileDetails(0);
                    profileController.getUsersWagl(0);
                  }
                  print("index $index");
                  homeController.changeTabIndex(index);
                  profileController.updateProfilePage(true);
                  // profileController.update();
                },
                unselectedLabelStyle: TextStyle (
                  fontFamily: "Gilroy",
                  color: colorGrey,
                  fontWeight: FontWeight.w500,
                  fontSize: 1.4 * SizeConfig.textMultiplier,
                ),
                unselectedItemColor: Colors.white,
                selectedItemColor: colorPrimary,
                showUnselectedLabels: true,
                unselectedFontSize: 1.6 * SizeConfig.textMultiplier,
                selectedLabelStyle: TextStyle(
                  fontFamily: "Gilroy",
                  color: colorPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 1.5 * SizeConfig.textMultiplier,
                ),
                // fixedColor: colorBlack,
                backgroundColor: colorBlack,
                items: [
                  BottomNavigationBarItem(
                    activeIcon: */ /*GestureDetector(
                      onTap: () {
                       */ /* */ /* homeController.getAllWagls();
                        homeController.getLikedWagls();
                        homeController.getSavedWagls();
                        homeController.getFollowersList();
                        homeController.changeTabIndex(0);*/ /* */ /*
                        // homeController.updateWaglIndex(0);
                      },
                      child:*/ /*
                        SvgPicture.asset(
                      "assets/icons/home_icon.svg",
                      color: colorPrimary,
                      fit: BoxFit.fill,
                      height: 4 * SizeConfig.heightMultiplier,
                      width: 5 * SizeConfig.widthMultiplier,
                    ),
                    // ),
                    icon: */ /*GestureDetector(
                      onTap: () {
                        // homeController.getAllWagls();
                        // homeController.changeTabIndex(0);
                        // // homeController.updateWaglIndex(0);
                        // homeController.changeTabIndex(0);
                      },
                      child:*/ /*
                        SvgPicture.asset(
                      "assets/icons/home_icon.svg",
                      color: colorWhite,
                      fit: BoxFit.fill,
                      height: 4 * SizeConfig.heightMultiplier,
                      width: 5 * SizeConfig.widthMultiplier,
                    ),
                    */ /*    ),*/ /*
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(
                      "assets/icons/discover_icon.svg",
                      color: colorPrimary,
                      fit: BoxFit.fill,
                      height: 4 * SizeConfig.heightMultiplier,
                      width: 5 * SizeConfig.widthMultiplier,
                    ),
                    icon: SvgPicture.asset(
                      "assets/icons/discover_icon.svg",
                      color: colorWhite,
                      fit: BoxFit.fill,
                      height: 4 * SizeConfig.heightMultiplier,
                      width: 5 * SizeConfig.widthMultiplier,
                    ),
                    label: 'Discover',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(
                      "assets/icons/notification_icon.svg",
                      color: colorPrimary,
                      fit: BoxFit.fill,
                      height: 4 * SizeConfig.heightMultiplier,
                      width: 5 * SizeConfig.widthMultiplier,
                    ),
                    icon: SvgPicture.asset(
                      "assets/icons/notification_icon.svg",
                      color: colorWhite,
                      fit: BoxFit.fill,
                      height: 4 * SizeConfig.heightMultiplier,
                      width: 5 * SizeConfig.widthMultiplier,
                    ),
                    label: 'Notification',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      width: 8 * SizeConfig.widthMultiplier,
                      height: 4 * SizeConfig.heightMultiplier,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: profileController.image != null
                              ? FileImage(profileController.image!)
                              : (profileController.profileImg != null)
                                  ? NetworkImage(
                                      profileController.profileImgUrl)
                                  : AssetImage("assets/images/no_profile.png")
                                      as ImageProvider,
                          // Use NetworkImage for network images
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    label: 'Profile',
                  ),
                ],
                currentIndex: homeController.selectedHomeIndex,
                type: BottomNavigationBarType.fixed,
              ),
            ],
          );
        },
      ),
    );
  }*/

// Future<void> displayDetails(SelectedImagesDetails? details, context) async {
//   print("Here :::selectedFiles ${details!.selectedFiles}");
//   await Navigator.of(context).push(
//     MaterialPageRoute(
//       builder: (context) {
//         return DisplayImages(
//             selectedBytes: details.selectedFiles,
//             aspectRatio: details.aspectRatio);
//       },
//     ),
//   );
// }
}

var profileController = Get.put(ProfileController());


