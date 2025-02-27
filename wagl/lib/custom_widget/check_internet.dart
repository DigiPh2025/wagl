import 'dart:io';

import 'package:flutter/material.dart';

import 'colorsC.dart';
import 'cust_text.dart';

class CheckInternet {
  static Future<bool> checkInternet()  async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
      }else{
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
class ConnectionChecker {
  static Future<void> checkConnection({
    required BuildContext context,
    required VoidCallback onConnected,
  }) async {
    if (await CheckInternet.checkInternet()) {
      // Executes the callback function if there's internet
      onConnected();
    } else {
      // Displays the snackbar if there's no internet
      var snackdemo = SnackBar(
        content: CustText(
          name: "Please check your internet connection",
          size: 1.4,
          colors: colorBlack,
          fontWeightName: FontWeight.w600,
        ),
        backgroundColor: colorPrimary,
        elevation: 10,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(5),
        shape: BeveledRectangleBorder(),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackdemo);
    }
  }
}