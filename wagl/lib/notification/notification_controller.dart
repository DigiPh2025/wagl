import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:video_player/video_player.dart';
import 'package:wagl/util/ApiClient.dart';
import 'package:http/http.dart' as http;
import '../home/home_model.dart';
import '../home/home_page.dart';
import '../home/home_wagl_data_callback.dart';
import '../profile/profile_controller.dart';
import '../services/remote_services.dart';
import 'notification_model_class.dart';

class NotificationController extends GetxController {
  List contactNames = [];
  List selectedItemList = [];
  final List<HomeWaglDataClass> notificationWaglItems = [];

  List userCategoriesList =[];

  @override
  void onInit() {
    // TODO: implement onInit
    getNotificationDetails();
    super.onInit();
  }

  toggleSelection(int index, bool isSelected) {
    print(" Heshe is the index$index,,,, \n $isSelected");
    selectedItemList[index] = isSelected;
    print((selectedItemList));
    update();
  }



  List<ListElement> notificationList = [];
  List followListArray = [];
  bool isLoading=true;

  Future getNotificationDetails() async {
    isLoading=true;
    notificationList.clear();
    followListArray.clear();
    var map = {
      "data": {"skip": 1, "limit": 1000}
    };
    // var getDetails = await RemoteServices.fetchGetData(
    //     'api/notifications?filters[user_id][\$in][0]=${ApiClient.box.read("userId")}&sort=createdAt:desc&populate[user_id][populate]=*&populate[wagl_id][populate]=*');
    var getDetails = await RemoteServices.postMethodWithToken(
        'api/getNotificationList', map);

    print("Here us the ${getDetails.data} ");
    if (getDetails.statusCode == 200) {
      var apiDetails = notificationModelClassFromJsonFromJson(getDetails.data);
      // viewWaglModel=apiDetails;
      print("Here is the body ${getDetails.data}");

      notificationList = apiDetails.data?.list ?? [];
      for(int i=0;i<notificationList.length;i++){
        followListArray.add(notificationList[i].isFollow);
      print("senderId::${notificationList[i].senderId}");
      }
      isLoading=false;
      print("followListArray::${notificationList.length}");
      print("followListArray::${followListArray}");
      if (notificationList.isNotEmpty) {

      /*  print(
            "here is the notificationData === ${notificationList[0].createdAt}");
        notificationWaglItems.clear();

        for (int i = 0; i < notificationList.length; i++) {
          // if(i<50){
          if (notificationList[i].waglId != null) {
            var userIdData = notificationList[i].senderId!;
            print(
                "her is description ::${notificationList[i].description!}");

            var profilePicData = userIdData.profilePic;
            if (profilePicData != null &&
                profilePicData.url != null &&
                profilePicData.url!.isNotEmpty &&
                notificationList[i].waglId?.productId != null) {
              String? urlProfilePic = profilePicData.url;
              HomeWaglDataClass homeWagls = await getHomeWagls(
                  notificationList[i],
                  urlProfilePic,
                  notificationList[i].id!,
                  notificationList[i].waglId?.productId);
              notificationWaglItems.add(homeWagls);
            } else if (profilePicData != null &&
                profilePicData.url != null &&
                profilePicData.url!.isNotEmpty &&
                notificationList[i].waglId?.productId == null) {
              String? urlProfilePic = profilePicData.url;
              HomeWaglDataClass homeWagls = await getHomeWagls(
                  notificationList[i],
                  urlProfilePic,
                  notificationList[i].id!,
                  null);
              notificationWaglItems.add(homeWagls);
            } else {
              HomeWaglDataClass homeWagls = await getHomeWagls(
                  notificationList[i],
                  null,
                  notificationList[i].id!,
                  notificationList[i].waglId?.productId);
              notificationWaglItems.add(homeWagls);
            }
          }
          // }

          print("here is the Length ${notificationWaglItems.length}");
          print("here is the Length $notificationWaglItems");
        }*/
      }
    } else {
      print(
          "Failed to fetch data. Status getNotificationList :profile${getDetails.statusCode}");
    }

    update();
  }

  getSelectedProduct() {
    update();
  }
  VideoPlayerController videoController = VideoPlayerController.networkUrl(Uri.parse("uri"));
  updateFollower(int index, int followerId, bool status) async {
    print("\n\n\nhere 1 $followerId");
    print("\n\n\nhere 1 $status \n\n\n");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${ApiClient.box.read("authToken")}'
    };

    // Build the URL dynamically based on the status (follow/unfollow)
    var requestUrl = Uri.parse(
        '${RemoteServices.baseUrl}api/${status ? "follower-lists" : "unfollow"}');
    print(
        "here is Link ${RemoteServices.baseUrl}api/${status ? "follower-lists" : "unfollow"}");
    var request = http.Request('POST', requestUrl);
// notificationList[index].isFollow=status;
    request.body = json.encode({
      "data": {
        "userID": ApiClient.box.read("userId"),
        "followersID": followerId
      }
    });
    request.headers.addAll(headers);
    try {
      // Send the request and wait for the response
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());

        // Update the follow/unfollow status in the story item
      } else {
        print("Error: ${response.statusCode}, ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error during API call: $e");
    } finally {
      // This will trigger a UI update
    }
    getNotificationDetails();

    var profileController = Get.put(ProfileController());
    profileController.getUsersWagl(0);
    /*homeController.getHomeFeedWagl();*/
    update();
  }

  updateFollows(int index, status) {
    print("Here $status");

    update();
  }

  ///////////////////////////////////////////////
  final List<PersonStories> waglItem = [];

/*  getNotificationWagl(){

    PersonStories personItem =getPersonStories(attributes, url, wagls, productId);
    update();

  }*/

}
