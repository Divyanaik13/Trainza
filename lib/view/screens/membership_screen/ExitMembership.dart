import 'package:club_runner/util/custom_view/CustomView.dart';
import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:club_runner/util/text_style/MyTextStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controller/ExitMembershipController.dart';
import '../../../util/size_config/SizeConfig.dart';
import '../../../util/string_const/MyString.dart';

class ExitMembership extends StatefulWidget {
  const ExitMembership({super.key});

  @override
  State<ExitMembership> createState() => _ExitMembershipState();
}

class _ExitMembershipState extends State<ExitMembership> {
  exitMembershipController exitController = Get.put(exitMembershipController());

  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var screenWidth = SizeConfig.screenWidth;
  var fontSize = SizeConfig.fontSize();
  var checked = false.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColor.screen_bg,
      child: SafeArea(child: Obx(() {
        return Scaffold(
          body:  SingleChildScrollView(physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.scrollViewPadding!),
              child: Column(
                children: [
                  CustomView.customAppBar("EXIT ", "MEMBERSHIP", () {
                    Get.back();
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    elevation: 0.0,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 20),
                          child: Column(
                            children: [
                              Text(
                                "You can remove yourself from this brand / club by deleting your membership below.",
                                style: MyTextStyle.textStyle(FontWeight.w400,
                                    16, MyColor.app_black_color),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  " Please note this will remove your membership entirely and cannot be undone. ",
                                  style: MyTextStyle.textStyle(FontWeight.w500,
                                      16, MyColor.app_black_color),
                                  textAlign: TextAlign.center)
                            ],
                          ),
                        ),
                        Divider(
                          color: MyColor.app_divder_color,
                          thickness: 1,
                          height: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomView.differentStyleTextTogether(
                              "EXIT ",
                              FontWeight.w400,
                              "MEMBERSHIP",
                              FontWeight.w900,
                              17,
                              MyColor.app_black_color),
                        ),
                        Divider(
                          color: MyColor.app_divder_color,
                          thickness: 1,
                          height: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 15, right: 15, bottom: 15),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: ListTileTheme(
                                  horizontalTitleGap: 0,
                                  child: CheckboxListTile(
                                    side: BorderSide(
                                        color: Colors.black, width: 2),
                                    checkboxShape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    title: Text(
                                      "Confirm Exit and Remove",
                                      style: MyTextStyle.textStyle(
                                          FontWeight.w300,
                                          14,
                                          MyColor.app_black_color),
                                    ),
                                    value: checked.value,
                                    onChanged: (newValue) {
                                      checked.value = newValue!;
                                    },
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: widthPerBox! * 12),
                                    checkColor: MyColor.app_white_color,
                                    fillColor: MaterialStateProperty.all(
                                        checked.value
                                            ? MyColor.app_orange_color.value
                                            : MyColor.app_white_color),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.screenWidth,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: () {
                                    checked.value
                                        ? Future.delayed(Duration.zero)
                                            .then((value) {exitController
                                                .deleteExitMembership_Api();
                                          })
                                        : SizedBox();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      checked.value
                                          ? MyColor.app_orange_color.value ??
                                              Color(0xFFFF4300)
                                          : MyColor.app_light_grey_color,
                                    ),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(4.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    MyString.exit_and_remove_var,
                                    style: TextStyle(
                                      color: checked.value
                                          ? MyColor
                                              .app_button_text_dynamic_color
                                          : MyColor.app_white_color,
                                      fontFamily:
                                          GoogleFonts.manrope().fontFamily,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17.28,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )),
        );
      })),
    );
  }
}
