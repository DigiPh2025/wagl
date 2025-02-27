import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:wagl/custom_widget/cust_appbar.dart';
import '../../custom_widget/colorsC.dart';
import '../../custom_widget/cust_text.dart';
import '../../util/SizeConfig.dart';

class SearchGooglePlaces<T extends GetxController> extends StatelessWidget {
  final T controller;

  SearchGooglePlaces({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBlack,
      body: GetBuilder<T>(
        init: controller,
        builder: (controller) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5 * SizeConfig.heightMultiplier,
              ),
              CustAppbar(title: "Location", icon: false),
              Stack(
                children: [
                  Container(
                    height: 8 * SizeConfig.heightMultiplier,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        // stops: [0.9,0.8],
                        end: Alignment.topCenter,
                        colors: [colorBlack_2, colorBlack_2],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: GooglePlaceAutoCompleteTextField(
                      boxDecoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(
                            Radius.circular(2 * SizeConfig.widthMultiplier)),
                      ),
                      textEditingController:
                          (controller as dynamic).searchController,
                      googleAPIKey: "AIzaSyACiIQ35rAygkhiknW2UpRh8dwABcf98FA",
                      textStyle: TextStyle(
                        fontFamily: "Gilroy",
                        color: colorWhite,
                        fontWeight: FontWeight.w500,
                        fontSize: 1.6 * SizeConfig.textMultiplier,
                      ),
                      inputDecoration: InputDecoration(
                        hintText: "Search locations",
                        hintStyle: TextStyle(
                          fontFamily: "Gilroy",
                          color: colorWhite,
                          fontWeight: FontWeight.w500,
                          fontSize: 1.6 * SizeConfig.textMultiplier,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              2 * SizeConfig.widthMultiplier),
                          borderSide: BorderSide(
                            color: colorBlack2Light,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              2 * SizeConfig.widthMultiplier),
                          borderSide: BorderSide(
                            color: colorPrimary,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              2 * SizeConfig.widthMultiplier),
                          borderSide: BorderSide(
                            color: colorPrimary,
                          ),
                        ),
                        focusColor: colorPrimary,
                        suffixIcon: Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: GestureDetector(
                            onTap: () {

                              if ((controller as dynamic).isAddressSelected) {
                                (controller as dynamic)
                                    .searchController
                                    .clear();
                                (controller as dynamic).isAddressSelected =
                                    false;
                                (controller as dynamic).selectedAddress =
                                    "Add location";
                                (controller as dynamic).update();
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            child: Image.asset(
                              (controller as dynamic).isAddressSelected
                                  ? "assets/icons/close_icon.png"
                                  : "assets/icons/search_icon.png",
                              fit: BoxFit.contain,
                              height: 3 * SizeConfig.heightMultiplier,
                              width: 5 * SizeConfig.widthMultiplier,
                            ),
                          ),
                        ),
                        /* prefixIcon: Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back,
                            ),
                          ),
                        ),*/
                      ),
                      debounceTime: 400,
                      isLatLngRequired: true,
                      getPlaceDetailWithLatLng: (Prediction prediction) {
                        (controller as dynamic)
                            .updateLatlng(prediction.lat, prediction.lng);
                        Navigator.pop(context);
                      },
                      itemClick: (Prediction prediction) {
                        try {
                          (controller as dynamic).searchController.text =
                              prediction.description ?? "";
                          (controller as dynamic).searchController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: prediction.description?.length ?? 0));
                          print(
                              "placeDetails ${(controller as dynamic).searchController.text}");

                          (controller as dynamic).updateAddress();
                          print("Here is the corect");
                        } catch (e) {
                          print("Here is the exception $e");
                        }
                        // (controller as dynamic).updateLocation({(controller as dynamic).searchController.text});
                      },
                      itemBuilder: (context, index, Prediction prediction) {
                        return Container(
                          color: colorBlack,
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              SizedBox(width: 2 * SizeConfig.widthMultiplier),
                              Expanded(
                                  child: CustText(
                                      name: prediction.description ?? "",
                                      size: 1.8,
                                      colors: c_white,
                                      textAlign: TextAlign.start,
                                      fontWeightName: FontWeight.w500))
                            ],
                          ),
                        );
                      },
                      isCrossBtnShown: false,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
