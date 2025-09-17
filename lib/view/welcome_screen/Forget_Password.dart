import 'package:club_runner/controller/ForgotPasswordController.dart';
import 'package:club_runner/util/FunctionConstant/FunctionConstant.dart';
import 'package:club_runner/util/asstes_image/AssetsImage.dart';
import 'package:club_runner/util/my_color/MyColor.dart';
//import 'package:country_calling_code_picker/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../util/custom_view/CustomView.dart';
import '../../util/masking_string_constant/MaskingStringConstant.dart';
import '../../util/size_config/SizeConfig.dart';
import '../../util/string_const/MyString.dart';
import '../../util/text_style/MyTextStyle.dart';

class ForgetPassswordScreen extends StatefulWidget {
  const ForgetPassswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPassswordScreen> createState() => _ForgetPassswordScreenState();
}

class _ForgetPassswordScreenState extends State<ForgetPassswordScreen> {
  final fp_Controller = ForgotPasswordController();

  @override
  void initState() {
    print("resendType ${fp_Controller.resendType}");
    fp_Controller.initCountry();
    fp_Controller.maskFormatter.value = MaskTextInputFormatter(
        mask: '##-###-####',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        return GestureDetector(
          onTap: () {
            CommonFunction.keyboardHide(context);
          },
          child: Scaffold(
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(left: 30, right: 30),
              child: SizedBox(
                width: SizeConfig.screenWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Image.asset(
                          MyAssetsImage.app_back_icon,
                          fit: BoxFit.contain,
                          height: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Image.asset(
                        MyAssetsImage.app_trainza_img,
                        height: 50,
                        width: 218,
                        color: MyColor.app_white_color,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: CustomView.twotextView(
                          MyString.pass_var,
                          FontWeight.w800,
                          MyString.reminder_var,
                          FontWeight.w300,
                          20,
                          MyColor.app_white_color,
                          1.74),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Send to",
                          style: MyTextStyle.textStyle(
                              FontWeight.w500, 12, MyColor.app_white_color),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          onTap: () {
                            fp_Controller.resendType.value = true;
                            fp_Controller.isError.value = 0;
                            fp_Controller.phoneController.text = "";
                          },
                          child: Row(
                            children: [
                              Image.asset(MyAssetsImage.app_emailImage,
                                  width: 22.2,
                                  height: 17.33,
                                  color: fp_Controller.resendType.value
                                      ? MyColor.app_white_color
                                      : MyColor.app_icon_inactive_color),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Email",
                                style: MyTextStyle.textStyle(
                                    FontWeight.w500,
                                    12,
                                    fp_Controller.resendType.value
                                        ? MyColor.app_white_color
                                        : MyColor.app_icon_inactive_color),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 22.75,
                          width: 0.9,
                          color: Color(0xFF8a8a8a),
                        ),
                        InkWell(
                          onTap: () {
                            fp_Controller.resendType.value = false;
                            fp_Controller.isError.value = 0;
                            fp_Controller.emailController.text = "";
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 12,
                              ),
                              Image.asset(MyAssetsImage.app_phoneImage,
                                  width: 13.12,
                                  height: 22.42,
                                  color: !fp_Controller.resendType.value
                                      ? MyColor.app_white_color
                                      : MyColor.app_icon_inactive_color),
                              SizedBox(
                                width: 8,
                              ),
                              Text("Mobile",
                                  style: MyTextStyle.textStyle(
                                      FontWeight.w500,
                                      12,
                                      !fp_Controller.resendType.value
                                          ? MyColor.app_white_color
                                          : MyColor.app_icon_inactive_color)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    fp_Controller.resendType.value
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: CustomView.editTextFiled(
                                fp_Controller.emailController,
                                TextInputType.emailAddress,
                                MyString.email_var,
                                FontWeight.w500,
                                FontWeight.w500,
                                Container(
                                  margin: EdgeInsets.all(13),
                                  child: Image.asset(
                                      MyAssetsImage.app_emailImage,
                                      width: 18,
                                      height: 14,
                                      color: MyColor.app_hint_color),
                                ),
                                false, () {
                              fp_Controller.isError.value = 0;
                            }, [
                              LengthLimitingTextInputFormatter(50),
                            ]),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: CustomView.phoneTextField(
                                fp_Controller.phoneController,
                                [
                                  LengthLimitingTextInputFormatter(15),
                                  FilteringTextInputFormatter.digitsOnly,
                                  fp_Controller.maskFormatter.value!,
                                  /*if (fp_Controller.selectedCountry != null)
                                  CountryNumberFormatter(
                                    isoCode: fp_Controller
                                        .selectedCountry.value!.countryCode,
                                    dialCode: fp_Controller
                                        .selectedCountry.value!.callingCode,
                                    onInputFormatted: (TextEditingValue value) {
                                      fp_Controller.phoneController.text =
                                          value.text;
                                    },
                                  )*/
                                ],
                                () {
                                  fp_Controller.isError.value = 0;
                                },
                                () {
                                  CommonFunction.keyboardHide(context);
                                  fp_Controller.onPressed();
                                },
                                fp_Controller.selectedCountry.value ??
                                    Country(
                                      name: MyString.southAfrica_var,
                                      flag: MyAssetsImage.app_flagSA_icon,
                                      code:
                                          MyString.southAfrica_countryCode_var,
                                      dialCode:
                                          MyString.southAfrica_dialCode_var,
                                      nameTranslations: {},
                                      minLength: 3,
                                      maxLength: 15,
                                    ),
                                (event) {
                                  print('onTapOutside');
                                  CommonFunction.keyboardHide(Get.context!);
                                },
                                maskHint: PhoneNumberMask.getMaskPattern(
                                        "+${fp_Controller.selectedCountry.value!.dialCode}")
                                    .replaceAll('#', "_ ")),
                          ),
                    fp_Controller.isError.value == 1 ||
                            fp_Controller.isError.value == 2 ||
                            fp_Controller.isError.value == 3 ||
                            fp_Controller.isError.value == 4
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: CustomView.errorField(
                                fp_Controller.errorMessage1.value,
                                fp_Controller.errorMessage2.value,
                                FontWeight.w500,
                                FontWeight.w700,
                                10),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: CustomView.buttonShow(
                          MyString.submit_var,
                          FontWeight.w600,
                          5.0,
                          16.8,
                          MyColor.app_orange_color.value ?? Color(0xFFFF4300),
                          () async {
                        if (await fp_Controller.validations(context)) {
                          fp_Controller.ForgotPasswordApi(
                              context,
                              fp_Controller.resendType.value ? "1" : "2",
                              fp_Controller.emailController.text,
                              fp_Controller.selectedCountry.value!.dialCode
                                  .replaceAll("+", ""),
                              fp_Controller.phoneController.text
                                  .replaceAll("-", ""));
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
