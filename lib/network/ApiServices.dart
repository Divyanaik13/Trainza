import 'dart:convert';
import 'dart:io';
import 'package:club_runner/network/EndPointList.dart';
import 'package:club_runner/util/route_helper/RouteHelper.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../util/FunctionConstant/FunctionConstant.dart';
import '../util/api_message_constant/ApiMsgConstant.dart';
import '../util/local_storage/LocalStorage.dart';


class ApiService extends GetxService {
  static var client = http.Client();
  static final int timeoutInSeconds = 30;
  static LocalStorage sp = LocalStorage();

  // http post api function
  static Future<http.Response> postData(
      String url, dynamic body, dynamic headerBody) async {
    print("headerBody :--- $headerBody");

    var response = await client
        .post(Uri.parse(WebServices.BASE_URL + url),
            body: body, headers: headerBody)
        .timeout(Duration(seconds: timeoutInSeconds));

    var statusCode = jsonDecode(response.body)["code"];
    if (statusCode != 200) {
      String responseMessage = ApiMsgConstant.getResponseMessage(statusCode.toString());
      CommonFunction.showAlertDialogdelete(Get.context!, responseMessage, () {
        if (statusCode == 104) {
          //Logout wala code....
          print("Logout wala code....");
          Get.offAllNamed(RouteHelper.getWelcomeScreen());
        } else {
          print("back");
          Get.back();
        }
      });
      return response;
    }

    return response;
  }

  // http get api function
  static Future<http.Response> getData(String uri, dynamic headerBody) async {
    // http.Response _response = await client.get(Uri.parse(WebServices.BASE_URL + uri),headers: headerBody)
    //     .timeout(Duration(seconds: timeoutInSeconds));
    // return _response;

    var response = await client
        .get(Uri.parse(WebServices.BASE_URL + uri), headers: headerBody)
        .timeout(Duration(seconds: timeoutInSeconds));

    var statusCode = jsonDecode(response.body)["code"];
    if (statusCode != 200) {
      String responseMessage =
          ApiMsgConstant.getResponseMessage(statusCode.toString());
      CommonFunction.showAlertDialogdelete(Get.context!, responseMessage, () {
        if (statusCode == 104) {
          //Logout wala code....
          print("Logout wala code....");
          Get.offAllNamed(RouteHelper.getWelcomeScreen());
        } else {
          Get.back();
        }
      });
      return response;
    }
    return response;
  }

  // http multipart api function
  static Future<http.StreamedResponse> multipartData(
      String url, Map<String, String> map, File? file, String key) async {
    http.MultipartRequest request =
        http.MultipartRequest('Post', Uri.parse(WebServices.BASE_URL + url));

    if (file != null) {
      request.files.add(http.MultipartFile(
          key, file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.path.split('/').last));
    }

    request.fields.addAll(map);

    print("multipartData request.fields:--- ${map.toString()}");
    http.StreamedResponse response = await request.send();
    return response;
  }

  // http Delete function
  static Future<http.Response> deleteData(String url, dynamic headerBody) async {
    print("headerBody :--- $headerBody");

    var response = await client.delete(Uri.parse(WebServices.BASE_URL + url), headers: headerBody)
        .timeout(Duration(seconds: timeoutInSeconds));

    var statusCode = jsonDecode(response.body)["code"];
    if (statusCode != 200) {
      String responseMessage = ApiMsgConstant.getResponseMessage(statusCode.toString());
      CommonFunction.showAlertDialogdelete(Get.context!, responseMessage, () {
        if (statusCode == 104) {
          // Logout code....
          print("Logout wala code....");
          Get.offAllNamed(RouteHelper.getWelcomeScreen());
        } else {
          Get.back();
        }
      });
      return response;
    }
    return response;
  }

  static Map<String, String> getDefaultHeader() {
    Map<String, String> defaultHeaders = {
      "device-token": LocalStorage.getStringValue(sp.deviceToken),
      "device-type": LocalStorage.getStringValue(sp.deviceType),
      "device-id": LocalStorage.getStringValue(sp.deviceId),
      "api-key": "m2E7FFKm3v8e!xCxj|6RAC87lMA2wOFXt8i3HX&klH}?{556dc1kwyllokWzqeKw&kH}?{j7UuFXn55BE508zy7gEHNMx",
      "accept": "application/json"
    };

    print("getDefaultHeader " + defaultHeaders.toString());
    print(LocalStorage.getStringValue(sp.deviceId));
    return defaultHeaders;
  }

  static Map<String, String> getAllHeaders() {
    Map<String, String> allHeaders = {
      "access-token": LocalStorage.getStringValue(sp.authToken),
      "device-token": LocalStorage.getStringValue(sp.deviceToken),
      "device-type": LocalStorage.getStringValue(sp.deviceType),
      "device-id": LocalStorage.getStringValue(sp.deviceId),
      "api-key": "m2E7FFKm3v8e!xCxj|6RAC87lMA2wOFXt8i3HX&klH}?{556dc1kwyllokWzqeKw&kH}?{j7UuFXn55BE508zy7gEHNMx",
      "accept": "application/json"
    };

    return allHeaders;
  }

}

