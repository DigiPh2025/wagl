import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:http/http.dart" as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:wagl/register/follow_list_model.dart';
import '../create_wagl/good_tag_model.dart';
import '../custom_widget/color_loader.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_text.dart';
import '../custom_widget/location_permission_dialog.dart';
import '../custom_widget/validator.dart';
import '../services/remote_services.dart';
import '../util/ApiClient.dart';
import '../util/SizeConfig.dart';
import 'categories_model.dart';

class AdditionalDetailsController extends GetxController {
  String fName = "", lName = "", userName = "";
  bool isPrivateAccount = ApiClient.box.read("isPrivateAccount") ?? false;
  bool allNames = false;
  LatLng latlng = LatLng(18.579442, 73.482968);
  CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(18.579442, 73.482968),
    tilt: 5.440717697143555,
    zoom: 14,
  );
  double? lat, lng;
  String mapTheme = "";
  List<Marker> markers = <Marker>[];
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var userNameController = TextEditingController();
  var contactNoController = TextEditingController();
  var locationController = TextEditingController();
  List<int> disconnectIds = []; // Replace with your dynamic data
  List<int> connectIds = []; // Replace with your dynamic data
  List categoriesNames = [];
  List contactNames = [];
  bool isFollows = false;
  var selectedDay;

  // var dayValue="DD";
  // String monthValue="MM";
  // String yearValue="YYYY";
  var selectedMonth;

  var selectedYear;

  int daysInMonth = 31;
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  static final LatLng center = const LatLng(45.521563, -122.677433);
  bool servicestatus = false;
  bool haspermission = false;
  bool enableDeviceLocation = true;
  LocationPermission? permission;
  Position? position;
  late StreamSubscription<Position> positionStream;

  List selectedItemList = [];
  String genderDetails = "Select gender";
  String pronounDetails = "Select pronoun";
  List selectedFollows = [];
  List selectedCategoriesIndex = [];
  late DataModel categories;
  var selectedAddress = 'Search locations';
  bool isAddressSelected = false;
  List<CategoryList> categoriesList = [];

  @override
  void onInit() {
    // TODO: implement onInit
    cleanData();
    fetchNames();
    getFcmToken();
    futureUsers = fetchUsers();
    ApiClient.box.read("isPrivateAccount") == null
        ? ApiClient.box.write("isPrivateAccount", false)
        : ();
    // updateDaysInMonth();

    // onMapCreated(mapController);
    super.onInit();
  }

  void setDay(int day) {
    selectedDay = day;
    update();
  }

  void setMonth(int month) {
    selectedMonth = month;
    updateDaysInMonth();
    update();
  }

  void setYear(int year) {
    selectedYear = year;
    updateDaysInMonth();
    update();
  }

  checkAdditionalDataFilled() {

    print("selectedDay  : $selectedDay");
    print("selectedMonth  : $selectedMonth");
    print("selectedYear  : $selectedYear");
    print("selectedAddress  : $selectedAddress");
    print("pronounDetails  : $pronounDetails");
    print("genderDetails  : $genderDetails");

    if (selectedDay != null &&
        selectedMonth != null &&
        selectedYear != null /*&&
        selectedAddress != 'Search locations'*/ &&
        pronounDetails != "Select Pronoun" &&
        genderDetails != "Select Gender") {

      print("if  :======== ");
      return true;
    } else {
      print("item :: $selectedDay");
      print("item :: $selectedMonth");
      print("item :: $selectedYear");
      print("item :: $selectedAddress");
      print("item :: $pronounDetails");
      print("item :: $genderDetails");
      // print("item :: $selectedDay");

      return false;
    }
  }

  void updateDaysInMonth() {
    var month = selectedMonth;
    var year = selectedYear;
    if (month == 4 || month == 6 || month == 9 || month == 11) {
      daysInMonth = 30;
    } else if (month == 2) {
      if (isLeapYear(year)) {
        daysInMonth = 29;
      } else {
        daysInMonth = 28;
      }
    } else {
      daysInMonth = 31;
    }
    if (selectedDay > daysInMonth) {
      selectedDay = daysInMonth;
    }
  }

  updateAddress() {
    print(
        "Here is the searchController Address ${searchController.text.toString()}\n\n");
    print("Here is the selected Address ${selectedAddress}\n\n");
    selectedAddress = searchController.text.toString();
    print("Here is the selectedAddress  ${selectedAddress}");

    update();
  }

  bool isLeapYear(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) {
          return true;
        }
        return false;
      }
      return true;
    }
    return false;
  }

  String getSelectedDate() {
    return '$selectedDay/$selectedMonth/$selectedYear';
  }

  updateLatlng(plat, plng) {
    print("position.longitude === 2");
    latlng = LatLng(double.parse(plat), double.parse(plng));
    lat = double.parse(plat);
    lng = double.parse(plng);
    gotoCurrentPosition();
    update();
  }

  gotoCurrentPosition() async {
    GoogleMapController mController = await mapController.future;
    mController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latlng, tilt: 5.440717697143555, zoom: 18),
      ),
    );

    print("gotoCurrentPosition === 2");
    markers.clear();
    markers.add(Marker(
        markerId: MarkerId("Current"),
        position: latlng,
        infoWindow: InfoWindow(title: "_t1232", snippet: "_detail"),
        icon: BitmapDescriptor.defaultMarker));
    getAddressFromLatLng();

    update();
  }

  bool updatedStatus = false;

  updateGender(value) {
    genderDetails = value;
    print("Here asre ithe $genderDetails");
    update();
  }

  void onMapCreated(GoogleMapController controller) {
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }
  }

  Future checkGps(flag) async {
    print('Location permissions 111');
    servicestatus = await Geolocator.isLocationServiceEnabled();

    if (servicestatus) {
      print('Location permissions 22222');
      permission = await Geolocator.checkPermission();
      print('Location permissions 3333');
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        print('Location permissions 55555');
        print('Location permissions are denied');
        if (permission != LocationPermission.denied ||
            permission != LocationPermission.deniedForever) {
          print('Location permissions 4444');
          checkGps(flag);
        } else {
          print('Location permissions 999');
        }
      } else if (permission == LocationPermission.deniedForever) {
        print('Location permissions 6666');
        // await Geolocator.requestPermission();
        print("'Location permissions are permanently denied");
      } else {
        haspermission = true;
        enableDeviceLocation = true;
        await getLocation(false, "");
      }
    } else {
      print('Location permissions 88888 ');
      enableDeviceLocation = false;
      //  var openApp = await Geolocator.openLocationSettings();
      //   print("openApp ++++++ $openApp");

      print("GPS Service is not enabled, turn on GPS location");

      // ignore: use_build_context_synchronously
      showDialog(
          barrierDismissible: true,
          context: Get.context!,
          builder: (BuildContext context) => locationPermissionDialog(
                onSelected: (flag) {
                  print("selected : $flag");
                  if (flag) {
                    Geolocator.openLocationSettings();
                  }
                },
              ));
      //   return Future.error('Location services are disabled.');
    }

    update();
  }
  bool locationPermission=true;
  Future<void> getCurrentLocation(context) async {
    print("Here is the Location @@@locationPermission");
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
    permission = await Geolocator.requestPermission();
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
    print(statuses[Permission.location]);
    print("here is ther notifiaction $serviceEnabled");
    if(serviceEnabled){
      locationPermission=true;
      update();

      print("here is ther notifiaction $serviceEnabled");
    }
    if (!serviceEnabled) {
      locationPermission =false;
      print("Here  $serviceEnabled");
      update();

      var snackdemo = SnackBar(
        content: CustText(
            name: "Please enter location or enable location from settings !",
            size: 1.4,
            colors: colorBlack,
            fontWeightName: FontWeight.w600),
        backgroundColor: colorPrimary,
        elevation: 10,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(5),
        shape: BeveledRectangleBorder(),
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(snackdemo);
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      locationPermission =false;
      print("Here  $serviceEnabled");
      print('Location permissions are denied');
      update();
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
      permission = await Geolocator.requestPermission();
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
      ].request();
      print(statuses[Permission.location]);
      var snackdemo = SnackBar(
        content: CustText(
            name: "Please enter location or enable location from settings !",
            size: 1.4,
            colors: colorBlack,
            fontWeightName: FontWeight.w600),
        backgroundColor: colorPrimary,
        elevation: 10,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(5),
        shape: BeveledRectangleBorder(),
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(snackdemo);
    }

    if (permission == LocationPermission.deniedForever) {
      locationPermission =false;
      var snackdemo = SnackBar(
        content: CustText(
            name: "Please enter location or enable location from settings !",
            size: 1.4,
            colors: colorBlack,
            fontWeightName: FontWeight.w600),
        backgroundColor: colorPrimary,
        elevation: 10,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(5),
        shape: BeveledRectangleBorder(),
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(snackdemo);
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');

    }
    print("here is ther notifiaction $serviceEnabled");
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    getAddressFromLatLng();
    update();
  }

  Future getLocation(positionFlag, addres) async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      enableDeviceLocation = true;
    } else {
      enableDeviceLocation = false;
    }
    print('position.longitude === 22222 $servicestatus');
    print('position.longitude === 33333 $enableDeviceLocation');

    if (enableDeviceLocation) {
      print(
          "position.longitude === 1  permission $permission"); //Output: 80.24599079

      print("addres === 1   $addres");
      if (addres == "") {
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        print(
            "position.longitude ===  ${position!.latitude}"); //Output: 80.24599079
        print("position.latitude === ${position!.longitude}");
        lat = position!.latitude;
        lng = position!.longitude;
        latlng = LatLng(position!.latitude, position!.longitude);
      } else {
        List<Location> locations = await locationFromAddress(addres);
        print(
            "position.longitude ===  ${locations.first.latitude}"); //Output: 80.24599079
        print("position.latitude === ${locations.first.latitude}");
        lat = locations.first.latitude;
        lng = locations.first.longitude;
        latlng = LatLng(locations.first.latitude, locations.first.longitude);
      }
      //lat = 21.146135; lng = 79.092370;
      if (positionFlag) {
        gotoCurrentPosition();
        //   getCenter(position);
      }
    }

    update();
  }

  Future<void> updateUserInfo() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${ApiClient.box.read("authToken")}'
    };

    var disconnectList = disconnectIds.map((id) => {"id": id}).toList();
    var connectList = connectIds.map((id) => {"id": id}).toList();
    print("Here is the map ${ApiClient.box.read("authToken")}");
    print("Here is the map ${connectList}");
    print("Here is disconnect  ${disconnectList}");
    var request =
        http.Request('PUT', Uri.parse('${RemoteServices.baseUrl}api/user/me'));
    request.body = json.encode({
      "interestedCategories": {
        "disconnect": disconnectList,
        "connect": connectList
      }
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
      print("object  :: ${response.statusCode}");
    }
    update();
  }

  updateLocation(newLocation) {
    var additionalController = Get.put(AdditionalDetailsController());
    additionalController.updateLocation(newLocation);
    additionalController.update();

    update();
  }

  updatePronoun(value) {
    pronounDetails = value;
    print("Here asre ithe $pronounDetails");
    update();
  }

  var isMoved = false;
  late Future<List<User>> futureUsers;

  getCenter(position) async {
    isMoved = true;
    lat = position.target.latitude;
    lng = position.target.longitude;
    markers.clear();
    if (markers.length == 0) {
      markers.add(Marker(
          markerId: MarkerId("Current"),
          position: position.target,
          infoWindow: InfoWindow(title: "_title", snippet: "_detail"),
          icon: BitmapDescriptor.defaultMarker));
    }

    update();
  }
  List<User> waglUser=[];
  Future<List<User>> fetchUsers() async {
    var getDetails =
        await RemoteServices.fetchGetData("api/users?populate=profilePic&filters[id][\$ne]=${ApiClient.box.read("userId")}&filters[blocked][\$eq]=false&sort=firstName:asc");
    if (getDetails.statusCode == 200) {
      var apiDetails= userFromJson(getDetails.body);
      waglUser=apiDetails;
      print("Here ${getDetails.body}");
      for (int i = 0; i < waglUser.length; i++) {
        selectedFollows.add(false);
      }
      return userFromJson(getDetails.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

  var currentAddress = "";
  var usersCountry = "";

  Future<void> getAddressFromLatLng() async {
    var addresses = await GeocodingPlatform.instance!
        .placemarkFromCoordinates(lat ?? 0, lng ?? 0);
    await placemarkFromCoordinates(lat!, lng!)
        .then((List<Placemark> placemarks) {
      //   Placemark place = placemarks[0];
      currentAddress = "";
      // print("place == $place");
      print("addresses first == ${addresses.first}");
      print("addresses == ${addresses.first.name}");
      // Dynamix Mall, Y.J. Reality Ltd, Sant Dhyaneshwar Marg, Jvpd Scheme, next to Chandan Cinema, Vile Parle (W, Juhu, Mumbai, Maharashtra 400049
      print("place == $lat,$lng");

      if (addresses.first.subLocality != "") {
        currentAddress = '$currentAddress ${addresses.first.subLocality}';
        print("currentAddress subLocality ${currentAddress} \n\n");
      }
      if (addresses.first.locality != "") {
        if (addresses.first.locality != addresses.first.subLocality) {
          currentAddress = '${addresses.first.locality}';
          print("currentAddress  locality${currentAddress} \n\n");
        }
      }
      if (addresses.first.administrativeArea != "") {
        currentAddress =
            '$currentAddress, ${addresses.first.administrativeArea}';
        print("currentAddress administrativeArea ${currentAddress} \n\n");
      }
      if (addresses.first.postalCode != "") {
        currentAddress = '$currentAddress, ${addresses.first.postalCode}';
        print("currentAddress postalCode ${currentAddress} \n\n");
      }
      var newCurrentAddress = '${addresses.first.subLocality}';
       usersCountry = '${addresses.first.country}';
      //  print("place===== ${place}");
      print("currentAddress $currentAddress");
      print("addresses 1 : ${addresses[0]}");
      print(
          "addresses 2 : here ::${addresses.first.subLocality} ${addresses.first.locality}, ${addresses.first.postalCode} ");
      print("newCurrentAddress 3 : ${newCurrentAddress}");
      selectedAddress = currentAddress;

      // ${place.name} ${place.street}
    }).catchError((e) {
      debugPrint(e);
    });

    isMoved = false;
    if (searchController.text != "") {
      print("currentAddress === 1 : ${searchController.text}");

      currentAddress = searchController.text;
      searchController.text = "";
    } else {
      print("currentAddress === 2 : $currentAddress");
    }

    // mapController = Completer();

    markers.add(Marker(
        markerId: MarkerId("Current"),
        position: LatLng(lat!, lng!),
        infoWindow: InfoWindow(title: "_t1232", snippet: "_detail"),
        icon: BitmapDescriptor.defaultMarker));

    print("addresses  1 length : ${addresses.length}");
    addresses.clear();
    addresses = [];

    print("addresses 2 length : ${addresses.length}");

    update();
  }

  Future updateUserDetails(value) async {
    var newDate;
    if (selectedYear != null) {
      String date =
          ApiClient.formatDate(selectedYear, selectedMonth, selectedDay);
      print("${selectedYear}-${selectedMonth}-${selectedDay}");
      print("$date");
      print("\n\n ${RemoteServices.baseUrl}api/user/me");
      newDate = date;
    }
    var headers = {
      'Authorization': 'Bearer ${ApiClient.box.read("authToken")}'
    };
    var request = http.MultipartRequest(
        'PUT', Uri.parse('${RemoteServices.baseUrl}api/user/me'));

    print("\n\n ${ApiClient.box.read("authToken")}");

    if (value == 1) {
      request.fields.addAll({
        "firstName": firstNameController.text.toString(),
        "lastName": lastNameController.text.toString(),
        "username": userNameController.text.toString(),
        "contact_no": contactNoController.text.toString(),
        "fcm":fcmToken,
        "is_first":'1'
      });
    } else if (value == 2) {
      request.fields.addAll({
        'dateOfBirth': newDate,
        'location': currentAddress,
        'gender': genderDetails,
        'pronouns': pronounDetails,
        'accountType': accountType,
        'searchable_location': usersCountry,
      });
    }

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print("her is  ${response.statusCode}");
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      updatedStatus = true;
      ApiClient.box.write("registered", true);
    } else {
      updatedStatus = false;
      print(response.reasonPhrase);
    }
/*
    Map map = {
   */ /*   "firstName": firstNameController.text.toString(),
      "lastName": lastNameController.text.toString(),
      "username": userNameController.text.toString(),*/ /*
    };

    var getDetails =
        await RemoteServices.fetchPutData('api/user/me', map);
    if (getDetails.data != null) {
      isLoading = false;
      var apiDetails = loginResponseFromJson(getDetails.data);
      var msg = getDetails.errorMessage;
      print("JWT: ${msg}");

      print("JWT: ${getDetails.data}");
      updatedStatus=true;
      print("Here is the data. Status ${getDetails.data}");
    } else {
      var msg = getDetails.errorMessage!;
      print("Error: HERE HREE ${getDetails.errorMessage}");
      updatedStatus = false;
    }*/
    update();
  }
  String fcmToken="";
  Future<void> getFcmToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    // Retrieve FCM Token

    String? token = await messaging.getToken();

    if (token != null) {
      // Store the token in Hiv
      fcmToken=token;
      print("fcm token $fcmToken");
    }
  }
  validation() {
    // firstNameController.text = firstNameController.text.replaceAll(' ', '');
    print("Here is the string $fName");
/*    lastNameController.text = lastNameController.text.removeAllWhitespace;
    userName.removeAllWhitespace;*/

    fName = Validator.validateFName(firstNameController.text.toString());
    lName = Validator.validateLName(lastNameController.text.toString());
    userName = Validator.validateUserName(userNameController.text.toString());
    isValidContactNo = Validator.validateMobile(contactNoController.text.toString());
    update();
  }

  sendCategories() async {
    selectedCategoriesIndex.sort();
    print("here:: ${selectedCategoriesList}");
    connectIds.clear();
    disconnectIds.clear();
    for (int i = 0; i < selectedCategoriesList.length; i++) {
      connectIds.add(selectedCategoriesList[i]);
    }
    await updateUserInfo();
    print("Here is the value : $connectIds");
    update();
  }

  toggleSelection(int index, bool isSelected) {
    print(" Heshe is the index$index,,,, \n $isSelected");
    selectedItemList[index] = isSelected;
    print((selectedItemList));
    update();
  }

  updateFollows(int index, status,int followerId) async {
    print("Here $status");
    print("HerefollowerId $followerId");
    selectedFollows[index] = status;
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
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      // Update the follow/unfollow status in the story item
    }
    else {
    print("Error: ${response.statusCode}, ${response.reasonPhrase}");
    }
    update();
  }

  bool isFriendsSelected = false;

  checktrueValue() {
    bool hasTrue = selectedItemList.contains(true);
    if (hasTrue) {
      print('The list contains at least one true value.');
      isFriendsSelected = true;
    } else {
      print('The list does not contain any true values.');
      isFriendsSelected = false;
    }

    update();
  }

bool isValidUsername=true;
  Future checkUsernameApi(String username) async {
    var getDetails = await RemoteServices.fetchGetData(
        'api/users?filters[username][\$eq]=$username');
    if (getDetails.statusCode == 200) {

      var responseBody = jsonDecode(getDetails.body);

      // Check if the response body is a list and whether it is empty
      if (responseBody is List && responseBody.isEmpty) {
        print("The array is empty.");

        userName= Validator.validateUserName(userNameController.text.toString());
        isValidUsername=true;
      } else if (responseBody is List) {
        print("The array is not empty.");
        userName="This username is already taken.";
        isValidUsername=false;
        print("Response data:isValidUsername:: $isValidUsername $responseBody");
      } else {
        isValidUsername=false;
        print("Unexpected response format: $responseBody");
      }

    } else {
      print(
          "Failed to fetch data. Status code: profile${getDetails.statusCode}");
    }
    update();
  }

  Future fetchNames() async {
    List namesList = [];
    namesList = [
      'AliceCharlie',
      'BobCharlie',
      'CharlievCharlie',
      'DCharlieavid',
      'Eve',
      'Frank',
      'GrCharlieace',
      'Hank',
      'Ivy',
      'JackCharlie',
      'Karen',
      'Leo',
      'Mona',
      'NinaNinaNinaNina',
      'OscCharliear'
    ];
    contactNames.addAll(namesList);

    var getDetails = await RemoteServices.fetchGetData(
        // 'api/interested-categories?fields[0]=categoryName&populate[categoryIcon][fields][0]=*');
        'api/interested-categories?fields[0]=categoryName&populate[categoryImage][fields][0]=*&populate[categoryIcon][fields][0]=*&sort[0]=categoryName');
    if (getDetails.statusCode == 200) {
      var apiDetails = getCategoriesModelFromJson(getDetails.body);
      categoriesList = apiDetails.data;
      print("API Details: $apiDetails");
      categories = apiDetails;
      isLoading = false;
      print(
          "object:: ${apiDetails.data[0].attributes.categoryImage!.data.attributes.url}");
    } else {
      print(
          "Failed to fetch data. Status code: additional ${getDetails.statusCode}");
    }
    update();
  }

  List selectedCategoriesList = [];

  onNameTap(int index) {
    if (selectedCategoriesIndex.contains(index)) {
      selectedCategoriesIndex.remove(index);
      selectedCategoriesList.remove(categoriesList[index].id);
    } else {
      selectedCategoriesIndex.add(index);
      selectedCategoriesList.add(categoriesList[index].id);
    }
    print("$selectedCategoriesIndex");
    print("Here is the Categoris $selectedCategoriesList");
    print("Here is the Categoris $selectedCategoriesIndex");
    update();
  }

  validationNames() {
    var tempfName = Validator.validateFName(firstNameController.text.toString());
    var templName = Validator.validateLName(lastNameController.text.toString());
    var   tempContactNo =
    Validator.validateMobile(contactNoController.text.toString());
    var tempuserName =
        Validator.validateUserName(userNameController.text.toString());
    if (tempfName == "" && templName == "" && tempuserName == ""&& tempContactNo==''&& isValidUsername==true) {
      print("here is the value true $isValidUsername");
      allNames = true;
    } else {
      print("here is the value false");
      allNames = false;
    }
    update();
  }
  String isValidContactNo="";
validationMobileNo(){
  isValidContactNo =
  Validator.validateMobile(contactNoController.text.toString());

    update();
}
  cleanData() {
    fName = '';
    permissionDenied=false;
    lName = '';
    fcmToken='';
    isValidContactNo = '';
    userName = '';
    categoriesNames.clear();
    selectedCategoriesIndex = [];
    selectedCategoriesList = [];
    isLoading = false;
    isAddressSelected = false;
    selectedAddress = 'Search locations';
    usersCountry = '';
    update();
  }

  String accountType = "public";
  updateAccountType(bool flag) async {
    print("Here");
    isPrivateAccount = flag;
    if (flag) {
      accountType = "private";
    } else {
      accountType = "public";
    }
    Map<String, dynamic> map = {
      "accountType": isPrivateAccount,
    };
    var getDetails=await RemoteServices.fetchPutData("api/user/me", map);
    print("here is the getdials body :: ${getDetails.statusCode}");
    print("here is the getdials body :: ${getDetails.data}");
    print("here is the getdials body :: ${getDetails.errorMessage}");
    categoriesNames.clear();
    ApiClient.box.write("isPrivateAccount", flag);
    update();
  }


  bool permissionDenied = false;
var totalContacts=0;
var totalFetchContacts=0;
  List phoneNoList = [];
  List phoneName = [];

  Future checkPermission(context) async {
    permissionDenied=false;
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      permissionDenied = true;

      print("here is the condition permissionDenied $permissionDenied");
    }else{
     await fetchContacts(context);
    }
    update();
  }
  Future fetchContacts(context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => GetBuilder<AdditionalDetailsController>(
            init: AdditionalDetailsController(),
            builder: (controller) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                      16.0)),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Container(
                margin: EdgeInsets.only(
                    top: 3.5 *
                        SizeConfig
                            .widthMultiplier,
                    right: 2 *
                        SizeConfig
                            .widthMultiplier),
                color: backgroundDialogLoader,
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisSize:
                      MainAxisSize.min,
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .stretch,
                      children: <Widget>[
                        Center(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 2 *
                                      SizeConfig
                                          .widthMultiplier,
                                ),
                                // SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                                ColorLoader(),
                                // CustomRefreshIndicator(),
                                // SizedBox(width: 1  * SizeConfig.widthMultiplier,),
                                GetBuilder<AdditionalDetailsController>(
                                    init: AdditionalDetailsController(),

                                    builder: (controllert) {
                                      print("here is the value ${totalFetchContacts}");
                                      return CustText(
                                          name:
                                          "Fetching contacts...${totalFetchContacts}/${totalContacts}",
                                          size: 1.4,
                                          colors:
                                          Colors.white,
                                          textAlign:
                                          TextAlign
                                              .center,
                                          fontWeightName:
                                          FontWeight
                                              .w600);
                                    }
                                ),
                              ],
                            ) //
                        ),
                        SizedBox(
                            height: 4 *
                                SizeConfig
                                    .widthMultiplier),
                      ],
                    ),
                  ],
                ),
              ),
            )
        ));
    phoneNoList.clear();
    phoneName.clear();
    selectedItemList.clear();
    totalContacts=0;
    print("here is the condition permissionDenied 2 $permissionDenied");
    //  if(allRows.length == 0){
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      permissionDenied = true;
      print("here is the condition Checked $permissionDenied");
    }else {
      final contact = await FlutterContacts.getContacts();
      print("here is the condition else $permissionDenied");
      // contacts = contact;
      totalContacts=contact.length;
      for(int i =0; i<contact.length; i++){

        final fullContact = await FlutterContacts.getContact(contact![i].id);
        updateCount(i);

        for(int j =0; j<fullContact!.phones.length; j++){

          if(fullContact!.phones.isNotEmpty){
            var f1 = fullContact.phones[j].number.replaceAll(" ", "");
            var f2 = f1.replaceAll("-", "");
            var f3 = "${fullContact.name.first} ${fullContact.name.last}";

            if(f2.length ==10){
              phoneNoList.add(f2);
              phoneName.add(f3);
              selectedItemList.add(false);
            }else{
              phoneNoList.add(f2.replaceAll("+91", ""));
              phoneName.add(f3);
              selectedItemList.add(false);
            }
          }
        }

      }
    }
 print("Here is the length ${phoneNoList.length}");
 print("Here is the length ${phoneName.length}");
    update();
  }

  updateCount(count){
    totalFetchContacts=count;
    print("here is the current fetch contact $count} and total length ${totalContacts}");
    update();
  }
}
