import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wagl/home/home_page.dart';
import 'package:wagl/util/ApiClient.dart';
import 'package:http/http.dart' as http;
import '../services/remote_services.dart';
import 'follower_model_class.dart';
import 'following_model_class.dart';

class FollowerController extends GetxController {

  var searchFollowerController = TextEditingController();
  var searchFollowingController = TextEditingController();

  @override
  void onInit() async {
    // TODO: implement onInit
    // getAllCategories();
    // getCurrentLocation();
    // getSavedPost();
    // getUsersWagl(0);
    super.onInit();
  }


  List<Datum> followingUsers=[];
  List<Datuf> followerUserList=[];
  List<Datuf> filteredFollowerUserList=[];
  Future getFollowingList(userId) async {
    var getDetails;
    if(userId==0){
      getDetails =
      await RemoteServices.fetchGetData('api/follower-lists?populate[followersID][populate]=profilePic&filters[userID][\$eq]=${ApiClient.box.read("userId")}');
    
    }
    else{
      getDetails =
      await RemoteServices.fetchGetData('api/follower-lists?populate[followersID][populate]=profilePic&filters[userID][\$eq]=$userId');
      
    }

    if (getDetails.statusCode == 200) {
      followingUsers.clear();
      var apiDetails = followingModelClassFromJson(getDetails.body);
    var  followingUserListUnFiltered = apiDetails.data!;
      if(followingUserListUnFiltered!.isNotEmpty){
        // print("object:: ${followingUsers![0].attributes!.followersId!.data!.attributes!.username}");
        if(followingUserListUnFiltered!.isNotEmpty){
          for(int i=0;i<followingUserListUnFiltered.length;i++){
            if(followingUserListUnFiltered![i]
                .attributes!
                .followersId!
                .data!=null){
              followingUsers.add(followingUserListUnFiltered[i]);
            }
          }
          print("object:: ${followerUserList!.length}");


        }
      }
    } else {
      print("Failed to fetch data. Status code: ${getDetails.statusCode}");
    }
    update();
  }

  List selectedFollows = [];
  Future getFollowerUserList(userId) async {
    var getDetails;
    if(userId==0){
       getDetails =
      await RemoteServices.fetchGetData('api/follower-lists?populate[userID][populate]=profilePic&filters[followersID][\$eq]=${ApiClient.box.read("userId")}');
    }
    else{
       getDetails =
      await RemoteServices.fetchGetData('api/follower-lists?populate[userID][populate]=profilePic&filters[followersID][\$eq]=$userId');
    }
    if (getDetails.statusCode == 200) {
      followerUserList.clear();
      var apiDetails = followerModelClassFromJson(getDetails.body);
      var followerUserListUnFiltered = apiDetails.data!;
      try{
        if(followerUserListUnFiltered!.isNotEmpty){
          for(int i=0;i<followerUserListUnFiltered.length;i++){
            if(followerUserListUnFiltered![i]
                .attributes!
                .followersId!
                .data!=null){
              followerUserList.add(followerUserListUnFiltered[i]);
            }
          }
          print("object:: ${followerUserList!.length}");
          print("object:: ${followerUserList![0].attributes!.followersId!.data!.attributes!.username}");

        }
        print("object:: ${followerUserList!.length}");
      }catch(e){
        print("object:: $e ${followerUserList!.length}");
      }

    } else {
      print("Failed to fetch data. Status code: ${getDetails.statusCode}");
    }
    update();
  }


  // Method to filter followers by search query
  List<Datum> searchFollower(String query) {
    return followingUsers.where((user) {
      return user.attributes!.followersId!.data!.attributes!.username!.toLowerCase().contains(query.toLowerCase()) ||user.attributes!.followersId!.data!.attributes!.firstName!.toLowerCase().contains(query.toLowerCase()) ||
          user.attributes!.followersId!.data!.attributes!.lastName!.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Method to filter following by search query
  List<Datuf> searchFollowing(String query) {
    return followerUserList.where((user) {
      return user.attributes!.followersId!.data!.attributes!.username!.toLowerCase().contains(query.toLowerCase()) ||user.attributes!.followersId!.data!.attributes!.firstName!.toLowerCase().contains(query.toLowerCase()) ||
          user.attributes!.followersId!.data!.attributes!.lastName!.toLowerCase().contains(query.toLowerCase());
    }).toList();

  }


  Future<void> updateFollowing(int userId,bool status,followerRequest,int index,) async {
    print("Here  id : ${userId}");
    if(followerRequest){
      followingUsers[index].attributes!.followersId!.data!.attributes!.isFollow = status;
      update();
    }
    else{
      followingUsers[index].attributes!.followersId!.data!.attributes!.isFollow = status;
      update();
    }

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

    request.body = json.encode({
      "data": {
        "userID": ApiClient.box.read("userId"),
        "followersID": userId
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
    update(); // This will trigger a UI update
    }
    homeController.getHomeFeedWagl();
    update();
  }
}
