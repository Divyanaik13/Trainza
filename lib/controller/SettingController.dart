import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../network/ApiServices.dart';
import '../network/DioServices.dart';
import '../network/EndPointList.dart';
import '../util/FunctionConstant/FunctionConstant.dart';
import '../util/api_message_constant/ApiMsgConstant.dart';
import '../util/local_storage/LocalStorage.dart';
import '../util/my_color/MyColor.dart';
import '../util/route_helper/RouteHelper.dart';

class settingsController extends GetxController{

  var checked = false.obs;
  var light = false.obs;
  var notificationStatus = 0.obs;

  LocalStorage sp = LocalStorage();


  // Delete Api function
  Future<String> deleteAccount_Api(BuildContext context) async {

    CommonFunction.showLoader();

    print("Headers:-- ${ApiService.getAllHeaders()}");

    try {
      var response = await ApiService.deleteData(
          WebServices.delete_account, ApiService.getAllHeaders());
      print("Delete Account Responce -${response.body}");

      CommonFunction.hideLoader();

      var jsonResponse = jsonDecode(response.body);

      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("statusCode:-$statusCode");
      print("data:-$data");
      String responseMessage =
      ApiMsgConstant.getResponseMessage(statusCode.toString());

      if (statusCode == 200) {
        print("Delete Account Success : " + response.body);
        MyColor.app_orange_color.value = Color(0xFFFF4300);
        MyColor.app_button_text_dynamic_color = Color(0xFFFFFFFF);
        MyColor.app_text_dynamic_color = Color(0xFFFF4300);
        Get.toNamed(RouteHelper.getWelcomeScreen());
      }
      return responseMessage;
    } catch (e) {
      print("Catch error $e");
    }
    return ApiMsgConstant.getResponseMessage("500");
  }



  // put api function
  Future<String> notificationStatus_api(String newStatus) async {
    CommonFunction.showLoader();
    newStatus=="0"?newStatus="1":newStatus="0";
    Map<String, String> body = {
      "notification_status": newStatus,
    };
    print("Body:-- $body");

    try {
      var response = await DioServices.putMethod(
        WebServices.notificationStatus,
        body,
        DioServices.getAllHeaders(),
      );
      print("notification_status Reasponce ${response.data}");
      CommonFunction.hideLoader();
      // LocalStorage sp = LocalStorage();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("statusCode:-$statusCode");
      print("data:-$data");

      if (statusCode == 200) {

        if(notificationStatus.value==1){
          print("notificationStatus 1");
          notificationStatus.value=0;
          LocalStorage.setStringValue(sp.notification_enable, notificationStatus.value.toString());
          print("notificationStatus :- ${LocalStorage.getStringValue(sp.notification_enable)}");
        }else{
          print("notificationStatus 0");
          notificationStatus.value=1;
          LocalStorage.setStringValue(sp.notification_enable, notificationStatus.value.toString());
          print("notificationStatus :- ${LocalStorage.getStringValue(sp.notification_enable)}");
        }
      // LocalStorage.setStringValue(sp.notification_enable, logindata.data.notification_enable);
      }
      return statusCode.toString();
    } catch (e) {
      CommonFunction.hideLoader();
      print("Catch error $e");
    }
    return "";
  }

}