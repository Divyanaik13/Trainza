import 'dart:io';
import 'package:club_runner/controller/WelcomeScreenController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../controller/EditProfileController.dart';
import '../../../util/FunctionConstant/FunctionConstant.dart';
import '../../../util/asstes_image/AssetsImage.dart';
import '../../../util/custom_view/CustomView.dart';
import '../../../util/my_color/MyColor.dart';
import '../../../util/size_config/SizeConfig.dart';
import '../../../util/string_const/MyString.dart';
import '../../../util/text_style/MyTextStyle.dart';
import '../profile_screen/SelectImageDialog.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  TextEditingController dobController = TextEditingController();
  TextEditingController bibController = TextEditingController();
  final controller = EditProfileController();
  final wcController = WelcomeScreenController();
  var _imageFile = Rxn<File>();
  DateTime currentDate = DateTime.now();
  DateTime? selectedDateTime;
  var isError = 0.obs;
  var errorMessage1 = "".obs;
  var errorMessage2 = "".obs;
  var removeProfilePicture = "0".obs;
  var profileImg = "".obs;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: SafeArea(
            child: Scaffold(
                body: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Obx(() {
                      return SizedBox(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    wcController.skipOnboardingStep();
                                  },
                                  child: Container(
                                    width: 70,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: MyColor.app_white_color,
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("skip",
                                            style: MyTextStyle.textStyle(
                                                FontWeight.w600,
                                                18,
                                                Colors.black)),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 2.0),
                                          child: Icon(Icons.double_arrow_sharp,color: Colors.black,size: 18,),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomView.twotextView(
                                MyString.on_var,
                                FontWeight.w800,
                                MyString.boarding_var,
                                FontWeight.w300,
                                20,
                                MyColor.app_white_color,
                                1.74),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 80.0),
                              child: Text(
                                "Just a bit more info about you to complete your profile.",
                                style: TextStyle(
                                    color: MyColor.app_white_color,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Divider(),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    MyString.dob_var +
                                        MyString.requider_var.toLowerCase(),
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w400,
                                        14.5,
                                        MyColor.app_white_color)),
                                const SizedBox(height: 5),
                                SizedBox(
                                  height: 40,
                                  child: TextFormField(
                                    controller: dobController,
                                    keyboardType: TextInputType.number,
                                    readOnly: true,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: MyColor.app_text_box_bg_color,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                MyColor.app_border_grey_color,
                                            width: 0.0),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                MyColor.app_border_grey_color,
                                            width: 0.0),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      hintText: MyString.select_dob_var,
                                      prefixIcon: const Icon(
                                          Icons.calendar_today_outlined),
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          fontFamily:
                                              GoogleFonts.manrope().fontFamily,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: MyColor.app_hint_color),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 14),
                                    ),
                                    onTap: () {
                                      _selectDate(context);
                                      isError.value = 0;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            isError.value == 1
                                ? CustomView.errorField(
                                    errorMessage1.value,
                                    errorMessage2.value,
                                    FontWeight.w500,
                                    FontWeight.w700,
                                    10)
                                : const SizedBox(),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    MyString.gender_var +
                                        MyString.requider_var.toLowerCase(),
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w400,
                                        14.5,
                                        MyColor.app_white_color)),
                                const SizedBox(height: 5),
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: MyColor.app_text_box_bg_color,
                                      border: Border.all(
                                          color: MyColor.app_border_grey_color),
                                      borderRadius: BorderRadius.circular(5)),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7),
                                  child: Row(
                                    children: [
                                      controller.addRadioButton(
                                          1, MyString.female_var, context),
                                      const SizedBox(width: 5),
                                      controller.addRadioButton(
                                          0, MyString.male_var, context),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            controller.isError.value == 2
                                ? CustomView.errorField(
                                    controller.errorMessage1.value,
                                    controller.errorMessage2.value,
                                    FontWeight.w500,
                                    FontWeight.w700,
                                    10)
                                : const SizedBox(),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    MyString.bibNumber_var +
                                        MyString.optional_var,
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w400,
                                        14.5,
                                        MyColor.app_white_color)),
                                const SizedBox(height: 5),
                                SizedBox(
                                  height: 40,
                                  child: TextFormField(
                                    controller: bibController,
                                    onTap: () {},
                                    keyboardType: TextInputType.text,
                                    readOnly: false,
                                    textAlignVertical: TextAlignVertical.center,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^[a-zA-Z0-9]*$'))
                                    ],
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: MyColor.app_light_yellow_color,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                MyColor.app_light_yellow_color,
                                            width: 0.0),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                MyColor.app_light_yellow_color,
                                            width: 0.0),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      hintText: MyString.bibNumberhint_var,
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          fontFamily:
                                              GoogleFonts.manrope().fontFamily,
                                          color: MyColor.app_hint_color),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 14),
                                    ),
                                    onTapOutside: (event) {
                                      print('onTapOutside');
                                      CommonFunction.keyboardHide(Get.context!);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Divider(
                              color: MyColor.app_divder_color,
                              thickness: 1,
                              height: 2,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    CustomView.differentStyleTextTogether(
                                        MyString.profile_picture_var
                                            .toString()
                                            .substring(0, 9),
                                        FontWeight.w500,
                                        MyString.profile_picture_var
                                            .toString()
                                            .substring(9, 15),
                                        FontWeight.w700,
                                        18,
                                        MyColor.app_white_color),
                                    Text(
                                      "Optional - You can add this later",
                                      textAlign: TextAlign.center,
                                      style: MyTextStyle.textStyle(
                                          FontWeight.w400,
                                          16,
                                          MyColor.app_white_color),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: MyColor.app_divder_color,
                              thickness: 1,
                              height: 2,
                            ),
                            Container(
                              width: SizeConfig.screenWidth,
                              margin: const EdgeInsets.only(top: 20),
                              padding:
                                  const EdgeInsets.only(left: 50, right: 50),
                              decoration: BoxDecoration(
                                  // color: MyColor.app_white_color,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Obx(() => CircleAvatar(
                                        radius: 70,
                                        backgroundColor:
                                            MyColor.app_border_grey_color,
                                        child: CircleAvatar(
                                            radius: 70,
                                            backgroundColor:
                                                MyColor.app_grey_color,
                                            child: (_imageFile.value != null &&
                                                    _imageFile!.value?.path !=
                                                        "")
                                                ? ClipOval(
                                                    child: Image.file(
                                                      _imageFile.value!,
                                                      // height: 120,
                                                      // width: 120,
                                                    ),
                                                  )
                                                : ClipOval(
                                                    child: controller.profileImg
                                                                .value !=
                                                            ""
                                                        ? Image.network(
                                                            controller
                                                                .profileImg
                                                                .value,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.asset(
                                                            MyAssetsImage
                                                                .app_profileimg,
                                                            fit: BoxFit.cover,
                                                          ),
                                                  )),
                                      )),
                                  const SizedBox(height: 20),
                                  InkWell(
                                    onTap: () {
                                      UploadImageDialog.show(context, () async {
                                        Get.back();
                                        var file = await CommonFunction()
                                            .pickImage(ImageSource.camera);
                                        print(">>>>>> $file");
                                        print(">camera>>>>> ${file?.path}");
                                        _imageFile.value = File(file!.path);
                                      }, () async {
                                        Get.back();
                                        var file = await CommonFunction()
                                            .pickImage(ImageSource.gallery);
                                        print(">>>>>> $file");
                                        print(">gallery>>>>> ${file?.path}");
                                        _imageFile.value = File(file!.path);
                                      });
                                    },
                                    child: Card(
                                      margin: EdgeInsets.zero,
                                      color: MyColor.app_orange_color.value ??
                                          const Color(0xFFFF4300),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: SizedBox(
                                        width: 164,
                                        height: 44,
                                        // padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                        child: Center(
                                          child: Text(MyString.select_photo_var,
                                              textAlign: TextAlign.center,
                                              style:
                                                  MyTextStyle.buttonTextStyle(
                                                      FontWeight.w600, 15)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                _imageFile.value = null;
                                profileImg.value = '';
                                removeProfilePicture.value = "1";
                              },
                              child: Center(
                                child: Text(
                                  MyString.remove_var,
                                  textAlign: TextAlign.center,
                                  style: MyTextStyle.textStyle(FontWeight.w600,
                                      14, MyColor.app_white_color),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                validation();
                                print("object");
                              },
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                // padding: EdgeInsets.all(15),
                                //width: widthPerBox! * 75,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5)),
                                  color: MyColor.app_orange_color.value ??
                                      const Color(0xFFFF4300),
                                ),
                                child: Text(
                                  MyString.save_var,
                                  style: MyTextStyle.textStyle(
                                      FontWeight.w700,
                                      16.8,
                                      MyColor.app_button_text_dynamic_color,
                                      letterSpacing: 0.48),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ]));
                    })))));
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? userSelectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.red,
            ).copyWith(secondary: Colors.red),
          ),
          child: Builder(builder: (BuildContext context) {
            return child!;
          }),
        );
      },
    );

    if (userSelectedDate == null) {
      return;
    } else {
      print("currentDate >>>" + userSelectedDate.toString());
      setState(() {
        selectedDateTime = userSelectedDate;
        dobController.text =
            DateFormat('dd MMMM yyy').format(selectedDateTime!);
      });

      print("currentDate >>>" + DateTime.now().toString());
    }
  }

  validation() {
    if (dobController.text.trim().isEmpty) {
      isError.value = 1;
      errorMessage1.value = "Please select ";
      errorMessage2.value = "date of birth";
    } else if (controller.select.value == "Other" ||
        controller.select.value.isEmpty) {
      controller.isError.value = 2;
      controller.errorMessage1.value = "Please select ";
      controller.errorMessage2.value = "gender";
    } else {
      wcController.onBoardingStep(
          DateFormat("yyyy-MM-dd").format(selectedDateTime != null
              ? selectedDateTime!
              : DateTime.parse(dobController.text.trim().toString())),
          controller.select.value == "Male"
              ? "1"
              : controller.select.value == "Female"
                  ? "2"
                  : "3",
          bibController.text,
          removeProfilePicture.value,
          _imageFile.value);
    }
  }
}
