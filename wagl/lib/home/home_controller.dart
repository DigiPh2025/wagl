import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wagl/discover/discover_controller.dart';
import 'package:wagl/home/all_wagl_model.dart';
import 'package:wagl/home/report/reportModelClass.dart';
import 'package:wagl/profile/profile_controller.dart';
import '../services/remote_services.dart';
import '../util/ApiClient.dart';
import 'comments/comment_model.dart';
import 'home_model.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'home_page.dart';
import 'home_wagl_data_callback.dart';
import 'home_wagl_model.dart';

var storyViewIndex = 0;

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  VideoPlayerController? videoPlayerController;
  List<VideoPlayerController>? videoPlayerControllers = [];
  bool isVideoLoading = true;
  late PageController pageViewController;
  int selectedHomeIndex = 0;
  var currentIndex = 0.obs;
  var initialChildSize = 0.6;
  String reasonText = "Please select";
  int reasonId = 0;
  var keyBroadSize = 0.0;
  String additionalDetailsText = "Please provide any additional information";
  var inChildSize = 0.3;
  bool isDiscard = false;
  var maxChildSize = 0.9;
  bool liked = false;
  bool isSelected = false;
  bool likedResponse = false;
  List<XFile> selectedMedia = [];
  List<String> changedImages = [];
  List<String> changedImagesAll = [];
  XFile? videoThumbnail;
  List<String> changedVideosPaths = [];
  List<String> changedVideos = [];

  String? currentSelectedMedia;
  List<int>? likedWaglArray = [];
  List<int>? savedWaglArray = [];
  List<int>? followersList = [];
  bool isAddressSelected = false;
  bool isFollowing = false;
  bool isProcessing = false;

  var bioTextController = TextEditingController();
  var commentTextController = TextEditingController();
  TextEditingController reportTextController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  Duration videoDuration = Duration.zero; // Holds the video duration
  bool dataReceived = false;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    clearData();
    pageViewController = PageController(initialPage: 0);
    selectedHomeIndex = 0;
    selectedIndex = 0;

    getLikedWagls();
    getSavedWagls();
    getFollowersList();
  }

  @override
  void dispose() {
    // pageViewController!.dispose();
    print("here dispose");
    super.dispose();
  }

  updateStoryIndex(waglIndex) {
    pageViewController = PageController(initialPage: storyViewIndex);
    update();
  }

  int currentIndexStoryView = 0;

  storyViewShowIndex(index) {
    currentIndexStoryView = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentIndexStoryView = index;
      print("here is the value currentIndexStoryView $currentIndexStoryView ");
      homeController.update();
      update(); // Notify listeners after the frame is rendered
    });
  }

  final List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  int selectedIndex = 0;
  final PageController pageController = PageController();

  void onBottomOptionTapped(int index) {
    if (selectedIndex == index) {
      print("here is the Condition selectedIndex index== $index");
      // If the tab is already selected, pop to the first route of that navigator
      navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      print("here is the Condition else index== $index");
      selectedIndex = index;
      pageController.jumpToPage(index);
      update();
    }
    update();
  }

  Future<void> handlePageViewChanged(
      int currentIndex, bool isDiscover, bool isSaved, index) async {
    storyViewIndex = currentIndex;
    // currentPageIndex = 2;
    print("here is the $currentIndex here is the call api");
    updateStoryIndex(currentIndex);
    {
      if (isDiscover) {
        var discoverController = Get.put(DiscoverController());
        if (discoverController.categoryWaglItems[index].userId !=
            ApiClient.box.read("userId")) {
          print(
              "here is the Discover ;:: like userId ${discoverController.categoryWaglItems[index].userId}   self id:: ${ApiClient.box.read("userId")}");
          discoverController.categoryWaglItems[index].views! + 1;
          print("\n\n Response object");
          var request = http.Request(
              'POST', Uri.parse('${RemoteServices.baseUrl}api/viewCount'));
          print("\n\n  ${RemoteServices.baseUrl}api/viewCount");

          var headers = {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${ApiClient.box.read("authToken")}'
          };

          request.body = json.encode({
            "data": {
              "wagl_id": discoverController.categoryWaglItems[index].waglId
            }
          });

          request.headers.addAll(headers);
          http.StreamedResponse response = await request.send();

          var decode = jsonDecode(request.body);

          if (response.statusCode == 200) {
            print(await response.stream.bytesToString());
          } else {}

          update();
        }
      } else if (isSaved) {
        var profileController = Get.put(ProfileController());
        if (profileController.savedStoryItems[index].userId !=
            ApiClient.box.read("userId")) {
          print(
              "here is the Discover ;:: like userId ${profileController.savedStoryItems[index].userId}   self id:: ${ApiClient.box.read("userId")}");

          print("here is the Discover ;:: like incerament ");
          profileController.savedStoryItems[index].views! + 1;
          print("\n\n Response object");
          var request = http.Request(
              'POST', Uri.parse('${RemoteServices.baseUrl}api/viewCount'));
          print("\n\n  ${RemoteServices.baseUrl}api/viewCount");

          var headers = {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${ApiClient.box.read("authToken")}'
          };

          request.body = json.encode({
            "data": {"wagl_id": profileController.savedStoryItems[index].waglId}
          });

          request.headers.addAll(headers);
          http.StreamedResponse response = await request.send();

          var decode = jsonDecode(request.body);

          if (response.statusCode == 200) {
            print(await response.stream.bytesToString());
          } else {}
          update();
        }
      } else {
        if (storyItems[currentIndex].userId != ApiClient.box.read("userId")) {
          print(
              "here is the Discover ;:: ${storyItems[currentIndex].userId.toString() != ApiClient.box.read("userId")}like userId ${storyItems[currentIndex].userId}   self id::!!! ${ApiClient.box.read("userId")}");
          storyItems[currentIndex].views = storyItems[currentIndex].views! + 1;
          print("\n\n Response object");
          var request = http.Request(
              'POST', Uri.parse('${RemoteServices.baseUrl}api/viewCount'));
          print("\n\n  ${RemoteServices.baseUrl}api/viewCount");

          var headers = {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${ApiClient.box.read("authToken")}'
          };

          request.body = json.encode({
            "data": {"wagl_id": wagls![currentIndex].id}
          });

          request.headers.addAll(headers);
          http.StreamedResponse response = await request.send();

          var decode = jsonDecode(request.body);

          if (response.statusCode == 200) {
            print(await response.stream.bytesToString());
          } else {}
        }
      }
    }

    // print("here count ${storyItems[currentIndex].views}");
    // updateWaglViews(currentIndex);
    updateStoryIndex(currentIndex);

    update();
  }

  int skipCount = 1;

  Future<void> handleMainPageViewChanged(int currentIndex) async {
    if (currentIndex == homeWaglStoryItems.length - 2) {
      print(
          "here is the api call for add new ${homeWaglStoryItems.length - 1}");
      skipCount++;
      getHomeFeedWaglWithPagination(skipCount);
    }
    if (homeWaglStoryItems.isNotEmpty) {
      storyViewIndex = currentIndex;
      // currentPageIndex = 2;
      for (int i = 0; i < 10; i++) {
        print(i);
        print("here is the $currentIndex here is the call api");
        homeWaglStoryItems[storyViewIndex].controller.previous();
      }
      print(
          "here is the Discover ;:: like userId ${homeWaglStoryItems[currentIndex].userId}  here is the call api   ${(homeWaglStoryItems[currentIndex].userId.toString() == "${ApiClient.box.read("userId")}")}");

      if (homeWaglStoryItems[currentIndex].userId !=
          ApiClient.box.read("userId")) {
        print("did get api call ");
        homeWaglStoryItems[currentIndex].views =
            homeWaglStoryItems[currentIndex].views! + 1;

        var request = http.Request(
            'POST', Uri.parse('${RemoteServices.baseUrl}api/viewCount'));
        print("\n\n  ${RemoteServices.baseUrl}api/viewCount");

        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiClient.box.read("authToken")}'
        };

        request.body = json.encode({
          "data": {"wagl_id": homeWaglStoryItems[currentIndex].waglId}
        });

        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();

        var decode = jsonDecode(request.body);

        if (response.statusCode == 200) {
          print(await response.stream.bytesToString());
        } else {
          print("did Not api call ");
        }
      } else {
        print(
            "Else ${homeWaglStoryItems[currentIndex].userId} Else   ${(homeWaglStoryItems[currentIndex].userId.toString() == "${ApiClient.box.read("userId")}")}");
      }
    }
    updateStoryIndex(currentIndex);
    update();
  }

  Future getHomeFeedWaglWithPagination(skip) async {
    // isWaglLoading = true;
    print("here is the skip  $skipCount");
    var request = http.Request(
        'POST', Uri.parse('${RemoteServices.baseUrl}api/homefeeds'));
    print("\n\n  ${RemoteServices.baseUrl}api/homefeeds");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${ApiClient.box.read("authToken")}'
    };

    request.body = json.encode({
      "data": {
        "skip": skip,
        "limit": 10,
        "unfollowLastpage": metaCount?.pagination?.unfollowLastPage ?? 0,
        "btn": "inc"
      }
    });

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      homeWaglData.clear();
      // homeWaglStoryItems.clear();
      var responseString = await response.stream.bytesToString();
      var decode = jsonDecode(request.body);
      print("here is homeFeedDatahere is homeFeedData $responseString");
      var apiDetails = homeWaglModelClassFromJson(responseString);
      homeWaglData = apiDetails.data!;
      metaCount = apiDetails.meta;
      // storyViewIndex = 0;
      // handleMainPageViewChanged(0);
      print("here is homeFeedData ${homeWaglData.length}");

      for (int i = 0; i < homeWaglData.length; i++) {
        // if(i<50){
        if (homeWaglData[i].userId != null) {
          var userIdData = homeWaglData[i].userId!;
          var profilePicData = userIdData.profilePic;
          if (profilePicData != null &&
              profilePicData.url != null &&
              profilePicData.url!.isNotEmpty &&
              homeWaglData[i].productId != null) {
            String? urlProfilePic = profilePicData.url;
            HomeWaglDataClass homeWagls = await getHomeWagls(homeWaglData[i],
                urlProfilePic, homeWaglData[i].id!, homeWaglData[i].productId);
            homeWaglStoryItems.add(homeWagls);
          } else if (profilePicData != null &&
              profilePicData.url != null &&
              profilePicData.url!.isNotEmpty &&
              homeWaglData[i].productId == null) {
            String? urlProfilePic = profilePicData.url;
            HomeWaglDataClass homeWagls = await getHomeWagls(
                homeWaglData[i], urlProfilePic, homeWaglData[i].id!, null);
            homeWaglStoryItems.add(homeWagls);
          } else {
            HomeWaglDataClass homeWagls = await getHomeWagls(homeWaglData[i],
                null, homeWaglData[i].id!, homeWaglData[i].productId);
            homeWaglStoryItems.add(homeWagls);
          }
        }
        // }
      }
    } else {

      print("here is issue ${response.statusCode}");
    }

    print(
        "here is the homeWaglStoryItems add wagls ${homeWaglStoryItems.length}");
    // isWaglLoading = false;
    update();
  }

  bool isProcessingFollow = false;

  updateFollower(int index, int followerId, bool status, bool isDiscover,
      bool isSaved) async {
    print("\n\n\nhere 1 $followerId");
    print("\n\n\nhere 1 $status \n\n\n");
    if (isProcessing) return;
    isProcessing = true;
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
        if (isDiscover) {
          var discoverController = Get.put(DiscoverController());
          if (status) {
            discoverController.categoryWaglItems[index].isFollows = status;
          }
        } else if (isSaved) {
          var profileController = Get.put(ProfileController());
          if (status) {
            print("here is the Discover ;:: like incerament ");
            profileController.savedStoryItems[index].isFollows = status;
          }
        } else {
          storyItems[index].isFollows = status;
        }
      } else {
        print(
            "Error: Here is followupdate${response.statusCode}, ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error during API call: $e");
    } finally {
      isProcessing = false;
      print("getFollowersListgetFollowersListgetFollowersList $e");
      // await getFollowersListGetApi(followerId);
      await getFollowersList();

      update(); // This will trigger a UI update
    }
  }

  LatLng latlng = LatLng(18.579442, 73.482968);
  double? lat, lng;
  String mapTheme = "";

  updateLatlng(plat, plng) {
    print("position.longitude === 2");
    latlng = LatLng(double.parse(plat), double.parse(plng));
    lat = double.parse(plat);
    lng = double.parse(plng);
    update();
  }

  bool isOwnProfile = true;

  List<ReportMessage> reportMessage = [];
  List<ReportType> reportType = [];

  Future reportDetails() async {
    var getDetails = await RemoteServices.fetchGetData('api/getReportData');
    if (getDetails.statusCode == 200) {
      var apidetails = reportDetailsFromJson(getDetails.body);
      print("here is the reportDetailsFromJson $apidetails");
      reportMessage = apidetails.reportMessage ?? [];
      reportType = apidetails.reportType ?? [];
    } else {
      print("here is the exception");
    }

    update();
  }

  File? mainImage;

  List<File> additionalImages = [];
  final ImagePicker picker = ImagePicker();

  List<HomeWaglData> homeWaglData = [];
  final List<HomeWaglDataClass> homeWaglStoryItems = [];
  bool isWaglLoading = true;

  Future getHomeFeedWagl() async {
    print("here is the homefeed api calll");
    isWaglLoading = true;
    skipCount = 1;
    var request = http.Request(
        'POST', Uri.parse('${RemoteServices.baseUrl}api/homefeeds'));
    print("\n\n  ${RemoteServices.baseUrl}api/homefeeds");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${ApiClient.box.read("authToken")}'
    };

    request.body = json.encode({
      "data": {"skip": 1, "limit": 10, "unfollowLastpage": 0, "btn": "inc"}
    });

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      homeWaglData.clear();
      homeWaglStoryItems.clear();
      var responseString = await response.stream.bytesToString();
      var decode = jsonDecode(request.body);
      print("here is homeFeedDatahere is homeFeedData $responseString");
      var apiDetails = homeWaglModelClassFromJson(responseString);
      homeWaglData = apiDetails.data!;
      metaCount = apiDetails.meta;
      storyViewIndex = 0;
      handleMainPageViewChanged(0);
      print("here is homeFeedData ${homeWaglData.length}");

      for (int i = 0; i < homeWaglData.length; i++) {
        // if(i<50){
        if (homeWaglData[i].userId != null) {
          var userIdData = homeWaglData[i].userId!;
          var profilePicData = userIdData.profilePic;
          if (profilePicData != null &&
              profilePicData.url != null &&
              profilePicData.url!.isNotEmpty &&
              homeWaglData[i].productId != null) {
            String? urlProfilePic = profilePicData.url;
            HomeWaglDataClass homeWagls = await getHomeWagls(homeWaglData[i],
                urlProfilePic, homeWaglData[i].id!, homeWaglData[i].productId);
            homeWaglStoryItems.add(homeWagls);
          } else if (profilePicData != null &&
              profilePicData.url != null &&
              profilePicData.url!.isNotEmpty &&
              homeWaglData[i].productId == null) {
            String? urlProfilePic = profilePicData.url;
            HomeWaglDataClass homeWagls = await getHomeWagls(
                homeWaglData[i], urlProfilePic, homeWaglData[i].id!, null);
            homeWaglStoryItems.add(homeWagls);
          } else {
            HomeWaglDataClass homeWagls = await getHomeWagls(homeWaglData[i],
                null, homeWaglData[i].id!, homeWaglData[i].productId);
            homeWaglStoryItems.add(homeWagls);
          }
        }
        // }
      }
    } else {

      print("here is issue ${response.statusCode}");
    }

    print("here is the homeWaglStoryItems ${homeWaglStoryItems.length}");
    isWaglLoading = false;
    update();
  }

  MetaClass? metaCount;

  Future submitReport(int waglId, bool isUserReport) async {
    Map<String, dynamic> waglData = {};
    if (isUserReport) {
      waglData = {
        "data": {
          "user_id": waglId,
          "reported_by": ApiClient.box.read("userId"),
          "comment": reportTextController.text.toString(),
          "reason_id": {
            "disconnect": [],
            "connect": [
              {"id": reasonId},
            ]
          }
        }
      };
    } else {
      waglData = {
        "data": {
          "wagl_id": waglId,
          "user_id": ApiClient.box.read("userId"),
          "reason": reportTextController.text.toString(),
          "reason_id": {
            "disconnect": [],
            "connect": [
              {"id": reasonId},
            ]
          }
        }
      };
    }

    print("print the map ${waglData}");
    // var getDetails = await RemoteServices.postMethodWithToken('api/report-wagls', waglData);
    var getDetails = await RemoteServices.postMethodWithToken(
        isUserReport ? "api/report-users" : "api/reports", waglData);
    print("here is the wagl Report Brfore ");
    if (getDetails.statusCode == 200) {
      print("here is the wagl Report ${getDetails.statusCode}");
    } else {
      print("here is the wagl Report ${getDetails.statusCode}");
    }
    ;
    update();
  }

  List<DataWagl>? wagls = [];
  final List<PersonStories> storyItems = [];
  VideoPlayerController videoController = VideoPlayerController.network("url");

  getHomeWagls(HomeWaglData attributes, url, int wagls, productId) {
    final attributesUser = attributes.userId!;
    final List<String> mediaUrls =
        attributes.media!.map((mediaItem) => mediaItem.url!).toList();
    final List<String> mediaExt =
        attributes.media!.map((mediaItem) => mediaItem.ext!).toList();
    final sortedMedia = List.from(attributes.media!)
      ..sort((media1, media2) {
        final number1 = int.tryParse(media1.name.split('_')[0]) ?? 0;
        final number2 = int.tryParse(media2.name.split('_')[0]) ?? 0;
        return number1.compareTo(number2); // Sort based on extracted number
      });
    final List<String> mediaName =
        attributes.media!.map((mediaItem) => mediaItem.name!).toList();
    final List<int> mediaIds =
        attributes.media!.map((mediaItem) => mediaItem.id!).toList();
    sortedUrl.clear();
    sortedUrl = mediaUrls;
    List<String> sortedUrls = [];
    sortedUrls.clear();
    print("here is the lengthhere ::${mediaName.length}");
    sortMedia1(mediaName);
    print("sortMedia aa :: $list");
    for (int i = 0; i < mediaName.length; i++) {
      //  final sp = int.tryParse(mediaNames[i].split('_')[0]) ?? 0;
      sortedUrls.add(sortMedia(mediaName, list[i]));
      // print("here is the sort media file ${mediaNames[i]}");
    }
    return HomeWaglDataClass(
      username: "${attributesUser.username}",
      profileImage: url,
      description: "${attributes.description}",
      location: "${attributes.location}",
      likes: attributes.totalLikes ?? 0,
      totalComments: attributes.totalComments ?? 0,
      views: attributes.totalViews ?? 0,
      userId: attributes.userId!.id,
      productId: productId,
      waglId: wagls,
      mediaUrls: sortedUrls,
      mediaName: mediaName,
      mediaId: mediaIds,
      mediaExt: mediaExt,
      totalSaved: attributes.totalSaved ?? 0,
      sortedMedia: sortedMedia,
      // categoryData:attributesCategories,
      liked: attributes.isLike,
      saved: attributes.isSaved,

      categoryData: attributes.interestedCategories!,
      goodTagData: attributes.goodTags!,

      controller: StoryController(),
      // stories: [...List.generate(2, (index) => attributes.media.data[index].attributesMedia.url)],
      stories: [
        ...List.generate(
          sortedMedia.length,
          (index) {
            final media = sortedMedia[index];
            return media.ext == ".mp4" ||
                    media.ext == ".mov" ||
                    media.ext == ".hevc"
                ? StoryItem.pageVideo(
                    "${media.url}",

                    controller: StoryController(),
                    // videoController: videoController,

                    duration: const Duration(seconds: 40),
                  )
                : StoryItem.pageImage(
                    url: "${media.url}",
                    duration: const Duration(seconds: 40),
                    controller: StoryController(),
                  );
          },
        ),
      ],

      isFollows: attributes.isFollow,
    );
  }

  var list = [];
  var listName = [];

  sortMedia1(lengthMedia) {
    list = [];
    for (int i = 0; i < lengthMedia.length; i++) {
      final number1 = int.tryParse(lengthMedia[i].split('_')[0]) ?? 0;

      list.add(number1);
      print("sortMedia 1 :: $list");
      list.sort();
      print("sortMedia 2 :: $list");
    }
    list.sort();
    update();
  }

  sortMedia(
    lengthMedia,
    index,
  ) {
    //  int indexA = int.parse(a.split('_')[0]);
    //  int indexB = int.parse(b.split('_')[0]);
    //  indexA.compareTo(indexB);

    var a;
    for (int i = 0; i < lengthMedia.length; i++) {
      final number1 = int.tryParse(lengthMedia[i].split('_')[0]) ?? 0;
      print("no;;; $number1 ::index $index ");
      if (index == number1) {
        a = sortedUrl[i];
        print("here is sored index ${a}  a");
        break;
      }
    }
    print("here is and the generateVideoThumbnail link ${lengthMedia}");
    print("here is  and the name of the file ${index}");
    return a;
  }

  sortMediaName(
    lengthMedia,
    index,
  ) {
    var a;
    for (int i = 0; i < lengthMedia.length; i++) {
      final number1 = int.tryParse(lengthMedia[i].split('_')[0]) ?? 0;
      print("no;;; $number1 ::index $index ");

      if (index == number1) {
        print("lengthMedia +++++ :::  ${lengthMedia[i]}");
        a = lengthMedia[i];
        break;
      }
    }
    return a;
  }

  Future deleteWagl(waglId, isDiscover, isSaved) async {
    var getDetails = await RemoteServices.deleteData('api/wagls/$waglId');

    var profileController = Get.put(ProfileController());
    profileController.getUsersWagl(0);
    profileController.update();
    update();
  }

  List<String> sortedUrl = [];
  List<String> sortedMediaName = [];
  var iDsList = [];
  List<TagData> goodTags = [];
  bool isLoading = true;
  int notificationIndex = 0;
  List<Data> commentData = [];

  getPersonStories(WaglAttributes attributes, url, int wagls, productId) {
    iDsList = [];
    final attributesUser = attributes.userId!.data!.attributes!;
    final List<String> mediaUrls = attributes.media!.data!
        .map((mediaItem) => mediaItem.attributesMedia!.url!)
        .toList();
    sortedUrl.clear();
    sortedMediaName.clear();
    sortedUrl = mediaUrls;
    final List<String> mediaNames = attributes.media!.data!
        .map((mediaItem) => mediaItem.attributesMedia!.name!)
        .toList();

    final List<int> mediaIds =
        attributes.media!.data!.map((mediaItem) => mediaItem.id!).toList();
    final List<String> mediaext = attributes.media!.data!
        .map((mediaItem) => mediaItem.attributesMedia?.ext ?? "")
        .toList();
    final sortedMedia = List.from(attributes.media!.data!)
      ..sort((media1, media2) {
        final number1 =
            int.tryParse(media1.attributesMedia!.name!.split('_')[0]) ?? 0;
        final number2 =
            int.tryParse(media2.attributesMedia!.name!.split('_')[0]) ?? 0;
        return number1.compareTo(number2); // Ascending order
      });

    iDsList = sortedMedia;

    print("iDsList : >>> : ${iDsList.length}");

    List<String> sortedIds = [];
    sortedIds.clear();
    List<String> sortedUrls = [];
    sortedUrls.clear();
    print("here is the lengthhere ::${mediaNames.length}");
    sortMedia1(mediaNames);
    print("sortMedia aa :: $list");
    for (int i = 0; i < mediaNames.length; i++) {
      sortedUrls.add(sortMedia(mediaNames, list[i]));
    }
    print("here is the lengthhere ::${sortedUrl.length}");
    return PersonStories(
      username: "${attributesUser.username}",
      profileImage: url,
      description: "${attributes.description}",
      location: "${attributes.location}",
      likes: attributes.totalLikes ?? 0,
      totalComments: attributes.totalComments ?? 0,
      views: attributes.totalViews ?? 0,
      userId: attributes.userId!.data!.id,
      sortedMedia: sortedMedia,
      waglId: wagls,
      productId: productId,
      totalSaved: attributes.totalSaved ?? 0,
      // categoryData:attributesCategories,
      liked: true,
      mediaExt: mediaext,
      saved: false,
      media: sortedUrls,
      mediaName: mediaNames,
      //sortedMediaName,
      categoryData: attributes.interestedCategories!.data!,
      goodTagData: attributes.goodTags!.data!,
      controller: StoryController(),
      stories: [
        ...List.generate(
          sortedMedia.length,
          (index) {
            final media = sortedMedia[index];
            return media.attributesMedia!.ext == ".mp4" ||
                    media.attributesMedia!.ext == ".mov" ||
                    media.attributesMedia!.ext == ".hevc"
                ? StoryItem.pageVideo(
                    // videoController: videoController,
                    "${media.attributesMedia!.url}",
                    controller: StoryController(),
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
      mediaId: mediaIds,
    );
  }

  Future getAllWagls(id, selectedCategories) async {
    int notificationIndex = 0;
    isLoading = true;
    print("id===getAllWagls $id");
    var getDetails;

    final categoryFilters = selectedCategories
        .map((id) => 'filters[interested_categories][\$eq]=$id')
        .join('&');

    if (id == 0) {
      print("here is the id 3 $getDetails ");
      getDetails = null;
      print("here is the id 1 $id ");

      getDetails = await RemoteServices.fetchGetData(
          'api/wagls?populate[media]=*&sort=createdAt:desc&populate[interested_categories]=*&filters[isActive][\$eq]=true&populate[user_id][populate]=*&populate[good_tags][populate]=*&pagination[page]=1&pagination[pageSize]=100&populate[product_id][populate]=*&$categoryFilters');
    } else if (id == 1) {
      print("here is the id 3 $getDetails ");
      getDetails = null;
      print("here is the id 2 $id ");
      getDetails = await RemoteServices.fetchGetData(
          'api/wagls?populate[media]=*&sort=createdAt:desc&populate[interested_categories]=*&filters[user_id][\$eq]=${ApiClient.box.read("userId")}&filters[isActive][\$eq]=true&populate[user_id][populate]=*&populate[good_tags][populate]=*&pagination[page]=1&pagination[pageSize]=100&populate[product_id][populate]=*&$categoryFilters');
    } else if (id != 1) {
      print("here is the data $selectedCategories");
      getDetails = null;
      print("here is the id 3 $id ");
      print("here is the id 3 $getDetails ");
      getDetails = await RemoteServices.fetchGetData(
          'api/wagls?populate[media]=*&sort=createdAt:desc&populate[interested_categories]=*&filters[user_id][\$eq]=$id&filters[isActive][\$eq]=true&populate[user_id][populate]=*&populate[good_tags][populate]=*&pagination[page]=1&pagination[pageSize]=100&populate[product_id][populate]=*&$categoryFilters');
    } else if (id == "categories") {
      getDetails = null;
      print("here is the id 4 $id ");
      getDetails = await RemoteServices.fetchGetData(
          'api/wagls?populate[media]=*&sort=createdAt:desc&populate[interested_categories]=*&filters[isActive][\$eq]=true&populate[user_id][populate]=*&populate[good_tags][populate]=*&pagination[page]=1&pagination[pageSize]=100&populate[product_id][populate]=*&$categoryFilters');
    }
    if (getDetails.statusCode == 200) {
      // print("\n\n Here is${getDetails.body}\n\n");
      print("here is the id 5$id ");
      print("\n\n Here is${getDetails.body}\n\n");

      var apiDetails = viewAllWaglModelFromJson(getDetails.body);
      isLoading = false;
      wagls!.clear();
      storyItems.clear();
      print("here is the value $wagls");
      wagls = apiDetails.data;

      // print("\n\n Here is the profile images link ${wagls![1].attributes!.userId!.data!.attributes!.profilePicData!.data!.attributes!.url}\n\n");
      if (wagls!.isNotEmpty) {
        for (int i = 0; i < wagls!.length; i++) {
          var userIdData = wagls![i].attributes!.userId!.data;
          var profilePicData = userIdData!.attributes!.profilePicData;

          if (wagls![i].attributes!.productId!.data != null) {
            print(
                "here is the product ${wagls![i].attributes!.productId!.data!.attributes!.name}");

            if (profilePicData != null &&
                profilePicData.data != null &&
                profilePicData.data!.attributes!.url != null &&
                profilePicData.data!.attributes!.url!.isNotEmpty) {
              String? urlProfilePic = profilePicData.data!.attributes!.url;
              PersonStories personItem = getPersonStories(
                  wagls![i].attributes!,
                  urlProfilePic,
                  wagls![i].id!,
                  wagls![i].attributes!.productId!);
              storyItems.add(personItem);
            } else {
              PersonStories personItem = getPersonStories(wagls![i].attributes!,
                  null, wagls![i].id!, wagls![i].attributes!.productId!);
              storyItems.add(personItem);
            }
          } else {
            print("here is the empty Product ");
            if (profilePicData != null &&
                profilePicData.data != null &&
                profilePicData.data!.attributes!.url != null &&
                profilePicData.data!.attributes!.url!.isNotEmpty) {
              String? urlProfilePic = profilePicData.data!.attributes!.url;
              PersonStories personItem = getPersonStories(
                  wagls![i].attributes!, urlProfilePic, wagls![i].id!, null);
              storyItems.add(personItem);
            } else {
              PersonStories personItem = getPersonStories(
                  wagls![i].attributes!, null, wagls![i].id!, null);
              storyItems.add(personItem);
            }
          }
        }
      }
    } else {
      print("Failed to fetch data. Status code: Home ${getDetails.statusCode}");
    }
    dataReceived = true;
    update();
  }

  Future getLikedWagls() async {
    var getDetails = await RemoteServices.fetchGetData('api/getLikeWagls');
    if (getDetails.statusCode == 200) {
      print("\n\n Here is${getDetails.body}\n\n");
      var apiDetails = viewCountModelFromJson(getDetails.body);
      likedWaglArray = apiDetails.result;
      if (likedWaglArray!.isNotEmpty) {
        print("here is the likedWaglArray \n\n ${likedWaglArray}");
        // profileDetails=apiDetails;
      } else {
        print("Empty getLikeWagls");
      }
    } else {
      print("Failed to fetch data. Status code:Home${getDetails.statusCode}");
    }
    update();
  }

  Future getSavedWagls() async {
    var getDetails = await RemoteServices.fetchGetData('api/getSavedWagls');
    if (getDetails.statusCode == 200) {
      print("\n\n Here is${getDetails.body}\n\n");
      var apiDetails = viewCountModelFromJson(getDetails.body);
      savedWaglArray = apiDetails.result;
      if (savedWaglArray!.isNotEmpty) {
        print("\n\nhere is the cur::${savedWaglArray!}");
        // profileDetails=apiDetails;
      } else {
        print("Empty getLikeWagls");
      }
    } else {
      print("here is the apiLink ${RemoteServices.baseUrl}api/getSavedWagls");
      print("Failed to fetch data. Status code:Home 3${getDetails.statusCode}");
    }
    update();
  }

  Future getCommentWagls(waglId) async {
    print("here is the ID::${waglId}");
    var getDetails = await RemoteServices.fetchGetData(
        'api/comments?filters[wagl_id][\$eq]=$waglId&populate[user_id][populate]=*&sort=createdAt:desc');
    if (getDetails.statusCode == 200) {
      commentData.clear();
      print("\n\n Here is Comment ${getDetails.body}\n\n");
      var apiDetails = viewCommentFromJsonModel(getDetails.body);
      commentData = apiDetails.data!;
      if (commentData!.isNotEmpty) {
        // profileDetails=apiDetails;
        print("Empty getLikeWagls${commentData.length}");
      } else {
        print("Empty getLikeWagls");
      }
    } else {
      print(
          "Failed to fetch data. Status code: Home 4${getDetails.statusCode}");
    }
    update();
  }

  Future getHomeCommentWagls(index) async {
    print("here is the ID${homeWaglData![index].id}");
    var getDetails = await RemoteServices.fetchGetData(
        'api/comments?filters[wagl_id][\$eq]=${homeWaglData![index].id}&populate[user_id][populate]=*');
    if (getDetails.statusCode == 200) {
      print("\n\n Here is Comment ${getDetails.body}\n\n");
      var apiDetails = viewCommentFromJsonModel(getDetails.body);
      commentData = apiDetails.data!;
      if (commentData!.isNotEmpty) {
        // profileDetails=apiDetails;
        print("Empty getLikeWagls${commentData[0].attributes!.userId!.data}");
      } else {
        print("Empty getLikeWagls");
      }
    } else {
      print(
          "Failed to fetch data. Status code: Home 4${getDetails.statusCode}");
    }
    update();
  }

  Future getFollowersList() async {
    var getDetails = await RemoteServices.fetchGetData('api/getFollowersList');
    if (getDetails.statusCode == 200) {
      var apiDetails = viewCountModelFromJson(getDetails.body);
      followersList = apiDetails.result;
      print("\n\n here is the followersList::${followersList}");
      if (followersList!.isNotEmpty) {
        // profileDetails=apiDetails;
      } else {}
    } else {
      print(
          "Failed to fetch data. Status code: 5 Home${getDetails.statusCode}");
    }

    update();
  }

  Future pickImages() async {
    changedImages.clear();
    changedImagesAll.clear();
    changedVideos.clear();
    videoPlayerControllers!.clear();
    List<XFile> renamedFiles = [];
    List videothumnail = [];
    final List<XFile>? pickedImages = await picker.pickMultipleMedia();
    if (pickedImages != null && pickedImages.isNotEmpty) {
      videothumnail.clear();

      for (var file in pickedImages) {
        print("File after renaming: ${file.path}");
      }

      List<XFile> changedFiles = [];
      for (var pickedFile in pickedImages) {
        if (pickedFile.path.endsWith('.mp4') ||
            pickedFile.path.endsWith('.mov') ||
            pickedFile.path.endsWith('.hevc')) {
          changedFiles.add(pickedFile);
        } else {
          final fixedFile = await _fixImageOrientation(pickedFile.path);
          if (fixedFile != null) {
            changedFiles.add(fixedFile);
          }
        }
      }
      selectedMedia = changedFiles;
      currentSelectedMedia = selectedMedia.first.path;
      for (int i = 0; i < changedFiles.length; i++) {
        changedImages.add(changedFiles[i].path);
        changedImagesAll.add(changedFiles[i].path);
        /* if(changedFiles[i].path.endsWith(".mp4")||changedFiles[i].path.endsWith(".mov")){
          changedImagesAll.add(generateVideoThumbnail(changedFiles[i].path).toString());
        }*/
        videoPlayerControllers!
            .add(VideoPlayerController.file(File(changedFiles[i].path)));
      }
      // homeController.homeWaglStoryItems[storyViewIndex].controller.pause();
    }

    update();

    if (pickedImages != null && pickedImages.isNotEmpty) {
      return true;
    } else {
      return false;
    }
    update();
  }

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  pauseWagl() {
    if (homeWaglStoryItems.isNotEmpty) {
      print("Pause called 11 ");
      homeWaglStoryItems[storyViewIndex].controller.pause();
      print("Pause called ${()}");
      update();
    }
  }

  String timeAgo(String timestamp) {
    try {
      // Parse the provided ISO8601 timestamp
      DateTime dateTime = DateTime.parse(timestamp);
      DateTime now = DateTime.now().toUtc();

      // Calculate the difference
      Duration difference = now.difference(dateTime);

      // Convert to human-readable format
      if (difference.inSeconds < 60) {
        return "Just now";
      } else if (difference.inMinutes < 60) {
        return "${difference.inMinutes}m";
      } else if (difference.inHours < 24) {
        return "${difference.inHours}h";
      } else {
        return "${difference.inDays}d";
      }
    } catch (e) {
      return "Invalid timestamp";
    }
  }

  List<Uint8List?> _thumbnails = [];

  Future<bool> checkPermission() async {
    ///For Check permission..
    if (Platform.isAndroid
        ? !await requestPermission(Permission.storage) &&
            !await requestPermission(Permission.manageExternalStorage)
        : !await requestPermission(Permission.storage)) {
      await Get.dialog(CupertinoAlertDialog(
        title: const Text("Photos & Videos permission"),
        content: const Text(
            " Photos & Videos permission should be granted to connect with device, would you like to go to app settings permissions?"),
        actions: <Widget>[
          TextButton(
              child: const Text('No thanks'),
              onPressed: () {
                Get.back();
              }),
          TextButton(
              child: const Text('Ok'),
              onPressed: () async {
                Get.back();
                await openAppSettings();
              })
        ],
      ));
      return false;
    } else {
      return true;
    }
  }

  Future<XFile?> _fixImageOrientation(String imagePath) async {
    // Load the image file
    final imageFile = File(imagePath);
    final imageBytes = await imageFile.readAsBytes();

    // Decode the image
    img.Image? originalImage = img.decodeImage(imageBytes);

    if (originalImage != null) {
      // Check the orientation and rotate if necessary
      if (originalImage.width > originalImage.height) {
        // Rotate 90 degrees clockwise
        // originalImage = img.copyRotate(originalImage,angle:  90);
        originalImage = originalImage;
      }

      // Convert back to bytes
      final fixedImageBytes = img.encodeJpg(originalImage);

      // Save the fixed image as a new temporary file
      final fixedImageFile = await imageFile.writeAsBytes(fixedImageBytes);

      // Return an XFile from the saved file
      return XFile(fixedImageFile.path);
    }
    return XFile(imagePath);
  }

  final permissionStorage = Permission.storage;

  Future<void> requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      print("\n\n\n storage permission granted");
      // Either the permission was already granted before or the user just granted it.
    }

    if (await Permission.location.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      print("\n\n\n storage Permission.storage.request().isGranted");
    }
    if (await Permission.storage.request().isDenied) {
      print("\n\n\n storage permission Permission.storage.request().isDenied ");
      // Either the permission was already granted before or the user just granted it.
    }
    if (await Permission.location.request().isDenied) {
      print("\n\n\n storage permission Permission.location.request().isDenied");
      // Either the permission was already granted before or the user just granted it.
    }

// You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.accessMediaLocation,
    ].request();
    print(statuses[Permission.location]);
    print(statuses[Permission.storage]);
    update();
  }

  void selectImage(index) {
    // selectedImage = image;
    // selectedVideo=selectedMedia[index];
    currentSelectedMedia = changedImages[index];
    print("update image index with image :: ${currentSelectedMedia!}");
    update();
  }

  var commentTextFieldController = TextEditingController();

  Future likeWagl(
      isLike, waglId, index, status, isDiscover, bool isSaved) async {
    if (isLike) {
      print(" ${likedWaglArray}");
      for (int i = 0; i < likedWaglArray!.length; i++) {
        if (likedWaglArray![i] == waglId) {
          likedWaglArray!.removeAt(i);
        }
      }
    } else {
      likedWaglArray!.add(waglId);
    }
    try {
      if (isProcessing) return;
      // Set isProcessing to true and update the UI
      isProcessing = true;
      update();

      print("\n\n token::: ${ApiClient.box.read("authToken")}");
      print("\n\n userId::: ${ApiClient.box.read("userId")}");
      print("\n\n status::: $status");

      var request;
      if (isDiscover) {
        var discoverController = Get.put(DiscoverController());
        if (status) {
          print("here is the Discover ;:: like incerament ");

          discoverController.categoryWaglItems[index].liked = status;
          discoverController.categoryWaglItems[index].likes =
              discoverController.categoryWaglItems[index].likes + 1;
          request = http.Request(
              'POST', Uri.parse('${RemoteServices.baseUrl}api/likes'));
          print("\n\n ${RemoteServices.baseUrl}api/likes");
        } else {
          print("here is the likeDiscover ;:: like decreament decreament ");
          discoverController.categoryWaglItems[index].liked = status;
          discoverController.categoryWaglItems[index].likes =
              discoverController.categoryWaglItems[index].likes - 1;
          request = http.Request(
              'POST', Uri.parse('${RemoteServices.baseUrl}api/unLike'));
          print("\n\n  ${RemoteServices.baseUrl}api/unLike");
        }
      } else if (isSaved) {
        var profileController = Get.put(ProfileController());
        if (status) {
          print("here is the Discover ;:: like incerament ");

          profileController.savedStoryItems[index].liked = status;
          profileController.savedStoryItems[index].likes =
              profileController.savedStoryItems[index].likes + 1;
          request = http.Request(
              'POST', Uri.parse('${RemoteServices.baseUrl}api/likes'));
          print("\n\n ${RemoteServices.baseUrl}api/likes");
        } else {
          print("here is the likeDiscover ;:: like decreament decreament ");
          profileController.savedStoryItems[index].liked = status;
          profileController.savedStoryItems[index].likes =
              profileController.savedStoryItems[index].likes - 1;
          request = http.Request(
              'POST', Uri.parse('${RemoteServices.baseUrl}api/unLike'));
          print("\n\n  ${RemoteServices.baseUrl}api/unLike");
        }
      } else {
        if (status) {
          print("here is the like incerament ");
          storyItems[index].liked = status;
          storyItems[index].likes = storyItems[index].likes + 1;
          request = http.Request(
              'POST', Uri.parse('${RemoteServices.baseUrl}api/likes'));
          print("\n\n ${RemoteServices.baseUrl}api/likes");
        } else {
          print("here is the like decreament ");
          storyItems[index].liked = status;
          storyItems[index].likes = storyItems[index].likes - 1;
          request = http.Request(
              'POST', Uri.parse('${RemoteServices.baseUrl}api/unLike'));
          print("\n\n  ${RemoteServices.baseUrl}api/unLike");
        }
      }
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiClient.box.read("authToken")}'
      };
      // print()
      request.body = json.encode({
        "data": {
          "wagl_id": waglId.toString(),
          "user_id": "${ApiClient.box.read("userId")}"
        }
      });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      var decode = jsonDecode(request.body);
      print("decode :: ${jsonEncode(decode)}");

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());

        print("object${response.stream}\n\n");
        print("\n\n Response object${response.statusCode}\n\n");
        print("\n\n Response object${response.reasonPhrase}\n\n");
      } else {
        print("\n\n\n Here Comment ");
        print(response.statusCode);
        print(response.reasonPhrase);
      }
    } catch (e) {
      print("Exception $e");
    } finally {
      isProcessing = false;
      await getLikedWagls();
      update();
    }
    HapticFeedback.heavyImpact();
  }

  Future updateFollowerHome(index, status, followerId) async {
    homeWaglStoryItems[index].isFollows = status;
    update();
    Map map = {
      "data": {
        "userID": ApiClient.box.read("userId"),
        "followersID": followerId
      }
    };

    /*   var requestUrl = Uri.parse(
        '${RemoteServices.baseUrl}api/${status
            ? "follower-lists"
            : "unfollow"}');*/
    var getDetails = await RemoteServices.postMethodWithToken(
        'api/${status ? "follower-lists" : "unfollow"}', map);
    print("here is the data$getDetails");
    print("here is the getDetails :: ${getDetails.data}");
    homeWaglStoryItems[index].isFollows = status;
    update();
  }

  Future likeWaglHomePage(waglId, index, status) async {
    try {
      print("\n\n token::: ${ApiClient.box.read("authToken")}");
      print("\n\n userId::: ${ApiClient.box.read("userId")}");
      print("\n\n status::: $status");

      var request;
      if (status) {
        homeWaglStoryItems[index].liked = status;
        homeWaglStoryItems[index].likes = homeWaglStoryItems[index].likes + 1;
        request = http.Request(
            'POST', Uri.parse('${RemoteServices.baseUrl}api/likes'));
        print("\n\n ${RemoteServices.baseUrl}api/likes");
      } else {
        homeWaglStoryItems[index].liked = status;
        homeWaglStoryItems[index].likes = homeWaglStoryItems[index].likes - 1;
        request = http.Request(
            'POST', Uri.parse('${RemoteServices.baseUrl}api/unLike'));
        print("\n\n  ${RemoteServices.baseUrl}api/unLike");
      }
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiClient.box.read("authToken")}'
      };
      // print()
      request.body = json.encode({
        "data": {
          "wagl_id": waglId.toString(),
          "user_id": "${ApiClient.box.read("userId")}"
        }
      });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      var decode = jsonDecode(request.body);
      print("decode :: ${jsonEncode(decode)}");

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());

        print("object${response.stream}\n\n");
        print("\n\n Response object${response.statusCode}\n\n");
        print("\n\n Response object${response.reasonPhrase}\n\n");
      } else {
        print("\n\n\n Here Comment ");
        print(response.statusCode);
        print(response.reasonPhrase);
      }
    } catch (e) {
      print("Exception $e");
    } finally {}
    print("Exception HapticFeedback.selectionClick() ");
    HapticFeedback.heavyImpact();
    update();
  }

  Future saveWagl(
      isSave, waglId, index, status, bool isDiscover, bool isSaved) async {
    var request;
    if (isSave) {
      // print("isLike $isSave \n likedWaglArray length ${likedWaglArray!.length}  total wagls${wagls!.length}  id;; $waglId");
      // print(" ${likedWaglArray}");
      for (int i = 0; i < savedWaglArray!.length; i++) {
        if (savedWaglArray![i] == waglId) {
          savedWaglArray!.removeAt(i);
        }
      }
    } else {
      savedWaglArray!.add(waglId);
    }

    try {
      if (isProcessing) return;

      // Set isProcessing to true and update the UI
      isProcessing = true;
      update();
      print("\n\n token::: ${ApiClient.box.read("authToken")}");
      print("\n\n userId::: ${ApiClient.box.read("userId")}");
      print("\n\n status::: $status");
      if (isSaved) {
        var profileController = Get.put(ProfileController());

        if (status) {
          profileController.savedStoryItems[index].saved = status;
          HapticFeedback.heavyImpact();
          profileController.savedStoryItems[index].totalSaved =
              profileController.savedStoryItems[index].totalSaved! + 1;
          request = http.Request(
              'POST', Uri.parse('${RemoteServices.baseUrl}api/saved-wagls'));
          print("\n\n ${RemoteServices.baseUrl}api/saved-wagls");
        } else {
          print("here is the likeDiscover ;:: like decreament decreament ");
          profileController.savedStoryItems[index].saved = status;
          HapticFeedback.heavyImpact();
          profileController.savedStoryItems[index].totalSaved =
              profileController.savedStoryItems[index].totalSaved! - 1;
          request = http.Request(
              'POST', Uri.parse('${RemoteServices.baseUrl}api/removedSaved'));
          print("\n\n  ${RemoteServices.baseUrl}api/unLike");
        }
      } else if (isDiscover) {
        var discoverController = Get.put(DiscoverController());
        if (status) {
          discoverController.categoryWaglItems[index].saved = status;
          HapticFeedback.heavyImpact();
          discoverController.categoryWaglItems[index].totalSaved =
              discoverController.categoryWaglItems[index].totalSaved! + 1;
          request = http.Request(
              'POST', Uri.parse('${RemoteServices.baseUrl}api/saved-wagls'));
          print("\n\n ${RemoteServices.baseUrl}api/saved-wagls");
        } else {
          discoverController.categoryWaglItems[index].saved = status;
          HapticFeedback.heavyImpact();
          discoverController.categoryWaglItems[index].totalSaved =
              discoverController.categoryWaglItems[index].totalSaved! - 1;
          request = http.Request(
              'POST', Uri.parse('${RemoteServices.baseUrl}api/removedSaved'));
          print("\n\n  ${RemoteServices.baseUrl}api/removedSaved");
        }
      } else {
        if (status) {
          storyItems[index].saved = status;
          HapticFeedback.heavyImpact();
          storyItems[index].totalSaved = storyItems[index].totalSaved! + 1;
          request = http.Request(
              'POST', Uri.parse('${RemoteServices.baseUrl}api/saved-wagls'));
          print("\n\n ${RemoteServices.baseUrl}api/saved-wagls");
        } else {
          storyItems[index].saved = status;
          HapticFeedback.heavyImpact();
          storyItems[index].totalSaved = storyItems[index].totalSaved! - 1;
          request = http.Request(
              'POST', Uri.parse('${RemoteServices.baseUrl}api/removedSaved'));
          print("\n\n  ${RemoteServices.baseUrl}api/removedSaved");
        }
      }

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiClient.box.read("authToken")}'
      };
      // print()
      request.body = json.encode({
        "data": {
          "wagl_id": waglId.toString(),
          "user_id": "${ApiClient.box.read("userId")}"
        }
      });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      var decode = jsonDecode(request.body);
      print("decodehere :: ${jsonEncode(decode)}");

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        getSavedWagls();
        print("object${response.stream}\n\n");
        print("\n\n Response object${response.statusCode}\n\n");
        print("\n\n Response object${response.reasonPhrase}\n\n");
      } else {
        print("\n\n\n Here Comment ");
        print(response.statusCode);
        print(response.reasonPhrase);
      }
    } catch (e) {
      print("Exception $e");
    } finally {
      isProcessing = false;
    }

    var profileController = Get.put(ProfileController());
    var result = await profileController.getSavedPost();
    profileController.update();

    update();
  }

  Future saveHomeWagl(waglId, index, status) async {
    try {
      update();
      print("\n\n token::: ${ApiClient.box.read("authToken")}");
      print("\n\n userId::: ${ApiClient.box.read("userId")}");
      print("\n\n status::: $status");

      var request;
      if (status) {
        homeWaglStoryItems[index].saved = status;
        HapticFeedback.heavyImpact();
        homeWaglStoryItems[index].totalSaved =
            homeWaglStoryItems[index].totalSaved! + 1;
        request = http.Request(
            'POST', Uri.parse('${RemoteServices.baseUrl}api/saved-wagls'));
        print("\n\n ${RemoteServices.baseUrl}api/saved-wagls");
      } else {
        homeWaglStoryItems[index].saved = status;
        HapticFeedback.heavyImpact();
        homeWaglStoryItems[index].totalSaved =
            homeWaglStoryItems[index].totalSaved! - 1;
        request = http.Request(
            'POST', Uri.parse('${RemoteServices.baseUrl}api/removedSaved'));
        print("\n\n  ${RemoteServices.baseUrl}api/removedSaved");
      }
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiClient.box.read("authToken")}'
      };
      // print()
      request.body = json.encode({
        "data": {
          "wagl_id": waglId.toString(),
          "user_id": "${ApiClient.box.read("userId")}"
        }
      });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      var decode = jsonDecode(request.body);
      print("decode :: ${jsonEncode(decode)}");

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());

        print("object${response.stream}\n\n");
        print("\n\n Response object${response.statusCode}\n\n");
        print("\n\n Response object${response.reasonPhrase}\n\n");
      } else {
        print("\n\n\n Here Comment ");
        print(response.statusCode);
        print(response.reasonPhrase);
      }
    } catch (e) {
      print("Exception $e");
    } finally {
      update();
    }

    await getSavedWagls();
    update();
  }

  Future postComment(String commentText, int waglId) async {
    print("Here Comment ");
    print("\n\n token::: ${ApiClient.box.read("authToken")}");
    print("Here Comment ");
    print("\n\n Wagl Id:: ${waglId.toString()}");
    print("\n\n userId::: ${ApiClient.box.read("userId")}");
    print("\n\n comment ::  ${commentText}");
    print("\n\n Link ${RemoteServices.baseUrl}api/comments");
    print("Here Comment ");
    var headers = {
      'Authorization': 'Bearer ${ApiClient.box.read("authToken")}'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${RemoteServices.baseUrl}api/comments'));

    // var a = '{"wagl_id":{"disconnect": [],"connect": [  {"id": ${wagls![index].id}}]},"user_id":${ApiClient.box.read("userId")},"comment_text":"$commentText"}';
    var a =
        '{"wagl_id":{"disconnect": [],"connect": [  {"id": $waglId}]},"user_id":{"disconnect": [],"connect": [  {"id": ${ApiClient.box.read("userId")}}]},"comment_text":"$commentText"}';
    request.fields.addAll({
      'data': a
      // '{  "wagl_id": "88",  "user_id": "48",  "comment_text": "asmdnam,snd,m"}'
    });

    print("HERE IS THE FEILD ${request.fields}");

    List<XFile>? mediaFileList;
    // request.body = json.encode(body);
    List<http.MultipartFile> files = [];
    if (files.isNotEmpty) {
      for (int i = 0; i < mediaFileList!.length; i++) {
        var f = await http.MultipartFile.fromPath(
            'files.media', mediaFileList[i].path);
        files.add(f);
      }
    }

    request.files.addAll(files);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
    } else {}

    commentTextController.clear();
    HapticFeedback.heavyImpact();
    await getCommentWagls(waglId);
    update();
  }

  Future updateImage(index, currentImagePath) async {
    changedImages[index] = currentImagePath;
    // changedImagesAll[index]=currentImagePath;
    selectedMedia[index].path != currentImagePath;
    print("path of the currentImagePath:: $currentImagePath");
    print("path of the  $index image:: ${selectedMedia[index].path}");

    currentSelectedMedia = changedImages[index];
    update();
  }

  List<String> changedThumnails() {
    for (int i = 0; i < changedImagesAll.length; i++) {
      print(("here are the ThumbnailFunction${changedImagesAll[i]}"));
    }
    update();
    return changedImagesAll;
  }

  Future updateThumbnailImage(currentImagePath, index) async {
    videoThumbnail = XFile(currentImagePath);
    changedImagesAll[index] = currentImagePath;
    // print("Here is the image$currentImagePath  ");
    update();
  }

  final TextEditingController commentController = TextEditingController();

  bool checkedLikedPost(waglId) {
    // Convert the list into a Set for faster lookups
    final Set<int> idSet = likedWaglArray!.toSet();
    print(
        "here is the id asad hererr  $waglId and here is the liked  ${idSet.contains(waglId)}");

    print(
        "here is the id asad 22222222 $waglId and here is the liked  ${idSet}");
    if (idSet.contains(waglId)) {
      return true;
    } else {
      return false;
    }
  }

  bool checkedSavedPost(waglId) {
    // Convert the list into a Set for faster lookups
    final Set<int> idSet = savedWaglArray!.toSet();
    if (idSet.contains(waglId)) {
      return true;
    } else {
      return false;
    }
  }

  bool checkedFollowedUser(int userId, index) {
    final Set<int> idSet = followersList!.toSet();
    if (idSet.contains(userId)) {
      // print("here is the followed User $userId");
      // update();
      // storyItems[index].isFollows = !storyItems[index].isFollows;
      return true;
    } else {
      // storyItems[index].isFollows = !storyItems[index].isFollows;
      return false;
    }
  }

  updateKeybroadSize(size) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      keyBroadSize = size;
      print("here is the keybroadSize $keyBroadSize");
      update();
    });
  }

  void dragCommentBox() {
    initialChildSize = 0.6;
    maxChildSize = 1.0;
    print("here is the size$initialChildSize $maxChildSize");
    update();
  }

  clearData() {
    isLoading = true;
    isWaglLoading = true;
    update();
  }

  clearReportData() {
    reportTextController.clear();
    reasonText = "Please select";
    reasonId = 0;
    update();
  }

  void updateDiscardValue(bool value) {
    isDiscard = value;
    print("here is the value $isDiscard");
  }

  int? getIdByReason(String reason) {
    for (var type in reportType) {
      if (type.reason == reason) {
        return type.id;
      }
    }
    return null; // Return null if reason is not found
  }

  updateReportReason(value) {
    reasonText = value;
    reasonId = getIdByReason(value)!;
    print("Here asre ithe $reasonText");
    print("Here asre ithe $reasonId");
    update();
  }
}
