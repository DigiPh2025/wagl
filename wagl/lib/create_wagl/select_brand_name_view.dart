import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:wagl/create_wagl/add_product_view.dart';
import 'package:wagl/custom_widget/cust_appbar.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import 'package:wagl/util/SizeConfig.dart';

import '../custom_widget/blur_back_button.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_button.dart';
import '../custom_widget/cust_text_field.dart';
import '../login/login_controller.dart';
import 'create_wagl_controller.dart';

class BrandNameView extends StatelessWidget {
  BrandNameView({super.key});

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
                  CustAppbar(title: "Brand name", icon: false),
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
                              createWaglController.searchBrandController,
                              cursorColor: colorWhite,
                              obscureText: false,
                              onTapOutside: (value) {
                                print("value");
                                FocusManager.instance.primaryFocus
                                    ?.unfocus();
                                createWaglController
                                    .updateConfirmTagButton(true);
                              },
                              onChanged: (value) {
                                print("here is tje $value");
                                createWaglController.filterBrandName(value);
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
                                hintText: "Search brand names",
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

                      /*    Container(
                            height: 77 * SizeConfig.heightMultiplier,
                            width: 100 * SizeConfig.widthMultiplier,
                            child: RefreshIndicator(
                              color: colorPrimary,
                              backgroundColor: colorBlack_2,
                              onRefresh: () {
                                return createWaglController.getBrandNames();
                              },
                              child: ListView.builder(
                                  itemCount: createWaglController
                                        .filterBrandListNew.length,
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
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap:(){
                                                createWaglController.getBrandName(createWaglController
                                                    .filterBrandListNew![index]);
                                                // Get.back();
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                color:Colors.transparent,
                                                width: 90*SizeConfig.widthMultiplier,
                                                child: Row(
                                                  children: [

                                                    Container(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [

                                                          Padding(
                                                            padding:  EdgeInsets.symmetric(horizontal:1*SizeConfig.widthMultiplier,vertical: 1*SizeConfig.heightMultiplier),
                                                            child: CustText(
                                                              name: createWaglController
                                                                  .filterBrandListNew[
                                                              index]
                                                                  .attributes?.brandName??"",
                                                              size: 1.6,
                                                              colors: c_white,
                                                              fontWeightName:
                                                              FontWeight.w800,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
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
                                    return _buildSuggestionTile(
                                        "controller.searchResults[index]",context);
                                  }),
                            ),
                          ),*/
                          Container(
                            height: 77 * SizeConfig.heightMultiplier,
                            width: 100 * SizeConfig.widthMultiplier,
                            child: RefreshIndicator(
                              color: colorPrimary,
                              backgroundColor: colorBlack_2,
                              onRefresh: () {
                                return createWaglController.getBrandNames();
                              },
                              child: createWaglController.filterBrandListNew.isEmpty&&createWaglController.searchBrandController.text.isEmpty?Center(
                                child: CircularProgressIndicator(
                                  color: colorPrimary,

                                ),
                              ):ListView.builder(
                                itemCount: createWaglController.filterBrandListNew.length + 1, // Add 1 for _buildSuggestionTile
                                scrollDirection: Axis.vertical,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  if (index < createWaglController.filterBrandListNew.length) {
                                    // Display filterBrandListNew items
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                createWaglController.getBrandName(
                                                  createWaglController.filterBrandListNew[index],
                                                );
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                color: Colors.transparent,
                                                width: 90 * SizeConfig.widthMultiplier,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(
                                                              horizontal: 1 * SizeConfig.widthMultiplier,
                                                              vertical: 1 * SizeConfig.heightMultiplier,
                                                            ),
                                                            child: CustText(
                                                              name: createWaglController
                                                                  .filterBrandListNew[index]
                                                                  .attributes
                                                                  ?.brandName ??
                                                                  "",
                                                              size: 1.6,
                                                              colors: c_white,
                                                              fontWeightName: FontWeight.w800,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 3 * SizeConfig.heightMultiplier,
                                          width: 100 * SizeConfig.widthMultiplier,
                                          child: Divider(
                                            height: 1 * SizeConfig.heightMultiplier,
                                            color: borderColor,
                                            endIndent: 2 * SizeConfig.widthMultiplier,
                                            thickness: 1,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    // Display _buildSuggestionTile
                                    if(createWaglController.searchBrandController.text.isEmpty){
                                      return Container();
                                    }
                                    else{
                                      return _buildSuggestionTile(createWaglController.searchBrandController.text.toString(), context);
                                    }

                                  }
                                },
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
              /*createWaglController.viewConfirmButtonTag
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
                bottom: 10,
                right: 10,
                left: 5,
                child: CustButton(
                    btnColor: colorPrimary,
                    width: 100,
                    height: 7,
                    onSelected: () {

                      Get.back();
                    },
                    size: 1.6,
                    name: "Confirm",
                    fontColor: colorBlack),
              )
                  : Container(),*/
            ],
          )),
    );
  }
  Widget _buildSuggestionTile(String brandName,context) {
    return GestureDetector(
      onTap: () async {
        print("here is the _buildSuggestionTile_buildSuggestionTile brandName ");
    var  result=  await  createWaglController.addBrand(brandName);
        print("here is is the brand name ith id ${createWaglController.newBrandId}");
        Navigator.pop(context);
        /*Navigator.push(
          context,
          MaterialPageRoute(builder: (_) =>  BrandNameView()),
        );*/
        // Get.to(() => TabSearchView());
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
                    child: SvgPicture.asset(
                      "assets/icons/add_icon.svg",
                      color: colorWhite,
                      height: 2*SizeConfig.heightMultiplier,
                    ),
                  )),
              SizedBox(width: 2 * SizeConfig.widthMultiplier),
              Container(
                // height: 7*SizeConfig.heightMultiplier,
                width: 78 * SizeConfig.widthMultiplier,
                child: Row(
                  children: [
                    CustText(
                        name: "Create brand / creator for",
                        size: 1.5,
                        colors: colorGrey,
                        fontWeightName: FontWeight.w600),
                    CustText(
                        name:
                        " \"${createWaglController.searchBrandController.text}\"",
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
