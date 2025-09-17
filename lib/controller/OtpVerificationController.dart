import 'dart:convert';

import 'package:club_runner/network/DioServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../network/ApiServices.dart';
import '../network/EndPointList.dart';
import '../util/FunctionConstant/FunctionConstant.dart';
import '../util/custom_view/CustomView.dart';
import '../util/local_storage/LocalStorage.dart';
import '../util/size_config/SizeConfig.dart';
import '../util/text_style/MyTextStyle.dart';

class OtpVerificationController extends GetxController{

  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var fontSize = SizeConfig.fontSize();

  TextEditingController emailotpController = TextEditingController();
  TextEditingController phoneotpController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  var verified = false.obs;
  var isError = 0.obs;
  var errorMessage1 = "".obs;
  var errorMessage2 = "".obs;
  LocalStorage sp = LocalStorage();


  Widget theTextShow(String text, FontWeight fontWeight, double size, Color color) {
    return Text(
      text,
      style: MyTextStyle.textStyle(fontWeight, size,color),
      textAlign: TextAlign.center,
    );
  }

  bool validation(BuildContext context){
    if(otpController.text.isEmpty){
      isError.value = 1;
      errorMessage1.value = "Please input ";
      errorMessage2.value = "otp";
    }
    else if(otpController.text.trim().length < 4){
      isError.value = 2;
      errorMessage1.value = "Please input valid ";
      errorMessage2.value = "otp";
    }
   /* if(emailotpController.text.isEmpty){
      // CustomView.showAlertDialogBox(context,"Please enter otp");
      isError.value = 1;
      errorMessage1.value = "Please input ";
      errorMessage2.value = "otp";
    }
    else if(emailotpController.text.trim().length < 4){
      // CustomView.showAlertDialogBox(context,"invalid otp");
      isError.value = 2;
      errorMessage1.value = "Please input valid ";
      errorMessage2.value = "otp";
    }
    else if(phoneotpController.text.isEmpty){
      // CustomView.showAlertDialogBox(context, "Please enter otp");
      isError.value = 3;
      errorMessage1.value = "Please input ";
      errorMessage2.value = "otp";
    }
    else if(phoneotpController.text.trim().length < 4){
      // CustomView.showAlertDialogBox(context, "invalid otp");
      isError.value = 4;
      errorMessage1.value = "Please input valid ";
      errorMessage2.value = "otp";
    }*/else{
      return true;
    }
    return false;
  }




  Future<void> otpVerificationApi(BuildContext context, code
      ) async {
    CommonFunction.showLoader();
    var token = LocalStorage.getStringValue(sp.authToken);
    Map<String, String> body = {
      // "eCode": eCode,
      // "pCode": pCode,
      "code": code,
      "token": token,
    };
    print("formData:-- $body");
    print("Headers:-- ${ApiService.getDefaultHeader()}");
    Map<String, String> headers = await DioServices.getDefaultHeader();

    try {
      var response = await DioServices.postMethod(
          WebServices.verifyCodes, body, headers);

      print("otpVerification Responce -${response.data}");

      CommonFunction.hideLoader();

      var jsonResponse = response.data;

      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("statusCode:-$statusCode");
      print("data:-$data");

      if (statusCode == 200) {
        print("Success : " + response.data.toString());
        verified.value = true;
      }
    } catch (e) {
      CommonFunction.hideLoader();
      print("Catch error $e");
    }
  }

  Future<void> resendCodeApi(BuildContext context) async {
    CommonFunction.showLoader();
    Map<String, String> body = {
     // "resendType": resendType,
      "token": LocalStorage.getStringValue(sp.authToken),
    };

    print("formData:-- $body");
    print("Headers:-- ${ApiService.getAllHeaders()}");

    try {
      var response = await DioServices.postMethod(
          WebServices.resendOtp, body, DioServices.getAllHeaders());

      print("SignUp Responce -${response.data}");

      CommonFunction.hideLoader();

      var jsonResponse = response.data;

      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("statusCode:-$statusCode");
      print("data:-$data");

      if (statusCode == 200) {
        var token = data["token"];

        print("token : " + token);
        LocalStorage.setStringValue(sp.authToken, token);

      }
    } catch (e) {
      CommonFunction.hideLoader();
      print("Catch error $e");
    }
  }
}