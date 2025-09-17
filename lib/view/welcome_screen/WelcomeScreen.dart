import 'package:club_runner/controller/WelcomeScreenController.dart';
import 'package:club_runner/util/FunctionConstant/FunctionConstant.dart';
import 'package:club_runner/util/asstes_image/AssetsImage.dart';
import 'package:club_runner/util/custom_view/CustomView.dart';
import 'package:club_runner/util/local_storage/LocalStorage.dart';
import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:club_runner/util/route_helper/RouteHelper.dart';
import 'package:club_runner/util/size_config/SizeConfig.dart';
import 'package:club_runner/util/string_const/MyString.dart';
import 'package:club_runner/util/text_style/MyTextStyle.dart';
//import 'package:country_calling_code_picker/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../util/masking_string_constant/MaskingStringConstant.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var fontSize = SizeConfig.fontSize();

  WelcomeScreenController ws_controller = Get.put(WelcomeScreenController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      ws_controller.initCountry(context);
    });
    ws_controller.maskFormatter.value = MaskTextInputFormatter(
        mask: '##-###-####',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
    getValue();
  }

  @override
  Widget build(BuildContext context) {
    var widthPerBox = SizeConfig.blockSizeHorizontalWith;
    return Container(
      color: MyColor.screen_bg,
      child: SafeArea(child: Obx(() {
        return Scaffold(
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(50),
            child: Form(
              key: formKey,
              child: SizedBox(
                width: SizeConfig.screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Image.asset(
                      MyAssetsImage.app_trainza_img,
                      fit: BoxFit.contain,
                      width: 220,
                      height: 50,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomView.twotextView(
                        MyString.welcome_var,
                        FontWeight.w800,
                        MyString.back_var,
                        FontWeight.w300,
                        20,
                        MyColor.app_white_color,
                        1.74),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          MyString.loginWith_var,
                          style: MyTextStyle.textStyle(
                              FontWeight.w500, 12, MyColor.app_white_color),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            ws_controller.loginType.value = true;
                            if (ws_controller.checked == false) {
                              ws_controller.clear();
                            }
                            CommonFunction.keyboardHide(context);
                          },
                          child: Row(
                            children: [
                              Image.asset(MyAssetsImage.app_emailImage,
                                  width: 22.2,
                                  height: 17.33,
                                  color: ws_controller.loginType.value
                                      ? MyColor.app_white_color
                                      : MyColor.app_icon_inactive_color),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                MyString.email_var.substring(0, 5),
                                style: MyTextStyle.textStyle(
                                    FontWeight.w500,
                                    12,
                                    ws_controller.loginType.value
                                        ? MyColor.app_white_color
                                        : MyColor.app_icon_inactive_color),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 22.75,
                          width: 0.9,
                          color: MyColor.app_icon_inactive_color,
                        ),
                        InkWell(
                          onTap: () {
                            ws_controller.loginType.value = false;
                            if (ws_controller.checked == false) {
                              ws_controller.clear();
                            }
                            CommonFunction.keyboardHide(context);
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Image.asset(MyAssetsImage.app_phoneImage,
                                  // width: widthPerBox !* 3,
                                  width: 13.12,
                                  height: 22.42,
                                  color: !ws_controller.loginType.value
                                      ? MyColor.app_white_color
                                      : MyColor.app_icon_inactive_color),
                              SizedBox(
                                width: widthPerBox! * 2,
                              ),
                              Text(MyString.mobile_var,
                                  style: MyTextStyle.textStyle(
                                      FontWeight.w500,
                                      12,
                                      !ws_controller.loginType.value
                                          ? MyColor.app_white_color
                                          : MyColor.app_icon_inactive_color)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    ws_controller.loginType.value
                        ? CustomView.editTextFiled(
                            ws_controller.emailController,
                            TextInputType.emailAddress,
                            MyString.email_var,
                            FontWeight.w500,
                            FontWeight.w500,
                            Container(
                              margin: EdgeInsets.all(13),
                              child: Image.asset(
                                MyAssetsImage.app_emailImage,
                                color: MyColor.app_hint_color,
                              ),
                            ),
                            false, () {
                            ws_controller.isError.value = 0;
                          }, [
                            LengthLimitingTextInputFormatter(50),
                          ])
                        : CustomView.phoneTextField(
                            ws_controller.phoneController,
                            [
                              LengthLimitingTextInputFormatter(20),
                              FilteringTextInputFormatter.digitsOnly,
                              ws_controller.maskFormatter.value!
                            ],
                            () {
                              print("phoneController value :- " +
                                  ws_controller.phoneController.text);
                              ws_controller.isError.value = 0;
                            },
                            () {
                              CommonFunction.keyboardHide(context);
                              ws_controller.onPressed();
                              print(
                                  "object ${LocalStorage.getStringValue(ws_controller.sp.countryname)}");
                            },
                            ws_controller.selectedCountry.value!.dialCode == ""
                                ? (LocalStorage.getStringValue(ws_controller.sp.countryname) != ""
                                    ? Country(
                                        name: LocalStorage.getStringValue(
                                            ws_controller.sp.countryname),
                                        flag: LocalStorage.getStringValue(
                                            ws_controller.sp.countryflag),
                                        code: LocalStorage.getStringValue(
                                            ws_controller.sp.countrycode),
                                        dialCode: LocalStorage.getStringValue(
                                            ws_controller.sp.dialcodeReminder),
                                        nameTranslations: {},
                                        minLength: 3,
                                        maxLength: 15,
                                      )
                                    : Country(
                                        name: MyString.southAfrica_var,
                                        flag: MyAssetsImage.app_flagSA_icon,
                                        code: MyString
                                            .southAfrica_countryCode_var,
                                        dialCode:
                                            MyString.southAfrica_dialCode_var,
                                        nameTranslations: {},
                                        minLength: 3,
                                        maxLength: 15,
                                      ))
                                : Country(
                                    name: ws_controller
                                        .selectedCountry.value!.name,
                                    flag: ws_controller
                                        .selectedCountry.value!.flag,
                                    code: ws_controller
                                        .selectedCountry.value!.code,
                                    dialCode: ws_controller
                                        .selectedCountry.value!.dialCode,
                                    nameTranslations: {},
                                    minLength: 3,
                                    maxLength: 15,
                                  ),
                            (event) {
                              print('onTapOutside');
                              CommonFunction.keyboardHide(Get.context!);
                            },
                            maskHint: PhoneNumberMask.getMaskPattern(
                                    "+${ws_controller.selectedCountry.value!.dialCode}")
                                .replaceAll('#', "_ ")),

                    ws_controller.isError.value == 1 ||
                            ws_controller.isError.value == 2 ||
                            ws_controller.isError.value == 3 ||
                            ws_controller.isError.value == 4
                        ? CustomView.errorField(
                            ws_controller.errorMessage1.value,
                            ws_controller.errorMessage2.value,
                            FontWeight.w500,
                            FontWeight.w700,
                            10)
                        : SizedBox(),
                    SizedBox(
                      height: 15,
                    ),
                    CustomView.passwordTextFiled(
                      ws_controller.passController,
                      ws_controller.passwordVisible,
                      MyString.password_var,
                      Container(
                          margin: EdgeInsets.all(8),
                          child: Image.asset(
                            MyAssetsImage.app_lockImage,
                            color: MyColor.app_hint_color,
                          )),
                      () {
                        ws_controller.isError.value = 0;
                      },
                    ),
                    ws_controller.isError.value == 5
                        ? CustomView.errorField(
                            ws_controller.errorMessage1.value,
                            ws_controller.errorMessage2.value,
                            FontWeight.w500,
                            FontWeight.w700,
                            10)
                        : SizedBox(),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    ws_controller.checkBox(context),
                    SizedBox(
                      height: 10,
                    ),
                    CustomView.buttonShow(
                        MyString.login_var,
                        FontWeight.w600,
                        4.32,
                        16.8,
                        MyColor.app_orange_color.value ?? Color(0xFFFF4300),
                        () async {
                      CommonFunction.keyboardHide(context);
                      if (await ws_controller.validation(context)) {
                        // Get.offNamed(RouteHelper.getMainScreen());
                        ws_controller.loginAPi(
                            context,
                            ws_controller.loginType.value ? "1" : "2",
                            ws_controller.loginType.value
                                ? ws_controller.emailController.text
                                : "",
                            ws_controller.selectedCountry.value!.dialCode
                                .replaceAll("+", ""),
                            ws_controller.selectedCountry.value!.name,
                            ws_controller.selectedCountry.value!.code,
                            ws_controller.selectedCountry.value!.flag,
                            ws_controller.phoneController.text
                                .replaceAll("-", ""),
                            ws_controller.passController.text.trim());
                      }
                    }),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      MyString.login_with_var,
                      style: MyTextStyle.textStyle(
                          FontWeight.w400, 15, MyColor.app_white_color),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    // Social button
                    ws_controller.socialLogin(context),
                    // InkWell(
                    //     onTap: () {
                    //       Get.toNamed(RouteHelper.getSingUpScreen());
                    //       CommonFunction.keyboardHide(context);
                    //       ws_controller.clear();
                    //     },
                    //     child: CustomView.differentStyleTextTogether(
                    //         MyString.new_here_var,
                    //         FontWeight.w400,
                    //         MyString.sing_up_var,
                    //         FontWeight.w700,
                    //         16,
                    //         MyColor.app_white_color)),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(MyString.new_here_var,
                          style: MyTextStyle.textStyle(
                              FontWeight.w400, 16, MyColor.app_white_color)),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          Get.toNamed(RouteHelper.getSingUpScreen());
                          CommonFunction.keyboardHide(context);
                          if (ws_controller.checked == false) {
                            ws_controller.clear();
                          }
                        },
                        child: Text(MyString.sing_up_var,
                            style: MyTextStyle.textStyle(
                                FontWeight.w700, 16, MyColor.app_white_color)),
                      )
                    ])
                  ],
                ),
              ),
            ),
          ),
        );
      })),
    );
  }

  void getValue() {
    var isCheckedRM = LocalStorage.getBoolValue(ws_controller.sp.isRemember);
    var email = LocalStorage.getStringValue(ws_controller.sp.emailRemember);
    var phone = LocalStorage.getStringValue(ws_controller.sp.phoneReminder);
    var dialCode =
        LocalStorage.getStringValue(ws_controller.sp.dialcodeReminder);
    var countryflag = LocalStorage.getStringValue(ws_controller.sp.countryflag);
    var countryname = LocalStorage.getStringValue(ws_controller.sp.countryname);
    var countrycode = LocalStorage.getStringValue(ws_controller.sp.countrycode);
    var loginwith =
        LocalStorage.getStringValue(ws_controller.sp.loginTypeRemember);
    var pass = LocalStorage.getStringValue(ws_controller.sp.passwordRemember);

    print("email getValue :-- $email");
    print("loginwith getValue :-- $loginwith");
    print("dialCode getValue :-- $dialCode");
    print("phone getValue :-- $phone");
    print("countryflag getValue :-- $countryflag");
    print("countryname getValue :-- $countryname");
    print("countrycode getValue :-- $countrycode");
    isCheckedRM ??= false;
    if (isCheckedRM) {
      ws_controller.emailController.text = email.toString().trim();
      ws_controller.passController.text = pass.toString().trim();
      ws_controller.checked.value = isCheckedRM;
      ws_controller.phoneController.text = phone.toString().trim();
      ws_controller.selectedCountry.value = Country(
        name: countryname,
        flag: countryflag,
        code: countrycode,
        dialCode: dialCode,
        nameTranslations: {},
        minLength: 3,
        maxLength: 15,
      );
      ws_controller.loginType.value = loginwith == "false" ? false : true;
      print(
          "get value after logout ${ws_controller.selectedCountry.value!.dialCode}");
      String maskPattern = PhoneNumberMask.getMaskPattern(
          "+${ws_controller.selectedCountry.value!.dialCode}");
      print("get value after logout maskPattern $maskPattern");
      ws_controller.maskFormatter.value = MaskTextInputFormatter(
          mask: '+# (###) ###-##-##',
          // mask: maskPattern,
          filter: {"#": RegExp(r'[0-9]')},
          type: MaskAutoCompletionType.lazy);

      if (ws_controller.maskFormatter.value != null) {
        ws_controller.maskFormatter.value!.updateMask(mask: maskPattern);
      }
      ws_controller.phoneController.text = ws_controller.maskFormatter.value!
          .maskText(ws_controller.phoneController.text);
    }
  }
}
