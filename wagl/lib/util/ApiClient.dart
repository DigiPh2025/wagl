import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../home/all_wagl_model.dart';
import '../profile/saved_wagl_model.dart';

class ApiClient {
  // Google Map Key  AIzaSyCOGis4giHCz4aAEkFfOH5UaDlISRP9i4s

  static int drawerFlag = 0;
  static final box = GetStorage();

  static String splitDate(dateT) {
    final moonLanding = DateTime.parse(dateT);

    return "${moonLanding.day} ${DateFormat.MMM().format(moonLanding)} ${moonLanding.year}";
  }

  static String convertDate(dateT) {
    final moonLanding = DateTime.parse(dateT);
    return "${moonLanding.day} ${DateFormat.MMM().format(moonLanding)} ${moonLanding.year}";
  }

  static String convertTime(dateT) {
    // print(" ChatMeetList ========= $dateT");

    var moonLanding1 = DateTime.parse(dateT);
    var moonLanding = moonLanding1.add(Duration(seconds: 1));

    print(" ChatMeetList ========= $moonLanding");
    return DateFormat("hh:mm a").format(moonLanding);
  }

  static bool checkBalance(balance) {
    int amount = int.parse(balance.toString());
    if (amount >= 100) {
      return false;
    } else {
      return true;
    }
  }



  static popUpView(
      context, String title, Color bgColor, Color borderColor, var icon) {
    Flushbar(
      backgroundColor: bgColor,
      message: title,
      borderColor: borderColor,
      duration: Duration(seconds: 3),
      borderRadius: BorderRadius.circular(100),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      icon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: icon,
      ),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  static twoDateDifference(fromDate, toDate) {
    print("fromDate : $fromDate");
    print("toDate : $toDate");

    var todayDate = DateTime.now();
    todayDate = todayDate.add(Duration(seconds: 2));
    // final todayDate = DateTime.parse("${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} 00:00:00.000");

    Duration diff = fromDate.difference(todayDate);
    if (DateFormat("dd").format(fromDate) ==
        DateFormat("dd").format(DateTime.now())) {
      Duration dif = fromDate.difference(toDate);
      if (DateFormat("dd").format(fromDate) ==
          DateFormat("dd").format(toDate)) {
        return "Today ${DateFormat("hh:mm a").format(fromDate)} - ${DateFormat("hh:mm a").format(toDate)}";
      } else {
        return "Today ${DateFormat("hh:mm a").format(fromDate)} - ${toDate.day} ${DateFormat.MMM().format(toDate)} ${fromDate.year} ${DateFormat("hh:mm a").format(toDate)}";
      }
    } else if (diff.inDays == 1) {
      Duration dif = fromDate.difference(toDate);
      print("toDate  ====== : ${dif.inDays}");
      if (DateFormat("dd").format(fromDate) ==
          DateFormat("dd").format(toDate)) {
        return "Tomorrow ${DateFormat("hh:mm a").format(fromDate)} - ${DateFormat("hh:mm a").format(toDate)}";
      } else {
        return "Tomorrow ${DateFormat("hh:mm a").format(fromDate)} - ${toDate.day} ${DateFormat.MMM().format(toDate)} ${fromDate.year} ${DateFormat("hh:mm a").format(toDate)}";
      }
    } else {
      return "${fromDate.day} ${DateFormat.MMM().format(fromDate)} ${fromDate.year} ${DateFormat("hh:mm a").format(fromDate)} - ${toDate.day} ${DateFormat.MMM().format(toDate)} ${toDate.year} ${DateFormat("hh:mm a").format(toDate)}";
    }
  }

  static dateDifference(fromDate, num) {
    print(fromDate);
    print(DateTime.now());

    var todayDate = DateTime.now();
    todayDate = todayDate.add(Duration(seconds: 1));

    Duration diff = fromDate.difference(todayDate);

    print(diff.inMinutes);

    if (num == 1) {
      return diff.inDays;
    } else if (num == 2) {
      return diff.inHours % 24;
    } else if (num == 3) {
      return diff.inMinutes % 60;
    } else {
      return diff.inSeconds % 60;
    }
  }

  static selectedDateDifference(fromDate) {
    print("fromDate :: fromDate ::  Temp $fromDate");

    var todayDate = DateTime.now();
    todayDate = todayDate.add(Duration(seconds: 1));
    Duration diff = fromDate.difference(todayDate);
    if (diff.inDays == 0) {
      return fromDate;
    } else {
      print(
          "fromDate :: fromDate ::  ${DateFormat("yyyy-mm-dd").format(fromDate)} 00:00:00.000");
      return fromDate; // DateTime.parse("${DateFormat("yyyy-mm-dd").format(fromDate)} 00:00:00.000");
    }
  }

  static selectedTwoDateDifference(fromDate, toDate) {
    if (DateFormat("dd").format(fromDate) == DateFormat("dd").format(toDate)) {
      print("=============  True");
      return true;
    } else {
      print("=============  false");
      return false;
    }
  }

  static String formatNumber(int num) {
    if (num >= 1000000) {
      return (num / 1000000).toStringAsFixed(1).replaceAll('.0', '') + 'M';
    } else if (num >= 1000) {
      return (num / 1000).toStringAsFixed(1).replaceAll('.0', '') + 'K';
    } else {
      return num.toString();
    }
  }

  static bool checkImageCount(
       dataWagl, index) {
    int jpgCount = 0;
    for (int i = 0; i < dataWagl[index].attributes!.media!.data!.length; i++) {

      // print("${dataWagl![index].attributes!.media!.data![i].attributesMedia!.ext}");
      String ext =
      dataWagl[index].attributes!.media!.data![i].attributesMedia!.ext!;

      if (ext == ".png" || ext == ".jpg" || ext == ".jpeg") {
        jpgCount++;
      }

    }
    if (jpgCount >= 1) {
      return true;
    } else {
      return false;
    }
  }
  static bool checkImageCountSaved(
      List<SavedData> dataWagl, index) {
    int jpgCount = 0;
    // print("object checkImageCount$jpgCount");
    for (int i = 0; i < dataWagl[index].attributes!.waglId!.data!.attributes!.media!.data!.length; i++) {
      // print(
      //     "count ==$i ${dataWagl[index].attributes!.waglId!.data!.attributes!.media!.data![i].attributes!.ext}");
      // print("${dataWagl![index].attributes!.media!.data![i].attributesMedia!.ext}");
      String ext =
      dataWagl[index].attributes!.waglId!.data!.attributes!.media!.data![i].attributes!.ext!;

      if (ext == ".png" || ext == ".jpg" || ext == ".jpeg") {
        jpgCount++;
      }
      else{
        print("$ext");
      }

    }
    if (jpgCount >= 1) {
      return true;
    } else {
      return false;
    }
  }
  static bool checkVideoCountSaved( List<SavedData> dataWagl, index) {
    int mp4Count = 0;
    // print("object checkVideoCount$index");
    for (int i = 0; i < dataWagl[index].attributes!.waglId!.data!.attributes!.media!.data!.length; i++) {
      // print(
      //     "count ==$i ${dataWagl[index].attributes!.waglId!.data!.attributes!.media!.data![i].attributes!.ext}");
      // print("${dataWagl![index].attributes!.media!.data![i].attributesMedia!.ext}");
      String ext =
      dataWagl[index].attributes!.waglId!.data!.attributes!.media!.data![i].attributes!.ext!;
      if (ext == ".mp4"||ext == ".mov"||ext == ".hevc"||ext == ".mkv") {
        mp4Count++;
      }
      else{
        print("$ext");
      }
    }
    if (mp4Count >= 1) {

      return true;
    } else {
      return false;
    }
  }
  static bool checkVideoCount(  dataWagl, index) {
    int mp4Count = 0;
    for (int i = 0; i < dataWagl[index].attributes!.media!.data!.length; i++) {
      // print("${dataWagl![index].attributes!.media!.data![i].attributesMedia!.ext}");
      String ext =
      dataWagl[index].attributes!.media!.data![i].attributesMedia!.ext!;
      if (ext == ".mp4"||ext == ".hevc"||ext == ".mov"||ext == ".mkv") {
        mp4Count++;
      }
    }
    if (mp4Count >= 1) {

      return true;
    } else {
      return false;
    }
  }

  static sTwoDateDifference(fromDate, toDate) {
    Duration diff = DateTime.parse(toDate).difference(DateTime.parse(fromDate));
    print("=============  ${diff.inDays}");
    return diff.inDays;
  }

  static twoHoursDifference(startTime) {
    var todayDate = DateTime.now();
    todayDate = todayDate.add(Duration(seconds: 1));

    print("startTime =  $startTime");
    print("startTime =  $todayDate");

    Duration diff = startTime.difference(todayDate);
    print("startTime =============  ${diff.inMinutes}");
    return diff.inMinutes;
  }

  static compareTwoTime(fromDate, toDate) {
    if (fromDate.compareTo(toDate) < 0) {
      print("== compareTwoTime  True");
      return false;
    } else {
      print("== compareTwoTime  false");
      return true;
    }
  }

  static getColors(cl) {
    if (cl != null) {
      String valueString = cl.split('(0x')[1].split(')')[0]; // kind of hacky..
      int value = int.parse(valueString, radix: 16);
      Color otherColor = new Color(value);
      return otherColor;
    } else {
      return null;
    }
  }
 static  String timeAgoConversion(DateTime dateTime) {

    final currentTime = DateTime.now();
    final difference = currentTime.difference(dateTime);

    if (difference.inMinutes < 1) {
      return "just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else {
      return "${difference.inDays} days ago";
    }
  }
  static stringDateFormat(stringDate) {
    List<String> substrings = stringDate.split("-");
    print("substrings  : $substrings");
    //DateTime.parse('10-10-2001 00:00:00')

    return "${substrings[2]}-${substrings[1]}-${substrings[0]}";
  }

  static String formatDate(int year, int month, int day) {
    // Ensure the month and day have two digits
    String formattedMonth = month.toString().padLeft(2, '0');
    String formattedDay = day.toString().padLeft(2, '0');

    // Combine into YYYY-MM-DD format
    return '$year-$formattedMonth-$formattedDay';
  }

  static stringDateFormatT(strDate) {
    var stringDate = strDate.substring(0, 10);
    List<String> substrings = stringDate.split("-");
    print("substrings  : $substrings");
    //DateTime.parse('10-10-2001 00:00:00')

    return "${substrings[2]}-${substrings[1]}-${substrings[0]}";
  }

  static bool stringToBool(String stringValue) {
    if (stringValue.toLowerCase() == "true") {
      return true;
    } else if (stringValue.toLowerCase() == "false") {
      return false;
    } else {
      // Handle other cases if needed
      print("Invalid input: $stringValue");
      // Return a default value or throw an error, depending on your requirements
      return true; // Defaulting to false for unknown inputs
    }
  }
}
