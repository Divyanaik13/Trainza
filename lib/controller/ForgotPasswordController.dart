import 'package:club_runner/network/DioServices.dart';
// import 'package:country_calling_code_picker/country.dart';
// import 'package:country_calling_code_picker/functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../network/EndPointList.dart';
import '../util/FunctionConstant/FunctionConstant.dart';
import '../util/masking_string_constant/MaskingStringConstant.dart';
import '../util/route_helper/RouteHelper.dart';
import '../util/size_config/SizeConfig.dart';

class ForgotPasswordController extends GetxController{
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  var fontSize = SizeConfig.fontSize();
  var selectedCountry = Rxn<Country?>();
  Rx<String> defaultCountryCode = Rx("");
  var intialData = PhoneNumber(isoCode: 'ZA');

  var resendType = true.obs;
  var isError = 0.obs;
  var errorMessage1 = "".obs;
  var errorMessage2 = "".obs;

  //For number Masking
  var maskFormatter = Rxn<MaskTextInputFormatter>();

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

/*  void initCountry(BuildContext context) async {
    // final country = await getDefaultCountry(context);

    Country? country = await getCountryByCountryCode(context, 'ZA');
    selectedCountry.value = country;
    defaultCountryCode.value = country!.callingCode;
  }*/

  void initCountry() {
    // Find the country using its code ('ZA' for South Africa)
    final Country? country = countries.firstWhere(
          (c) => c.code == 'ZA',
      orElse: () => countries.first, // Provide a fallback country
    );

    if (country != null) {
      selectedCountry.value = country;
      defaultCountryCode.value = country.dialCode;
      print("Selected country: ${selectedCountry.value!.dialCode}");
    } else {
      print("Country not found");
    }
  }


  Future<bool> validations(BuildContext context) async {
    if (resendType == true.obs && emailController.text.isEmpty) {
      isError.value = 1;
      errorMessage1.value = "Please input an ";
      errorMessage2.value = "email address";
    } else if (resendType == true.obs && !emailController.text.trim().isEmail) {
      isError.value = 2;
      errorMessage1.value = "Please input a ";
      errorMessage2.value = "valid email address";
    } else if (resendType == false.obs && phoneController.text.trim().isEmpty) {
      isError.value = 3;
      errorMessage1.value = "Please input a ";
      errorMessage2.value = "mobile number";
    } else if (resendType == false.obs &&
    !await CommonFunction.getPhoneNumberValidation(
        phoneController.text.trim().replaceAll("-", "").toString(),
    selectedCountry.value?.code)){
      isError.value = 4;
      errorMessage1.value = "Please input a ";
      errorMessage2.value = "valid mobile number";
    } else {
      return true;
    }
    return false;
  }

  Future<void> ForgotPasswordApi(BuildContext context, forgotWith, email, phoneDialCode, phoneNumber) async {
    CommonFunction.showLoader();
    Map<String, String> body = {
      "forgotWith": forgotWith,
      "email": email,
      "phoneDialCode": phoneDialCode,
      "phoneNumber": phoneNumber,
    };

    print("formData:-- $body");
    Map<String, String> headers = await DioServices.getDefaultHeader();

    try {
      var response = await DioServices.postMethod(
          WebServices.forgotPassword, body, headers);

      print("SignUp Responce -${response.data}");

      CommonFunction.hideLoader();

      var jsonResponse = response.data;

      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("statusCode:-$statusCode");
      print("data:-$data");

      if (statusCode == 200) {
        Get.offNamed(RouteHelper.getPasswordReminderSuccessScreen());
      }
    } catch (e) {
      CommonFunction.hideLoader();
      print("Catch error $e");
    }
  }
}