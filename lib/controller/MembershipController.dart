import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/Membership_Model.dart';
import '../network/DioServices.dart';
import '../network/EndPointList.dart';
import '../util/FunctionConstant/FunctionConstant.dart';
import '../util/local_storage/LocalStorage.dart';

class MembershipController extends GetxController {
  var membershipmodel = Rxn<MembershipInfoModel>();
  var membershipInfo = Rxn<MembershipInfo>();
  var membershipButtonStatus = "".obs;
  var privacyPolicy = "".obs;
  var termsConditions = "".obs;
  var pageContent = "".obs;
  var Info = "".obs;
  LocalStorage sp = LocalStorage();

  Future<void> getMembership_Api() async {
    print("Headers:-- ${DioServices.getAllHeaders()}");
    CommonFunction.showLoader();
    try {
      var response = await DioServices.getMethod(
          WebServices.membership, DioServices.getAllHeaders());
      print("Membership Response :--  ${response.data}");
      CommonFunction.hideLoader();

      var jsonResponse = response.data;

      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("data:-${jsonEncode(response.data)}");

      if (statusCode == 200) {
        membershipmodel.value = membershipInfoModelFromJson(jsonEncode(response.data));
        membershipInfo.value = membershipmodel.value!.data.membershipInfo;
        membershipButtonStatus.value = membershipmodel.value!.data.membershipButtonStatus;

        print("membershipButtonStatus :-- ${membershipButtonStatus.value}");

        Info.value = membershipInfo.value!.details;

        if (Info.value.contains("<p><br></p><p>")) {
          Info.value = Info.value.replaceAll("<p><br></p><p>", "");
        }
        if (Info.value.contains("<p><br></p>")) {
          Info.value = Info.value.replaceAll("<p><br></p>", "");
        }
        if (Info.value.contains("<p><br>")) {
          Info.value = Info.value.replaceAll("<p><br>", "");
        }

        // print("joinClub length :- ${joinClub.value.length}");
      }
    } catch (e) {
      CommonFunction.hideLoader();
      log("Membership Exception :-- ", error: e.toString());
    }
  }

  launchURL(String data) async {
    print("data $data");
    if (data.contains("http")) {
    } else {
      data = "https://" + data.toString();
      print("data $data");
    }
    final Uri url = Uri.parse(data);
    print("Url $url");

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  emaillaunchURL(String toMailId, String subject, String body) async {
    print("subject $subject");
    print("body $body");
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchWhatsapp1(
    String phone,
    String message,
  ) async {
    final url = 'https://wa.me/967$phone?text=$message';

    await launchUrlString(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  launchWhatsapp(String phone, String message) async {
    print("phone :-- $phone");

    var androidUrl = "whatsapp://send?phone=$phone&text=$message";
    //var iosUrl = "whatsapp://send?phone=$phone&text=${Uri.parse('$message')}";
    // var iosUrl = "https://wa.me/$phone?text=$message";

    try {
      if (Platform.isIOS) {
        print("isIOS whatsApp ");
        await launchUrl(Uri.parse(androidUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      EasyLoading.showError('WhatsApp is not installed.');
    }
  }

  launchPhoneCall(String phone) async {
    // final url = 'https://wa.me/967$phone?text=$message';
    //
    // await launchUrlString(
    //   url,
    //   mode: LaunchMode.externalApplication,
    // );

    print("phone :-- ${phone.replaceAll("+", "")}");

    final call = Uri.parse('tel:+${phone}');
    if (await canLaunchUrl(call)) {
      launchUrl(call);
    } else {
      throw 'Could not launch $call';
    }
  }

  // Privacy policy & terms conditions
  Future<void> privacyPolicy_termsConditions(String pageType) async {
    print("Headers page content:-- ${DioServices.getAllHeaders()}");
    CommonFunction.showLoader();
    try {
      var url =
          WebServices.privacyPolicy_termConditions + "?pageType=$pageType";
      print("Request url page content --> $url");
      var response =
          await DioServices.getMethod(url, DioServices.getAllHeaders());
      print("page content Response :--  ${response.data}");
      CommonFunction.hideLoader();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("data:-${jsonEncode(response.data)}");

      if (statusCode == 200) {
        pageContent.value = data["pageContent"];
        print("Success page content");
      } else {
        print("Failed: $statusCode, Message: ${jsonResponse["message"]}");
      }
    } catch (e) {
      CommonFunction.hideLoader();
      log("page content Exception :-- ", error: e.toString());
    }
  }
}
