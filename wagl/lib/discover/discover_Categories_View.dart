import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wagl/discover/discover_controller.dart';
import 'package:wagl/discover/wagl_categories_view.dart';
import 'package:wagl/util/ApiClient.dart';

import '../custom_widget/check_internet.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_text.dart';
import '../custom_widget/custom_loading_popup.dart';
import '../custom_widget/hexa_outcolor_widget.dart';
import '../util/SizeConfig.dart';

class DiscoverCategoriesView extends StatelessWidget {
  var discoverController = Get.put(DiscoverController());
   DiscoverCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DiscoverController>(
        builder: (controller)  {
        return GridView.builder(
          itemCount:
          discoverController.categoriesListItems.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0.0,
            childAspectRatio: 1,
          ),
          itemBuilder: (BuildContext context, int index) {
            return /*profileController
                    .userWagl!.isEmpty?Container(color: Colors.red,width: 100,height: 100,):*/
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 1 * SizeConfig.widthMultiplier,
                    vertical: 0.5 * SizeConfig.heightMultiplier),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      2 * SizeConfig.widthMultiplier),
                  child: GestureDetector(
                    onTap: () async {
                      if (await CheckInternet.checkInternet()) {
                        // Store a reference to the dialog's context
                        BuildContext? dialogContext;

                        // Show a loading dialog
                        showDialog(
                          context: context,
                          // barrierDismissible: false, // Prevent user from dismissing the dialog
                          builder: (BuildContext context) {
                            dialogContext = context; // Save dialog context for dismissal
                            return CustomLoadingPopup();
                          },
                        );

                        try {
                          // Clear existing data before fetching new data
                          discoverController.clearData();

                          // Fetch data for the selected category
                          final result = await discoverController.getAllCategoryWagls(
                            discoverController.categoriesListItems[index].id,
                          );

                          // Navigate to the next screen with the fetched data
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CategoriesWaglView(
                                categoriesData: discoverController.categoriesListItems,
                                categoryIndex: index,
                                categoryWagls: discoverController.categoryWagls,
                              ),
                            ),
                          );

                          // Update controller values after navigation
                          discoverController.updateDiscardValue(false);
                          discoverController.updateImageSize(false);
                        } catch (e) {
                          print("Error during operation: $e");
                        } finally {
                          // Dismiss the loading dialog
                          if (dialogContext != null && Navigator.canPop(dialogContext!)) {
                            Navigator.pop(dialogContext!);
                          }
                        }
                      } else {
                        // Show a no-internet alert dialog
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            backgroundColor: colorBlack_2,
                            title: Row(
                              children: [
                                Icon(Icons.info_outline),
                                SizedBox(width: 2 * SizeConfig.widthMultiplier),
                                CustText(
                                  name: 'No internet connection!',
                                  size: 1.8,
                                  colors: colorWhite,
                                  fontWeightName: FontWeight.w600,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                            content: Padding(
                              padding: EdgeInsets.only(
                                right: 3.0 * SizeConfig.widthMultiplier,
                                top: 2 * SizeConfig.heightMultiplier,
                              ),
                              child: CustText(
                                name: 'Please check your internet connection and try again.',
                                size: 1.5,
                                colors: colorWhite,
                                fontWeightName: FontWeight.w900,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: CustText(
                                  name: 'Cancel',
                                  size: 1.6,
                                  colors: colorWhite,
                                  fontWeightName: FontWeight.w600,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: CustText(
                                  name: 'OK',
                                  size: 1.6,
                                  colors: colorWhite,
                                  fontWeightName: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Check connection and handle any related actions

                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Image.network(
                        // savedWagl![index].attributes!.waglId!.data!.attributes!.media!.data![0].attributes.urlattributes.attributesMedia!.ext==".mp4"?savedWagl![index].attributes!.thumbnail!.attributes!.url!:savedWagl![index].attributes!.media!.data![0].attributesMedia!.formats!.thumbnail!.url!,
                        discoverController
                            .categoriesListItems[index]
                            .attributes!
                            .categoryImage!
                            .data!
                            .attributesImage!
                            ./*formats!.small!.*/url!,
                        fit: BoxFit.fill,
                        loadingBuilder: (BuildContext context,
                            Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return Stack(
                            children: [
                              Container(
                                  width: 50 *
                                      SizeConfig.widthMultiplier,
                                  height: 50 *
                                      SizeConfig.heightMultiplier,
                                  child: child),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 10 *
                                      SizeConfig.heightMultiplier,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        backgroundLightColor,
                                        Colors.transparent
                                      ], // Change colors as needed
                                    ),
                                  ),
                                ),
                              ),
                              loadingProgress == null
                                  ? Positioned(
                                bottom: 7,
                                left: 7,
                                // Positioned at the bottom
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/wagl_icon.svg",
                                          color: colorWhite,
                                          height: 2.0 *
                                              SizeConfig
                                                  .heightMultiplier,
                                          fit: BoxFit.contain,
                                        ),
                                        SizedBox(width: 2*SizeConfig.widthMultiplier,),
                                        CustText(
                                            name: discoverController
                                                .categoriesWaglCount.isEmpty||discoverController
                                                .categoriesWaglCount[
                                            index]==0?"":"${ApiClient.formatNumber(discoverController
                                                .categoriesWaglCount[
                                            index])} +",
                                            size: 1.5,
                                            colors: colorWhite,
                                            fontWeightName:
                                            FontWeight
                                                .w700),
                                      ],
                                    ),
                                    SizedBox(height: 1*SizeConfig.heightMultiplier,),
                                    Container(
                                      width: 32 *
                                          SizeConfig
                                              .widthMultiplier,
                                      child: CustText(
                                          name: discoverController
                                              .categoriesListItems[
                                          index]
                                              .attributes!
                                              .categoryName,
                                          size: 1.6,
                                          colors: colorWhite,
                                          fontWeightName:
                                          FontWeight
                                              .w700),
                                    ),
                                  ],
                                ),
                              )
                                  : Container(),
                              Positioned(
                                bottom: 10, // Positioned at the bottom
                                right: 10,
                                child: HexagonBorder(
                                  iconPath: "assets/icons/comment_icon.png",
                                ),
                              ),

                            ],
                              ); // Image is loaded, show the image
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress
                                    .expectedTotalBytes !=
                                    null
                                    ? loadingProgress
                                    .cumulativeBytesLoaded /
                                    loadingProgress
                                        .expectedTotalBytes!
                                    : null,
                                color: colorPrimary,
                                backgroundColor: backgroundLightColor,
                              ),
                            ); // Image is loading, show the loader
                          }
                        },
                        errorBuilder: (BuildContext context,
                            Object error, StackTrace? stackTrace) {
                          return Container(); // Handle error
                          // return Text('Failed to load image'); // Handle error
                        },
                      ),
                    ),
                  ),
                ),
              );
          },
        );
      }
    );
  }
}
