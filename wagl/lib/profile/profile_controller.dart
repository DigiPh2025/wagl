import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:video_player/video_player.dart';
import 'package:wagl/home/home_page.dart';
import 'package:wagl/profile/saved_wagl_model.dart';
import 'package:wagl/util/ApiClient.dart';
import 'package:http/http.dart' as http;
import '../custom_widget/colorsC.dart';
import '../home/all_wagl_model.dart';
import '../home/home_controller.dart';
import '../home/home_model.dart';
import '../register/categories_model.dart';
import '../services/remote_services.dart';
import '../settings/settings_controller.dart';
import 'profile_model.dart';

class ProfileController extends GetxController {
  // late var profileDetails;
  var profileImg;
  String profileImgUrl = "";
  bool emailNotification = false;
  bool pushNotification = false;



  // List<Data>? viewUserWagl = [];
  String bio = "0";
  var location = "Here";
  var address = "Here";
  List categoriesNames = [];
  bool isChecked = false;
  bool isOwnProfile = true;
  int? userAttributeIndex;
  int? userAttributeId;
  List<CategoryList> categoriesList = [];
  List<CategoryList> userRecentCategoriesList = [];
  List<InterestedCategoryProfile>? personalCategoriesList = [];
  List<InterestedCategoryProfile>? userCategoriesList = [];

  ScrollController scrollController = ScrollController();

  // late final ViewWaglModel viewWaglModel;
  // List<MediaDataUser> mediaDataUser=[];
  List<DataWagl>? personalDetails = [];
  List<DataWagl>? userDetails = [];
  List<DataWagl>? selfWagl = [];
  var imgUrl;

  // late TabController tabController;
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    fetchNames();
    getProfileDetails(0);
    getSavedPost();
    clearData();
    // getAllCategories();
    // getCurrentLocation();
    // getSavedPost();
    // getUsersWagl(0);
    super.onInit();
  }

// late ProfileDetailsModel profileDetails;

  Future<void> getCurrentLocation() async {
    print("Here is the Location ####");
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    } else {
      permission = await Geolocator.checkPermission();
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    location = 'Lat: ${position.latitude}, Long: ${position.longitude}';
    location = 'Lat: ${position.latitude}, Long: ${position.longitude}';
    getAddressFromLatLng(position.latitude, position.longitude);
    update();
  }

  Future<void> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placeMark = await placemarkFromCoordinates(lat, lng);
      Placemark place = placeMark[0];
      address = '${place.locality}, ${place.postalCode}, ${place.country}';
    } catch (e) {
      address = 'Failed to get address';
    }
    update();
  }

  Future getAllCategories() async {
    var getDetails = await RemoteServices.fetchGetData(
        'api/interested-categories?fields[0]=categoryName&populate[categoryIcon][fields][0]=*&sort[0]=categoryName');
    if (getDetails.statusCode == 200) {
      var apiDetails = getCategoriesModelFromJson(getDetails.body);
      categoriesList = apiDetails.data;
    } else {
      print(
          "Failed to fetch data. Status code: profile${getDetails.statusCode}");
    }
    update();
  }

  updateNotificationType(bool flag, int no) {
    print("Here");
    if (no == 1) {
      emailNotification = !emailNotification;
      print("Email $emailNotification");
    } else {
      pushNotification = !pushNotification;
      print("pushNotificationpushNotification $pushNotification");
    }

    update();
  }

  List<SavedData>? savedWagl = [];
  List<SavedData>? inFilteredWagls = [];
  final List<PersonStories> savedStoryItems = [];

  Future getSavedPost() async {
    final categoryFilters = selectedCategoriesList
        .map((id) => 'filters[interested_categories][\$eq]=$id')
        .join('&');
    print("here are the list getSavedPost $categoryFilters");

    var getDetails = await RemoteServices.fetchGetData(
        /*'api/users/${ApiClient.box.read("userId")}/?populate=*');*/
        // 'api/saved-wagls?populate[wagl_id][populate]=thumbnail&filters[user_id][\$eq]=${ApiClient.box.read("userId")}&populate[wagl_id][populate]=media&sort=createdAt:desc&populate[user_id]=*');
        'api/saved-wagls?populate[media][sort]=name:asc&filters[user_id][\$eq]=${ApiClient.box.read("userId")}&sort=createdAt:desc&isActive=true&populate[wagl_id][populate]=product_id.brand_id&pagination[pageSize]=10000&pagination[page]=1&populate[wagl_id][populate]=product_id.product_pic&populate[wagl_id][populate]=user_id.profilePic&populate[wagl_id][populate]=interested_categories&populate[wagl_id][populate]=thumbnail&populate[wagl_id][populate]=media&populate[wagl_id][populate][0]=good_tags.image&$categoryFilters');
    if (getDetails.statusCode == 200) {
      savedWagl!.clear();
      inFilteredWagls!.clear();
      var apiDetails = viewAllSavedWaglModelFromJson(getDetails.body);
      inFilteredWagls = apiDetails.data;
      for (int i = 0; i < inFilteredWagls!.length; i++) {
        print("here is theinFilteredWagls ${inFilteredWagls!.length} ");
        if (inFilteredWagls![i].attributes!.waglId!.data != null&&inFilteredWagls![i].attributes!.waglId!.data!.attributes!.userDetails!.data!=null) {
          // print("here is the saved Wagl ${savedWagl![i].attributes!.waglId!.data!.attributes!.media!.data![0].attributes!.ext!}");

          savedWagl?.add(inFilteredWagls![i]);
          // .where((item) => item.attributes!.waglId!.data != null)
          // .toList();
          // if(savedWagl![i].attributes!.waglId!.data!.attributes!.thumbnail!=null){
          //   print("\n\n\nThumnail url ${savedWagl![i].attributes!.waglId!.data!.attributes!.thumbnail!.attributes!.url!}");
          // }d
        } else {
          // print("here is the saved Wagl issue/*${savedWagl![i].id}*/");
        }
      }
      if (savedWagl!.isNotEmpty) {
        print("object here is ${savedWagl!.length}");
        for (int i = 0; i < savedWagl!.length; i++) {
          if(savedWagl![i].attributes!.waglId!.data!.attributes!.userDetails!.data!=null){
            print(
                ": Here is the length :${savedWagl![i].attributes!.waglId!.data!.attributes!.userDetails!.data!.attributes!.username}");
            var userIdData =
                savedWagl![i].attributes!.waglId!.data!.attributes!.userDetails!.data;
            var profilePicData = userIdData!.attributes!.profilePicData;

            if (profilePicData != null &&
                profilePicData.data != null &&
                profilePicData.data!.attributes!.url != null &&
                profilePicData.data!.attributes!.url!.isNotEmpty) {
            } else {}
          }

        }
        storyViewIndex = 0;
        savedStoryItems.clear();

        for (int i = 0; i < savedWagl!.length; i++) {

          if(savedWagl![i].attributes!.waglId!.data!.attributes!.userDetails!.data!=null){
            var userIdData =  savedWagl![i].attributes!.waglId!.data!.attributes!.userDetails!.data;
            var profilePicData = userIdData!.attributes!.profilePicData;
            // print("here us the value ");
            // print("here is the product ${savedWagl![i].attributes!.waglId!.data!.attributes!.productId!.data!.attributes!.name}");

            if(savedWagl![i].attributes!.waglId!.data!.attributes!.productId!.data!=null){
              print("here us the value ");
              if (profilePicData != null &&
                  profilePicData.data != null &&
                  profilePicData.data!.attributes!.url != null &&
                  profilePicData.data!.attributes!.url!.isNotEmpty ) {
                String? urlProfilePic = profilePicData.data!.attributes!.url;
                PersonStories personItem =
                getPersonStories( savedWagl![i].attributes!.waglId!.data!.attributes!, urlProfilePic,savedWagl![i].attributes!.waglId!.data!.id!,savedWagl![i].attributes!.waglId!.data!.attributes!.productId);
                savedStoryItems.add(personItem);
                print("here is profile pic present && product also${savedWagl![i].attributes!.waglId!.data!.attributes!.productId!.data!.attributes!.productPic}");
                print("here is the product [$i] productId ${savedWagl![i].attributes!.waglId!.data!.attributes!.productId!.data!.attributes!.name}");
              }
              else {
                PersonStories personItem =
                getPersonStories( savedWagl![i].attributes!.waglId!.data!.attributes!, null,savedWagl![i].attributes!.waglId!.data!.id!,savedWagl![i].attributes!.waglId!.data!.attributes!.productId/*savedWagl![i].attributes!.waglId!.data!.attributes!.productId!*/);
                savedStoryItems.add(personItem);
                print("productId here is empty");
              }
            }
            else{
              if (profilePicData != null &&
                  profilePicData.data != null &&
                  profilePicData.data!.attributes!.url != null &&
                  profilePicData.data!.attributes!.url!.isNotEmpty) {
                String? urlProfilePic = profilePicData.data!.attributes!.url;
                PersonStories personItem =
                getPersonStories( savedWagl![i].attributes!.waglId!.data!.attributes!, urlProfilePic,savedWagl![i].attributes!.waglId!.data!.id!,null);
                savedStoryItems.add(personItem);

              }
              else {
                PersonStories personItem =
                getPersonStories( savedWagl![i].attributes!.waglId!.data!.attributes!, null,savedWagl![i].attributes!.waglId!.data!.id!,null);
                savedStoryItems.add(personItem);

              }
            }
          }

        }
        /////////////////////////////////////////////////////////////////////////
        for (int i = 0; i < savedWagl!.length; i++) {

if(savedWagl![i].attributes!.waglId!.data!.attributes!.userDetails!.data!=null){
  var userIdData =
      savedWagl![i].attributes!.waglId!.data!.attributes!.userDetails!.data;
  var profilePicData = userIdData!.attributes!.profilePicData;

  if (profilePicData != null &&
      profilePicData.data != null &&
      profilePicData.data!.attributes!.url != null &&
      profilePicData.data!.attributes!.url!.isNotEmpty&&savedWagl![i].attributes!.waglId!.data!.attributes!.productId!=null) {
    String? urlProfilePic = profilePicData.data!.attributes!.url;
    PersonStories personItem = getPersonStories(
        savedWagl![i].attributes!.waglId!.data!.attributes!,
        urlProfilePic,
        savedWagl![i].attributes!.waglId!.data!.id!,savedWagl![i].attributes!.waglId!.data!.attributes!.productId);
    savedStoryItems.add(personItem);

  }
  else if (profilePicData != null &&
      profilePicData.data != null &&
      profilePicData.data!.attributes!.url != null &&
      profilePicData.data!.attributes!.url!.isNotEmpty&&savedWagl![i].attributes!.waglId!.data!.attributes!.productId==null) {
    String? urlProfilePic = profilePicData.data!.attributes!.url;
    PersonStories personItem = getPersonStories(
        savedWagl![i].attributes!.waglId!.data!.attributes!,
        urlProfilePic,
        savedWagl![i].attributes!.waglId!.data!.id!,null);
    savedStoryItems.add(personItem);

  }else {
    PersonStories personItem = getPersonStories(
        savedWagl![i].attributes!.waglId!.data!.attributes!,
        null,
        savedWagl![i].attributes!.waglId!.data!.id!,null);
    savedStoryItems.add(personItem);

  }
}

        }
      } else {
        print("Empty WaglshErer ");
        print("object lengthhh ${savedWagl!.length}");
      }
      print("object ${savedWagl!.length}");
    } else {
      print("Empty WaglshErer ");
      print("object lengthhh ${savedWagl!.length}");
      print(

          "222. Failed to fetch data. Status code:profile${getDetails.statusCode}");
    }
    update();
  }

  VideoPlayerController videoController = VideoPlayerController.network("url");
  List<String> sortedUrl=[];
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
  sortMedia(lengthMedia,index,){

    //  int indexA = int.parse(a.split('_')[0]);
    //  int indexB = int.parse(b.split('_')[0]);
    //  indexA.compareTo(indexB);

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
  getPersonStories(WaglSavedAttributes attributes, url, int wagls,productId) {
    final attributesUser = attributes.userDetails!.data!.attributes!;
    final List<String> mediaUrls = attributes.media!.data!
        .map((mediaItem) => mediaItem.attributes!.url!)
        .toList();

    final List<String> mediaExt = attributes.media!.data!
        .map((mediaItem) => mediaItem.attributes?.ext??"")
        .toList();
    final List<String> mediaName = attributes.media!.data!
        .map((mediaItem) => mediaItem.attributes?.name??"")
        .toList();

    sortedUrl.clear();
    sortedUrl=mediaUrls;

    final sortedMedia = List.from(attributes.media!.data!)
      ..sort((media1, media2) {
        final number1 = int.tryParse(media1.attributes!.name!.split('_')[0]) ?? 0;
        final number2 = int.tryParse(media2.attributes!.name!.split('_')[0]) ?? 0;

        return number1.compareTo(number2); // Ascending order
      });
    final List<int> mediaIds = attributes.media!.data!
        .map((mediaItem) => mediaItem.id!)
        .toList();
    for(int i=0;i<sortedMedia.length;i++){
      print("here is the sort media file ${sortedMedia[i].attributes!.url}");
    }
    List<int> sortedIds=[];
    sortedIds.clear();
    List<String> sortedUrls=[];
    sortedUrls.clear();
    print("here is the lengthhere ::${mediaName.length}");
    sortMedia1(mediaName);
    print("sortMedia aa :: $list");
    for(int i=0;i<mediaName.length;i++){
      //  final sp = int.tryParse(mediaNames[i].split('_')[0]) ?? 0;
      sortedUrls.add(sortMedia(mediaName,list[i]));
      // print("here is the sort media file ${mediaNames[i]}");
    }
    return PersonStories(
      username: "${attributesUser.username}",
      profileImage: url,
      // profileImage: profilePicData==null?profilePicData!.data!.attributes!.url!:"https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_960_720.png",
      //"${attributesUser.profilePicData!.data!.attributes!.url!}",
      description: "${attributes.description}",
      location: "${attributes.location}",
      likes: attributes.totalLikes ?? 0,
      totalComments: attributes.totalComments ?? 0,
      views: attributes.totalViews ?? 0,
      userId: attributes.userDetails!.data!.id,
      waglId: wagls,
      productId: productId,
      sortedMedia: sortedMedia,
      mediaName: mediaName,
      media: sortedUrls,
      mediaExt: mediaExt,
      totalSaved: attributes.totalSaved ?? 0,
      // categoryData:attributesCategories,
      liked: true,
      saved: false,
      categoryData: attributes.interestedCategories!.data!,
      goodTagData: attributes.goodTags?.data ?? [],
      controller: StoryController(),
      mediaId: mediaIds,
      // stories: [...List.generate(2, (index) => attributes.media.data[index].attributesMedia.url)],
      stories: [
      /*  ...List.generate(
          attributes.media!.data!.length,
          (index) => attributes.media!.data![index].attributes!.ext == ".mp4"
              ? StoryItem.pageVideo(
                  "${attributes.media!.data![index].attributes!.url}",
                  controller: StoryController(),
                  // requestHeaders: {"content-type":"media/mp4"},
              // videoController: videoController,
                  duration: Duration(minutes: 1000))
              : StoryItem.pageImage(
                  url: "${attributes.media!.data![index].attributes!.url}",
              duration: Duration(minutes: 1000),
                  controller: StoryController()),
        )*/
        ...List.generate(
          sortedMedia.length,
              (index) {
            final media = sortedMedia[index];
            return media.attributes!.ext == ".mp4"||media.attributes!.ext == ".mov"||media.attributes!.ext == ".hevc"
                ? StoryItem.pageVideo(
              // videoController: videoController,
              "${media.attributes!.url}",
              controller: StoryController(),
              duration: Duration(seconds: 40),
            )
                : StoryItem.pageImage(
              url: "${media.attributes!.url}",
              duration: Duration(seconds: 40),
              controller: StoryController(),
            );
          },
        ),
      ],

      /* stories: [
        StoryItem.pageImage(
          url:
          "${attributes.media.data.}",
          controller: StoryController(),
        ),
        StoryItem.pageImage(
          url:
          "https://images.unsplash.com/photo-1575111589590-2f0ee8eec5d4?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
          controller: StoryController(),
        ),
        StoryItem.text(
            title: "Person 1 - Story 4", backgroundColor: Colors.blue),
      ],*/
      isFollows: false,
    );
  }

  updateProfilePic() {
    var homeController = Get.put(HomeController());
    homeController.update();
  }

  ProfileDetailsModel? personProfileDetails;

  Future getProfileDetails(id) async {
    var getDetails;

    if (id == 0) {
      var userId = ApiClient.box.read("userId");
      // getDetails  = await RemoteServices.fetchGetData('api/wagls?populate[thumbnail]=*&sort=createdAt:desc&populate[media][populate]=media&filters[user_id][\$eq]=$userId&populate[user_id][populate]=*');
      getDetails = await RemoteServices.fetchGetData(
          'api/users/${ApiClient.box.read("userId")}/?populate=*');
      if (getDetails.statusCode == 200) {
        print("here to update user Data");

        var apiDetails = profileDetailsFromJson(getDetails.body);
        // profileDetails=apiDetails;
        personProfileDetails = apiDetails;
        profileImg = apiDetails.profilePic;
        bool isPrivateFlag=false;
        if (apiDetails.accountType=="private") {
          isPrivateFlag = true;
        } else {
          isPrivateFlag = false;
        }
        var settingController = Get.put(SettingController());

        settingController.updateAccountType(isPrivateFlag);
        if (personProfileDetails!.profilePic == null) {
          image = null;
          profileImg = null;
          print("profile function call");
        } else {
          profileImgUrl = apiDetails.profilePic!.url;
          ApiClient.box.write("profilePic", profileImgUrl);
          print("profile function call");
        }
        personalCategoriesList!.clear();
        if (personProfileDetails!.recentCategories != null) {
          for (int i = 0;
              i < personProfileDetails!.recentCategories!.length;
              i++) {
            personalCategoriesList!
                .add(personProfileDetails!.recentCategories![i]);
            print(
                "here are the categories::${personalCategoriesList![i].categoryName}   id ==${personalCategoriesList![i].id}");
          }
        }
        print("here is the first name${personProfileDetails!.firstName}");
        print("\n\n here is the first name${personProfileDetails!.firstName}");

        pushNotification = apiDetails.pushNotification;
        emailNotification = apiDetails.emailNotification;
        bio = apiDetails.bio;
        // getTotalViewCountPerson();
        /* print(
            "Profile Controller  recentCategories${apiDetails.recentCategories!.length}");*/
      } else {
        print(
            "Profile ControllergetUsersWagl  Failed to fetch data. Status code:profile${getDetails.statusCode}");
      }
    } else {
      getDetails =
          await RemoteServices.fetchGetData('api/users/$id/?populate=*');
      if (getDetails.statusCode == 200) {
        print("here to update user Data");
        var apiDetails = profileDetailsFromJson(getDetails.body);
        // profileDetails=apiDetails;

        if (apiDetails.interestedCategories != null) {
          personalCategoriesList!.clear();
          for (int i = 0; i < apiDetails.interestedCategories!.length; i++) {
            personalCategoriesList!.add(apiDetails.interestedCategories![i]);
          }
        }

        pushNotification = apiDetails.pushNotification;
        emailNotification = apiDetails.emailNotification;
        bio = apiDetails.bio;
      } else {
        print(
            "1111.Profile Controller  Failed to fetch data. Status code:profile${getDetails.statusCode}");
      }
    }

    updateProfilePic();
    update();
  }

  List<DataWagl>? wagls = [];
  var getDetails;
  var categoryFilters;

  Future clearRecentCategoriesFilter(userId) async {
    selectedCategoriesIndex.clear();
    selectedCategoriesList.clear();
    categoryFilters = "";

    getUsersWagl(0);
    update();
  }
  var selectedCategories;

  Future getUsersWagl(id) async {
    print("here is the getUsersWagl FOr the id  $id");
    final categoryFilters = selectedCategoriesList
        .map((id) => 'filters[interested_categories][\$eq]=$id')
        .join('&');
    print("here are the list $categoryFilters");
    selectedCategories=categoryFilters;
    if (id == 0||id == 1) {
      var userId = ApiClient.box.read("userId");
      // getDetails  = await RemoteServices.fetchGetData('api/wagls?populate[thumbnail]=*&sort=createdAt:desc&populate[media][populate]=media&filters[user_id][\$eq]=$userId&populate[user_id][populate]=*');
      getDetails = await RemoteServices.fetchGetData(
          'api/wagls?populate[media][sort]=name:asc&populate[thumbnail]=*&sort=createdAt:desc&populate[media][populate]=media&filters[user_id][\$eq]=$userId&pagination[pageSize]=300&pagination[page]=1&populate[product_id][populate]=*&populate[user_id][populate]=*&$categoryFilters');
    } else {
      getDetails = await RemoteServices.fetchGetData(
          'api/wagls?populate[media][sort]=name:asc&populate[thumbnail]=*&sort=createdAt:desc&populate[media][populate]=media&filters[user_id][\$eq]=$id&pagination[pageSize]=300&pagination[page]=1&populate[user_id][populate]=*&populate[product_id][populate]=*');
    }
    // var getDetails = await RemoteServices.fetchGetData('api/wagls?populate=*');
    // var getDetails = await RemoteServices.fetchGetData('api/wagls?&populate[thumbnail]=*populate=media&filters[user_id][\$eq]=&sort=createdAt:desc');

    print("Here us the ${getDetails.body} ");
    if (getDetails.statusCode == 200) {
      var apiDetails = await viewAllWaglModelFromJson(getDetails.body);
      // viewWaglModel=apiDetails;

      if (id == 0) {
        personalDetails!.clear();
        personalDetails = apiDetails.data;
        // updateProfilePic();
        //  getTotalViewCountPerson();

        update();
      } else {
        userDetails!.clear();
        userDetails =apiDetails.data;
        update();
        print(
            "-----------------------------------------------------------------------");
      }

    }
    else if(getDetails.statusCode == 403||getDetails.statusCode == 401) {
      AlertDialog(
        title: Text('Action Buttons Example'),
        content: Text('This dialog has custom action buttons and padding.'),
        actionsPadding: EdgeInsets.symmetric(horizontal: 10.0),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              // Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text('Proceed'),
            onPressed: () {
              // Handle the proceed action
            },
          ),
        ],
      );
    }
    else {
      print(
          "getUsersWagl Failed to fetch data. Status code:profile${getDetails.statusCode}");

    }

    update();
  }

  Future removeProfileImage() async {
    print("Here is the sentence from function outer ");

    if (profileImg != null) {
      var getDetails = await RemoteServices.deleteData('api/removeProfilePic');
      if (getDetails.statusCode == 200) {
        print("Here is the sentence from function outer ");

        print("Here is${getDetails.data}");
        print("Here is${getDetails.statusCode}");
      } else {
        print(
            "6666Failed to fetch data. Status code:profile${getDetails.statusCode}");
      }
    }

    getProfileDetails(0);
    updateProfilePic();
    update();
  }

  List<DataWagl> userData = [];

  File? image;

  Future get_image(ImageSource source) async {
    var img = await ImagePicker()
        .pickImage(source: source); // moto x4
    // var image = await ImagePicker.pickImage( imageQuality: 90, source: ImageSource.camera, );
    if (img != null) {
      var cropped = await ImageCropper().cropImage(
          sourcePath: img.path,
          // compressQuality: 100,
          cropStyle: CropStyle.circle,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            // CropAspectRatioPreset.ratio5x3,
            //  CropAspectRatioPreset.ratio3x2,
            // CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            // /*   CropAspectRatioPreset.ratio5x3,
            // CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio7x5,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
              toolbarColor: colorPrimary,
              toolbarTitle: "Wagl",
              statusBarColor: colorPrimary,
              backgroundColor: Colors.white,
            )
          ]);

      // final bytes = (await img.readAsBytes()).lengthInBytes;
      image = File(cropped!.path);
    }

    // print(" print == ::: $image");
    print("Here is the msg :: ${image}");
    updateProfileImg();
    update();
  }

  bool updatedStatus = false;

  Future updateProfileImg() async {
    print("here is the token Bearer ${ApiClient.box.read("authToken")}");
    print("here is the Link ${RemoteServices.baseUrl}api/user/me");
    var headers = {
      'Authorization': 'Bearer ${ApiClient.box.read("authToken")}'
    };
    var request = http.MultipartRequest(
        'PUT', Uri.parse('${RemoteServices.baseUrl}api/user/me'));
    if (image == null) {
      request.fields['profilePic'] = '';
    } else {
      request.files
          .add(await http.MultipartFile.fromPath('profilePic', image!.path));
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("Here is the msg for 200:: ${response}");
      print(await response.stream.bytesToString());
      updatedStatus = true;
    } else {
      updatedStatus = false;
      print("Here is the msg Else :: ${response.statusCode}");
      print(response.reasonPhrase);
    }

    await getProfileDetails(0);
    // updateProfilePic();
    update();
  }

  bool isFollows = false;
  List<int>? followersList = [];



  var isProcessing = false;



  fetchNames() async {
    List namesList = [];
    categoriesNames.clear();
    categoriesNames.addAll(namesList);
    for (int i = 0; i < namesList.length; i++) {
      print("Here are the Name ${categoriesNames[i]}\n\n");
      print("Here are the Name ${categoriesNames[i]}\n\n");
    }

    update();
  }

  clearData() {
    selectedCategoriesIndex = [];
    selectedCategoriesList = [];
    clearRecentCategoriesFilter(0);
    update();
  }

  var tabIndex = 0;

  void updateTabIndex(int index) {
    tabIndex = index;
    update();
  }

  Future getFollowersList() async {
    print("here is the getFollowersList ");
    var getDetails = await RemoteServices.fetchGetData('api/getFollowersList');
    if (getDetails.statusCode == 200) {
      var apiDetails = viewCountModelFromJson(getDetails.body);
      followersList = apiDetails.result;
      if (followersList!.isNotEmpty) {
        print("\n\n here is the followersList::${followersList}");
        // profileDetails=apiDetails;
      } else {
        print("\n\n here is the followersList::${followersList}");
      }
    } else {
      print(
          "api/getFollowersList Failed to fetch data. Status code:profile${getDetails.statusCode}");
    }
    update();
  }



  List selectedCategoriesIndex = [];
  List selectedCategoriesList = [];

  Future getFilteredWaglsFromCategories(int index) async {
    if (selectedCategoriesIndex.contains(index)) {
      selectedCategoriesIndex.remove(index);
      selectedCategoriesList.remove(personalCategoriesList![index].id);
    } else {
      selectedCategoriesIndex.add(index);
      selectedCategoriesList.add(personalCategoriesList![index].id);
    }
    print("$selectedCategoriesIndex");
    print("Here is the Categoris $selectedCategoriesList");
    final categoryFilters = selectedCategoriesList
        .map((id) => 'filters[interested_categories][\$eq]=$id')
        .join('&');
    print("here are the list $categoryFilters");
    getUsersWagl(0);
    update();
  }

  bool isUpdated=false;

  Future updateNotification() async {

    Map<String, dynamic> map = {
      "emailNotification": emailNotification,
      "pushNotification": pushNotification,

    };

    print("here is the map $map");
    var getDetails=await RemoteServices.fetchPutData("api/user/me", map);
    if(getDetails.statusCode==200){
      isUpdated=true;
    }
    else{
      isUpdated=false;
    }
    print("here is the getdials body :: ${getDetails.statusCode}");
    print("here is the getdials body :: ${getDetails.data}");
    print("here is the getdials body :: ${getDetails.errorMessage}");
    update();
  }
}
