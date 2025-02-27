import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wagl/home/home_page.dart';
import '../custom_widget/validator.dart';
import '../profile/profile_controller.dart';
import '../profile/profile_model.dart';
import '../services/remote_services.dart';
import '../util/ApiClient.dart';
import 'blockUserModelClass.dart';

class SettingController extends GetxController {
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var userNameController = TextEditingController();
  var locationNameController = TextEditingController();
  var bioTextController = TextEditingController();
  var oldPasswordController = TextEditingController();
  var newConfirmPassController = TextEditingController();
  var confirmPassController = TextEditingController();

  String fName = "", lName = "", userName = "";
  bool allNames = false;
  var selectedDay = 14;
  var selectedMonth = 10;
  var selectedYear = 2001;
  String dayValue = "DD";
  String monthValue = "MM";
  String yearValue = "YYYY";
  List selectedFollows = [];
  List contactNames = [];
  List selectedItemList = [];
  int daysInMonth = 31;

  @override
  void onInit() {
    // TODO: implement onInit
    // fetchNames();
    getProfileDetails();
    updateDaysInMonth();
    getBlockUserList();
    super.onInit();
  }

  bool isValidEmail = false;
  String confirmPassword = '';
  String validatePassword(String value, String value2) {
    print(value);
    if (value.isEmpty || value.isEmpty) {
      return 'Please enter password';
    } else if (value != value2) {
      return "The passwords do not match. Please try again.";
    } else {
      return '';
    }
  }
bool isAccountDelete=false;
  Future deleteAccount() async {
    var map= {"data": {
      "user_id": ApiClient.box.read("userId"),
    }};
    var getDetails = await RemoteServices.postMethodWithToken(
        'api/userProfileDelete',map);
    if (getDetails.statusCode == 200) {
      print("Here is${getDetails.data}");
      print("Here is${getDetails.statusCode}");
      isAccountDelete=true;
      print(
          "Failed to fetch data. Status code:Setting ${getDetails.statusCode}  ${getDetails.errorMessage} ${getDetails.data}");
      ApiClient.box.write('authToken', "");
      ApiClient.box.write('login', false);
    } else {
      isAccountDelete=false;
      print(
          "Failed to fetch data. Status code:Setting ${getDetails.statusCode}  ${getDetails.errorMessage} ${getDetails.data}");
    }
    update();
  }

  checkPassMatch() {
    var temppass = validatePassword(newConfirmPassController.text.toString(),
        confirmPassController.text.toString());

  }

  void updateDaysInMonth() {
    int month = selectedMonth;
    int year = selectedYear;
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

  checkText(email) {
    var temp = Validator.validateEmail(email);
    print("object $temp");
    var temppass = validatePassword(oldPasswordController.text.toString(),
        confirmPassController.text.toString());
    print("Object $temppass");
    if (temp == "" && temppass == "") {
      isValidEmail = true;
    } else {
      isValidEmail = false;
    }
    update();
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

  validationNames() {
    var tempfName = Validator.validateFName(firstNameController.text.toString());
    var templName = Validator.validateLName(lastNameController.text.toString());
    var tempuserName =
        Validator.validateUserName(userNameController.text.toString());
    if (tempfName == "" && templName == "" && tempuserName == "") {
      print("here is the value true");
      allNames = true;
    } else {
      print("here is the value false");
      allNames = false;
    }
    update();
  }

  List<Datum> blockUserList = [];

  Future getBlockUserList() async {
    var getDetails = await RemoteServices.fetchGetData(
        'api/block-users?filters[user_id][\$eq]=${ApiClient.box.read("userId")}&populate[block_id][populate]=profilePic');
    if (getDetails.statusCode == 200) {
      var apiDetails = blockUserModelClassFromJson(getDetails.body);
      blockUserList = apiDetails.data!;
      if (blockUserList.isNotEmpty) {
        print("${blockUserList.length}");
        print(
            "object::== ${blockUserList[0].attributes!.blockId!.data!.attributes!.username}\n\n Length ");
      }
      selectedFollows.clear();
      selectedItemList.clear();
      for (int i = 0; i < blockUserList.length; i++) {
        selectedFollows.add(false);
        selectedItemList.add(false);
      }
    } else {
      print("Failed to fetch data. Status code: ${getDetails.statusCode}");
    }
    update();
  }

  toggleSelection(int index, bool isSelected) async {
    print(" Heshe is the index$index,,,, \n $isSelected");
    selectedItemList[index] = isSelected;
    print((selectedItemList));

    update();
  }

  Future unBlockUser(blockerId) async {
    var getDetails =
        await RemoteServices.deleteData('api/block-users/$blockerId');
    print("here is the block user ${getDetails.statusCode}");
    print("here is the block user ${getDetails.data}");

    update();
  }

  updateFollows(int index, status) async {
    print("Here $status");
    selectedFollows[index] = status;
    int blockedUserId = blockUserList[index].id!;
    int blockUserId = blockUserList[index].attributes!.blockId!.data!.id!;
    if (status) {
      await unBlockUser(blockedUserId);
    } else {
      await blockUserApi(blockUserId);
    }

    update();
  }

  bool accountLinked = false;

  Future blockUserApi(int blockUserId) async {
    Map<String, dynamic> map = {
      "data": {
        "user_id": ApiClient.box.read("userId"),
        "block_id": blockUserId,
      }
    };

    print("print the map ${map}");
    // var getDetails = await RemoteServices.postMethodWithToken('api/report-wagls', waglData);
    var getDetails =
        await RemoteServices.postMethodWithToken('api/block-users', map);
    print("here is the wagl Report Brfore ");
    if (getDetails.statusCode == 200) {
      print("here is the wagl Report ${getDetails.statusCode}");
    } else {
      print("here is the wagl Report ${getDetails.statusCode}");
    }
    ;

    update();
  }

  updateLinkedAccount(flag) {
    accountLinked = flag;
    update();
  }

  String accountType = "private";

  updateAccountType(bool flag) async {
    isPrivateAccount = flag;
    if (flag) {
      accountType = "private";
    } else {
      accountType = "public";
    }
    update();
    print("here is the accountType :: $accountType");
    ApiClient.box.write("isPrivateAccount",flag);
    Map<String, dynamic> map = {
       "accountType": accountType,
    };
   var getDetails=await RemoteServices.fetchPutData("api/user/me", map);
    print("here is the getdials body :: ${getDetails.statusCode}");
    print("here is the getdials body :: ${getDetails.data}");
    print("here is the getdials body :: ${getDetails.errorMessage}");

    update();
  }

  String gender = "Please Select";
  String pronouns = "Please Select";
  late ProfileDetailsModel profileDetails;

  Future getProfileDetails() async {
    var getDetails = await RemoteServices.fetchGetData(
        'api/users/${ApiClient.box.read("userId")}/?populate=*');
    if (getDetails.statusCode == 200) {
      print("Here is${getDetails.body}");
      var apiDetails = profileDetailsFromJson(getDetails.body);
      profileDetails = apiDetails;
      print("Here is${apiDetails.pushNotification}");
      List<String> dateParts = profileDetails.dateOfBirth.split('-');
      // Assign each part to its respective variable

      // int year = int.parse(dateParts[0]);
      // int month = int.parse(dateParts[1]);
      // int day = int.parse(dateParts[2]);

      firstNameController.text = profileDetails.firstName;
      lastNameController.text = profileDetails.lastName;
      userNameController.text = profileDetails.username.toString();
      locationNameController.text = profileDetails.location.toString();
      bioTextController.text = profileDetails.bio.toString();
      gender = profileDetails.gender;
      accountType = profileDetails.accountType;
      pronouns = profileDetails.pronouns;
      selectedYear = int.parse(dateParts[0]);
      selectedMonth = int.parse(dateParts[1]);
      selectedDay = int.parse(dateParts[2]);
    } else {
      print(
          "Failed to fetch data. Status code:Setting${getDetails.statusCode}");
    }
    update();
  }

  bool isPrivateAccount = ApiClient.box.read("isPrivateAccount") ?? false;
  bool updatedStatus = false;

  Future updateUserDetails() async {
    String date =
        ApiClient.formatDate(selectedYear, selectedMonth, selectedDay);
    print("${selectedYear}-${selectedMonth}-${selectedDay}");
    print("$date");
    var headers = {
      'Authorization': 'Bearer ${ApiClient.box.read("authToken")}'
    };
    var request = http.MultipartRequest(
        'PUT', Uri.parse('${RemoteServices.baseUrl}api/user/me'));
    request.fields.addAll({
      'dateOfBirth': date,
      'firstName': firstNameController.text.toString(),
      "lastName": lastNameController.text.toString(),
      "username": userNameController.text.toString(),
      "location": locationNameController.text.toString(),
      'searchable_location': profileDetails.location.toString(),
      "accountType": accountType,
      'gender': gender,
      'pronouns': pronouns,
      'bio': bioTextController.text.toString(),
      // 'accountType': "2",
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      updatedStatus = true;
    } else {
      updatedStatus = false;
      print(response.reasonPhrase);
      print("response.reasonPhrase ::::::::::: ${response.statusCode}");
    }
    var profileController = Get.put(ProfileController());
    profileController.getProfileDetails(0);
    profileController.update();
    homeController.update();
    update();
  }


  updateFollowers() async {
    var headers = {
      'Authorization': 'Bearer ${ApiClient.box.read("authToken")}'
    };
    var request = http.Request(
        'POST', Uri.parse('${RemoteServices.baseUrl}api/follower-lists'));

    var body = {
      "data": {"userID": 48, "followersID": 7}
    };
    request.body = json.encode(body);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print("object${response.stream}");
    } else {
      print(response.reasonPhrase);
    }

    update();
  }



  Future updateFcmToken() async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiClient.box.read("authToken")}'
      };
      var request = http.Request(
          'POST', Uri.parse('${RemoteServices.baseUrl}api/auth/local/fcm'));
      request.body = json.encode({"token": ""});

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        print("${RemoteServices.baseUrl}api/auth/local/fcm}");
      } else {
        print(await response.stream.bytesToString());
      }
    } catch (e) {
      print("e");
    }
    update();
  }

  clearData() {
    update();
  }

  validation() {
    confirmPassword = validatePassword(newConfirmPassController.text.toString(),
        confirmPassController.text.toString());
    update();
  }

  Future updateOldPass() async {
    Map<String, dynamic> passMap = {
      "data": {
        "user_id": ApiClient.box.read("userId"),
        "old_password": oldPasswordController.text.toString(),
        "new_password": confirmPassController.text.toString(),

      }
    };

    var getDetails = await RemoteServices.postMethodWithToken(
        'api/updatePassword', passMap);
    if(getDetails.statusCode==200){
      print("here is the updated password ");
      updatedStatus=true;
    }
    else if(getDetails.statusCode==400){
      updatedStatus=false;
      print("Here ===>> ${getDetails.statusCode} \n\n ${getDetails.data} \n\n ${getDetails.errorMessage}");
      print("here is the updated password ");
    }
    else{
      print("Here ===>> ${getDetails.statusCode} \n\n ${getDetails.data} \n\n ${getDetails.errorMessage}");
    }
    update();
  }
}
