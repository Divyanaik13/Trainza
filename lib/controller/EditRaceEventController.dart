import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/ResultDetail_Model.dart';
import '../network/ApiServices.dart';
import '../network/DioServices.dart';
import '../network/EndPointList.dart';
import '../util/FunctionConstant/FunctionConstant.dart';
import '../util/api_message_constant/ApiMsgConstant.dart';
import '../util/size_config/SizeConfig.dart';

class EditRaceEventController extends GetxController{
  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var screenWidth = SizeConfig.screenWidth;
  var fontSize = SizeConfig.fontSize();

  final RegExp numberRegex = RegExp(r'^[0-9]*$');

  TextEditingController distanceCtrl = TextEditingController();
  TextEditingController hourController = TextEditingController();
  TextEditingController minController = TextEditingController();
  TextEditingController secController = TextEditingController();

  var resultDetailModel = Rxn<ResultDetailModel>();
  var selectedDistance = Rxn<Distance>();
  var editDistanceId = "".obs;
  var distance = "".obs;
  var distanceUnit = "".obs;

  List<String> distances = ['Select Distance', '5', '10', '21.1', '42.2'].obs;
  List<String> spinnerItems1 = [
    'Select Distance',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
  ].obs;

  Future<String> resultDetail_API(String resultId) async {
    CommonFunction.showLoader();
    print("Headers:-- ${DioServices.getAllHeaders()}");

    try {
      var url =
          "${WebServices.resultDetail}/$resultId";
      print("Request URL:-- $url");
      var response =
      await DioServices.getMethod(url, DioServices.getAllHeaders());
      print("resultDetail Response :-- ${response.data}");
      CommonFunction.hideLoader();
      //  pageLoader.value =false;
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode resultDetail:- $statusCode");
      print("data resultDetail:-${jsonEncode(data)}");

      if (response.statusCode == 200) {
        resultDetailModel.value = resultDetailModelFromJson(jsonEncode(data));
        //eventDistanceData.value = eventDistanceDataModel.value!.eventsDistanceData;

        resultDetailModel.refresh();
        selectedDistance.refresh();

        return jsonEncode(data);

      }
      return jsonEncode(data);
    } catch (e) {
      CommonFunction.hideLoader();
      // pageLoader.value =false;
      log("Exception :-- ", error: e.toString());
      return "";
    }
  }

  Future<String> deleteEventRaceResult_Api(BuildContext context,String resultId) async {

    CommonFunction.showLoader();

    print("Headers:-- ${ApiService.getAllHeaders()}");
    print("Url:-- ${WebServices.deleteEventresult}$resultId");

    try {
      var response = await ApiService.deleteData(
          "${WebServices.deleteEventresult}$resultId", ApiService.getAllHeaders());
      print("Delete EventRaceResult Responce -${response.body}");

      CommonFunction.hideLoader();

      var jsonResponse = jsonDecode(response.body);

      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("statusCode:-$statusCode");
      print("data:-$data");
      String responseMessage =
      ApiMsgConstant.getResponseMessage(statusCode.toString());

      if (statusCode == 200) {
        print("Delete EventRaceResult Success : " + response.body);
        Get.back(result:"refresh");

       // Get.toNamed(RouteHelper.getWelcomeScreen());
      }
      return responseMessage;
    } catch (e) {
      print("Catch error $e");
    }
    return ApiMsgConstant.getResponseMessage("500");
  }

  Future<String> Event_addResults_api(String eventId, distanceId, time, pace,
      eventResultId) async {
   CommonFunction.showLoader();
    Map<String, String> body = {
      "distanceId": distanceId,
      "time": time,
      "pace": pace,
      "eventResultId": eventResultId,
    };
    print("Body:-- $body");
    var url = "${WebServices.event}/$eventId/result";
    print("url:-- $url");

    try {
      var response =
      await DioServices.postMethod(url, body, DioServices.getAllHeaders());

      CommonFunction.hideLoader();

      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("statusCode:-$statusCode");
      print("jsonResponse Event_addResults_api:-$jsonResponse");

      if (statusCode.toString() == "200") {

        return jsonEncode(response.data);
      }
      return jsonEncode(response.data);
    } catch (e) {
      CommonFunction.hideLoader();
      print("Catch error $e");
      return "";
    }
  }
}