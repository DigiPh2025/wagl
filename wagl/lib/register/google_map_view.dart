import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wagl/register/search_google_places.dart';
import '../../custom_widget/colorsC.dart';
import '../../custom_widget/cust_text.dart';
import '../../util/SizeConfig.dart';
import 'package:http/http.dart' as http;

import 'additional_details_controller.dart';


class GoogleMapView extends StatefulWidget {
  var numFlag;
  GoogleMapView(this.numFlag, {super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  double latitude = 18.49675221008349;
 // Replace with your actual latitude 18°34'46.0"N 73°28'58.7"E
  double longitude = 73.81048578768969;

  var additionalDetailsController = Get.put(AdditionalDetailsController());

  @override
  void dispose() {
    setState(() {
      additionalDetailsController.mapController = Completer();
      additionalDetailsController.getLocation(true,"");
    });

    super.dispose();
  }

  Future<List<String>> getPlacePhotos(lat,lng) async {
    String apiKey = 'AIzaSyACiIQ35rAygkhiknW2UpRh8dwABcf98FA';
    String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,additionalDetailsController.lng,$longitude&radius=500&type=point_of_interest&key=$apiKey';

    print("lat :: $lat");
    print("lng :: $lng");
    print("url :: $url");



    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> photoUrls = [];

      for (var place in data['results']) {
        if (place['photos'] != null && place['photos'].isNotEmpty) {
          String photoReference = place['photos'][0]['photo_reference'];
          String photoUrl =
              'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';
          photoUrls.add(photoUrl);
        }
      }

      print("photoUrls.length == :: ${photoUrls.length}");

      return photoUrls;
    } else {
      throw Exception('Failed to load place photos');
    }
  }

  @override
  Widget build(BuildContext context) {

    print("meetUpController :: =====");



    print("meetUpController :: ${additionalDetailsController.latlng}");
    return Scaffold(
      backgroundColor: backgroundLightColor,
      body: GetBuilder<AdditionalDetailsController>(
        init: AdditionalDetailsController(),
        builder: (controller) => Column(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 5 * SizeConfig.heightMultiplier,left: 2 * SizeConfig.widthMultiplier,right: 2 * SizeConfig.widthMultiplier),
                child:  Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {Navigator.pop(context);},
                        icon: Icon(
                          CupertinoIcons.back,
                          color: c_white,
                          size: 7 * SizeConfig.imageSizeMultiplier,
                        )),
                    CustText(name: "Select Location", size: 1.8, colors: c_white,
                        textAlign:TextAlign.start,fontWeightName:FontWeight.w600),

                  ],
                )
            ),

            Expanded(
              child: Stack(
                children: [
                GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: additionalDetailsController.latlng,
                        tilt: 5.440717697143555,
                        zoom: 50,

                      ),
                      scrollGesturesEnabled: true,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      mapToolbarEnabled: false,
                      compassEnabled: false,
                      zoomControlsEnabled: true,
                     // minMaxZoomPreference: const MinMaxZoomPreference(8, 20),

                      markers: Set<Marker>.of(additionalDetailsController.markers),

                     onCameraIdle: (){
                        print("tapping for update");
                        additionalDetailsController.getAddressFromLatLng();
                     },
                      onCameraMove: (position) {
                        print("position.longitude123 === 123");
                        additionalDetailsController.getCenter(position);
                      },
                      onMapCreated: (GoogleMapController controller) {
                        if (!additionalDetailsController.mapController.isCompleted) {
                          additionalDetailsController.mapController.complete(controller);
                          controller.setMapStyle(additionalDetailsController.mapTheme);
                        }else{
                          controller.setMapStyle(additionalDetailsController.mapTheme);
                          //other calling, later is true,
                          //don't call again completer()
                        }

                      },

                    ),

               /*   Container(
                    height: 5 * SizeConfig.heightMultiplier,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey.shade200.withOpacity(0.5),
                      borderRadius:BorderRadius.circular(8 * SizeConfig.widthMultiplier),

                    ),child: Row(children: [
                    SizedBox(width: 4.5 * SizeConfig.widthMultiplier),
                    Container(
                      width: 77 * SizeConfig.widthMultiplier ,
                      child: TextFormField(
                        textAlign:TextAlign.start ,
                        style: GoogleFonts.openSans(
                            textStyle:TextStyle(
                              color: c_white,
                              fontWeight: FontWeight.w600,
                              fontSize:1.8 * SizeConfig.textMultiplier,
                            )),
                        cursorColor: c_white,
                        onChanged: (value) {
                          additionalDetailsController.getLocation();
                        },
                        decoration:  InputDecoration(
                          //borderSide: BorderSide.none,
                          border: UnderlineInputBorder(),
                          hintText: 'Search',
                          hintStyle: GoogleFonts.openSans(
                              textStyle:TextStyle(
                                color: c_white,
                                fontSize: 1.8 * SizeConfig.textMultiplier,
                                fontWeight: FontWeight.w400,
                              )),

                          enabledBorder: UnderlineInputBorder(
                            // borderSide: BorderSide(color: Colors.white54),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                            //   borderSide: BorderSide(color: Colors.white54),
                          ),

                        ),
                      ),),
                    SizedBox(width: 3 * SizeConfig.widthMultiplier),
                    Icon(
                      Remix.search_line,
                      color: c_white,
                      size: 6 * SizeConfig.imageSizeMultiplier,
                    ),
                    SizedBox(width: 3 * SizeConfig.widthMultiplier),
                  ],),
                  ),*/
                  GestureDetector(
                    onTap: (){
                      Get.to(() => SearchGooglePlaces(controller: AdditionalDetailsController()));
                    },
                    child: Padding(
                      padding:  EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 5 * SizeConfig.heightMultiplier,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                                color: Color(0xFF404a59).withOpacity(0.8),
                              borderRadius:BorderRadius.circular(8 * SizeConfig.widthMultiplier),

                            ),child: Row(children: [
                            SizedBox(width: 4.5 * SizeConfig.widthMultiplier),
                            Container(
                              width: 75 * SizeConfig.widthMultiplier,
                              child: CustText(name: "Search Location", size: 1.8, colors: Colors.white,
                                  textAlign:TextAlign.start,fontWeightName:FontWeight.w400),
                            ),
                            SizedBox(width: 3 * SizeConfig.widthMultiplier),
                            Image.asset(
                               "assets/icons/search_icon.png",
                              fit: BoxFit.contain,
                              height: 3 * SizeConfig.heightMultiplier,
                              width: 5 * SizeConfig.widthMultiplier,
                            ),
                            SizedBox(width: 3 * SizeConfig.widthMultiplier),
                          ],),

                          ),
                        ],
                      ),
                    ),
                  ),
/*

                  Opacity(
                    opacity: 0.70,
                    child: Row(mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        CustButton1(name: "Move to another Circle", size: 58,
                            onSelected:  (flag) async {

                            }),
                      ],),
                  ),
                  */
                  Positioned(
                    bottom: 3 * SizeConfig.heightMultiplier,
                    child: Opacity(
                      opacity: additionalDetailsController.isMoved?0.20:1,
                      child: GestureDetector(
                        onTap: (){
                          print("\n Here ${additionalDetailsController.currentAddress}");
Get.back();                        },
                        child: Container(
                          width: 100 * SizeConfig.widthMultiplier,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                               //   height: 10 * SizeConfig.heightMultiplier,
                                width: 90 * SizeConfig.widthMultiplier,
                                decoration: BoxDecoration(
                                 /* gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Color(0xFF1A2448),
                                        Color(0xFF1A2448)])*/
                                  color: colorBackground,
                                  shape: BoxShape.rectangle,
                                  borderRadius:BorderRadius.circular(3 * SizeConfig.widthMultiplier),
                                ),child: Padding(
                                  padding:  EdgeInsets.only(top: 2 * SizeConfig.heightMultiplier,bottom: 2 * SizeConfig.heightMultiplier,
                                  left: 2 * SizeConfig.widthMultiplier,right: 2 * SizeConfig.widthMultiplier),
                                  child: Wrap(
                                  children: [
                                    CustText(name: additionalDetailsController.currentAddress, size: 1.8, colors: Colors.white,
                                        textAlign:TextAlign.start,fontWeightName:FontWeight.w400),

                                  ],),
                                ),

                              ),
                              SizedBox(height: 2 * SizeConfig.heightMultiplier),
                             /* Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      if(widget.numFlag == 1){

                                        if(additionalDetailsController.latPlacePhotos ==  additionalDetailsController.lat){

                                          showGeneralDialog(
                                            barrierLabel: "Label",
                                            barrierDismissible: false,
                                            barrierColor: Colors.black.withOpacity(0.5),
                                            transitionDuration: Duration(milliseconds: 500),
                                            context: context,
                                            pageBuilder: (context, anim1, anim2) {
                                              return PlaceImageSelection(additionalDetailsController.photoUrlList);
                                            },
                                            transitionBuilder: (context, anim1, anim2, child) {
                                              return SlideTransition(
                                                position: Tween(begin: Offset(1,  -1), end: Offset(0, 0)).animate(anim1),
                                                child: child,
                                              );
                                            },
                                          );
                                        }
                                        else{
                                          showDialog(context: context, builder: (BuildContext context) => CustomLoadingPopup());
                                          additionalDetailsController.getPlacePhotos().then((photoUrls) {
                                            Navigator.pop(context);
                                            print("photoUrls.length :: ${photoUrls.length}");
                                            // Handle the list of photo URLs as needed

                                            showGeneralDialog(
                                              barrierLabel: "Label",
                                              barrierDismissible: false,
                                              barrierColor: Colors.black.withOpacity(0.5),
                                              transitionDuration: Duration(milliseconds: 500),
                                              context: context,
                                              pageBuilder: (context, anim1, anim2) {
                                                return PlaceImageSelection(photoUrls);
                                              },
                                              transitionBuilder: (context, anim1, anim2, child) {
                                                return SlideTransition(
                                                  position: Tween(begin: Offset(1,  -1), end: Offset(0, 0)).animate(anim1),
                                                  child: child,
                                                );
                                              },
                                            );

                                            print("photoUrls.length :: ${photoUrls.length}");
                                          }).catchError((error) {
                                            print('Error: $error');
                                          });
                                        }
                                      }else{
                                        var chattingController = Get.put(ChattingController());
                                        chattingController.send("","",additionalDetailsController.currentAddress,additionalDetailsController.lat,additionalDetailsController.lng);
                                        Get.back();
                                      }

                              *//*
                                      print("numFlag  :$numFlag");
                                      if(numFlag ==1){
                                        var meetUpController = Get.put(MeetUpController());
                                        meetUpController.updateSelectAddMap(additionalDetailsController.currentAddress,additionalDetailsController.lat,additionalDetailsController.lng);
                                        Get.back();
                                      }else{
                                        print("numFlag  else :$numFlag");

                                        var chattingController = Get.put(ChattingController());
                                        chattingController.send("","",additionalDetailsController.currentAddress,additionalDetailsController.lat,additionalDetailsController.lng);
                                        Get.back();
                                      }

                                      *//*

                                    },
                                    child: Container(
                                      width: 60 * SizeConfig.widthMultiplier,
                                      height: 5 * SizeConfig.heightMultiplier,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [c_blue1.withOpacity(0.8),c_blue1.withOpacity(0.8),c_purple.withOpacity(0.9)],
                                          tileMode: TileMode.clamp,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(
                                          5 * SizeConfig.imageSizeMultiplier,
                                        )),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: Center(
                                        child: Text("Confirm Location",
                                            style: GoogleFonts.numans( // Numans
                                                textStyle:TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                    1.8 * SizeConfig.textMultiplier))),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5 * SizeConfig.widthMultiplier),
                                  GestureDetector(
                                    onTap: (){
                                      print("getLocation Clicked "); //Ou
                                      additionalDetailsController.getLocation(true,"");
                                    },
                                    child: Container(
                                      height: 12 * SizeConfig.widthMultiplier,
                                        width: 12 * SizeConfig.widthMultiplier,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: AssetImage('assets/icons/ellipse2.png'))),
                                        child: Icon(
                                          Remix.focus_3_line,
                                          color: c_white,
                                          size: 6 * SizeConfig.imageSizeMultiplier,
                                        ),
                                    ),
                                  ),
                                ],
                              ),*/
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MyMarker extends StatelessWidget {
  // declare a global key and get it trough Constructor

  MyMarker(this.globalKeyMyWidget);
  final GlobalKey globalKeyMyWidget;

  @override
  Widget build(BuildContext context) {
    // wrap your widget with RepaintBoundary and
    // pass your global key to RepaintBoundary
    return RepaintBoundary(
      key: globalKeyMyWidget,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 250,
            height: 180,
            decoration:
            BoxDecoration(color: Colors.black, shape: BoxShape.circle),
          ),
          Container(
              width: 220,
              height: 150,
              decoration:
              BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.accessibility,
                    color: Colors.white,
                    size: 35,
                  ),
                  Text(
                    'Widget',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ],
              )),
        ],
      ),
    );
  }


}
