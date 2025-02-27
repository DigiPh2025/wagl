import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:video_player/video_player.dart';
import 'package:wagl/discover/search_model.dart';
import 'package:wagl/home/home_page.dart';
import 'package:wagl/util/ApiClient.dart';
import '../home/all_wagl_model.dart';
import '../home/home_controller.dart';
import '../home/home_model.dart';
import '../profile/profile_model.dart';
import '../services/remote_services.dart';
import 'DiscoverCountModel.dart';
import 'categories_model_discover.dart';

class DiscoverController extends GetxController {

  @override
  void onInit() {
    // TODO: implement onInit
    getAllCategory();
    getFollowersList();
    clearData();
    super.onInit();
  }

  var searchTextController = TextEditingController();
  String searchQuery = "";
  bool isDiscard=false;
  // List<dynamic> searchResults = [];
  // List<dynamic> allResults = [];

  String selectedTab = 'Top';
  List selectedFollows = [];
  List<String> categories = ["Vegan", "Vegetables", "Technology", "Sports"];
  List<String> optionList = ["Report", "Block", "Share", "Copy profile","Cancel"];
  List<InterestedCategoryProfile>? userCategoriesList = [];
  List<dynamic> searchResults = [];
  List<DataWagl>? userWagls = [];
  ScrollController scrollController = ScrollController();
  bool isClipped =false;
  var profileImg;
  String profileImgUrl = "";
  ProfileDetailsModel? userDetails;
  bool isProfileLoading=true;
  bool isProfileWaglLoading=true;

updateLoaders(){
   isProfileLoading=true;
   isProfileWaglLoading=true;
  update();
}
  Future getProfileDetails(id) async {
    var getDetails;
    if (id != 0) {
      var userId = ApiClient.box.read("userId");
      getDetails = await RemoteServices.fetchGetData(
          'api/users/$id/?populate=*&interested_categories=*');
      if (getDetails.statusCode == 200) {
        userDetails=null;
        userDetails = profileDetailsFromJson(getDetails.body);
        isProfileLoading=false;
        if(profileImgUrl==""){
          print("here is image");
          profileImg = userDetails!.profilePic;
          if (userDetails!.profilePic == null) {
            profileImg = null;
          } else {
            profileImgUrl = userDetails!.profilePic!.url;
          }
        }
        if (userDetails!.recentCategories != null) {
          userCategoriesList!.clear();
          for (int i = 0; i < userDetails!.recentCategories!.length; i++) {
            userCategoriesList!.add(userDetails!.recentCategories![i]);
          }
        }
      } else {
        print(
            "Profile Controller  Failed to fetch data. Status code:profile1111${getDetails.statusCode}");
      }
    }

    update();
  }

Future blockUserApi(int blockUserId) async {
  Map<String, dynamic> map = {
    "data": {
      "user_id":ApiClient.box.read("userId"),
      "block_id":blockUserId,
    }
  };

  print("print the map ${map}");
  // var getDetails = await RemoteServices.postMethodWithToken('api/report-wagls', waglData);
  var getDetails = await RemoteServices.postMethodWithToken(
      'api/block-users', map);
  print("here is the wagl Report Brfore ");
  if (getDetails.statusCode == 200) {
    print("here is the wagl Report ${getDetails.statusCode}");
  } else {
    print("here is the wagl Report ${getDetails.statusCode}");
  };

    update();
}
var categoryFilters;
Future clearRecentCategoriesFilter(userId) async {
  selectedUserCategoriesIndex.clear();
  selectedUserCategoriesList.clear();
  categoryFilters="";
  getUsersWagl(userId);
    update();
}
void updateImageSize(bool status){
  print("here is isClipped $isClipped");
  isClipped=status;
  update();
}


  void updateDiscardValue(bool value) {
    isDiscard=value;
    print("here is the value $isDiscard");
  }
  Future getUsersWagl(userId) async {
    var categoryFilters = selectedUserCategoriesList
        .map((id) => 'filters[interested_categories][\$eq]=$id')
        .join('&');
    print("here are the list $categoryFilters");
    print("here is the getUsersWagl ${categoryFilters.runtimeType}");

    var getDetails = await RemoteServices.fetchGetData(
        'api/wagls?populate[media][sort]=name:asc&populate[thumbnail]=*&sort=createdAt:desc&populate[media][populate]=media&filters[user_id][\$eq]=$userId&populate[user_id][populate]=*&$categoryFilters');

    print("Here us the ${getDetails.body} ");
    if (getDetails.statusCode == 200) {
      var apiDetails = viewAllWaglModelFromJson(getDetails.body);
      // viewWaglModel=apiDetails;
      isProfileWaglLoading=false;

      userWagls!.clear();
      userWagls = apiDetails.data;

    } else {
      print(
          "Failed to fetch data. Status code:profile2222${getDetails.statusCode}");
    }
    // getTotalViewCount();
    update();
  }
  List<DataWagl>? goodTagWagls = [];
  List<DataWagl>? categoryTagWagls = [];
  final List<PersonStories> goodTagWaglItems = [];
  final List<PersonStories> categoryWaglItems = [];
  Future getGoodTagWagls(id) async {
    print("here is the id =#=#=# $id");
    var getDetails = await RemoteServices.fetchGetData(
        'api/wagls?filters[good_tags][\$eq]=$id&populate[media]=*&populate[thumbnail]=*&sort=createdAt:desc&populate[interested_categories]populate=*&filters[isActive][\$eq]=true&pagination[pageSize]=100&pagination[page]=1&populate[user_id]=*&populate[good_tags][populate]=image&populate[product_id][populate]=*');
    if (getDetails.statusCode == 200) {
      goodTagWagls!.clear();
      var apiDetails = viewAllWaglModelFromJson(getDetails.body);
      goodTagWagls = apiDetails.data ?? [] ;
      print("Here is the Length ${apiDetails.data!.length}");
      print("Here is the Length ${goodTagWagls!.length}");
      if (goodTagWagls!.isNotEmpty) {
        for (int i = 0; i < goodTagWagls!.length; i++) {
          if(goodTagWagls![i].attributes!.userId!.data!=null){
            var userIdData = goodTagWagls![i].attributes!.userId!.data;
            var profilePicData = userIdData!.attributes!.profilePicData;
            // goodTags = goodTagWagls![i].attributes!.goodTags!.data;
            // print("here is the goodTags ${goodTags[1].attributes!.toJson()}");
            if (profilePicData != null &&
                profilePicData.data != null &&
                profilePicData.data!.attributes!.url != null &&
                profilePicData.data!.attributes!.url!.isNotEmpty) {
            } else {}
          }

        }
        storyViewIndex = 0;
        goodTagWaglItems.clear();
        for (int i = 0; i < goodTagWagls!.length; i++) {
          if(goodTagWagls![i].attributes!.userId!.data!=null){
            var userIdData = goodTagWagls![i].attributes!.userId!.data;
            var profilePicData = userIdData!.attributes!.profilePicData;

            if(goodTagWagls![i].attributes!.productId!.data!=null){
              print("here us the value ");
              print("here is the product ${goodTagWagls![i].attributes!.productId!.data!.attributes!.name}");

              if (profilePicData != null &&
                  profilePicData.data != null &&
                  profilePicData.data!.attributes!.url != null &&
                  profilePicData.data!.attributes!.url!.isNotEmpty) {
                String? urlProfilePic = profilePicData.data!.attributes!.url;
                PersonStories personItem =
                getPersonStories(goodTagWagls![i].attributes!, urlProfilePic,goodTagWagls![i].id!,goodTagWagls![i].attributes!.productId!);
                goodTagWaglItems.add(personItem);
              }
              else {
                PersonStories personItem =
                getPersonStories(goodTagWagls![i].attributes!, null,goodTagWagls![i].id!,goodTagWagls![i].attributes!.productId!);
                goodTagWaglItems.add(personItem);
              }
            }
            else{
              print("here is the empty Product ");
              if (profilePicData != null &&
                  profilePicData.data != null &&
                  profilePicData.data!.attributes!.url != null &&
                  profilePicData.data!.attributes!.url!.isNotEmpty) {
                String? urlProfilePic = profilePicData.data!.attributes!.url;
                PersonStories personItem =
                getPersonStories(goodTagWagls![i].attributes!, urlProfilePic,goodTagWagls![i].id!,null);
                goodTagWaglItems.add(personItem);
              }
              else {
                PersonStories personItem =
                getPersonStories(goodTagWagls![i].attributes!, null,goodTagWagls![i].id!,null);
                goodTagWaglItems.add(personItem);
              }
            }

          }

        }
      } else {
        print("Empty Wagls");
      }
    } else {
      print(
          "Failed to fetch data. Status code:Discover ${getDetails.statusCode}");
    }
    update();
  }
  Future getCategoryTagsWagls(id,index) async {
    print("here is the id===> $id");
    var getDetails = await RemoteServices.fetchGetData(
        'api/wagls?populate[media][sort]=name:asc&filters[interested_categories][\$eq]=$id&populate[media]=*&populate[thumbnail]=*&sort=createdAt:desc&populate[interested_categories]populate=*&filters[isActive][\$eq]=true&pagination[pageSize]=100&pagination[page]=1&populate[user_id]=*&populate[good_tags][populate]=image&populate[product_id][populate]=*');

    if (getDetails.statusCode == 200) {
      categoryWaglItems!.clear();
      goodTagWaglItems.clear();
      var apiDetails = viewAllWaglModelFromJson(getDetails.body);
      categoryTagWagls = apiDetails.data ?? [] ;
      print("Here is the Length ${apiDetails.data!.length}");
      print("Here is the Length ${categoryTagWagls!.length}");
      if (categoryTagWagls!.isNotEmpty) {
        for (int i = 0; i < categoryTagWagls!.length; i++) {
          if(categoryTagWagls![i].attributes!.userId!.data!=null){
            var userIdData = categoryTagWagls![i].attributes!.userId!.data;
            var profilePicData = userIdData?.attributes!.profilePicData;
            // goodTags = goodTagWagls![i].attributes!.goodTags!.data;
            // print("here is the goodTags ${goodTags[1].attributes!.toJson()}");
            if (profilePicData != null &&
                profilePicData.data != null &&
                profilePicData.data!.attributes!.url != null &&
                profilePicData.data!.attributes!.url!.isNotEmpty) {
            } else {

            }
          }

        }
        storyViewIndex = index;
        categoryWaglItems.clear();
        for (int i = 0; i < categoryTagWagls!.length; i++) {
          if(categoryTagWagls![i].attributes!.userId!.data!=null){
            var userIdData = categoryTagWagls![i].attributes!.userId!.data;
            var profilePicData = userIdData!.attributes!.profilePicData;

            if(categoryTagWagls![i].attributes!.productId!.data!=null){
              print("here us the value ");
              print("here is the product ${categoryTagWagls![i].attributes!.productId!.data!.attributes!.name}");

              if (profilePicData != null &&
                  profilePicData.data != null &&
                  profilePicData.data!.attributes!.url != null &&
                  profilePicData.data!.attributes!.url!.isNotEmpty) {
                String? urlProfilePic = profilePicData.data!.attributes!.url;
                PersonStories personItem =
                getPersonStories(categoryTagWagls![i].attributes!, urlProfilePic,categoryTagWagls![i].id!,categoryTagWagls![i].attributes!.productId!);
                categoryWaglItems.add(personItem);
              }
              else {
                PersonStories personItem =
                getPersonStories(categoryTagWagls![i].attributes!, null,categoryTagWagls![i].id!,categoryTagWagls![i].attributes!.productId!);
                categoryWaglItems.add(personItem);
              }
            }
            else{
              print("here is the empty Product ");
              if (profilePicData != null &&
                  profilePicData.data != null &&
                  profilePicData.data!.attributes!.url != null &&
                  profilePicData.data!.attributes!.url!.isNotEmpty) {
                String? urlProfilePic = profilePicData.data!.attributes!.url;
                PersonStories personItem =
                getPersonStories(categoryTagWagls![i].attributes!, urlProfilePic,categoryTagWagls![i].id!,null);
                categoryWaglItems.add(personItem);
              }
              else {
                PersonStories personItem =
                getPersonStories(categoryTagWagls![i].attributes!, null,categoryTagWagls![i].id!,null);
                categoryWaglItems.add(personItem);
              }
            }
          }
        }
      } else {
        print("Empty Wagls");
      }
    } else {
      print(
          "Failed to fetch data. Status code:Discover ${getDetails.statusCode}");
    }
    update();
  }
  Future getProductWagls(id,index) async {
    print("here is the id===> $id");
    var getDetails = await RemoteServices.fetchGetData(
        'api/wagls?populate[media][sort]=name:asc&filters[product_id][\$eq]=$id&populate[media]=*&populate[thumbnail]=*&sort=createdAt:desc&populate[interested_categories]populate=*&filters[isActive][\$eq]=true&pagination[pageSize]=200&pagination[page]=1&populate[user_id]=*&populate[good_tags][populate]=image&populate[product_id][populate]=*');

    if (getDetails.statusCode == 200) {
      categoryWaglItems!.clear();
      goodTagWaglItems.clear();
      var apiDetails = viewAllWaglModelFromJson(getDetails.body);
      categoryTagWagls = apiDetails.data ?? [] ;
      print("Here is the Length ${apiDetails.data!.length}");
      print("Here is the Length ${categoryTagWagls!.length}");
      if (categoryTagWagls!.isNotEmpty) {
        for (int i = 0; i < categoryTagWagls!.length; i++) {
          if(categoryTagWagls![i].attributes!.userId!.data!=null){
            var userIdData = categoryTagWagls![i].attributes!.userId!.data;
            var profilePicData = userIdData?.attributes!.profilePicData;
            // goodTags = goodTagWagls![i].attributes!.goodTags!.data;
            // print("here is the goodTags ${goodTags[1].attributes!.toJson()}");
            if (profilePicData != null &&
                profilePicData.data != null &&
                profilePicData.data!.attributes!.url != null &&
                profilePicData.data!.attributes!.url!.isNotEmpty) {
            } else {

            }
          }

        }
        storyViewIndex = index;
        categoryWaglItems.clear();
        for (int i = 0; i < categoryTagWagls!.length; i++) {
          if(categoryTagWagls![i].attributes!.userId!.data!=null){
            var userIdData = categoryTagWagls![i].attributes!.userId!.data;
            var profilePicData = userIdData!.attributes!.profilePicData;

            if(categoryTagWagls![i].attributes!.productId!.data!=null){
              print("here us the value ");
              print("here is the product ${categoryTagWagls![i].attributes!.productId!.data!.attributes!.name}");

              if (profilePicData != null &&
                  profilePicData.data != null &&
                  profilePicData.data!.attributes!.url != null &&
                  profilePicData.data!.attributes!.url!.isNotEmpty) {
                String? urlProfilePic = profilePicData.data!.attributes!.url;
                PersonStories personItem =
                getPersonStories(categoryTagWagls![i].attributes!, urlProfilePic,categoryTagWagls![i].id!,categoryTagWagls![i].attributes!.productId!);
                categoryWaglItems.add(personItem);
              }
              else {
                PersonStories personItem =
                getPersonStories(categoryTagWagls![i].attributes!, null,categoryTagWagls![i].id!,categoryTagWagls![i].attributes!.productId!);
                categoryWaglItems.add(personItem);
              }
            }
            else{
              print("here is the empty Product ");
              if (profilePicData != null &&
                  profilePicData.data != null &&
                  profilePicData.data!.attributes!.url != null &&
                  profilePicData.data!.attributes!.url!.isNotEmpty) {
                String? urlProfilePic = profilePicData.data!.attributes!.url;
                PersonStories personItem =
                getPersonStories(categoryTagWagls![i].attributes!, urlProfilePic,categoryTagWagls![i].id!,null);
                categoryWaglItems.add(personItem);
              }
              else {
                PersonStories personItem =
                getPersonStories(categoryTagWagls![i].attributes!, null,categoryTagWagls![i].id!,null);
                categoryWaglItems.add(personItem);
              }
            }
          }
        }
      } else {
        print("Empty Wagls");
      }
    } else {
      print(
          "Failed to fetch data. Status code:Discover ${getDetails.statusCode}");
    }
    update();
  }
  VideoPlayerController videoController = VideoPlayerController.networkUrl(Uri.parse("uri"));

  var list = [];
  sortMedia1(lengthMedia){
    list = [];
    for(int i=0;i<lengthMedia.length;i++){
      final number1 = int.tryParse(lengthMedia[i].split('_')[0]) ?? 0;

      list.add(number1);
      print("sortMedia 1 :: $list");
      list.sort();
      print("sortMedia 2 :: $list");
    }
    list.sort();
    update();
  }
  List<String> sortedUrl=[];
  sortMedia(lengthMedia,index,){
    var a;
    for(int i=0;i<lengthMedia.length;i++){
      final number1 = int.tryParse(lengthMedia[i].split('_')[0]) ?? 0;
      print("no;;; $number1 ::index $index ");
      if(index==number1){
        a= sortedUrl[i];
        print("here is sored index ${a}  a");
        break;
      }
    }
    print("here is and the generateVideoThumbnail link ${lengthMedia}");
    print("here is  and the name of the file ${index}");
    return a;
  }

  getPersonStories(WaglAttributes attributes, url,int wagls,productId) {
    final attributesUser = attributes.userId!.data!.attributes!;
    final List<String> mediaUrls = attributes.media!.data!
        .map((mediaItem) => mediaItem.attributesMedia!.url!)
        .toList();
    final List<String> mediaExt = attributes.media!.data!
        .map((mediaItem) => mediaItem.attributesMedia?.ext??"")
        .toList();
    final sortedMedia = List.from(attributes.media!.data!)
      ..sort((media1, media2) {
        final number1 = int.tryParse(media1.attributesMedia!.name!.split('_')[0]) ?? 0;
        final number2 = int.tryParse(media2.attributesMedia!.name!.split('_')[0]) ?? 0;
        return number1.compareTo(number2); // Ascending order
      });
    print("here is the mediaURL:::$sortedMedia");
    final List<int> mediaIds = attributes.media!.data!
        .map((mediaItem) => mediaItem.id!)
        .toList();
    sortedUrl.clear();
    sortedUrl=mediaUrls;
    final List<String> mediaNames = attributes.media!.data!
        .map((mediaItem) => mediaItem.attributesMedia!.name!)
        .toList();
  for(int i=0;i<sortedMedia.length;i++){
    print("here is the sort media file ${sortedMedia[i].attributesMedia!.url}");
   }
print("here is the sort media file $sortedMedia");
    List<String> sortedUrls=[];
    List<String> sortedIds=[];
    sortedUrls.clear();
    sortedIds.clear();
    print("here is the lengthhere ::${mediaNames.length}");
    sortMedia1(mediaNames);
    print("sortedUrls aa :: $list");
    for(int i=0;i<mediaNames.length;i++){
      sortedUrls.add(sortMedia(mediaNames,list[i]));
    }
    return PersonStories(
      username: "${attributesUser.username}",
      profileImage: url,
      description: "${attributes.description}",
      location: "${attributes.location}",
      likes: attributes.totalLikes ?? 0,
      totalComments: attributes.totalComments ?? 0,
      views: attributes.totalViews ?? 0,
      userId: attributes.userId!.data!.id,
      waglId: wagls,
      productId:productId,
      sortedMedia: sortedMedia,
      totalSaved: attributes.totalSaved ?? 0,
      // categoryData:attributesCategories,
      liked: true,
      saved: false,
      mediaExt: mediaExt,
      categoryData: attributes.interestedCategories!.data!,
      goodTagData: attributes.goodTags!.data!,
      controller: StoryController(),
      media: sortedUrls,
      mediaName: mediaNames,
      mediaId: mediaIds,
      // stories: [...List.generate(2, (index) => attributes.media.data[index].attributesMedia.url)],
      stories: [
        ...List.generate(
          sortedMedia.length,
              (index) {
            final media = sortedMedia[index];
            return media.attributesMedia!.ext == ".mp4"||media.attributesMedia!.ext =="mov"||media.attributesMedia!.ext =="hevc"
                ? StoryItem.pageVideo(
              "${media.attributesMedia!.url}",
              controller: StoryController(),

              // videoController: videoController,
              duration: Duration(seconds: 40),
            )
                : StoryItem.pageImage(
              url: "${media.attributesMedia!.url}",
              duration: Duration(seconds: 40),
              controller: StoryController(),
            );
          },
        ),
      ],
      isFollows: false,
    );
  }


  Timer? _debounceTimer;
  List<GoodTag> goodTagList = [];
  List<InterestedCategory> categoriesList = [];
  List<SearchUser> userList = [];
  List<Data> categoriesListItems = [];
  List<Data> categoriesItemSearched = [];

  List<int> categoriesIds=[];
  List<int> categoriesWaglCount=[];
  getCategoriesIds() async {
    categoriesIds=[];
    categoriesWaglCount=[];
    for(int i=0;i<categoriesListItems.length;i++){
      categoriesIds.add(categoriesListItems[i].id!);
    }
    print("here is the categoriesIds  $categoriesIds ");

    List<int> totals = await fetchWaglData(categoriesIds);
    print("here is the total Categories  counts $totals");
    categoriesWaglCount=totals;
    update();
  }

  Future<List<int>> fetchWaglData(List<int> categoriesIds) async {
    List<int> totals = [];

    for (int id in categoriesIds) {
      try {
        // Construct the URL with the dynamic ID
        var response = await RemoteServices.fetchGetData(
            "api/wagls?filters[interested_categories][\$eq]=$id&filters[isActive][\$eq]=true&filters[user_id][\$ne]=${ApiClient.box.read("userId")}");

        // Send the GET request
        //  = await http.get(url);

        if (response.statusCode == 200) {
          // Parse the response
          // final jsonResponse = json.decode(response.body);
          final discoverWaglCount = discoverWaglCountFromJson(response.body);

          // Extract the `total` value and add to the list
          final total = discoverWaglCount.meta?.pagination?.total ?? 0;
          totals.add(total);
        } else {
          print("Failed to fetch data for ID $id: ${response.statusCode}");
        }
      } catch (e) {
        print("Error fetching data for ID $id: $e");
      }
    }

    return totals;
  }
  Future<void> search(String query) async {
    var request;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${ApiClient.box.read('authToken')}'
    };
    request = http.MultipartRequest(
        'POST', Uri.parse('${RemoteServices.baseUrl}api/searchSuggestions'));
    request.fields.addAll({'searchKey': query});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      var decodedResponse = jsonDecode(responseString);
      var apiDetails = searchModelFromJson(responseString);
      goodTagList = apiDetails.data.goodTags;
      categoriesList = apiDetails.data.interestedCategories;
      userList = apiDetails.data.users;
      // Handle the decoded response (e.g., populate your search results)
    } else {
      print(response.reasonPhrase);
      print(response.statusCode);
    }

    // Local search results update
    if (query.isEmpty) {
      searchResults.clear();
      goodTagList.clear();
      categoriesList.clear();
      userList.clear();

    } else {
      searchResults = [
        ...goodTagList.where((goodTag) => goodTag.attributes.name
            .toLowerCase()
            .contains(query.toLowerCase())),
        ...categoriesList.where((category) => category.attributes.categoryName
            .toLowerCase()
            .contains(query.toLowerCase())),
        ...userList.where((user) =>
            user.attributes.username
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            user.attributes.firstName
                .toLowerCase()
                .contains(query.toLowerCase())),
        1
      ];

    }
    update(); // Update the UI
  }

  Future getCategoryData(searchId) async {
    await categoriesItemSearched.clear;
    print("here is the CategoryData ${categoriesItemSearched}");
    categoriesItemSearched = [
      ...categoriesListItems.where((data) => data.id == searchId),
    ];
    print(
        "here is the CategoryData ${categoriesItemSearched[0].attributes!.categoryName}");
    update();
  }

  Future getAllCategory() async {
    var getDetails = await RemoteServices.fetchGetData(
        'api/interested-categories?fields[0]=categoryName&populate[categoryIcon][fields][0]=*&populate[categoryImage]=*&fields[1]=totalWagls&sort[0]=categoryName');
    if (getDetails.statusCode == 200) {
      categoriesListItems.clear();
      var apiDetails = viewAllCategoriesModelFromJson(getDetails.body);
      categoriesListItems = apiDetails.data!;
      getCategoriesIds();
    } else {
      print(
          "Failed to fetch data. Status code: Discover ${getDetails.statusCode}");
    }
    update();
  }

  List<DataWagl> categoryWagls = [];
  List<DataWagl> searchCategoryWagls = [];

  Future getAllCategoryWagls(id) async {
    var getDetails = await RemoteServices.fetchGetData(
        'api/wagls?populate[media][sort]=name:asc&filters[interested_categories][\$eq]=$id&populate[media]=*&populate[thumbnail]=*&filters[user_id][\$ne]=${ApiClient.box.read("userId")}&populate[good_tags]=*&sort=createdAt:desc&populate[interested_categories]=*&filters[isActive][\$eq]=true&pagination[pageSize]=200&pagination[page]=1&populate[user_id][populate]=profilePic&populate[product_id][populate]=*');

    if (getDetails.statusCode == 200) {
      categoryWagls.clear();
      var apiDetails = viewAllWaglModelFromJson(getDetails.body);
      categoryWagls = apiDetails.data ?? [];
      print("Here is the Length ${apiDetails.data!.length}");
      print("Here is the Length ${categoryWagls.length}");
      for(int i=0;i<categoryWagls.length;i++){
        if(categoryWagls[i].attributes!.userId!.data==null){
          categoryWagls.removeAt(i);
          print("here is the  delete index $i");
        }
      }

    } else {
      print(
          "Failed to fetch data. Status code:Discover ${getDetails.statusCode}");
    }
    update();
  }
  Future getAllProductWagls(id) async {
    var getDetails = await RemoteServices.fetchGetData(
        'api/wagls?filters[product_id][\$eq]=$id&&populate[media]=*&populate[thumbnail]=*&populate[good_tags]=*&sort=createdAt:desc&populate[interested_categories]=*&filters[isActive][\$eq]=true&pagination[pageSize]=200&pagination[page]=1&populate[user_id][populate]=profilePic&populate[product_id][populate]=*');

    if (getDetails.statusCode == 200) {
      categoryWagls.clear();
      var apiDetails = viewAllWaglModelFromJson(getDetails.body);
      categoryWagls = apiDetails.data ?? [];
      print("Here is the Length ${apiDetails.data!.length}");
      print("Here is the Length ${categoryWagls.length}");
      for(int i=0;i<categoryWagls.length;i++){
        if(categoryWagls[i].attributes!.userId!.data==null){
          categoryWagls.removeAt(i);
          print("here is the  delete index $i");
        }
      }

    } else {
      print(
          "Failed to fetch data. Status code:Discover ${getDetails.statusCode}");
    }
    update();
  }
  Future getCategoryWagls(id) async {
    print("here is the id ####$id");
    var getDetails = await RemoteServices.fetchGetData(
        'api/wagls?filters[interested_categories][\$eq]=$id&populate[media]=*&populate[thumbnail]=*&populate[good_tags]=*&sort=createdAt:desc&populate[interested_categories]=*&filters[isActive][\$eq]=true&pagination[pageSize]=200&pagination[page]=1&populate[user_id][populate]=profilePic');

    if (getDetails.statusCode == 200) {
      searchCategoryWagls.clear();
      var apiDetails = viewAllWaglModelFromJson(getDetails.body);
      searchCategoryWagls = apiDetails.data ?? [];
      print("Here is the Length ${apiDetails.data!.length}");
      print("Here is the Length ${searchCategoryWagls.length}");
    } else {
      print(
          "Failed to fetch data. Status code:Discover ${getDetails.statusCode}");
    }
    update();
  }

  clearData() {
    searchTextController.clear();
    searchResults.clear();
    isProfileLoading=true;
    isProfileWaglLoading=true;
    isLoading=false;
    update();
  }

  bool isFollows = false;

  updateFollows(status,index,SearchUser user) async {
    print("Here follows:: ${user.attributes.following}");
    print("Here  id : ${user.id}");
    user.attributes.following = status;
    update();
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
        "followersID": user.id
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
    getFollowersList();
    homeController.getHomeFeedWagl();
    update();
  }
  List<int>? followersList = [];
  Future getFollowersList() async {
    var getDetails = await RemoteServices.fetchGetData('api/getFollowersList');
    if (getDetails.statusCode == 200) {
      var apiDetails = viewCountModelFromJson(getDetails.body);
      followersList = apiDetails.result;
      if (followersList!.isNotEmpty) {
        print("\n\n here is the followersList::${followersList}");
        // profileDetails=apiDetails;
      } else {


      }
    } else {
      print(
          "Failed to fetch data. Status code:profile3333${getDetails.statusCode}");
    }
    update();
  }

  List selectedUserCategoriesIndex = [];
  List selectedUserCategoriesList = [];
  bool checkedFollowedUser(int userId) {
    final Set<int> idSet = followersList!.toSet();
    if (idSet.contains(userId)) {
      print("$followersList");
      print("here is the followed User $userId ");
      // update();
      // isFollows = !isFollows;
      return true;
    } else {
      print("$followersList");
      print("here is the present follower $userId  $isFollows");
      // isFollows = !isFollows;
      return false;
    }
  }
bool isLoading=false;
  bool isClicked=true;
  Future updateFollower(int followerId, bool status) async {
    isLoading=true;
    // isLoadingUpdate(true);
    isClicked=false;
    print("\n\n\nhere 1 isClicked| $isClicked");
    print("\n\n\nhere 1\n\n\n");
    print("here is the follower id $followerId");
if(status){
  userDetails!.totalFollowers++;
}else if (userDetails!.totalFollowers > 0) {
  userDetails!.totalFollowers--; // Prevent negative follower count
} else {
  print("Warning: Follower count is already at 0");
}
    update();
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
        // isFollows = !status;
      } else {
        print("Error: ${response.statusCode}, ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error during API call: $e");
    } finally {
      // isProcessing = false;

    }
    await getFollowersList();
     homeController.getHomeFeedWagl();
    homeController.update();
    isLoading=false;
    isClicked=true;
    update();
  }

/*isLoadingUpdate(status){
  isLoading=status;
    update();
}*/

  Future getUserFilteredWaglsFromCategories(int index,userid) async {
    if (selectedUserCategoriesIndex.contains(index)) {
      selectedUserCategoriesIndex.remove(index);
      selectedUserCategoriesList.remove(userCategoriesList![index].id);
    } else {
      selectedUserCategoriesIndex.add(index);
      selectedUserCategoriesList.add(userCategoriesList![index].id);
    }
    print("$selectedUserCategoriesIndex");
    print("Here is the Categoris $selectedUserCategoriesList");
    final categoryFilters = selectedUserCategoriesList
        .map((id) => 'filters[interested_categories][\$eq]=$id')
        .join('&');
    print("here are the list $categoryFilters");
    getUsersWagl(userid);
    update();
  }

}
