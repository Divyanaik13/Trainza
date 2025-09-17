import 'dart:convert';
import 'dart:ffi';

import 'package:club_runner/util/FunctionConstant/FunctionConstant.dart';
import 'package:club_runner/util/asstes_image/AssetsImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../../controller/EditRaceEventController.dart';
import '../../../controller/EventDetailController.dart';
import '../../../controller/EventScreenController.dart';
import '../../../models/ResultDetail_Model.dart';
import '../../../util/custom_view/CustomView.dart';
import '../../../util/my_color/MyColor.dart';
import '../../../util/size_config/SizeConfig.dart';
import '../../../util/string_const/MyString.dart';
import '../../../util/text_style/MyTextStyle.dart';

class EditRaceEventScreen extends StatefulWidget {
  const EditRaceEventScreen({super.key});

  @override
  State<EditRaceEventScreen> createState() => _EditRaceEventScreenState();
}

class _EditRaceEventScreenState extends State<EditRaceEventScreen> {
  EditRaceEventController re_controller = Get.put(EditRaceEventController());
  EventDetailsController e_controller = Get.put(EventDetailsController());
  EventController eventcon = Get.put(EventController());

  var distances = <Distance>[].obs;
  var date;
  var day;

  @override
  void initState() {
    // TODO: implement initState
    print("parameter ${Get.parameters["resultId"].toString()}");
    print("parameter distance ${Get.parameters["distance"]}");

/*    var isDisabled = false.obs;
    if (controller.dateData.value[index].eventInfo.eventStartDate != "" &&
        controller.dateData.value[index].eventInfo.eventEndDate == null) {
      print("eventStartDate ");
      isDisabled.value = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day) !=
          DateTime.parse(
              controller.dateData.value[index].eventInfo.eventStartDate);
    } else if (controller.dateData.value[index].eventInfo.repeatingDays
        .toString() !=
        "" &&
        controller.dateData.value[index].eventInfo.repeatingDays.toString() !=
            "null" &&
        controller.dateData.value[index].eventInfo.repeatingDays.toString() !=
            null) {
      var currentDay = eventcon.REPEATING_DAYS
          .where(
              (day) => day['day'] == DateFormat('EEE').format(DateTime.now()))
          .toList();
      Object? cDay =
      currentDay.isNotEmpty ? currentDay.first['day'] : 'Unknown';
      print("arr $currentDay");
      print("cDay Name: $cDay");

      var matchedDay = eventcon.REPEATING_DAYS
          .where(
            (day) =>
        day['id'] ==
            int.parse(
                controller.dateData.value[index].eventInfo.repeatingDays),
      )
          .toList();
      print("matchedDay : ${matchedDay}");
      Object? eventDay =
      matchedDay.isNotEmpty ? matchedDay.first['day'] : 'Unknown';
      print("eventDay Name: $eventDay");

      isDisabled.value = currentDay != eventDay;
    } else if (controller.dateData.value[index].eventInfo.eventStartDate !=
        "" &&
        controller.dateData.value[index].eventInfo.eventEndDate != "") {
      print("Date Range");
      print(
          "isBefore ${DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).isBefore(DateTime.parse(controller.dateData.value[index].eventInfo.eventEndDate))}");
      print(
          "isAfter ${DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).isAfter(DateTime.parse(controller.dateData.value[index].eventInfo.eventStartDate))}");

      isDisabled.value = !((DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).isAfter(DateTime.parse(
          controller.dateData.value[index].eventInfo.eventStartDate)) ||
          (DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString() ==
              DateTime.parse(controller.dateData.value[index].eventInfo.eventStartDate)
                  .toString())) &&
          (DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).isBefore(DateTime.parse(
              controller.dateData.value[index].eventInfo.eventEndDate)) ||
              (DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString() ==
                  DateTime.parse(controller.dateData.value[index].eventInfo.eventEndDate).toString())));
      print("Date Range :-- ${isDisabled.value}");
    }*/

    if (Get.parameters["resultId"].toString() != "null") {
      resultDetail();
    } else {
      distances.value = (jsonDecode(Get.parameters["distance"]!) as List)
          .map((data) => Distance.fromJson(data))
          .toList();
      print("parameter distance 1 ${distances.value}");
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    re_controller.resultDetailModel.refresh();
    re_controller.selectedDistance.refresh();
    return Obx(() {
      if (re_controller.resultDetailModel.value == null &&
          Get.parameters["resultId"].toString() != "null") {
        return Container(
          color: MyColor.screen_bg,
          child: const Center(
              child: CircularProgressIndicator()), // or any loading indicator
        );
      }
      return Container(
        color: MyColor.screen_bg,
        child: SafeArea(
            child: Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                CustomView.customAppBar("${MyString.race_var.toUpperCase()}",
                    MyString.result_var.toUpperCase(), () {
                  Get.back();
                }),
                const SizedBox(height: 30),
                SizedBox(
                  width: re_controller.screenWidth,
                  child: Card(
                    elevation: 0.0,
                    color: MyColor.app_orange_color.value ??
                        const Color(0xFFFF4300),
                    margin: const EdgeInsets.only(top: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Get.parameters["resultId"].toString() != "null"
                                ? re_controller
                                    .resultDetailModel.value!.event.eventName
                                : Get.parameters["eventName"].toString(),
                            style: MyTextStyle.textStyle(
                                FontWeight.w700, 14, MyColor.app_white_color,
                                lineHeight: 1.429),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Get.parameters["resultId"].toString() != "null"
                              ? CustomView.differentStyleTextTogether(
                                  day == null ? "" : day,
                                  FontWeight.w700,
                                  date == null ? "" : date,
                                  FontWeight.w300,
                                  14,
                                  MyColor.app_white_color,
                                  lineHeight: 1.429)
                              : CustomView.differentStyleTextTogether(
                                  DateFormat('EE').format(DateTime.parse(
                                      Get.parameters["eventDate"].toString())),
                                  FontWeight.w700,
                                  DateFormat(' d MMM yyyy').format(
                                      DateTime.parse(Get.parameters["eventDate"]
                                          .toString())),
                                  FontWeight.w300,
                                  14,
                                  MyColor.app_white_color,
                                  lineHeight: 1.429),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Get.parameters["resultId"].toString() != "null"
                    ? editResultCard(context)
                    : submitResultCard(context)
              ],
            ),
          ),
        )),
      );
    });
  }

  Widget editResultCard(BuildContext context) {
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
                    1.111),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    width: (MediaQuery.of(context).size.width) - 20,
                    height: 40,
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: DropdownButton(
                      value: re_controller.selectedDistance.value,
                      hint: Text(
                        re_controller.distance.value == ""
                            ? "Select Distance"
                            : "${re_controller.distance.value}${re_controller.distanceUnit.toString() == "1" ? " KM" : " MI"}",
                      ),
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
                      items: re_controller
                          .resultDetailModel.value!.event.distances
                          .map<DropdownMenuItem<Distance>>((Distance value) {
                        return DropdownMenuItem<Distance>(
                          value: value,
                          child: Text(
                            "${value.distance}${value.unit.toString() == "1" ? " KM" : " MI"}",
                          ),
                        );
                      }).toList(),
                      onChanged: (Distance? value) {
                        re_controller.selectedDistance.value = value!;
                        re_controller.editDistanceId.value =
                            re_controller.selectedDistance.value!.id;
                        re_controller.distance.value = re_controller
                            .selectedDistance.value!.distance
                            .toString();

                        print(
                            "onchanged editDistanceId ${re_controller.editDistanceId.value}");
                        print(
                            "onchanged distance ${re_controller.distance.value}");
                      },
                      // onTap: onTap,
                    ),
                    decoration: BoxDecoration(
                      color: MyColor.app_text_box_bg_color,
                      border: Border.all(
                          color: const Color(0xFF979797), width: 1.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  )),
              const SizedBox(
                height: 17,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        decoration: BoxDecoration(
                            color: MyColor.app_white_color,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.4))),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: re_controller.hourController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(3),
                                _NumberLimitFormatter(1000),
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
                                    FontWeight.w700,
                                    30,
                                    MyColor.app_black_color),
                              ),
                            ),
                            Text(
                              MyString.hours_var,
                              style: MyTextStyle.textStyle(FontWeight.w500,
                                  15.4, MyColor.app_black_color,
                                  lineHeight: 1.571),
                            )
                          ],
                        ),
                      ),
                    ),
                    Text(
                      " : ",
                      style: MyTextStyle.textStyle(
                          FontWeight.w700, 30.8, MyColor.app_black_color),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: MyColor.app_white_color,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.4))),
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: re_controller.minController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                // LengthLimitingTextInputFormatter(2),
                                _NumberLimitFormatter(60),
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
                                    FontWeight.w700,
                                    30,
                                    MyColor.app_black_color),
                              ),
                              onChanged: (value) {
                                print(
                                    "controller :- ${re_controller.minController.text}");

                                if (re_controller.minController.text.length ==
                                    1) {
                                  re_controller.minController.text =
                                      "0${re_controller.minController.text}";
                                } else if (re_controller
                                        .minController.text.length >
                                    1) {
                                  re_controller.minController.text =
                                      re_controller.minController.text
                                          .substring(1);
                                }
                              },
                            ),
                            Text(
                              MyString.mins_var,
                              style: MyTextStyle.textStyle(FontWeight.w500,
                                  15.4, MyColor.app_black_color,
                                  lineHeight: 1.571),
                            )
                          ],
                        ),
                      ),
                    ),
                    Text(
                      " : ",
                      style: MyTextStyle.textStyle(
                          FontWeight.w700, 30.8, MyColor.app_black_color),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: MyColor.app_white_color,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.4))),
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: re_controller.secController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                // LengthLimitingTextInputFormatter(2),
                                _NumberLimitFormatter(60),
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
                                    FontWeight.bold,
                                    30,
                                    MyColor.app_black_color),
                              ),
                              onTapOutside: (e) {
                                CommonFunction.keyboardHide(context);
                              },
                              onChanged: (value) {
                                print(
                                    "controller :- ${re_controller.secController.text}");

                                if (re_controller.secController.text.length ==
                                    1) {
                                  re_controller.secController.text =
                                      "0${re_controller.secController.text}";
                                } else if (re_controller
                                        .secController.text.length >
                                    1) {
                                  re_controller.secController.text =
                                      re_controller.secController.text
                                          .substring(1);
                                }
                              },
                            ),
                            Text(
                              MyString.sec_var,
                              style: MyTextStyle.textStyle(FontWeight.w500,
                                  15.4, MyColor.app_black_color,
                                  lineHeight: 1.571),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 19,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    width: SizeConfig.screenWidth,
                    height: 54,
                    child: ElevatedButton(
                        onPressed: () {
                          if (re_controller.hourController.text == "00" ||
                              re_controller.hourController.text == "" ||
                              re_controller.hourController.text == "0") {
                            re_controller.hourController.text = "00";
                          }
                          if (re_controller.minController.text == "00" ||
                              re_controller.minController.text == "" ||
                              re_controller.minController.text == "0") {
                            re_controller.minController.text = "00";
                          }
                          if (re_controller.secController.text == "00" ||
                              re_controller.secController.text == "" ||
                              re_controller.minController.text == "0") {
                            re_controller.secController.text = "00";
                          }
                          var pace = CommonFunction.calculatePace(
                              double.parse(
                                  re_controller.distance.value.toString()),
                              int.parse(re_controller.hourController.text
                                  .trim()
                                  .toString()),
                              int.parse(re_controller.minController.text
                                  .trim()
                                  .toString()),
                              int.parse(re_controller.secController.text
                                  .trim()
                                  .toString()));

                          var arr = pace.split(":");
                          if (arr.length == 2) {
                            if (arr[1].length == 1) {
                              arr[1] = "0" + arr[1];
                            }
                            pace = arr[0] + ":" + arr[1];
                          }

                          var convertPace = "$pace p/km".toString();
                          var timeSend =
                              "${re_controller.hourController.text.trim().length == 1 ? "${re_controller.hourController.text.trim()}" : re_controller.hourController.text.trim()}:"
                              "${re_controller.minController.text.trim().length == 1 ? "0${re_controller.minController.text.trim()}" : re_controller.minController.text.trim()}:"
                              "${re_controller.secController.text.trim().length == 1 ? "0${re_controller.secController.text.trim()}" : re_controller.secController.text.trim()}";

                          print("convertPace :- $convertPace");
                          print("timeSend edit :- $timeSend");
                          print(
                              "edit selectedDistance :- ${re_controller.resultDetailModel.value!.eventId}");

                          if (re_controller.selectedDistance.value == null &&
                              re_controller.selectedDistance.value == "null" &&
                              re_controller.resultDetailModel.value!.eventId ==
                                  "") {
                            CustomView.showAlertDialogBox(
                                context, "Please select distance");
                            print("submitYourResult---1");
                          } else if (re_controller.hourController.text ==
                                  "00" &&
                              re_controller.minController.text == "00" &&
                              re_controller.secController.text == "00") {
                            CustomView.showAlertDialogBox(
                                context, "Please enter time");
                            print("please enter time --- 2");
                          } else {
                            re_controller.Event_addResults_api(
                                    re_controller
                                        .resultDetailModel.value!.eventId,
                                    re_controller.editDistanceId.value,
                                    timeSend,
                                    convertPace,
                                    Get.parameters["resultId"].toString())
                                .then((value) {
                              var backdata = {
                                "pace": convertPace,
                                "distance": re_controller.distance.value,
                                "eventResult": timeSend,
                                "index": Get.parameters["index"].toString()
                              };
                              Get.back(result: backdata);
                            });
                          }

                          CommonFunction.keyboardHide(context);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              MyColor.app_orange_color.value ??
                                  const Color(0xFFFF4300)),
                          shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        child: CustomView.twotextView(
                            MyString.submitYourResult_var.substring(0, 6),
                            FontWeight.w400,
                            MyString.submitYourResult_var.substring(6, 19),
                            FontWeight.w600,
                            17,
                            MyColor.app_white_color,
                            1)),
                  )),
              const SizedBox(
                height: 22.5,
              ),
              InkWell(
                onTap: () {
                  re_controller.deleteEventRaceResult_Api(
                      context, Get.parameters["resultId"].toString());
                  // re_controller.selectedDistance.value = 'Select Distance';
                  re_controller.hourController.clear();
                  re_controller.minController.clear();
                  re_controller.secController.clear();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      MyAssetsImage.app_delete,
                      height: 21,
                      color: MyColor.app_black_color,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Delete Result",
                      style: MyTextStyle.textStyle(
                          FontWeight.w600, 16, MyColor.app_black_color),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 22.5,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget submitResultCard(BuildContext context) {
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
                    1.111),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    width: (MediaQuery.of(context).size.width) - 20,
                    height: 40,
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                      color: MyColor.app_text_box_bg_color,
                      border: Border.all(
                          color: const Color(0xFF979797), width: 1.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: DropdownButton(
                      value: re_controller.selectedDistance.value,
                      hint: const Text(
                        "Select Distance",
                      ),
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
                      items: distances
                          .map<DropdownMenuItem<Distance>>((Distance value) {
                        return DropdownMenuItem<Distance>(
                          value: value,
                          child: Text(
                            "${value.distance} ${value.unit == 1 ? "KM" : "MI"}",
                          ),
                        );
                      }).toList(),
                      onChanged: (Distance? value) {
                        re_controller.selectedDistance.value = value!;
                        re_controller.editDistanceId.value =
                            re_controller.selectedDistance.value!.id;
                        re_controller.distance.value = re_controller
                            .selectedDistance.value!.distance
                            .toString();

                        print(
                            "onchanged editDistanceId ${re_controller.editDistanceId.value}");
                        print(
                            "onchanged distance ${re_controller.distance.value}");
                      },
                      // onTap: onTap,
                    ),
                  )),
              const SizedBox(
                height: 17,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        decoration: BoxDecoration(
                            color: MyColor.app_white_color,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.4))),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: re_controller.hourController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(3),
                                _NumberLimitFormatter(1000),
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
                                    FontWeight.w700,
                                    30,
                                    MyColor.app_border_grey_color),
                              ),
                            ),
                            Text(
                              MyString.hours_var,
                              style: MyTextStyle.textStyle(FontWeight.w500,
                                  15.4, MyColor.app_black_color,
                                  lineHeight: 1.571),
                            )
                          ],
                        ),
                      ),
                    ),
                    Text(
                      " : ",
                      style: MyTextStyle.textStyle(
                          FontWeight.w700, 30.8, MyColor.app_black_color),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: MyColor.app_white_color,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.4))),
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: re_controller.minController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                // LengthLimitingTextInputFormatter(2),
                                _NumberLimitFormatter(60),
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
                                    FontWeight.w700,
                                    30,
                                    MyColor.app_border_grey_color),
                              ),
                              onTapOutside: (e) {
                                CommonFunction.keyboardHide(context);
                              },
                              onChanged: (value) {
                                print(
                                    "controller :- ${re_controller.minController.text}");

                                if (re_controller.minController.text.length == 1 && re_controller.minController.text[0] != "0") {
                                  re_controller.minController.text =
                                      "0${re_controller.minController.text}";
                                } else if (re_controller
                                        .minController.text.length >
                                    2) {
                                  re_controller.minController.text =
                                      re_controller.minController.text
                                          .substring(1);
                                }
                              },
                            ),
                            Text(
                              MyString.mins_var,
                              style: MyTextStyle.textStyle(FontWeight.w500,
                                  15.4, MyColor.app_black_color,
                                  lineHeight: 1.571),
                            )
                          ],
                        ),
                      ),
                    ),
                    Text(
                      " : ",
                      style: MyTextStyle.textStyle(
                          FontWeight.w700, 30.8, MyColor.app_black_color),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: MyColor.app_white_color,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.4))),
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: re_controller.secController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                // LengthLimitingTextInputFormatter(2),
                                _NumberLimitFormatter(60),
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
                                    FontWeight.bold,
                                    30,
                                    MyColor.app_border_grey_color),
                              ),
                              onTapOutside: (e) {
                                CommonFunction.keyboardHide(context);
                              },
                              onChanged: (value) {
                                print(
                                    "controller :- ${re_controller.secController.text}");

                                if (re_controller.secController.text.length ==
                                    1 && re_controller.secController.text[0] != "0") {
                                  re_controller.secController.text =
                                      "0${re_controller.secController.text}";
                                } else if (re_controller
                                        .secController.text.length >
                                    2) {
                                  re_controller.secController.text =
                                      re_controller.secController.text
                                          .substring(1);
                                }
                              },
                            ),
                            Text(
                              MyString.sec_var,
                              style: MyTextStyle.textStyle(FontWeight.w500,
                                  15.4, MyColor.app_black_color,
                                  lineHeight: 1.571),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 19,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    width: SizeConfig.screenWidth,
                    height: 54,
                    child: ElevatedButton(
                        onPressed: () {
                          if (re_controller.hourController.text == "00" ||
                              re_controller.hourController.text == "" ||
                              re_controller.hourController.text == "0") {
                            re_controller.hourController.text = "00";
                          }
                          if (re_controller.minController.text == "00" ||
                              re_controller.minController.text == "" ||
                              re_controller.minController.text == "0") {
                            re_controller.minController.text = "00";
                          }
                          if (re_controller.secController.text == "00" ||
                              re_controller.secController.text == "" ||
                              re_controller.minController.text == "0") {
                            re_controller.secController.text = "00";
                          }
                          print(
                              "selectedDistance:- ${re_controller.selectedDistance.value}");
                          var convertPace;
                          var timeSend;
                          if (re_controller.selectedDistance.value != null) {
                            var pace = CommonFunction.calculatePace(
                                double.parse(
                                    re_controller.distance.value.toString()),
                                int.parse(re_controller.hourController.text
                                    .trim()
                                    .toString()),
                                int.parse(re_controller.minController.text
                                    .trim()
                                    .toString()),
                                int.parse(re_controller.secController.text
                                    .trim().toString()));
                            convertPace = "$pace p/km".toString();
                            timeSend =
                                "${re_controller.hourController.text.trim().length == 1 ? "${re_controller.hourController.text.trim()}" : re_controller.hourController.text.trim()}:"
                                "${re_controller.minController.text.trim().length == 1 ? "0${re_controller.minController.text.trim()}" : re_controller.minController.text.trim()}:"
                                "${re_controller.secController.text.trim().length == 1 ? "0${re_controller.secController.text.trim()}" : re_controller.secController.text.trim()}";

                            print("convertPace :- $convertPace");
                            print("timeSend submit:- $timeSend");
                          }
                          if (re_controller.selectedDistance.value == null &&
                              re_controller.selectedDistance.value == "null" &&
                              re_controller.resultDetailModel.value!.eventId ==
                                  "") {
                            CustomView.showAlertDialogBox(
                                context, "Please select distance");
                            print("submitYourResult---1");
                          } else if (re_controller.hourController.text ==
                                  "00" &&
                              re_controller.minController.text == "00" &&
                              re_controller.secController.text == "00") {
                            CustomView.showAlertDialogBox(
                                context, "Please enter time");
                            print("please enter time --- 2");
                          } else {
                            re_controller.Event_addResults_api(
                                    Get.parameters["eventId"].toString(),
                                    re_controller.editDistanceId.value,
                                    timeSend,
                                    convertPace,
                                    "")
                                .then((value) {
                              print("value Event_addResults_api:-$value");
                              var json = jsonDecode(value);

                              re_controller.selectedDistance.value = null;
                              re_controller.hourController.text = "00";
                              re_controller.minController.text = "00";
                              re_controller.secController.text = "00";
                              if (json["code"].toString() == "200") {
                                Get.back(result: "value");
                              }
                            });
                          }

                          CommonFunction.keyboardHide(context);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              MyColor.app_orange_color.value ??
                                  const Color(0xFFFF4300)),
                          shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        child: CustomView.twotextView(
                            MyString.submitYourResult_var.substring(0, 6),
                            FontWeight.w400,
                            MyString.submitYourResult_var.substring(6, 19),
                            FontWeight.w600,
                            17,
                            MyColor.app_white_color,
                            1)),
                  )),
              const SizedBox(
                height: 22.5,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildTimeElement(String label, TextEditingController controller,
      List<TextInputFormatter> inputFormatter) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
          color: MyColor.app_white_color,
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 30,
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                style: MyTextStyle.textStyle(FontWeight.w500,
                    re_controller.fontSize * 3.5, MyColor.app_black_color),
                inputFormatters: inputFormatter,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "00",
                  hintStyle: MyTextStyle.textStyle(FontWeight.w700,
                      re_controller.fontSize * 3.5, MyColor.app_black_color),
                ),
                onTapOutside: (event) {
                  print('onTapOutside');
                  CommonFunction.keyboardHide(context);
                },
              ),
            ),
          ),
          Text(
            label,
            style: MyTextStyle.textStyle(FontWeight.w500,
                re_controller.fontSize * 2.5, MyColor.app_black_color),
          ),
        ],
      ),
    );
  }

  void showDistanceMenu(BuildContext context) async {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final left = offset.dx;
    final top = offset.dy + renderBox.size.height;
    final right = left + renderBox.size.width;

    final result = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, right, 0.0),
      items: re_controller.distances.map((String distance) {
        return PopupMenuItem<String>(
          value: distance,
          child: Text(distance),
        );
      }).toList(),
    );

    if (result != null) {
      setState(() {
        // re_controller.selectedDistance.value = result;
        re_controller.distanceCtrl.text = result;
      });
    }
  }

  void resultDetail() {
    re_controller
        .resultDetail_API(Get.parameters["resultId"].toString())
        .then((value) {
      if (value != "") {
        print("resultDetail :--$value");
        re_controller.editDistanceId.value =
            re_controller.resultDetailModel.value!.distanceId;

        re_controller.distance.value =
            re_controller.resultDetailModel.value!.event.distances
                .firstWhere((element) => element.id == re_controller.editDistanceId.value,)!
                .distance.toString();

/*         distances.value = re_controller.resultDetailModel.value!.event.distances;
        List<double> distanceValues = distances.map((distance) => distance.distance.toDouble()).toList();*/

        print("distance :--${jsonEncode(re_controller.resultDetailModel.value!.event.distances)}");
     //   print("distanceValues :--${jsonEncode(distanceValues)}");

        re_controller.distanceUnit.value =
            re_controller.resultDetailModel.value!.event.distances
                .firstWhere(
                  (element) => element.id == re_controller.editDistanceId.value,
                )!
                .unit
                .toString();
        print("distance unit :--${re_controller.distanceUnit.value}");

        List<String> splitResult =
            re_controller.resultDetailModel.value!.result.split(':');
        re_controller.hourController.text = splitResult[0].toString();
        re_controller.minController.text = splitResult[1].toString();
        re_controller.secController.text = splitResult[2].toString();

        if (re_controller.resultDetailModel.value!.event.eventDate != "null" &&
            re_controller.resultDetailModel.value!.event.eventDate != "" &&
            re_controller.resultDetailModel.value!.event.eventDate != null) {
          date = DateFormat(' d MMM yyyy').format(DateTime.parse(
              re_controller.resultDetailModel.value!.event.eventDate));
          day = DateFormat('EE').format(DateTime.parse(
              re_controller.resultDetailModel.value!.event.eventDate));

          print("date if $date");
          print("day $day");
        } else {
          print("else date");
          date = "";
        }

        if (re_controller.resultDetailModel.value!.event.repeatingDays ==
                "null" ||
            re_controller.resultDetailModel.value!.event.repeatingDays == "" ||
            re_controller.resultDetailModel.value!.event.repeatingDays ==
                null) {
          print("111222");
          day = "";
        } else {
          print(
              "repeatingDays 123 ${re_controller.resultDetailModel.value!.event.repeatingDays}");
          day = eventcon.REPEATING_DAYS.firstWhere((element) =>
              element['id'] ==
              int.parse(re_controller
                  .resultDetailModel.value!.event.repeatingDays))['day'];
        }

        print("distance ${re_controller.distance.value}");
        print("distance Unit ${re_controller.distanceUnit.value}");
        print(
            "splitResult hourController ${re_controller.hourController.text}");
        print("splitResult minController ${re_controller.minController.text}");
        print(
            "splitResult hourController ${re_controller.hourController.text}");
      }
    });
  }
}

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
      return oldValue;
    }

    return newValue;
  }
}
