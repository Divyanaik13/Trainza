import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:club_runner/models/StateList_Model.dart';
import 'package:club_runner/models/WeightList_Model.dart';
import 'package:club_runner/network/ApiServices.dart';
//import 'package:country_calling_code_picker/country.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../models/CountryList_Model.dart';
import '../models/HeightList_Model.dart';
import '../models/Login_Model.dart';
import '../network/DioServices.dart';
import '../network/EndPointList.dart';
import '../util/FunctionConstant/FunctionConstant.dart';
import '../util/api_message_constant/ApiMsgConstant.dart';
import '../util/local_storage/LocalStorage.dart';
import '../util/my_color/MyColor.dart';
import '../util/route_helper/RouteHelper.dart';
import '../util/string_const/MyString.dart';
import '../util/text_style/MyTextStyle.dart';
import 'package:http/http.dart' as http;

///DIKSHA
class EditProfileController extends GetxController {
  Rx<DateTime> selectedDate = DateTime.now().obs;

  List gender = [MyString.male_var, MyString.female_var];
  var select = "".obs;

  //for weight list
  var dropdownweight = Rxn<WeightMeta>();
  var weightList = <WeightMeta>[].obs;
  var weightMeta = "".obs;
  var selectedWeightValue="".obs;

  //for country list
  var dropdowncountry = Rxn<CountryMeta>();
  var countryList = <CountryMeta>[].obs;
  var countryMeta = "".obs;
  var countryName = "".obs;

  //for height list
  var dropdownheight = Rxn<HeightMeta>();
  var heightList = <HeightMeta>[].obs;
  var heightMeta = "".obs;
  List <HeightMeta> HeightMetaList = [];
  var selectedHeight="".obs;


  //for state list
  var dropdownstate = Rxn<StateMeta>();
  var stateList = <StateMeta>[].obs;
  var stateMeta = "".obs;
  var selectedState = "".obs;

  var isError = 0.obs;
  var errorMessage1 = "".obs;
  var errorMessage2 = "".obs;
  var profileImg = "".obs;
  var dailCode = "";
  var flagImg = "";
  var removeProfilePicture = "0".obs;

  var selectedCountry = Rxn<Country?>();
  Rx<String> defaultCountryCode = Rx("");
  var maskFormatter = Rxn<MaskTextInputFormatter>();

  TextEditingController dobctrl = TextEditingController();
  TextEditingController firstnamectrl = TextEditingController();
  TextEditingController lastnamectrl = TextEditingController();
  TextEditingController emailctrl = TextEditingController();
  TextEditingController contactNoctrl = TextEditingController();
  TextEditingController genderctrl = TextEditingController();
  TextEditingController heightctrl = TextEditingController();
  TextEditingController weightctrl = TextEditingController();
  TextEditingController countryctrl = TextEditingController();
  TextEditingController cityctrl = TextEditingController();
  TextEditingController provincectrl = TextEditingController();
  TextEditingController postalctrl = TextEditingController();
  TextEditingController bibController = TextEditingController();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      dobctrl.text =
          "${selectedDate.value.year}-${selectedDate.value.month}-${selectedDate.value.day}";

      print(">>> " + selectedDate.value.toString());
    }
  }

  Widget checkBox(double widthPerBox, RxBool checked) {
    return Obx(() {
      return ListTileTheme(
        horizontalTitleGap: 0,
        child: CheckboxListTile(
          side: BorderSide(color: MyColor.app_black_color),
          title: Text(
            "Share Publicly",
            style: MyTextStyle.textStyle(
                FontWeight.w500, widthPerBox * 2.5, MyColor.app_text_color),
          ),
          activeColor: Colors.white,
          value: checked.value,
          onChanged: (newValue) {
            checked.value = newValue!;
          },
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
          checkColor: MyColor.app_white_color,
          fillColor: MaterialStateProperty.all(
            checked.value ? MyColor.app_black_color : MyColor.app_white_color,
          ),
          controlAffinity: ListTileControlAffinity.leading,
          visualDensity: VisualDensity.compact,
        ),
      );
    });
  }

  Obx addRadioButton(int btnValue, String title, BuildContext context) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Radio(
            // activeColor: Theme.of(context).primaryColor,
            value: gender[btnValue],
            groupValue: select.value,
            onChanged: (value) {
              print(value);
              select.value = value;
              isError.value = 0;
              print(isError);
            },
            materialTapTargetSize:
                MaterialTapTargetSize.shrinkWrap, // To avoid padding
            visualDensity: VisualDensity.compact, // To reduce space
            activeColor: Theme.of(context).primaryColor, // Selected color
            fillColor: MaterialStateProperty.resolveWith<Color>((states) {
              // Unselected color
              if (states.contains(MaterialState.selected)) {
                return Theme.of(context).primaryColor; // Color when selected
              }
              return MyColor.app_radio_grey_color; // Color when not selected
            }),
          ),
          Text(
            title,
            style: TextStyle(
                fontFamily: GoogleFonts.manrope().fontFamily,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: MyColor.app_hint_color),
          )
        ],
      );
    });
  }

  // Api function for delete
  Future<String> deleteAccount_Api(BuildContext context) async {
    print("Headers:-- ${ApiService.getAllHeaders()}");

    try {
      var response = await ApiService.deleteData(
          WebServices.delete_account, ApiService.getAllHeaders());
      print("Delete Account Reasponce -${response.body}");
      var jsonResponse = jsonDecode(response.body);
      var statusCode = jsonResponse["code"];
      print("statusCode:-$statusCode");
      if (statusCode == 200) {
        print("Delete Account Success : " + response.body);
      }
    } catch (e) {
      print("Catch error $e");
    }
    return ApiMsgConstant.getResponseMessage("500");
  }

  //country list
  Future<void> countryList_Api() async {
    CommonFunction.showLoader();
    print("Headers:-- ${DioServices.getAllHeaders()}");

    try {
      var response = await DioServices.getMethod(
          WebServices.countryList, DioServices.getAllHeaders());
      print("countryList Response :-- ${response.data}");
      CommonFunction.hideLoader();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode:- $statusCode");
      if (statusCode == 200) {
        countryList.value = List<CountryMeta>.from(
            data["countryMeta"].map((x) => CountryMeta.fromJson(x)));
        print("countryList : ${countryList.length}");
      }
    } catch (e) {
      CommonFunction.hideLoader();
      log("Exception :-- ", error: e.toString());
    }
  }

  //height list
  Future<void> heightList_Api() async {
    CommonFunction.showLoader();
    print("Headers:-- ${DioServices.getAllHeaders()}");

    try {
      var response = await DioServices.getMethod(
          WebServices.heightList, DioServices.getAllHeaders());
      print("heightList Response :-- ${response.data}");
      CommonFunction.hideLoader();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode:- $statusCode");
      if (statusCode == 200) {
        heightList.value = List<HeightMeta>.from(
            data["heightMeta"].map((x) => HeightMeta.fromJson(x)));
      }
    } catch (e) {
      CommonFunction.hideLoader();
      log("Exception :-- ", error: e.toString());
    }
  }

  //weight list
  Future<void> weightList_Api() async {
    CommonFunction.showLoader();
    print("Headers:-- ${DioServices.getAllHeaders()}");

    try {
      var response = await DioServices.getMethod(
          WebServices.weightList, DioServices.getAllHeaders());
      print("weightList Response :-- ${response.data}");
      CommonFunction.hideLoader();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode:- $statusCode");
      if (statusCode == 200) {
        weightList.value = List<WeightMeta>.from(
            data["weightMeta"].map((x) => WeightMeta.fromJson(x)));
      }
    } catch (e) {
      CommonFunction.hideLoader();
      log("Exception :-- ", error: e.toString());
    }
  }

  //state list
  Future<void> stateList_Api(String countryId) async {
    // CommonFunction.showLoader();
    print("Headers:-- ${DioServices.getAllHeaders()}");

    try {
      var response = await DioServices.getMethod(
          "${WebServices.stateList}?countryId=$countryId",
          DioServices.getAllHeaders());
      print("stateList Response :-- ${response.data}");
      // CommonFunction.hideLoader();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode:- $statusCode");
      if (statusCode == 200) {
        stateList.value = List<StateMeta>.from(
            data["stateMeta"].map((x) => StateMeta.fromJson(x)));
      }
    } catch (e) {
      // CommonFunction.hideLoader();
      log("Exception :-- ", error: e.toString());
    }
  }

  static Future<dynamic> updateProfile_api(
      BuildContext context,
      String firstName,
      lastName,
      email,
      isEmailPubliclyShared,
      phoneDialCode,
      phoneCountryCode,
      phoneNumber,
      isNumberPubliclyShared,
      dateOfBirth,
      gender,
      height,
      weight,
      countryMeta,
      stateMeta,
      town,
      removeProfilePicture,
      bibNumber,
      File? _imageFile) async {
    CommonFunction.showLoader();
    LocalStorage sp = LocalStorage();
    var response;
    final url = Uri.parse(WebServices.BASE_URL + WebServices.userprofile);

    print("update profile Url -- $url");
    print("update _imageFile Url -- ${_imageFile?.path.toString()}");
    print("update gender -- $gender");

    final request = http.MultipartRequest('PUT', url);

    request.headers.addAll(DioServices.getAllHeaders());

    request.fields.addAll({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'isEmailPubliclyShared': isEmailPubliclyShared,
      'phoneDialCode': phoneDialCode,
      'phoneCountryCode': phoneCountryCode,
      'phoneNumber': phoneNumber,
      'isNumberPubliclyShared': isNumberPubliclyShared,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'height': height,
      'weight': weight,
      'countryMeta': countryMeta,
      'stateMeta': stateMeta,
      'town': town,
      'removeProfilePicture': removeProfilePicture,
      'bibNumber': bibNumber,
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
      print("update profile body ${responseBody}");

      CommonFunction.hideLoader();
      if (response.statusCode != 200) {
        String responseMessage =
            ApiMsgConstant.getResponseMessage(code.toString());
        CommonFunction.showAlertDialogdelete(Get.context!, responseMessage, () {
          if (response.statusCode == 104) {
            bool isRemember =  LocalStorage.getBoolValue(sp.isRemember);
            String emailRemember = LocalStorage.getStringValue(sp.emailRemember),
                passRemember = LocalStorage.getStringValue(sp.passwordRemember),
                deviceId = LocalStorage.getStringValue(sp.deviceId),
                deviceType = LocalStorage.getStringValue(sp.deviceType),
                deviceToken = LocalStorage.getStringValue(sp.deviceToken),
                dialcodeReminder = LocalStorage.getStringValue(sp.dialcodeReminder),
                phoneReminder = LocalStorage.getStringValue(sp.phoneReminder),
                loginType = LocalStorage.getStringValue(sp.loginTypeRemember),
                countrynameReminder = LocalStorage.getStringValue(sp.countryname),
                countrycodeReminder =  LocalStorage.getStringValue(sp.countrycode),
                countryflagReminder = LocalStorage.getStringValue(sp.countryflag),
                appleFirstName = LocalStorage.getStringValue(sp.appleFirstName),
                appleLastName = LocalStorage.getStringValue(sp.appleLastName),
                appleEmail = LocalStorage.getStringValue(sp.appleEmail),
                appleId = LocalStorage.getStringValue(sp.appleId);

            //Logout wala code....
            print("Logout wala code....");
            LocalStorage.clearLocalStorage();
            LocalStorage.setBoolValue(sp.isRemember, isRemember);
            LocalStorage.setStringValue(sp.loginTypeRemember,loginType == "2" ? "false" : "true");
            LocalStorage.setStringValue(sp.emailRemember, emailRemember);
            LocalStorage.setStringValue(sp.phoneReminder,phoneReminder);
            LocalStorage.setStringValue(sp.dialcodeReminder, dialcodeReminder);
            LocalStorage.setStringValue(sp.countryname, countrynameReminder);
            LocalStorage.setStringValue(sp.countryflag,countryflagReminder);
            LocalStorage.setStringValue(sp.countrycode,countrycodeReminder);
            LocalStorage.setStringValue(sp.passwordRemember, passRemember);
            LocalStorage.setStringValue(sp.deviceId,deviceId);
            LocalStorage.setStringValue(sp.deviceType, deviceType);
            LocalStorage.setStringValue(sp.deviceToken, deviceToken);
            LocalStorage.setStringValue(sp.appleFirstName, appleFirstName);
            LocalStorage.setStringValue(sp.appleLastName, appleLastName);
            LocalStorage.setStringValue(sp.appleEmail, appleEmail);
            LocalStorage.setStringValue(sp.appleId, appleId);
            MyColor.app_orange_color.value = Color(0xFFFF4300);
            MyColor.app_button_text_dynamic_color = Color(0xFFFFFFFF);
            MyColor.app_text_dynamic_color = Color(0xFFFF4300);

            Get.offAllNamed(RouteHelper.getWelcomeScreen());
          }
          else if(response.statusCode == 109){
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
            LocalStorage.setStringValue(sp.isMembershipExpire, currentClubData.isMembershipExpire);
            LocalStorage.setStringValue(sp.isMembershipActive, currentClubData.isMembershipActive);

            if (currentClubData.isMembershipExpire == '1' || currentClubData.isMembershipActive == '0'){
              currentClubData.isMembershipFinal = '0';
            }else{
              currentClubData.isMembershipFinal = '1';
            }
            LocalStorage.setStringValue(sp.isMembershipFinal, currentClubData.isMembershipFinal);
            Get.offAllNamed(RouteHelper.getMainScreen());

          } else {
            print("back");
            Get.back();
          }
        });
        return responseMessage;
      }
      return response.statusCode;
    } catch (e) {
      CommonFunction.hideLoader();
      String responseMessage =
          ApiMsgConstant.getResponseMessage(response.statusCode.toString());
      print('Error sending request: $e');
      return responseMessage;
    }
  }

}
