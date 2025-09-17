import 'dart:convert';
import 'dart:developer';
import 'package:club_runner/network/EndPointList.dart';
import 'package:club_runner/util/route_helper/RouteHelper.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/Login_Model.dart';
import '../util/FunctionConstant/FunctionConstant.dart';
import '../util/api_message_constant/ApiMsgConstant.dart';
import '../util/local_storage/LocalStorage.dart';
import '../util/my_color/MyColor.dart';

class DioServices extends GetxService {
  static final DIO.Dio dio = DIO.Dio();
  final int timeoutInSeconds = 30;
  final DIO.LogInterceptor loggingInterceptor = DIO.LogInterceptor();
  static LocalStorage sp = LocalStorage();

  //For getMethod
  static Future<DIO.Response> getMethod(String endPoint, dynamic header) async {
    var response;
    try {
      response = await dio.get(WebServices.BASE_URL + endPoint,
          options: DIO.Options(headers: header));
      return returnResponse(response);
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          response = e.response;
          return returnResponse(e.response!);
        }
      } else {
        log("NO Dio Error: $e");
      }
    }

    return returnResponse(response);
  }

  //For postMethod
  static Future<DIO.Response> postMethod(
      String endPoint, Map<String, dynamic>? body, header) async
  {
    DIO.FormData formData = DIO.FormData.fromMap(body!);
    var response;
    try {
      response = await dio.post(
        WebServices.BASE_URL + endPoint,
        data: formData,
        options: DIO.Options(headers: header),
      );

      return returnResponse(response);
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          response = e.response;
          return returnResponse(e.response!);
        } else {
          log("Error:-- ${e.message}");
        }
      } else {
        log("NO Dio Error: $e");
      }
    }
    return returnResponse(response);
  }

  //For put Method
  static Future<DIO.Response> putMethod(
      String endPoint, Map<String, dynamic> body, header) async
  {
    DIO.FormData formData = DIO.FormData.fromMap(body);
    var response;
    try {
      response = await dio.put(
        WebServices.BASE_URL + endPoint,
        data: formData,
        options: DIO.Options(headers: header),
      );

      return returnResponse(response);
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          response = e.response;
          return returnResponse(e.response!);
        } else {
          log("Error:-- ${e.message}");
        }
      } else {
        log("NO Dio Error: $e");
      }
    }
    return returnResponse(response);
  }

  //For multipart method
  static Future<dynamic> multipartPostMethod(String endPoint, String keyName,
      String filePath, Map<String, dynamic> body, header) async
  {
    body[keyName] = await DIO.MultipartFile.fromFile(filePath,
        filename: filePath.split('/').last);

    final formData = DIO.FormData.fromMap(body);
    var response;
    try {
      response = await dio.post(
        WebServices.BASE_URL + endPoint,
        data: formData,
        options: DIO.Options(headers: header),
      );
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          response = e.response;
          return returnResponse(e.response!);
        } else {
          log("Error: ${e.message}");
        }
      } else {
        log("NO Dio Error: $e");
      }
    }
    return returnResponse(response);
  }

  static returnResponse(DIO.Response response) {
    bool isRemember = LocalStorage.getBoolValue(sp.isRemember);
    String emailRemember = LocalStorage.getStringValue(sp.emailRemember),
        passRemember = LocalStorage.getStringValue(sp.passwordRemember),
        deviceId = LocalStorage.getStringValue(sp.deviceId),
        deviceType = LocalStorage.getStringValue(sp.deviceType),
        deviceToken = LocalStorage.getStringValue(sp.deviceToken),
        dialcodeReminder = LocalStorage.getStringValue(sp.dialcodeReminder),
        phoneReminder = LocalStorage.getStringValue(sp.phoneReminder),
        loginType = LocalStorage.getStringValue(sp.loginTypeRemember),
        countrynameReminder = LocalStorage.getStringValue(sp.countryname),
        countrycodeReminder = LocalStorage.getStringValue(sp.countrycode),
        countryflagReminder = LocalStorage.getStringValue(sp.countryflag),
        appleFirstName = LocalStorage.getStringValue(sp.appleFirstName),
        appleLastName = LocalStorage.getStringValue(sp.appleLastName),
        appleEmail = LocalStorage.getStringValue(sp.appleEmail),
        appleId = LocalStorage.getStringValue(sp.appleId);

    //print("deviceId session expired:--- $deviceId");
    //CommonFunction.hideLoader();
    if (response.statusCode != 200 && response.statusCode != 158 && response.statusCode != 204) {

      String responseMessage = ApiMsgConstant.getResponseMessage(response.data["code"].toString());

      CommonFunction.showAlertDialogdelete(
          Get.context!,
          response.data["code"] == 105
              ? response.data["message"].toString()
              : responseMessage,

              () {
        if (response.data["code"] == 104) {
          //Logout wala code....
          print("Logout wala code....");
          LocalStorage.clearLocalStorage();
          LocalStorage.setBoolValue(sp.isRemember, isRemember);
          LocalStorage.setStringValue(
              sp.loginTypeRemember, loginType == "2" ? "false" : "true");
          LocalStorage.setStringValue(sp.emailRemember, emailRemember);
          LocalStorage.setStringValue(sp.phoneReminder, phoneReminder);
          LocalStorage.setStringValue(sp.dialcodeReminder, dialcodeReminder);
          LocalStorage.setStringValue(sp.countryname, countrynameReminder);
          LocalStorage.setStringValue(sp.countryflag, countryflagReminder);
          LocalStorage.setStringValue(sp.countrycode, countrycodeReminder);
          LocalStorage.setStringValue(sp.passwordRemember, passRemember);
          LocalStorage.setStringValue(sp.deviceId, deviceId);
          LocalStorage.setStringValue(sp.deviceType, deviceType);
          LocalStorage.setStringValue(sp.deviceToken, deviceToken);
          LocalStorage.setStringValue(sp.appleFirstName, appleFirstName);
          LocalStorage.setStringValue(sp.appleLastName, appleLastName);
          LocalStorage.setStringValue(sp.appleEmail, appleEmail);
          LocalStorage.setStringValue(sp.appleId, appleId);

          MyColor.app_orange_color.value = Color(0xFFFF4300);
          MyColor.app_button_text_dynamic_color = Color(0xFFFFFFFF);
          MyColor.app_text_dynamic_color = Color(0xFFFF4300);
          Get.offAllNamed(RouteHelper.getWelcomeScreen());
        }
        else if (response.data["code"] == 109) {
          LoginModel logindata = loginModelFromJson(jsonEncode(response.data));

          print("Login logindata : " + logindata.data.toString());
          LocalStorage.setStringValue(sp.authToken, logindata.data.token);
          LocalStorage.setStringValue(
              sp.userfirstName, logindata.data.firstName);
          LocalStorage.setStringValue(sp.userlastName, logindata.data.lastName);
          LocalStorage.setStringValue(sp.useremail, logindata.data.email);
          LocalStorage.setStringValue(sp.isEmailPubliclyShared,
              logindata.data.isEmailPubliclyShared.toString());
          LocalStorage.setStringValue(sp.isNumberPubliclyShared,
              logindata.data.isNumberPubliclyShared.toString());
          LocalStorage.setStringValue(
              sp.userprofilePicture, logindata.data.profilePicture);
          LocalStorage.setStringValue(
              sp.phoneDialCode, logindata.data.phoneDialCode);
          LocalStorage.setStringValue(
              sp.phoneCountryCode, logindata.data.phoneCountryCode);
          LocalStorage.setStringValue(
              sp.phoneNumber, logindata.data.phoneNumber);
          LocalStorage.setStringValue(
              sp.notification_enable, logindata.data.notification_enable);
          CurrentClubData currentClubData = logindata.data.currentClubData;
          LocalStorage.setStringValue(
              sp.currentClubData_logo, currentClubData.appLogoFilename);
          LocalStorage.setStringValue(
              sp.currentClubData_clubName, currentClubData.clubName);
          LocalStorage.setStringValue(sp.currentClubData_canViewOtherMembers,
              currentClubData.canViewOtherMembers.toString());
          LocalStorage.setStringValue(
              sp.currentClubData_btnBgColor, currentClubData.btnBgColor);
          LocalStorage.setStringValue(
              sp.currentClubData_btnTxtColor, currentClubData.btnTxtColor);
          LocalStorage.setStringValue(
              sp.currentClubData_txtColor, currentClubData.txtColor);
          LocalStorage.setStringValue(
              sp.isMembershipExpire, currentClubData.isMembershipExpire);
          LocalStorage.setStringValue(
              sp.isMembershipActive, currentClubData.isMembershipActive);
          if (currentClubData.isMembershipExpire == '1' ||
              currentClubData.isMembershipActive == '0') {
            currentClubData.isMembershipFinal = '0';
          } else {
            currentClubData.isMembershipFinal = '1';
          }
          LocalStorage.setStringValue(
              sp.isMembershipFinal, currentClubData.isMembershipFinal);
          Get.offAllNamed(RouteHelper.getMainScreen());
        }
        else {

          Get.back();
        }
      });
    }
      return response;
  }

  static Future<Map<String, String>> getDefaultHeader() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Check if the token is empty or null, and regenerate if necessary
    String? deviceToken = LocalStorage.getStringValue(sp.deviceToken);
    if (deviceToken == null || deviceToken.isEmpty) {
      // Regenerate the token
      deviceToken = await messaging.getToken();
      if (deviceToken != null) {
        print("Re-generated device token: $deviceToken");
        LocalStorage.setStringValue(sp.deviceToken, deviceToken);
      } else {
        print("Failed to regenerate device token");
      }
    }

    // Build headers with the available or regenerated token
    Map<String, String> defaultHeaders = {
      "device-token": deviceToken ?? "",
      "device-type": LocalStorage.getStringValue(sp.deviceType) ?? "",
      "device-id": LocalStorage.getStringValue(sp.deviceId) ?? "",
      "api-key": "m2E7FFKm3v8e!xCxj|6RAC87lMA2wOFXt8i3HX&klH}?{556dc1kwyllokWzqeKw&kH}?{j7UuFXn55BE508zy7gEHNMx",
      'Content-Type': 'application/json',
    };

    print("getDefaultHeader " + defaultHeaders.toString());
    print("device Id :--${LocalStorage.getStringValue(sp.deviceId)}");

    return defaultHeaders;
  }


  static Map<String, String> getAllHeaders() {
    Map<String, String> allHeaders = {
      "access-token": LocalStorage.getStringValue(sp.authToken),
      "device-token": LocalStorage.getStringValue(sp.deviceToken),
      "device-type": LocalStorage.getStringValue(sp.deviceType),
      "device-id": LocalStorage.getStringValue(sp.deviceId),
      "api-key":
          "m2E7FFKm3v8e!xCxj|6RAC87lMA2wOFXt8i3HX&klH}?{556dc1kwyllokWzqeKw&kH}?{j7UuFXn55BE508zy7gEHNMx",
      'Content-Type': 'application/json',
    };
    print(LocalStorage.getStringValue(sp.deviceId));
    return allHeaders;
  }
}
