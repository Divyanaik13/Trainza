import 'package:club_runner/controller/SettingController.dart';
import 'package:club_runner/util/asstes_image/AssetsImage.dart';
import 'package:club_runner/util/custom_view/CustomView.dart';
import 'package:club_runner/util/local_storage/LocalStorage.dart';
import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:club_runner/util/text_style/MyTextStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../util/string_const/MyString.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var checked = false.obs;
  var light = false.obs;

  settingsController sc_controller = Get.put(settingsController());

  @override
  void initState() {
    print("notificationStatus  :--${LocalStorage.getStringValue(sc_controller.sp.notification_enable)}");
     sc_controller.notificationStatus.value = int.parse(LocalStorage.getStringValue(sc_controller.sp.notification_enable));
   // LocalStorage.setStringValue(sp.notification_enable, logindata.data.notification_enable);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColor.screen_bg,
      child: SafeArea(child: Obx(() {
        return Scaffold(
          body:  SingleChildScrollView(physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomView.customAppBar(MyString.setting_var, "", () {
                  Get.back(result: "refresh");
                }),
                SizedBox(height: 30),
                Divider(
                  color: MyColor.app_divder_color,
                  thickness: 1,
                  height: 2,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, bottom: 10, top: 20),
                  child: Text(
                    "Control the push notifications you receive from TrainZA",
                    textAlign: TextAlign.center,
                    style: MyTextStyle.textStyle(
                        FontWeight.w400, 16, MyColor.app_white_color,
                        lineHeight: 1.5),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Push Notifications",
                      style: MyTextStyle.textStyle(
                          FontWeight.w600, 16.8, MyColor.app_white_color),
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    GestureDetector(
                      onTap: () {
                        // light.value = !light.value;
                        sc_controller.notificationStatus_api(sc_controller.notificationStatus.value.toString());
                        print(sc_controller.notificationStatus.value);
                      },
                      child: Obx(() {
                        return Image.asset(
                           sc_controller.notificationStatus.value == 1
                              ? MyAssetsImage.app_ToggleNotification_active
                              : MyAssetsImage.app_ToggleNotification_inactive,
                          height: 28,
                          width: 55,
                        );
                       }),

                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, bottom: 10, top: 20),
                  child: Text(
                    "Should you want to delete your TRAINZA profile, you can do so by clicking the delete below.",
                    textAlign: TextAlign.center,
                    style: MyTextStyle.textStyle(
                        FontWeight.w400, 16, MyColor.app_white_color),
                  ),
                ),
                checkBox(),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 50, right: 40),
                  child: deletebutton(
                      "Delete ",
                      "Profile",
                      FontWeight.w400,
                      FontWeight.w600,
                      4,
                      16.8,
                      checked.value
                          ? MyColor.app_orange_color.value??Color(0xFFFF4300)
                          : MyColor.app_grey_color,
                      checked.value, () {
                    if (checked.value) {
                      sc_controller.deleteAccount_Api(context);
                    }
                  }),
                )
              ],
            ),
          ),
        );
      })),
    );
  }

  Widget checkBox() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            side: BorderSide(color: Colors.white),
            activeColor: MyColor.screen_bg,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            fillColor: MaterialStateProperty.all(
                checked.value ? MyColor.app_white_color : MyColor.screen_bg),
            checkColor: MyColor.screen_bg,
            value: checked.value,
            onChanged: (newValue) {
              checked.value = newValue!;
              print(checked.value);
            },
            visualDensity: VisualDensity(horizontal: -3.0),
          ),
          Text(
            MyString.confirm_and_delete_var,
            style: MyTextStyle.textStyle(
                FontWeight.w600, 16.8, MyColor.app_white_color),
          )
        ],
      );
    });
  }

  static Widget deletebutton(
      String buttonText1,
      buttonText2,
      FontWeight fontWeight1,
      fontWeight2,
      double widthPerBox,
      fontSizeShow,
      Color myColor,
      bool checked,
      VoidCallback onPressedFun) {
    return SizedBox(
      width: 204,
      child: ElevatedButton(
        onPressed: onPressedFun,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(myColor),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(4.32),
                ),
              ),
            ),
            side: MaterialStateProperty.all(BorderSide(
                color: checked
                    ? MyColor.app_orange_color.value??Color(0xFFFF4300)
                    : MyColor.app_light_grey_color)),
            padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(vertical: widthPerBox * 2.4))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(MyAssetsImage.app_delete_icon, width: 14.96,color: checked
                ? MyColor.app_button_text_dynamic_color: MyColor.app_white_color,),
            SizedBox(
              width: 15,
            ),
            CustomView.differentStyleTextTogether(
                buttonText1,
                fontWeight1,
                buttonText2,
                fontWeight2,
                fontSizeShow,
                checked
                    ? MyColor.app_button_text_dynamic_color: MyColor.app_white_color),
          ],
        ),
      ),
    );
  }
}
