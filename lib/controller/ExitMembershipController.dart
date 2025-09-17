import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/Login_Model.dart';
import '../network/ApiServices.dart';
import '../network/DioServices.dart';
import '../network/EndPointList.dart';
import '../util/FunctionConstant/FunctionConstant.dart';
import '../util/api_message_constant/ApiMsgConstant.dart';
import '../util/local_storage/LocalStorage.dart';
import '../util/route_helper/RouteHelper.dart';

class exitMembershipController extends GetxController{

  var logindata = Rxn<LoginModel>();
  LocalStorage sp = LocalStorage();


  Future<String> deleteExitMembership_Api() async {
    CommonFunction.showLoader();
    print("Headers:-- ${ApiService.getAllHeaders()}");
    try {
      var response =
      await ApiService.deleteData(WebServices.exitMembership, ApiService.getAllHeaders());
      print("Delete membership Reasponce -${response.body}");
      CommonFunction.hideLoader();
      var jsonResponse = jsonDecode(response.body);
      var statusCode = jsonResponse["code"];
      print("statusCode:-$statusCode");
      if (statusCode == 200) {
        // profileCallback_api();
        Future.delayed(Duration.zero, () {

          logindata.value = loginModelFromJson(response.body);

          LocalStorage.setStringValue(sp.authToken, logindata.value!.data.token);
          LocalStorage.setStringValue(sp.userfirstName, logindata.value!.data.firstName);
          LocalStorage.setStringValue(sp.userlastName, logindata.value!.data.lastName);
          LocalStorage.setStringValue(sp.useremail, logindata.value!.data.email);
          LocalStorage.setStringValue(sp.isEmailPubliclyShared, logindata.value!.data.isEmailPubliclyShared.toString());
          LocalStorage.setStringValue(sp.isNumberPubliclyShared, logindata.value!.data.isNumberPubliclyShared.toString());
          LocalStorage.setStringValue(sp.userprofilePicture, logindata.value!.data.profilePicture);
          LocalStorage.setStringValue(sp.phoneDialCode, logindata.value!.data.phoneDialCode);
          LocalStorage.setStringValue(sp.phoneCountryCode, logindata.value!.data.phoneCountryCode);
          LocalStorage.setStringValue(sp.phoneNumber, logindata.value!.data.phoneNumber);
          LocalStorage.setStringValue(sp.notification_enable, logindata.value!.data.notification_enable);
          CurrentClubData currentClubData = logindata.value!.data.currentClubData;
          LocalStorage.setStringValue(sp.currentClubData_logo, currentClubData.appLogoFilename);
          LocalStorage.setStringValue(sp.currentClubData_clubName, currentClubData.clubName);
          LocalStorage.setStringValue(sp.currentClubData_canViewOtherMembers, currentClubData.canViewOtherMembers.toString());
          LocalStorage.setStringValue(sp.currentClubData_btnBgColor, currentClubData.btnBgColor);
          LocalStorage.setStringValue(sp.currentClubData_btnTxtColor, currentClubData.btnTxtColor);
          LocalStorage.setStringValue(sp.currentClubData_txtColor, currentClubData.txtColor);
          LocalStorage.setStringValue(sp.isMembershipExpire, currentClubData.isMembershipExpire);
          LocalStorage.setStringValue(sp.isMembershipActive, currentClubData.isMembershipActive);

          Get.offAllNamed(RouteHelper.getMainScreen());

        });

        print("Delete membership Success : " + response.body);
      }else{
        CommonFunction.hideLoader();
      }
    } catch (e) {
      CommonFunction.hideLoader();
      print("Catch error $e");
    }
    return ApiMsgConstant.getResponseMessage("500");

  }

/*  Future<String> deleteExitMembership_Api() async {
    await performDeleteExitMembership();
    return ApiMsgConstant.getResponseMessage("500");
  }*/

  Future<void> profileCallback_api() async {
    CommonFunction.showLoader();

    print("membershiploginresponse");

    try {
      var url = WebServices.membershiploginresponse;
      print("Request URL:-- $url");
      var response = await DioServices.getMethod(url, DioServices.getAllHeaders());
      print("membershiploginresponse Date Response :-- ${response.data}");
      CommonFunction.hideLoader();

      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode:- $statusCode");


      if(response.statusCode == 200){
        print("success data:-$data");
         logindata.value = loginModelFromJson(jsonEncode(response.data));

         LocalStorage.setStringValue(sp.authToken, logindata.value!.data.token);
         LocalStorage.setStringValue(sp.userfirstName, logindata.value!.data.firstName);
         LocalStorage.setStringValue(sp.userlastName, logindata.value!.data.lastName);
         LocalStorage.setStringValue(sp.useremail, logindata.value!.data.email);
         LocalStorage.setStringValue(sp.isEmailPubliclyShared, logindata.value!.data.isEmailPubliclyShared.toString());
         LocalStorage.setStringValue(sp.isNumberPubliclyShared, logindata.value!.data.isNumberPubliclyShared.toString());
         LocalStorage.setStringValue(sp.userprofilePicture, logindata.value!.data.profilePicture);
         LocalStorage.setStringValue(sp.phoneDialCode, logindata.value!.data.phoneDialCode);
         LocalStorage.setStringValue(sp.phoneCountryCode, logindata.value!.data.phoneCountryCode);
         LocalStorage.setStringValue(sp.phoneNumber, logindata.value!.data.phoneNumber);
         LocalStorage.setStringValue(sp.notification_enable, logindata.value!.data.notification_enable.toString());
         CurrentClubData currentClubData = logindata.value!.data.currentClubData;
         LocalStorage.setStringValue(sp.currentClubData_logo, currentClubData.appLogoFilename);
         LocalStorage.setStringValue(sp.currentClubData_clubName, currentClubData.clubName);
         LocalStorage.setStringValue(sp.currentClubData_canViewOtherMembers, currentClubData.canViewOtherMembers.toString());
         LocalStorage.setStringValue(sp.currentClubData_btnBgColor, currentClubData.btnBgColor);
         LocalStorage.setStringValue(sp.currentClubData_btnTxtColor, currentClubData.btnTxtColor);
         LocalStorage.setStringValue(sp.currentClubData_txtColor, currentClubData.txtColor);
        LocalStorage.setStringValue(sp.isMembershipExpire, currentClubData.isMembershipExpire);
        LocalStorage.setStringValue(sp.isMembershipActive, currentClubData.isMembershipActive);

         Get.offNamed(RouteHelper.getMainScreen());

        print("membershiploginresponse Success : " + response.data);
      }
    } catch (e) {
      CommonFunction.hideLoader();
      log("membershiploginresponse Exception :-- ", error: e.toString());
    }
  }

}