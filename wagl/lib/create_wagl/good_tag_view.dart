import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:wagl/custom_widget/cust_appbar.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import 'package:wagl/util/SizeConfig.dart';

import '../custom_widget/check_internet.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_button.dart';
import '../custom_widget/cust_text_field.dart';
import '../login/login_controller.dart';
import 'create_wagl_controller.dart';

class GoodTagView extends StatelessWidget {
  GoodTagView({super.key});

  var createWaglController = Get.put(CreateWaglController());

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      backgroundColor: colorBlack,
      body: GetBuilder<CreateWaglController>(
          init: CreateWaglController(),
          builder: (controller) => Stack(
                children: [
                  SingleChildScrollView(
                    // scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5 * SizeConfig.heightMultiplier,
                        ),
                        CustAppbar(title: "Add good tags", icon: false),
                        Stack(
                          children: [
                            Container(
                              height: 7 * SizeConfig.heightMultiplier,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  // stops: [0.9,0.8],
                                  end: Alignment.topCenter,
                                  colors: [colorBlack_2, colorBlack_2],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2 * SizeConfig.widthMultiplier),
                              child: Container(
                                height: 5.5 * SizeConfig.heightMultiplier,
                                width: 100 * SizeConfig.widthMultiplier,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          2 * SizeConfig.widthMultiplier)),
                                ),
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: "Gilroy",
                                    color: colorWhite,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 1.6 * SizeConfig.textMultiplier/scaleFactor,
                                  ),
                                  controller:
                                      createWaglController.searchTagController,
                                  cursorColor: colorWhite,
                                  obscureText: false,
                                  onTap: () {
                                    // FocusManager.instance.notifyListeners();
                                    createWaglController
                                        .updateConfirmTagButton(false);
                                  },
                                  onTapOutside: (Value) {
                                    print("ASDASDAS");
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    createWaglController
                                        .updateConfirmTagButton(true);
                                  },
                                  onChanged: (value) {
                                    createWaglController.filterTags(value);
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
                                        height:
                                            5.5 * SizeConfig.heightMultiplier,
                                        width: 2 * SizeConfig.widthMultiplier),
                                    fillColor: colorPrimary,
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
                                        color: borderColor,
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
                                    hintText: "Search good tags",
                                    hintStyle: TextStyle(
                                      fontFamily: "Gilroy",
                                      color: colorGrey,
                                      fontSize: 1.5 * SizeConfig.textMultiplier/scaleFactor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2 * SizeConfig.widthMultiplier),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 2 * SizeConfig.heightMultiplier,
                              ),
                              CustText(
                                  name: "Suggested good tags",
                                  size: 1.5,
                                  colors: colorWhite,
                                  fontWeightName: FontWeight.w800),
                              SizedBox(
                                height: 5 * SizeConfig.heightMultiplier,
                                width: 100 * SizeConfig.widthMultiplier,
                                child: Divider(
                                  height: 10 * SizeConfig.heightMultiplier,
                                  color: borderColor,
                                  endIndent: 2 * SizeConfig.widthMultiplier,
                                  thickness: 1,
                                ),
                              ),
                              // Container(
                              //   color: Colors.red,
                              //   width: 100 * SizeConfig.widthMultiplier,
                              //   child: Divider(
                              //     height: 5 * SizeConfig.heightMultiplier,
                              //     color: borderColor,
                              //     endIndent: 2 * SizeConfig.widthMultiplier,
                              //     thickness: 1,
                              //   ),
                              // ),
                              createWaglController.selectedGoodTag.isEmpty
                                  ? Container()
                                  : Container(
                                      height: 5 * SizeConfig.heightMultiplier,
                                      child: ListView.builder(
                                          itemCount: createWaglController
                                              .selectedGoodTag.length,
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context,
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
                                                    goodTag.attributes.name,
                                                    style: TextStyle(
                                                      fontFamily: "Gilroy",
                                                      color: colorWhite,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 1.5 *
                                                          SizeConfig
                                                              .textMultiplier/scaleFactor,
                                                    ),
                                                  ),
                                                  backgroundColor: Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color: borderColor,
                                                        width: 1),
                                                    // Thin white border
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20), // Adjust the border radius if needed
                                                  ),
                                                  avatar: Container(
                                                    height: 5 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    width: 10 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: colorPrimary,
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(0.5 *
                                                          SizeConfig
                                                              .widthMultiplier),
                                                      child: goodTag
                                                                      .attributes
                                                                      .image
                                                                      .data
                                                                      .attributes
                                                                      .ext ==
                                                                  ".png" ||
                                                              goodTag
                                                                      .attributes
                                                                      .image
                                                                      .data
                                                                      .attributes
                                                                      .ext ==
                                                                  ".jpg" ||
                                                              goodTag
                                                                      .attributes
                                                                      .image
                                                                      .data
                                                                      .attributes
                                                                      .ext ==
                                                                  ".jpeg"
                                                          ? Image.network(
                                                              "${goodTag.attributes.image.data.attributes.url}")
                                                          : SvgPicture.network(
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
                                                      shape: BoxShape.circle,
                                                      color: borderColor,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child: Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                        size: 4 *
                                                            SizeConfig
                                                                .imageSizeMultiplier,
                                                      ),
                                                    ),
                                                  ),
                                                  // Close icon
                                                  onDeleted: () {
                                                    controller.deselectGoodTag(
                                                        goodTag);
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 1 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                )
                                              ],
                                            );
                                          })),
                              Container(
                                height: 77 * SizeConfig.heightMultiplier,
                                width: 100 * SizeConfig.widthMultiplier,
                                child: RefreshIndicator(
                                  color: colorPrimary,
                                  backgroundColor: colorBlack_2,
                                  onRefresh: () async {
                                    if (await CheckInternet.checkInternet()) {
                                      return createWaglController.getGoodTag();
                                    } else {
                                      var snackdemo = SnackBar(
                                        content: CustText(
                                            name:
                                                "Please check your internet connection",
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
                                  child: ListView.builder(
                                      itemCount: createWaglController
                                          .filteredGoodTagList.length,
                                      scrollDirection: Axis.vertical,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                createWaglController
                                                    .toggleSelectionGoodTag(
                                                        createWaglController
                                                                .filteredGoodTagList[
                                                            index]);
                                              },
                                              child: Container(
                                                color: Colors.transparent,
                                                height: 5 *
                                                    SizeConfig.heightMultiplier,
                                                width: 100 *
                                                    SizeConfig.widthMultiplier,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 8 *
                                                              SizeConfig
                                                                  .widthMultiplier,
                                                          decoration:
                                                              const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: borderColor,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: createWaglController
                                                                        .filteredGoodTagList[
                                                                            index]
                                                                        .attributes
                                                                        .image
                                                                        .data
                                                                        .attributes
                                                                        .ext ==
                                                                    ".svg"
                                                                ? SvgPicture
                                                                    .network(
                                                                    createWaglController
                                                                        .filteredGoodTagList[
                                                                            index]
                                                                        .attributes
                                                                        .image
                                                                        .data
                                                                        .attributes
                                                                        .url,
                                                                    color:
                                                                        colorPrimary,
                                                                    width: 2 *
                                                                        SizeConfig
                                                                            .widthMultiplier,
                                                                    height: 2 *
                                                                        SizeConfig
                                                                            .heightMultiplier,
                                                                  )
                                                                : Image.network(
                                                                    createWaglController
                                                                        .filteredGoodTagList[
                                                                            index]
                                                                        .attributes
                                                                        .image
                                                                        .data
                                                                        .attributes
                                                                        .url,
                                                                    width: 2 *
                                                                        SizeConfig
                                                                            .widthMultiplier,
                                                                    height: 2 *
                                                                        SizeConfig
                                                                            .heightMultiplier,
                                                                    fit: BoxFit
                                                                        .contain,
                                                                  ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 2 *
                                                              SizeConfig
                                                                  .widthMultiplier,
                                                        ),
                                                        CustText(
                                                          name: createWaglController
                                                              .filteredGoodTagList[
                                                                  index]
                                                              .attributes
                                                              .name,
                                                          size: 1.6,
                                                          colors: c_white,
                                                          fontWeightName:
                                                              FontWeight.w500,
                                                        ),
                                                      ],
                                                    ),
                                                    Checkbox(
                                                      value: createWaglController
                                                          .isSelectedGoodTag(
                                                              createWaglController
                                                                      .filteredGoodTagList[
                                                                  index]),
                                                      onChanged: (value) {
                                                        createWaglController
                                                            .toggleSelectionGoodTag(
                                                                createWaglController
                                                                        .filteredGoodTagList[
                                                                    index]);
                                                      },
                                                      activeColor: colorPrimary,
                                                      checkColor: Colors.black,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 3 *
                                                  SizeConfig.heightMultiplier,
                                              width: 100 *
                                                  SizeConfig.widthMultiplier,
                                              child: Divider(
                                                height: 1 *
                                                    SizeConfig.heightMultiplier,
                                                color: borderColor,
                                                endIndent: 2 *
                                                    SizeConfig.widthMultiplier,
                                                thickness: 1,
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  createWaglController.viewConfirmButtonTag
                      ? Positioned(
                          bottom: 0,
                          child: Container(
                            width: 100 * SizeConfig.widthMultiplier,
                            height: 10 * SizeConfig.heightMultiplier,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                // stops: [0.9,0.8],
                                end: Alignment.topCenter,
                                colors: [colorBlack, colorBlackLight],
                              ),
                            ),
                          ))
                      : Container(),
                  createWaglController.viewConfirmButtonTag
                      ? Positioned(
                    bottom: 2*SizeConfig.heightMultiplier,
                          right: 10,
                          left: 5,
                          child: CustButton(
                              btnColor: colorPrimary,
                              width: 100,
                              height: 7,
                              onSelected: () {
                                // Get.back();
                                Navigator.pop(context);
                              },
                              size: 1.6,
                              name: "Confirm",
                              fontColor: colorBlack),
                        )
                      : Container(),
                ],
              )),
    );
  }
}
