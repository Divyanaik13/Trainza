import 'package:club_runner/util/custom_view/CustomView.dart';
import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:club_runner/util/route_helper/RouteHelper.dart';
import 'package:club_runner/util/string_const/MyString.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controller/EditPersonalBestScreenController.dart';
import '../../../models/DistanceMeta_Model.dart';
import '../../../models/PbDistanceMeta_Model.dart';
import '../../../util/FunctionConstant/FunctionConstant.dart';
import '../../../util/asstes_image/AssetsImage.dart';
import '../../../util/local_storage/LocalStorage.dart';
import '../../../util/size_config/SizeConfig.dart';
import '../../../util/text_style/MyTextStyle.dart';

class PersonalBest extends StatefulWidget {
  const PersonalBest({super.key});

  @override
  State<PersonalBest> createState() => _PersonalBestState();
}

class _PersonalBestState extends State<PersonalBest> {
  final pb_controller = EditPersonalBestScreenController();
  LocalStorage sp = LocalStorage();

  @override
  void initState() {
    super.initState();
    pb_controller.PersonalBest_API().then((value) {
      if (value != "") {
        pb_controller.distanceMeta_API().then((value) {
          if (value != "") {
            filterValue();
          }
        });
      }
    });
  }

  void filterValue() {
    print(
        "pb_controller.distanceMetaListDefault lenght :-- ${EditPersonalBestScreenController.distanceMetaListDefault.length}");
    pb_controller.distanceMetaList.clear();
    pb_controller.distanceMetaList
        .assignAll(EditPersonalBestScreenController.distanceMetaListDefault);
    for (final element1 in pb_controller.personalBestList) {
      var array = pb_controller.distanceMetaList
          .where((item) => item.id == element1.distanceId)
          .toList();
      print("array");
      print(array.length);
      pb_controller.distanceMetaList.remove(array[0]);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColor.screen_bg,
      child: SafeArea(
          child: Obx(() => Scaffold(
                body: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      CustomView.customAppBar(
                          MyString.your_pb_var.toString().substring(0, 4),
                          MyString.your_pb_var.toString().substring(4), () {
                        Get.back(result: "refresh");
                      }),
                      const SizedBox(height: 30),
                      Divider(
                        color: MyColor.app_divder_color,
                        thickness: 1,
                        height: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
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
                      const SizedBox(
                        height: 15,
                      ),
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: pb_controller.personalBestList.length,
                          itemBuilder: (context, index) {
                            var Details = pb_controller.personalBestList[index];
                            print("personalbest--->$Details");
                            int unit = int.tryParse(Details.unit) ?? 0;
                            String formattedBestTime = Details.bestTime;

                            // Try to split the bestTime into hours, minutes, and seconds
                            List<String> timeParts =
                                formattedBestTime.split(':');
                            if (timeParts.length == 3) {
                              // Format hours, minutes, and seconds
                              int hours = int.tryParse(timeParts[0]) ?? 0;
                              int minutes = int.tryParse(timeParts[1]) ?? 0;
                              int seconds = int.tryParse(timeParts[2]) ?? 0;
                              formattedBestTime =
                                  '${hours.toString()}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
                            } else if (timeParts.length == 2) {
                              // Format minutes and seconds
                              int minutes = int.tryParse(timeParts[0]) ?? 0;
                              int seconds = int.tryParse(timeParts[1]) ?? 0;
                              formattedBestTime =
                                  '${minutes.toString()}:${seconds.toString().padLeft(2, '0')}';
                            }
                            return Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              // padding: EdgeInsets.all(10),
                              height: 38,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: MyColor.app_border_color),
                                  borderRadius: BorderRadius.circular(5)),
                              child: CustomView.differentStyleTextTogether(
                                  Details.distance.toString() +
                                      (unit == 1 ? 'KM ' : 'MI '),
                                  FontWeight.w700,
                                  formattedBestTime,
                                  FontWeight.w300,
                                  16,
                                  MyColor.app_white_color),
                            );
                          }),
                      pb_controller.personalBestList.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 30, bottom: 20),
                              child: CustomView.customButtonWithBorder(
                                  "EDIT BESTS", () async {
                                var result = await Get.toNamed(
                                    RouteHelper.editpersonalBestScreen);
                                print(result);

                                if (result != null) {
                                  pb_controller.distanceKM.value = "";
                                  pb_controller.distanceId = "";
                                  pb_controller.hourController.clear();
                                  pb_controller.minController.clear();
                                  pb_controller.secController.clear();
                                  pb_controller.PersonalBest_API()
                                      .then((value) {
                                    filterValue();
                                  });
                                }
                              }, 150, 2.0),
                            )
                          : Container(),
                      pb_controller.distanceMetaList.isNotEmpty
                          ? submitResultCard(
                              context, pb_controller.distanceMetaList.length)
                          : Container(),
                      const SizedBox(
                        height: 25,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          height: ((SizeConfig.screenWidth)! -
                                  (SizeConfig.screenWidth! * 40 / 100)) /
                              1.62,
                          width: (SizeConfig.screenWidth)! -
                              (SizeConfig.screenWidth! * 40 / 100),
                          child: LocalStorage.getStringValue(
                                      sp.currentClubData_logo) ==
                                  ""
                              ? Image.asset(MyAssetsImage.app_trainza_ratioLogo,
                                  fit: BoxFit.cover)
                              : Image.network(
                                  LocalStorage.getStringValue(
                                      sp.currentClubData_logo),
                                  fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ))),
    );
  }

  Widget submitResultCard(BuildContext context, int index) {
    return Obx(() {
      return Card(
        color: const Color(0xFFDEDEDE),
        margin: const EdgeInsets.only(top: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: CustomView.twotextView(
                    "SELECT ",
                    FontWeight.w500,
                    "DISTANCE",
                    FontWeight.w700,
                    18,
                    MyColor.app_black_color,
                    0),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 40,
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  decoration: BoxDecoration(
                    color: MyColor.app_text_box_bg_color,
                    border:
                        Border.all(color: const Color(0xFF979797), width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: DropdownButton(
                      value: pb_controller.selectedDistance.value,
                      hint: Text(pb_controller.distanceKM == ""
                          ? "Select Distance"
                          : "${pb_controller.distanceKM.value}"),
                      isExpanded: true,
                      icon: Image.asset(MyAssetsImage.app_textField_dropdown,
                          height: 15, width: 15),
                      elevation: 16,
                      style: TextStyle(
                        color: MyColor.app_hint_color,
                        fontSize: 15,
                      ),
                      underline: Container(height: 2),
                      items: pb_controller.distanceMetaList.map<DropdownMenuItem<PersonalBestDistanceMeta>>(
                              (PersonalBestDistanceMeta value) {
                        int distanceUnit = int.tryParse(value.distanceUnit) ?? 0;
                        return DropdownMenuItem<PersonalBestDistanceMeta>(
                          value: value,
                          child: Text(
                              "${value.distance.toString()}${distanceUnit == 1 ? 'KM ' : 'MI '}"),
                        );
                      }).toList(),
                      onChanged: (PersonalBestDistanceMeta? value) async {
                        print(value?.distance.toString());
                        setState(() {
                          pb_controller.distanceKM.value = "${value!.distance.toString()}${value.distanceUnit == "1" ? 'KM ' : 'MI '}";
                          pb_controller.distanceId = value!.id.toString();
                          print(pb_controller.distanceKM);
                          print(pb_controller.distanceId);
                        });
                      }),
                ),
              ),
              const SizedBox(height: 17),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _timeInputField(context, pb_controller.hourController, 1000,
                        MyString.hours_var,
                        length: 3),
                    Text(" : ",
                        style: MyTextStyle.textStyle(
                            FontWeight.w700, 30.8, MyColor.app_black_color)),
                    _timeInputField(context, pb_controller.minController, 60,
                        MyString.mins_var, onChanged: (str) {
                      print(
                          "controller :- ${pb_controller.minController.text}");

                      if (pb_controller.minController.text.length == 1 &&
                          pb_controller.minController.text[0] != "0") {
                        pb_controller.minController.text =
                            "0${pb_controller.minController.text}";
                      } else if (pb_controller.minController.text.length > 2) {
                        pb_controller.minController.text =
                            pb_controller.minController.text.substring(1);
                      }
                    }),
                    Text(" : ",
                        style: MyTextStyle.textStyle(
                            FontWeight.w700, 30.8, MyColor.app_black_color)),
                    _timeInputField(context, pb_controller.secController, 60,
                        MyString.sec_var, onChanged: (str) {
                      print(
                          "controller :- ${pb_controller.secController.text}");

                      if (pb_controller.secController.text.length == 1 &&
                          pb_controller.secController.text[0] != "0") {
                        pb_controller.secController.text =
                            "0${pb_controller.secController.text}";
                      } else if (pb_controller.secController.text.length > 2) {
                        pb_controller.secController.text =
                            pb_controller.secController.text.substring(1);
                      }
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: SizeConfig.screenWidth,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      CommonFunction.keyboardHide(context);
                      if (pb_controller.hourController.text.trim().isEmpty) {
                        pb_controller.hourController.text = "0";
                      }
                      if (pb_controller.hourController.text.trim().isEmpty) {
                        pb_controller.hourController.text = "00";
                      }
                      if (pb_controller.hourController.text.trim().isEmpty) {
                        pb_controller.hourController.text = "00";
                      }
                      if (pb_controller.hourController.text == "00" ||
                          pb_controller.hourController.text == "" ||
                          pb_controller.hourController.text == "0") {
                        pb_controller.hourController.text = "00";
                      }
                      if (pb_controller.minController.text == "00" ||
                          pb_controller.minController.text == "" ||
                          pb_controller.minController.text == "0") {
                        pb_controller.minController.text = "00";
                      }
                      if (pb_controller.secController.text == "00" ||
                          pb_controller.secController.text == "" ||
                          pb_controller.minController.text == "0") {
                        pb_controller.secController.text = "00";
                      }
                      print(
                          "submitYourResult ${pb_controller.hourController.text}");
                      print(
                          "submitYourResult ${pb_controller.minController.text}");
                      print(
                          "submitYourResult ${pb_controller.secController.text}");
                      if (pb_controller.distanceKM == "" ||
                          pb_controller.distanceKM == "Select Distance") {
                        print("submitYourResult---1");
                        CustomView.showAlertDialogBox(
                            context, "Please select distance");
                      } else if (pb_controller.hourController.text.isEmpty &&
                          pb_controller.minController.text.isEmpty &&
                          pb_controller.secController.text.isEmpty) {
                        CustomView.showAlertDialogBox(
                            context, "Please enter time");
                        print("please enter time --- 1");
                      } else if ((pb_controller
                                      .hourController.text
                                      .trim()
                                      .toString() ==
                                  "0" &&
                              pb_controller
                                      .minController.text
                                      .trim()
                                      .toString() ==
                                  "00" &&
                              pb_controller
                                      .secController.text
                                      .trim()
                                      .toString() ==
                                  "00") ||
                          (pb_controller
                                      .hourController.text
                                      .trim()
                                      .toString() ==
                                  "00" &&
                              pb_controller.minController.text
                                      .trim()
                                      .toString() ==
                                  "00" &&
                              pb_controller.secController.text
                                      .trim()
                                      .toString() ==
                                  "00")) {
                        CustomView.showAlertDialogBox(
                            context, "Please enter time");
                      }
                      /* else if (pb_controller.hourController.text == "00" &&
                          pb_controller.minController.text == "00" &&
                          pb_controller.secController.text == "00") {
                        CustomView.showAlertDialogBox(
                            context, "Please enter time");
                        print("please enter time --- 2");
                      }
                      else if (pb_controller.hourController.text == "0" &&
                          pb_controller.minController.text == "0" &&
                          pb_controller.secController.text == "0") {
                        CustomView.showAlertDialogBox(
                            context, "Please enter time");
                        print("please enter time --- 3");
                      } */
                      else {
                        /*if (pb_controller.hourController.text == "00" ||
                            pb_controller.hourController.text == "" ||
                            pb_controller.hourController.text == "0") {
                          pb_controller.hourController.text = "00";
                        }
                        if (pb_controller.minController.text == "00" ||
                            pb_controller.minController.text == "" ||
                            pb_controller.minController.text == "0") {
                          pb_controller.minController.text = "00";
                        }
                        if (pb_controller.secController.text == "00" ||
                            pb_controller.secController.text == "" ||
                            pb_controller.minController.text == "0") {
                          pb_controller.secController.text = "00";
                        }*/
                        setState(() {
                          pb_controller.savePersonalBest_api().then((value) {
                            pb_controller.distanceKM.value = "Select Distance";
                            pb_controller.distanceId = "";
                            pb_controller.hourController.clear();
                            pb_controller.minController.clear();
                            pb_controller.secController.clear();
                            if (value != "") {
                              pb_controller.PersonalBest_API().then((value) {
                                filterValue();
                                if (value != "") {}
                              });
                            }
                          });
                        });
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          MyColor.app_orange_color.value ??
                              const Color(0xFFFF4300)),
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                    ),
                    child: CustomView.twotextView(
                        MyString.submitYourResult_var.substring(0, 6),
                        FontWeight.w400,
                        MyString.submitYourResult_var.substring(6, 19),
                        FontWeight.w600,
                        17,
                        MyColor.app_button_text_dynamic_color,
                        1),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    });
  }

  Widget _timeInputField(BuildContext context, TextEditingController controller,
      int max, String label,
      {Function(String)? onChanged, int? length}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        margin: const EdgeInsets.symmetric(horizontal: 7),
        decoration: BoxDecoration(
            color: MyColor.app_white_color,
            borderRadius: const BorderRadius.all(Radius.circular(4.4))),
        child: Column(
          children: [
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(length),
                _NumberLimitFormatter(max),
              ],
              style: MyTextStyle.textStyle(
                  FontWeight.w700, 30, MyColor.app_black_color),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
                hintText: "00",
                hintStyle: MyTextStyle.textStyle(
                    FontWeight.w700, 30, MyColor.app_border_grey_color),
              ),
              onTapOutside: (e) {
                CommonFunction.keyboardHide(context);
              },
              onChanged: onChanged,
              /*  (value) {
                print("controller :- ${controller}");

                if(controller.text.length == 1){
                  controller.text = "0${controller.text}";
                }else if(controller.text.length > 1){
                  controller.text = controller.text.substring(1);
                }
              },*/
            ),
            Text(label,
                style: MyTextStyle.textStyle(
                    FontWeight.w500, 15.4, MyColor.app_black_color,
                    lineHeight: 1.571)),
          ],
        ),
      ),
    );
  }
}

// Number limitetions
class _NumberLimitFormatter extends TextInputFormatter {
  final int limit;

  _NumberLimitFormatter(this.limit);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final parsed = int.tryParse(newValue.text);
    if (parsed == null || parsed >= limit) {
      // Return old value if not a number or greater than limit
      return oldValue;
    }

    final int value = int.parse(newValue.text);
    if (value > limit) {
      return oldValue;
    }
    return newValue;
  }
}
