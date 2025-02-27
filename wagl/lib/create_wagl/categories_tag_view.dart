import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wagl/custom_widget/cust_appbar.dart';
import 'package:wagl/custom_widget/cust_button.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import 'package:wagl/util/SizeConfig.dart';
import '../custom_widget/colorsC.dart';
import 'create_wagl_controller.dart';

class CategoriesTagView extends StatelessWidget {
  CategoriesTagView({super.key});

  var createWaglController = Get.put(CreateWaglController());

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      backgroundColor: colorBlack,
      body: GetBuilder<CreateWaglController>(
          init: CreateWaglController(),
          builder: (controller) => Container(
                height: 100 * SizeConfig.heightMultiplier,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5 * SizeConfig.heightMultiplier,
                          ),
                          CustAppbar(title: "Add Category tags", icon: false),
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
                                    controller: createWaglController
                                        .searchCategoryController,
                                    cursorColor: colorWhite,
                                    obscureText: false,
                                    onTap: () {
                                      // FocusManager.instance.notifyListeners();
                                      print(
                                          "Here clicked ${createWaglController.viewConfirmButtonCategories}");
                                      createWaglController
                                          .updateConfirmCategoryButton(false);
                                    },
                                    onTapOutside: (Value) {
                                      print("ASDASDAS");
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      createWaglController
                                          .updateConfirmCategoryButton(true);
                                    },
                                    onChanged: (value) {
                                      print("searching categories${value}");
                                      createWaglController
                                          .filterCategories(value);
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
                                          width:
                                              2 * SizeConfig.widthMultiplier),
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
                                      hintText: "Search categories",
                                      hintStyle: TextStyle(
                                        fontFamily: "Gilroy",
                                        color: colorGrey,
                                        fontSize:
                                            1.5 * SizeConfig.textMultiplier/scaleFactor,
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
                                    name: "Suggested category tags",
                                    size: 1.6,
                                    colors: colorWhite,
                                    fontWeightName: FontWeight.w800),
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
                                createWaglController
                                        .selectedCategories.isEmpty
                                    ? Container()
                                    : Container(
                                        height: 5 * SizeConfig.heightMultiplier,
                                        child: ListView.builder(
                                            itemCount:
                                            controller.selectedCategories.length,
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                AlwaysScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              var category = controller
                                                  .selectedCategories[index];
                                              return Row(
                                                children: [
                                                  Chip(
                                                    label: CustText(
                                                      name:
                                                      category.attributes.categoryName,
                                                      fontWeightName:  FontWeight.w600,
                                                      size: 1.6 ,
                                                      colors: colorWhite,

                                                    ),
                                                    backgroundColor:
                                                        borderColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: borderColor,
                                                          width: 1),
                                                      // Thin white border
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20), // Adjust the border radius if needed
                                                    ),

                                                    deleteIcon: Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape:
                                                            BoxShape.circle,
                                                        color: Colors.black,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
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
                                                      controller.deselectCategory(
                                                          category);
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                ],
                                              );
                                            })),

                                /*Container(
                                  height: 5 * SizeConfig.heightMultiplier,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          controller.selectedCategories.length,
                                      itemBuilder: (context, index) {
                                        var category = controller
                                            .selectedCategories[index];
                                        return Card(
                                          margin: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(category.attributes.categoryName),
                                              IconButton(
                                                icon: Icon(Icons.remove_circle),
                                                onPressed: () {
                                                  controller.deselectCategory(
                                                      category);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),*/
                                Container(
                                  height: 60 * SizeConfig.heightMultiplier,
                                  width: 100 * SizeConfig.widthMultiplier,
                                  child: RefreshIndicator(
                                    color: colorPrimary,
                                    backgroundColor: colorBlack_2,
                                    onRefresh: () {
                                      return createWaglController
                                          .getCategoryTag();
                                    },
                                    child: ListView.builder(
                                        itemCount: createWaglController
                                            .filteredCategoriesList.length,
                                        scrollDirection: Axis.vertical,
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap:(){
                                                  createWaglController
                                                      .toggleSelection(
                                                      createWaglController
                                                          .filteredCategoriesList[
                                                      index]);
                                          },
                                                child: Container(
                                                  color:Colors.transparent,
                                                  width: 100*SizeConfig.widthMultiplier,
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
                                                            decoration:
                                                                const BoxDecoration(
                                                              shape: BoxShape
                                                                  .rectangle,
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets.all(2 *
                                                                      SizeConfig
                                                                          .widthMultiplier),
                                                              child: Image.network(
                                                                createWaglController
                                                                    .filteredCategoriesList[
                                                                        index]
                                                                    .attributes
                                                                    .categoryImage!
                                                                    .data
                                                                    .attributes
                                                                    .url,
                                                                fit: BoxFit.fill,
                                                                width: 10 *
                                                                    SizeConfig
                                                                        .widthMultiplier,
                                                                height: 5 *
                                                                    SizeConfig
                                                                        .heightMultiplier,
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
                                                                .filteredCategoriesList[
                                                                    index]
                                                                .attributes
                                                                .categoryName,
                                                            size: 1.6,
                                                            colors: c_white,
                                                            fontWeightName:
                                                                FontWeight.w500,
                                                          ),
                                                        ],
                                                      ),
                                                      /* Checkbox(
                                                        value: createWaglController
                                                            .selectedCategoriesIndex
                                                            .contains(createWaglController.selectedCategoryList[index].id),
                                                        onChanged: (bool? value) {
print("here is the wagl ${createWaglController.selectedCategoriesIndex}");
                                                          createWaglController
                                                              .updateCategoryTagsList(
                                                              createWaglController
                                                                  .filteredCategoriesList[index],
                                                                  value,
                                                                  index,
                                                              createWaglController
                                                                  .filteredCategoriesList[
                                                              index]
                                                                  .id,  createWaglController
                                                              .filteredCategoriesList[
                                                          index].attributes.categoryName);
                                                        },
                                                        activeColor: colorPrimary,
                                                        checkColor: Colors.black,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        5))),
                                                      ),*/
                                                      Checkbox(
                                                        value: createWaglController
                                                            .isSelected(
                                                                createWaglController
                                                                        .filteredCategoriesList[
                                                                    index]),
                                                        onChanged: (value) {
                                                          createWaglController
                                                              .toggleSelection(
                                                                  createWaglController
                                                                          .filteredCategoriesList[
                                                                      index]);
                                                        },
                                                        activeColor: colorPrimary,
                                                        checkColor: Colors.black,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2.5 *
                                                    SizeConfig.heightMultiplier,
                                                width: 100 *
                                                    SizeConfig.widthMultiplier,
                                                child: Divider(
                                                  height: 7 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  color: borderColor,
                                                  endIndent: 2 *
                                                      SizeConfig
                                                          .widthMultiplier,
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
                          // Container(width: 200,height: 500,color: Colors.red,)
                        ],
                      ),
                    ),
                    createWaglController.viewConfirmButtonCategories
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
                    createWaglController.viewConfirmButtonCategories
                        ? Positioned(
                            bottom: 2*SizeConfig.heightMultiplier,
                            right: 10,
                            left: 5,
                            child: CustButton(
                                btnColor: colorPrimary,
                                width: 100,
                                height: 7,
                                onSelected: () {
                                  Navigator.pop(context);
                                  // Get.back();
                                },
                                size: 1.6,
                                name: "Confirm",
                                fontColor: colorBlack),
                          )
                        : Container(),
                  ],
                ),
              )),
    );
  }
}
