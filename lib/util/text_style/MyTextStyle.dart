import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextStyle{

  static TextStyle? welcome_msg_style(FontWeight fontWeight,double fontSize) {
    return TextStyle(
      color: MyColor.app_white_color,
      fontFamily: GoogleFonts.manrope().fontFamily,
      fontWeight: fontWeight,
      fontSize: fontSize

    );
  }

  static TextStyle? black_text_welcome_msg_style(FontWeight fontWeight,double fontSize) {
    return TextStyle(
        color: MyColor.app_black_color,
        fontFamily: GoogleFonts.manrope().fontFamily,
        fontWeight: fontWeight,
        fontSize: fontSize
    );
  }

  static TextStyle? textStyle(FontWeight fontWeight,double fontSize,Color myColor,{double? letterSpacing ,lineHeight}) {
    return TextStyle(
        color: myColor,
        fontFamily: GoogleFonts.manrope().fontFamily,
        fontWeight: fontWeight,
        fontSize: fontSize,
        letterSpacing: letterSpacing,
        height: lineHeight
    );
  }

  //Button Text Style
  static TextStyle? buttonTextStyle(FontWeight fontWeight,double fontSize,{double? letterSpecing}) {
    return TextStyle(
        color: MyColor.app_button_text_dynamic_color,
        fontFamily: GoogleFonts.manrope().fontFamily,
        fontWeight: fontWeight,
        fontSize: fontSize,
      letterSpacing: letterSpecing,
    );
  }
}