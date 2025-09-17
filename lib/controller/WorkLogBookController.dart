import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/Logbook_UserWorkoutList_Model.dart';
import '../models/Logbook_WorkoutType_Model.dart';
import '../network/ApiServices.dart';
import '../network/DioServices.dart';
import '../network/EndPointList.dart';
import '../util/FunctionConstant/FunctionConstant.dart';
import '../util/api_message_constant/ApiMsgConstant.dart';
import '../util/size_config/SizeConfig.dart';

class WorkLogBookController extends GetxController {
  late Rx<double> tv_hours = Rx(0.0);
  late Rx<double> tv_minutes = Rx(0.0);
  late Rx<double> tv_seconds = Rx(0.0);
  late Rx<double> tv_kmeter = Rx(0.0);
  late Rx<double> tv_meter = Rx(0.0);
  var tv_speed = "".obs;
  final RegExp numberRegex = RegExp(r'^[0-9]*$');

  //workout Type dropdown
  var workoutModel = Rxn<LogbookWorkoutTypeModel>();
  var workoutTypeList = <WorkoutType>[].obs;
  var workoutTypeName = "".obs;
  var workoutTypeId = "".obs;
  var workoutId = "".obs;

  //add and edit workout
  var showWorkout = false.obs;
  var typeOfClick = "".obs;
  var selectedWorkout = "".obs;
  var userWorkoutId = "".obs;

  //User workout List
  var userWorkoutModel = Rxn<LogbookUserworkoutListModel>();
  var userWorkoutList = <UserworkoutList>[].obs;

  TextEditingController hours_controller = TextEditingController();
  TextEditingController minutes_controller = TextEditingController();
  TextEditingController second_controller = TextEditingController();
  TextEditingController km_controller = TextEditingController();
  TextEditingController meter_controller = TextEditingController();
  TextEditingController note_controller = TextEditingController();
  // HtmlEditorController note_controller = HtmlEditorController();

  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var fontSize = SizeConfig.fontSize();

  var currentDate = DateTime.now().obs;
  final selectedDay = DateTime.now().obs;
  final focusedDay = DateTime.now().obs;

  var levelTypeNum = "1".obs;
  var checkedValue = true.obs;
  var dropdownValue1 = Rxn<WorkoutType?>();
  var workoutType = "";
  var workoutID = "";

  speed_calculator() {
    if (km_controller.text.isEmpty || km_controller.text.trim() == "0") {
      tv_kmeter.value = double.parse("0.0");
    }
    if (meter_controller.text.isEmpty || meter_controller.text.trim() == "0") {
      tv_meter.value = double.parse("0.0");
    }
    if (hours_controller.text.isEmpty || hours_controller.text.trim() == "0") {
      tv_hours.value = double.parse("0.0");
    }
    if (minutes_controller.text.isEmpty ||
        minutes_controller.text.trim() == "0") {
      tv_minutes.value = double.parse("0.0");
    }
    if (second_controller.text.isEmpty ||
        second_controller.text.trim() == "0") {
      tv_seconds.value = double.parse("0.0");
    }

    if (hours_controller.text.trim().isNotEmpty) {
      tv_hours.value = double.parse(hours_controller.text.trim()) ?? 0;
    }

    if (minutes_controller.text.trim().isNotEmpty) {
      tv_minutes.value = double.parse(minutes_controller.text.trim()) ?? 0;
    }
    if (second_controller.text.trim().isNotEmpty) {
      tv_seconds.value = double.parse(second_controller.text.trim()) ?? 0;
    }

    if (km_controller.text.trim().isNotEmpty) {
      tv_kmeter.value = double.parse(km_controller.text.trim()) ?? 0;
    }

    if (meter_controller.text.trim().isNotEmpty) {
      tv_meter.value = double.parse(meter_controller.text.trim()) ?? 0;
    }

    tv_kmeter.value =
    double.parse("${tv_kmeter.value.toInt()}.${tv_meter.value.toInt()}"); // convert in kilo meter

    print("tv_kmeter.value speed_calculator ${tv_kmeter.value}");
    print("tv_hours.value speed_calculator ${tv_hours.value.toInt()}");
    print("tv_minutes.value speed_calculator ${tv_minutes.value.toInt()}");
    print("tv_seconds.value speed_calculator ${tv_seconds.value.toInt()}");

    var paceCal = CommonFunction.calculatePace(
        tv_kmeter.value,
        tv_hours.value.toInt(),
        tv_minutes.value.toInt(),
        tv_seconds.value.toInt());

    print("paceCal $paceCal");

    var arr = paceCal.split(":");
    if (arr.length == 2){
      if (arr[1].length == 1){
        arr[1] = "0"+ arr[1];
      }
      paceCal = arr[0] + ":" + arr[1];
    }

        tv_speed.value = "$paceCal/KM";
  }

  clearInputs() {
    hours_controller.clear();
    minutes_controller.clear();
    second_controller.clear();
    km_controller.clear();
    meter_controller.clear();
    note_controller.clear();
    levelTypeNum.value = "1";
    tv_speed.value = "0:0";
  }

  void incrementDate() {
    currentDate.value = currentDate.value.add(const Duration(days: 1));
    logbook_userWorkoutList_api(
            DateFormat("yyyy-MM-dd").format(currentDate.value))
        .then((value) {
      if (value != "") {
        print("value userWorkout :- $value");
        userWorkoutModel.value = logbookUserworkoutListModelFromJson(value);
        userWorkoutList.value = userWorkoutModel.value!.data;
      }
    });
  }

  void decrementDate() {
    currentDate.value = currentDate.value.subtract(const Duration(days: 1));
    logbook_userWorkoutList_api(
            DateFormat("yyyy-MM-dd").format(currentDate.value))
        .then((value) {
      if (value != "") {
        print("value userWorkout :- $value");
        userWorkoutModel.value = logbookUserworkoutListModelFromJson(value);
        userWorkoutList.value = userWorkoutModel.value!.data;
      }
    });
  }

  String timeValidation(){

    print("timeValidation");


    if (km_controller.text.isEmpty || km_controller.text.trim() == "0") {
      tv_kmeter.value = double.parse("0.0");
    }
    if (meter_controller.text.isEmpty || meter_controller.text.trim() == "0") {
     tv_meter.value = double.parse("0.0");
    }
    if (hours_controller.text.isEmpty || hours_controller.text.trim() == "0") {
      tv_hours.value = double.parse("0.0");
    }
    if (minutes_controller.text.isEmpty || minutes_controller.text.trim() == "0") {
     tv_minutes.value = double.parse("0.0");
    }
    if (second_controller.text.isEmpty || second_controller.text.trim() == "0") {
     tv_seconds.value = double.parse("0.0");
    }

    if (hours_controller.text.trim().isNotEmpty) {
      tv_hours.value = double.parse(hours_controller.text.trim()) ?? 0;
    }

    if (minutes_controller.text.trim().isNotEmpty) {
      tv_minutes.value = double.parse(minutes_controller.text.trim()) ?? 0;
    }
    if (second_controller.text.trim().isNotEmpty) {
      tv_seconds.value = double.parse(second_controller.text.trim()) ?? 0;
    }

    if (km_controller.text.trim().isNotEmpty) {
      tv_kmeter.value = double.parse(km_controller.text.trim()) ?? 0;
    }

    if (meter_controller.text.trim().isNotEmpty) {
      tv_meter.value = double.parse(meter_controller.text.trim()) ?? 0;
    }

   // tv_kmeter.value = tv_kmeter.value + (tv_meter.value / 1000);
   tv_kmeter.value = double.parse("${tv_kmeter.value.toInt()}.${tv_meter.value.toInt()}");

    print("tv_kmeter.value ${tv_kmeter.value}");
    print("tv_hours.value ${tv_hours.value}");
    print("tv_minutes.value ${tv_minutes.value}");
    print("tv_seconds.value ${tv_seconds.value}");

    var paceCal = CommonFunction.calculatePace(
        tv_kmeter.value, tv_hours.value.round(), tv_minutes.value.round(), tv_seconds.value.round());

    print("paceCal timeValidation $paceCal");

    return paceCal;
  }

  @override
  void onInit() {
    super.onInit();
  }

  //Workout Type list Api
  Future<void> logbook_workoutType_api() async {
    CommonFunction.hideLoader();
    print("Headers:-- ${DioServices.getAllHeaders()}");

    try {
      var response = await DioServices.getMethod(
          WebServices.logbook_workoutType, DioServices.getAllHeaders());
      print("workoutType List Response :-- ${jsonEncode(response.data)}");
      CommonFunction.hideLoader();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode:- $statusCode");
      print("data:- $data");

      if (response.statusCode == 200) {
        workoutModel.value =
            logbookWorkoutTypeModelFromJson(jsonEncode(response.data));
        workoutTypeList.value = workoutModel.value!.data;
      }
    } catch (e) {
      CommonFunction.hideLoader();

      log("Exception :-- ", error: e.toString());
    }
  }

  //User Workout list Api (Date)
  Future<String> logbook_userWorkoutList_api(String date) async {
    CommonFunction.showLoader();
    showWorkout.value=false;
   selectedWorkout.value = "";
    typeOfClick.value = "";
    userWorkoutId.value = "";
    print("Headers:-- ${DioServices.getAllHeaders()}");

    try {
      var url = WebServices.logbook_user_workoutList + "$date";
      print("user workoutType List Url${url}");
      var response =
          await DioServices.getMethod(url, DioServices.getAllHeaders());
      print("user workoutType List Response :-- ${response.data}");
      CommonFunction.hideLoader();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode:- $statusCode");
      print("data:- $data");

      if (response.statusCode == 200) {
        return jsonEncode(response.data);
      }

      return jsonEncode(response.data);
    } catch (e) {
      CommonFunction.hideLoader();
      return "";
      log("Exception :-- ", error: e.toString());
    }
  }

  //Save workout api
  Future<String> logbook_saveWorkout_api(String workoutId, workoutTypeId,
      effortLevel, date, isDistance, distance, time, pace, notes) async {
    CommonFunction.showLoader();
    Map<String, String> body = {
      "workoutId": workoutId,
      "workoutTypeId": workoutTypeId,
      "effortLevel": effortLevel,
      "date": date,
      "isDistance": isDistance,
      "distance": distance,
      "time": time,
      "pace": pace,
      "notes": notes,
    };
    print("logbook_saveWorkout_api Body:-- $body");

    try {
      var response = await DioServices.postMethod(
        WebServices.logbook_save_workout,
        body,
        DioServices.getAllHeaders(),
      );
      print("saveWorkout Reasponce ${response.data}");
      CommonFunction.hideLoader();
      // LocalStorage sp = LocalStorage();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("statusCode:-$statusCode");
      print("data:-$data");
      showWorkout.value=false;
      selectedWorkout.value = "";
      typeOfClick.value = "";
      userWorkoutId.value = "";
      if (statusCode == 200) {
        print("success ");
      }
      return statusCode.toString();
    } catch (e) {
     showWorkout.value=false;
     selectedWorkout.value = "";
     typeOfClick.value = "";
     userWorkoutId.value = "";
      CommonFunction.hideLoader();
      print("Catch error $e");
    }
    return "";
  }

  //Delete Workout
  Future<String> deleteWorkout_Api(BuildContext context,String workoutId) async {

    CommonFunction.showLoader();
    print("workoutId:-- ${workoutId}");
    print("Headers:-- ${ApiService.getAllHeaders()}");

    try {
      var url = "${WebServices.deleteWorkout}$workoutId";
      var response = await ApiService.deleteData(
          url, ApiService.getAllHeaders());
      print("Delete Workout Responce -${response.body}");

      CommonFunction.hideLoader();

      var jsonResponse = jsonDecode(response.body);

      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("statusCode:-$statusCode");
      print("data:-$data");
      String responseMessage =
      ApiMsgConstant.getResponseMessage(statusCode.toString());

      if (statusCode == 200) {
        print("Delete Workout Success : " + response.body);
      }
      return responseMessage;
    } catch (e) {
      print("Catch error $e");
    }
    return ApiMsgConstant.getResponseMessage("500");
  }
}
