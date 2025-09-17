import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:club_runner/util/size_config/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../../../controller/MembershipController.dart';
import '../../../util/custom_view/CustomView.dart';
import '../../../util/string_const/MyString.dart';
import '../../../util/text_style/MyTextStyle.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  MembershipController privacyController = Get.put(MembershipController());

  @override
  void initState() {
    privacyController.privacyPolicy_termsConditions("3");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() {
      return privacyController.pageContent.value.isEmpty
          ? Center(child: CircularProgressIndicator())
          :  SingleChildScrollView(physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.scrollViewPadding!),
                child: Column(
                  children: [
                    CustomView.customAppBar(
                        MyString.contact_var, MyString.us_var, () {
                      privacyController.pageContent.value = "";
                      Get.back();
                    }),
                    SizedBox(height: 30),
                    Divider(
                      color: MyColor.app_divder_color,
                      thickness: 1,
                      height: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10, top: 20),
                      child: Obx(() => HtmlWidget(
                            privacyController.pageContent.value,
                            textStyle: MyTextStyle.textStyle(
                                FontWeight.w400, 16, MyColor.app_white_color,
                                lineHeight: 1.5),
                          )),
                    ),
                  ],
                ),
              ),
            );
    }));
  }
}
