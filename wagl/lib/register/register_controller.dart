import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../custom_widget/validator.dart';
import '../login/loginModel.dart';
import '../services/remote_services.dart';
import '../util/ApiClient.dart';

class RegisterController extends GetxController {
  String userEmail = '';
  String confirmPassword = '';
  bool status=false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  User? user;
  var emailTextController = TextEditingController();

  var passwordController = TextEditingController();
  var confirmPassController = TextEditingController();
  List<int> disConnect = [];
  List connect = [{"id":1,"position":{"end":true}}];
  bool isMailSend = false, isValidEmail = false, isValidPass = false;

  Future<UserCredential> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        final AccessToken accessToken = loginResult.accessToken!;
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);
        return await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        throw FirebaseAuthException(
          code: 'Facebook Login Failed',
          message: 'The Facebook login was not successful.',
        );
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Exception: ${e.message}');
      throw e; // rethrow the exception
    } catch (e) {
      // Handle other exceptions
      print('Other Exception: $e');
      throw e; // rethrow the exception
    }
  }

  sendMail(bool status) {
    isMailSend = status;
    update();
  }
  Future<void> signOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
    user = null;
    print("here ");
    update();
  }
  Future<User?> signInWithGoogle() async {
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

      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
    update();
  }

  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;

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
          redirectUri: Uri.parse("https://wagl-a8aad.firebaseapp.com/__/auth/handler"),
        ),

      );
      String? email = appleCredential.email;
      print("Apple SignIn Email: $email");
      print(appleCredential.authorizationCode);
      print(appleCredential.email);
      print(appleCredential.givenName);
      print(appleCredential.identityToken);
      print("here is the sucess");
      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final UserCredential authResult = await firebaseAuth.signInWithCredential(oauthCredential);
      if (authResult.user?.email == null) {
        return null;
      }


      final firebaseUser = authResult.user;

      print("  \n\n \n ###### ");
      await firebaseUser!.updateEmail(authResult.user?.email??"error@abc.com");
      return firebaseUser;
    } catch (exception) {
      print(exception);
      return null;
    }
  }

  checkText(email) {
    var temp = Validator.validateEmail(email);
    print("object $temp");
    var temppass = validatePassword(passwordController.text.toString(),
        confirmPassController.text.toString());
    print("Object $temppass");
    if (temp == "" && temppass == "") {
      isValidEmail = true;
    } else {
      isValidEmail = false;
    }
    update();
  }

  validation() {
    userEmail = Validator.validateEmail(emailTextController.text);
    confirmPassword = validatePassword(passwordController.text.toString(),
        confirmPassController.text.toString());
    update();
  }

  bool isLoading = true;
  bool isValidRegistration=false;
  var msg="";
  Future signUp(value) async {
    Map map;
    if (value == 1) {
      map = {
        "email": emailTextController.text.toString(),
        "username": emailTextController.text.toString(),
        "password": passwordController.text.toString(),
        // "role": '{ disconnect: $disConnect,connect:$connect}',
        "role": "",

      };
    } else {
      map = {
        "email": value,
        "username": value,
        "password": value,
        "role": { "disconnect": [],    "connect":connect},
      };
    }
    var getDetails =
        await RemoteServices.postMethod('api/auth/local/register',map);
    if (getDetails.data != null) {
      isLoading = false;
      var apiDetails = loginResponseFromJson(getDetails.data);
      print("getdetails:: ${getDetails.data}");
      ApiClient.box.write('login', true);

      ApiClient.box.write('userId', apiDetails.user.id);
      ApiClient.box.write('authToken', apiDetails.jwt);
      ApiClient.box.write('userName', apiDetails.user.username);;
      print("JWT: ${apiDetails}");
      print("User: ${apiDetails.user.username}");
      print("User: ${ApiClient.box.read("authToken")}");
      isValidRegistration=true;
    } else {
      msg = getDetails.errorMessage!;
      isValidRegistration=false;
      print("Error: ${getDetails.errorMessage}");
      print("Error: ${getDetails.errorMessage}");
    }
    update();
  }

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

  cleanData() {
    userEmail = '';
    confirmPassword = '';
    emailTextController.clear();
    passwordController.clear();
    confirmPassController.clear();
    sendMail(false);
    isValidRegistration=false;
    isValidEmail = false;
    update();
  }
}
