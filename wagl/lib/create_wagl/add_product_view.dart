import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wagl/create_wagl/create_wagl_controller.dart';
import 'package:wagl/create_wagl/create_wagl_view.dart';
import 'package:wagl/create_wagl/select_brand_name_view.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import 'package:wagl/util/SizeConfig.dart';

import '../custom_widget/Strings.dart';
import '../custom_widget/check_internet.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_appbar.dart';
import '../custom_widget/cust_button_with_icon_last.dart';
import '../custom_widget/cust_container.dart';
import '../custom_widget/custom_loading_popup.dart';

class AddProductView extends StatelessWidget {
  final CreateWaglController createWaglController =
  Get.put(CreateWaglController());
  AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      backgroundColor: colorBlack,
      body: SafeArea(
        child: GetBuilder<CreateWaglController>(
          init: CreateWaglController(),
          builder: (controller) => SizedBox(
            height: 98*SizeConfig.heightMultiplier,
            width: 100*SizeConfig.widthMultiplier,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustAppbar(title: "Add", icon: false),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 2 * SizeConfig.heightMultiplier,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 2 * SizeConfig.heightMultiplier,
                                horizontal: 3 * SizeConfig.widthMultiplier),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustText(
                                  name: "Image",
                                  size: 1.4,
                                  colors: colorWhite,
                                  fontWeightName: FontWeight.w500,
                                ),
                                SizedBox(
                                  height: 1*SizeConfig.heightMultiplier,
                                ),
                                DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(12),
                                    strokeWidth: 1,
                                    color: colorBlack_2,
                                    dashPattern: const [5],
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            print("asdasdasd");
                                            createWaglController.getProductImage(ImageSource.gallery);
                                          },
                                          child: SizedBox(
                                            height: 35 * SizeConfig.heightMultiplier,
                                            width: 97 * SizeConfig.widthMultiplier,
                                            child: Container(
                                              width: 30 * SizeConfig.widthMultiplier,
                                              height: 30 * SizeConfig.heightMultiplier,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal:
                                                  20 * SizeConfig.widthMultiplier,
                                                  vertical:
                                                  5 * SizeConfig.heightMultiplier),
                                              decoration: createWaglController.productImage==null?BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: colorBlack_2,
                                              ):BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: FileImage(
                                                      createWaglController.productImage!),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              child:createWaglController.productImage==null? Center(
                                                  child: CustText(
                                                      name: "Click to upload",
                                                      size: 1.4,
                                                      fontWeightName: FontWeight.w500)):Container(),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 4 * SizeConfig.heightMultiplier,
                                          right: 23 * SizeConfig.widthMultiplier,
                                          child: GestureDetector(
                                            onTap: (){
                                              createWaglController.getProductImage(ImageSource.gallery);
                                            },
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: 17 * SizeConfig.widthMultiplier,
                                                  height: 10 * SizeConfig.heightMultiplier,
                                                  // margin: EdgeInsets.symmetric(horizontal:5*SizeConfig.widthMultiplier,vertical:  5*SizeConfig.heightMultiplier),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: colorBlack,
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      width: 13 * SizeConfig.widthMultiplier,
                                                      height:
                                                      8 * SizeConfig.heightMultiplier,
                                                      // margin: EdgeInsets.symmetric(horizontal:5*SizeConfig.widthMultiplier,vertical:  5*SizeConfig.heightMultiplier),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: colorBlack_2,
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(1.8*SizeConfig.heightMultiplier),
                                                        child: SvgPicture.asset("assets/icons/upload_icon.svg",width: 3*SizeConfig.widthMultiplier,height: 4*SizeConfig.heightMultiplier,),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                                SizedBox(
                                  height: 1*SizeConfig.heightMultiplier,
                                ),
                                createWaglController.emptyProductImgError!=""?CustContainer(
                                  borderColor: Colors.red,
                                  label: createWaglController.emptyProductImgError,
                                  labelColor: colorWhite,
                                  iconPath: "assets/icons/failed_1.png",
                                ):Container(),
                                SizedBox(
                                  height: 3*SizeConfig.heightMultiplier,
                                ),
                                CustText(
                                  name: "Brand name / Creator",
                                  size: 1.6,
                                  colors: colorWhite,
                                  fontWeightName: FontWeight.w500,
                                ),
                                SizedBox(
                                  height: 1*SizeConfig.heightMultiplier,
                                ),
                                GestureDetector(
                                  onTap: (){
                                    createWaglController.clearBrandName();
                                    createWaglController.getBrandNames();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) =>  BrandNameView()),
                                    );
                                    // Get.to(()=>BrandNameView());
                                  },
                                  child: Container(
                                    width: 100 * SizeConfig.widthMultiplier,
                                    height: 7 * SizeConfig.heightMultiplier,
                                    decoration: BoxDecoration(
                                        color: backgroundLightColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(2 *
                                              SizeConfig
                                                  .imageSizeMultiplier),
                                        )),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.all(8.0),
                                          child: CustText(
                                              name: createWaglController.selectedBrandName==""?"Add Brand name / Creator":createWaglController.selectedBrandName,
                                              size: 1.5,
                                              colors:createWaglController.selectedBrandName==""?colorGrey:colorWhite,
                                              fontWeightName:
                                              FontWeight.w500),
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
                                                /* createWaglController
                                                .isAddressSelected
                                                ? "assets/icons/edit_icon_logo.png"
                                                :*/ "assets/icons/right_arrow_icon.png",
                                                  width: 6 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  height: 1.9 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  fit: BoxFit.contain),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 1*SizeConfig.heightMultiplier,
                                ),
                                createWaglController.emptyBrandError!=""?CustContainer(
                                  borderColor: Colors.red,
                                  label: createWaglController.emptyBrandError,
                                  labelColor: colorWhite,
                                  iconPath: "assets/icons/failed_1.png",
                                ):Container(),
                                SizedBox(
                                  height: 2*SizeConfig.heightMultiplier,
                                ),
                                CustText(
                                  name: "Product name / Title",
                                  size: 1.6,
                                  colors: colorWhite,
                                  fontWeightName: FontWeight.w500,
                                ),
                                SizedBox(
                                  height: 1*SizeConfig.heightMultiplier,
                                ),
                                TextField(
                                  maxLines: 6,
                                  style: TextStyle(
                                    fontFamily: "Gilroy",
                                    color: colorWhite,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 1.4 * SizeConfig.textMultiplier/scaleFactor,
                                  ),
                                  controller: createWaglController
                                      .productTextController,
                                  cursorColor: colorWhite,
                                  obscureText: false,

                                  onTapOutside: (Value) {
                                    print("ASDASDAS");
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  onChanged: (value) {
                               createWaglController.emptyProductError="";
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
                                    fillColor: backgroundLightColor,
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
                                          color: colorBlack2Light,
                                          width: 0.5
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
                                    hintText: "Product name / Title",
                                    hintStyle: TextStyle(
                                      fontFamily: "Gilroy",
                                      color: colorGrey,
                                      fontSize: 1.4 * SizeConfig.textMultiplier/scaleFactor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 1*SizeConfig.heightMultiplier,
                                ),
                                createWaglController.emptyProductError!=""?CustContainer(
                                  borderColor: Colors.red,
                                  label: createWaglController.emptyProductError,
                                  labelColor: colorWhite,
                                  iconPath: "assets/icons/failed_1.png",
                                ):Container(),
                              ],
                            ),
                          ),
                          /*  Spacer(),*/
                          Padding(
                            padding:  EdgeInsets.symmetric(
                                horizontal: 3*SizeConfig.widthMultiplier),
                            child: CustButtonIconLast(
                                name: "Add",
                                size: 1.6,
                                btnColor: colorPrimary,
                                fontColor: colorBlack,
                                onSelected: () async {

                                  ConnectionChecker.checkConnection(
                                    context: context,
                                    onConnected: () async {

                                      if(createWaglController.checkProductFields()){
                                        BuildContext? dialogContext;
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false, // Prevent dismissal by tapping outside
                                          builder: (BuildContext context) {
                                            dialogContext = context; // Capture dialog context for later dismissal
                                            return CustomLoadingPopup();
                                          },
                                        );
                                        var result = await createWaglController.addProduct();
                                        // Get.back();
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        if (dialogContext != null && Navigator.canPop(dialogContext!)) {
                                          Navigator.pop(dialogContext!);
                                        }
                                      }
                                      else{
                                        print("image is empty");
                                      }

                                      // Get.back();
                                    },
                                  );


                                },
                                preIconPath:
                                "assets/icons/publish_icon.png"),
                          ),
                          SizedBox(
                            height: 7*SizeConfig.heightMultiplier,
                          )
                        ],
                      ),
                    ),
                  ),

                ]),
          ),
        ),
      ),
    );
  }
}
