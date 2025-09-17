import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/DistanceMeta_Model.dart';
import '../models/PbDistanceMeta_Model.dart';
import '../models/PersonalBest_Model.dart';
import '../network/ApiServices.dart';
import '../network/DioServices.dart';
import '../network/EndPointList.dart';
import '../util/FunctionConstant/FunctionConstant.dart';
import '../util/api_message_constant/ApiMsgConstant.dart';
import '../util/size_config/SizeConfig.dart';

class EditPersonalBestScreenController extends GetxController {
  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var screenWidth = SizeConfig.screenWidth;
  var fontSize = SizeConfig.fontSize();

  var personalBestList = <PersonalBestList>[].obs;
  var personalBestModel = Rxn<PersonalBestModel>();
  var distanceId = "";
  var distanceUnit = "";
  var distanceMetaModel = Rxn<PbDistanceMetaModel>();
  static List<PersonalBestDistanceMeta> distanceMetaListDefault = [];
  var distanceMetaList = <PersonalBestDistanceMeta>[].obs;
  var isFromSubmit = false.obs;
  var distanceKM = "".obs;


  TextEditingController distanceCtrl = TextEditingController();
  TextEditingController hourController = TextEditingController();
  TextEditingController minController = TextEditingController();
  TextEditingController secController = TextEditingController();

  final RegExp numberRegex = RegExp(r'^[0-9]*$');

  var selectedDistance = Rxn<PersonalBestDistanceMeta?>(null);

  @override
  void onInit() {
    // TODO: implement onInit
    WidgetsFlutterBinding.ensureInitialized();
    super.onInit();
  }

  // Delete api
  Future<String> deletepersonalBest_Api(
      BuildContext context, personalBestId) async {
    CommonFunction.showLoader();
    print("Headers:-- ${ApiService.getAllHeaders()}");

    try {
      var url = '${WebServices.personalBest}/$personalBestId';
      print("Url--->$url");
      var response =
          await ApiService.deleteData(url, ApiService.getAllHeaders());

      print("Delete Account Reasponce -${response.body}");
      //CommonFunction.hideLoader();
      var jsonResponse = jsonDecode(response.body);
      var statusCode = jsonResponse["code"];
      print("statusCode:-$statusCode");
      if (statusCode == 200) {
        isFromSubmit.value = true;
        print("Delete Account Success : " + response.body);
      }else{
        CommonFunction.hideLoader();
      }
    } catch (e) {
      CommonFunction.hideLoader();
      print("Catch error $e");
    }
    return ApiMsgConstant.getResponseMessage("500");
  }



  // Edit personal best
  Future<void> editPersonalBest_API() async {
    CommonFunction.showLoader();
    print("Headers:-- ${DioServices.getAllHeaders()}");
    try {
      var url = WebServices.personalBest;
      print("Request URL:-- $url");
      var response =
          await DioServices.getMethod(url, DioServices.getAllHeaders());
      print("personalBest_API Date Response :-- ${response.data}");
      CommonFunction.hideLoader();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode:- $statusCode");
      print("data:-$data");
      if (response.statusCode == 200) {
        personalBestModel.value =
            personalBestModelFromJson(jsonEncode(response.data));
        personalBestList.value = personalBestModel.value!.data.personalBestList;
        print(
            "personalBestList.value :-- " + jsonEncode(personalBestList.value));
        print("personalBestListCount :-- " +
            jsonEncode(personalBestList.value.length));
      }
    } catch (e) {
      CommonFunction.hideLoader();
      log("Exception :-- ", error: e.toString());
    }
  }



  // Get API
  Future<String> PersonalBest_API() async {
    if (isFromSubmit.value) {
      isFromSubmit.value = false;

    } else {
      CommonFunction.showLoader();
    }


    print("Headers:-- ${DioServices.getAllHeaders()}");
    try {
      var url = WebServices.personalBest;
      print("Request URL:-- $url");
      var response =
          await DioServices.getMethod(url, DioServices.getAllHeaders());
      print("PersonalBestList Date Response :-- ${response.data}");
      CommonFunction.hideLoader();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode:- $statusCode");
      print("data:-$data");

      if (response.statusCode == 200) {
        personalBestModel.value =
            personalBestModelFromJson(jsonEncode(response.data));
        personalBestList.value = personalBestModel.value!.data.personalBestList;
        print("personalBestList :-- " +
            jsonEncode(personalBestList.value.length));
        return jsonEncode(response.data);
      }
      return jsonEncode(response.data);
    } catch (e) {
      CommonFunction.hideLoader();
      log("Exception :-- ", error: e.toString());
      return "";
    }
  }



  // Post api
  Future<String> savePersonalBest_api() async {
    CommonFunction.showLoader();
    Map<String, String> body = {
      "distanceId": distanceId,
      "time":
          "${hourController.text.toString() + ":" + minController.text.toString() + ":" + secController.text.toString()}",
    };
    print("Body savePersonalBest_api :-- $body");
    var url = "${WebServices.personalBest}";
    print("url:-- $url");

    try {
      var response =
          await DioServices.postMethod(url, body, DioServices.getAllHeaders());
      //CommonFunction.hideLoader();

      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("statusCode:-$statusCode");
      print("jsonResponse:-$jsonResponse");
      if (statusCode == 200) {
        isFromSubmit.value = true;
        return jsonEncode(response.data);
      } else {
        CommonFunction.hideLoader();
      }
      return jsonEncode(response.data);
    } catch (e) {
      CommonFunction.hideLoader();
      print("Catch error $e");
      return "";
    }
  }



  // Get Meta API
  Future<String> distanceMeta_API() async {
    // CommonFunction.showLoader();
    print("Headers:-- ${DioServices.getAllHeaders()}");
    try {
     // var url = WebServices.distanceMeta;
      var url = WebServices.personalBestdistanceMeta;
      print("Request url-- $url");
      var response = await DioServices.getMethod(url, DioServices.getAllHeaders());
      print("Request distanceMeta_API-- ${jsonEncode(response.data)}");
       CommonFunction.hideLoader();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      if (response.statusCode == 200) {

        distanceMetaModel.value = pbDistanceMetaModelFromJson(jsonEncode(response.data));
        distanceMetaListDefault = distanceMetaModel.value!.data.personalBestDistanceMeta;

        return jsonEncode(response.data);
      }

      return jsonEncode(response.data);
    } catch (e) {
      CommonFunction.hideLoader();
      log("Exception distanceMeta:-- ", error: e.toString());
      return "";
    }
  }
}
