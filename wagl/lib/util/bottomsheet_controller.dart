import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class BottomSheetController extends GetxController{

 var flagList = [true,false,false,false,false];

  void handelFlag(flag) async{
    for(int i = 0; i<flagList.length; i++ ){
      if(i == flag){
        flagList[i] = true;
      }else{
        flagList[i] = false;
      }
      update();
    }
  }
}
