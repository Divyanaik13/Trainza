import 'dart:developer';

import 'package:club_runner/util/FunctionConstant/FunctionConstant.dart';
import 'package:club_runner/util/custom_view/CustomView.dart';
import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:club_runner/util/string_const/MyString.dart';
import 'package:club_runner/util/text_style/MyTextStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../controller/LoginPasswordController.dart';
import '../../../util/local_storage/LocalStorage.dart';
import '../../../util/masking_string_constant/MaskingStringConstant.dart';
import '../../../util/size_config/SizeConfig.dart';

class LoginPasswordScreen extends StatefulWidget {
  const LoginPasswordScreen({super.key});

  @override
  State<LoginPasswordScreen> createState() => _LoginPasswordScreenState();
}

class _LoginPasswordScreenState extends State<LoginPasswordScreen> {


  loginPasswordController lpController = Get.put(loginPasswordController());


  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var screenWidth = SizeConfig.screenWidth;
  var fontSize = SizeConfig.fontSize();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  var dialcode = "".obs;
  var phoneNumber = "".obs;
  var havePassword = "".obs;

  LocalStorage lp = LocalStorage();

  @override
  void initState() {
    dialcode.value = LocalStorage.getStringValue(lp.phoneDialCode);
    phoneNumber.value = LocalStorage.getStringValue(lp.phoneNumber);
    havePassword.value = LocalStorage.getStringValue(lp.havePassword);
    String maskPattern =  PhoneNumberMask.getMaskPattern("+${dialcode.value.replaceAll("+", "")}");
    log("Masking",error: "$maskPattern");
    print("havePassword :-- ${havePassword.value}");
    lpController.maskFormatter.value =  MaskTextInputFormatter(
      // mask: '+# (###) ###-##-##',
        mask: maskPattern,
        filter: { "#": RegExp(r'[0-9]') },
        type: MaskAutoCompletionType.lazy
    );

    if( lpController.maskFormatter.value != null){
      lpController.maskFormatter.value!.updateMask(mask: maskPattern);
      phoneNumber.value = lpController.maskFormatter.value!.maskText(phoneNumber.value);
    }


     print("number :-- ${dialcode.value}${phoneNumber.value}");
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColor.screen_bg,
      child: SafeArea(
          child: Obx((){
            return Scaffold(
              body:  SingleChildScrollView(physics: BouncingScrollPhysics(),
                padding:
                EdgeInsets.symmetric(horizontal:20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomView.customAppBar(MyString.login_var, MyString.pass_var, () {
                      Get.back(result: "refresh");
                    }),
                    SizedBox(height: 30),
                    Divider(
                      color: MyColor.app_divder_color,
                      thickness: 1,
                      height: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CustomView.differentStyleTextTogether(
                          "Login ",
                          FontWeight.w400,
                          "Details",
                          FontWeight.w700,
                          18,
                          MyColor.app_white_color),
                    ),
                    Divider(
                      color: MyColor.app_divder_color,
                      thickness: 1,
                      height: 2,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                        text: TextSpan(
                            text:
                            "Login with your email address ",
                            style: MyTextStyle.textStyle(
                                FontWeight.w400, 13, MyColor.app_white_color,lineHeight: 1.308),
                            children: <TextSpan>[
                              TextSpan(
                                text: "or ",
                                style: MyTextStyle.textStyle(
                                    FontWeight.w700, 13, MyColor.app_white_color,lineHeight: 1.308),
                              ),
                              TextSpan(
                                text: "mobile number and password. You can change your login email or ",
                                style: MyTextStyle.textStyle(
                                    FontWeight.w400, 13, MyColor.app_white_color,lineHeight: 1.308),
                              ),
                              TextSpan(
                                text: "mobile number on your",
                                style: MyTextStyle.textStyle(
                                    FontWeight.w400, 13, MyColor.app_white_color,lineHeight: 1.308),
                              ),
                              TextSpan(
                                text: " profile page",
                                style: MyTextStyle.textStyle(
                                    FontWeight.w700, 13, MyColor.app_white_color,lineHeight: 1.308),
                              ),
                              TextSpan(
                                  text: ".",
                                  style: MyTextStyle.textStyle(
                                      FontWeight.w400, 13, MyColor.app_white_color)),
                            ])),
                    SizedBox(
                      height: 14,
                    ),
                    Text(MyString.email_var.substring(0,5),
                        style: MyTextStyle.textStyle(
                            FontWeight.w500, 14.5, MyColor.app_white_color)),
                    SizedBox(
                      height: 2,
                    ),
                    Text(LocalStorage.getStringValue(lp.useremail),
                        style: MyTextStyle.textStyle(
                            FontWeight.w500, 16, MyColor.app_white_color)),
                    SizedBox(
                      height: 14,
                    ),
                    phoneNumber.value != ""? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Mobile Number",
                            style: MyTextStyle.textStyle(
                                FontWeight.w500, 14.5, MyColor.app_white_color)),
                        SizedBox(
                          height: 2,
                        ),
                        Text("+${dialcode.value.replaceAll("+", "")} ${phoneNumber.value}",
                            style: MyTextStyle.textStyle(
                                FontWeight.w500, 16, MyColor.app_white_color)),
                        SizedBox(
                          height: 19,
                        ),
                      ],
                    ):SizedBox(),
                    Divider(
                      color: MyColor.app_divder_color,
                      thickness: 1,
                      height: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CustomView.differentStyleTextTogether(
                          "Your ",
                          FontWeight.w400,
                          "Password",
                          FontWeight.w700,
                          18,
                          MyColor.app_white_color),
                    ),

                    Divider(
                      color: MyColor.app_divder_color,
                      thickness: 1,
                      height: 2,
                    ),
                    SizedBox(
                      height: 11,
                    ),
                    //current password
                  havePassword.value=="1"?Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Current Password",
                            style: MyTextStyle.textStyle(
                                FontWeight.w500, 14.5, MyColor.app_white_color)),
                        SizedBox(
                          height: 7,
                        ),
                        SizedBox(
                          height: 40,
                          child: TextFormField(
                            controller: currentPasswordController,
                            onTap: (){
                              lpController.isError.value = 0;
                            },
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: MyColor.app_black_color,
                              fontFamily: GoogleFonts.manrope().fontFamily,
                              // fontWeight: textInputFontWait
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')), //for stop user to enter white space.
                              LengthLimitingTextInputFormatter(30),
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: MyColor.app_text_box_bg_color,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: MyColor.app_text_box_bg_color, width: 0.0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: MyColor.app_text_box_bg_color, width: 0.0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintText: "Current Password",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  fontFamily: GoogleFonts.manrope().fontFamily,
                                  color: MyColor.app_hint_color),
                              contentPadding: EdgeInsets.symmetric(horizontal: 14),
                            ),
                            onTapOutside: (event) {
                              CommonFunction.keyboardHide(Get.context!);
                            },
                          ),
                        ),
                        lpController.isError.value == 1 || lpController.isError.value == 7
                            ? CustomView.errorField(lpController.errorMessage1.value,
                            lpController.errorMessage2.value, FontWeight.w500, FontWeight.w700, 10)
                            : SizedBox(),
                        SizedBox(height: 15),
                        Divider(
                          color: MyColor.app_divder_color,
                          thickness: 1,
                          height: 2,
                        ),
                        SizedBox(
                          height: 11,
                        ),
                      ],
                    ):SizedBox(),
                    //new password
                    Text("New Password",
                        style: MyTextStyle.textStyle(
                            FontWeight.w500, 14.5, MyColor.app_white_color)),
                    SizedBox(
                      height: 7,
                    ),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        controller: newPasswordController,
                        onTap: (){
                          lpController.isError.value = 0;
                        },
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: MyColor.app_black_color,
                          fontFamily: GoogleFonts.manrope().fontFamily,
                          // fontWeight: textInputFontWait
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')), //for stop user to enter white space.
                          LengthLimitingTextInputFormatter(30),
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: MyColor.app_text_box_bg_color,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColor.app_text_box_bg_color, width: 0.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColor.app_text_box_bg_color, width: 0.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintText: "New Password",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              fontFamily: GoogleFonts.manrope().fontFamily,
                              color: MyColor.app_hint_color),
                          contentPadding: EdgeInsets.symmetric(horizontal: 14),
                        ),
                        onTapOutside: (event) {
                          CommonFunction.keyboardHide(Get.context!);
                        },
                      ),
                    ),
                    lpController.isError.value == 2||lpController.isError.value == 3|| lpController.isError.value==4
                        ? CustomView.errorField(lpController.errorMessage1.value,
                        lpController.errorMessage2.value, FontWeight.w500, FontWeight.w700, 10)
                        : SizedBox(),
                    SizedBox(height: 8),

                    //Repeat password
                    Text("Repeat Password",
                        style: MyTextStyle.textStyle(
                            FontWeight.w500, 14.5, MyColor.app_white_color)),
                    SizedBox(
                      height: 7,
                    ),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        controller: repeatPasswordController,
                        onTap: (){
                          lpController.isError.value = 0;
                        },
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: MyColor.app_black_color,
                          fontFamily: GoogleFonts.manrope().fontFamily,
                          // fontWeight: textInputFontWait
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')), //for stop user to enter white space.
                          LengthLimitingTextInputFormatter(30),
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: MyColor.app_text_box_bg_color,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColor.app_text_box_bg_color, width: 0.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColor.app_text_box_bg_color, width: 0.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintText: "Repeat Password",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              fontFamily: GoogleFonts.manrope().fontFamily,
                              color: MyColor.app_hint_color),
                          contentPadding: EdgeInsets.symmetric(horizontal: 14),
                        ),
                        onTapOutside: (event) {
                          CommonFunction.keyboardHide(Get.context!);
                        },
                      ),
                    ),
                    lpController.isError.value == 5||lpController.isError.value == 6
                    ? CustomView.errorField(lpController.errorMessage1.value,
                        lpController.errorMessage2.value, FontWeight.w500, FontWeight.w700, 10)
                        : SizedBox(),
                    SizedBox(height: 20),
                    CustomView.buttonShowWithdifferentTextStyle(
                        "SAVE ",
                        "PASSWORD",
                        FontWeight.w400,
                        FontWeight.w700,
                        4,
                        16.8,
                        MyColor.app_orange_color.value??Color(0xFFFF4300), () {

                      if (Validations()) {
                          print("object");
                          lpController.ChangePassword_api(currentPasswordController.text.trim(),newPasswordController.text.trim()).then((value) {
                            if (value != ""){
                              print("current Password $currentPasswordController");
                              Get.back(result: "refresh");
                            }
                          });
                      }

                    },letterSpacing: 0.48),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            );
          })
      ),
    );
  }

  bool Validations() {
    if (currentPasswordController.text.trim().isEmpty && havePassword.value=="1") {
      // CustomView.showAlertDialogBox(context, "Please enter first name");
      lpController.isError.value = 1;
      lpController.errorMessage1.value = "Please input ";
      lpController.errorMessage2.value = "current password";
      print(currentPasswordController.text.trim().isEmpty);
    }
    else if (newPasswordController.text.trim().isEmpty) {
      // CustomView.showAlertDialogBox(context, "Please enter password");
      lpController.isError.value = 2;
      lpController.errorMessage1.value = "Please input ";
      lpController.errorMessage2.value = "new password";
    } else if (newPasswordController.text.trim().length < 8) {
      // CustomView.showAlertDialogBox(context, "Please enter at least 8 digit password");
      lpController.isError.value = 3;
      lpController.errorMessage1.value = "Please input at least 8 digit ";
      lpController.errorMessage2.value = "password";
    } else if (!MyString.passwordregex.hasMatch(newPasswordController.text)) {
      // CustomView.showAlertDialogBox(context, "Password must contain at least 1 uppercase letter, 1 lowercase letter, 1 numeric digit, and 1 special character.");
      lpController.isError.value = 4;
      lpController.errorMessage1.value = "Password must contain at least 1 uppercase letter, 1 lowercase letter, 1 numeric digit, and 1 special character.";
      lpController.errorMessage2.value = "";
    } else if (repeatPasswordController.text.trim().isEmpty) {
      // CustomView.showAlertDialogBox(context, "Please confirm the password");
      lpController.isError.value = 5;
      lpController.errorMessage1.value = "Please input ";
      lpController.errorMessage2.value = "repeat password";
    } else if (repeatPasswordController.text.trim() != newPasswordController.text.trim()) {
      // CustomView.showAlertDialogBox(context, "Password must be same");
      lpController.isError.value = 6;
      lpController.errorMessage1.value = "Password must be same";
      lpController.errorMessage2.value = "";
    }
      else {
      return true;
    }
    return false;
  }
}
