import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../network/DioServices.dart';
import '../network/EndPointList.dart';
import '../util/FunctionConstant/FunctionConstant.dart';

class loginPasswordController extends GetxController{

  String old_password = "old_password";
  String new_password = "new_password";
  var isError = 0.obs;
  var errorMessage1 = "".obs;
  var errorMessage2 = "".obs;
  var maskFormatter = Rxn<MaskTextInputFormatter>();


  // post api function
  Future<String> ChangePassword_api(String old_password,new_password ) async {
    CommonFunction.showLoader();
    Map<String, String> body = {
      "old_password": old_password,
      "new_password": new_password,
    };
    print("Body ChangePassword_api :-- $body");
    var url = "${WebServices.changePassword}";
    print("url:-- $url");
    try {
      var response =
      await DioServices.postMethod(url, body, DioServices.getAllHeaders());
      CommonFunction.hideLoader();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("statusCode:-$statusCode");
      print("jsonResponse:-$jsonResponse");
      if (statusCode == 200) {
        return jsonEncode(response.data);

      }
      if(statusCode==203){
        isError.value = 7;
        errorMessage1.value = "Your current password ";
        errorMessage2.value = "is invalid";
      }
      return jsonEncode(response.data);
    } catch (e) {
      CommonFunction.hideLoader();
      print("Catch error $e");
      return "";
    }
  }

}