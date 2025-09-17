import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../models/UserProfile_Model.dart';
import '../network/DioServices.dart';
import '../network/EndPointList.dart';
import '../util/FunctionConstant/FunctionConstant.dart';

class ProfileController extends GetxController{

  var profilemodel = Rxn<UserProfileModel>();
  var memberInfo = Rxn<MemberInfo>();
  var personalBests = <PersonalBest>[].obs;
  var eventResults = <EventResult>[].obs;
  var showAll = false.obs;
  var profileImage = "".obs;
  var phoneNumber = "".obs;
  var maskFormatter = Rxn<MaskTextInputFormatter>();

//Get Profile APi
  Future<String> userProfile_api(String memberId) async {
    CommonFunction.showLoader();
    print("Headers:-- ${DioServices.getAllHeaders()}");
    var query = "?memberId=$memberId";
    print("query :-- $query");
    try {
      var response = await DioServices.getMethod(
          "${WebServices.userprofile}$query", DioServices.getAllHeaders());
      print("userProfile Response :-- ${jsonEncode(response.data)}");
      CommonFunction.hideLoader();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode:- $statusCode");
      print("data:- $data");

      if (response.statusCode == 200) {

      }
      return jsonEncode(response.data);
    } catch (e) {
      CommonFunction.hideLoader();

      log("Exception :-- ", error: e.toString());
      return "";
    }
  }
}