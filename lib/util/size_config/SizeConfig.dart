import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? blockSizeHorizontalWith;
  static double? blockSizeVerticalHeight;

  static double? _safeAreaHorizontal;
  static double? _safeAreaVertical;
  static double? safeBlockHorizontal;
  static double? safeBlockVertical;
  static String? screenTypeSizeConfig;

  void init(BuildContext context,String screenType) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData?.size.width;
    screenHeight = _mediaQueryData?.size.height;
    blockSizeHorizontalWith = screenWidth! / 100;
    blockSizeVerticalHeight = screenHeight! / 100;

    _safeAreaHorizontal =
        _mediaQueryData!.padding.left + _mediaQueryData!.padding.right;
    _safeAreaVertical =
        _mediaQueryData!.padding.top + _mediaQueryData!.padding.bottom;
    safeBlockHorizontal = screenWidth! - _safeAreaHorizontal! / 100;
    safeBlockVertical = screenHeight! - _safeAreaVertical! / 100;

    screenTypeSizeConfig = screenType;
  }

  static double? scrollViewPadding = blockSizeHorizontalWith! * 6;
  static double? scrollViewPaddingAuth = blockSizeHorizontalWith! * 8;
  static double? minPadding = blockSizeHorizontalWith! * 4;


  static double fontSize() {
    if (screenTypeSizeConfig == "large") {
      return blockSizeHorizontalWith! + 1;
    } else if(screenTypeSizeConfig == "small"){
      return blockSizeHorizontalWith! - 1;
    }
    else {
      return blockSizeHorizontalWith!;
    }
  }
}
