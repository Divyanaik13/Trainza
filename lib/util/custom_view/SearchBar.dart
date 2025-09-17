import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:club_runner/util/text_style/MyTextStyle.dart';
import 'package:flutter/material.dart';

class SearchTextBar extends StatelessWidget {
  SearchTextBar({
    super.key,
    required this.searchController,
    required this.onChanged,
    this.suffixIcon = false,
    this.onFilterTap,
    required this.margin,
  });

  final TextEditingController searchController;
  final void Function(String) onChanged;
  final void Function()? onFilterTap;
  final bool suffixIcon;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: margin,
      child: TextField(
        enableInteractiveSelection: true,
        cursorColor: MyColor.ap_grey_color_text,
        controller: searchController,
        keyboardType: TextInputType.text,
        onChanged: onChanged,
        style: MyTextStyle.textStyle(FontWeight.w500, 14, MyColor.app_white_color),
        decoration: InputDecoration(
          contentPadding:  EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 10),
          hintText: "Search...",
          hintStyle:  MyTextStyle.textStyle(FontWeight.w500, 14, MyColor.app_hint_color),
          prefixIcon: Padding(
            padding:  EdgeInsets.only(
              top: 10,
              left: 5,
              right: 0,
              bottom: 10,
            ),
            child: SizedBox(
              height: 5,
              child: Icon(Icons.search,color: MyColor.app_white_color
                ,),
            ),
          ),
         /* suffixIcon: suffixIcon
              ? Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: 5,
              right: 0,
              bottom: 10,
            ),
            child: GestureDetector(
              onTap: onFilterTap ??
                      () {
                    // Use the specified function or a default function (empty in this case)
                  },
              child: SizedBox(
                height: 4,
                child: Image.asset(
                  ic_filter,
                  width: 2,
                ),
              ),
            ),
          )
              : null,*/
          border: OutlineInputBorder(
            borderSide: BorderSide(color: MyColor.app_border_grey_color),
            borderRadius: BorderRadius.circular(30.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:  BorderSide(color: MyColor.app_border_grey_color),
            borderRadius: BorderRadius.circular(30.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:  BorderSide(
              color: MyColor.app_border_grey_color, // Customize the focused border color
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide:  BorderSide(
              color: MyColor.app_border_grey_color, // Customize the focused border color
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }
}
