import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wagl/login/loginModel.dart';

import '../custom_widget/validator.dart';
import '../notification/local_notification_services.dart';
import '../services/remote_services.dart';
import '../util/ApiClient.dart';

class LoginController extends GetxController {
  String userEmail = '';
  String userPassword = '';
  String resetUserPassword = '';
  var msg;
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var resetUserController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(
      5, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(5, (index) => FocusNode());
  bool isMailSend = false,
      isValidEmail = false,
      isValidPass = false,
      isVerified = false,
      isValidEmailPass = false;

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  User? user;

  @override
  void onInit() {
    // TODO: implement onInit
    cleanData();
    getFcmToken();
    signOut();
    super.onInit();
  }

  String confirmOtp = "";

  String getOtp() {
    return otpControllers.map((controller) => controller.text).join();
  }

  void updateOtp(String value, int index) {
    if (value.isNotEmpty && index < 4) {
      // Move to the next field
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      // Move to the previous field on backspace
      focusNodes[index - 1].requestFocus();
    }
    confirmOtp = getOtp();
    print("here is the otp $confirmOtp");
    update();
  }

  @override
  void dispose() {
    otpControllers.forEach((controller) => controller.dispose());
    focusNodes.forEach((node) => node.dispose());
    super.dispose();
  }

  Future<UserCredential> signInWithFacebook() async {
    print("here is login faccebook faccebook");
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      print("here we are ${loginResult}");
      print("here we are ${loginResult.message}");
      if (loginResult.status == LoginStatus.success) {
        final AccessToken accessToken = loginResult.accessToken!;
        final OAuthCredential credential =
        FacebookAuthProvider.credential(accessToken.tokenString);
        print("here is login faccebook $accessToken");
        final userData = await FacebookAuth.instance.getUserData();
        print("here is login credential $credential");
        print("here is login userData $userData");
        return await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        throw FirebaseAuthException(
          code: 'Facebook Login Failed',
          message: 'The Facebook login was not successful.',
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication exceptions
      print('Firebase Auth Exception: ${e.message}');
      throw e; // rethrow the exception
    } catch (e) {
      // Handle other exceptions
      print('Other Exception: $e');
      rethrow; // rethrow the exception
      // return e;
    }
  }

  String errorMessage = "";

  sendResetMail(bool status) async {
    Map<String, dynamic> emailMap = {
      "data": {
        "email": resetUserController.text.toString(),
      }
    };

    var getDetails = await RemoteServices.postMethod(
        'api/forgetPasswordMail', emailMap);
    if (getDetails.statusCode == 200) {
      print("Here  statusCode===>> ${getDetails.statusCode} \n\n ${getDetails
          .data} \n\n ${getDetails.errorMessage}");
      errorMessage = "Verification code has sent on your email id.";
      isMailSend = true;
    }
    else if (getDetails.statusCode == 400) {
      print("Here ===>> ${getDetails.statusCode} \n\n ${getDetails
          .data} \n\n ${getDetails.errorMessage}");
      errorMessage = "User not found, Please try again !";
      isMailSend = false;
    }
    else {
      print("Here ===>> ${getDetails.statusCode} \n\n ${getDetails
          .data} \n\n ${getDetails.errorMessage}");
      errorMessage = getDetails.errorMessage ?? "Please retry";
      isMailSend = false;
    }
    update();
  }

  Future<User?> signInWithGoogle() async {
    print("here is the call for google sign in ");
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await auth.signInWithCredential(credential);
      print("here is the call for userCredential sign in ");
      return userCredential.user;
    } catch (e) {
      var e;
      print("Here is the exception $e");
      return e;
    }
    update();
  }

  late final FirebaseAuth? firebaseAuth;

  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<User?> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: Platform.isIOS ? nonce : null,

        /// We are providing Web Authentication for Android Login,
        /// Android uses web browser based login for Apple.
        webAuthenticationOptions: Platform.isIOS
            ? null
            : WebAuthenticationOptions(
          clientId: "9U3RJ22QFN",
          redirectUri: Uri.parse(
              "https://wagl-a8aad.firebaseapp.com/__/auth/handler"),
        ),

      );

      print(appleCredential.authorizationCode);

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final authResult =
      await firebaseAuth!.signInWithCredential(oauthCredential);

      final displayName =
          '${appleCredential.givenName} ${appleCredential.familyName}';
      final userEmail = '${appleCredential.email}';

      final firebaseUser = authResult.user;
      print(displayName);
      await firebaseUser!.updateProfile(displayName: displayName);
      await firebaseUser!.updateEmail(userEmail);

      return firebaseUser;
    } catch (exception) {
      print(exception);
      return null;
    }
  }

  checkEmail(value) {
    var temp = Validator.validateEmail(value);
    if (temp == "") {
      isValidEmailPass = true;
    } else {
      isValidEmailPass = false;
    }
    update();
  }

  checkText(value, bool flag) {
    if (flag) {
      var temp = Validator.validateEmail(value);
      if (temp == "") {
        isValidEmail = true;
        print("Here valid");
      } else {
        isValidEmail = false;
        print("Here Invalid");
      }
    }
    if (flag == false) {
      var tempPassword = Validator.validatePassword(value);
      if (tempPassword == "") {
        isValidPass = true;
      } else {
        isValidPass = false;
      }
    }
    update();
  }

  Future login(value) async {
    Map map;

    if (value == 1) {
      map = {
        "identifier": userNameController.text.toString(),
        "password": passwordController.text.toString(),
        /*  identifier:"pragati@yopmail.com"
        password:Test@123*/
      };
    } else {
      map = {
        "identifier": value,
        "password": value,
        /*  identifier:"pragati@yopmail.com"
        password:Test@123*/
      };
    }

    var getDetails = await RemoteServices.postMethod('api/auth/local', map);
    print("here is the data");
    print("here is the getDetails :: ${getDetails.data}");

    if (getDetails.statusCode == 200) {
      print("Here is the response 1:::${getDetails.data}");
      var apiDetails = loginResponseFromJson(getDetails.data);
      ApiClient.box.write('userId', apiDetails.user.id);
      ApiClient.box.write('userEmail', apiDetails.user.email);
      ApiClient.box.write('login', true);
      ApiClient.box.write('authToken', apiDetails.jwt);
      ApiClient.box.write('userName', apiDetails.user.username);
      msg = getDetails.errorMessage;
      print("JWT: ${apiDetails}");
      print("User: ${apiDetails.user.username}");
      print("User: ${ApiClient.box.read("authToken")}");
      isVerified = true;
      await updateFcmToken(apiDetails.jwt);
    } else {
      print("Here is the response 1::");
      isVerified = false;
      if (value == 1) {
        userEmail = "User not found,please register.";
      }
      else {
        userEmail = "Invalid email or password. Please try again.";
      }
      msg = getDetails.errorMessage!;
      print("Error heres : ${getDetails.errorMessage}");
    }

    update();
  }

  Future updateFcmToken(String token) async {
    print("here is the token $token ====");
    print("here is the token $fcmToken ====");
    try {
      Map map;
      map = {
        "token": fcmToken,
      };

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var request = http.Request(
          'POST', Uri.parse('${RemoteServices.baseUrl}api/auth/local/fcm'));
      request.body = json.encode({
        "token": fcmToken
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        print("${RemoteServices.baseUrl}api/auth/local/fcm}");
        print("here is the fcm$fcmToken");
      }
      else {
        print(await response.stream.bytesToString());
        print("here is the fcm$fcmToken");
      }
    }
    catch (e) {
      print("e");
    }
    update();
  }


  String validatePassword(String value, String value2) {
    print(value);
    if (value.isEmpty || value.isEmpty) {
      return 'Please enter password';
    } else if (value != value2) {
      return "The passwords do not match. Please try again";
    } else {
      return '';
    }
  }

  validation(int number) {
    if (number == 1) {
      userEmail = Validator.validateEmail(userNameController.text);
      userPassword = Validator.validatePassword(passwordController.text);
    } else if (number == 2) {
      resetUserPassword = Validator.validateEmail(resetUserController.text);
    } else if (number == 3) {
      confirmPassword = validatePassword(passwordController.text.toString(),
          confirmPasswordController.text.toString());

      print("here is the password $confirmPassword");
    }
    update();
  }


  Future<void> signOut() async {
    isVerified = false;
    await auth.signOut();
    await googleSignIn.signOut();
    user = null;
    print("here ");
    update();
  }

  String confirmPassword = '';

  cleanData() {
    userEmail = '';
    userPassword = '';
    confirmPassword = '';
    resetUserPassword = '';
    userNameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    resetUserController.clear();
    isVerified = false;
    confirmOtp = "";
    updatedStatus = false;
    isMailSend = false;
    isValidEmailPass = false;
    msg = "";
    isValidEmail = false;
    errorMessage = "";
    otpControllers.forEach((controller) => controller.clear());
    // focusNodes.forEach((node) => node.());

    update();
  }

  String fcmToken = "";
  List<LoginModel> loginDetails = [];

  Future<void> getFcmToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    // Retrieve FCM Token

    String? token = await messaging.getToken();

    if (token != null) {
      // Store the token in Hiv
      fcmToken = token;
      print("fcm token $fcmToken");
    }
  }


  firebaseMsg() {
    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
          (message) {
        //  log("Here is the Title${message.notification?.title}");

        print("message.notification?:::  ${message.notification?.title}");
        String? channeId = "";
        //   if (Platform.isIOS) {
        //     print("received event for iOS : $message");
        //     return;
        //   }else{
        if (message.notification != null) {
          /*  log("Here is the Title${message.notification?.title}");
          log("Here is the Data${message.data.values}");
          log("${message.notification?.body}");
          log("Here is the channel ID ${message.notification?.android?.channelId}");
          log("Here is the Sound ${message.notification?.android?.sound}");*/
          channeId = message.notification?.android?.channelId;

          if (Platform.isAndroid) {
            if (channeId == "invitation_channel") {
              // LocalNotificationService.createAndDisplayNotification(message, true);
              // LocalNotificationService.handleNotification(message);
              if (message.notification?.title == "‘Ping’d Invitation") {
                LocalNotificationService.showSimpleNotificationCustomSound(
                    title: "${message.notification?.title}",
                    body: "${message.notification?.body}",
                    payload: "payload");
              } else {
                LocalNotificationService.showSimpleNotification(
                    id: 10, title: "${message.notification?.title}",
                    body: "${message.notification?.body}",
                    payload: "payload");
              }
              //   print("Here is the channel ID firebaseMsg 2222");
            } else {
              // LocalNotificationService.createAndDisplayNotification(message, false);
              // LocalNotificationService.handleNotification(message);
              if (message.notification?.title == "‘Ping’d Invitation") {
                LocalNotificationService.showSimpleNotificationCustomSound(
                    title: "${message.notification?.title}",
                    body: "${message.notification?.body}",
                    payload: "payload");
              } else {
                LocalNotificationService.showSimpleNotification(
                    id: 10, title: "${message.notification?.title}",
                    body: "${message.notification?.body}",
                    payload: "payload");
              }
            }
          }
        }
        // }
      },
    );
  }

  bool updatedStatus = false;

  Future resetNewPassword() async {
    Map<String, dynamic> passMap = {
      "data": {
        "email": resetUserController.text.toString(),
        "otp": confirmOtp,
        "password": confirmPasswordController.text.toString(),

      }
    };

    var getDetails = await RemoteServices.postMethod(
        'api/resetPassword', passMap);
    if (getDetails.statusCode == 200) {
      print("here is the updated password ");
      updatedStatus = true;
    }
    else if (getDetails.statusCode == 400) {
      updatedStatus = false;
      print("Here ===>> ${getDetails.statusCode} \n\n ${getDetails
          .data} \n\n ${getDetails.errorMessage}");
      print("here is the updated password ");
    }
    else {
      print("Here ===>> ${getDetails.statusCode} \n\n ${getDetails
          .data} \n\n ${getDetails.errorMessage}");
    }
    update();
  }

}
