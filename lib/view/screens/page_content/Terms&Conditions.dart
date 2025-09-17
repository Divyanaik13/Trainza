import 'package:club_runner/util/custom_view/CustomView.dart';
import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

import '../../../controller/MembershipController.dart';
import '../../../util/size_config/SizeConfig.dart';
import '../../../util/string_const/MyString.dart';
import '../../../util/text_style/MyTextStyle.dart';


class TermsConditions extends StatefulWidget {
  const TermsConditions({Key? key}) : super(key: key);

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {

  MembershipController termsController = Get.put(MembershipController());

  @override
  void initState(){
    termsController.privacyPolicy_termsConditions("2");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx((){
        return termsController.pageContent.value.isEmpty
            ? Center(child: CircularProgressIndicator())
            :SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.scrollViewPadding!),
            child: Column(
              children: [
                CustomView.customAppBar(MyString.Terms_var, MyString.Conditions_var, () {
                  termsController.pageContent.value = "";
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
                      left: 20,right: 20, bottom: 10, top: 20),
                  child:Obx(() => HtmlWidget(
                    termsController.pageContent.value,
                    textStyle: MyTextStyle.textStyle(
                        FontWeight.w400, 16, MyColor.app_white_color,
                        lineHeight: 1.5),
                  )),
                ),

              ],
            )
        );
      })
    );
  }
}
