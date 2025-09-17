import 'package:club_runner/util/asstes_image/AssetsImage.dart';
import 'package:club_runner/util/text_style/MyTextStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../util/custom_view/CustomView.dart';
import '../../../util/my_color/MyColor.dart';
import '../../../util/size_config/SizeConfig.dart';
import '../../../util/string_const/MyString.dart';

class MemberDetailScreen extends StatefulWidget {
  const MemberDetailScreen({Key? key}) : super(key: key);

  @override
  State<MemberDetailScreen> createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends State<MemberDetailScreen> {
  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var fontSize = SizeConfig.fontSize();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColor.screen_bg,
      child: SafeArea(
        child: Scaffold(
          body:  SingleChildScrollView(physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              child: Column(
                children: [
                  CustomView.customAppBar(MyString.member_var.substring(0, 3),
                      MyString.member_var.substring(3), () {
                    Get.back();
                  }),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: () {},
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          height: (SizeConfig.screenWidth! - 40) * 0.21,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(3.79)),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: SizedBox(
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 110.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        child: Text(
                                          "Johnathan",
                                          softWrap: true,
                                          textAlign: TextAlign.start,
                                          style: MyTextStyle.textStyle(
                                              FontWeight.w300,
                                              19,
                                              MyColor.app_white_color),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          "Ashworth",
                                          softWrap: true,
                                          textAlign: TextAlign.start,
                                          style: MyTextStyle.textStyle(
                                              FontWeight.w600,
                                              19,
                                              MyColor.app_white_color),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: MyColor.app_white_color,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
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
                              image:
                                  "https://images.pexels.com/photos/1680172/pexels-photo-1680172.jpeg?auto=compress&cs=tinysrgb&w=600",
                              fit: BoxFit.cover,
                              height: (SizeConfig.screenWidth! - 40) * 0.21 + 4,
                              width: (SizeConfig.screenWidth! - 40) * 0.21 + 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 21),
                  Divider(
                    color: MyColor.app_divder_color,
                    thickness: 1,
                    height: 2,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
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
                  SizedBox(
                    height: 15,
                  ),
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          height: 38,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: MyColor.app_border_color),
                              borderRadius: BorderRadius.circular(4)),
                          child: CustomView.differentStyleTextTogether(
                              "5KM ",
                              FontWeight.w700,
                              "33.34",
                              FontWeight.w300,
                              16,
                              MyColor.app_white_color),
                        );
                      }),
                  SizedBox(height: 15),
                  Divider(
                    color: MyColor.app_divder_color,
                    thickness: 1,
                    height: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                    height: 2,
                  ),
                  SizedBox(height: 20),
                  raceResultListShow(),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "M O R E",
                        style: MyTextStyle.textStyle(
                            FontWeight.w500, 14, Color(0xFFABABAB)),
                      ),
                      SizedBox(width: 10),
                      Image.asset(
                        MyAssetsImage.app_dropdown_arrow,
                        height: 11,
                        width: 13.65,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 21,
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
                        "23 JUNE",
                        FontWeight.w300,
                        14,
                        MyColor.app_white_color),
                  ),
                  Divider(
                    color: MyColor.app_divder_color,
                    thickness: 1,
                    height: 2,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "082-234-7878",
                    style: MyTextStyle.textStyle(
                        FontWeight.w700, 19, MyColor.app_white_color),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "gerald@in-detail.com",
                    style: MyTextStyle.textStyle(
                        FontWeight.w600, 15, MyColor.app_white_color),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget raceResultListShow() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
              Text(
                "EDENVALE MARATHON",
                style: MyTextStyle.textStyle(
                    FontWeight.w700, 13, MyColor.app_white_color),
              ),
              SizedBox(
                height: 5,
              ),
              RichText(
                text: TextSpan(
                  text: "SUN",
                  style: MyTextStyle.textStyle(
                      FontWeight.w700, 12, MyColor.app_white_color),
                  children: <TextSpan>[
                    TextSpan(
                        text: " 5NOV 2024 ",
                        style: MyTextStyle.textStyle(
                            FontWeight.w300, 12, MyColor.app_white_color)),
                    TextSpan(
                        text: "- 4:34p/km ",
                        style: MyTextStyle.textStyle(
                            FontWeight.w300, 12, Color(0xFF9B9B9B))),
                    TextSpan(
                        text: "- 42.2 KM ",
                        style: MyTextStyle.textStyle(
                            FontWeight.w300, 12, MyColor.app_white_color)),
                    TextSpan(
                        text: "- 35:32",
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
}
