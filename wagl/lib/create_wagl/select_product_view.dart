import 'dart:ui';

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
import '../custom_widget/hexa_outline_widget.dart';
import '../login/login_controller.dart';
import 'create_wagl_controller.dart';

class ProductTagView extends StatelessWidget {
  ProductTagView({super.key});

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
                    Container(
                      height: 7 * SizeConfig.heightMultiplier,
                      decoration:  const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          // stops: [0.9,0.8],
                          end: Alignment.topCenter,
                          colors: [colorBlack_2, colorBlack],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: (){
                                  // Get.back();
                                  Navigator.pop(context);
                                },
                                child: CustBackButton()),
                            CustText(
                                name: "Add product",
                                size: 1.6,
                                colors: colorWhite,
                                textAlign: TextAlign.center,
                                fontWeightName: FontWeight.w700),
                            /*SizedBox(
              width: 7 * SizeConfig.widthMultiplier,
            ),*/
                            GestureDetector(
                              onTap: (){
                                createWaglController.clearWarning();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) =>  AddProductView()),
                                );
                                // Get.to(()=>AddProductView());
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: colorBlack_2,
                                    borderRadius: BorderRadius.all(Radius.circular(
                                      1.5 * SizeConfig.imageSizeMultiplier,
                                    ),),

                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1.5 * SizeConfig.heightMultiplier,
                                        horizontal: 3 * SizeConfig.widthMultiplier),
                                    child: SvgPicture.asset(
                                      "assets/icons/add_icon.svg",
                                      color: colorWhite,
                                      fit: BoxFit.fill,
                                      width: 4*SizeConfig.widthMultiplier,
                                      height: 2*SizeConfig.heightMultiplier,
                                    ),
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                              createWaglController.searchProductController,
                              cursorColor: colorWhite,
                              obscureText: false,
                              onTapOutside: (value) {
                                print("ASDASDAS");
                                FocusManager.instance.primaryFocus
                                    ?.unfocus();
                                createWaglController
                                    .updateConfirmTagButton(true);
                              },
                              onChanged: (value) {
                                createWaglController.filterProducts(value);
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
                                hintText: "Search products",
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
                              name: "Suggested products",
                              size: 1.5,
                              colors: colorWhite,
                              fontWeightName: FontWeight.w800),
                          SizedBox(
                            height: 2 * SizeConfig.heightMultiplier,
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

                          Container(
                            height: 77 * SizeConfig.heightMultiplier,
                            width: 100 * SizeConfig.widthMultiplier,
                            child: RefreshIndicator(
                              color: colorPrimary,
                              backgroundColor: colorBlack_2,
                              onRefresh: () {
                                return createWaglController.getProducts();
                              },
                              child: ListView.builder(
                                  itemCount: createWaglController
                                      .filterProductList.length,
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
                                            Row(
                                              children: [
                                                Container(
                                                  width:
                                                  9 * SizeConfig.widthMultiplier,
                                                  height:
                                                  5 * SizeConfig.heightMultiplier,

                                                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(
                                                    "assets/icons/heza_icon.png",))),
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      ClipPath(
                                                        clipper: HexagonClipperProduct(),
                                                        child: Container(
                                                          width: 9 * SizeConfig.widthMultiplier,
                                                          height: 5 * SizeConfig.heightMultiplier,
                                                          child: ClipRRect(
                                                            child: BackdropFilter(
                                                                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                                                                child: Container(color: colorWhite,)
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Center(
                                                        child:createWaglController
                                                            .filterProductList[
                                                        index]
                                                            .attributes!
                                                            .productPic!.data==null?Image.asset("assets/icons/no_image.png",width:
                                                        4 * SizeConfig.widthMultiplier,
                                                          height:
                                                          2 * SizeConfig.heightMultiplier,
                                                          // color: colorBlack,
                                                          fit: BoxFit.fill,): Image.network(
                                                          createWaglController
                                                              .filterProductList[
                                                          index]
                                                              .attributes!
                                                              .productPic!.data!.attributes!.url!,
                                                          width:
                                                          4 * SizeConfig.widthMultiplier,
                                                          height:
                                                          3 * SizeConfig.heightMultiplier,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),

                                                    ],
                                                  ),

                                                ),
                                               /* Container(
                                                  width: 8 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  decoration:
                                                  const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: borderColor,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child:
                                                    Image.network(
                                                      createWaglController
                                                          .filterProductList[
                                                      index]
                                                          .attributes!
                                                          .productPic!
                                                          .data!.attributes!.url!,
                                                      width: 4 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                      height: 4 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),*/
                                                SizedBox(
                                                  width: 2 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    CustText(
                                                      name: createWaglController
                                                          .filterProductList[
                                                      index]
                                                          .attributes!.name,
                                                      size: 1.6,
                                                      colors: c_white,
                                                      fontWeightName:
                                                      FontWeight.w700,
                                                    ),
                                                    CustText(
                                                      name: createWaglController
                                                          .filterProductList[
                                                      index]
                                                          .attributes!.brandId!.data!.attributes!.brandName,
                                                      size: 1.6,
                                                      colors: colorGreyLight2,
                                                      fontWeightName:
                                                      FontWeight.w500,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap:(){
                                                createWaglController.getSelectedProduct(createWaglController
                                                    .filterProductList[
                                                index]);
                                                // Get.back();
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: colorBlack_2
                                                  ,
                                                  border: Border.all(
                                                      color
                                                          : colorBlack_2,
                                                      width: 0.40 *
                                                          SizeConfig
                                                              .widthMultiplier),
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                        2 *
                                                            SizeConfig
                                                                .imageSizeMultiplier,
                                                      )),
                                                  shape: BoxShape.rectangle,
                                                ),
                                                height: 4 *
                                                    SizeConfig.heightMultiplier,
                                                child: Center(
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 3.0 *
                                                            SizeConfig
                                                                .widthMultiplier),
                                                    child: CustText(
                                                        name: "Select",
                                                        size: 1.6,
                                                        colors: colorPrimary,
                                                        fontWeightName:
                                                        FontWeight.w800),
                                                  ),
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
                                  }),
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
}
