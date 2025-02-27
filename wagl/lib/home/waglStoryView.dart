import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vs_story_designer/vs_story_designer.dart';
import 'package:wagl/home/video_editor/video_editor_view.dart';
import 'package:video_editor/video_editor.dart';
import '../create_wagl/create_wagl_controller.dart';
import '../create_wagl/create_wagl_view.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_text.dart';
import '../custom_widget/custom_loading_popup.dart';
import '../util/SizeConfig.dart';
import 'home_controller.dart';
import 'home_page.dart';

class StoryDesignerScreen extends StatelessWidget {
  String? mediaPath;
  bool? isEditFlag=false;
  final int index;

  StoryDesignerScreen({Key? key, @required this.mediaPath,this.isEditFlag, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // homeController.homeWaglStoryItems[storyViewIndex].controller.pause();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            // flex: homeController.isSelected ? 7 : 10,
            // flex: 10,
            child: Container(
              color: Colors.white,
              child: homeController.currentSelectedMedia!.endsWith(".mp4") ||homeController.currentSelectedMedia!.endsWith(".hevc") ||
                  homeController.currentSelectedMedia!.endsWith(".mov")
                  ? VideoEditor(
                index: index,
                file: File(homeController.selectedMedia[index].path),)
                  : VSStoryDesigner(
                centerText: "Start Creating Your Story",
                themeType: ThemeType.dark,
                galleryThumbnailQuality: 250,
                fileName: "wagl-files",
                onDoneButtonStyle: false
                    ? SizedBox()
                    : Padding(
                  padding: EdgeInsets.only(
                      right: 6 * SizeConfig.widthMultiplier),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorPrimary,
                      border: Border.all(
                          color: colorPrimary,
                          width: 0.25 * SizeConfig.widthMultiplier),
                      borderRadius:
                      BorderRadius.all(Radius.circular(
                        2 * SizeConfig.imageSizeMultiplier,
                      )),
                      shape: BoxShape.rectangle,
                    ),
                    width: 25 * SizeConfig.widthMultiplier,
                    height: 4 * SizeConfig.heightMultiplier,
                    child: Center(
                        child: CustText(
                            name: "Save changes",
                            size: 1.4,
                            colors: colorBlack,
                            fontWeightName: FontWeight.w600)),
                  ),
                ),
                onDone: (currentImagePath) async {

                  await homeController.updateImage(
                      index, currentImagePath);

                  // showModalBottomSheet(context: context, builder: (context) => Image.file(File(currentImagePath),));
                  // debugPrint(uri);
                },
                fontFamilyList: const [
                  FontType.abrilFatface,
                  FontType.alegreya,
                  FontType.typewriter,
                  FontType.notoSansGujarati,
                  FontType.openSans,
                ],
                mediaPath: mediaPath,
                // fileName: "",
              ),
            ),
          ),
          /*Container(
            height: 15*SizeConfig.heightMultiplier,
            color: Colors.black,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: homeController.images.map((image) {
                  return GestureDetector(
                    onTap: () {
                      homeController.selectImage(image);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => homeController.selectedImage == null
                              ? CustomLoadingPopup()
                              : StoryDesignerScreen(
                              mediaPath: homeController.selectedImage!.path),
                        ),
                      );
                    },
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 1.0*SizeConfig.widthMultiplier),

                      child: Container(
                        decoration: BoxDecoration(border: Border.all(color: image.path==homeController.selectedImage!.path?colorPrimary:colorBlack,),borderRadius: BorderRadius.circular(2*SizeConfig.widthMultiplier)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical:  0.5*SizeConfig.heightMultiplier,horizontal: 1*SizeConfig.widthMultiplier),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(1.5*SizeConfig.widthMultiplier),
                            child: Image.file(
                              File(image.path),
                              width: 15*SizeConfig.widthMultiplier,
                              height: 13* SizeConfig.heightMultiplier,
                              fit: BoxFit.cover,

                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),

              ),
            ),
          ),*/
          Container(
            height: 15 * SizeConfig.heightMultiplier,
            color: Colors.black,
            child: Row(
              children: [
                SizedBox(
                  width: 2 * SizeConfig.widthMultiplier,
                ),
                GestureDetector(
                  onTap: () {
                    // Get.back();
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 10 * SizeConfig.heightMultiplier,
                    width: 15 * SizeConfig.widthMultiplier,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: borderColor, width: 1)),
                    child: Padding(
                      padding:
                      EdgeInsets.all(2.80 * SizeConfig.heightMultiplier),
                      child: SvgPicture.asset(
                        "assets/icons/left_arrow.svg",
                        color: Colors.white,
                        width: 15 * SizeConfig.widthMultiplier,
                        height: 5 * SizeConfig.heightMultiplier,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 10 * SizeConfig.heightMultiplier,
                  width: 66 * SizeConfig.widthMultiplier,
                  child: /*SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child:*/ /*Row(
                      children: homeController.images.map((image) {
                        return GestureDetector(
                          onTap: () {
                            homeController.selectImage(image);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    homeController.selectedImage == null
                                        ? CustomLoadingPopup()
                                        : StoryDesignerScreen(
                                            mediaPath: homeController
                                                .selectedImage!.path),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 1.0 * SizeConfig.widthMultiplier),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: image.path ==
                                          homeController.selectedImage!.path
                                      ? colorPrimary
                                      : colorBlack,
                                ),
                                borderRadius: BorderRadius.circular(
                                    2 * SizeConfig.widthMultiplier),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 0.5 * SizeConfig.heightMultiplier,
                                  horizontal: 1 * SizeConfig.widthMultiplier,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      1.5 * SizeConfig.widthMultiplier),
                                  child: Image.file(
                                    File(image.path),
                                    width: 15 * SizeConfig.widthMultiplier,
                                    height: 13 * SizeConfig.heightMultiplier,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),*/
                  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: homeController.selectedMedia.length,
                    itemBuilder: (context, index) {
                      final image = homeController.selectedMedia[index];
                      homeController.changedImagesAll;
                      return GestureDetector(
                        onTap: () {
                          final CreateWaglController createWaglController =
                          Get.put(CreateWaglController());
                          createWaglController.pauseVideo();
                          homeController.selectImage(index);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              homeController.currentSelectedMedia == null
                                  ? CustomLoadingPopup()
                                  : StoryDesignerScreen(
                                  mediaPath: homeController
                                      .currentSelectedMedia!,
                                  index: index,isEditFlag: isEditFlag),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 1.0 * SizeConfig.widthMultiplier),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: image.path ==
                                    homeController.currentSelectedMedia!
                                    ? colorPrimary
                                    : colorBlack,
                              ),
                              borderRadius: BorderRadius.circular(
                                  2 * SizeConfig.widthMultiplier),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 0.5 * SizeConfig.heightMultiplier,
                                horizontal: 0.5 * SizeConfig.widthMultiplier,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    1.5 * SizeConfig.widthMultiplier),
                                child: (homeController.selectedMedia[index].path
                                    .endsWith('.mp4')||homeController.selectedMedia[index].path
                                    .endsWith('.hevc')||homeController.selectedMedia[index].path
                                    .endsWith('.mov'))
                                    ? (homeController.changedImagesAll[index]
                                    .endsWith(".mp4")||homeController.changedImagesAll[index]
                                    .endsWith(".hevc")||homeController.changedImagesAll[index]
                                    .endsWith(".mov"))
                                    ? Container(
                                  width:
                                  15 * SizeConfig.widthMultiplier,
                                  height: 14 *
                                      SizeConfig.heightMultiplier,
                                  color: borderColor,
                                  child: Center(
                                      child: CustText(
                                        name: "Tap to trim video",
                                        fontWeightName: FontWeight.w500,
                                        colors: colorWhite,
                                        size: 1.2,
                                        textAlign: TextAlign.center,
                                      )),
                                )
                                    : Image.file(
                                  File(homeController
                                      .changedImagesAll[index]),
                                  width:
                                  15 * SizeConfig.widthMultiplier,
                                  height: 13 *
                                      SizeConfig.heightMultiplier,
                                  fit: BoxFit.cover,
                                ) /*AspectRatio(
                                    aspectRatio: homeController.videoPlayerControllers![index].value.aspectRatio,
                                    child: VideoPlayer(homeController.videoPlayerControllers![index]),
                                  )*/
                                    : Image.file(
                                  File(image.path),
                                  width: 15 * SizeConfig.widthMultiplier,
                                  height:
                                  13 * SizeConfig.heightMultiplier,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // ),
                ),
                GestureDetector(
                  onTap: () async {
                    if(isEditFlag!=null){
                      print("create wagl isEditFlag");
                      var createWaglController = Get.put(
                          CreateWaglController());

                      await createWaglController
                          .getChangedImages(homeController.changedImages);
                      await createWaglController
                          .getChangedVideos(homeController.changedVideos);
                      await createWaglController
                          .getChangedMedia(homeController.changedThumnails());
                      await createWaglController
                          .getChangedThumbnails(homeController.changedThumnails());
                      await createWaglController.addNewImages(homeController.changedImagesAll);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateWaglView(isEdit: true),
                        ),
                      );
                    }else {
                      print("create wagl Navigate");
                      homeController.update();
                      var createWaglController = Get.put(
                          CreateWaglController());
                      createWaglController.pauseVideo();
                      createWaglController.clearData();
                      await createWaglController
                          .getChangedImages(homeController.changedImages);
                      await createWaglController
                          .getChangedVideos(homeController.changedVideos);
                      await createWaglController
                          .getChangedMedia(homeController.changedThumnails());
                      await createWaglController.clearBrandName();
                      // Get.to(() => CreateWaglView(isEdit: false));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CreateWaglView(isEdit: false)),
                      );
                      createWaglController.pauseVideo();
                    }
                  },
                  child: Container(
                    height: 10 * SizeConfig.heightMultiplier,
                    width: 15 * SizeConfig.widthMultiplier,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: borderColor, width: 1),
                        color: homeController.selectedMedia[index].path ==
                            homeController.selectedMedia[index].path
                            ? colorPrimary
                            : colorPrimary),
                    child: Padding(
                      padding:
                      EdgeInsets.all(2.80 * SizeConfig.heightMultiplier),
                      child: SvgPicture.asset(
                        "assets/icons/right_arrow.svg",
                        color: Colors.black,
                        width: 15 * SizeConfig.widthMultiplier,
                        height: 5 * SizeConfig.heightMultiplier,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 2 * SizeConfig.widthMultiplier,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}