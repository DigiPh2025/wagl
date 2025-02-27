import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wagl/onbroading/welcomeModelClass.dart';
import '../custom_widget/Strings.dart';
import '../services/remote_services.dart';

class OnbroadingController extends GetxController {
  late PageController pageViewController;
  var currentPageIndex = 0;
  var welcomePageCount = 0;

  @override
  void onInit() {
    // TODO: implement onInit
    pageViewController = PageController();
    getTitles();
    super.onInit();
  }

  @override
  void dispose() {
    pageViewController.dispose();
    print("here dispose");
    super.dispose();
  }

  void handlePageViewChanged(int currentIndex) {
    currentPageIndex = currentIndex;
    update();
  }
bool isLoading=true;
   late WelcomeModel welcomeModel;
  Future getTitles() async {
    var getDetails =
    await RemoteServices.fetchGetDataWithoutToken('api/welcome-details?sort=id:Asc');
    if (getDetails.statusCode == 200) {
      var apiDetails = getWelcomeModelFromJson(getDetails.body);

      print("API Details: $apiDetails");
      print("API Details: ${getDetails.body}");
      welcomeModel = apiDetails;
      isLoading=false;
      if (welcomeModel.dataFields.isNotEmpty) {
        print("HERE ${welcomeModel.dataFields[0].attributes!.description}");
        welcomePageCount=welcomeModel.dataFields.length;
      } else {
        print("dataFields list is empty");
      }
    } else {
      print("Failed to fetch data. Status code: onBroading${getDetails.statusCode}");
    }
    update();
  }

  void updateCurrentPageIndex(int index) {
    pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    print("asdasda $index");
    print("asdasda $currentPageIndex");
    update();
  }
}
