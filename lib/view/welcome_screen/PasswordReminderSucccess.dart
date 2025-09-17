import 'package:club_runner/util/size_config/SizeConfig.dart';
import 'package:club_runner/util/text_style/MyTextStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../util/asstes_image/AssetsImage.dart';
import '../../util/custom_view/CustomView.dart';
import '../../util/my_color/MyColor.dart';
import '../../util/route_helper/RouteHelper.dart';
import '../../util/string_const/MyString.dart';

class PasswordReminderSuccessScreen extends StatefulWidget {
  const PasswordReminderSuccessScreen({Key? key}) : super(key: key);

  @override
  State<PasswordReminderSuccessScreen> createState() =>
      _PasswordReminderSuccessScreenState();
}

class _PasswordReminderSuccessScreenState
    extends State<PasswordReminderSuccessScreen> {
  var fontSize = SizeConfig.fontSize();

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body:  SingleChildScrollView(physics: BouncingScrollPhysics(),
          padding:
              EdgeInsets.only(top: 10,left: 30,right: 30),
          child: SizedBox(
            width: SizeConfig.screenWidth,
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Image.asset(
                  MyAssetsImage.app_trainza_img,
                  height: 50,width: 280,
                  color: MyColor.app_white_color,
                ),
                SizedBox(
                  height: 50,
                ),
                CustomView.twotextView(
                    MyString.pass_var,
                    FontWeight.w800,
                    MyString.reminder_var,

                    FontWeight.w300,
                    20,
                    MyColor.app_white_color,1.74),

                SizedBox(
                  height: 25,
                ),
                Text(
                  "Sent!",
                  style: MyTextStyle.textStyle(
                      FontWeight.w600, 25, MyColor.app_white_color),
                ),
                SizedBox(
                  height: 18,
                ),
                Text(
                  "Grab your password and LOGIN now.",
                  style: MyTextStyle.textStyle(
                      FontWeight.w400, 15, MyColor.app_white_color),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: CustomView.buttonShow(MyString.login_now_var, FontWeight.w500,
                      5.0,16.8, MyColor.app_orange_color.value??Color(0xFFFF4300), () {
                    Get.back();
                    //Get.toNamed(RouteHelper.getWelcomeScreen());
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
