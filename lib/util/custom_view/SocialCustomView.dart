// // import 'package:authapp/pages/database.dart';
// // import 'package:authapp/pages/home.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:the_apple_sign_in/scope.dart';
// import 'package:the_apple_sign_in/the_apple_sign_in.dart';
//
// class AuthMethods {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//
//   getCurrentUser() async {
//     return await auth.currentUser;
//   }
//
//   // signInWithGoogle(BuildContext context) async {
//   //   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//   //   final GoogleSignIn googleSignIn = GoogleSignIn();
//   //
//   //   final GoogleSignInAccount? googleSignInAccount =
//   //   await googleSignIn.signIn();
//   //
//   //   final GoogleSignInAuthentication? googleSignInAuthentication =
//   //   await googleSignInAccount?.authentication;
//   //
//   //   final AuthCredential credential = GoogleAuthProvider.credential(
//   //       idToken: googleSignInAuthentication?.idToken,
//   //       accessToken: googleSignInAuthentication?.accessToken);
//   //
//   //   UserCredential result = await firebaseAuth.signInWithCredential(credential);
//   //
//   //   User? userDetails = result.user;
//   //
//   //   if (result != null) {
//   //     Map<String, dynamic> userInfoMap = {
//   //       "email": userDetails!.email,
//   //       "name": userDetails.displayName,
//   //       "imgUrl": userDetails.photoURL,
//   //       "id": userDetails.uid,
//   //     };
//   //     DatabaseMethods().addUser(userDetails.uid, userInfoMap).then((value) {
//   //       Navigator.push(
//   //           context, MaterialPageRoute(builder: (context) => Home()));
//   //     });
//   //   }
//   // }
//
//   Future<User> signInWithApple({List<Scope> scopes = const []}) async {
//     final result = await TheAppleSignIn.performRequests(
//         [AppleIdRequest(requestedScopes: scopes)]);
//
//     switch (result.status) {
//       case AuthorizationStatus.authorized:
//         final AppleIdCredential = result.credential!;
//         final oAuthProvider = OAuthProvider('apple.com');
//         final credential = oAuthProvider.credential(
//             idToken: String.fromCharCodes(AppleIdCredential.identityToken!));
//         final UserCredential = await auth.signInWithCredential(credential);
//         final firebaseUser = UserCredential.user!;
//         if (scopes.contains(Scope.fullName)) {
//           final fullName = AppleIdCredential.fullName;
//           if (fullName != null &&
//               fullName.givenName != null &&
//               fullName.familyName != null) {
//             final displayName = '${fullName.givenName} ${fullName.familyName}';
//             await firebaseUser.updateDisplayName(displayName);
//           }
//         }
//         return firebaseUser;
//       case AuthorizationStatus.error:
//         throw PlatformException(
//             code: 'ERROR_AUTHORIZATION_DENIED',
//             message: result.error.toString());
//
//       case AuthorizationStatus.cancelled:
//         throw PlatformException(
//             code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
//
//       default:
//         throw UnimplementedError();
//     }
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:club_runner/util/local_storage/LocalStorage.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:http/http.dart' as http;

import '../../controller/WelcomeScreenController.dart';

/// Generates a cryptographically secure random nonce, to be included in a
/// credential request.
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

Future<UserCredential> signInWithApple1() async {
  // To prevent replay attacks with the credential returned from Apple, we
  // include a nonce in the credential request. When signing in with
  // Firebase, the nonce in the id token returned by Apple, is expected to
  // match the sha256 hash of `rawNonce`.
  final rawNonce = generateNonce();
  final nonce = sha256ofString(rawNonce);

  // Request credential for the currently signed in Apple account.
  final appleCredential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
    nonce: nonce,
  );

  // Create an `OAuthCredential` from the credential returned by Apple.
  final oauthCredential = OAuthProvider("apple.com").credential(
    idToken: appleCredential.identityToken,
    rawNonce: rawNonce,
  );

  // Sign in the user with Firebase. If the nonce we generated earlier does
  // not match the nonce in `appleCredential.identityToken`, sign in will fail.
  return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
}

Future<void> signInWithApple() async {
  WelcomeScreenController ws_controller = Get.put(WelcomeScreenController());
  final rawNonce = generateNonce();
  final nonce = sha256ofString(rawNonce);
  final credential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
    nonce: nonce,
    state: 'example-state',
  );

  print("credential :-- ${credential.identityToken}");
  print("credential :-- ${credential.userIdentifier}");
  print("credential givenName :-- ${credential.givenName}");

  if (credential.givenName != null) {
    print("before credential givenName");

    ws_controller.socialTempData(
        Get.context!,
        credential.givenName.toString(),
        credential.familyName.toString(),
        credential.email.toString(),
        credential.userIdentifier.toString());

    ws_controller.socialLoginAPi(
        Get.context!,
        credential.givenName!,
        credential.familyName,
        credential.email,
        "2",
        credential.userIdentifier,
        null);
  } else {
    print("after credential appleFirstName");
    ws_controller.getsocialTempData(credential.userIdentifier.toString());
    // ws_controller.socialLoginAPi(Get.context!, appleFirstName, appleLastName,
    //     appleEmail != null ? appleEmail : "", "2", appleId, null);
  }
}

signInWithTwitter() async {
  WelcomeScreenController ws_controller = Get.put(WelcomeScreenController());
  final twitterLogin = TwitterLogin(
    apiKey: 'DTW8yrGb9rwnAPXnxCgsTxhhL',
    apiSecretKey: 'rSmA3OJPus8qhqcJNvoMQ45qM9H8VKOdK3HtypObNBowr4Mdwi',
    redirectURI: 'trainza://',
  );

  await twitterLogin.login(forceLogin: false).then((value) async {
    print("Twitter Value " + value.status.toString());

    print("Twitter Value user :${value.user}");
    print("Twitter Value name: ${value.user!.name}");
    print("Twitter Value id :${value.user!.id}");
    print("Twitter Value email : ${value.user!.email}");

    List<String> nameParts = value.user!.name.split(" ");
    String firstName = nameParts.isNotEmpty ? nameParts[0] : "";
    String lastName =
        nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";
    var Imgurl = value.user!.thumbnailImage;

    print("Twitter firstName :--  $firstName");
    print("Twitter lastName :--  $lastName");
    print("Twitter image :--  ${value.user!.thumbnailImage}");

    if (Imgurl.contains("_normal")) {
      Imgurl = Imgurl.replaceAll("_normal", "");
    }

    File file = await downloadFile(Imgurl);

    print("Twitter file :--  $file");

    ws_controller.socialLoginAPi(Get.context!, firstName, lastName,
        value.user!.email, "3", value.user!.id.toString(), file);

    switch (value.status) {
      case TwitterLoginStatus.loggedIn:
        // success
        print("Twitter :--  ${TwitterLoginStatus.loggedIn}");
        break;
      case TwitterLoginStatus.cancelledByUser:
        // cancel
        print("Twitter :--  ${TwitterLoginStatus.cancelledByUser}");
        break;
      case TwitterLoginStatus.error:
        // error
        print("Twitter :--  ${TwitterLoginStatus.error}");
        break;
      case null:
        // TODO: Handle this case.
        print("Twitter :--  null");
        break;
    }
  });
}

Future<void> signInWithGoogle() async {
  WelcomeScreenController ws_controller = Get.put(WelcomeScreenController());
  // Trigger the authentication flow
  GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  print("googleUser:--  ${googleUser}");
  print("user social id:--  ${googleUser!.id}");
  print("user email ${googleUser.email}");
  print("user name ${googleUser.displayName}");
  print("user url ${googleUser.photoUrl}");

  List<String> nameParts = googleUser.displayName!.split(" ");
  String firstName = nameParts.isNotEmpty ? nameParts[0] : "";
  String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";

  print("firstName :--  $firstName");
  print("lastName :--  $lastName");

  File? file;
  if (googleUser.photoUrl != null && googleUser.photoUrl.toString() != "") {
    file = await downloadFile(googleUser.photoUrl.toString());
  }

  print("Google file :--  $file");

  signOutGoogle();

  ws_controller.socialLoginAPi(Get.context!, firstName, lastName,
      googleUser.email, "1", googleUser.id, file);
  /* // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);*/
}

Future<void> signOutGoogle() async {
  await GoogleSignIn().signOut();
  print("User signed out");
}

Future<File> downloadFile(String url) async {
  print("downloadFile url $url");
  // Get the directory to store the file
  final directory = await getApplicationDocumentsDirectory();
  final fileName = url.split('/').last;
  print("downloadFile fileName $fileName");

  // Check if the fileName already contains the .jpg extension
  final completeFileName = fileName.endsWith('.jpg') ? fileName : '$fileName.jpg';

  // Define the file path
  final filePath = '${directory.path}/$completeFileName';

  // Send an HTTP GET request to download the file
  final response = await http.get(Uri.parse(url));

  print("filePath $filePath");
  // Create a file at the specified path
  final file = File(filePath);

  // Write the file contents to the file
  return file.writeAsBytes(response.bodyBytes);
}
