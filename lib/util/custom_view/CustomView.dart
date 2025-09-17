import 'package:club_runner/util/FunctionConstant/FunctionConstant.dart';
// import 'package:country_calling_code_picker/country.dart';
// import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/countries.dart';
import '../asstes_image/AssetsImage.dart';
import '../masking_string_constant/MaskingStringConstant.dart';
import '../my_color/MyColor.dart';
import '../route_helper/RouteHelper.dart';
import '../size_config/SizeConfig.dart';
import '../text_style/MyTextStyle.dart';

//Rishabh 12-March-2024
class CustomView {
  static Widget editTextFiled(
      TextEditingController controller,
      TextInputType inputType,
      String hintText,
      FontWeight hintTextFontWait,
      textInputFontWait,
      Widget prefixIcon,
      bool readOnly,
      void Function() onTap,
      List<TextInputFormatter> inputFormatter) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      height: 40,
      child: TextFormField(
        readOnly: readOnly,
        onTap: onTap,
        controller: controller,
        keyboardType: inputType,
        inputFormatters: inputFormatter,
        style: TextStyle(
            color: MyColor.app_black_color,
            fontFamily: GoogleFonts.manrope().fontFamily,
            fontWeight: textInputFontWait),
        decoration: InputDecoration(
          filled: true,
          fillColor: MyColor.app_text_box_bg_color,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: MyColor.app_text_box_bg_color, width: 0.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: MyColor.app_text_box_bg_color, width: 0.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          hintText: hintText,
          border: InputBorder.none,
          hintStyle: TextStyle(
              fontWeight: hintTextFontWait,
              fontSize: 15,
              fontFamily: GoogleFonts.manrope().fontFamily,
              color: MyColor.app_hint_color),
          prefixIcon: prefixIcon,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onTapOutside: (event) {
          CommonFunction.keyboardHide(Get.context!);
        },
      ),
    );
  }

  static Widget checkBox(bool checked, String text, double fontSize,
      void Function(bool?)? onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          side: BorderSide(color: MyColor.app_white_color, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          activeColor: MyColor.screen_bg,
          fillColor: MaterialStateProperty.all(
              checked ? MyColor.app_white_color : MyColor.screen_bg),
          checkColor: MyColor.screen_bg,
          value: checked,
          onChanged: onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(
          text,
          style: MyTextStyle.textStyle(
              FontWeight.w400, fontSize * 4, MyColor.app_white_color),
        )
      ],
    );
  }

  //Button
  static Widget buttonShow(
      String buttonText,
      FontWeight fontWeight,
      double borderRadius,
      fontSizeShow,
      Color myColor,
      VoidCallback onPressedFun,
      {double? buttonHeight}) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onPressedFun,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(myColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius),
              ),
            ),
          ),
          padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(vertical: 10,horizontal: 10))
        ),
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: MyTextStyle.buttonTextStyle(fontWeight, fontSizeShow),
        ),
      ),
    );
  }

  static Widget buttonShowWithdifferentTextStyle(
      String buttonText1,
      buttonText2,
      FontWeight fontWeight1,
      fontWeight2,
      double radius,
      fontSizeShow,
      Color myColor,
      VoidCallback onPressedFun,{double? letterSpacing}) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: ElevatedButton(
        onPressed: onPressedFun,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(myColor),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(radius),
                ),
              ),
            ),
            padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(vertical: 5))
        ),
        child: differentStyleTextTogether(buttonText1, fontWeight1, buttonText2,
            fontWeight2, fontSizeShow,MyColor.app_button_text_dynamic_color,letterSpacing: letterSpacing),
      ),
    );
  }

  //Transparent button
  static Widget transparentButton(
      String buttonText,
      FontWeight fontWeight,
      double widthPerBox,
      fontSizeShow,
      Color showColor,
      VoidCallback onPressedFun,
      {double? height}) {
    return SizedBox(
        width: SizeConfig.screenWidth,
        height: height,
        child: TextButton(
          onPressed: onPressedFun,
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(4.32),
                ),
              ),
            ),
            side: MaterialStateProperty.all(
                BorderSide(color: MyColor.app_black_color, width: 2)),
            // padding: MaterialStateProperty.all(
            //     EdgeInsets.symmetric(vertical: ))
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              color: MyColor.app_black_color,
              fontFamily: GoogleFonts.manrope().fontFamily,
              fontWeight: fontWeight,
              fontSize: fontSizeShow,
            ),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ));
  }

  //for Social Login Button
  static Widget socialButton(String assetsImage, double assetWidth, assetHeight,
      VoidCallback onTapFun) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: ElevatedButton(
          onPressed: onTapFun,
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(MyColor.app_white_color),
              shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              // padding: EdgeInsets.symmetric(vertical: 15),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 10))),
          child: Image.asset(
            assetsImage,
            width: assetWidth,
            height: assetHeight,
          )),
    );
    //   InkWell(
    //   onTap: onTapFun,
    //   child: Card(
    //     color: MyColor.app_white_color,
    //     shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.all(Radius.circular(10))),
    //     elevation: 2,
    //     child: Padding(
    //       padding: EdgeInsets.symmetric(vertical: 15),
    //       child: Image.asset(
    //         assetsImage,
    //         height: assetHeight,
    //         width: assetWidth,
    //       ),
    //     ),
    //   ),
    // );
  }

  //for different type text together
  static Widget differentStyleTextTogether(
      String firstText,
      FontWeight fontWeightFirst,
      String firstSecond,
      FontWeight fontWeightSecond,
      double fontSizeShow,

      Color myColor,{double? letterSpacing,lineHeight}) {
    return RichText(
      text: TextSpan(
        text: firstText,
        style: MyTextStyle.textStyle(fontWeightFirst, fontSizeShow, myColor,letterSpacing: letterSpacing,lineHeight: lineHeight),
        children: <TextSpan>[
          TextSpan(
            text: firstSecond,
            style:
                MyTextStyle.textStyle(fontWeightSecond, fontSizeShow, myColor,letterSpacing: letterSpacing,lineHeight: lineHeight),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  static Widget twotextView(
      String firstText,
      FontWeight fontWeightFirst,
      String secondText,
      FontWeight fontWeightSecond,
      double fontSizeShow,
      Color myColor,
      double letterSpacing) {
    return RichText(
      text: TextSpan(
        text: firstText,
        style: TextStyle(
            color: myColor,
            fontFamily: GoogleFonts.manrope().fontFamily,
            fontWeight: fontWeightFirst,
            letterSpacing: letterSpacing,
            fontSize: fontSizeShow),
        children: <TextSpan>[
          TextSpan(
            text: secondText,
            style: TextStyle(
                letterSpacing: letterSpacing,
                color: myColor,
                fontFamily: GoogleFonts.manrope().fontFamily,
                fontWeight: fontWeightSecond,
                fontSize: fontSizeShow),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  static Widget twotextViewNoSpace(
      String firstText,
      FontWeight fontWeightFirst,
      String firstSecond,
      FontWeight fontWeightSecond,
      double fontSizeShow,
      Color myColor) {
    return RichText(
      text: TextSpan(
        text: firstText,
        style: TextStyle(
            color: myColor,
            fontFamily: GoogleFonts.manrope().fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: fontSizeShow,
            letterSpacing: 1.74),
        children: <TextSpan>[
          TextSpan(
              text: firstSecond,
              style: TextStyle(
                  color: Colors.white60,
                  fontFamily: GoogleFonts.manrope().fontFamily,
                  fontWeight: FontWeight.w300,
                  fontSize: fontSizeShow,
                  letterSpacing: 1.74)),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  static Widget trainingBlock(
      String firstText, String secondText, String image) {
    return Container(

      decoration: BoxDecoration(
          color: MyColor.screen_gray, borderRadius: BorderRadius.circular(4.0)),
      height: 80,
      width: (SizeConfig.screenWidth! - 40)*0.25,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 2),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 28,
                width: 30,
                decoration: BoxDecoration(
                    color: MyColor.ap_grey_color_bg,
                    borderRadius: BorderRadius.circular(1.71)),
                padding: const EdgeInsets.all(1),
                child: Image.asset(
                  image,
                  height: 18,
                  width: 14,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.center,
            child: CustomView.differentStyleTextTogether(
              "$firstText",
              FontWeight.w400,
              "\n$secondText",
              FontWeight.w700,
              12,
              MyColor.app_black_color,lineHeight: 1.0,letterSpacing: 0.3,
            ),
          ),
        ],
      )),
    );
  }

  static Widget dropDownSelectWidget(
      BuildContext context,
      var dropdownValue1,
      List<dynamic> spinnerItems1,
      void Function(dynamic) onChanged,
      {void Function()? onTap,
      double? height}) {
    print("dropdownValue1 : $dropdownValue1");
    return Container(
      width: (MediaQuery.of(context).size.width) - 20,
      height: height != null ? height : 40,
      padding: const EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        color: MyColor.app_text_box_bg_color,
        border: Border.all(color: MyColor.app_text_box_bg_color, width: 0.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: DropdownButton(
        value: dropdownValue1,
        hint: Text("Select Here"),
        isExpanded: true,
        icon: Image.asset(MyAssetsImage.app_textField_dropdown,
            height: 15, width: 15),
        elevation: 16,
        style: TextStyle(
          color: MyColor.app_hint_color,
          fontSize: 15,
        ),
        underline: Container(
          height: 2,
        ),
        items: spinnerItems1.map<DropdownMenuItem<dynamic>>((dynamic value) {
          return DropdownMenuItem<dynamic>(
            value: value,
            child: Text(
              "${value}",
            ),
          );
        }).toList(),
        onChanged: onChanged,
        onTap: onTap,
        //     (dynamic? value) {
        //   dropdownValue1 = value!;
        //   onChangedCallback(value);
        // }
      ),
    );
  }

  //For SnackBar message
  static showToast(String msg) {
    return Get.showSnackbar(
      GetSnackBar(
        message: msg,
        messageText: Text(
          msg,
          style: MyTextStyle.textStyle(
              FontWeight.w300, 15, MyColor.app_white_color),
        ),
        duration: const Duration(seconds: 2),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        backgroundColor: Colors.black.withOpacity(0.4),
        snackStyle: SnackStyle.GROUNDED,
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      ),
    );
  }

//For custom appbar
  static Widget customAppBar(
      String firstText, secondText, VoidCallback onClick) {
    return Column(
      children: [
        const SizedBox(height: 30),
        AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0.0,
          centerTitle: true,
          leadingWidth: 30,
          leading: GestureDetector(
            onTap: onClick,
            child: Image.asset(
              MyAssetsImage.app_back_icon,
              fit: BoxFit.contain,
            ),
          ),
          title: CustomView.twotextViewNoSpace(firstText, FontWeight.w900,
              secondText, FontWeight.w300, 20, MyColor.app_white_color),
        ),
      ],
    );
  }

  static Widget customAppBarWithDrawerBack(
      VoidCallback onBackPress, VoidCallback onCalenderTap) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0.0,
      centerTitle: true,
      leadingWidth: 30,
      leading: InkWell(
          onTap: onBackPress,
          child: Image.asset(
            MyAssetsImage.app_back_icon,
            fit: BoxFit.contain,
          )),
      actions: [
        InkWell(
            onTap: onCalenderTap,
            child: Image.asset(
              MyAssetsImage.app_date_calender,
              fit: BoxFit.contain,
              height: 25,
              width: 25,
            ))
      ],
    );
    //   Column(
    //   children: [
    //     SizedBox(
    //       height: heightPerBox * 5,
    //     ),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         ClipRRect(
    //           borderRadius: BorderRadius.circular(30),
    //           child: Container(
    //             padding: const EdgeInsets.all(5),
    //             alignment: Alignment.center,
    //             color: MyColor.app_white_color, // Button color
    //             child: InkWell(
    //               onTap: onClick1,
    //               child: Icon(
    //                 Icons.arrow_back_ios_new,
    //                 color: MyColor.screen_bg,
    //                 size: heightPerBox * 2,
    //               ),
    //             ),
    //           ),
    //         ),
    //         InkWell(
    //           onTap: onClick2,
    //           child: Image.asset(MyAssetsImage.app_event_icon_bottom_nav,
    //               height: heightPerBox * 3.5),
    //         ),
    //         // Expanded(child:Center(child: CustomView.differentStyleTextTogether(firstText, FontWeight.bold,secondText, FontWeight.w300, heightPerBox! * 2.9)))
    //       ],
    //     )
    //   ],
    // );
  }

  static Widget customAppBarWithDrawer(
      VoidCallback onMenuPress, VoidCallback onCalenderTap) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0.0,
      centerTitle: true,
      leadingWidth: 25,
      leading: GestureDetector(
        onTap: onMenuPress,
        child: Image.asset(
          MyAssetsImage.app_menu,
          color: MyColor.app_white_color,
          // fit: BoxFit.cover,
        ),
      ),
      actions: [
        InkWell(
            onTap: onCalenderTap,
            child: Image.asset(
              MyAssetsImage.app_date_calender,
              fit: BoxFit.contain,
              height: 25,
              width: 25,
            ))
      ],
    );
  }

//For Date show
  static Widget cardViewDateClick(
    String title,
    Rx<DateTime> currentDate,
    Color myColor,
    Function() decrementClick,
    incrementClick,
  ) {
    return Card(
      color: myColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      margin: EdgeInsets.zero,
      elevation: 0,
      child: Obx(() {
        return Column(
          children: [
            Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: myColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4))),
              //  padding: const EdgeInsets.all(8.0),
              child: Text(title,
                  style: MyTextStyle.textStyle(
                      FontWeight.w900, 17, MyColor.app_button_text_dynamic_color,
                      letterSpacing: 1.48)),
            ),
            Divider(
              color: MyColor.screen_bg,
              thickness: 1,
              height: 2,
            ),
            Card(
              color: MyColor.app_white_color,
              elevation: 0.0,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(4.0))),
              margin: EdgeInsets.zero,
              child: Container(
                height: 55,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      flex: 0,
                      child: InkWell(
                        onTap: decrementClick,
                        child: Container(
                          height: 28,
                          width: 28,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.only(right: 0),
                          decoration: BoxDecoration(
                              color: MyColor.app_white_color,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4))),
                          child: Image.asset(
                            MyAssetsImage.app_leftarrow,
                            color: MyColor.screen_bg,
                            height: 28,
                            width: 28,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EEEE').format(currentDate.value!),
                            style: MyTextStyle.textStyle(
                                FontWeight.w700, 16, MyColor.screen_bg),
                          ),
                          Text(
                            DateFormat('d MMMM yyyy').format(currentDate.value!),
                            style: MyTextStyle.textStyle(
                                FontWeight.w300, 16, MyColor.screen_bg),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: InkWell(
                        onTap: incrementClick,
                        child: Container(
                          height: 28,
                          width: 28,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.only(right: 0),
                          decoration: BoxDecoration(
                              color: MyColor.app_white_color,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4))),
                          child: Image.asset(
                            MyAssetsImage.app_rightarrow,
                            color: MyColor.screen_bg,
                            height: 28,
                            width: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  ///Diksha
  static Widget profileTextFiled(
      TextEditingController controller,
      TextInputType inputType,
      String hintText,
      fontSizeShow,
      bool readOnly,
      List<TextInputFormatter>? inputFormatter,void Function() onTap) {
    return SizedBox(
      height: 40,
      child: TextFormField(
        controller: controller,
        onTap: onTap,
        keyboardType: inputType,
        readOnly: readOnly,
        textAlignVertical: TextAlignVertical.center,
        inputFormatters: inputFormatter,
        decoration: InputDecoration(
          filled: true,
          fillColor: MyColor.app_text_box_bg_color,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: MyColor.app_border_grey_color, width: 0.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: MyColor.app_border_grey_color, width: 0.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          hintText: hintText,
          border: InputBorder.none,
          hintStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: fontSizeShow,
              fontFamily: GoogleFonts.manrope().fontFamily,
              color: MyColor.app_hint_color),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
        ),
        onTapOutside: (event) {
          print('onTapOutside');
          CommonFunction.keyboardHide(Get.context!);
        },
      ),
    );
  }

  static Widget customButtonWithBorder(
      String text, Function() OnTap, double width, letterSpacing) {
    return GestureDetector(
      onTap: OnTap,
      child: Center(
        child: Container(
          width: width,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: MyColor.app_white_color),
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                text,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: MyColor.app_white_color,
                    fontFamily: GoogleFonts.manrope().fontFamily,
                    letterSpacing: letterSpacing),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                width: 10,
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: MyColor.app_white_color,
                size: 16,
              )
            ],
          ),
        ),
      ),
    );
  }

  static Widget membershipStatus(
      Function() onPressed, String buttonText, Image icon,Color color) {
    return Card(
      margin: EdgeInsets.zero,
      color: MyColor.app_white_color,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: differentStyleTextTogether("MEMBERSHIP ", FontWeight.w400,
                "STATUS", FontWeight.w900, 17, MyColor.app_black_color),
          ),
          const Divider(height: 1),
          SizedBox(
            width: SizeConfig.screenWidth,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ButtonStyle(
                    // backgroundColor: MaterialStateProperty.all(Color(0xFFFF0000)),
                    backgroundColor: MaterialStateProperty.all(color),
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                    ),
                    // padding: MaterialStateProperty.all(
                    //     EdgeInsets.symmetric(vertical: widthPerBox! * 2.4))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        buttonText,
                        style: TextStyle(
                          color: MyColor.app_white_color,
                          fontFamily: GoogleFonts.manrope().fontFamily,
                          fontWeight: FontWeight.w600,
                          fontSize: 17.28,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      icon
                      // Icon(icon)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget phoneTextField(
    TextEditingController controller,
    List<TextInputFormatter>? inputFormatters,
    Function() onTap,
    Function() onPressed,
    Country selectedCountry,
    Function(dynamic) onTapOutside,
    {Function(String)? onFieldSubmitted,String? maskHint}
  ) {
    print("Country 123 " + selectedCountry.flag);
    return SizedBox(
      height: 40,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: inputFormatters,
        onTap: onTap,
        style: TextStyle(
            color: MyColor.app_black_color,
            fontFamily: GoogleFonts.manrope().fontFamily,
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(
            filled: true,
            fillColor: MyColor.app_text_box_bg_color,
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: MyColor.app_text_box_bg_color, width: 0.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: MyColor.app_text_box_bg_color, width: 0.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            hintText: maskHint,
            hintStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                fontFamily: GoogleFonts.manrope().fontFamily,
                color: MyColor.app_hint_color),
            border: InputBorder.none,
            prefixIcon: GestureDetector(
              onTap: onPressed,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    margin: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: MyColor.app_textform_bg_color,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       /* Image.asset(
                          selectedCountry.flag,
                          // package: countryCodePackageName,
                          height: 20,
                        ),*/
                        Text(
                          selectedCountry.flag,
                          style: const TextStyle(fontSize: 24), // Adjust size as needed
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(Icons.keyboard_arrow_down_sharp,
                            color: Color(0xFF8B8A8A)),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10 ,bottom: 1),
                    child: Text("+${selectedCountry.dialCode}",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: GoogleFonts.manrope().fontFamily,
                            color: const Color.fromARGB(255, 92, 90, 90))),
                  ),
                ],
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10)),
        onTapOutside: onTapOutside,
        onChanged: (test){
          print("test phone number :-- ${controller.text}");
        },
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }

  static Future<dynamic> showAlertDialogBox(BuildContext context, mainMSG) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          var fontSize = SizeConfig.fontSize();
          var heightPerBox = SizeConfig.blockSizeVerticalHeight;
          // var widthPerBox = SizeConfig.blockSizeHorizontalWith;
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)), //this right here
            child: Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.cancel)),
                    ),
                    // RichText(
                    //   text: TextSpan(
                    //     text: "${headingFirstMSG} ",
                    //     style: MyTextStyle.black_text_welcome_msg_style(
                    //         FontWeight.w400, fontSize * 6),
                    //     children: <TextSpan>[
                    //       TextSpan(
                    //         text: headingSecondMSG,
                    //         style: MyTextStyle.black_text_welcome_msg_style(
                    //             FontWeight.w600, fontSize * 6),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Text("ALERT!",
                        style: MyTextStyle.textStyle(FontWeight.w600,
                            fontSize * 6, MyColor.app_orange_color.value??Color(0xFFFF4300))),
                    SizedBox(
                      height: heightPerBox! * 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        mainMSG,
                        style: MyTextStyle.black_text_welcome_msg_style(
                            FontWeight.w400, fontSize * 3.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: heightPerBox * 2.6,
                    ),
                    CustomView.buttonShow("OK", FontWeight.w300, 5, 16.8,
                        MyColor.app_orange_color.value??Color(0xFFFF4300), () {
                      Get.back();
                    }),
                    // Expanded(
                    //   flex: 1,
                    //   child: CustomView.buttonShow(
                    //       "OK",
                    //       FontWeight.w300,
                    //       0,
                    //       fontSize,
                    //       MyColor.app_orange_color.value??Color(0xFFFF4300),
                    //       (){Get.back();}),
                    // )
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Future<dynamic> showSuccessDialogBox(BuildContext context, mainMSG) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          var fontSize = SizeConfig.fontSize();
          var heightPerBox = SizeConfig.blockSizeVerticalHeight;
          // var widthPerBox = SizeConfig.blockSizeHorizontalWith;
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)), //this right here
            child: Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                 /*   Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.cancel)),
                    ),*/
                    // RichText(
                    //   text: TextSpan(
                    //     text: "${headingFirstMSG} ",
                    //     style: MyTextStyle.black_text_welcome_msg_style(
                    //         FontWeight.w400, fontSize * 6),
                    //     children: <TextSpan>[
                    //       TextSpan(
                    //         text: headingSecondMSG,
                    //         style: MyTextStyle.black_text_welcome_msg_style(
                    //             FontWeight.w600, fontSize * 6),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Text("Success",
                        style: MyTextStyle.textStyle(
                            FontWeight.w600, 22, Colors.green)),
                    SizedBox(
                      height: heightPerBox! * 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        mainMSG,
                        style: MyTextStyle.black_text_welcome_msg_style(
                            FontWeight.w400, fontSize * 3.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: heightPerBox * 2.6,
                    ),
                    CustomView.buttonShow("OK", FontWeight.w300, 5, 16.8,
                        MyColor.app_orange_color.value??Color(0xFFFF4300), () {
                      Get.offAllNamed(RouteHelper.welcomeScreen);
                    }),
                    // Expanded(
                    //   flex: 1,
                    //   child: CustomView.buttonShow(
                    //       "OK",
                    //       FontWeight.w300,
                    //       0,
                    //       fontSize,
                    //       MyColor.app_orange_color.value??Color(0xFFFF4300),
                    //       (){Get.back();}),
                    // )
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Widget passwordTextFiled(
      TextEditingController controller,
      RxBool _passwordVisible,
      String hintText,
      Widget prefixIcon,
      void Function() onTap) {
    var widthPerBox = SizeConfig.blockSizeHorizontalWith;
    return Obx(() {
      return SizedBox(
        height: 40,
        child: TextFormField(
          controller: controller,
          obscureText: !_passwordVisible.value,
          keyboardType: TextInputType.text,
          onTap: onTap,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')), //for stop user to enter white space.
            LengthLimitingTextInputFormatter(30),
          ],
          style: TextStyle(
              color: MyColor.app_black_color,
              fontFamily: GoogleFonts.manrope().fontFamily,
              fontWeight: FontWeight.w500),
          decoration: InputDecoration(
              filled: true,
              fillColor: MyColor.app_text_box_bg_color,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: MyColor.app_text_box_bg_color, width: 0.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: MyColor.app_text_box_bg_color, width: 0.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              hintText: hintText,
              border: InputBorder.none,
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  fontFamily: GoogleFonts.manrope().fontFamily,
                  color: MyColor.app_hint_color),
              prefixIcon: prefixIcon,
              suffixIconConstraints:
                  const BoxConstraints(minHeight: 5, minWidth: 5),
              suffixIcon: InkWell(
                  onTap: () {
                    if(controller.text.trim().isNotEmpty){
                      _passwordVisible.value = !_passwordVisible.value;
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0, top: 3),
                    child: SizedBox(
                      height: 14,
                      width: 22,
                      child: Image.asset(
                        _passwordVisible.value
                            ? MyAssetsImage.app_Eye_active
                            : MyAssetsImage.app_Eye_inactive,
                      ),
                    ),
                  )),
              contentPadding: EdgeInsets.symmetric(
                  vertical: widthPerBox! * 2, horizontal: 10)),
          onTapOutside: (event) {
            CommonFunction.keyboardHide(Get.context!);
          },
        ),
      );
    });
  }

  static Widget errorField(String firstText, secondText,
      FontWeight fontWeightFirst, fontWeightSecond, double fontSize) {
    return Container(
        alignment: Alignment.centerLeft,
        width: SizeConfig.screenWidth,
        padding: const EdgeInsets.all(7),
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            color: MyColor.app_orange_color.value??Color(0xFFFF4300),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: MyColor.app_orange_color.value??Color(0xFFFF4300), width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                firstText,
                maxLines: null,
                style: TextStyle(
                    color: MyColor.app_button_text_dynamic_color,
                    fontFamily: GoogleFonts.manrope().fontFamily,
                    fontWeight: fontWeightFirst,
                    letterSpacing: 1,
                    fontSize: fontSize),
              ),
            ),
            Text(
              secondText,
              maxLines: null,
              style: TextStyle(
                  letterSpacing: 1,
                  color: MyColor.app_button_text_dynamic_color,
                  fontFamily: GoogleFonts.manrope().fontFamily,
                  fontWeight: fontWeightSecond,
                  fontSize: fontSize),
            )
          ],
        )
        // CustomView.twotextView(firstText, fontWeightFirst, firstSecond,
        //     fontWeightSecond, fontSize, MyColor.app_white_color, 1),

        );
  }
}
