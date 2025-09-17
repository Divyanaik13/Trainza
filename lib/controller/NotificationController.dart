import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import '../models/NotificationList_Model.dart';
import '../network/ApiServices.dart';
import '../network/DioServices.dart';
import '../network/EndPointList.dart';
import '../util/FunctionConstant/FunctionConstant.dart';
import '../util/api_message_constant/ApiMsgConstant.dart';

class NotificationController extends GetxController {
  var notificationModel = Rxn<NotificationListModel>();
  var notificationList = <NotificationsList>[].obs;
  var loadMore = false.obs;
  var pageLoader = false.obs;

  // Get api function
  Future<void> notificationList_API(int pageNo) async {
    print("pageNo $pageNo");
    if (pageNo == 0 || pageNo == 1) {
      CommonFunction.showLoader();
      notificationList.clear();
    } else {
      pageLoader.value = true;
      print("pageLoader true ${pageLoader.value}");
    }
    print("Headers:-- ${DioServices.getAllHeaders()}");

    try {
      var url = WebServices.notificationList + "?pageNo=$pageNo";
      print("Request URL:-- $url");
      var response =
          await DioServices.getMethod(url, DioServices.getAllHeaders());
      print("notification Date Response :-- ${response.data}");
      CommonFunction.hideLoader();
      pageLoader.value = false;
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode:- $statusCode");
      print("data:-$data");

      if (response.statusCode == 200) {
        notificationModel.value =
            notificationListModelFromJson(jsonEncode(response.data));
        notificationList.value
            .addAll(notificationModel.value!.data.notificationsList);
        loadMore.value = notificationModel.value!.data.loadMore;
        notificationModel.refresh();
        notificationList.refresh();

        print("notificationList :-- " +
            jsonEncode(notificationList.value.length));
      }
    } catch (e) {
      CommonFunction.hideLoader();
      pageLoader.value = false;
      log("Exception :-- ", error: e.toString());
    }
  }

  // Delete api function
  Future<String> notificationDelete_Api() async {
    CommonFunction.showLoader();

    print("Headers:-- ${ApiService.getAllHeaders()}");

    try {
      var response = await ApiService.deleteData(
          WebServices.notificationDelete, ApiService.getAllHeaders());
      print("Delete Notification Reasponce -${response.body}");
      print(" length before delete ${notificationList.length}");

      CommonFunction.hideLoader();

      var jsonResponse = jsonDecode(response.body);
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("statusCode:-$statusCode");
      print("data:-$data");
      String responseMessage =
          ApiMsgConstant.getResponseMessage(statusCode.toString());

      if (statusCode == 200) {
        notificationList.refresh();
        print("Delete Notifications Success : " + response.body);
        print("Delete notification length ${notificationList.length}");
      }
      return responseMessage;
    } catch (e) {
      print("Catch error $e");
    }
    return ApiMsgConstant.getResponseMessage("500");
  }

  Future<bool> readNotification_api(String notificationId) async {
    CommonFunction.showLoader();
    print("read notification api");
    try {
      var Url =
          "${WebServices.notificationReadStatus}/$notificationId/readStatus";
      var response = await DioServices.putMethod(
        Url,
        {},
        DioServices.getAllHeaders(),
      );
      print("read notification status Response ${response.data}");
      CommonFunction.hideLoader();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode:-$statusCode");
      print("data:-$data");
      if(statusCode == 204){
        CommonFunction.showAlertDialogdelete(Get.context!, "Content is not available", () {
          Get.back();
          notificationList_API(1);
          Get.back();
        });
      }
      if (statusCode == 200) {
        print("Read notification successfully");
        return true;
      }
    } catch (e) {
      print("Catch error $e");
    } finally {
      CommonFunction.hideLoader();
    }
    return false;
  }
}
