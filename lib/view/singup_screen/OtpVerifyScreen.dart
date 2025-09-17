import 'package:club_runner/util/FunctionConstant/FunctionConstant.dart';
import 'package:club_runner/util/custom_view/CustomView.dart';
import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:club_runner/util/route_helper/RouteHelper.dart';
import 'package:club_runner/util/string_const/MyString.dart';
import 'package:club_runner/util/text_style/MyTextStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../controller/OtpVerificationController.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final OtpVerController = OtpVerificationController();

  String email ="",dialCode = "",phoneNumber = "";
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    if(Get.parameters["email"] !=null){
      email = Get.parameters["email"]!;
      dialCode = Get.parameters["dial_code"]!;
      phoneNumber = Get.parameters["phone_number"]!;

      print("email :-- $email");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        color: MyColor.screen_bg,
        child: SafeArea(
          child: Scaffold(
            body: GestureDetector(
              onTap: () {
                CommonFunction.keyboardHide(context);
              },
              child:  SingleChildScrollView(physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 55),
                      child: CustomView.customAppBar(
                          MyString.verify_var, MyString.email_single_var, () {
                        Get.back();
                      }),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    OtpVerController.verified.value
                        //second screen
                        ? Column(
                            children: [
                              OtpVerController.theTextShow(MyString.verified_var,
                                  FontWeight.w600, 25, MyColor.app_white_color),
                              SizedBox(
                                height: OtpVerController.heightPerBox! * 2,
                              ),
                              OtpVerController.theTextShow(
                                  MyString.you_can_proceed_var,
                                  FontWeight.w400,
                                  15,
                                  Color.fromARGB(255, 255, 255, 255)),
                              SizedBox(
                                height: OtpVerController.heightPerBox! * 4,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 55, right: 55),
                                child: CustomView.buttonShow(
                                    MyString.login_now_var,
                                    FontWeight.w500,
                                    OtpVerController.widthPerBox!,
                                    16.8,
                                    MyColor.app_orange_color.value??Color(0xFFFF4300)??Color(0xFFFF4300), () {
                                  Get.offAllNamed(RouteHelper.getWelcomeScreen());
                                }),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              OtpVerController.theTextShow(
                                  MyString.enter_4_digit_var,
                                  FontWeight.w600,
                                  18,
                                  MyColor.app_white_color),
                              SizedBox(
                                height: 25,
                              ),
                              OtpVerController.theTextShow(
                                  MyString.verification_code_send_var,
                                  FontWeight.w400,
                                  15,
                                  MyColor.app_grey_text_color),
                              SizedBox(
                                height: 7,
                              ),

                              // email section
                              OtpVerController.theTextShow(
                                  email,
                                  FontWeight.w400,
                                  15,
                                  MyColor.app_white_color),
                              SizedBox(
                                height: 7,
                              ),
                              OtpVerController.theTextShow(
                                  "+${dialCode.replaceAll("+", "")} $phoneNumber",
                                  FontWeight.w400,
                                  15,
                                  MyColor.app_white_color),
                              SizedBox(
                                height: 7,
                              ),

                              OtpVerController.theTextShow(
                                  MyString.the_code_will_expire_var,
                                  FontWeight.w400,
                                  15,
                                  MyColor.app_grey_text_color),
                              SizedBox(
                                height: 25,
                              ),
                              otpTextField(55, OtpVerController.otpController),
                              OtpVerController.isError.value == 1 || OtpVerController.isError.value == 2
                                  ? Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 55),
                                      child: CustomView.errorField(
                                          OtpVerController.errorMessage1.value,
                                          OtpVerController.errorMessage2.value,
                                          FontWeight.w500,
                                          FontWeight.w700,
                                          10),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 0.5,
                              ),
                              TextButton(
                                onPressed: () {
                                  OtpVerController.resendCodeApi(context).then((value) {
                                    OtpVerController.otpController.text = "";
                                  });
                                },
                                child: Text(
                                  MyString.or_resend_code_var,
                                  style: MyTextStyle.textStyle(FontWeight.w400,
                                      16, MyColor.app_white_color),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),

                              // Phone number section
                              /* OtpVerController.theTextShow(
                                  MyString.verification_code_send_var,
                                  FontWeight.w400,
                                  15,
                                  MyColor.app_grey_text_color),
                              SizedBox(
                                height: 7,
                              ),
                              OtpVerController.theTextShow("+" +dialCode.replaceAll("+", "") + phoneNumber,
                                  FontWeight.w400, 15, MyColor.app_white_color),
                              SizedBox(
                                height: 7,
                              ),

                              OtpVerController.theTextShow(
                                  MyString.the_code_will_expire_var,
                                  FontWeight.w400,
                                  15,
                                  MyColor.app_grey_text_color),
                              SizedBox(
                                height: 25,
                              ),

                              otpTextField(
                                  55, OtpVerController.phoneotpController),
                              OtpVerController.isError.value == 3 ||
                                      OtpVerController.isError.value == 4
                                  ? Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 55),
                                      child: CustomView.errorField(
                                          OtpVerController.errorMessage1.value,
                                          OtpVerController.errorMessage2.value,
                                          FontWeight.w500,
                                          FontWeight.w700,
                                          10),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 0.5,
                              ),
                              TextButton(
                                onPressed: () {
                                  print("resend object");
                                  OtpVerController.resendCodeApi(context, "2").then((value) {
                                    OtpVerController.phoneotpController.text = "";
                                  });

                                },
                                child: Text(
                                  MyString.or_resend_code_var,
                                  style: MyTextStyle.textStyle(FontWeight.w400,
                                      16, MyColor.app_white_color),
                                ),
                              ),*/

                              Padding(
                                padding: EdgeInsets.only(left: 55, right: 55),
                                child: CustomView.buttonShow(
                                    MyString.submit_var,
                                    FontWeight.w500,
                                    4.32,
                                    16.8,
                                    MyColor.app_orange_color.value??Color(0xFFFF4300), () {
                                  if (OtpVerController.validation(context)) {
                                    OtpVerController.otpVerificationApi(
                                        context,
                                        OtpVerController.otpController.text
                                        /*OtpVerController.emailotpController.text,
                                        OtpVerController.phoneotpController.text*/);
                                  }
                                  CommonFunction.keyboardHide(context);
                                }),
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              OtpVerController.theTextShow(
                                  MyString.check_your_spam_var + email,
                                  FontWeight.w400,
                                  14.5,
                                  MyColor.app_grey_text_color),
                            ],
                          ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget AppBar(String firstText, secondText, double heightPerBox, fontSize,
      VoidCallback onClick) {
    return Column(
      children: [
        SizedBox(
          height: heightPerBox * 6,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 55, top: 5, bottom: 5),
          child: Row(
            children: [
              InkWell(
                onTap: onClick,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    color: MyColor.app_white_color,
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: MyColor.screen_bg,
                      size: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Center(
                    child: CustomView.twotextView(
                        firstText,
                        FontWeight.w800,
                        secondText,
                        FontWeight.w300,
                        20,
                        MyColor.app_white_color,
                        1.74)),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget otpTextField(double padding, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: PinCodeTextField(
        length: 4,
        obscureText: false,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 70,
            fieldWidth: 55,
            activeFillColor: Colors.white,
            inactiveColor: Colors.white,
            inactiveFillColor: Colors.white,
            selectedFillColor: Colors.white,
            selectedColor: Colors.white,
            activeColor: Colors.white),
        cursorColor: Colors.black,
        animationDuration: Duration(milliseconds: 300),
        enableActiveFill: true,
        backgroundColor: Colors.transparent,
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onCompleted: (v) {
          print("Completed  $v");
        },
        onChanged: (value) {
          print(value);
        },
        onTap: () {
          OtpVerController.isError.value = 0;
        },
        beforeTextPaste: (text) {
          print("Allowing to paste $text");
          return true;
        },
        appContext: Get.context!,
      ),
    );
  }
}
