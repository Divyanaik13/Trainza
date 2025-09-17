import 'dart:convert';
import 'dart:developer';
import 'package:club_runner/network/DioServices.dart';
import 'package:club_runner/util/route_helper/RouteHelper.dart';
import 'package:get/get.dart';
import '../models/JoinClub_Model.dart';
import '../network/ApiServices.dart';
import '../network/EndPointList.dart';
import '../util/FunctionConstant/FunctionConstant.dart';
import '../util/local_storage/LocalStorage.dart';

class switchProfileController extends GetxController {

  LocalStorage sp = LocalStorage();
  // JoinClubModule? joinedModule;
  var joinedModule = Rxn<JoinClubModule>();
  var joinClub = [].obs;
  var isMembershipFinal = "";

  // Joined club api
  /*Future<void> joinedClubs_ApiHttp() async {
    print("Headers:-- ${ApiService.getAllHeaders()}");
    CommonFunction.showLoader();
    try {
      var response = await ApiService.getData(
          WebServices.joinedClubs, ApiService.getAllHeaders());
      print("joined Clubs Reasponce ${response.body}");
      CommonFunction.hideLoader();
      log("Rishabh :-- ",error: "here1");
      var jsonResponse = jsonDecode(response.body);
      log("Rishabh :-- ",error: "here");
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode:-$statusCode");

      if (statusCode == 200) {
        joinedModule.value = joinClubModuleFromJson(response.body);
        joinClub.value = joinedModule!.value!.data.joinedClubs;

      }
    } catch (e) {
      CommonFunction.hideLoader();
    log("Exception :-- ",error:  e.toString());
    }
  }*/

  Future<void> joinedClubs_Api() async {
    print("Headers:-- ${DioServices.getAllHeaders()}");
    // CommonFunction.showLoader();
    try {
      var response = await DioServices.getMethod(
          WebServices.joinedClubs+"", DioServices.getAllHeaders());
      print("joined Clubs Response :--  ${response.data}");
      CommonFunction.hideLoader();

      var jsonResponse = response.data;

      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode:-$statusCode");

      if (statusCode == 200) {
        joinedModule.value = joinClubModuleFromJson(jsonEncode(response.data));
        joinClub.value = joinedModule!.value!.data.joinedClubs;

        print("joinClub length :- ${joinClub.value.length}");
      }
    } catch (e) {
      CommonFunction.hideLoader();
      log("Exception :-- ",error:  e.toString());
    }
  }

  // Switch club api
  Future<void> switchClubs_Api(String clubId) async {
    CommonFunction.showLoader();
    Map<String, String> body = {
      "clubId" : clubId,
    };
    print("Headers:-- ${ApiService.getAllHeaders()}");

    try {
      var response = await ApiService.postData(
          WebServices.switchClub,body, ApiService.getAllHeaders(),);
      print("switch Club Reasponce ${response.body}");

      CommonFunction.hideLoader();
      var jsonResponse = jsonDecode(response.body);
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"]["currentClubData"];
      print("statusCode:-$statusCode");
      print("data:-$data");

      if (statusCode == 200) {
        var logo = data["appLogoFilename"];
        var isMembershipExpire = data["isMembershipExpire"];
        var isMembershipActive = data["isMembershipActive"];
        var canViewOtherMembers = data["canViewOtherMembers"];
        var btnBgColor = data["btnBgColor"];
        var btnTxtColor = data["btnTxtColor"];
        var txtColor = data["txtColor"];
        var token = jsonResponse["data"]["token"];

        print("switch Club Success token : " + token.toString());
        print("switch Club Success : " + response.body);
        print("canViewOtherMembers : " + canViewOtherMembers.toString());
        LocalStorage.setStringValue(sp.currentClubData_logo, logo);
        LocalStorage.setStringValue(sp.currentClubData_canViewOtherMembers, canViewOtherMembers.toString());
        LocalStorage.setStringValue(sp.currentClubData_btnBgColor, btnBgColor);
        LocalStorage.setStringValue(sp.currentClubData_btnTxtColor, btnTxtColor);
        LocalStorage.setStringValue(sp.currentClubData_txtColor, txtColor);
        LocalStorage.setStringValue(sp.authToken, token.toString());
        LocalStorage.setStringValue(sp.isMembershipExpire, isMembershipExpire.toString());
        LocalStorage.setStringValue(sp.isMembershipActive, isMembershipActive.toString());

        if (isMembershipExpire == '1' || isMembershipActive == '0'){
          isMembershipFinal = '0';
        }else{
          isMembershipFinal = '1';
        }
        LocalStorage.setStringValue(sp.isMembershipFinal, isMembershipFinal);

        print("Token Switch :- " + LocalStorage.getStringValue(sp.authToken));
        // MyColor.app_orange_color = btnBgColor;
        // MyColor.app_button_text_dynamic_color = btnTxtColor;
        // MyColor.app_text_dynamic_color = txtColor;
        Future.delayed(Duration.zero, () async {
          Get.offAllNamed(RouteHelper.getMainScreen());
        });
      }
    } catch (e) {
      CommonFunction.hideLoader();
      print("Catch error $e");
    }
  }
}