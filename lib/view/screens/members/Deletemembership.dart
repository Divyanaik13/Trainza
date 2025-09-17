import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../util/custom_view/CustomView.dart';
import '../../../util/my_color/MyColor.dart';
import '../../../util/route_helper/RouteHelper.dart';
import '../../../util/size_config/SizeConfig.dart';
import '../../../util/string_const/MyString.dart';
import '../../../util/text_style/MyTextStyle.dart';

class DeleteMembership_Screen extends StatefulWidget {
  const DeleteMembership_Screen({Key? key}) : super(key: key);

  @override
  State<DeleteMembership_Screen> createState() =>
      _DeleteMembership_ScreenState();
}

class _DeleteMembership_ScreenState extends State<DeleteMembership_Screen> {
  var screenWidth = SizeConfig.screenWidth;
  var fontSize = SizeConfig.fontSize();
  var checked = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SafeArea(
          child: Scaffold(
        body:  SingleChildScrollView(physics: BouncingScrollPhysics(),
            padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.scrollViewPadding!),
            child: Column(
              children: [
                CustomView.customAppBar(
                    MyString.delete_var, MyString.profile_var, () {
                  Get.back();
                }),
                SizedBox(
                  height: 25,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: MyColor.app_white_color,
                    border: Border.all(color: MyColor.app_white_color),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              "Please note this will delete your ",
                              style: MyTextStyle.textStyle(
                                  FontWeight.w500, 18, MyColor.app_black_color),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            RichText(
                                text: TextSpan(
                                    text: "TRAINZA PROFILE ",
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w700,
                                        18,
                                        MyColor.app_black_color),
                                    children: <TextSpan>[
                                  TextSpan(
                                    text: "entirely",
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w500,
                                        18,
                                        MyColor.app_black_color),
                                  ),
                                  TextSpan(
                                    text: " and ",
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w400,
                                        18,
                                        MyColor.app_black_color),
                                  ),
                                ])),
                            SizedBox(
                              height: 3,
                            ),
                            Text("CANNOT BE UNDONE ",
                                style: MyTextStyle.textStyle(FontWeight.w700,
                                    18, MyColor.app_black_color),
                                textAlign: TextAlign.center)
                          ],
                        ),
                      ),
                      Divider(
                        color: Color(0xFFD2D2D2),
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CustomView.differentStyleTextTogether(
                            MyString.delete_var,
                            FontWeight.w400,
                            MyString.profile_var,
                            FontWeight.w900,
                            17,
                            MyColor.app_black_color),
                      ),
                      Divider(
                        color: Color(0xFFD2D2D2),
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
                        child: Column(
                          children: [
                            Obx(() {
                              return Align(
                                alignment: Alignment.center,
                                child: ListTileTheme(
                                  horizontalTitleGap: 0,
                                  child: CheckboxListTile(
                                    side: BorderSide(
                                        color: Colors.black, width: 2),
                                    checkboxShape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    title: Text(
                                      "Confirm Profile Deletion",
                                      style: MyTextStyle.textStyle(
                                          FontWeight.w500,
                                          14,
                                          MyColor.app_black_color),
                                    ),
                                    value: checked.value,
                                    onChanged: (newValue) {
                                      checked.value = newValue!;
                                    },
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 40),
                                    checkColor: MyColor.app_white_color,
                                    fillColor: MaterialStateProperty.all(
                                        checked.value
                                            ? MyColor.screen_bg
                                            : MyColor.app_white_color),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                              );
                            }),
                            SizedBox(
                              height: 5,
                            ),
                            CustomView.buttonShow(
                                "CONFIRM AND DELETE",
                                FontWeight.w600,
                                4.0,
                                17.28,
                                checked.value
                                    ? MyColor.app_orange_color.value ??
                                        Color(0xFFFF4300)
                                    : MyColor.app_light_grey_color, () {
                              // showAlertDialogdelete(context,
                              //     "Are you sure you want to delete your profile?");
                            }, buttonHeight: 50),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
      ));
    });
  }

  Future<dynamic> showAlertDialogdelete(BuildContext context, mainMSG) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          var fontSize = SizeConfig.fontSize();
          var heightPerBox = SizeConfig.blockSizeVerticalHeight;
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.cancel)),
                    ),
                    Text("ALERT!",
                        style: MyTextStyle.textStyle(
                            FontWeight.w600,
                            fontSize * 6,
                            MyColor.app_orange_color.value ??
                                Color(0xFFFF4300))),
                    SizedBox(
                      height: heightPerBox! * 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        mainMSG,
                        style: MyTextStyle.black_text_welcome_msg_style(
                            FontWeight.w400, fontSize * 4.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: heightPerBox * 2.6,
                    ),
                    CustomView.buttonShow("OK", FontWeight.w300, 5, 16.8,
                        MyColor.app_orange_color.value ?? Color(0xFFFF4300),
                        () {
                      Get.offAllNamed(RouteHelper.welcomeScreen);
                    }),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
