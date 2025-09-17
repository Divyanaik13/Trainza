import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../util/size_config/SizeConfig.dart';
import '../../../util/string_const/MyString.dart';
import '../../../util/text_style/MyTextStyle.dart';

class UploadImageDialog {
  static Future<dynamic> show(
    BuildContext context,
    Function() onCamera,
    Function() onGalley,
  ) {
    return showModalBottomSheet(
        backgroundColor: Colors.black.withOpacity(0.01),
        context: context,
        builder: (BuildContext cntx) {
          var fontSize = SizeConfig.fontSize();
          var widthPerBox = SizeConfig.blockSizeHorizontalWith;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: MyColor.app_white_color,
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                        child: Text('Camera',
                            style: MyTextStyle.textStyle(FontWeight.w600,
                                fontSize * 3.5, MyColor.app_black_color)),
                      ),
                      onTap: onCamera,
                    ),
                    Divider(),
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 10),
                        child: Text('Gallery',
                            style: MyTextStyle.textStyle(FontWeight.w600,
                                fontSize * 3.5, MyColor.app_black_color)),
                      ),
                      onTap: onGalley,
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.black.withOpacity(0.01),
                // height: 20,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                padding: EdgeInsets.only(top: 15, bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: MyColor.app_orange_color.value??Color(0xFFFF4300),
                ),
                child: GestureDetector(
                  child: Center(
                    child: Text(MyString.cancel_small_var,
                        style: MyTextStyle.textStyle(FontWeight.w600,
                            fontSize * 3.5, MyColor.app_white_color)),
                  ),
                  onTap: () {
                    Get.back();
                  },
                ),
              )
              // CustomView.buttonShow(MyString.cancel_small_var, FontWeight.w600, fontSize, () { }, fontSize*95)
            ],
          );
        });
  }
}
