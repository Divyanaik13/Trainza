import 'package:club_runner/controller/ProfileController.dart';
import 'package:club_runner/util/asstes_image/AssetsImage.dart';
import 'package:club_runner/util/route_helper/RouteHelper.dart';
import 'package:club_runner/util/text_style/MyTextStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../models/UserProfile_Model.dart';
import '../../../util/custom_view/CustomView.dart';
import '../../../util/local_storage/LocalStorage.dart';
import '../../../util/masking_string_constant/MaskingStringConstant.dart';
import '../../../util/my_color/MyColor.dart';
import '../../../util/size_config/SizeConfig.dart';
import '../../../util/string_const/MyString.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var fontSize = SizeConfig.fontSize();
  LocalStorage sp = LocalStorage();
  ProfileController ps_controller = Get.put(ProfileController());

  String screenType = "";
  var loader = false.obs;
  @override
  void initState() {
    super.initState();
    print(Get.parameters["userId"].toString());
    userProfile(Get.parameters["userId"].toString() ?? "");
    screenType = Get.parameters["screenType"].toString();
    print("screenType :-- $screenType");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColor.screen_bg,
      child: SafeArea(child: Obx(() {
        return Scaffold(
          body:  SingleChildScrollView(physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ps_controller.profilemodel.value == null || !loader.value
                ? Container()
                : Column(
                    children: [
                      screenType == MyString.member_var
                          ? CustomView.customAppBar(
                              MyString.member_var.substring(0, 3),
                              MyString.member_var.substring(3), () {
                              Get.back();
                            })
                          : CustomView.customAppBar(
                              MyString.profile_var.substring(0, 3),
                              MyString.profile_var.substring(3), () {
                              Get.back(result: "refresh");
                            }),
                      const SizedBox(height: 30),
                      InkWell(
                        onTap: () {
                          if (screenType != MyString.member_var) {
                            Get.toNamed(RouteHelper.getFullProfileScreen());
                          }
                        },
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(
                              height: (SizeConfig.screenWidth! - 40) * 0.21,
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(3.79)),
                                border:
                                    Border.all(color: Colors.white, width: 1),
                              ),
                              child: SizedBox(
                                height: 60,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.only(left: 110.0),
                                        // width: (SizeConfig.screenWidth! - 110-40-40),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              ps_controller.memberInfo.value!
                                                      .firstName ??
                                                  "",
                                              textAlign: TextAlign.start,
                                              style: MyTextStyle.textStyle(
                                                  FontWeight.w300,
                                                  19,
                                                  MyColor.app_white_color),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              ps_controller.memberInfo.value!
                                                          .lastName ==
                                                      ""
                                                  ? "NA"
                                                  : ps_controller
                                                      .memberInfo.value!.lastName,
                                              textAlign: TextAlign.start,
                                              style: MyTextStyle.textStyle(
                                                  FontWeight.w600,
                                                  19,
                                                  MyColor.app_white_color),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: screenType != MyString.member_var
                                          ? Icon(
                                              Icons.arrow_forward_ios,
                                              color: MyColor.app_white_color,
                                              size: 22,
                                            )
                                          : SizedBox(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              // padding: const EdgeInsets.all(2),
                              margin: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: MyColor.app_white_color, width: 2),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: FadeInImage.assetNetwork(
                                  placeholder: MyAssetsImage.app_loader,
                                  placeholderFit: BoxFit.cover,
                                  image: ps_controller.memberInfo.value!.profilePicture,
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset(
                                      MyAssetsImage.app_default_user,
                                      height: (SizeConfig.screenWidth! - 40) *
                                              0.21 +
                                          4,
                                      width: (SizeConfig.screenWidth! - 40) *
                                              0.21 +
                                          4,
                                    );
                                  },
                                  fit: BoxFit.cover,
                                  height:
                                      (SizeConfig.screenWidth! - 40) * 0.21 + 4,
                                  width:
                                      (SizeConfig.screenWidth! - 40) * 0.21 + 4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 21),
                      ps_controller.personalBests.value.isNotEmpty
                          ? Column(
                              children: [
                                Divider(
                                  color: MyColor.app_divder_color,
                                  thickness: 1,
                                  height: 2,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: CustomView.differentStyleTextTogether(
                                      "PERSONAL ",
                                      FontWeight.w700,
                                      "BESTS",
                                      FontWeight.w300,
                                      14,
                                      MyColor.app_white_color),
                                ),
                                Divider(
                                  color: MyColor.app_divder_color,
                                  thickness: 1,
                                  height: 2,
                                ),
                                const SizedBox(
                                  height: 11,
                                ),
                                pbList(),
                              ],
                            )
                          : SizedBox(),
                      ps_controller.eventResults.value.isNotEmpty
                          ? Column(
                              children: [
                                const SizedBox(height: 11),
                                Divider(
                                  color: MyColor.app_divder_color,
                                  thickness: 1,
                                  height: 2,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: CustomView.differentStyleTextTogether(
                                      "RACE ",
                                      FontWeight.w700,
                                      "RESULTS",
                                      FontWeight.normal,
                                      14,
                                      MyColor.app_white_color),
                                ),
                                Divider(
                                    color: MyColor.app_divder_color,
                                    thickness: 1,
                                    height: 2),
                                const SizedBox(height: 26),
                                raceResultListShow(),
                                const SizedBox(height: 15),
                                ps_controller.eventResults.value.length > 5
                                    ? InkWell(
                                        onTap: () {
                                          ps_controller.showAll.value =
                                              !ps_controller.showAll.value;
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              ps_controller.showAll.value
                                                  ? 'L E S S'
                                                  : "M O R E",
                                              style: MyTextStyle.textStyle(
                                                  FontWeight.w500,
                                                  14,
                                                  const Color(0xFFABABAB)),
                                            ),
                                            const SizedBox(width: 10),
                                            Image.asset(
                                              MyAssetsImage.app_dropdown_arrow,
                                              height: 11,
                                              width: 13.65,
                                            )
                                          ],
                                        ),
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  height: 21,
                                ),
                              ],
                            )
                          : SizedBox(
                              height: 10,
                            ),
                      Divider(
                        color: MyColor.app_divder_color,
                        thickness: 1,
                        height: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomView.differentStyleTextTogether(
                            "BIRTHDAY - ",
                            FontWeight.w700,
                            ps_controller.memberInfo.value!.dateOfBirth != ""
                                ? "${DateFormat('dd MMMM').format(DateTime.parse(ps_controller.memberInfo.value!.dateOfBirth))}"
                                : "NA",
                            FontWeight.w300,
                            14,
                            MyColor.app_white_color),
                      ),
                      Divider(
                        color: MyColor.app_divder_color,
                        thickness: 1,
                        height: 2,
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("BIB / ASA NUMBER",
                              style: MyTextStyle.textStyle(
                                  FontWeight.w400, 13.05, MyColor.app_white_color)),
                          Text(ps_controller.memberInfo.value!.bibNumber != ""
                              ? ps_controller.memberInfo.value!.bibNumber
                              : "NA",
                              style: MyTextStyle.textStyle(
                                  FontWeight.w600, 16.2, MyColor.app_white_color)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(
                        color: MyColor.app_divder_color,
                        thickness: 1,
                        height: 2,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      screenType == MyString.member_var
                          ? Column(
                              children: [
                                ps_controller.memberInfo.value!
                                            .isNumberPubliclyShared ==
                                        "1"
                                    ? Text(
                                        "${ps_controller.memberInfo.value!.phoneNumber}",
                                        style: MyTextStyle.textStyle(
                                            FontWeight.w700,
                                            19,
                                            MyColor.app_white_color),
                                      )
                                    : SizedBox(),
                                const SizedBox(
                                  height: 3,
                                ),
                                ps_controller.memberInfo.value!
                                            .isEmailPubliclyShared ==
                                        "1"
                                    ? Text(
                                        "${ps_controller.memberInfo.value!.email}",
                                        style: MyTextStyle.textStyle(
                                            FontWeight.w600,
                                            15,
                                            MyColor.app_white_color),
                                      )
                                    : SizedBox(),
                              ],
                            )
                          : Column(
                              children: [
                                Text(
                                  "${ps_controller.phoneNumber.value}",
                                  style: MyTextStyle.textStyle(FontWeight.w700,
                                      19, MyColor.app_white_color),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "${ps_controller.memberInfo.value!.email}",
                                  style: MyTextStyle.textStyle(FontWeight.w600,
                                      15, MyColor.app_white_color),
                                ),
                              ],
                            ),
                      const SizedBox(
                        height: 40,
                      ),
                      screenType != MyString.member_var
                          ? CustomView.customButtonWithBorder("FULL PROFILE",
                              () {
                              Get.toNamed(RouteHelper.getFullProfileScreen());
                            }, 162, 2.0)
                          : const SizedBox(),
                      const SizedBox(height: 40),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          height: ((SizeConfig.screenWidth)!-(SizeConfig.screenWidth!*40/100))/1.62,
                          width: (SizeConfig.screenWidth)!-(SizeConfig.screenWidth!*40/100),
                          child: LocalStorage.getStringValue(
                                      sp.currentClubData_logo) ==
                                  ""
                              ? Image.asset(MyAssetsImage.app_trainza_ratioLogo,
                                  fit: BoxFit.fill)
                              : Image.network(
                                  LocalStorage.getStringValue(
                                      sp.currentClubData_logo),
                                  fit: BoxFit.fill),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
          ),
          //   bottomNavigationBar:BottomNavigationBarWidget()
        );
      })),
    );
  }

  Widget raceResultListShow() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ps_controller.showAll.value
          ? ps_controller.eventResults.value.length
          : (ps_controller.eventResults.value.length > 5
              ? 5
              : ps_controller.eventResults.value.length),
      itemBuilder: (context, index) {
        var date, day;
        var results = ps_controller.eventResults.value[index];
        var unit = results.distanceUnit == "1" ? "KM" : "MI";
        if (results.eventDate.toString() != "null") {
          DateTime parsedDate = DateTime.parse(results.eventDate.toString());
          date = DateFormat('dd MMMM yyyy').format(parsedDate);
          day = DateFormat('EEE ').format(parsedDate);
        } else {
          date = "";
          day = "";
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
              Text(
                results.title,
                style: MyTextStyle.textStyle(
                    FontWeight.w700, 13, MyColor.app_white_color),
              ),
              const SizedBox(
                height: 5,
              ),
              RichText(
                text: TextSpan(
                  text: "$day",
                  style: MyTextStyle.textStyle(
                      FontWeight.w700, 12, MyColor.app_white_color),
                  children: <TextSpan>[
                    TextSpan(
                        text: "$date",
                        style: MyTextStyle.textStyle(
                            FontWeight.w300, 12, MyColor.app_white_color)),
                    TextSpan(
                        text: "- ${results.pace}",
                        style: MyTextStyle.textStyle(
                            FontWeight.w300, 12, const Color(0xFF9B9B9B))),
                    TextSpan(
                        text: "- ${results.distance} $unit",
                        style: MyTextStyle.textStyle(
                            FontWeight.w300, 12, MyColor.app_white_color)),
                    TextSpan(
                        text: "- ${results.result}",
                        style: MyTextStyle.textStyle(
                            FontWeight.w700, 12, MyColor.app_white_color)),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget pbList() {
    return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ps_controller.personalBests.value.length,
        itemBuilder: (context, index) {
          var pbs = ps_controller.personalBests.value[index];
          var distanceUnit = pbs.unit == "1" ? "KM" : "MI";
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 5),
            // padding: EdgeInsets.all(10),
            height: 38,
            decoration: BoxDecoration(
                border: Border.all(color: MyColor.app_border_color),
                borderRadius: BorderRadius.circular(5)),
            child: CustomView.differentStyleTextTogether(
                "${pbs.distance.toString()}${distanceUnit}\t",
                FontWeight.w700,
                pbs.bestTime,
                FontWeight.w300,
                16,
                MyColor.app_white_color,
                letterSpacing: 1),
          );
        });
  }

  userProfile(String memberId) {
    ps_controller.userProfile_api(memberId).then((value) {
      if (value != "") {
        loader.value = true;
        ps_controller.profilemodel.value = userProfileModelFromJson(value);
        ps_controller.memberInfo.value =
            ps_controller.profilemodel.value!.data.memberInfo;
        ps_controller.personalBests.value =
            ps_controller.profilemodel.value!.data.personalBests;
        ps_controller.eventResults.value =
            ps_controller.profilemodel.value!.data.eventResults;
        ps_controller.phoneNumber.value = ps_controller.memberInfo.value!.phoneNumber;

        String maskPattern = PhoneNumberMask.getMaskPattern("+${ps_controller.memberInfo.value!.phoneDialCode}");
        print("get value after profile maskPattern $maskPattern");
        ps_controller.maskFormatter.value = MaskTextInputFormatter(
            mask: '+# (###) ###-##-##',
            // mask: maskPattern,
            filter: { "#": RegExp(r'[0-9]')},
            type: MaskAutoCompletionType.lazy
        );

        if( ps_controller.maskFormatter.value != null){
          ps_controller.maskFormatter.value!.updateMask(mask: maskPattern);
        }
        ps_controller.phoneNumber.value = ps_controller.maskFormatter.value!.maskText(ps_controller.phoneNumber.value);



        print("phoneNumber ${ps_controller.phoneNumber.value}");
      }
    });
  }
}
