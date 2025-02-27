
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:wagl/home/home_page.dart';
import 'package:wagl/login/login_view.dart';
import 'package:wagl/onbroading/onbroading_view.dart';
import 'package:wagl/profile/profile_controller.dart';
import 'package:wagl/register/about_you.dart';
import 'package:wagl/register/additional_details_view.dart';
import 'package:wagl/register/categories_view.dart';
import 'package:wagl/register/friends_follow_view.dart';
import 'firebase_options.dart';
import 'login/login_controller.dart';
import 'util/ApiClient.dart';
import 'util/SizeConfig.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

// Future<void> backgroundHandler(RemoteMessage message) async {
//   LocalNotificationService.handleNotification(message);
// }

late AndroidNotificationChannel channel;
// late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin2;
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future<void> main() async {
  // Application main method entry points.
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp,]);
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]); // To turn of
  await GetStorage.init();

  print("Tokenvalue::${ApiClient.box.read("authToken")}");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );
  final InitializationSettings initializationSettings = const InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your_channel_id', // channel ID
            'your_channel_name', // channel name
            // 'your_channel_description', // channel description
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  });
  if (!kIsWeb) {
    print('This channel is used for important notifications.');
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Wagl',
              theme: ThemeData.dark(),
              // initialRoute: ApiClient.box.read('login') == null?RouteName.getLoginRoute():ApiClient.box.read('login')?RouteName.getHomeView():RouteName.getLoginRoute(),
              // getPages:RouteName.routes,
              home: getPage(),
              // home: const Login(),
              // getPages:AppRoutes.appRoutes(),
            );
          },
        );
      },
    );
  }

  // Handel application component.login status.
  getPage() {
    try {
      if (ApiClient.box.read('onBroading') == null || ApiClient.box.read('onBroading') == false) {
        (ApiClient.box.write('onBroading',true));
        return OnbroadingView();
      } else if (ApiClient.box.read('login') == true) {
        // return AdditionalDetailsView(); //Dashboard();
        // return FollowFriendView();     /// OnbroadingView Screen.
        // homeController.getAllWagls();
        // return RegisterAboutView();
        return MyHomePage(); //Dashboard();
      } else {
        print("LOGOUTTEDD:::${ApiClient.box.read('login')}");
        // return OnbroadingView();    // OnbroadingView Screen..
        // return FollowFriendView(); //Dashboard();
        var loginController = Get.put(LoginController());
        loginController.getFcmToken();
        return LoginView();
      }
    } catch (e) {
      // return FollowFriendView();     /// OnbroadingView Screen..
      var loginController = Get.put(LoginController());
      loginController.getFcmToken();
      return LoginView();
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
