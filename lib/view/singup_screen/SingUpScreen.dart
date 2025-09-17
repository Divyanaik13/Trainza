import 'package:club_runner/controller/SignUpController.dart';
import 'package:club_runner/util/FunctionConstant/FunctionConstant.dart';
import 'package:club_runner/util/custom_view/CustomView.dart';
import 'package:club_runner/util/route_helper/RouteHelper.dart';
import 'package:club_runner/util/string_const/MyString.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../util/asstes_image/AssetsImage.dart';
import '../../util/masking_string_constant/MaskingStringConstant.dart';
import '../../util/my_color/MyColor.dart';
import '../../util/size_config/SizeConfig.dart';
import '../../util/text_style/MyTextStyle.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({super.key});

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  SignUpScreenController sp_controller = Get.put(SignUpScreenController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    sp_controller.initCountry();
    sp_controller.maskFormatter.value  =  MaskTextInputFormatter(
        mask: '##-###-####',
        filter: { "#": RegExp(r'[0-9]') },
        type: MaskAutoCompletionType.lazy
    );
  }

  @override
  Widget build(BuildContext context) {
    var heightPerBox = SizeConfig.blockSizeVerticalHeight;
    var widthPerBox = SizeConfig.blockSizeHorizontalWith;

    var headingInputStyle = TextStyle(
        color: MyColor.app_white_color,
        fontSize: 12,
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w600,
        letterSpacing: 1);
    var subheadingInputStyle =
        MyTextStyle.textStyle(FontWeight.w400, 12, MyColor.app_white_color);

    return Container(
      color: MyColor.screen_bg,
      child: SafeArea(
        child: Obx(() {
          return GestureDetector(
            onTap: () {
              CommonFunction.keyboardHide(context);
            },
            child: Scaffold(
              body:  SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Column(
                      children: [
                        // CustomView.customAppBarAuth(
                        //     MyString.sing_var, MyString.up_var, 20.0, 1.74, () {
                        //   Get.toNamed(RouteHelper.welcomeScreen);
                        // }),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: CustomView.customAppBar(
                              MyString.sing_var, MyString.up_var, () {
                            Get.back();
                          }),
                        ),
                        SizedBox(
                          height: 38,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              MyString.create_your_var,
                              style: MyTextStyle.textStyle(
                                  FontWeight.w600, 15, MyColor.app_white_color),
                            ),
                            Image.asset(
                              MyAssetsImage.app_trainza_img,
                              width: 100,
                            ),
                            Text(MyString.account_var,
                                style: MyTextStyle.textStyle(FontWeight.w600,
                                    15, MyColor.app_white_color))
                          ],
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //first name
                              Text(
                                MyString.first_name_var.toUpperCase(),
                                style: headingInputStyle,
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              CustomView.editTextFiled(
                                  sp_controller.nameTextCTRL,
                                  TextInputType.text,
                                  MyString.first_name_var,
                                  FontWeight.w400,
                                  FontWeight.w500,
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Image.asset(
                                      MyAssetsImage.app_personImage,
                                      color: MyColor.app_hint_color,
                                    ),
                                  ),
                                  false, () {
                                sp_controller.isError.value = 0;
                              }, [
                                LengthLimitingTextInputFormatter(30),
                                // FilteringTextInputFormatter.deny(
                                //     MyString.nameregex)
                              ]),
                              sp_controller.isError.value == 1
                                  ? CustomView.errorField(
                                      sp_controller.errorMessage1.value,
                                      sp_controller.errorMessage2.value,
                                      FontWeight.w500,
                                      FontWeight.w700,
                                      10)
                                  : SizedBox(),
                              SizedBox(
                                height: 12,
                              ),

                              // last name
                              Text(
                                MyString.last_name_var.toUpperCase(),
                                style: headingInputStyle,
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              CustomView.editTextFiled(
                                  sp_controller.lastNameTextCTRL,
                                  TextInputType.text,
                                  MyString.last_name_var,
                                  FontWeight.w400,
                                  FontWeight.w500,
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Image.asset(
                                      MyAssetsImage.app_personImage,
                                      color: MyColor.app_hint_color,
                                    ),
                                  ),
                                  false, () {
                                sp_controller.isError.value = 0;
                              }, [
                                LengthLimitingTextInputFormatter(30),
                                // FilteringTextInputFormatter.deny(
                                //     MyString.nameregex)
                              ]),
                              sp_controller.isError.value == 2
                                  ? CustomView.errorField(
                                      sp_controller.errorMessage1.value,
                                      sp_controller.errorMessage2.value,
                                      FontWeight.w500,
                                      FontWeight.w700,
                                      10)
                                  : SizedBox(),
                              SizedBox(
                                height: 12,
                              ),

                              //email address
                              Row(
                                children: [
                                  Text(
                                    MyString.email_address_Capital_var
                                        .toUpperCase(),
                                    style: headingInputStyle,
                                  ),
                                  Text(
                                    MyString.requider_var.toUpperCase(),
                                    style: subheadingInputStyle,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              CustomView.editTextFiled(
                                  sp_controller.emailTextCTRL,
                                  TextInputType.emailAddress,
                                  MyString.email_var,
                                  FontWeight.w400,
                                  FontWeight.w500,
                                  Container(
                                    margin: EdgeInsets.all(13),
                                    child: Image.asset(
                                        MyAssetsImage.app_emailImage,
                                        color: MyColor.app_hint_color),
                                  ),
                                  false, () {
                                sp_controller.isError.value = 0;
                              }, [
                                LengthLimitingTextInputFormatter(50),
                              ]),
                              sp_controller.isError.value == 3
                                  ? CustomView.errorField(
                                      sp_controller.errorMessage1.value,
                                      sp_controller.errorMessage2.value,
                                      FontWeight.w500,
                                      FontWeight.w700,
                                      10)
                                  : SizedBox(),
                              SizedBox(
                                height: 12,
                              ),

                              //phone number
                              Row(
                                children: [
                                  Text(
                                    MyString.mobileNoCapital_var.toUpperCase(),
                                    style: headingInputStyle,
                                  ),
                                  Text(
                                    MyString.requider_var.toUpperCase(),
                                    style: subheadingInputStyle,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              CustomView.phoneTextField(
                                sp_controller.phoneController,
                                [
                                  LengthLimitingTextInputFormatter(15),
                                  FilteringTextInputFormatter.digitsOnly,
                                  sp_controller.maskFormatter.value!,
                                 /* CountryNumberFormatter(
                                    isoCode: sp_controller.selectedCountry1.value!.countryCode,
                                    dialCode: sp_controller.selectedCountry1.value!.callingCode,
                                    onInputFormatted: (TextEditingValue value) {
                                      sp_controller.phoneController.text = value.text;
                                    },
                                  )*/
                                ],
                                () {
                                  sp_controller.isError.value = 0;
                                },
                                () {
                                  CommonFunction.keyboardHide(context);
                                  sp_controller.onPressed();
                                },
                                sp_controller.selectedCountry1.value!,
                                    (event) {
                                  print('onTapOutside');
                                  CommonFunction.keyboardHide(Get.context!);
                                },
                                  maskHint: PhoneNumberMask.getMaskPattern("+${sp_controller.selectedCountry1.value!.dialCode}")
                                      .replaceAll('#', "_ ")
                              ),
                              sp_controller.isError.value == 4 ||
                                      sp_controller.isError.value == 5
                                  ? CustomView.errorField(
                                      sp_controller.errorMessage1.value,
                                      sp_controller.errorMessage2.value,
                                      FontWeight.w500,
                                      FontWeight.w700,
                                      10)
                                  : SizedBox(),
                              SizedBox(
                                height: 10,
                              ),

                              //Password
                              Row(
                                children: [
                                  Text(
                                    MyString.pass_var.toUpperCase(),
                                    style: headingInputStyle,
                                  ),
                                  Text(
                                    MyString.requider_var.toUpperCase(),
                                    style: subheadingInputStyle,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              CustomView.passwordTextFiled(
                                  sp_controller.yourPassTextCTRL,
                                  sp_controller.passwordVisible,
                                  MyString.password_var,
                                  Container(
                                      margin: EdgeInsets.all(10),
                                      child: Image.asset(
                                          MyAssetsImage.app_lockImage)), () {
                                sp_controller.isError.value = 0;
                              }),
                              sp_controller.isError.value == 6 ||
                                      sp_controller.isError.value == 7 ||
                                      sp_controller.isError.value == 8
                                  ? CustomView.errorField(
                                      sp_controller.errorMessage1.value,
                                      sp_controller.errorMessage2.value,
                                      FontWeight.w500,
                                      FontWeight.w700,
                                      10)
                                  : SizedBox(),
                              SizedBox(
                                height: 7,
                              ),

                              // Repeat password
                              CustomView.passwordTextFiled(
                                  sp_controller.confirmPassTextCTRL,
                                  sp_controller.passwordVisibleSecond,
                                  MyString.confirm_password_var,
                                  Container(
                                      margin: EdgeInsets.all(10),
                                      child: Image.asset(
                                        MyAssetsImage.app_lockImage,
                                      )), () {
                                sp_controller.isError.value = 0;
                              }),
                              sp_controller.isError.value == 9 ||
                                      sp_controller.isError.value == 10
                                  ? CustomView.errorField(
                                      sp_controller.errorMessage1.value,
                                      sp_controller.errorMessage2.value,
                                      FontWeight.w500,
                                      FontWeight.w700,
                                      10)
                                  : SizedBox(),
                              SizedBox(
                                height: 24,
                              ),

                            ],
                          ),
                        ),
                        CustomView.checkBox(
                            sp_controller.checked.value,
                            MyString.accept_terms_var,
                            widthPerBox! * 1, (value) {
                          sp_controller.checked.value = value!;
                          sp_controller.isError.value = 0;
                        }),
                        sp_controller.isError.value == 11
                            ? CustomView.errorField(
                            sp_controller.errorMessage1.value,
                            sp_controller.errorMessage2.value,
                            FontWeight.w500,
                            FontWeight.w700,
                            10)
                            : SizedBox(),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: CustomView.buttonShow(
                              MyString.register_now_var,
                              FontWeight.w500,
                              4.32,
                              16.8,
                              MyColor.app_orange_color.value??Color(0xFFFF4300), () async{
                            CommonFunction.keyboardHide(context);
                            // sp_controller.validation(context);
                            if (await sp_controller.validation(context)) {
                             /* Map<String, String>? paramValue = {
                                "email": sp_controller.emailTextCTRL.text,
                                "phone_number" : sp_controller.phoneController.text,
                                "dial_code":sp_controller.selectedCountry1.value!.callingCode.replaceAll("+", "")
                              };

                              Get.toNamed(RouteHelper.getOtpVerifyScreen(),parameters: paramValue);*/
                              sp_controller.SignUpApi(
                                  context,
                                  sp_controller.nameTextCTRL.text.trim(),
                                  sp_controller.lastNameTextCTRL.text.trim(),
                                  sp_controller.emailTextCTRL.text.trim(),
                                  sp_controller.selectedCountry1.value!.dialCode.replaceAll("+", ""),
                                  sp_controller.selectedCountry1.value!.code,
                                  sp_controller.phoneController.text.trim().replaceAll("-", ""),
                                  sp_controller.yourPassTextCTRL.text.trim(),
                                  sp_controller.confirmPassTextCTRL.text.trim());
                            }
                          }),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          MyString.or_sign_up_with_var,
                          textAlign: TextAlign.center,
                          style: MyTextStyle.textStyle(
                              FontWeight.w400, 15, MyColor.app_white_color),
                        ),
                        SizedBox(
                          height: 11,
                        ),

                        //social button
                        sp_controller.socialLogin(context),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(MyString.already_registered_var,
                                  style: MyTextStyle.textStyle(FontWeight.w400,
                                      16, MyColor.app_white_color)),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(MyString.sign_in_var,
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w700,
                                        16,
                                        MyColor.app_white_color)),
                              )
                            ]),
                        SizedBox(
                          height: 35,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                            onPressed: () {
                             Get.toNamed(RouteHelper.getTermsConditions());
                            },
                            child: Text(
                              MyString.terms_of_use_var,
                              style: MyTextStyle.textStyle(
                                  FontWeight.w400, 13, MyColor.app_white_color),
                            )),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.0), // Adjust the horizontal padding
                          child: Text(
                            "|",
                            style: TextStyle(
                              color: MyColor.app_white_color,
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                             Get.toNamed(RouteHelper.getPrivacyPolicy());
                            },
                            child: Text(
                              MyString.privacy_Policy_var,
                              style: MyTextStyle.textStyle(
                                  FontWeight.w400, 13, MyColor.app_white_color),
                            )),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.0),
                          child: Text(
                            "|",
                            style: TextStyle(
                              color: MyColor.app_white_color,
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              sp_controller.launchURL("https://www.google.com/");
                            },
                            child: Text(
                              MyString.contact_var,
                              style: MyTextStyle.textStyle(
                                  FontWeight.w400, 13, MyColor.app_white_color),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
