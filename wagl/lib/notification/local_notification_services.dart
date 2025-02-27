import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;


class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future initTimeZones() async {
    tz.initializeTimeZones();
    // final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    //  tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }
  static Future initialize() async {



    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {});

    InitializationSettings initializationSettings =
    InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: initializationSettingsDarwin,
    );

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

    // Initialize FlutterLocalNotificationsPlugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: (details) => null,
      onDidReceiveNotificationResponse: (details) => null,
    );
  }


  static  Future<void> repeatNotification() async {

    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'repeating channel id', 'repeating channel name',
        channelDescription: 'repeating description');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      12,
      'repeating title',
      'repeating body',
      RepeatInterval.everyMinute,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }


  static void createAndDisplayNotification(
      RemoteMessage message, bool notifyButton) async {
    try {
      print("${message.notification?.title}");
      print("${message.notification?.body}");
      print(
          "Here is the channel ID ${message.notification?.android?.channelId}");
      print("Here is the Sound ${message.notification?.android?.sound}");



      final id = DateTime.now().millisecondsSinceEpoch / 1000;
      AndroidNotificationChannel channel = AndroidNotificationChannel(
        'Vibin',
        'Vibin',
        importance: Importance.max,
        showBadge: true,
        description: "Vibin Application",
        enableLights: true,
        playSound: true,
        enableVibration: true,
      );
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "high_importance_channel_0",
          "Sound",
          channelDescription: "Your channel Description 123",
          importance: Importance.max,
          priority: Priority.high,
          autoCancel: true,
          enableLights: true,
          playSound: true,
          enableVibration: true,
        ),
        //  iOS: IOSNotificationDetails(),
      );
    /*  NotificationDetails notificationDetailWithButtons = NotificationDetails(
        android: AndroidNotificationDetails(
          soundBool && vibrateBool
              ? "high_importance_channel_0"
              : soundBool == false && vibrateBool
              ? "high_importance_channel_1"
              : "high_importance_channel_2",
          soundBool && vibrateBool
              ? "Sound"
              : soundBool == false && vibrateBool
              ? "Vibrate"
              : "Mute",
          channelDescription: "Your channel Description 123",
          importance: Importance.max,
          priority: Priority.high,
          actions: [
            const AndroidNotificationAction(
              'accept',
              'Sure',
              cancelNotification: true,
            ),
            const AndroidNotificationAction(
              'decline',
              'May be Next Time',
              cancelNotification: true,
            ),
          ],
          autoCancel: true,
          enableLights: true,
          playSound: soundBool,
          enableVibration: vibrateBool,
        ),
        // iOS: IOSNotificationDetails(),
      );*/
      await flutterLocalNotificationsPlugin.show(
        id.toInt(),
        message.notification?.title.toString(),
        message.notification?.body.toString(),
        /*notifyButton ? notificationDetailWithButtons :*/ notificationDetails,
      );

      const InitializationSettings initializationSettings =
      InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
        // iOS: IOSInitializationSettings(),
      );
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
          handleNotification(message);
      /*    print("object data ${message.data["service"]}");
          var vibrateFile = await StorageHelper.readFromFile("VibrateFile");
          String selectedpayload = response.payload ?? '';
          String selectedAction = response.actionId ?? '';
          print("Here is the Value ${selectedAction}");

          switch (selectedAction) {
            case 'ACCEPT_ACTION':
            // Perform an API call or any other operation for accept action
              print("{ await performAcceptAction();}");
              break;
            case 'REJECT_ACTION':
            // Perform an API call or any other operation for reject action
              print("{ await REJECT_ACTION();}");
              break;
            default:
            // Handle other actions or default behavior
              break;
          }*/

          if (message.notification?.title == "Meeting") {
            print("HERE IS THE ON TAB NOTIFICATION");
            //await meetUpController.readFile(meetUpController.upcomingMeets[i].mediaPath,meetUpController.upcomingMeets[i].meetId);
          }
        },
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future<void> handleNotification(RemoteMessage message) async {
    log("Here is the navigation ");
    print("${message.data.toString()}");
   /* switch (message.data["service"]) {
      case "circle":
        log("here is the switch");
        Get.offAll(() =>NavigationDrawerMenu());
        var homecontroller = Get.put(HomeController());
        // homecontroller.isMeetUPFlag = false;
        homecontroller.isMeetUPFlag = true;
        homecontroller.isCircleFlag = true;
        await Get.put(HomePageView1());
        print("Navigated to circle ");
        break;
      case "create meetup":
      // var meetUpController = Get.put(MeetUpController());
        print(
            "HERE IS THE NOTIFICATION MEETING ID ::${message.data["meet_id"]}");
        int meetingID = int.parse(message.data["meet_id"]);
        var invitesHistoryController = Get.put(InvitesHistoryController());
        Get.offAll(() =>NavigationDrawerMenu());
        var homeController = Get.put(HomeController());
        homeController.isMeetUPFlag = true;
        homeController.isCircleFlag = false;
        var meetUpController = Get.put(MeetUpController());
        await meetUpController.getUpcomingMeetUp();
        print(
            "HERE are the details ::${jsonEncode(meetUpController.upcomingMeets.length)}");
        for (int i = 0; i < meetUpController.meetInvites.length; i++) {
          print(
              "HERE IS THE MEET ID${meetUpController.meetInvites[i].meetId}\n");
          if (meetUpController.meetInvites[i].meetId == meetingID) {
            print("meeting id =$meetingID");
            await meetUpController.readFile(meetUpController.meetInvites[i].mediaThumb,meetUpController.meetInvites[i].placeImg);
            meetUpController.getUserName(meetUpController.meetInvites[i]);
            await meetUpController.readProfileDada(meetUpController.meetInvites[1].meetupUsers);
            Get.to(() =>MeetInvitesDetails(i),
                transition: Transition.fade,
                duration: const Duration(seconds: 1));
          } else {}
        }
      case "invite meetup":
      // var meetUpController = Get.put(MeetUpController());
        print(
            "HERE IS THE NOTIFICATION MEETING ID ::${message.data["meet_id"]}");
        int meetingID = int.parse(message.data["meet_id"]);
        Get.offAll(() =>NavigationDrawerMenu());
        var homeController = Get.put(HomeController());
        homeController.isMeetUPFlag = true;
        homeController.isCircleFlag = false;
        var meetUpController = Get.put(MeetUpController());
        await meetUpController.getUpcomingMeetUp();
        print(
            "HERE are the details ::${jsonEncode(meetUpController.upcomingMeets.length)}");
        for (int i = 0; i < meetUpController.meetInvites.length; i++) {
          print(
              "HERE IS THE MEET ID${meetUpController.meetInvites[i].meetId}\n");
          if (meetUpController.meetInvites[i].meetId == meetingID) {
            print(
                "asd${meetUpController.meetInvites[i].meetId} and here is $meetingID");
            await meetUpController.readFile(meetUpController.meetInvites[i].mediaThumb,meetUpController.meetInvites[i].placeImg);
            meetUpController.getUserName(meetUpController.meetInvites[i]);
            await meetUpController.readProfileDada(meetUpController.meetInvites[1].meetupUsers);
            Get.to(() =>MeetInvitesDetails(i),
                transition: Transition.fade,
                duration: const Duration(seconds: 1));
          } else {}
        }
        break;
      case "update meetup":
        print(
            "HERE IS THE NOTIFICATION MEETING ID ::${message.data["meet_id"]}");
        int meetingID = int.parse(message.data["meet_id"]);
        Get.to(() =>NavigationDrawerMenu());
        var homeController = Get.put(HomeController());
        homeController.isMeetUPFlag = true;
        homeController.isCircleFlag = false;
        var invitesHistoryController = Get.put(InvitesHistoryController());
        var date = DateTime.now();
        final result =
        await invitesHistoryController.getMeetList(meetingID, "", "", 0);
        await invitesHistoryController.readProfileDada(invitesHistoryController.meetDetails[0].meetupUsers);
        Get.to(() =>
            HistoryInvitesDetails(
                "${DateTime(date.year, date.month - 3, date.day)}"
                    .substring(0, 10),
                "${DateTime(date.year, date.month + 3, date.day)}"
                    .substring(0, 10)),
            transition: Transition.fade,
            duration: const Duration(seconds: 1));
        print("HERE are the details :");

        // if (foundIndex != null) {
        //   meetUpController
        //       .getUserName(meetUpController.upcomingMeets[foundIndex]);
        //   print("Going to navigate::${meetUpController
        // .getUserName(meetUpController.upcomingMeets[foundIndex].description)}");
        //   Get.to(MeetInvitesDetails(foundIndex),
        //       transition: Transition.fade,
        //       duration: const Duration(seconds: 1));
        // }
        *//* for (int i = 0; i < meetUpController.upcomingMeets.length; i++) {
                print(
                    "HERE IS THE MEET ID${meetUpController.upcomingMeets[i].meetId}\n");
                if (meetUpController.upcomingMeets[i].meetId == meetingID) {
                  meetUpController
                      .getUserName(meetUpController.upcomingMeets[i]);
                  Get.to(MeetUpDetails(i),
                      transition: Transition.fade,
                      duration: const Duration(milliseconds: 400));
                } else {}
              }*//*

        break;
      case "cancel meetup":
        print(
            "HERE IS THE NOTIFICATION MEETING ID ::${message.data["meet_id"]}");
        int meetingID = int.parse(message.data["meet_id"]);
        var invitesHistoryController = Get.put(InvitesHistoryController());
        Get.to(() =>NavigationDrawerMenu());
        var homeController = Get.put(HomeController());
        homeController.isMeetUPFlag = true;
        homeController.isCircleFlag = false;
        var meetUpController = Get.put(MeetUpController());
        await meetUpController.getUpcomingMeetUp();
        print(
            "HERE are the details ::${jsonEncode(meetUpController.upcomingMeets.length)}");
        for (int i = 0; i < meetUpController.upcomingMeets.length; i++) {
          print(
              "HERE IS THE MEET ID${meetUpController.upcomingMeets[i].meetId}\n");
          if (meetUpController.upcomingMeets[i].meetId == meetingID) {
            await meetUpController.readFile(meetUpController.upcomingMeets[i].mediaThumb,meetUpController.upcomingMeets[i].placeImg);
            meetUpController.getUserName(meetUpController.upcomingMeets[i]);
            Get.to(() =>MeetUpDetails(i),
                transition: Transition.fade,
                duration: const Duration(seconds: 1));
          } else {}
        }
        break;
      case "meetup status":
      // var meetUpController = Get.put(MeetUpController());
        int meetingID = int.parse(message.data["meet_id"]);
        Get.to(() =>NavigationDrawerMenu());
        var homeController = Get.put(HomeController());
        homeController.isMeetUPFlag = true;
        homeController.isCircleFlag = false;
        var meetUpController = Get.put(MeetUpController());
        await meetUpController.getUpcomingMeetUp();
        for (int i = 0; i < meetUpController.meetInvites.length; i++) {
          if (meetUpController.meetInvites[i].meetId == meetingID) {
            await meetUpController.readFile(meetUpController.meetInvites[i].mediaThumb,meetUpController.meetInvites[i].placeImg);
            meetUpController.getUserName(meetUpController.meetInvites[i]);
            await meetUpController.readProfileDada(meetUpController.meetInvites[1].meetupUsers);

            Get.to(() =>MeetInvitesDetails(i),
                transition: Transition.fade,
                duration: const Duration(seconds: 1));
          } else {}
        }
        break;
      default:
        Get.offAll(() =>NavigationDrawerMenu());
        var homecontroller = Get.put(HomeController());
        homecontroller.isMeetUPFlag = true;
        homecontroller.isCircleFlag = false;
        Get.put(HomePageView1());
        break;
    }*/
  }
//   Future<void> setupInteractMessage() async {
// RemoteMessage? intitalMessage = await
//   }


  static Future<void> showSimpleNotification({
    required int id,
    required String title,
    required String body,
    required String payload
  })async{
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        icon: "@mipmap/ic_launcher",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true);
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id, title, body, notificationDetails,
        payload: payload);
  }

  static Future<void> showSimpleNotificationCustomSound({
    required String title,
    required String body,
    required String payload
  })async{
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id sound', 'default_notification_channel_ida',
      channelDescription: 'your channel description sound',
      icon: "@mipmap/ic_launcher",
      playSound: true,
      sound: RawResourceAndroidNotificationSound('pingsound'),
      importance: Importance.max,
      priority: Priority.high,
//  playSound: true
    );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails,iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        10, title, body, notificationDetails,
        payload: payload);
  }

  static Future showPriorityNotification({
    required String title,
    required String body,
    required String payload,
    required int id,
    required Duration nTime
  })async{

    print("showPriorityNotification Call");
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        icon: "@mipmap/ic_launcher",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true);

    var iosDetails = const DarwinNotificationDetails();

    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails, iOS: iosDetails);

    tz.initializeTimeZones();
    //  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    //  tz.setLocalLocation(tz.getLocation(timeZoneName!));

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(nTime), // Duration(seconds : 10)
        notificationDetails,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);


/*
  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title??''),
        content: Text(body??''),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecondScreen(payload),
                ),
              );
            },
          )
        ],
      ),
    );
  }


  */
  }}
