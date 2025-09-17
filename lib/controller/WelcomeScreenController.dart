import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:club_runner/network/DioServices.dart';
import 'package:club_runner/network/EndPointList.dart';
import 'package:club_runner/util/FunctionConstant/FunctionConstant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../models/Login_Model.dart';
import '../util/api_message_constant/ApiMsgConstant.dart';
import '../util/asstes_image/AssetsImage.dart';
import '../util/custom_view/CustomView.dart';
import '../util/custom_view/SocialCustomView.dart';
import '../util/local_storage/LocalStorage.dart';
import '../util/masking_string_constant/MaskingStringConstant.dart';
import '../util/my_color/MyColor.dart';
import '../util/route_helper/RouteHelper.dart';
import '../util/size_config/SizeConfig.dart';
import '../util/string_const/MyString.dart';
import '../util/text_style/MyTextStyle.dart';
import 'package:http/http.dart' as http;

class WelcomeScreenController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  LocalStorage sp = LocalStorage();
  var fontSize = SizeConfig.fontSize();
  var checked = false.obs;
  var loginType = true.obs;
  //late Rx<Country?> selectedCountry;
  var selectedCountry = Rxn<Country?>();
  Rx<String> defaultCountryCode = Rx("");
  var passwordVisible = false.obs;
  var isError = 0.obs;
  var errorMessage1 = "".obs;
  var errorMessage2 = "".obs;

  //For number Masking
  var maskFormatter = Rxn<MaskTextInputFormatter>();


  void clear() {
    emailController.clear();
    phoneController.clear();
    passController.clear();
    isError.value = 0;
  }

/*  void initCountry(BuildContext context) async {
    // final country = await getDefaultCountry(context);
    if(LocalStorage.getStringValue(sp.countryname) != "") {

      Country? country = await getCountryByCountryCode(context, LocalStorage.getStringValue(sp.countrycode));
      selectedCountry.value = country;
      defaultCountryCode.value = country!.dialCode;

    }else{
    Country? country = await getCountryByCountryCode(context, 'ZA');
    selectedCountry.value = country;
    defaultCountryCode.value = country!.dialCode;
    }
  }*/

  void initCountry(BuildContext context) async {
    // final String savedCountryCode = LocalStorage.getStringValue(sp.countrycode);
    // final String defaultCountryCode = savedCountryCode.isNotEmpty ? savedCountryCode : 'ZA';

    // Find the country from the intl_phone_field's Countries list
    final Country? country = countries.firstWhere(
          (c) => c.code == defaultCountryCode,
      orElse: () => countries.firstWhere((c) => c.code == 'ZA'), // Fallback to South Africa
    );

    if (country != null) {
      selectedCountry.value = country;
      defaultCountryCode.value = country.dialCode;
    } else {
      // Handle the case where the country is not found, if needed
      print('Country not found for code: $defaultCountryCode');
    }
  }

  @override
  void onInit() {
    // initCountry(Get.context!);
    super.onInit();
  }

  Widget checkBox(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      side: BorderSide(color: MyColor.app_white_color),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: checked.value,
                      onChanged: (newValue) {
                        checked.value = newValue!;
                      },
                      checkColor: MyColor.screen_bg,
                      fillColor: MaterialStateProperty.all(checked.value
                          ? MyColor.app_white_color
                          : MyColor.screen_bg),
                    ),
                  ),
                  const SizedBox(
                      width: 5.0), // Add some space between checkbox and text
                  Text(
                    MyString.remember_var,
                    style: MyTextStyle.textStyle(
                        FontWeight.w400, 12, MyColor.app_white_color),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  Get.toNamed(RouteHelper.forgotPasswordScreen);
                  CommonFunction.keyboardHide(context);
                  if(checked==false){
                    clear();
                  }
                },
                child: Text(
                  MyString.forgot_pass_var,
                  style: MyTextStyle.textStyle(
                      FontWeight.w400, 12, MyColor.app_white_color),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget socialLogin(BuildContext context) {
    return Padding(
      padding: Platform.isAndroid
          ? EdgeInsets.symmetric(horizontal: 50)
          : EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: CustomView.socialButton(
                MyAssetsImage.app_google_logo, 26.0, 26.0, () {
              print("Google");
              signInWithGoogle();
              CommonFunction.keyboardHide(context);
              isError.value = 0;
            }),
          ),
          Platform.isIOS
              ? Expanded(
                  flex: 1,
                  child: CustomView.socialButton(
                      MyAssetsImage.app_apple_logo, 21.0, 26.0, () {
                    signInWithApple();
                    CommonFunction.keyboardHide(context);
                    isError.value = 0;
                    print("Apple");
                  }),
                )
              : Container(),
          Expanded(
            flex: 1,
            child: CustomView.socialButton(
                MyAssetsImage.app_twitter_logo, 21.0, 26.0, () {
              print("Twitter");
              signInWithTwitter();
              CommonFunction.keyboardHide(context);
              isError.value = 0;
            }),
          ),
        ],
      ),
    );
  }

  Future<bool> validation(BuildContext context) async {
    if (loginType == true.obs && emailController.text.trim().isEmpty) {
      isError.value = 1;
      errorMessage1.value = "Please input an ";
      errorMessage2.value = "email address";
    } else if (loginType == true.obs && !emailController.text.trim().isEmail) {
      isError.value = 2;
      errorMessage1.value = "Please input a ";
      errorMessage2.value = "valid email address";
    } else if (loginType == false.obs && phoneController.text.trim().isEmpty) {
      isError.value = 3;
      errorMessage1.value = "Please input a ";
      errorMessage2.value = "mobile number";
    } else if (loginType == false.obs &&
        !await CommonFunction.getPhoneNumberValidation(
            phoneController.text.trim().replaceAll("-", "").toString(),
            selectedCountry.value?.code)) {
      print("phoneController : ${phoneController.text.trim().replaceAll("-", "")}");
      isError.value = 4;
      errorMessage1.value = "Please input a ";
      errorMessage2.value = "valid mobile number";
    } else if (passController.text.trim().isEmpty) {
      isError.value = 5;
      errorMessage1.value = "Please input a ";
      errorMessage2.value = "password";
    } else {
      return true;
    }
    return false;
  }

  void onPressed() async {
    Country country = await Get.toNamed(RouteHelper.getCountryPickerScreen());

    if (country != null) {
      selectedCountry.value = country;
      defaultCountryCode.value = selectedCountry.value!.code;
      phoneController.text = "";
      print("Selected Code " + selectedCountry.value.toString());
      String maskPattern = PhoneNumberMask.getMaskPattern("+${selectedCountry.value!.dialCode}");
    maskFormatter.value =  MaskTextInputFormatter(
        // mask: '+# (###) ###-##-##',
          mask: maskPattern,
          filter: { "#": RegExp(r'[0-9]') },
          type: MaskAutoCompletionType.lazy
      );

    }
  }


  Future<void> loginAPi(BuildContext context, loginWith, email, phoneDialCode,countryname,countrycode,countryflag,
      phoneNumber, password) async {
    CommonFunction.showLoader();
    Map<String, String> body = {
      "loginWith": loginWith,
      "email": email,
      "phoneDialCode": phoneDialCode,
      "phoneNumber": phoneNumber,
      "password": password
    };

    print("formData:-- $body");

    Map<String, String> headers = await DioServices.getDefaultHeader();

    try {

      var response = await DioServices.postMethod(
          WebServices.login, body, headers);

      print("Login Response :- ${response.data}");

      CommonFunction.hideLoader();

      // var jsonResponse = jsonDecode(response.data);
      var jsonResponse = response.data;

      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("statusCode:-$statusCode");
      print("data:-$data");

      if (statusCode == 200) {
        LoginModel logindata = loginModelFromJson(jsonEncode(response.data));

          print("Login logindata : " + logindata.data.toString());
          LocalStorage.setStringValue(sp.signupType, logindata.data.signupType);
          LocalStorage.setStringValue(sp.authToken, logindata.data.token);
          LocalStorage.setStringValue(sp.userfirstName, logindata.data.firstName);
          LocalStorage.setStringValue(sp.userlastName, logindata.data.lastName);
          LocalStorage.setStringValue(sp.useremail, logindata.data.email);
          LocalStorage.setStringValue(sp.isEmailPubliclyShared, logindata.data.isEmailPubliclyShared.toString());
          LocalStorage.setStringValue(sp.isNumberPubliclyShared, logindata.data.isNumberPubliclyShared.toString());
          LocalStorage.setStringValue(sp.userprofilePicture, logindata.data.profilePicture);
          LocalStorage.setStringValue(sp.phoneDialCode, logindata.data.phoneDialCode);
          LocalStorage.setStringValue(sp.phoneCountryCode, logindata.data.phoneCountryCode);
          LocalStorage.setStringValue(sp.phoneNumber, logindata.data.phoneNumber);
          LocalStorage.setStringValue(sp.notification_enable, logindata.data.notification_enable);
          LocalStorage.setStringValue(sp.havePassword, logindata.data.havePassword);
          LocalStorage.setStringValue(sp.isOnboardingStep, logindata.data.isOnboardingStep.toString());

          print("qqqqqq  ${logindata.data.currentClubData.clubName.isNotEmpty}");

          if (logindata.data.currentClubData != null && logindata.data.currentClubData.clubName.isNotEmpty){

            CurrentClubData currentClubData = logindata.data.currentClubData;
            print("Login logindata : " + jsonEncode(currentClubData));
            LocalStorage.setStringValue(sp.currentClubData_logo, currentClubData.appLogoFilename);
            LocalStorage.setStringValue(sp.currentClubData_clubName, currentClubData.clubName);
            LocalStorage.setStringValue(sp.currentClubData_canViewOtherMembers, currentClubData.canViewOtherMembers.toString());
            LocalStorage.setStringValue(sp.currentClubData_btnBgColor, currentClubData.btnBgColor);
            LocalStorage.setStringValue(sp.currentClubData_btnTxtColor, currentClubData.btnTxtColor);
            LocalStorage.setStringValue(sp.currentClubData_txtColor, currentClubData.txtColor);
            LocalStorage.setStringValue(sp.isMembershipExpire, currentClubData.isMembershipExpire);
            LocalStorage.setStringValue(sp.isMembershipActive, currentClubData.isMembershipActive);
            LocalStorage.setStringValue(sp.notificationUnreadCount, currentClubData.notificationUnreadCount.toString());

            if (currentClubData.isMembershipExpire == '1' || currentClubData.isMembershipActive == '0'){
              currentClubData.isMembershipFinal = '0';
            }else{
              currentClubData.isMembershipFinal = '1';
            }
            LocalStorage.setStringValue(sp.isMembershipFinal, currentClubData.isMembershipFinal);

          }

          if(checked.value){
            LocalStorage.setBoolValue(sp.isRemember, checked.value);
            LocalStorage.setStringValue(sp.emailRemember, email);
            LocalStorage.setStringValue(sp.dialcodeReminder, phoneDialCode);
            LocalStorage.setStringValue(sp.countryname, countryname);
            LocalStorage.setStringValue(sp.countrycode, countrycode);
            LocalStorage.setStringValue(sp.countryflag, countryflag);
            LocalStorage.setStringValue(sp.phoneReminder, phoneNumber);
            LocalStorage.setStringValue(sp.passwordRemember, password);
            LocalStorage.setStringValue(sp.loginTypeRemember, loginWith);
          }
          else{
            LocalStorage.setBoolValue(sp.isRemember, false);
            LocalStorage.setStringValue(sp.emailRemember, "");
            LocalStorage.setStringValue(sp.dialcodeReminder, "");
            LocalStorage.setStringValue(sp.countryname, "");
            LocalStorage.setStringValue(sp.countrycode, "");
            LocalStorage.setStringValue(sp.countryflag, "");
            LocalStorage.setStringValue(sp.phoneReminder, "");
            LocalStorage.setStringValue(sp.passwordRemember, "");
            LocalStorage.setStringValue(sp.loginTypeRemember, "");
          }

        if(logindata.data.isOnboardingStep == 0){
          Get.offNamed(RouteHelper.getOnBoardingScreen());
        }else {
          Get.offNamed(RouteHelper.getMainScreen());
        }
        print("Login Success : " + response.data);
      }
    } catch (e) {
      CommonFunction.hideLoader();
      print("Catch error Login :-- $e");
    }
  }

  Future<String> socialLoginAPi1(BuildContext context, firstName,lastName, email, socialType,socialId) async {
    CommonFunction.showLoader();
    Map<String, String> body = {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "socialType": socialType,
      "socialId": socialId
    };

    print("formData:-- $body");
    print("Headers:-- ${DioServices.getDefaultHeader()}");
    Map<String, String> headers = await DioServices.getDefaultHeader();

    try {
      var response = await DioServices.postMethod(
          WebServices.socialAuthentication, body, headers);

      print("social Login Response :- ${response.data}");

      CommonFunction.hideLoader();

      // var jsonResponse = jsonDecode(response.data);
      var jsonResponse = response.data;

      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("statusCode:-$statusCode");
      print("data:-$data");

      if (statusCode == 200) {
        LoginModel logindata = loginModelFromJson(jsonEncode(response.data));

        print("Login logindata : " + logindata.data.toString());
        LocalStorage.setStringValue(sp.authToken, logindata.data.token);
        LocalStorage.setStringValue(sp.userfirstName, logindata.data.firstName);
        LocalStorage.setStringValue(sp.userlastName, logindata.data.lastName);
        LocalStorage.setStringValue(sp.useremail, logindata.data.email);
        LocalStorage.setStringValue(sp.isEmailPubliclyShared, logindata.data.isEmailPubliclyShared.toString());
        LocalStorage.setStringValue(sp.isNumberPubliclyShared, logindata.data.isNumberPubliclyShared.toString());
        LocalStorage.setStringValue(sp.userprofilePicture, logindata.data.profilePicture);
        LocalStorage.setStringValue(sp.phoneDialCode, logindata.data.phoneDialCode);
        LocalStorage.setStringValue(sp.phoneCountryCode, logindata.data.phoneCountryCode);
        LocalStorage.setStringValue(sp.phoneNumber, logindata.data.phoneNumber);
        LocalStorage.setStringValue(sp.notification_enable, logindata.data.notification_enable);
        CurrentClubData currentClubData = logindata.data.currentClubData;
        LocalStorage.setStringValue(sp.currentClubData_logo, currentClubData.appLogoFilename);
        LocalStorage.setStringValue(sp.currentClubData_clubName, currentClubData.clubName);
        LocalStorage.setStringValue(sp.currentClubData_canViewOtherMembers, currentClubData.canViewOtherMembers.toString());
        LocalStorage.setStringValue(sp.currentClubData_btnBgColor, currentClubData.btnBgColor);
        LocalStorage.setStringValue(sp.currentClubData_btnTxtColor, currentClubData.btnTxtColor);
        LocalStorage.setStringValue(sp.currentClubData_txtColor, currentClubData.txtColor);
        LocalStorage.setStringValue(sp.isMembershipExpire, currentClubData.isMembershipExpire.toString());
        LocalStorage.setStringValue(sp.isMembershipActive, currentClubData.isMembershipActive.toString());

        if (currentClubData.isMembershipExpire == '1' || currentClubData.isMembershipActive == '0'){
          currentClubData.isMembershipFinal = '0';
        }else{
          currentClubData.isMembershipFinal = '1';
        }
        LocalStorage.setStringValue(sp.isMembershipFinal, currentClubData.isMembershipFinal);

        Get.offNamed(RouteHelper.getMainScreen());

        print("social Login Success : " + response.data);
        return jsonEncode(response.data);
      }
      return jsonEncode(response.data);
    } catch (e) {
      CommonFunction.hideLoader();
      print("Catch error Login :-- $e");
      return "";
    }
  }


  Future<dynamic> socialLoginAPi(
      BuildContext context,
      String firstName,
      lastName,
      email,
      socialType,
      socialId,
      File? memberImg) async {
    CommonFunction.showLoader();
    LocalStorage sp = LocalStorage();
    var response;
    final url = Uri.parse(WebServices.BASE_URL + WebServices.socialAuthentication);

    print("update profile Url -- $url");
    print("update _imageFile Url -- ${memberImg?.path.toString()}");

    final request = http.MultipartRequest('POST', url);

    request.headers.addAll(DioServices.getAllHeaders());

    request.fields.addAll({
      'firstName': firstName.toString(),
      'lastName': lastName.toString(),
      'email': email.toString(),
      "socialType": socialType.toString(),
      "socialId": socialId.toString()
    });

    if (memberImg != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'memberImg', memberImg.path.toString()));
    }

    print("Request Fields: ${request.fields}");
    print("Request Files: ${request.files}");
    // var statusCode = jsonDecode(response.body)["code"];

    try {
      response = await request.send();
      final responseBody = await response.stream.bytesToString();

      final parsedResponse = jsonDecode(responseBody);
      print("parsedResponse['code'] :-- ${parsedResponse['code']}");
      print("update profile body ${responseBody}");
      print("parsedResponse ${parsedResponse}");
      int code = parsedResponse['code']; // Extract the "code" from the JSON response
      print("Code: $code");

      CommonFunction.hideLoader();
      if (response.statusCode == 200) {
        LoginModel logindata = loginModelFromJson(responseBody);

        print("Login logindata : " + logindata.data.toString());
        LocalStorage.setStringValue(sp.authToken, logindata.data.token);
        LocalStorage.setStringValue(sp.userfirstName, logindata.data.firstName);
        LocalStorage.setStringValue(sp.userlastName, logindata.data.lastName);
        LocalStorage.setStringValue(sp.useremail, logindata.data.email);
        LocalStorage.setStringValue(sp.isEmailPubliclyShared, logindata.data.isEmailPubliclyShared.toString());
        LocalStorage.setStringValue(sp.isNumberPubliclyShared, logindata.data.isNumberPubliclyShared.toString());
        LocalStorage.setStringValue(sp.userprofilePicture, logindata.data.profilePicture);
        LocalStorage.setStringValue(sp.phoneDialCode, logindata.data.phoneDialCode);
        LocalStorage.setStringValue(sp.phoneCountryCode, logindata.data.phoneCountryCode);
        LocalStorage.setStringValue(sp.phoneNumber, logindata.data.phoneNumber);
        LocalStorage.setStringValue(sp.notification_enable, logindata.data.notification_enable);
        CurrentClubData currentClubData = logindata.data.currentClubData;
        LocalStorage.setStringValue(sp.currentClubData_logo, currentClubData.appLogoFilename);
        LocalStorage.setStringValue(sp.currentClubData_clubName, currentClubData.clubName);
        LocalStorage.setStringValue(sp.currentClubData_canViewOtherMembers, currentClubData.canViewOtherMembers.toString());
        LocalStorage.setStringValue(sp.currentClubData_btnBgColor, currentClubData.btnBgColor);
        LocalStorage.setStringValue(sp.currentClubData_btnTxtColor, currentClubData.btnTxtColor);
        LocalStorage.setStringValue(sp.currentClubData_txtColor, currentClubData.txtColor);
        LocalStorage.setStringValue(sp.isMembershipExpire, currentClubData.isMembershipExpire.toString());
        LocalStorage.setStringValue(sp.isMembershipActive, currentClubData.isMembershipActive.toString());

        if (currentClubData.isMembershipExpire == '1' || currentClubData.isMembershipActive == '0'){
          currentClubData.isMembershipFinal = '0';
        }else{
          currentClubData.isMembershipFinal = '1';
        }
        LocalStorage.setStringValue(sp.isMembershipFinal, currentClubData.isMembershipFinal);

        Get.offNamed(RouteHelper.getMainScreen());

        print("social Login Success : " + response.data);
        return jsonEncode(response.data);
      }
      else{
        String responseMessage =
        ApiMsgConstant.getResponseMessage(code.toString());
        if(code == 105){
          CommonFunction.showAlertDialogdelete(Get.context!,parsedResponse['message'],(){
            Get.back();
          });
        }else{
          CommonFunction.showAlertDialogdelete(Get.context!, responseMessage,(){
            Get.back();
          });
        }
      }
      return response.statusCode;
    } catch (e) {
      CommonFunction.hideLoader();
      String responseMessage = ApiMsgConstant.getResponseMessage(response.statusCode.toString());
      print('Error sending request: $e');
      return responseMessage;
    }
  }

  //Temporary social api to hold the apple login data
  Future<void> socialTempData(BuildContext context, firstName,lastName, email, socialId) async {
    CommonFunction.showLoader();
    Map<String, String> body = {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "socialId": socialId,
    };

    print("socialTempData formData:-- $body");
    print("Headers socialTempData :-- ${DioServices.getDefaultHeader()}");
    Map<String, String> headers = await DioServices.getDefaultHeader();

    try {
      var response = await DioServices.postMethod(
          WebServices.socialTempData, body, headers);

      print("socialTempData Response :- ${response.data}");

      CommonFunction.hideLoader();

      // var jsonResponse = jsonDecode(response.data);
      var jsonResponse = response.data;

      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("statusCode:-$statusCode");
      print("data:-$data");

      if (statusCode == 200) {
        print("socialTempData success");
      }
    } catch (e) {
      CommonFunction.hideLoader();
      print("Catch error Login :-- $e");
    }
  }

  //Temporary social api to get the apple login data
  Future<void> getsocialTempData(String socialId) async {

    print("getsocialTempData Headers:-- ${DioServices.getAllHeaders()}");

    try {
      var url = WebServices.socialTempData+"/$socialId";
      print("getsocialTempData URL:-- $url");
      var response = await DioServices.getMethod(url, DioServices.getAllHeaders());
      print("getsocialTempData Response :-- ${response.data}");
      CommonFunction.hideLoader();
      //  pageLoader.value =false;
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode:- $statusCode");
      print("data:-$data");

      if(response.statusCode == 200){
        print("getsocialTempData success");

        var TempfirstName = jsonResponse["data"]["tempSocialData"]["firstName"];
        var TemplastName = jsonResponse["data"]["tempSocialData"]["lastName"];
        var Tempemail = jsonResponse["data"]["tempSocialData"]["email"];
        var TempsocialId = jsonResponse["data"]["tempSocialData"]["socialId"];

        print("getsocialTempData TempfirstName $TempfirstName");
        print("getsocialTempData TemplastName $TemplastName");
        print("getsocialTempData Tempemail $Tempemail");
        print("getsocialTempData TempsocialId $TempsocialId");

        socialLoginAPi(Get.context!, TempfirstName, TemplastName,
            Tempemail != null ? Tempemail : "", "2", TempsocialId, null);

      }
    } catch (e) {
      CommonFunction.hideLoader();
      // pageLoader.value =false;
      log("Exception :-- ", error: e.toString());
    }
  }

  Future<dynamic> onBoardingStep(
  String dateOfBirth, gender, bibNumber,removeProfilePicture,
      File? _imageFile) async
  {
    CommonFunction.showLoader();
    LocalStorage sp = LocalStorage();
    var response;
    final url = Uri.parse(WebServices.BASE_URL + WebServices.onboardingStepApi);

    print("onBoardingStep profile Url -- $url");
    print("onBoardingStep _imageFile Url -- ${_imageFile?.path.toString()}");
    print("onBoardingStep gender -- $gender");

    final request = http.MultipartRequest('PUT', url);

    request.headers.addAll(DioServices.getAllHeaders());

    request.fields.addAll({
      "dateOfBirth": dateOfBirth,
      "gender": gender,
      "bibNumber": bibNumber,
      'removeProfilePicture': removeProfilePicture,
    });

    if (_imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'profilePicture', _imageFile.path.toString()));
    }

    print("Request Fields: ${request.fields}");
    print("Request Files: ${request.files}");
    // var statusCode = jsonDecode(response.body)["code"];

    try {
      response = await request.send();
      final responseBody = await response.stream.bytesToString();

      final parsedResponse = jsonDecode(responseBody);
      int code = parsedResponse['code']; // Extract the "code" from the JSON response
      print("Code: $code");
      print("onBoardingStep body ${responseBody}");

      CommonFunction.hideLoader();
      if (code == 200) {
        Get.offNamed(RouteHelper.getMainScreen());
      }
      return response.statusCode;
    } catch (e) {
      CommonFunction.hideLoader();
      /*String responseMessage =
      ApiMsgConstant.getResponseMessage(response.statusCode.toString());
      print('Error sending request: $e');
      return responseMessage;*/
    }
  }

  Future<String> skipOnboardingStep() async {
    CommonFunction.showLoader();
    try {
      var response = await DioServices.putMethod(
        WebServices.skipOnboardingStep,
        {},
        DioServices.getAllHeaders(),
      );
      print("skipOnboardingStep Reasponce ${response.data}");
      CommonFunction.hideLoader();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("statusCode:-$statusCode");
      print("data:-$data");

      if (statusCode == 200) {
        Get.offAllNamed(RouteHelper.getMainScreen());
      }
      return statusCode.toString();
    } catch (e) {
      CommonFunction.hideLoader();
      print("Catch error $e");
    }
    return "";
  }
}
