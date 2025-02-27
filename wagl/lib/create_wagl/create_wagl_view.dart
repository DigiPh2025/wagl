import 'dart:io';
import 'dart:ui';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:wagl/create_wagl/add_product_view.dart';
import 'package:wagl/create_wagl/good_tag_view.dart';
import 'package:wagl/create_wagl/select_product_view.dart';
import 'package:wagl/custom_widget/cust_appbar.dart';
import 'package:wagl/custom_widget/cust_button_with_icon_last.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import 'package:wagl/profile/profile_controller.dart';
import 'package:wagl/profile/profile_view.dart';
import 'package:wagl/util/SizeConfig.dart';
import '../custom_widget/Strings.dart';
import '../custom_widget/blur_back_button.dart';
import '../custom_widget/check_internet.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_container.dart';
import '../custom_widget/custom_loading_popup.dart';
import '../custom_widget/progress_bar_wagl.dart';
import '../home/home_controller.dart';
import '../home/home_model.dart';
import '../home/home_page.dart';
import '../home/waglStoryView.dart';
import '../register/search_google_places.dart';
import 'categories_tag_view.dart';
import 'create_wagl_controller.dart';

class CreateWaglView extends StatelessWidget {
  var waglData ;
  bool isEdit = false;
  final CreateWaglController createWaglController =
      Get.put(CreateWaglController());

  CreateWaglView({super.key, required this.isEdit,this.waglData});

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: GetBuilder<CreateWaglController>(
          init: CreateWaglController(),
          builder: (controller) => Column(
                children: [
                  CustAppbar(title: isEdit ? "Edit" : "Review", icon: true),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2 * SizeConfig.widthMultiplier),
                        child: Container(
                          width: 100 * Checkbox.width,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 1*SizeConfig.heightMultiplier,),
                                Container(
                                  child: SizedBox(
                                    height: 20 * SizeConfig.heightMultiplier,
                                    width: 100 * SizeConfig.widthMultiplier,
                                    child: /*SingleChildScrollView(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children:
                                            homeController.images.map((image) {
                                          return GestureDetector(
                                            onTap: (){
                                              print("object");
                                              for(int i=0;i<homeController.images.length;i++){
                                                print("${homeController.images[i].path}\n\n");
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(2 *
                                                        SizeConfig
                                                            .widthMultiplier)),
                                                child: Image.file(
                                                  File(image.path),
                                                  width: 20 *
                                                      SizeConfig.widthMultiplier,
                                                  height: 45 *
                                                      SizeConfig.heightMultiplier,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),*/
                                        isEdit
                                            ? ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                // Maintain horizontal scrolling
                                                itemCount: createWaglController
                                                    .addEditedMedia.length+1,
                                                itemBuilder: (context, index) {

                                                  // File? thumbnailFile = createWaglController.generateVideoThumbnail(image);
                                                 if(index!=createWaglController
                                                     .addEditedMedia.length){
                                                   var image =
                                                   createWaglController
                                                       .addEditedMedia[index];
                                                   var imageType=createWaglController
                                                       .addEditedMedia[index].runtimeType;
                                                   return Padding(
                                                     padding: const EdgeInsets
                                                         .symmetric(
                                                         horizontal: 4.0),
                                                     child: ClipRRect(
                                                       borderRadius:
                                                       BorderRadius.all(
                                                         Radius.circular(2 *
                                                             SizeConfig
                                                                 .widthMultiplier),
                                                       ),
                                                       child: /*createWaglController
                                                  .mediaListEdit[index]
                                                  .endsWith('.mp4')
                                                  ? Container()
                                                  : */
                                                       Stack(
                                                         children: [
                                                           imageType==String?Image.network(
                                                             image,
                                                             width: 25 *
                                                                 SizeConfig
                                                                     .widthMultiplier,
                                                             height: 45 *
                                                                 SizeConfig
                                                                     .heightMultiplier,
                                                             fit: BoxFit.cover,
                                                             loadingBuilder:
                                                                 (BuildContext
                                                             context,
                                                                 Widget child,
                                                                 ImageChunkEvent?
                                                                 loadingProgress) {
                                                               if (loadingProgress ==
                                                                   null) {
                                                                 return child; // Image is loaded, show the image
                                                               } else {
                                                                 return Container(
                                                                   width: 25 *
                                                                       SizeConfig
                                                                           .widthMultiplier,
                                                                   height: 45 *
                                                                       SizeConfig
                                                                           .heightMultiplier,
                                                                   child: Center(
                                                                     child: CircularProgressIndicator(
                                                                       value: loadingProgress
                                                                           .expectedTotalBytes !=
                                                                           null
                                                                           ? loadingProgress
                                                                           .cumulativeBytesLoaded /
                                                                           loadingProgress
                                                                               .expectedTotalBytes!
                                                                           : null,
                                                                       color:
                                                                       colorPrimary,
                                                                       backgroundColor:
                                                                       backgroundLightColor,
                                                                     ),
                                                                   ),
                                                                 ); // Image is loading, show the loader
                                                               }
                                                             },
                                                             errorBuilder:
                                                                 (BuildContext
                                                             context,
                                                                 Object error,
                                                                 StackTrace?
                                                                 stackTrace) {
                                                               return Container(
                                                                 child: Center(child: Image.file(File(image), width: 25 *
                                                                     SizeConfig
                                                                         .widthMultiplier,
                                                                   height: 45 *
                                                                       SizeConfig
                                                                           .heightMultiplier,fit: BoxFit.cover,)),
                                                               ); // Handle error
                                                               // return Text('Failed to load image'); // Handle error
                                                             },
                                                           ):Padding(
                                                             padding: const EdgeInsets
                                                                 .symmetric(
                                                                 horizontal: 4.0),
                                                             child: ClipRRect(
                                                               borderRadius:
                                                               BorderRadius.all(
                                                                 Radius.circular(2 *
                                                                     SizeConfig
                                                                         .widthMultiplier),
                                                               ),
                                                               child: image
                                                                   .path
                                                                   .endsWith(
                                                                   '.mp4') ||
                                                                   image
                                                                       .path
                                                                       .endsWith(
                                                                       '.mov')||
                                                                   image
                                                                       .path
                                                                       .endsWith(
                                                                       '.hevc')
                                                                   ?controller.videoPlayerController != null &&
                                                                   controller.videoPlayerController!.value.isInitialized?
                                                               AspectRatio(
                                                                   aspectRatio:
                                                                   controller.videoPlayerController!.value.aspectRatio,
                                                                   child: VideoPlayer(controller.videoPlayerController!)):Container()/* Image.file(File(
                                                                   image
                                                                       .path),     width: 25 *
                                                                   SizeConfig
                                                                       .widthMultiplier,
                                                                 height: 50 *
                                                                     SizeConfig
                                                                         .heightMultiplier,
                                                                 fit: BoxFit
                                                                     .cover,
                                                               )*/
                                                                   : Image.file(
                                                                 File(image.path),
                                                                 width: 25 *
                                                                     SizeConfig
                                                                         .widthMultiplier,
                                                                 height: 45 *
                                                                     SizeConfig
                                                                         .heightMultiplier,
                                                                 fit: BoxFit
                                                                     .cover,
                                                               ),
                                                             ),
                                                           ),
                                                           (createWaglController.mediaListEdit.length>1)&&(imageType==String)? Positioned(
                                                             right: 0,
                                                             top: 0,
                                                             child: GestureDetector(
                                                               onTap: (){

                                                                 //  print("here is the object id ${createWaglController.getID(index)}");
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
                                                                                       CustText(name: "Delete wagl media", size: 1.8, colors: colorWhite, fontWeightName: FontWeight.w600),
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
                                                                                       SizedBox(width: 60 * SizeConfig.widthMultiplier, child: CustText(name: "Are you sure you want to delete this media of Wagl?", size: 1.6, colors: colorWhite, fontWeightName: FontWeight.w500, textAlign: TextAlign.center)),
                                                                                       const Spacer(),
                                                                                       Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                                                         GestureDetector(
                                                                                           onTap: () async {
                                                                                             Navigator.pop(context);

                                                                                             createWaglController.getID(index);

// createWaglController.removeIndexFile(F);
                                                                                             // createWaglController.removeMediaWagl(waglData,0,index);

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
                                                                                                               CustText(name: "Your wagl media deleted successfully", size: 1.8, colors: colorWhite, fontWeightName: FontWeight.w600),
                                                                                                               const Spacer(),
                                                                                                               Padding(
                                                                                                                 padding: EdgeInsets.symmetric(horizontal: 2 * SizeConfig.widthMultiplier),
                                                                                                                 child: GestureDetector(
                                                                                                                   onTap: () {

                                                                                                                     Navigator.pop(context);
                                                                                                                     // Navigator.pop(context);


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
                                                                                             /* homeController.deleteWagl(waglData[index].waglId, isDiscover, isSaved);
                                                                                              waglData.removeAt(index);*/
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

                                                               },
                                                               child: Container(
                                                                 height: 2*SizeConfig.heightMultiplier,
                                                                 width: 4.5*SizeConfig.widthMultiplier,
                                                                 decoration: BoxDecoration(   color: colorPrimary,  borderRadius:
                                                                 BorderRadius.all(
                                                                   Radius.circular(1 *
                                                                       SizeConfig
                                                                           .widthMultiplier),
                                                                 ),),

                                                                 child: Center(
                                                                   child: SvgPicture.asset("assets/icons/close_svg.svg",width: 1*SizeConfig.widthMultiplier,height: 1*SizeConfig.heightMultiplier,color: colorBlack),
                                                                 ),
                                                               ),
                                                             ),
                                                           ):Container(),
                                                         ],
                                                       ),
                                                     ),
                                                   );
                                                 }else{
                                                   return GestureDetector(
                                                     onTap: () async {
                                                       // Handle add new image logic here
                                                       print("Add new image tapped");
                                                       for(int i=0;i<createWaglController.fileImages.length;i++){
                                                       print("here the fileimages path ${createWaglController.fileImages[i].path} \n\n ");
                                                       print("here the fileimages endsWith ${createWaglController.fileImages[i].path.endsWith(".mp4")}");

                                                       }
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
                                                         print("here pause 2  Navigator.pop(context);");
                                                         // homeController.onItemTapped(4);
                                                         // homeController.homeWaglStoryItems[storyViewIndex].controller.pause();
                                                         homeController.update();
                                                         print("here pause 2");
                                                         // print("here dispose 2 ${ homeController.homeWaglStoryItems[storyViewIndex].controller.playbackNotifier.isPaused}");
                                                         // homeController.onItemTapped(4);

                                                         homeController.currentSelectedMedia != null?Get.off(StoryDesignerScreen(
                                                             mediaPath:
                                                             homeController.currentSelectedMedia,
                                                             isEditFlag: true,
                                                             index: 0)):null;

                                                       /*  homeController.currentSelectedMedia != null

                                                             ? Navigator.push(
                                                             context,
                                                             MaterialPageRoute(
                                                               builder: (context) => StoryDesignerScreen(
                                                                   mediaPath:
                                                                   homeController.currentSelectedMedia,
                                                                   index: 0),
                                                             ))

                                                             : null;
*/                                                         // homeController.homeWaglStoryItems[storyViewIndex].controller.pause();
                                                         print("here pause 3");
                                                         // homeController.homeWaglStoryItems[storyViewIndex].controller.previous();
                                                         // print("here dispose 2 ${ homeController.homeWaglStoryItems[storyViewIndex].controller.previous}");
                                                       } else {
                                                         homeController.onBottomOptionTapped(0);
                                                         print("permission ");
                                                       }
                                                     },
                                                     child: Container(
                                                       width: 25 * SizeConfig.widthMultiplier,
                                                       height: 45 * SizeConfig.heightMultiplier,
                                                       decoration: BoxDecoration(
                                                         border: Border.all(color: colorPrimary,),
                                                         color: colorGreyDark, // Placeholder color
                                                         borderRadius: BorderRadius.circular(2 * SizeConfig.widthMultiplier),
                                                       ),
                                                       child: Icon(Icons.add, size: 30, color: colorWhite), // Add icon
                                                     ),
                                                   );
                                                 }
                                                },
                                              )
                                            : ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                // Maintain horizontal scrolling
                                                itemCount: createWaglController
                                                    .fileImages.length,
                                                itemBuilder: (context, index) {
                                                  var image =
                                                      createWaglController
                                                          .fileImages[index]
                                                          .path;

                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 4.0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(2 *
                                                            SizeConfig
                                                                .widthMultiplier),
                                                      ),
                                                      child: createWaglController
                                                                  .fileImages[
                                                                      index]
                                                                  .path
                                                                  .endsWith(
                                                                      '.mp4') ||
                                                          createWaglController
                                                              .fileImages[
                                                          index]
                                                              .path
                                                              .endsWith(
                                                              '.mov')||
                                                          createWaglController
                                                              .fileImages[
                                                          index]
                                                              .path
                                                              .endsWith(
                                                              '.hevc')
                                                          ?

                                                      Image.file(File(
                                                              createWaglController
                                                                  .mediaFileList[
                                                                      index]
                                                                  .path),     width: 25 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                        height: 50 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                        fit: BoxFit
                                                            .cover,
                                                      )
                                                          : Image.file(
                                                              File(image),
                                                              width: 25 *
                                                                  SizeConfig
                                                                      .widthMultiplier,
                                                              height: 45 *
                                                                  SizeConfig
                                                                      .heightMultiplier,
                                                              fit: BoxFit
                                                                  .cover,
                                                            ),
                                                    ),
                                                  );
                                                },
                                              ),
                                  ),
                                  // ),
                                ),
                                SizedBox(
                                  height: 1 * SizeConfig.heightMultiplier,
                                ),
                                Row(
                                  children: [
                                    CustText(
                                        name: descriptionText,
                                        size: 1.4,
                                        colors: colorWhite,
                                        fontWeightName: FontWeight.w600)
                                  ],
                                ),
                                SizedBox(
                                  height: 1 * SizeConfig.heightMultiplier,
                                ),
                                TextField(
                                  maxLines: 6,
                                  style: TextStyle(
                                    fontFamily: "Gilroy",
                                    color: colorWhite,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 1.6 *
                                        SizeConfig.textMultiplier /
                                        scaleFactor,
                                  ),
                                  controller: createWaglController
                                      .descriptionTextController,
                                  cursorColor: colorWhite,
                                  obscureText: false,
                                  onTap: () {
                                    // FocusManager.instance.notifyListeners();
                                  },
                                  onTapOutside: (Value) {
                                    print("ASDASDAS");
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  onChanged: (value) {
                                    print("${value.isNotEmpty}");
                                    if (value.isNotEmpty) {
                                      createWaglController
                                          .updateDescription(false);
                                    } else {
                                      createWaglController
                                          .updateDescription(true);
                                    }
                                  },
                                  textInputAction: TextInputAction.newline,
                                  decoration: InputDecoration(
                                    filled: true,
                                    counterText: "",
                                    contentPadding: EdgeInsets.only(
                                      top: 2 * SizeConfig.heightMultiplier,
                                      left: 2 * SizeConfig.widthMultiplier,
                                      right: 2 * SizeConfig.widthMultiplier,
                                    ),
                                    fillColor: colorBackground,
                                    /*contentPadding: new EdgeInsets.symmetric(
                                                vertical:
                                                2 * SizeConfig.widthMultiplier,
                                                horizontal:
                                                2 * SizeConfig.widthMultiplier),*/
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          2 * SizeConfig.widthMultiplier),
                                      borderSide: const BorderSide(
                                        color: colorPrimary,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          2 * SizeConfig.widthMultiplier),
                                      borderSide: const BorderSide(
                                        color: colorGreyLight2,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          2 * SizeConfig.widthMultiplier),
                                      borderSide: const BorderSide(
                                        color: colorPrimary,
                                        // width: 2.0,
                                      ),
                                    ),
                                    hintText: writeDescriptionText,
                                    hintStyle: TextStyle(
                                      fontFamily: "Gilroy",
                                      color: colorWhite,
                                      fontSize: 1.4 *
                                          SizeConfig.textMultiplier /
                                          scaleFactor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                createWaglController.descriptionText == true
                                    ? CustContainer(
                                        borderColor: Colors.red,
                                        label: "Please enter description",
                                        labelColor: colorWhite,
                                        iconPath: "assets/icons/failed_1.png",
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 2 * SizeConfig.heightMultiplier,
                                ),
                                CustText(
                                  name: "Product",
                                  size: 1.6,
                                  colors: colorWhite,
                                  fontWeightName: FontWeight.w500,
                                ),
                                SizedBox(
                                  height: 2 * SizeConfig.heightMultiplier,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    print("here is the Tap product ");
                                    createWaglController.searchProductController
                                        .clear();
                                    createWaglController.clearList();
                                    createWaglController.clearBrandName();
                                    // Get.to(() => ProductTagView());
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ProductTagView()),
                                    );
                                  },
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(12),
                                    strokeWidth: 1,
                                    color:
                                        createWaglController.isProductSelected
                                            ? colorBlack
                                            : colorBlack_2,
                                    dashPattern: [5],
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      child: Container(
                                        width: 100 * SizeConfig.widthMultiplier,
                                        height: 8 * SizeConfig.heightMultiplier,
                                        color: createWaglController
                                                .isProductSelected
                                            ? colorBlack_2
                                            : colorBlack,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 2 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                  ),
                                                  Container(
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
                                                              HexagonClipper(),
                                                          child: Container(
                                                            width: 11 *
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
                                                        Center(
                                                          child: createWaglController
                                                                      .productImage !=
                                                                  null
                                                              ? Image.file(
                                                                  createWaglController
                                                                      .productImage!,
                                                                  width: 8 *
                                                                      SizeConfig
                                                                          .widthMultiplier,
                                                                  height: 5 *
                                                                      SizeConfig
                                                                          .heightMultiplier,
                                                                  // Adjust the height as needed
                                                                  fit: BoxFit
                                                                      .contain,
                                                                )
                                                              : createWaglController
                                                                          .isProductSelected ==
                                                                      false
                                                                  ? Image.asset(
                                                                      "assets/icons/empty_heza.png",
                                                                      width: 13 *
                                                                          SizeConfig
                                                                              .widthMultiplier,
                                                                      height: 7 *
                                                                          SizeConfig
                                                                              .heightMultiplier,
                                                                      // Adjust the height as needed
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    )
                                                                  : createWaglController
                                                                              .productImageUrl ==
                                                                          ""
                                                                      ? Image
                                                                          .asset(
                                                                          "assets/icons/no_image.png",
                                                                          width:
                                                                              5 * SizeConfig.widthMultiplier,
                                                                          height:
                                                                              2 * SizeConfig.heightMultiplier,
                                                                          // color: colorBlack,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        )
                                                                      : Image
                                                                          .network(
                                                                          // createWaglController.selectedProduct.attributes!.productPic!.data!.attributes!.url!,
                                                                          createWaglController
                                                                              .productImageUrl,
                                                                          width:
                                                                              6 * SizeConfig.widthMultiplier,
                                                                          height:
                                                                              3 * SizeConfig.heightMultiplier,
                                                                          // Adjust the height as needed
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 1 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width: 62*SizeConfig
                                                      .widthMultiplier,
                                                        child: CustText(
                                                          // name: "${createWaglController.isProductSelected?createWaglController.selectedProduct.attributes!.name:createWaglController.selectedBrandName==""?"Add product":createWaglController.selectedBrandName}",
                                                          name:
                                                              "${createWaglController.selectedBrandName == "" ? createWaglController.selectedProductName == "" ? "Add" : createWaglController.selectedProductName! : createWaglController.selectedBrandName}",
                                                          size: 1.6,
                                                          colors: colorWhite,
                                                          fontWeightName:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      CustText(
                                                        // name: "${createWaglController.isProductSelected?createWaglController.isProductSelected?createWaglController.selectedProduct.attributes!.name:"Add product":"Add product"}",
                                                        name: createWaglController
                                                                .productTextController
                                                                .text
                                                                .isEmpty
                                                            ? createWaglController
                                                                        .selectedBrandNameList ==
                                                                    ""
                                                                ? "Add brand"
                                                                : createWaglController
                                                                    .selectedBrandNameList
                                                            : createWaglController
                                                                .productTextController
                                                                .text
                                                                .toString(),
                                                        size: 1.4,
                                                        colors: colorGreyLight2,
                                                        fontWeightName:
                                                            FontWeight.w500,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: colorBlack_2,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(
                                                        1.5 *
                                                            SizeConfig
                                                                .imageSizeMultiplier,
                                                      ),
                                                    ),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: 1.5 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                        horizontal: 2 *
                                                            SizeConfig
                                                                .widthMultiplier),
                                                    child: Image.asset(
                                                        "assets/icons/right_arrow_icon.png",
                                                        width: 6 *
                                                            SizeConfig
                                                                .widthMultiplier,
                                                        height: 1.5 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                        fit: BoxFit.contain),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 2 * SizeConfig.heightMultiplier,
                                ),
                                SizedBox(
                                  width: 100 * SizeConfig.widthMultiplier,
                                  child: Divider(
                                    color: backgroundLightColor,
                                    endIndent: 2 * SizeConfig.widthMultiplier,
                                    thickness: 1,
                                  ),
                                ),
                                SizedBox(
                                  height: 2 * SizeConfig.heightMultiplier,
                                ),
                                GestureDetector(
                                  onTap: (){

                                  },
                                  child: CustText(
                                    name: "Category tags",
                                    size: 1.6,
                                    colors: colorWhite,
                                    fontWeightName: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 2 * SizeConfig.heightMultiplier,
                                ),
                                createWaglController
                                        .selectedCategories.isNotEmpty
                                    ? Container(
                                        height: 5 * SizeConfig.heightMultiplier,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: ListView.builder(
                                                  itemCount: controller
                                                      .selectedCategories
                                                      .length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  physics:
                                                      AlwaysScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    var category = controller
                                                            .selectedCategories[
                                                        index];
                                                    return Row(
                                                      children: [
                                                        Chip(
                                                          label: CustText(
                                                            name: category
                                                                .attributes
                                                                .categoryName,
                                                            colors: colorWhite,
                                                            fontWeightName:
                                                                FontWeight.w600,
                                                            size: 1.6,
                                                          ),
                                                          backgroundColor:
                                                              borderColor,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color:
                                                                    borderColor,
                                                                width: 1),
                                                            // Thin white border
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20), // Adjust the border radius if needed
                                                          ),
                                                          deleteIcon: Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              child: Icon(
                                                                Icons.close,
                                                                color: Colors
                                                                    .white,
                                                                size: 4 *
                                                                    SizeConfig
                                                                        .imageSizeMultiplier,
                                                              ),
                                                            ),
                                                          ),
                                                          onDeleted: () {
                                                            controller
                                                                .deselectCategory(
                                                                    category);
                                                          },
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          CategoriesTagView()),
                                                );
                                                /* Get.to(
                                                    () => CategoriesTagView());*/
                                              },
                                              child: Container(
                                                height: 3.8 *
                                                    SizeConfig.heightMultiplier,
                                                width: 8 *
                                                    SizeConfig.widthMultiplier,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: colorBlack_2,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SvgPicture.asset(
                                                    "assets/icons/add_icon.svg",
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          createWaglController
                                              .searchCategoryController
                                              .clear();
                                          createWaglController.getCategoryTag();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    CategoriesTagView()),
                                          );
                                          // Get.to(() => CategoriesTagView());
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          height: createWaglController
                                                      .categoryValidation !=
                                                  ""
                                              ? 12 * SizeConfig.heightMultiplier
                                              : 7 * SizeConfig.heightMultiplier,
                                          width:
                                              100 * SizeConfig.widthMultiplier,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2 *
                                                    SizeConfig
                                                        .heightMultiplier),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    CustText(
                                                      name: "Add category tags",
                                                      size: 1.6,
                                                      colors: colorWhite,
                                                      fontWeightName:
                                                          FontWeight.w500,
                                                    ),
                                                    SizedBox(
                                                      width: 1 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                    ),
                                                    SvgPicture.asset(
                                                      "assets/icons/add_icon.svg",
                                                      color: colorPrimary,
                                                    ),
                                                  ],
                                                ),
                                                createWaglController
                                                            .categoryValidation !=
                                                        ""
                                                    ? CustContainer(
                                                        borderColor: Colors.red,
                                                        label:
                                                            "Please select at least one category",
                                                        labelColor: colorWhite,
                                                        iconPath:
                                                            "assets/icons/failed_1.png",
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  height: 1 * SizeConfig.heightMultiplier,
                                ),
                                SizedBox(
                                  width: 100 * SizeConfig.widthMultiplier,
                                  child: Divider(
                                    color: backgroundLightColor,
                                    endIndent: 2 * SizeConfig.widthMultiplier,
                                    thickness: 1,
                                  ),
                                ),
                                SizedBox(
                                  height: 2 * SizeConfig.heightMultiplier,
                                ),
                                CustText(
                                  name: "Good tags",
                                  size: 1.6,
                                  colors: colorWhite,
                                  fontWeightName: FontWeight.w500,
                                ),
                                SizedBox(
                                  height: 2 * SizeConfig.heightMultiplier,
                                ),
                                createWaglController.selectedGoodTag.isNotEmpty
                                    ? Container(
                                        height: 5 * SizeConfig.heightMultiplier,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: ListView.builder(
                                                  itemCount:
                                                      createWaglController
                                                          .selectedGoodTag
                                                          .length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  physics:
                                                      AlwaysScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    var goodTag = controller
                                                        .selectedGoodTag[index];
                                                    return Row(
                                                      children: [
                                                        Chip(
                                                          label: Text(
                                                            /*  createWaglController
                                                .filteredGoodTagList[
                                            createWaglController
                                                .selectedTagIndex[
                                            index]]
                                                .attributes
                                                .name,*/
                                                            goodTag.attributes
                                                                .name,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  "Gilroy",
                                                              color: colorWhite,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 1.5 *
                                                                  SizeConfig
                                                                      .textMultiplier /
                                                                  scaleFactor,
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              Colors.black,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color:
                                                                    borderColor,
                                                                width: 1),
                                                            // Thin white border
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20), // Adjust the border radius if needed
                                                          ),
                                                          avatar: Container(
                                                            height: 100,
                                                            width: 100,
                                                            decoration:
                                                                const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  colorPrimary,
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .all(1.5 *
                                                                      SizeConfig
                                                                          .widthMultiplier),
                                                              child: SvgPicture.network(
                                                                  goodTag
                                                                      .attributes
                                                                      .image
                                                                      .data
                                                                      .attributes
                                                                      .url,
                                                                  color:
                                                                      colorBlack),
                                                            ),
                                                          ),
                                                          deleteIcon: Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  borderColor,
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              child: Icon(
                                                                Icons.close,
                                                                color: Colors
                                                                    .white,
                                                                size: 4 *
                                                                    SizeConfig
                                                                        .imageSizeMultiplier,
                                                              ),
                                                            ),
                                                          ),
                                                          // Close icon
                                                          onDeleted: () {
                                                            controller
                                                                .deselectGoodTag(
                                                                    goodTag);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          GoodTagView()),
                                                );
                                                // Get.to(() => GoodTagView());
                                              },
                                              child: Container(
                                                height: 3.8 *
                                                    SizeConfig.heightMultiplier,
                                                width: 8 *
                                                    SizeConfig.widthMultiplier,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: colorBlack_2,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SvgPicture.asset(
                                                    "assets/icons/add_icon.svg",
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))
                                    : GestureDetector(
                                        onTap: () {
                                          print("Here is the good tag");

                                          createWaglController.getGoodTag();
                                          createWaglController
                                              .searchTagController
                                              .clear();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => GoodTagView()),
                                          );
                                          // Get.to(() => GoodTagView());
                                        },
                                        child: Container(
                                          width:
                                              100 * SizeConfig.widthMultiplier,
                                          height: createWaglController
                                                      .goodTagValidation !=
                                                  ""
                                              ? 8 * SizeConfig.heightMultiplier
                                              : 5 * SizeConfig.heightMultiplier,
                                          color: Colors.transparent,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  CustText(
                                                    name: "Add good tags",
                                                    size: 1.6,
                                                    colors: colorWhite,
                                                    fontWeightName:
                                                        FontWeight.w500,
                                                  ),
                                                  SizedBox(
                                                    width: 1 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                  ),
                                                  SvgPicture.asset(
                                                    "assets/icons/add_icon.svg",
                                                    color: colorPrimary,
                                                  ),
                                                ],
                                              ),
                                              createWaglController
                                                          .goodTagValidation !=
                                                      ""
                                                  ? CustContainer(
                                                      borderColor: Colors.red,
                                                      label:
                                                          "Please select at least one good tag.",
                                                      labelColor: colorWhite,
                                                      iconPath:
                                                          "assets/icons/failed_1.png",
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  width: 100 * SizeConfig.widthMultiplier,
                                  child: Divider(
                                    color: backgroundLightColor,
                                    endIndent: 2 * SizeConfig.widthMultiplier,
                                    thickness: 1,
                                  ),
                                ),
                                SizedBox(
                                  height: 2 * SizeConfig.heightMultiplier,
                                ),
                                CustText(
                                  name: "Location",
                                  size: 1.6,
                                  colors: colorWhite,
                                  fontWeightName: FontWeight.w500,
                                ),
                                SizedBox(
                                  height: 2 * SizeConfig.heightMultiplier,
                                ),
                                GestureDetector(
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => SearchGooglePlaces(
                                          controller: CreateWaglController()));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: backgroundLightColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(2 *
                                                SizeConfig.imageSizeMultiplier),
                                          )),
                                      child: Row(
                                        children: [
                                          Container(
                                            width:
                                                85 * SizeConfig.widthMultiplier,
                                            height:
                                                7 * SizeConfig.heightMultiplier,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CustText(
                                                  name: createWaglController
                                                      .selectedAddress,
                                                  size: 1.5,
                                                  colors: colorWhite,
                                                  fontWeightName:
                                                      FontWeight.w500),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: colorBlack_2,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                  1.5 *
                                                      SizeConfig
                                                          .imageSizeMultiplier,
                                                ),
                                              ),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 1.5 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  horizontal: 2 *
                                                      SizeConfig
                                                          .widthMultiplier),
                                              child: Image.asset(
                                                  createWaglController
                                                          .isAddressSelected
                                                      ? "assets/icons/edit_icon_logo.png"
                                                      : "assets/icons/right_arrow_icon.png",
                                                  width: 6 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  height: 1.9 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  fit: BoxFit.contain),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 2 * SizeConfig.heightMultiplier,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: CustButtonIconLast(
                                      name: "Publish",
                                      size: 1.6,
                                      btnColor: colorPrimary,
                                      fontColor: colorBlack,
                                      onSelected: () async {
                                        ConnectionChecker.checkConnection(
                                          context: context,
                                          onConnected: () async {
                                            if (!isEdit) {
                                              if (createWaglController
                                                          .descriptionTextController
                                                          .text
                                                          .toString() !=
                                                      "" &&
                                                  createWaglController
                                                      .selectedCategoryIds
                                                      .isNotEmpty &&
                                                  createWaglController
                                                      .selectedGoodTagIds
                                                      .isNotEmpty) {
                                                BuildContext? dialogContext;
                                                try {


                                                  // Show the loading dialog
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    // Prevent accidental dismissal
                                                    builder:
                                                        (BuildContext context) {
                                                      dialogContext =
                                                          context; // Save dialog context for later dismissal
                                                      return ProgressBarPopup();
                                                    },
                                                  );
                                                  /*   showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (dialogContext
                                                            context) =>
                                                        ProgressBarPopup());*/
                                                  final result =
                                                      await createWaglController
                                                          .createWaglDio(
                                                    (progressPercentange) {
                                                      print(
                                                          "Here is the percentange ::$progressPercentange");
                                                    },
                                                  );

                                                  var homeController =
                                                      Get.put(HomeController());

                                                  var data =
                                                      await homeController
                                                          .getHomeFeedWagl();
                                                  homeController.handleMainPageViewChanged(0);
                                                  profileController
                                                      .getUsersWagl(0);
                                                  /*  homeController.handleMainPageViewChanged(0);
                                                homeController
                                                    .changeTabIndex(4);

                                                Navigator.pop(context);
                                                // Get.back();
                                                Navigator.pop(context);
                                                Navigator.pop(context);*/
                                                  Navigator.pop(context);
                                                  // Get.back();
                                                  Navigator.pop(context);
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
                                                  HapticFeedback.heavyImpact();
                                                }
                                                homeController.onBottomOptionTapped(4);
                                                // Get.to(() => MyHomePage());
                                                // await createWaglController.createWagl();
                                              } else {
                                                createWaglController
                                                    .updateDescription(true);
                                              }
                                            }
                                            /*else {

                                              print(
                                                  "here is the waglId${createWaglController.editWaglId}");

                                              if (createWaglController
                                                  .descriptionTextController
                                                  .text
                                                  .toString() !=
                                                  "" &&createWaglController.selectedCategoryIds.isNotEmpty&&createWaglController.selectedGoodTagIds.isNotEmpty) {
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (BuildContext
                                                            context) =>
                                                        ProgressBarPopup());
                                                final result =
                                                    await createWaglController
                                                        .updateEditWaglMethod(
                                                  createWaglController
                                                      .editWaglId,
                                                  (progressPercentange) {
                                                    print(
                                                        "Here is the percentange ::$progressPercentange");
                                                  },
                                                );

                                                var homeController =
                                                    Get.put(HomeController());

                                                var data = await homeController
                                                    .getHomeFeedWagl();
                                                homeController
                                                    .changeTabIndex(4);
                                                profileController
                                                    .getUsersWagl(0);
                                                Navigator.pop(context);
                                                // Get.back();
                                                Navigator.pop(context);
                                                Get.to(() => MyHomePage());
                                                // await createWaglController.createWagl();
                                              } else {
                                                createWaglController
                                                    .updateDescription(true);
                                              }
                                            }*/
                                            else {
                                              print(
                                                  "Here is the waglId ${createWaglController.editWaglId}");

                                              // Validate the input fields
                                              if (createWaglController
                                                      .descriptionTextController
                                                      .text
                                                      .isNotEmpty &&
                                                  createWaglController
                                                      .selectedCategoryIds
                                                      .isNotEmpty &&
                                                  createWaglController
                                                      .selectedGoodTagIds
                                                      .isNotEmpty) {
                                                BuildContext?
                                                    dialogContext; // To safely manage the loader's context

                                                try {
                                                  // Show the loader
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    builder:
                                                        (BuildContext context) {
                                                      dialogContext =
                                                          context; // Save the loader's context
                                                      return ProgressBarPopup();
                                                    },
                                                  );

                                                  // Call the updateEditWaglMethod and handle the progress
                                                  final result =
                                                      await createWaglController
                                                          .updateEditWaglMethod(
                                                    createWaglController
                                                        .editWaglId,
                                                    (progressPercentage) {
                                                      print(
                                                          "Here is the percentage :: $progressPercentage");
                                                    },
                                                  );

                                                  // Fetch and update the home feed
                                                  homeController.onBottomOptionTapped(4);

                                                  // Navigate to the MyHomePage
                                                  if (dialogContext != null &&
                                                      Navigator.canPop(
                                                          dialogContext!)) {
                                                    Navigator.pop(
                                                        dialogContext!); // Dismiss the loader
                                                  }
                                                  // Navigator.pop(context);
                                                  // Navigator.pop(context);
                                                  homeController.onBottomOptionTapped(4);
                                                  // Get.to(() => MyHomePage());
                                                } catch (e) {
                                                  print(
                                                      "Error during operation: $e");
                                                } finally {
                                                  // Ensure the loader is dismissed in all cases
                                                  if (dialogContext != null &&
                                                      Navigator.canPop(
                                                          dialogContext!)) {
                                                    Navigator.pop(
                                                        dialogContext!);
                                                  }
                                                  HapticFeedback.heavyImpact();
                                                }
                                              } else {
                                                // Update the description error state
                                                createWaglController
                                                    .updateDescription(true);
                                              }
                                            }
                                          },
                                        );
                                        /*   if( await CheckInternet.checkInternet()){

                                        }else{
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
                                        }*/
                                      },
                                      preIconPath:
                                          "assets/icons/publish_icon.png"),
                                ),
                                SizedBox(
                                  height: 2 * SizeConfig.heightMultiplier,
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
    ));
  }
}

class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    double width = size.width;
    double height = size.height;

    double sideLength = width / 2;
    double heightOffset = height / 4;

    // Define the 6 points of the hexagon
    path.moveTo(width / 2, 0); // Top point
    path.lineTo(width, heightOffset); // Top-right
    path.lineTo(width, height - heightOffset); // Bottom-right
    path.lineTo(width / 2, height); // Bottom point
    path.lineTo(0, height - heightOffset); // Bottom-left
    path.lineTo(0, heightOffset); // Top-left
    path.close(); // Close the hexagon shape

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
