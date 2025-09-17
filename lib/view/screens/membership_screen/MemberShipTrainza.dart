import 'package:club_runner/controller/MembershipController.dart';
import 'package:club_runner/util/custom_view/CustomView.dart';
import 'package:club_runner/util/route_helper/RouteHelper.dart';
import 'package:club_runner/util/text_style/MyTextStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import '../../../util/FunctionConstant/FunctionConstant.dart';
import '../../../util/asstes_image/AssetsImage.dart';
import '../../../util/local_storage/LocalStorage.dart';
import '../../../util/my_color/MyColor.dart';
import '../../../util/size_config/SizeConfig.dart';
import '../../../util/string_const/MyString.dart';

class Membership extends StatefulWidget {
  const Membership({super.key});

  @override
  State<Membership> createState() => _MembershipState();
}

class _MembershipState extends State<Membership> {
  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var screenWidth = SizeConfig.screenWidth;
  var fontSize = SizeConfig.fontSize();

  MembershipController ms_controller = Get.put(MembershipController());

  @override
  void initState() {
    // TODO: implement initState
    ms_controller.getMembership_Api();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColor.screen_bg,
      child: SafeArea(child: Obx(() {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            Future.delayed(Duration.zero, () {
              print("PopScope 1 $didPop");
              Get.back(result: "refresh");
            });
          },
          /* onWillPop: () async{
            Get.back(result: "refresh");
            return true;
          },*/
          child: Scaffold(
            body:  SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ms_controller.membershipInfo.value == null
                  ? Container()
                  : Column(
                      children: [
                        CustomView.customAppBar("MEMBER", "SHIP", () {
                          Get.back(result: "refresh");
                        }),
                        SizedBox(height: 10),
                        ms_controller.membershipInfo.value!.membershipStatus ==
                            ""?SizedBox():CustomView.membershipStatus(
                            () {},
                            ms_controller.membershipInfo.value!.membershipStatus ==
                                    "1"
                                ? MyString.active_var
                                : MyString.notActive_var,
                            Image.asset(
                              ms_controller.membershipInfo.value!.membershipStatus ==
                                      "1"
                                  ? MyAssetsImage.app_activeCheck
                                  : MyAssetsImage.app_RedCrossIcon,
                              height: 31,
                              width: 31,
                            ),
                            ms_controller.membershipInfo.value!
                                        .membershipStatus ==
                                    "1"
                                ? Color(0xFFFF4300)
                                : Color(0xFFFF0000)),
                        SizedBox(height: 13),
                        Container(
                          // padding: EdgeInsets.all(10),
                          height: 41,
                          alignment: Alignment.center,
                          width: screenWidth,
                          // color: Color(0xFFDEDEDE),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4)),
                            border: Border.all(
                              color: MyColor.app_orange_color.value ??
                                  Color(0xFFFF4300),
                            ),
                            color: MyColor.app_orange_color.value ??
                                Color(0xFFFF4300),
                          ),

                          child: Text(
                            MyString.about_var,
                            style: MyTextStyle.textStyle(FontWeight.w900, 17,
                                MyColor.app_button_text_dynamic_color,
                                letterSpacing: 1.48),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Card(
                          margin: EdgeInsets.zero,
                          color: Color(0xFFDEDEDE),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(4),
                                  bottomRight: Radius.circular(4)),
                              side: BorderSide(
                                color: Color(0xFFDEDEDE),
                              )),
                          child: Column(children: [
                            Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Text(
                                    "${ms_controller.membershipInfo.value!.title}",
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w600,
                                        32,
                                        MyColor.app_black_color,
                                        letterSpacing: -1,
                                        lineHeight: 1.063),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 10),
                                  HtmlWidget(
                                    '''${ms_controller.Info.value}''',
                                    textStyle: MyTextStyle.textStyle(
                                        FontWeight.w400,
                                        16,
                                        MyColor.app_black_color,
                                        lineHeight: 1.5),
                                  ),
                                ],
                              ),
                            ),
                            Divider(color: Color(0xFF3F3F3F)),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  ms_controller.membershipButtonStatus.value.toString() == "1"? Column(
                                    children: [
                                      CustomView.differentStyleTextTogether(
                                          MyString.contactCapital_var,
                                          FontWeight.w400,
                                          MyString.details_var,
                                          FontWeight.w700,
                                          20,
                                          MyColor.app_black_color),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        MyString.phone_var,
                                        style: MyTextStyle.textStyle(
                                            FontWeight.w700,
                                            14,
                                            MyColor.app_black_color,
                                            letterSpacing: 4,
                                            lineHeight: 1.429),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      /* RichText(
                                        text: TextSpan(
                                          children: [
                                            if (ms_controller.membershipInfo.value!.phoneNumber.isNotEmpty)
                                              TextSpan(
                                                text: "+${ms_controller.membershipInfo.value!.phoneDialCode} ${ms_controller.membershipInfo.value!.phoneNumber.replaceAll("+", "")}",
                                                style: MyTextStyle.textStyle(FontWeight.w600, 24, MyColor.app_black_color),
                                              )
                                            else
                                              TextSpan(
                                                text: "NA",
                                                style: MyTextStyle.textStyle(FontWeight.w400, 14, MyColor.app_black_color,letterSpacing: 1),
                                              ),
                                          ],
                                        ),
                                      ),*/
                                      Text(
                                        ms_controller.membershipInfo.value!
                                                .phoneNumber.isNotEmpty
                                            ? "+${ms_controller.membershipInfo.value!.phoneDialCode.replaceAll("+", "")} ${ms_controller.membershipInfo.value!.phoneNumber}"
                                            : "NA",
                                        style: ms_controller.membershipInfo.value!
                                                .phoneNumber.isEmpty
                                            ? MyTextStyle.textStyle(FontWeight.w400,
                                                15, MyColor.app_black_color,
                                                letterSpacing: 1)
                                            : MyTextStyle.textStyle(FontWeight.w600,
                                                24, MyColor.app_black_color),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        MyString.email_single_var,
                                        style: MyTextStyle.textStyle(
                                            FontWeight.w700,
                                            14,
                                            MyColor.app_black_color,
                                            letterSpacing: 4,
                                            lineHeight: 1.429),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "${ms_controller.membershipInfo.value!.contactEmail == "" ? "NA" : ms_controller.membershipInfo.value!.contactEmail}",
                                        style: ms_controller.membershipInfo.value!
                                                    .contactEmail ==
                                                ""
                                            ? MyTextStyle.textStyle(FontWeight.w400,
                                                15, MyColor.app_black_color,
                                                letterSpacing: 1)
                                            : MyTextStyle.textStyle(FontWeight.w400,
                                                16, MyColor.app_black_color,
                                                lineHeight: 1.25),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        MyString.website_var,
                                        style: MyTextStyle.textStyle(
                                            FontWeight.w700,
                                            14,
                                            MyColor.app_black_color,
                                            letterSpacing: 4,
                                            lineHeight: 1.429),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "${ms_controller.membershipInfo.value!.webAddress == "" ? "NA" : ms_controller.membershipInfo.value!.webAddress}",
                                        textAlign: TextAlign.center,
                                        style: ms_controller.membershipInfo.value!
                                                    .webAddress ==
                                                ""
                                            ? MyTextStyle.textStyle(FontWeight.w400,
                                                15, MyColor.app_black_color,
                                                letterSpacing: 1)
                                            : MyTextStyle.textStyle(FontWeight.w500,
                                                17, MyColor.app_black_color),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ):SizedBox(),

                            // .........................................................................

                                  Text(
                                    MyString.location_var,
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w700,
                                        14,
                                        MyColor.app_black_color,
                                        letterSpacing: 4,
                                        lineHeight: 1.429),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "${ms_controller.membershipInfo.value!.googleAddress == "" ? "NA" : ms_controller.membershipInfo.value!.googleAddress}",
                                    textAlign: TextAlign.center,
                                    style: ms_controller.membershipInfo.value!.googleAddress == ""
                                        ? MyTextStyle.textStyle(FontWeight.w400,
                                            15, MyColor.app_black_color,
                                            letterSpacing: 1)
                                        : MyTextStyle.textStyle(FontWeight.w500,
                                            19, MyColor.app_black_color,
                                            lineHeight: 1.053),
                                  ),
                                ],
                              ),
                            ),

                            //========================================
                            ms_controller.membershipButtonStatus.value.toString() == "1"?Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  ms_controller.membershipInfo.value!.latitude != 0.0
                                      ? Column(
                                          children: [
                                            CustomView
                                                .buttonShowWithdifferentTextStyle(
                                                    MyString.view,
                                                    MyString.location_var,
                                                    FontWeight.w400,
                                                    FontWeight.w700,
                                                    5,
                                                    17.28,
                                                    MyColor.app_orange_color
                                                            .value ??
                                                        Color(0xFFFF4300), () {
                                              CommonFunction.openMap(
                                                  ms_controller.membershipInfo
                                                      .value!.latitude,
                                                  ms_controller.membershipInfo
                                                      .value!.longitude);
                                            }, letterSpacing: 1.5),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                  ms_controller.membershipInfo.value!.webAddress != ""
                                      ? Column(
                                          children: [
                                            CustomView
                                                .buttonShowWithdifferentTextStyle(
                                                    MyString.view,
                                                    MyString.website_var,
                                                    FontWeight.w400,
                                                    FontWeight.w700,
                                                    5,
                                                    17.28,
                                                    MyColor.app_orange_color
                                                            .value ??
                                                        Color(0xFFFF4300), () {
                                              ms_controller.launchURL(
                                                  ms_controller.membershipInfo
                                                      .value!.webAddress);
                                            }, letterSpacing: 1.5),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                  ms_controller.membershipInfo.value!.contactEmail != ""
                                      ? Column(
                                          children: [
                                            CustomView
                                                .buttonShowWithdifferentTextStyle(
                                                    MyString.send_var,
                                                    MyString.email_single_var,
                                                    FontWeight.w400,
                                                    FontWeight.w700,
                                                    5,
                                                    17.28,
                                                    MyColor.app_orange_color
                                                            .value ??
                                                        Color(0xFFFF4300),
                                                    () async {
                                              ms_controller.emaillaunchURL(
                                                  "${ms_controller.membershipInfo.value!.contactEmail}",
                                                  "",
                                                  "");
                                            }, letterSpacing: 1.5),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                  ms_controller.membershipInfo.value!.phoneNumber != ""
                                      ? Column(
                                          children: [
                                            CustomView
                                                .buttonShowWithdifferentTextStyle(
                                                    MyString.phone_var,
                                                    MyString.call_var,
                                                    FontWeight.w400,
                                                    FontWeight.w700,
                                                    5,
                                                    17.28,
                                                    MyColor.app_orange_color
                                                            .value ??
                                                        Color(0xFFFF4300),
                                                    () async {
                                              ms_controller.launchPhoneCall(
                                                  "${ms_controller.membershipInfo.value!.phoneDialCode.replaceAll("+", "")} ${ms_controller.membershipInfo.value!.phoneNumber}");
                                            }, letterSpacing: 1.5),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                  ms_controller.membershipInfo.value!.whatsappNumber != ""
                                      ? Column(
                                          children: [
                                            CustomView
                                                .buttonShowWithdifferentTextStyle(
                                                    MyString.send_var,
                                                    MyString.whatsapp_var,
                                                    FontWeight.w400,
                                                    FontWeight.w700,
                                                    5,
                                                    17.28,
                                                    MyColor.app_orange_color
                                                            .value ??
                                                        Color(0xFFFF4300), () {
                                              ms_controller.launchWhatsapp(
                                                  "${ms_controller.membershipInfo.value!.whatsappDialCode} ${ms_controller.membershipInfo.value!.whatsappNumber}",
                                                  "Hii");
                                            }, letterSpacing: 1.5),
                                            SizedBox(
                                              height: 5,
                                            )
                                          ],
                                        )
                                      : SizedBox(),
                                  ms_controller.membershipInfo.value!.isBtnAdded =="1"?
                                  CustomView.buttonShowWithdifferentTextStyle(
                                      "",
                                      ms_controller.membershipInfo.value!.btnLbl,
                                      FontWeight.w400,
                                      FontWeight.w700,
                                      5,
                                      17.28,
                                      MyColor.app_orange_color.value ??
                                          Color(0xFFFF4300),
                                      () {
                                        ms_controller.launchURL(
                                            ms_controller.membershipInfo.value!.btnLink);
                                      },
                                      letterSpacing: 1.5):SizedBox()
                                ],
                              ),
                            ):SizedBox()
                          ]),
                        ),
                        SizedBox(height: 15),
                        // ClipRRect(
                        //     borderRadius: BorderRadius.circular(6),
                        //     child: Image.network(
                        //         "https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?auto=compress&cs=tinysrgb&w=600")),
                        // ms_controller.membershipInfo.value!.membershipStatus == "1" &&
                                ms_controller.membershipInfo.value!.membershipPageImg != ""
                            ? Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: MyColor.app_white_color),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Image.network(
                                  ms_controller
                                      .membershipInfo.value!.membershipPageImg,
                                  width: SizeConfig.screenWidth,
                                  fit: BoxFit.cover,
                                ))
                            : SizedBox(),

                        SizedBox(height: 25),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: ((SizeConfig.screenWidth)! -
                                    (SizeConfig.screenWidth! * 40 / 100)) /
                                1.62,
                            width: (SizeConfig.screenWidth)! -
                                (SizeConfig.screenWidth! * 40 / 100),
                            child: LocalStorage.getStringValue(ms_controller.sp.currentClubData_logo) == ""
                                ? Image.asset(
                                    MyAssetsImage.app_trainza_ratioLogo,
                                    fit: BoxFit.fill)
                                : Image.network(
                                    LocalStorage.getStringValue(
                                        ms_controller.sp.currentClubData_logo),
                                    fit: BoxFit.fill),
                          ),
                        ),
                        SizedBox(height: 17),
                        ms_controller.membershipInfo.value!.membershipStatus != ""
                            ? Column(
                                children: [
                                  CustomView.customButtonWithBorder(
                                      MyString.exitMembership_var, () {
                                    Get.toNamed(
                                        RouteHelper.removemembershipScreen);
                                  }, 198, 2.0),
                                  SizedBox(height: 60),
                                ],
                              )
                            : SizedBox(),

                        Container(
                          width: SizeConfig.screenWidth,
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: MyColor.app_border_grey_color),
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            children: [
                              CustomView.differentStyleTextTogether(
                                  MyString.powered_var,
                                  FontWeight.w400,
                                  MyString.by_var,
                                  FontWeight.w900,
                                  17,
                                  MyColor.app_white_color,
                                  letterSpacing: 1.5),
                              SizedBox(height: 5),
                              Image.asset(
                                MyAssetsImage.app_trainza_img,
                                width: 174,
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        ms_controller.membershipButtonStatus.value.toString() == "1"?Column(
                          children: [
                            InkWell(
                              onTap: (){
                                ms_controller.launchURL(
                                    ms_controller.membershipInfo.value!.trainzaUrl);
                              },
                              child: Container(
                                width: SizeConfig.screenWidth,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: MyColor.app_border_grey_color),
                                    borderRadius: BorderRadius.circular(5)),
                                child: CustomView.differentStyleTextTogether(
                                    MyString.visit_var,
                                    FontWeight.w400,
                                    MyString.website_var,
                                    FontWeight.w900,
                                    15,
                                    MyColor.app_white_color,
                                    letterSpacing: 1.5),
                              ),
                            ),
                            SizedBox(height: 12),
                            InkWell(
                              onTap: () {
                                Get.toNamed(RouteHelper.getContactUs());
                              },
                              child: Container(
                                width: SizeConfig.screenWidth,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: MyColor.app_border_grey_color),
                                    borderRadius: BorderRadius.circular(5)),
                                child: CustomView.differentStyleTextTogether(
                                    MyString.contactCapital_var,
                                    FontWeight.w400,
                                    "US",
                                    FontWeight.w900,
                                    15,
                                    MyColor.app_white_color,
                                    letterSpacing: 1.5),
                              ),
                            ),
                            SizedBox(height: 12),
                            InkWell(
                              onTap: () {
                                Get.toNamed(RouteHelper.getPrivacyPolicy());
                              },
                              child: Container(
                                width: SizeConfig.screenWidth,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: MyColor.app_border_grey_color),
                                    borderRadius: BorderRadius.circular(5)),
                                child: CustomView.differentStyleTextTogether(
                                    "PRIVACY ",
                                    FontWeight.w400,
                                    "POLICY",
                                    FontWeight.w900,
                                    15,
                                    MyColor.app_white_color,
                                    letterSpacing: 1.5),
                              ),
                            ),
                            SizedBox(height: 12),
                            InkWell(
                              onTap: () {
                                Get.toNamed(RouteHelper.getTermsConditions());
                              },
                              child: Container(
                                width: SizeConfig.screenWidth,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: MyColor.app_border_grey_color),
                                    borderRadius: BorderRadius.circular(5)),
                                child: CustomView.differentStyleTextTogether(
                                    "TERMS & ",
                                    FontWeight.w400,
                                    "CONDITIONS",
                                    FontWeight.w900,
                                    15,
                                    MyColor.app_white_color,
                                    letterSpacing: 1.5),
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        ):SizedBox(),
                      ],
                    ),
            ),
          ),
        );
      })),
    );
  }
}
