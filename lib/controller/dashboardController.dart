import 'dart:convert';
import 'dart:developer';
import 'package:club_runner/network/DioServices.dart';
import 'package:club_runner/util/const_value/ConstValue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../models/ClubListModel.dart';
import '../models/Invitation_model.dart';
import '../network/ApiServices.dart';
import '../network/EndPointList.dart';
import '../util/FunctionConstant/FunctionConstant.dart';
import '../util/api_message_constant/ApiMsgConstant.dart';
import '../util/custom_view/CustomView.dart';
import '../util/local_storage/LocalStorage.dart';
import '../util/my_color/MyColor.dart';
import '../util/route_helper/RouteHelper.dart';
import '../util/size_config/SizeConfig.dart';
import '../util/text_style/MyTextStyle.dart';
import 'MainScreenController.dart';
import 'SwitchProfileController.dart';

class DeshboardController extends GetxController {
  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var invitation = Rxn<InvitationListApi>();
  var invitationsList = [].obs;
  var clubListModel = Rxn<ClubListModel>();
  var clubList = [].obs;
  var isLoading = true.obs;
  var loadMore = false.obs;
  var pageLoader = false.obs;
  switchProfileController sp_Controller = Get.put(switchProfileController());

  LocalStorage sp = LocalStorage();
  MainScreenController msc = Get.find();
  var clubLogo = "".obs;
  var img = "";
  var firstName = "";
  var lastName = "";
  var dialCode = "";
  var phoneNumber = "";
  var email = "";
  var isMembershipActive = "";
  var isMembershipExpire = "";
  var isMembershipFinal = "".obs;
  bool isRemember = false;
  String emailRemember = "",
      passRemember = "",
      deviceId = "",
      deviceType = "",
      deviceToken = "",
      dialCodeReminder = "",
      phoneReminder = "",
      signupType = "",
      loginType = "",
      countryNameReminder = "",
      countryCodeReminder = "",
      countryFlagReminder = "",
      dynamicBgColor = "",
      dynamicButtonTextColor = "",
      dynamicTextColor = "",
      appleFirstName = "",
      appleLastName = "",
      appleEmail = "",
      appleId = "",
      currentClubData_canViewOtherMembers = "";

  //Alert Dialogue
  Future<dynamic> showAlertDialog(BuildContext context, mainMSG) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)), //this right here
            child: Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.cancel)),
                    ),
                    Text("ALERT!",
                        style: MyTextStyle.textStyle(
                            FontWeight.w600,
                            22,
                            MyColor.app_orange_color.value ??
                                Color(0xFFFF4300))),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        mainMSG,
                        style: MyTextStyle.black_text_welcome_msg_style(
                            FontWeight.w400, 17),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomView.buttonShow("OK", FontWeight.w300, 5, 16.8,
                        MyColor.app_orange_color.value ?? Color(0xFFFF4300),
                        () {
                      logout_Api();
                    }),
                  ],
                ),
              ),
            ),
          );
        });
  }

  //Invitation Api function
  Future<void> invitation_Api() async {
    invitationsList.refresh();
    invitation.refresh();
    CommonFunction.showLoader();
    print("Headers:-- ${DioServices.getAllHeaders()}");

    try {
      var response = await DioServices.getMethod(
          WebServices.invitation, DioServices.getAllHeaders());
      print("invitation_Api 1 Response :-- ${response.data}");
      CommonFunction.hideLoader();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode:- $statusCode");
      print("data:-$data");
      if (statusCode == 200) {
        invitation.value = invitationListApiFromJson(jsonEncode(response.data));
        invitationsList.value = invitation.value!.data.invitationsList;
        isLoading.value = false;
        print("invitationsList :-- $invitationsList");
      }
    } catch (e) {
      CommonFunction.hideLoader();
      log("Exception :-- ", error: e.toString());
    }
  }

//Accept Invitation Api function
  Future<void> acceptInvitation_Api(String ID) async {
    CommonFunction.showLoader();
    Map<String, String> body = {
      "invitationId": ID,
    };
    print("Body acceptInvitation_Api:-- $body");

    try {
      var response = await DioServices.postMethod(
        WebServices.acceptInvitation,
        body,
        DioServices.getAllHeaders(),
      );
      print("acceptInvitation_Api Response ${response.data}");
      CommonFunction.hideLoader();
      LocalStorage sp = LocalStorage();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("statusCode:-$statusCode");
      print("invitationId : $ID");

      if(statusCode == 158){
        CommonFunction.showAlertDialogdelete(Get.context!, "Invitation expired", () {
          Get.back();
          invitation_Api();
          Get.back();
        });
      }

      if (statusCode == 200) {
        print("Invitation Successfully accepted");
        invitationsList.clear();
        invitation.refresh();
        invitationsList.refresh();
        sp_Controller.joinedClubs_Api();

        if (data.containsKey("currentClubData") && data["currentClubData"] != null)  {
          var currentClubData = jsonResponse["data"]["currentClubData"] ?? "";
          var logo = currentClubData["appLogoFilename"] ?? "";
          var btnBgColor = currentClubData["btnBgColor"] ?? "";
          var btnTxtColor = currentClubData["btnTxtColor"] ?? "";
          var txtColor = currentClubData["txtColor"] ?? "";
          var canViewOtherMembers = currentClubData["canViewOtherMembers"] ?? "";
          var isMembershipExpire = currentClubData["isMembershipExpire"].toString() ?? "";
          var isMembershipActive = currentClubData["isMembershipActive"].toString() ?? "";
          var token = jsonResponse["data"]["token"];

          print("currentClubData : $currentClubData");
          print("canViewOtherMembers : $canViewOtherMembers");
          LocalStorage.setStringValue(sp.currentClubData_logo, logo);
          LocalStorage.setStringValue(sp.currentClubData_canViewOtherMembers, canViewOtherMembers.toString());
          LocalStorage.setStringValue(sp.currentClubData_btnBgColor, btnBgColor);
          LocalStorage.setStringValue(sp.currentClubData_btnTxtColor, btnTxtColor);
          LocalStorage.setStringValue(sp.currentClubData_txtColor, txtColor);
          LocalStorage.setStringValue(sp.isMembershipExpire, isMembershipExpire);
          LocalStorage.setStringValue(sp.isMembershipActive, isMembershipActive);

          if (isMembershipExpire != 'null' || isMembershipActive != 'null'){
            if (isMembershipExpire == '1' || isMembershipActive == '0') {
              isMembershipFinal.value = '0';
            } else {
              isMembershipFinal.value = '1';
            }
          }else{
            isMembershipFinal.value = '0';
          }

          LocalStorage.setStringValue(sp.isMembershipFinal, isMembershipFinal.value);

          print("isMembershipFinal accept ${LocalStorage.getStringValue(sp.isMembershipFinal)}");

          LocalStorage.setStringValue(sp.authToken, token);

          var dynamicBgColor =
              LocalStorage.getStringValue(sp.currentClubData_btnBgColor) == ""
                  ? "FF4300"
                  : LocalStorage.getStringValue(sp.currentClubData_btnBgColor);
          var dynamicButtonTextColor =
              LocalStorage.getStringValue(sp.currentClubData_btnTxtColor) == ""
                  ? "FFFFFF"
                  : LocalStorage.getStringValue(sp.currentClubData_btnTxtColor);
          var dynamicTextColor =
              LocalStorage.getStringValue(sp.currentClubData_txtColor) == ""
                  ? "FF4300"
                  : LocalStorage.getStringValue(sp.currentClubData_txtColor);
          print("bGColor:--  ${dynamicBgColor.replaceAll("#", "")}");

          MyColor.app_orange_color.value =
              Color(int.parse('0xFF${dynamicBgColor.replaceAll("#", "")}'));

          MyColor.app_button_text_dynamic_color = Color(
              int.parse('0xFF${dynamicButtonTextColor.replaceAll("#", "")}'));
          MyColor.app_text_dynamic_color = Color(int.parse('0xFF${dynamicTextColor.replaceAll("#", "")}'));
          clubLogo.value = LocalStorage.getStringValue(sp.currentClubData_logo);
          img = LocalStorage.getStringValue(sp.userprofilePicture);
          firstName = LocalStorage.getStringValue(sp.userfirstName);
          lastName = LocalStorage.getStringValue(sp.userlastName);
        }
        callback();
        return response.data;
      }
    } catch (e) {
      CommonFunction.hideLoader();
      print("Catch error acceptInvitation $e");
    }
  }

//Decline Invitation Api function
  Future<void> declineInvitation_Api(String ID) async {
    CommonFunction.showLoader();
    Map<String, String> body = {
      "invitationId": ID,
    };

    try {
      var response = await DioServices.postMethod(
        WebServices.declineInvitation,
        body,
        ApiService.getAllHeaders(),
      );
      print("invitation Reasponce ${response.data}");
      CommonFunction.hideLoader();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];

      print("statusCode:-$statusCode");
      print("decline invitationId :-$ID");

      if(statusCode == 158){
        CommonFunction.showAlertDialogdelete(Get.context!, "Invitation expired", () {
          Get.back();
          invitation_Api();
          Get.back();
        });
      }

      if (statusCode == 200) {
        invitation_Api();
        return response.data;
      }
    } catch (e) {
      CommonFunction.hideLoader();
      print("Catch error $e");
    }
  }

  // Logout api post method
  Future<void> logout_Api() async {
    CommonFunction.showLoader();
    print("logout api");
    Map<String, String> body = {};
    print("Body:-- $body");
    try {
      var response = await DioServices.postMethod(
          WebServices.logout, body, DioServices.getAllHeaders());
      CommonFunction.hideLoader();

      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("statusCode:-$statusCode");
      print("jsonResponse:-$jsonResponse");

      if (statusCode == 200) {
        print("logout successfully");
        LocalStorage.clearLocalStorage();
        LocalStorage.setBoolValue(sp.isRemember, isRemember);
        LocalStorage.setStringValue(sp.loginTypeRemember, loginType == "2" ? "false" : "true");
        LocalStorage.setStringValue(sp.emailRemember, emailRemember);
        LocalStorage.setStringValue(sp.phoneReminder, phoneReminder);
        LocalStorage.setStringValue(sp.dialcodeReminder, dialCodeReminder);
        LocalStorage.setStringValue(sp.countryname, countryNameReminder);
        LocalStorage.setStringValue(sp.countryflag, countryFlagReminder);
        LocalStorage.setStringValue(sp.countrycode, countryCodeReminder);
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

        print(
            "deviceId get after logout : ${LocalStorage.getStringValue(sp.deviceId)}");
        print(
            "deviceType get after logout : ${LocalStorage.getStringValue(sp.deviceType)}");
        print(
            "deviceToken get after logout : ${LocalStorage.getStringValue(sp.deviceToken)}");
        print("loginTypeRemember : " +
            LocalStorage.getStringValue(sp.loginTypeRemember));
        print("appleFirstName logout: " +
            LocalStorage.getStringValue(sp.appleFirstName));
        print(
            "appleLastName : " + LocalStorage.getStringValue(sp.appleLastName));
        print("appleEmail : " + LocalStorage.getStringValue(sp.appleEmail));
        print("appleId : " + LocalStorage.getStringValue(sp.appleId));
        Get.offAllNamed(RouteHelper.welcomeScreen);
      }
    } catch (e) {
      CommonFunction.hideLoader();
      print("Catch error $e");
    }
  }

  // Change club data
  Future<void> changeClubData() async {
    print("Change Club data");
    print("Headers:-- ${DioServices.getAllHeaders()}");
    //  CommonFunction.showLoader();
    try {
      var response = await DioServices.getMethod(
          WebServices.changeclubdata, DioServices.getAllHeaders());

      print("Clubs Response :--  ${response.data}");

      //  CommonFunction.hideLoader();

      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"]["currentClubData"];

      print("statusCode:-$statusCode");
      print("data club :- $data");

      if (statusCode == 200) {
        print("API successfull");
        var token = jsonResponse["data"]["token"];
        var havePassword = jsonResponse["data"]["havePassword"].toString()??"";

        if(data!=null&&data!="null"){
          var logo = data["appLogoFilename"];
          var canViewOtherMembers = data["canViewOtherMembers"];
          var notificationUnreadCount = data["notificationUnreadCount"];
          var btnBgColor = data["btnBgColor"];
          var btnTxtColor = data["btnTxtColor"];
          var txtColor = data["txtColor"];
          String isMembershipExpire = data["isMembershipExpire"].toString() ?? "";
          String isMembershipActive = data["isMembershipActive"].toString() ?? "";
          print("logo : " + logo);
          print("havePassword : " + havePassword);
          print("isMembershipExpire : " + isMembershipExpire);
          print("isMembershipActive : " + isMembershipActive);
          print("btnBgColor : " + btnBgColor);
          print("btnTxtColor : " + btnTxtColor);
          print("notificationUnreadCount : " + notificationUnreadCount.toString());

          LocalStorage.setStringValue(sp.currentClubData_logo, logo);
          LocalStorage.setStringValue(sp.notificationUnreadCount, notificationUnreadCount.toString());
          LocalStorage.setStringValue(sp.currentClubData_canViewOtherMembers, canViewOtherMembers.toString());
          LocalStorage.setStringValue(sp.currentClubData_btnBgColor, btnBgColor);
          LocalStorage.setStringValue(sp.currentClubData_btnTxtColor, btnTxtColor);
          LocalStorage.setStringValue(sp.currentClubData_txtColor, txtColor);
          LocalStorage.setStringValue(sp.isMembershipExpire, isMembershipExpire.toString());
          LocalStorage.setStringValue(sp.isMembershipActive, isMembershipActive.toString());
          if (isMembershipExpire.toString() != 'null' || isMembershipActive.toString() != 'null'){
            if (isMembershipExpire.toString() == '1' || isMembershipActive.toString() == '0') {
              print("isMembershipFinal 0");
              isMembershipFinal.value = '0';
            } else {
              print("isMembershipFinal 1");
              isMembershipFinal.value = '1';
            }
          }else{
            isMembershipFinal.value = '0';
          }

          LocalStorage.setStringValue(sp.isMembershipFinal, isMembershipFinal.value);

          if (isMembershipFinal.value == "1") {
            print("selectedTab 0");
             ConstValue.isActive = "1";
           // msc.selectedTab.value = 0;
           // Get.offAllNamed(RouteHelper.getMainScreen());
          }
        }else{
          LocalStorage.setStringValue(sp.notificationUnreadCount, "");
        }

        LocalStorage.setStringValue(sp.authToken, token.toString());
        LocalStorage.setStringValue(sp.havePassword, havePassword.toString());
        getValue();

        print("Token Switch :- " + LocalStorage.getStringValue(sp.isMembershipFinal));
      }
    } catch (e) {
      CommonFunction.hideLoader();
      log("Exception  changeClubData:-- ", error: e.toString());
    }
  }

  Future<void> callback() async {
    print("callback");
    changeClubData();
    invitation_Api();
    sp_Controller.joinedClubs_Api();
  }

  void getValue() {
    currentClubData_canViewOtherMembers = LocalStorage.getStringValue(sp.currentClubData_canViewOtherMembers);
    ConstValue.notificationUnreadCount.value = LocalStorage.getStringValue(sp.notificationUnreadCount);
    isRemember = LocalStorage.getBoolValue(sp.isRemember);
    signupType = LocalStorage.getStringValue(sp.signupType);
    loginType = LocalStorage.getStringValue(sp.loginTypeRemember);
    emailRemember = LocalStorage.getStringValue(sp.emailRemember);
    dialCodeReminder = LocalStorage.getStringValue(sp.dialcodeReminder);
    countryNameReminder = LocalStorage.getStringValue(sp.countryname);
    countryCodeReminder = LocalStorage.getStringValue(sp.countrycode);
    countryFlagReminder = LocalStorage.getStringValue(sp.countryflag);
    phoneReminder = LocalStorage.getStringValue(sp.phoneReminder);
    passRemember = LocalStorage.getStringValue(sp.passwordRemember);
    deviceId = LocalStorage.getStringValue(sp.deviceId);
    deviceType = LocalStorage.getStringValue(sp.deviceType);
    deviceToken = LocalStorage.getStringValue(sp.deviceToken);
    isMembershipActive = LocalStorage.getStringValue(sp.isMembershipActive);
    isMembershipExpire = LocalStorage.getStringValue(sp.isMembershipExpire);
    clubLogo.value = LocalStorage.getStringValue(sp.currentClubData_logo);
    print("isMembershipActive get values :---- $isMembershipActive");
    print("isMembershipExpire get values :---- $isMembershipExpire");
    if (isMembershipExpire.toString() != 'null' || isMembershipActive.toString() != 'null'){
      if (isMembershipExpire.toString() == '1' || isMembershipActive.toString() == '0') {
        print("isMembershipFinal 0");
        isMembershipFinal.value = '0';
      } else {
        print("isMembershipFinal 1");
        isMembershipFinal.value = '1';
      }
    }else{
      isMembershipFinal.value = '0';
    }

    LocalStorage.setStringValue(sp.isMembershipFinal, isMembershipFinal.value);

    dynamicBgColor = LocalStorage.getStringValue(sp.currentClubData_btnBgColor) == ""
            ? "FF4300"
            : LocalStorage.getStringValue(sp.currentClubData_btnBgColor);
    dynamicButtonTextColor = LocalStorage.getStringValue(sp.currentClubData_btnTxtColor) == ""
            ? "FFFFFF"
            : LocalStorage.getStringValue(sp.currentClubData_btnTxtColor);
    dynamicTextColor =
        LocalStorage.getStringValue(sp.currentClubData_txtColor) == ""
            ? "FF4300"
            : LocalStorage.getStringValue(sp.currentClubData_txtColor);

    appleFirstName = LocalStorage.getStringValue(sp.appleFirstName);
    appleLastName = LocalStorage.getStringValue(sp.appleLastName);
    appleEmail = LocalStorage.getStringValue(sp.appleEmail);
    appleId = LocalStorage.getStringValue(sp.appleId);

    print("bGColor:--  ${dynamicBgColor.replaceAll("#", "")}");

    MyColor.app_orange_color.value =
        Color(int.parse('0xFF${dynamicBgColor.replaceAll("#", "")}'));

    MyColor.app_button_text_dynamic_color =
        Color(int.parse('0xFF${dynamicButtonTextColor.replaceAll("#", "")}'));
    MyColor.app_text_dynamic_color =
        Color(int.parse('0xFF${dynamicTextColor.replaceAll("#", "")}'));

    // Color(int.parse('0xFF${"E7E7E7"}'));
    print("dynamicTextColor:--  ${dynamicTextColor.replaceAll("#", "")}");

    print("deviceId ${deviceId}");
    print("deviceType ${deviceType}");
    print("deviceToken ${deviceToken}");
    print("dialcodeReminder ${dialCodeReminder}");
    print("countrynameReminder ${countryNameReminder}");
    print("countrycodeReminder ${countryCodeReminder}");
    print("countryflagReminder ${countryFlagReminder}");
    print("phoneReminder ${phoneReminder}");
    print("loginType ${loginType}");
    print("appleFirstName ${appleFirstName}");
    print("appleLastName ${appleLastName}");
    print("appleEmail ${appleEmail}");
    print("appleId ${appleId}");
    print("isMembershipFinal get values :---- ${isMembershipFinal.value}");
    print("notificationUnreadCount.value :---- ${ConstValue.notificationUnreadCount.value}");
  }

  Future<void> clubListApi(String pageNo, String search) async {
    if (pageNo == "0" || pageNo == "1") {
      clubListModel.refresh();
      clubList.refresh();
      clubList.clear();
      CommonFunction.showLoader();
    } else {
      pageLoader.value = true;
    }

    try {
      var response = await DioServices.getMethod(
          "${WebServices.clubList}?pageNo=$pageNo&search=$search", DioServices.getAllHeaders());
      print("clubListApi 1 Response :-- ${response.data}");
      pageLoader.value = false;
      CommonFunction.hideLoader();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("clubListApi statusCode:- $statusCode");
      print("clubListApi data:-${jsonEncode(data)}");
      if (statusCode == 200) {
        clubListModel.value = clubListModelFromJson(jsonEncode(data));
        //clubList.value = clubListModel.value!.clubs;
        clubList.addAll(clubListModel.value!.clubs);
        loadMore.value = clubListModel.value!.loadMore;

        clubListModel.refresh();
        clubList.refresh();
        // isLoading.value = false;
        print("clubList :-- " + clubList.value.toString());
      }
    } catch (e) {
      pageLoader.value = false;
      CommonFunction.hideLoader();
      log("Exception clubListApi:-- ", error: e.toString());
    }
  }

  Future<void> memberJoinRequestApi(String brandId) async {
    CommonFunction.showLoader();
    Map<String, String> body = {
      "brandId": brandId,
    };
    print("Body memberJoinRequestApi:-- $body");

    try {
      var response = await DioServices.postMethod(
        WebServices.memberJoinRequest,
        body,
        DioServices.getAllHeaders(),
      );
      print("memberJoinRequestApi Reasponce ${response.data}");
      CommonFunction.hideLoader();
      LocalStorage sp = LocalStorage();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("memberJoinRequestApi statusCode:-$statusCode");
      print("brandId : $brandId");

      if (statusCode == 200) {
        print("memberJoinRequestApi Successfully");
        clubListApi("1", "");
        return response.data;
      }
    } catch (e) {
      CommonFunction.hideLoader();
      print("Catch error acceptInvitation $e");
    }
  }

  Future<String> cancelJoinRequest(String requestId) async {
    print("Headers:-- ${ApiService.getAllHeaders()}");
    CommonFunction.showLoader();
    try {
      var response = await ApiService.deleteData(
          "${WebServices.cancelJoinRequest}/$requestId", ApiService.getAllHeaders());
      CommonFunction.hideLoader();
      print("cancelJoinRequest Response -${response.body}");
      var jsonResponse = jsonDecode(response.body);
      var statusCode = jsonResponse["code"];
      print("statusCode:-$statusCode");
      if (statusCode == 200) {
        print("cancelJoinRequest Success : " + response.body);
        clubListApi("1", "");
      }
    } catch (e) {
      CommonFunction.hideLoader();
      print("Catch error $e");
    }
    return ApiMsgConstant.getResponseMessage("500");
  }

}
