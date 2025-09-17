import 'dart:convert';
import 'dart:io';
import 'package:club_runner/network/DioServices.dart';
import 'package:club_runner/util/FunctionConstant/FunctionConstant.dart';
import 'package:club_runner/util/custom_view/CustomView.dart';
// import 'package:country_calling_code_picker/country.dart';
// import 'package:country_calling_code_picker/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../network/ApiServices.dart';
import '../network/EndPointList.dart';
import '../util/api_message_constant/ApiMsgConstant.dart';
import '../util/asstes_image/AssetsImage.dart';
import '../util/custom_view/SocialCustomView.dart';
import '../util/local_storage/LocalStorage.dart';
import '../util/masking_string_constant/MaskingStringConstant.dart';
import '../util/route_helper/RouteHelper.dart';
import '../util/size_config/SizeConfig.dart';
import '../util/string_const/MyString.dart';

class SignUpScreenController extends GetxController {
  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var fontSize = SizeConfig.fontSize();
  var passwordVisible = false.obs;
  var passwordVisibleSecond = false.obs;
  var checked = true.obs;
  var isError = 0.obs;
  var errorMessage1 = "".obs;
  var errorMessage2 = "".obs;

  var selectedCountry1 = Rxn<Country?>();
  var defaultCountryCode = "".obs;
  var maskFormatter = Rxn<MaskTextInputFormatter>();

  TextEditingController nameTextCTRL = TextEditingController();
  TextEditingController lastNameTextCTRL = TextEditingController();
  TextEditingController emailTextCTRL = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController yourPassTextCTRL = TextEditingController();
  TextEditingController confirmPassTextCTRL = TextEditingController();

/*  void initCountry() async {
    Country? country = await getCountryByCountryCode(Get.context!, 'ZA');
    selectedCountry1.value = country;
    defaultCountryCode.value = country!.dialCode;
    print("Select country " + selectedCountry1.value!.dialCode);
  }*/

  void initCountry() {
    // Find the country using its code ('ZA' for South Africa in this case)
    final Country? country = countries.firstWhere(
          (c) => c.code == 'ZA',
      orElse: () => countries.first, // Provide a fallback country
    );

    if (country != null) {
      selectedCountry1.value = country;
      defaultCountryCode.value = country.dialCode;
      print("Selected country: ${selectedCountry1.value!.dialCode}");
    } else {
      print("Country with code 'ZA' not found");
    }
  }

  @override
  void onInit() {
    //  initCountry();
    super.onInit();
  }

  Widget socialLogin(BuildContext context) {
    return Padding(
      padding: Platform.isAndroid
          ? EdgeInsets.symmetric(horizontal: 70)
          : EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: CustomView.socialButton(
                MyAssetsImage.app_google_logo, 26.0, 26.0, () {
              signInWithGoogle();
              CommonFunction.keyboardHide(context);
              print("Google");
            }),
          ),
          Platform.isIOS
              ? Expanded(
                  flex: 1,
                  child: CustomView.socialButton(
                      MyAssetsImage.app_apple_logo, 21.0, 26.0, () {
                    signInWithApple();
                    CommonFunction.keyboardHide(context);
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
            }),
          ),
        ],
      ),
    );
  }

  launchURL(String data) async {
    final Uri url = Uri.parse(data);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<bool> validation(BuildContext context) async {
    if (nameTextCTRL.text.trim().isEmpty) {
      // CustomView.showAlertDialogBox(context, "Please enter first name");
      isError.value = 1;
      errorMessage1.value = "Please input ";
      errorMessage2.value = "first name";
    } else if (lastNameTextCTRL.text.trim().isEmpty) {
      // CustomView.showAlertDialogBox(context, "Please enter last name");
      isError.value = 2;
      errorMessage1.value = "Please input ";
      errorMessage2.value = "last name";
    } else if (emailTextCTRL.text.trim().isEmpty) {
      // CustomView.showAlertDialogBox(context, "Please enter email");
      isError.value = 3;
      errorMessage1.value = "Please input an ";
      errorMessage2.value = "email address";
    } else if (!emailTextCTRL.text.trim().isEmail) {
      // CustomView.showAlertDialogBox(context, "Please enter valid email");
      isError.value = 3;
      errorMessage1.value = "Please input a ";
      errorMessage2.value = "valid email address";
    } else if (phoneController.text.trim().isEmpty) {
      // CustomView.showAlertDialogBox(context, "Please enter phone number");
      isError.value = 4;
      errorMessage1.value = "Please input a ";
      errorMessage2.value = "mobile number";
    } else if (!await CommonFunction.getPhoneNumberValidation(
        phoneController.text.trim().replaceAll("-", "").toString(),
        selectedCountry1.value!.code)) {
      // CustomView.showAlertDialogBox(context, "Please enter valid phone number");
      isError.value = 5;
      errorMessage1.value = "Please input a valid ";
      errorMessage2.value = "mobile number";
    } else if (yourPassTextCTRL.text.trim().isEmpty) {
      // CustomView.showAlertDialogBox(context, "Please enter password");
      isError.value = 6;
      errorMessage1.value = "Please input ";
      errorMessage2.value = "password";
    } else if (yourPassTextCTRL.text.trim().length < 8) {
      // CustomView.showAlertDialogBox(context, "Please enter at least 8 digit password");
      isError.value = 7;
      errorMessage1.value = "Please input at least 8 digit ";
      errorMessage2.value = "password";
    } else if (!MyString.passwordregex.hasMatch(yourPassTextCTRL.text)) {
      // CustomView.showAlertDialogBox(context, "Password must contain at least 1 uppercase letter, 1 lowercase letter, 1 numeric digit, and 1 special character.");
      isError.value = 8;
      errorMessage1.value =
          "Password must contain at least 1 uppercase letter, 1 lowercase letter, 1 numeric digit, and 1 special character.";
      errorMessage2.value = "";
    } else if (confirmPassTextCTRL.text.trim().isEmpty) {
      // CustomView.showAlertDialogBox(context, "Please confirm the password");
      isError.value = 9;
      errorMessage1.value = "Please input ";
      errorMessage2.value = "repeat password";
    } else if (confirmPassTextCTRL.text.trim() != yourPassTextCTRL.text.trim()) {
      isError.value = 10;
      errorMessage1.value = "Password must be same";
      errorMessage2.value = "";
    }else if (checked==false) {
      // CustomView.showAlertDialogBox(context, "Please confirm the password");
      isError.value = 11;
      errorMessage1.value = "Please accept ";
      errorMessage2.value = "terms and conditions";
    }  else {
      // Get.toNamed(RouteHelper.getOtpVerifyScreen());
      // SignUpApi(context, nameTextCTRL.text, lastNameTextCTRL.text, emailTextCTRL.text
      //     , "+91",phoneController.text,
      //     yourPassTextCTRL.text, confirmPassTextCTRL.text);
      return true;
    }
    return false;
  }

  void onPressed() async {
    Country country = await Get.toNamed(RouteHelper.getCountryPickerScreen());

    if (country != null) {
      selectedCountry1.value = country;

      defaultCountryCode.value = selectedCountry1.value!.dialCode;
      phoneController.text = "";
      print("Selected Code " + selectedCountry1.toString());
      print("defaultCountryCode " + defaultCountryCode.value);
      String maskPattern = PhoneNumberMask.getMaskPattern("+${selectedCountry1.value!.dialCode}");
      maskFormatter.value =  MaskTextInputFormatter(
        // mask: '+# (###) ###-##-##',
          mask: maskPattern,
          filter: { "#": RegExp(r'[0-9]') },
          type: MaskAutoCompletionType.lazy
      );

      // intialData.value = PhoneNumber(isoCode: country.countryCode);
    }
  }

   Future<void> SignUpApi(BuildContext context, firstName, lastName, email,
    dialCode,countryCode, phoneNumber, password, confirmPassword) async {
  CommonFunction.showLoader();
  Map<String, String> body = {
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "dialCode": dialCode,
    "countryCode": countryCode,
    "phoneNumber": phoneNumber,
    "password": password,
    "confirmPassword": confirmPassword
  };

  print("formData:-- $body");
  Map<String, String> headers = await DioServices.getDefaultHeader();

  try {
    var response = await DioServices.postMethod(
        WebServices.signUp, body, headers);

    print("SignUp Responce -${response.data}");

    CommonFunction.hideLoader();
    LocalStorage sp = LocalStorage();

    var jsonResponse = response.data;

    var statusCode = jsonResponse["code"];
    var data = jsonResponse["data"];

    print("statusCode:-$statusCode");
    print("data:-$data");


      if (statusCode == 200) {
        print("Success : " + response.data.toString());
        var token = data["token"];

      print("token : " + token);
      LocalStorage.setStringValue(sp.authToken, token);
      print("get token : " + LocalStorage.getStringValue(sp.authToken));
      Map<String, String>? paramValue = {
        "email": email,
        "phone_number" : phoneNumber,
        "dial_code":dialCode
      };

      Get.toNamed(RouteHelper.getOtpVerifyScreen(),parameters: paramValue);
    }
  } catch (e) {
    CommonFunction.hideLoader();
    print("Catch error $e");
  }
}

  // Future<void> SignUpApi(BuildContext context, firstName, lastName, email,
  //     dialCode,phoneNumber, password, confirmPassword
  //     ) async {
  //   // CommonFunction.showLoading();
  //   Map<String, dynamic> body = {
  //     "firstName": firstName,
  //     "lastName": lastName,
  //     "email": email,
  //     "dialCode": dialCode,
  //     "phoneNumber":phoneNumber,
  //     "password": password,
  //     "confirmPassword": confirmPassword
  //   };
  //
  //   print("formData:-- $body");
  //   print("Headers:-- ${ApiService.getDefaultHeader()}");
  //
  //   try {
  //     var response = await ApiService.postData(
  //         WebServices.signUp, body, ApiService.getDefaultHeader());
  //
  //     print("SignUp Responce -${response.body}");
  //
  //     // CommonFunction.hideLoader();
  //
  //     var jsonResponse = jsonDecode(response.body);
  //
  //     var statusCode = jsonResponse["code"];
  //     var data = jsonResponse["data"];
  //
  //     print("statusCode:-$statusCode");
  //     print("data:-$data");
  //
  //     if (statusCode == 200) {
  //       // showDialog(
  //       //     context: context,
  //       //     builder: (BuildContext context) {
  //       //       return CustomAlertBox(
  //       //           title: ConstString.customAleart_title,
  //       //           description: message,
  //       //           image: MyAssetsImages.alertBox_img,
  //       //           onTap: () {
  //       //             Navigator.pop(context);
  //       //             Navigator.pop(context);
  //       //           });
  //       //     });
  //
  //
  //       print("Success : " + response.body);
  //       // var data = jsonResponse["data"];
  //       var token = data["token"];
  //
  //       print("token : " + token);
  //       Get.toNamed(RouteHelper.getOtpVerifyScreen(),);
  //
  //     } else {
  //       // showDialog(
  //       //     context: context,
  //       //     builder: (BuildContext context) {
  //       //       return CustomAlertBox(
  //       //           title: ConstString.customAleart_title,
  //       //           description: message,
  //       //           image: MyAssetsImages.alertBox_img,
  //       //           onTap: () {
  //       //             Navigator.pop(context);
  //       //           });
  //       //     });
  //       print("else error ");
  //     }
  //   } catch (e) {
  //     print("Catch error $e");
  //   }
  // }
}
