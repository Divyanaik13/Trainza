import 'package:club_runner/controller/CalendarController.dart';
import 'package:club_runner/controller/WorkLogBookController.dart';
import 'package:club_runner/util/FunctionConstant/FunctionConstant.dart';
import 'package:club_runner/util/asstes_image/AssetsImage.dart';
import 'package:club_runner/util/custom_view/CustomView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../util/my_color/MyColor.dart';
import '../../../../util/string_const/MyString.dart';
import '../../../../util/text_style/MyTextStyle.dart';
import '../../../models/Logbook_UserWorkoutList_Model.dart';
import '../../../models/Logbook_WorkoutType_Model.dart';

class WorkoutLogbookScreen extends StatefulWidget {
  const WorkoutLogbookScreen({super.key});

  @override
  State<WorkoutLogbookScreen> createState() => _WorkoutLogbookScreenState();
}

class _WorkoutLogbookScreenState extends State<WorkoutLogbookScreen> {
  WorkLogBookController wb_controller = Get.put(WorkLogBookController());
  CalendarController controller = Get.put(CalendarController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    wb_controller.logbook_workoutType_api();
    wb_controller
        .logbook_userWorkoutList_api(
            DateFormat("yyyy-MM-dd").format(wb_controller.currentDate.value))
        .then((value) {
      if (value != "") {
        print("value userWorkout :- $value");
        wb_controller.userWorkoutModel.value =
            logbookUserworkoutListModelFromJson(value);
        wb_controller.userWorkoutList.value =
            wb_controller.userWorkoutModel.value!.data;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onHorizontalDragEnd: (DragEndDetails details) {
      if (details.primaryVelocity! > 0) {
        //right swipe
        print("wb_controller.typeOfClick.value");
        print(wb_controller.typeOfClick.value);

        if (wb_controller.typeOfClick.value == "Edit") {
          print("right swipe");
          showDialogBoxNew("Please".toUpperCase(), "Confirm".toUpperCase(),
              "Switching the date will discard your changes", "", () {
            wb_controller.currentDate.value = wb_controller.currentDate.value
                .subtract(const Duration(days: 1));
            wb_controller
                .logbook_userWorkoutList_api(DateFormat("yyyy-MM-dd")
                    .format(wb_controller.currentDate.value))
                .then((value) {
              if (value != "") {
                print("value userWorkout :- $value");
                wb_controller.userWorkoutModel.value =
                    logbookUserworkoutListModelFromJson(value);
                wb_controller.userWorkoutList.value =
                    wb_controller.userWorkoutModel.value!.data;
              }
            });
            Get.back();
          }, () {
            Get.back();
          });
        }
        else {
          wb_controller.currentDate.value =
              wb_controller.currentDate.value.subtract(const Duration(days: 1));
          wb_controller
              .logbook_userWorkoutList_api(DateFormat("yyyy-MM-dd")
                  .format(wb_controller.currentDate.value))
              .then((value) {
            if (value != "") {
              print("value userWorkout :- $value");
              wb_controller.userWorkoutModel.value =
                  logbookUserworkoutListModelFromJson(value);
              wb_controller.userWorkoutList.value =
                  wb_controller.userWorkoutModel.value!.data;
            }
          });
        }
      } else if (details.primaryVelocity! < 0) {
        print("wb_controller.typeOfClick.value");
        print(wb_controller.typeOfClick.value);

        if (wb_controller.typeOfClick.value == "Edit") {
          print("Left Swipe");
          showDialogBoxNew("Please".toUpperCase(), "Confirm".toUpperCase(),
              "Switching the date will discard your changes", "", () {
            wb_controller.currentDate.value =
                wb_controller.currentDate.value.add(const Duration(days: 1));
            wb_controller
                .logbook_userWorkoutList_api(DateFormat("yyyy-MM-dd")
                    .format(wb_controller.currentDate.value))
                .then((value) {
              if (value != "") {
                print("value userWorkout :- $value");
                wb_controller.userWorkoutModel.value =
                    logbookUserworkoutListModelFromJson(value);
                wb_controller.userWorkoutList.value =
                    wb_controller.userWorkoutModel.value!.data;
              }
            });
            Get.back();
          }, () {
            Get.back();
          });
        }
        else {
          wb_controller.currentDate.value =
              wb_controller.currentDate.value.add(const Duration(days: 1));
          wb_controller
              .logbook_userWorkoutList_api(DateFormat("yyyy-MM-dd")
                  .format(wb_controller.currentDate.value))
              .then((value) {
            if (value != "") {
              print("value userWorkout :- $value");
              wb_controller.userWorkoutModel.value =
                  logbookUserworkoutListModelFromJson(value);
              wb_controller.userWorkoutList.value =
                  wb_controller.userWorkoutModel.value!.data;
            }
          });
        }
      }
    },
        child: Obx(() {
      return Container(
        color: MyColor.screen_bg,
        child: SafeArea(
          child: PopScope(
            canPop: true,
            onPopInvoked: (didPop) {
              Future.delayed(Duration.zero, () {
                print("PopScope $didPop");
                Get.back(result: "refresh");
              });
            },
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body:  SingleChildScrollView(physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    CustomView.customAppBarWithDrawerBack(() {
                      Get.back(result: "refresh");
                    }, () {
                      CommonFunction.showCalenderDialogBox(
                        context,
                        wb_controller.focusedDay,
                        wb_controller.selectedDay,
                        wb_controller.heightPerBox!,
                        wb_controller.fontSize,
                        wb_controller.widthPerBox,
                        [],
                        controller: controller,
                      ).then((value) {
                        print("New Value:--  $value");
                        wb_controller.currentDate.value = value;
                        wb_controller
                            .logbook_userWorkoutList_api(
                                DateFormat("yyyy-MM-dd")
                                    .format(wb_controller.currentDate.value))
                            .then((value) {
                          if (value != "") {
                            print("value userWorkout :- $value");
                            wb_controller.userWorkoutModel.value =
                                logbookUserworkoutListModelFromJson(value);
                            wb_controller.userWorkoutList.value =
                                wb_controller.userWorkoutModel.value!.data;
                          }
                        });
                        wb_controller.currentDate.refresh();
                      });
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomView.cardViewDateClick(
                        MyString.your_workout_var,
                        wb_controller.currentDate,
                        MyColor.app_orange_color.value ??
                            const Color(0xFFFF4300), () {
                      print("decrementDate");
                      if (wb_controller.typeOfClick.value == "Edit") {
                        print("decrementDate Edit");
                        showDialogBoxNew(
                            "Please".toUpperCase(),
                            "Confirm".toUpperCase(),
                            "Switching the date will discard your changes",
                            "", () {
                          wb_controller.decrementDate();
                          Get.back();
                        }, () {
                          Get.back();
                        });
                      } else {
                        wb_controller.decrementDate();
                      }
                    }, () {
                      print("incrementDate");
                      if (wb_controller.typeOfClick.value == "Edit") {
                        print("incrementDate Edit");
                        showDialogBoxNew(
                            "Please".toUpperCase(),
                            "Confirm".toUpperCase(),
                            "Switching the date will discard your changes",
                            "", () {
                          wb_controller.incrementDate();
                          Get.back();
                        }, () {
                          Get.back();
                        });
                      } else {
                        wb_controller.incrementDate();
                      }
                    }),
                    const SizedBox(
                      height: 15,
                    ),
                    wb_controller.showWorkout.value
                        ? showDialogBox("",
                            () {
                            wb_controller.showWorkout.value = false;
                            wb_controller.selectedWorkout.value = "";
                            wb_controller.typeOfClick.value = "";
                            wb_controller.clearInputs();
                          },
                            () {
                            print(
                                "userWorkoutId : -- ${wb_controller.userWorkoutId.value}");
                            print(
                                "wb_controller.dropdownValue1.value : -- ${wb_controller.dropdownValue1.value}");
                            print(
                                "userWorkoutId : -- ${wb_controller.selectedWorkout.value}");
                            print(
                                "wb_controller.workoutType : -- ${wb_controller.workoutType}");
                            if(wb_controller.hours_controller.text.trim().isEmpty || wb_controller.hours_controller.text.trim() == "0"){
                            wb_controller.hours_controller.text = "0";
                            }
                            if(wb_controller.minutes_controller.text.trim().isEmpty|| wb_controller.minutes_controller.text.trim() == "0"){
                            wb_controller.minutes_controller.text = "00";
                            }
                            if(wb_controller.second_controller.text.trim().isEmpty|| wb_controller.second_controller.text.trim() == "0"){
                            wb_controller.second_controller.text = "00";
                            }


                            if (wb_controller.workoutType == "") {
                              CustomView.showAlertDialogBox(
                                  context, "Please select workout type");
                            }
                            else if (wb_controller.checkedValue.value) {
                              if (wb_controller.km_controller.text.trim().isEmpty &&
                                  wb_controller.meter_controller.text
                                      .trim().isEmpty) {
                                CustomView.showAlertDialogBox(
                                    context, "Please add distance");
                              }else if ((wb_controller.km_controller.text.trim()=="00" &&
                                  wb_controller.meter_controller.text
                                      .trim()=="00")||(wb_controller.km_controller.text.trim()=="0" &&
                                  wb_controller.meter_controller.text
                                      .trim()=="0")||(wb_controller.km_controller.text.trim()=="0" &&
                                  wb_controller.meter_controller.text
                                      .trim()=="00")||(wb_controller.km_controller.text.trim()=="00" &&
                                  wb_controller.meter_controller.text
                                      .trim()=="0")) {
                                CustomView.showAlertDialogBox(
                                    context, "Please add distance");
                              }
                              else if(wb_controller.hours_controller.text.trim().isEmpty &&
                                  wb_controller.minutes_controller.text.trim().isEmpty &&
                                  wb_controller.second_controller.text.trim().isEmpty) {
                                CustomView.showAlertDialogBox(
                                    context, "Please add time");
                              } else if (wb_controller.hours_controller.text == "00" &&
                                  wb_controller.minutes_controller.text == "00" &&
                                  wb_controller.second_controller.text == "00") {
                                CustomView.showAlertDialogBox(
                                    context, "Please enter time");
                                print("please enter time --- 2");
                              }else if (wb_controller.hours_controller.text ==
                                  "0" &&
                                  wb_controller.minutes_controller.text == "00" &&
                                  wb_controller.second_controller.text == "00") {
                                CustomView.showAlertDialogBox(
                                    context, "Please enter time");
                                print("please enter time --- 2");
                              }
                             /* else if (wb_controller.tv_speed.value.isEmpty ||
                                  wb_controller.tv_speed.value == "0:0" ||
                                  wb_controller.tv_speed.value == "0:0/KM") {
                                CustomView.showAlertDialogBox(
                                    context, "Please add time");
                              } */
                              else {
                                createWorkout(
                                    wb_controller.userWorkoutId.value);
                              }
                            } else {
                              createWorkout(wb_controller.userWorkoutId.value);
                            }
                          })
                        : showWorkoutDetailList(),
                    SizedBox(
                      height: 25,
                    ),
                    !wb_controller.showWorkout.value
                        ? yourWorkOutLogCard()
                        : SizedBox(),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }));
  }

  Widget effortLevelBoxCreateEdit() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: fontBox(
                MyString.easy_var,
                wb_controller.levelTypeNum.value == "1"
                    ? MyColor.app_white_color
                    : MyColor.screen_bg,
                wb_controller.levelTypeNum.value == "1"
                    ? MyColor.screen_bg
                    : MyColor.app_white_color,
                () {
                  wb_controller.levelTypeNum.value = "1";
                },
              ),
            ),
            const SizedBox(
              width: 17,
            ),
            Expanded(
              flex: 1,
              child: fontBox(
                MyString.normal_var,
                wb_controller.levelTypeNum.value == "2"
                    ? MyColor.app_white_color
                    : MyColor.screen_bg,
                wb_controller.levelTypeNum.value == "2"
                    ? MyColor.screen_bg
                    : MyColor.app_white_color,
                () {
                  wb_controller.levelTypeNum.value = "2";
                },
              ),
            ),
            const SizedBox(
              width: 17,
            ),
            Expanded(
              flex: 1,
              child: fontBox(
                MyString.hard_var,
                wb_controller.levelTypeNum.value == "3"
                    ? MyColor.app_white_color
                    : MyColor.screen_bg,
                wb_controller.levelTypeNum.value == "3"
                    ? MyColor.screen_bg
                    : MyColor.app_white_color,
                () {
                  wb_controller.levelTypeNum.value = "3";
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget showData(String headingText, value) {
    return Column(
      children: [
        Text(
          headingText,
          style: MyTextStyle.textStyle(
              FontWeight.w700, 17, MyColor.app_white_color,
              letterSpacing: 0.5),
        ),
        FittedBox(
          fit: BoxFit.contain,
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: MyTextStyle.textStyle(
                FontWeight.w700, 21, MyColor.app_white_color,
                letterSpacing: 0.5),
          ),
        ),
      ],
    );
  }

  Widget fontBox(
      String type, Color fontColor, backgroundColor, VoidCallback onClick) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 45.8,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(3)),
            border: Border.all(color: MyColor.screen_bg, width: 1)),
        child: Text(
          type,
          style: MyTextStyle.textStyle(FontWeight.w700, 13, fontColor),
        ),
      ),
    );
  }

  Widget yourWorkOutLogCard() {
    return Card(
      color: MyColor.app_white_color,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      margin: EdgeInsets.zero,
      elevation: 0.0,
      child: SizedBox(
        height: 128,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: RichText(
                text: TextSpan(
                  text: MyString.log_your_workout_var.substring(0, 4),
                  style: MyTextStyle.textStyle(
                      FontWeight.w400, 17, MyColor.app_black_color),
                  children: <TextSpan>[
                    TextSpan(
                      text: MyString.log_your_workout_var.substring(8),
                      style: MyTextStyle.textStyle(
                          FontWeight.w900, 17, MyColor.app_black_color),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(
              height: 1,
              color: Color(0xFFB4B4B4),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 18),
              child: CustomView.buttonShow(
                  MyString.log_your_workout_var,
                  FontWeight.w600,
                  wb_controller.widthPerBox!,
                  17.28,
                  MyColor.app_orange_color.value ?? const Color(0xFFFF4300),
                  () {
                print("log your workout");
                wb_controller.userWorkoutId.value = "";
                wb_controller.showWorkout.value = true;
                wb_controller.dropdownValue1.value = null;
                wb_controller.workoutTypeId.value = "";
                wb_controller.workoutTypeName.value = "";
                wb_controller.tv_speed.value = "";
                wb_controller.workoutType = "";
                wb_controller.clearInputs();
              }, buttonHeight: 54),
            )
          ],
        ),
      ),
    );
  }

  Widget showWorkoutDetailList() {
    if (wb_controller.userWorkoutList.value.isEmpty) {
      return Center(
        child: Text(
          "No Items to Display",
          style: MyTextStyle.textStyle(
              FontWeight.w600, 18, MyColor.app_white_color),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: wb_controller.userWorkoutList.value.length,
      itemBuilder: (context, index) {
        var userWorkout = wb_controller.userWorkoutList.value[index];
        var level = userWorkout.effortLevel.toString() == "1"
            ? MyString.easy_var
            : userWorkout.effortLevel.toString() == "2"
                ? MyString.normal_var
                : MyString.hard_var;

        var coachComments = userWorkout.coachComments.toString() == "null"
            ? "N/A"
            : userWorkout.coachComments;

        var userWorkoutInfo = userWorkout.notes;

        if (userWorkoutInfo.contains("<p><br></p><p>") ||
            coachComments.contains("<p><br></p><p>")) {
          userWorkoutInfo = userWorkoutInfo.replaceAll("<p><br></p><p>", "");
          coachComments = coachComments.replaceAll("<p><br></p><p>", "");
        }
        if (userWorkoutInfo.contains("<p><br></p>") ||
            coachComments.contains("<p><br></p>")) {
          userWorkoutInfo = userWorkoutInfo.replaceAll("<p><br></p>", "");
          coachComments = coachComments.replaceAll("<p><br></p>", "");
        }
        if (userWorkoutInfo.contains("<p><br>") ||
            coachComments.contains("<p><br>")) {
          userWorkoutInfo = userWorkoutInfo.replaceAll("<p><br>", "");
          coachComments = coachComments.replaceAll("<p><br>", "");
        }
        return Card(
          color: MyColor.app_white_color,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          margin: const EdgeInsets.only(bottom: 10.0),
          elevation: 0,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                child: Text(
                  "${userWorkout.workoutType}",
                  style: MyTextStyle.textStyle(
                      FontWeight.w600, 19, MyColor.app_black_color,
                      letterSpacing: 0.2),
                ),
              ),
              Divider(
                color: MyColor.screen_bg,
                thickness: 1,
                height: 1.5,
              ),
              const SizedBox(height: 14),
              CustomView.differentStyleTextTogether(
                  MyString.effort_level_var,
                  FontWeight.w400,
                  " - $level",
                  FontWeight.w700,
                  20,
                  MyColor.app_black_color,
                  letterSpacing: 0.2),
              const SizedBox(height: 14),
              userWorkout.isDistance == "1"
                  ? Card(
                      elevation: 0.0,
                      color: MyColor.screen_bg,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text(
                                    MyString.dist_var,
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w700,
                                        17,
                                        MyColor.app_white_color,
                                        letterSpacing: 0.5),
                                  ),
                                  CustomView.differentStyleTextTogether(
                                      "${userWorkout.distance}",
                                      FontWeight.w700,
                                      "KM",
                                      FontWeight.w400,
                                      21,
                                      MyColor.app_white_color,
                                      letterSpacing: 0.5),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: showData(
                                  MyString.time_var, "${userWorkout.time}"),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: showData(
                                  MyString.pace_var, "${userWorkout.pace}"),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Divider(
                      color: MyColor.screen_bg,
                      thickness: 2,
                      height: 0,
                    ),
              userWorkout.notes != "null"
                  ? Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: const Color(0xFFEEEEEE),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 13, horizontal: 7),
                            child: CustomView.differentStyleTextTogether(
                                "${MyString.your_workout_var}".substring(4),
                                FontWeight.w400,
                                MyString.notes_var,
                                FontWeight.w700,
                                20,
                                MyColor.app_black_color,
                                letterSpacing: 0.2),
                          ),
                        ),
                        Divider(
                          color: MyColor.screen_bg,
                          thickness: 2,
                          height: 0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text(
                            "$userWorkoutInfo",
                            style: MyTextStyle.textStyle(
                              FontWeight.w500,
                              15,
                              MyColor.app_black_color,
                              lineHeight: 1.467,
                            ),
                          ),
                        )
                         /* Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: HtmlWidget(
                              '''<div style="text-align:start;">$userWorkoutInfo</div>''',
                              textStyle: MyTextStyle.textStyle(
                                FontWeight.w500,
                                15,
                                MyColor.app_black_color,
                                lineHeight: 1.467,
                              ),
                            ),
                          ),
                        ),*/
                      ],
                    )
                  : SizedBox(),
              Divider(
                color: MyColor.screen_bg,
                thickness: 1,
                height: 0,
              ),
              userWorkout.coachComments.toString() == "null"
                  ? const SizedBox()
                  : Column(
                      children: [
                        Container(
                          color: MyColor.ap_grey_color_text,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 13, horizontal: 7),
                            child: CustomView.differentStyleTextTogether(
                                "${MyString.your_coach} ",
                                FontWeight.w400,
                                MyString.your_comment,
                                FontWeight.w700,
                                20,
                                MyColor.app_black_color,
                                letterSpacing: 0.5),
                          ),
                        ),
                        Divider(
                          color: MyColor.screen_bg,
                          thickness: 1,
                          height: 0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text(
                            "$coachComments",
                            style: MyTextStyle.textStyle(
                              FontWeight.w500,
                              15,
                              MyColor.app_black_color,
                              lineHeight: 1.467,
                            ),
                          ),
                        )
                       /* Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 10),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: HtmlWidget(
                              "$coachComments",
                              textStyle: MyTextStyle.textStyle(
                                  FontWeight.w500, 15, MyColor.app_black_color,
                                  lineHeight: 1.467),
                            ),
                          ),
                        ),*/
                      ],
                    ),
              Divider(
                height: 1,
                color: MyColor.ap_grey_color_bg,
              ),
              Container(
                color: Colors.black.withOpacity(0.3),
                width: double.maxFinite,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    print("Edit workout");
                    print(userWorkout.id);
                    wb_controller.showWorkout.value = true;
                    wb_controller.typeOfClick.value = "Edit";
                    wb_controller.selectedWorkout.value = userWorkout.workoutType;
                    wb_controller.userWorkoutId.value = userWorkout.id;
                    wb_controller.workoutType = userWorkout.workoutType;
                    print(
                        "Edit checkbox :--${wb_controller.checkedValue.value}");
                    print("Distance selected :--${userWorkout.isDistance}");

                    if (userWorkout.isDistance.toString() == "1") {
                      wb_controller.checkedValue.value = true;
                      List<String> parts = userWorkout.time.split(':');

                      int hours = int.parse(parts[0]);
                      int minutes = int.parse(parts[1]);
                      int seconds = int.parse(parts[2]);
                      wb_controller.hours_controller.text = hours.toString();
                      wb_controller.minutes_controller.text =
                          minutes.toString();
                      wb_controller.second_controller.text = seconds.toString();
                      wb_controller.km_controller.text =
                          double.parse(userWorkout.distance).floor().toString();
                      // wb_controller.meter_controller.text = userWorkout.distance.toString().split(".")[1].toString();
                      var meter = double.parse(userWorkout.distance);

                      if (meter > 0.0) {
                        List<String> parts = userWorkout.distance.split(".");
                        if (parts.length > 1) {
                          wb_controller.meter_controller.text = parts[1];
                        } else {
                          wb_controller.meter_controller.text =
                              "0"; // No fractional part
                        }
                      } else {
                        print("Less than 0 $meter");
                      }

                      wb_controller.tv_speed.value = userWorkout.pace;
                    } else {
                      wb_controller.checkedValue.value = false;
                      wb_controller.clearInputs();
                    }

                    wb_controller.workoutTypeId.value =
                        userWorkout.workoutTypeId;
                    wb_controller.levelTypeNum.value = userWorkout.effortLevel;
                    wb_controller.note_controller.text =
                        userWorkout.notes != "null" ? userWorkout.notes : "";

                    // wb_controller.dropdownValue1.value = null;

                    print("edit levelTypeNum :-- ${wb_controller.levelTypeNum.value}");

                    /* showDialogBox(userWorkout.workoutType, "Edit", () {
                      wb_controller.clearInputs();
                      Get.back();
                    },
                            () {
                      if (wb_controller.dropdownValue1.value == null &&
                          userWorkout.workoutType.isEmpty) {
                        CustomView.showAlertDialogBox(
                            context, "Please select workout type");
                      } else if (wb_controller.checkedValue.value) {
                        if (wb_controller.km_controller.text.trim().isEmpty &&
                            wb_controller.meter_controller.text
                                .trim()
                                .isEmpty) {
                          CustomView.showAlertDialogBox(
                              context, "Please add distance");
                        } else if ((wb_controller.hours_controller.text
                                .trim()
                                .isEmpty &&
                            wb_controller.minutes_controller.text
                                .trim()
                                .isEmpty &&
                            wb_controller.second_controller.text
                                .trim()
                                .isEmpty)) {
                          CustomView.showAlertDialogBox(
                              context, "Please add time");
                        } else if ((wb_controller.tv_speed.value.isEmpty ||
                                wb_controller.tv_speed.value == "0:0" ||
                                wb_controller.tv_speed.value == "0:0/KM") &&
                            ((wb_controller.km_controller.text.trim().isEmpty &&
                                    wb_controller.meter_controller.text
                                        .trim()
                                        .isEmpty) ||
                                ((int.parse(wb_controller.km_controller.text
                                            .trim()
                                            .toString()) <=
                                        0 &&
                                    int.parse(wb_controller
                                            .meter_controller.text
                                            .trim()
                                            .toString()) <=
                                        0)))) {
                          CustomView.showAlertDialogBox(
                              context, "Please enter required fields");
                        } else {
                          editSave(userWorkout.id);
                        }
                      } else {
                        editSave(userWorkout.id);
                      }
                    }, workoutId: userWorkout.id);*/
                  },
                  child: Text(
                    MyString.edit_workout_var,
                    style: MyTextStyle.textStyle(
                        FontWeight.w500, 16.8, MyColor.app_black_color,
                        letterSpacing: 0.3),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Future<dynamic> showDialogBox(
  //     String selectedWorkout, typeOfClick, VoidCallback cancelClick, saveClick,
  //     {String? workoutId}) {
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return Padding(
  //           padding: const EdgeInsets.only(top: 50),
  //           child: Dialog(
  //             insetPadding: const EdgeInsets.symmetric(horizontal: 20),
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(5.0)), //this right here
  //             child: Container(
  //               decoration: BoxDecoration(
  //                   color: MyColor.app_white_color,
  //                   borderRadius: BorderRadius.circular(6.0)),
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     const SizedBox(height: 15.0),
  //                     CustomView.differentStyleTextTogether(
  //                         MyString.workout_type_work.toUpperCase() + " ",
  //                         FontWeight.w400,
  //                         MyString.workout_type_type.toUpperCase(),
  //                         FontWeight.w700,
  //                         19,
  //                         MyColor.app_black_color),
  //                     const SizedBox(
  //                       height: 10.0,
  //                     ),
  //                     Obx(
  //                       () => Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //                         child: dropDownSelectWidgetCenterOne(
  //                             context,
  //                             typeOfClick == "Edit" ? selectedWorkout : "",
  //                             wb_controller.dropdownValue1.value, (value) {
  //                           print("Select Value name:- ${value.name}");
  //                           print("Select Value Id:- ${value.id}");
  //                           wb_controller.dropdownValue1.value = value;
  //                           wb_controller.workoutTypeId.value = value.id;
  //                           wb_controller.workoutTypeName.value = value.name;
  //                         }, height: 55),
  //                       ),
  //                     ),
  //                     const SizedBox(
  //                       height: 20,
  //                     ),
  //                     Divider(
  //                       thickness: 1,
  //                       color: MyColor.app_black_color,
  //                     ),
  //                     const SizedBox(
  //                       height: 3,
  //                     ),
  //                     CustomView.differentStyleTextTogether(
  //                         "EFFORT ",
  //                         FontWeight.w400,
  //                         "LEVEL",
  //                         FontWeight.w700,
  //                         19,
  //                         MyColor.app_black_color),
  //                     effortLevelBoxCreateEdit(),
  //                     Divider(
  //                       thickness: 1,
  //                       color: MyColor.app_black_color,
  //                     ),
  //                     const SizedBox(
  //                       height: 10,
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Obx(
  //                           () => SizedBox(
  //                             height: 17,
  //                             width: 30,
  //                             child: Checkbox(
  //                               side: BorderSide(color: MyColor.screen_bg),
  //                               activeColor: MyColor.screen_bg,
  //                               shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(5)),
  //                               fillColor: MaterialStateProperty.all(
  //                                   wb_controller.checkedValue.value
  //                                       ? MyColor.app_orange_color.value ??
  //                                           const Color(0xFFFF4300)
  //                                       : MyColor.app_white_color),
  //                               checkColor: MyColor.app_white_color,
  //                               value: wb_controller.checkedValue.value,
  //                               onChanged: (newValue) {
  //                                 wb_controller.checkedValue.value = newValue!;
  //                               },
  //                             ),
  //                           ),
  //                         ),
  //                         Text(
  //                           MyString.distance_var.toUpperCase(),
  //                           style: MyTextStyle.textStyle(
  //                               FontWeight.bold, 17, MyColor.app_black_color),
  //                         ),
  //                       ],
  //                     ),
  //                     const SizedBox(
  //                       height: 18,
  //                     ),
  //                     Obx(
  //                       () => wb_controller.checkedValue.value == false
  //                           ? Container()
  //                           : Column(
  //                               children: [
  //                                 Padding(
  //                                   padding:
  //                                       const EdgeInsets.fromLTRB(70, 3, 80, 3),
  //                                   child: Row(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.center,
  //                                     children: [
  //                                       SizedBox(
  //                                         height: 55,
  //                                         width: 80,
  //                                         child: TextFormField(
  //                                           style: MyTextStyle.textStyle(
  //                                               FontWeight.w700,
  //                                               30,
  //                                               MyColor.app_black_color),
  //                                           controller:
  //                                               wb_controller.km_controller,
  //                                           textAlign: TextAlign.end,
  //                                           keyboardType: TextInputType.number,
  //                                           inputFormatters: [
  //                                             LengthLimitingTextInputFormatter(
  //                                                 2),
  //                                             FilteringTextInputFormatter
  //                                                 .digitsOnly,
  //                                           ],
  //                                           decoration: InputDecoration(
  //                                             filled: true,
  //                                             contentPadding:
  //                                                 const EdgeInsets.only(
  //                                                     bottom: 10, right: 10),
  //                                             fillColor:
  //                                                 MyColor.app_textform_bg_color,
  //                                             border: OutlineInputBorder(
  //                                               borderRadius: BorderRadius.circular(
  //                                                   4.4), // Set your desired radius
  //                                               borderSide: BorderSide
  //                                                   .none, // No border side to keep it clean
  //                                             ),
  //                                             hintText: "  0",
  //                                             hintStyle: MyTextStyle.textStyle(
  //                                                 FontWeight.w700,
  //                                                 30,
  //                                                 MyColor.app_hint_color),
  //                                           ),
  //                                           onTap: () {
  //                                             wb_controller.km_controller.text =
  //                                                 "";
  //                                           },
  //                                           onTapOutside: (e) {
  //                                             CommonFunction.keyboardHide(
  //                                                 context);
  //                                           },
  //                                           onChanged: (value) {
  //                                             if (wb_controller
  //                                                 .km_controller.text
  //                                                 .trim()
  //                                                 .isEmpty) {
  //                                               wb_controller
  //                                                   .km_controller.text = "00";
  //                                             }
  //                                             if (wb_controller
  //                                                 .meter_controller.text
  //                                                 .trim()
  //                                                 .isEmpty) {
  //                                               wb_controller.meter_controller
  //                                                   .text = "00";
  //                                             }
  //                                             if (wb_controller
  //                                                         .km_controller.text
  //                                                         .trim() !=
  //                                                     "00" ||
  //                                                 wb_controller
  //                                                         .meter_controller.text
  //                                                         .trim() !=
  //                                                     "00") {
  //                                               wb_controller
  //                                                   .speed_calculator();
  //                                             }
  //                                           },
  //                                         ),
  //                                       ),
  //                                       const SizedBox(
  //                                         width: 10,
  //                                       ),
  //                                       Text(
  //                                         ".",
  //                                         style: MyTextStyle.textStyle(
  //                                             FontWeight.w700,
  //                                             wb_controller.fontSize * 6,
  //                                             MyColor.app_black_color),
  //                                       ),
  //                                       const SizedBox(
  //                                         width: 10,
  //                                       ),
  //                                       SizedBox(
  //                                         height: 55,
  //                                         width: 55,
  //                                         child: TextFormField(
  //                                           controller:
  //                                               wb_controller.meter_controller,
  //                                           keyboardType: TextInputType.number,
  //                                           textAlign: TextAlign.center,
  //                                           style: MyTextStyle.textStyle(
  //                                               FontWeight.w700,
  //                                               30,
  //                                               MyColor.app_black_color),
  //                                           inputFormatters: [
  //                                             LengthLimitingTextInputFormatter(
  //                                                 2),
  //                                             FilteringTextInputFormatter
  //                                                 .digitsOnly,
  //                                           ],
  //                                           decoration: InputDecoration(
  //                                             filled: true,
  //                                             contentPadding:
  //                                                 const EdgeInsets.only(
  //                                                     bottom: 10),
  //                                             fillColor:
  //                                                 MyColor.app_textform_bg_color,
  //                                             border: OutlineInputBorder(
  //                                               borderRadius:
  //                                                   BorderRadius.circular(4.4),
  //                                               borderSide: BorderSide
  //                                                   .none, // No border side to keep it clean
  //                                             ),
  //                                             hintText: " 00",
  //                                             hintStyle: MyTextStyle.textStyle(
  //                                                 FontWeight.w700,
  //                                                 30,
  //                                                 MyColor.app_hint_color),
  //                                           ),
  //                                           onTap: () {
  //                                             wb_controller
  //                                                 .meter_controller.text = "";
  //                                           },
  //                                           onTapOutside: (e) {
  //                                             CommonFunction.keyboardHide(
  //                                                 context);
  //                                           },
  //                                           onChanged: (value) {
  //                                             if (wb_controller
  //                                                 .km_controller.text
  //                                                 .trim()
  //                                                 .isEmpty) {
  //                                               wb_controller
  //                                                   .km_controller.text = "00";
  //                                             }
  //                                             if (wb_controller
  //                                                 .meter_controller.text
  //                                                 .trim()
  //                                                 .isEmpty) {
  //                                               wb_controller.meter_controller
  //                                                   .text = "00";
  //                                             }
  //                                             if (wb_controller
  //                                                         .km_controller.text
  //                                                         .trim() !=
  //                                                     "00" ||
  //                                                 wb_controller
  //                                                         .meter_controller.text
  //                                                         .trim() !=
  //                                                     "00") {
  //                                               wb_controller
  //                                                   .speed_calculator();
  //                                             }
  //                                             // wb_controller.speed_calculator();
  //                                           },
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                                 const SizedBox(
  //                                   height: 18,
  //                                 ),
  //                                 Text(
  //                                   MyString.time_var.toUpperCase(),
  //                                   style: MyTextStyle.textStyle(
  //                                       FontWeight.w700,
  //                                       22,
  //                                       MyColor.app_black_color,
  //                                       lineHeight: 0.909),
  //                                 ),
  //                                 const SizedBox(
  //                                   height: 18,
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.symmetric(
  //                                       horizontal: 60.0),
  //                                   child: Row(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.spaceAround,
  //                                     children: [
  //                                       Expanded(
  //                                         flex: 1,
  //                                         child: Container(
  //                                           padding: const EdgeInsets.symmetric(
  //                                               vertical: 10),
  //                                           decoration: BoxDecoration(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(4.4),
  //                                             color:
  //                                                 MyColor.app_textform_bg_color,
  //                                           ),
  //                                           child: SizedBox(
  //                                             height: 68,
  //                                             child: Column(
  //                                               children: [
  //                                                 TextFormField(
  //                                                   controller: wb_controller
  //                                                       .hours_controller,
  //                                                   keyboardType:
  //                                                       TextInputType.number,
  //                                                   textAlign: TextAlign.center,
  //                                                   inputFormatters: [
  //                                                     LengthLimitingTextInputFormatter(
  //                                                         2),
  //                                                     FilteringTextInputFormatter
  //                                                         .digitsOnly,
  //                                                     _NumberLimitFormatter(24),
  //                                                   ],
  //                                                   style: MyTextStyle.textStyle(
  //                                                       FontWeight.w700,
  //                                                       30,
  //                                                       MyColor
  //                                                           .app_black_color),
  //                                                   decoration: InputDecoration(
  //                                                     filled: true,
  //                                                     fillColor:
  //                                                         Colors.transparent,
  //                                                     border:
  //                                                         OutlineInputBorder(
  //                                                       borderRadius:
  //                                                           BorderRadius
  //                                                               .circular(10),
  //                                                       borderSide: BorderSide
  //                                                           .none, // No border side to keep it clean
  //                                                     ),
  //                                                     contentPadding:
  //                                                         EdgeInsets.zero,
  //                                                     isDense: true,
  //                                                     hintText: "00",
  //                                                     hintStyle:
  //                                                         MyTextStyle.textStyle(
  //                                                             FontWeight.w700,
  //                                                             30,
  //                                                             MyColor
  //                                                                 .app_hint_color),
  //                                                   ),
  //                                                   onChanged: (value) {
  //                                                     if (wb_controller
  //                                                             .km_controller
  //                                                             .text
  //                                                             .trim()
  //                                                             .isEmpty ||
  //                                                         wb_controller
  //                                                                 .km_controller
  //                                                                 .text
  //                                                                 .trim() ==
  //                                                             "0") {
  //                                                       wb_controller
  //                                                           .km_controller
  //                                                           .text = "00";
  //                                                     }
  //                                                     if (wb_controller
  //                                                             .meter_controller
  //                                                             .text
  //                                                             .trim()
  //                                                             .isEmpty ||
  //                                                         wb_controller
  //                                                                 .meter_controller
  //                                                                 .text
  //                                                                 .trim() ==
  //                                                             "0") {
  //                                                       wb_controller
  //                                                           .meter_controller
  //                                                           .text = "00";
  //                                                     }
  //                                                     if (wb_controller
  //                                                                 .km_controller
  //                                                                 .text
  //                                                                 .trim() !=
  //                                                             "00" ||
  //                                                         wb_controller
  //                                                                 .meter_controller
  //                                                                 .text
  //                                                                 .trim() !=
  //                                                             "00") {
  //                                                       wb_controller
  //                                                           .speed_calculator();
  //                                                     }
  //                                                   },
  //                                                   onTapOutside: (e) {
  //                                                     CommonFunction
  //                                                         .keyboardHide(
  //                                                             context);
  //                                                   },
  //                                                 ),
  //                                                 Text(
  //                                                   MyString.hours_var,
  //                                                   style: MyTextStyle.textStyle(
  //                                                       FontWeight.w500,
  //                                                       15.4,
  //                                                       MyColor
  //                                                           .app_black_color),
  //                                                 )
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                       const SizedBox(
  //                                         width: 10,
  //                                       ),
  //                                       Text(
  //                                         ":",
  //                                         style: MyTextStyle.textStyle(
  //                                             FontWeight.w700,
  //                                             30,
  //                                             MyColor.app_black_color),
  //                                       ),
  //                                       const SizedBox(
  //                                         width: 10,
  //                                       ),
  //                                       Expanded(
  //                                         flex: 1,
  //                                         child: Container(
  //                                           decoration: BoxDecoration(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(4.4),
  //                                             color:
  //                                                 MyColor.app_textform_bg_color,
  //                                           ),
  //                                           padding: EdgeInsets.symmetric(
  //                                               vertical: 10),
  //                                           child: SizedBox(
  //                                             height: 68,
  //                                             child: Column(
  //                                               children: [
  //                                                 TextFormField(
  //                                                   controller: wb_controller
  //                                                       .minutes_controller,
  //                                                   keyboardType:
  //                                                       TextInputType.number,
  //                                                   textAlign: TextAlign.center,
  //                                                   style: MyTextStyle.textStyle(
  //                                                       FontWeight.w700,
  //                                                       30,
  //                                                       MyColor
  //                                                           .app_black_color),
  //                                                   inputFormatters: [
  //                                                     LengthLimitingTextInputFormatter(
  //                                                         2),
  //                                                     FilteringTextInputFormatter
  //                                                         .digitsOnly,
  //                                                     _NumberLimitFormatter(60),
  //                                                   ],
  //                                                   decoration: InputDecoration(
  //                                                     filled: true,
  //                                                     fillColor:
  //                                                         Colors.transparent,
  //                                                     border:
  //                                                         OutlineInputBorder(
  //                                                       borderRadius:
  //                                                           BorderRadius.circular(
  //                                                               4.4), // Set your desired radius
  //                                                       borderSide: BorderSide
  //                                                           .none, // No border side to keep it clean
  //                                                     ),
  //                                                     contentPadding:
  //                                                         EdgeInsets.zero,
  //                                                     hintText: "00",
  //                                                     isDense: true,
  //                                                     hintStyle:
  //                                                         MyTextStyle.textStyle(
  //                                                             FontWeight.w700,
  //                                                             30,
  //                                                             MyColor
  //                                                                 .app_hint_color),
  //                                                   ),
  //                                                   onChanged: (value) {
  //                                                     if (wb_controller
  //                                                             .km_controller
  //                                                             .text
  //                                                             .trim()
  //                                                             .isEmpty ||
  //                                                         wb_controller
  //                                                                 .km_controller
  //                                                                 .text
  //                                                                 .trim() ==
  //                                                             "0") {
  //                                                       wb_controller
  //                                                           .km_controller
  //                                                           .text = "00";
  //                                                     }
  //                                                     if (wb_controller
  //                                                             .meter_controller
  //                                                             .text
  //                                                             .trim()
  //                                                             .isEmpty ||
  //                                                         wb_controller
  //                                                                 .meter_controller
  //                                                                 .text
  //                                                                 .trim() ==
  //                                                             "0") {
  //                                                       wb_controller
  //                                                           .meter_controller
  //                                                           .text = "00";
  //                                                     }
  //                                                     if (wb_controller
  //                                                                 .km_controller
  //                                                                 .text
  //                                                                 .trim() !=
  //                                                             "00" ||
  //                                                         wb_controller
  //                                                                 .meter_controller
  //                                                                 .text
  //                                                                 .trim() !=
  //                                                             "00") {
  //                                                       wb_controller
  //                                                           .speed_calculator();
  //                                                     }
  //                                                   },
  //                                                   onTapOutside: (e) {
  //                                                     CommonFunction
  //                                                         .keyboardHide(
  //                                                             context);
  //                                                   },
  //                                                 ),
  //                                                 Text(
  //                                                   MyString.mins_var,
  //                                                   style: MyTextStyle.textStyle(
  //                                                       FontWeight.w500,
  //                                                       15.4,
  //                                                       MyColor
  //                                                           .app_black_color),
  //                                                 )
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                       const SizedBox(
  //                                         width: 10,
  //                                       ),
  //                                       Text(
  //                                         ":",
  //                                         style: MyTextStyle.textStyle(
  //                                             FontWeight.w700,
  //                                             30,
  //                                             MyColor.app_black_color),
  //                                       ),
  //                                       const SizedBox(
  //                                         width: 10,
  //                                       ),
  //                                       Expanded(
  //                                         flex: 1,
  //                                         child: Container(
  //                                           decoration: BoxDecoration(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(4.4),
  //                                             color:
  //                                                 MyColor.app_textform_bg_color,
  //                                           ),
  //                                           padding: const EdgeInsets.symmetric(
  //                                               vertical: 10),
  //                                           child: SizedBox(
  //                                             height: 68,
  //                                             child: Column(
  //                                               children: [
  //                                                 TextFormField(
  //                                                   style: MyTextStyle.textStyle(
  //                                                       FontWeight.w700,
  //                                                       30,
  //                                                       MyColor
  //                                                           .app_black_color),
  //                                                   controller: wb_controller
  //                                                       .second_controller,
  //                                                   keyboardType:
  //                                                       TextInputType.number,
  //                                                   textAlign: TextAlign.center,
  //                                                   onChanged: (value) {
  //                                                     if (wb_controller
  //                                                             .km_controller
  //                                                             .text
  //                                                             .trim()
  //                                                             .isEmpty ||
  //                                                         wb_controller
  //                                                                 .km_controller
  //                                                                 .text
  //                                                                 .trim() ==
  //                                                             "0") {
  //                                                       wb_controller
  //                                                           .km_controller
  //                                                           .text = "00";
  //                                                     }
  //                                                     if (wb_controller
  //                                                             .meter_controller
  //                                                             .text
  //                                                             .trim()
  //                                                             .isEmpty ||
  //                                                         wb_controller
  //                                                                 .meter_controller
  //                                                                 .text
  //                                                                 .trim() ==
  //                                                             "0") {
  //                                                       wb_controller
  //                                                           .meter_controller
  //                                                           .text = "00";
  //                                                     }
  //                                                     if (wb_controller
  //                                                                 .km_controller
  //                                                                 .text
  //                                                                 .trim() !=
  //                                                             "00" ||
  //                                                         wb_controller
  //                                                                 .meter_controller
  //                                                                 .text
  //                                                                 .trim() !=
  //                                                             "00") {
  //                                                       wb_controller
  //                                                           .speed_calculator();
  //                                                     }
  //                                                   },
  //                                                   inputFormatters: [
  //                                                     LengthLimitingTextInputFormatter(
  //                                                         2),
  //                                                     FilteringTextInputFormatter
  //                                                         .digitsOnly,
  //                                                     _NumberLimitFormatter(60),
  //                                                   ],
  //                                                   decoration: InputDecoration(
  //                                                     filled: true,
  //                                                     contentPadding:
  //                                                         EdgeInsets.zero,
  //                                                     isDense: true,
  //                                                     fillColor:
  //                                                         Colors.transparent,
  //                                                     border:
  //                                                         OutlineInputBorder(
  //                                                       borderRadius:
  //                                                           BorderRadius.circular(
  //                                                               4.4), // Set your desired radius
  //                                                       borderSide: BorderSide
  //                                                           .none, // No border side to keep it clean
  //                                                     ),
  //                                                     hintText: "00",
  //                                                     hintStyle:
  //                                                         MyTextStyle.textStyle(
  //                                                             FontWeight.w700,
  //                                                             30,
  //                                                             MyColor
  //                                                                 .app_hint_color),
  //                                                   ),
  //                                                   onTapOutside: (e) {
  //                                                     CommonFunction
  //                                                         .keyboardHide(
  //                                                             context);
  //                                                   },
  //                                                 ),
  //                                                 Text(
  //                                                   MyString.sec_var,
  //                                                   style: MyTextStyle.textStyle(
  //                                                       FontWeight.w500,
  //                                                       15.4,
  //                                                       MyColor
  //                                                           .app_black_color),
  //                                                 )
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                                 const SizedBox(
  //                                   height: 21,
  //                                 ),
  //                                 Obx(
  //                                   () => CustomView.differentStyleTextTogether(
  //                                       "${MyString.pace_var} : ",
  //                                       FontWeight.w700,
  //                                       "${wb_controller.tv_speed.value}",
  //                                       FontWeight.w700,
  //                                       21,
  //                                       MyColor.app_black_color),
  //                                 ),
  //                                 SizedBox(height: 10),
  //                                 GestureDetector(
  //                                   onTap: () {
  //                                     wb_controller.clearInputs();
  //                                   },
  //                                   child: Text(
  //                                     MyString.clear_input_var.toUpperCase(),
  //                                     textAlign: TextAlign.center,
  //                                     style: MyTextStyle.textStyle(
  //                                         FontWeight.w600,
  //                                         16,
  //                                         MyColor.screen_bg),
  //                                   ),
  //                                 ),
  //                                 SizedBox(height: 10),
  //                               ],
  //                             ),
  //                     ),
  //                     Divider(
  //                       thickness: 1,
  //                       color: MyColor.app_black_color,
  //                       height: 1,
  //                     ),
  //                     const SizedBox(
  //                       height: 16,
  //                     ),
  //                     CustomView.differentStyleTextTogether(
  //                         "${MyString.workout_type_var.substring(0, 7).toUpperCase()} ",
  //                         FontWeight.w400,
  //                         MyString.notes_var.toUpperCase(),
  //                         FontWeight.w700,
  //                         19,
  //                         MyColor.app_black_color),
  //                     const SizedBox(
  //                       height: 12,
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //                       child: SizedBox(
  //                         height: wb_controller.heightPerBox! * 20,
  //                         child: TextFormField(
  //                           controller: wb_controller.note_controller,
  //                           keyboardType: TextInputType.multiline,
  //                           maxLines: null,
  //                           expands: true,
  //                           inputFormatters: [
  //                             LengthLimitingTextInputFormatter(250),
  //                           ],
  //                           style: MyTextStyle.textStyle(
  //                               FontWeight.w600, 15, MyColor.app_black_color),
  //                           decoration: InputDecoration(
  //                             contentPadding: const EdgeInsets.all(8),
  //                             filled: true,
  //                             fillColor: MyColor.app_textform_bg_color,
  //                             border: InputBorder.none,
  //                             hintText: MyString.any_note_to_var,
  //                             hintStyle: MyTextStyle.textStyle(FontWeight.w600,
  //                                 15, MyColor.ap_grey_color_bg),
  //                           ),
  //                           onTapOutside: (e) {
  //                             FocusScope.of(context).requestFocus(FocusNode());
  //                           },
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(
  //                       height: 14,
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.symmetric(
  //                         horizontal: 20.0,
  //                       ),
  //                       child: Align(
  //                         alignment: Alignment.bottomCenter,
  //                         child: Row(
  //                           children: [
  //                             Expanded(
  //                                 flex: 1,
  //                                 child: CustomView.transparentButton(
  //                                     MyString.cancel_var,
  //                                     FontWeight.w500,
  //                                     wb_controller.widthPerBox!,
  //                                     16.0,
  //                                     Colors.grey.withOpacity(0.5),
  //                                     cancelClick,
  //                                     height: 41)),
  //                             const SizedBox(
  //                               width: 16,
  //                             ),
  //                             Expanded(
  //                               flex: 1,
  //                               child: CustomView.buttonShow(
  //                                   MyString.save_var,
  //                                   FontWeight.w500,
  //                                   wb_controller.widthPerBox!,
  //                                   16.0,
  //                                   MyColor.app_orange_color.value ??
  //                                       const Color(0xFFFF4300),
  //                                   saveClick,
  //                                   buttonHeight: 41),
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(
  //                       height: 21,
  //                     ),
  //                     typeOfClick == "Edit"
  //                         ? SizedBox(
  //                             width: double.infinity,
  //                             child: TextButton.icon(
  //                               icon: Image.asset(
  //                                 MyAssetsImage.app_delete_icon,
  //                                 color: MyColor.app_black_color,
  //                                 height: 15,
  //                                 width: 15,
  //                               ), // Your icon here
  //                               label: CustomView.differentStyleTextTogether(
  //                                   " Delete ",
  //                                   FontWeight.w400,
  //                                   "Workout",
  //                                   FontWeight.w700,
  //                                   16.8,
  //                                   MyColor.app_black_color), // Your text here
  //                               onPressed: () {
  //                                 // wb_controller.clearInputs();
  //                                 print("Workkout Id :-- $workoutId");
  //                                 wb_controller
  //                                     .deleteWorkout_Api(context, workoutId!)
  //                                     .then((value) {
  //                                   if (value != "") {
  //                                     userWorkoutList();
  //                                   }
  //                                 });
  //                                 Get.back();
  //                               },
  //                             ),
  //                           )
  //                         : const SizedBox(),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }
  showDialogBox(String selectedWorkout, VoidCallback cancelClick, saveClick,
      {String? workoutId}) {
    return Container(
      decoration: BoxDecoration(
          color: MyColor.app_white_color,
          borderRadius: BorderRadius.circular(6.0)),
      child:  SingleChildScrollView(physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 15.0),
            CustomView.differentStyleTextTogether(
                MyString.workout_type_work.toUpperCase() + " ",
                FontWeight.w400,
                MyString.workout_type_type.toUpperCase(),
                FontWeight.w700,
                19,
                MyColor.app_black_color),
            const SizedBox(
              height: 10.0,
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: dropDownSelectWidgetCenterOne(
                    context,
                    wb_controller.typeOfClick.value == "Edit"
                        ? wb_controller.selectedWorkout.value
                        : "",
                    wb_controller.dropdownValue1.value, (value) {
                  print("Select Value name:- ${value.name}");
                  print("Select Value Id:- ${value.id}");
                  wb_controller.dropdownValue1.value = value;
                  wb_controller.workoutTypeId.value = value.id;
                  wb_controller.workoutTypeName.value = value.name;
                  wb_controller.workoutType = value.name;
                }, height: 55),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Divider(
              thickness: 1,
              color: MyColor.app_black_color,
            ),
            const SizedBox(
              height: 3,
            ),
            CustomView.differentStyleTextTogether("EFFORT ", FontWeight.w400,
                "LEVEL", FontWeight.w700, 19, MyColor.app_black_color),
            effortLevelBoxCreateEdit(),
            Divider(
              thickness: 1,
              color: MyColor.app_black_color,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => SizedBox(
                    height: 17,
                    width: 30,
                    child: Checkbox(
                      side: BorderSide(color: MyColor.screen_bg),
                      activeColor: MyColor.screen_bg,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      fillColor: MaterialStateProperty.all(
                          wb_controller.checkedValue.value
                              ? MyColor.app_orange_color.value ??
                                  const Color(0xFFFF4300)
                              : MyColor.app_white_color),
                      checkColor: MyColor.app_white_color,
                      value: wb_controller.checkedValue.value,
                      onChanged: (newValue) {
                        wb_controller.checkedValue.value = newValue!;
                      },
                    ),
                  ),
                ),
                Text(
                  MyString.distance_var.toUpperCase(),
                  style: MyTextStyle.textStyle(
                      FontWeight.bold, 17, MyColor.app_black_color),
                ),
              ],
            ),
            const SizedBox(
              height: 18,
            ),
            Obx(
              () => wb_controller.checkedValue.value == false
                  ? Container()
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(70, 3, 80, 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 55,
                                width: 80,
                                child: TextFormField(
                                  style: MyTextStyle.textStyle(FontWeight.w700,
                                      30, MyColor.app_black_color),
                                  controller: wb_controller.km_controller,
                                  textAlign: TextAlign.end,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(3),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    filled: true,
                                    contentPadding: const EdgeInsets.only(
                                        bottom: 10, right: 10),
                                    fillColor: MyColor.app_textform_bg_color,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.4),
                                      borderSide: BorderSide
                                          .none, // No border side to keep it clean
                                    ),
                                    hintText: "  0",
                                    hintStyle: MyTextStyle.textStyle(
                                        FontWeight.w700,
                                        30,
                                        MyColor.app_hint_color),
                                  ),
                                  onTap: () {
                                    if((wb_controller.km_controller.text == "00") || (wb_controller.km_controller.text == "000")){
                                      wb_controller.km_controller.text = "";
                                    }
                                 //   wb_controller.km_controller.text = "";
                                  },
                                  onTapOutside: (e) {
                                    CommonFunction.keyboardHide(context);
                                  },
                                  onChanged: (value) {
                                    if (wb_controller.km_controller.text
                                        .trim()
                                        .isEmpty) {
                                      wb_controller.km_controller.text = "00";
                                    }
                                    if (wb_controller.meter_controller.text
                                        .trim()
                                        .isEmpty) {
                                      wb_controller.meter_controller.text =
                                          "00";
                                    }
                                    if (wb_controller.km_controller.text
                                                .trim() !=
                                            "00" ||
                                        wb_controller.meter_controller.text
                                                .trim() !=
                                            "00") {
                                      wb_controller.speed_calculator();
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                ".",
                                style: MyTextStyle.textStyle(
                                    FontWeight.w700,
                                    wb_controller.fontSize * 6,
                                    MyColor.app_black_color),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                height: 55,
                                width: 55,
                                child: TextFormField(
                                  controller: wb_controller.meter_controller,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: MyTextStyle.textStyle(FontWeight.w700,
                                      30, MyColor.app_black_color),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(2),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    filled: true,
                                    contentPadding:
                                        const EdgeInsets.only(bottom: 10),
                                    fillColor: MyColor.app_textform_bg_color,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.4),
                                      borderSide: BorderSide
                                          .none, // No border side to keep it clean
                                    ),
                                    hintText: " 00",
                                    hintStyle: MyTextStyle.textStyle(
                                        FontWeight.w700,
                                        30,
                                        MyColor.app_hint_color),
                                  ),
                                  onTap: () {
                                    wb_controller.meter_controller.text = "";
                                  },
                                  onTapOutside: (e) {
                                    CommonFunction.keyboardHide(context);
                                  },
                                  onChanged: (value) {
                                    if (wb_controller.km_controller.text
                                        .trim()
                                        .isEmpty) {
                                      wb_controller.km_controller.text = "00";
                                    }
                                    if (wb_controller.meter_controller.text
                                        .trim()
                                        .isEmpty) {
                                      wb_controller.meter_controller.text =
                                          "00";
                                    }
                                    if (wb_controller.km_controller.text
                                                .trim() !=
                                            "00" ||
                                        wb_controller.meter_controller.text
                                                .trim() !=
                                            "00") {
                                      wb_controller.speed_calculator();
                                    }
                                    // wb_controller.speed_calculator();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Text(
                          MyString.time_var.toUpperCase(),
                          style: MyTextStyle.textStyle(
                              FontWeight.w700, 22, MyColor.app_black_color,
                              lineHeight: 0.909),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 11),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.4),
                                    color: MyColor.app_textform_bg_color,
                                  ),
                                  child: SizedBox(
                                    height: 75,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller:
                                              wb_controller.hours_controller,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(3),
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            _NumberLimitFormatter(1000),
                                          ],
                                          style: MyTextStyle.textStyle(
                                              FontWeight.w700,
                                              30,
                                              MyColor.app_black_color),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide
                                                  .none, // No border side to keep it clean
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                            isDense: true,
                                            hintText: "00",
                                            hintStyle: MyTextStyle.textStyle(
                                                FontWeight.w700,
                                                30,
                                                MyColor.app_hint_color),
                                          ),
                                          onChanged: (value) {
                                            if (wb_controller.km_controller.text
                                                    .trim()
                                                    .isEmpty ||
                                                wb_controller.km_controller.text
                                                        .trim() ==
                                                    "0") {
                                              wb_controller.km_controller.text =
                                                  "00";
                                            }
                                            if (wb_controller
                                                    .meter_controller.text
                                                    .trim()
                                                    .isEmpty ||
                                                wb_controller
                                                        .meter_controller.text
                                                        .trim() ==
                                                    "0") {
                                              wb_controller
                                                  .meter_controller.text = "00";
                                            }
                                            if (wb_controller.km_controller.text
                                                        .trim() !=
                                                    "00" ||
                                                wb_controller
                                                        .meter_controller.text
                                                        .trim() !=
                                                    "00") {
                                              wb_controller.speed_calculator();
                                            }
                                          },
                                          onTapOutside: (e) {
                                            CommonFunction.keyboardHide(
                                                context);
                                          },
                                        ),
                                        Text(
                                          MyString.hours_var,
                                          style: MyTextStyle.textStyle(
                                              FontWeight.w500,
                                              15.4,
                                              MyColor.app_black_color),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                ":",
                                style: MyTextStyle.textStyle(FontWeight.w700,
                                    30, MyColor.app_black_color),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.4),
                                    color: MyColor.app_textform_bg_color,
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: SizedBox(
                                    height: 75,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller:
                                              wb_controller.minutes_controller,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          style: MyTextStyle.textStyle(
                                              FontWeight.w700,
                                              30,
                                              MyColor.app_black_color),
                                          inputFormatters: [
                                            // LengthLimitingTextInputFormatter(
                                            //     2),
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            _NumberLimitFormatter(60),
                                          ],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(
                                                  4.4), // Set your desired radius
                                              borderSide: BorderSide
                                                  .none, // No border side to keep it clean
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                            hintText: "00",
                                            isDense: true,
                                            hintStyle: MyTextStyle.textStyle(
                                                FontWeight.w700,
                                                30,
                                                MyColor.app_hint_color),
                                          ),
                                          onChanged: (value) {
                                            if (wb_controller.km_controller.text
                                                    .trim()
                                                    .isEmpty ||
                                                wb_controller.km_controller.text
                                                        .trim() ==
                                                    "0") {
                                              wb_controller.km_controller.text =
                                                  "00";
                                            }
                                            if (wb_controller
                                                    .meter_controller.text
                                                    .trim()
                                                    .isEmpty ||
                                                wb_controller
                                                        .meter_controller.text
                                                        .trim() ==
                                                    "0") {
                                              wb_controller
                                                  .meter_controller.text = "00";
                                            }
                                            if (wb_controller.km_controller.text
                                                        .trim() !=
                                                    "00" ||
                                                wb_controller
                                                        .meter_controller.text
                                                        .trim() !=
                                                    "00") {
                                              wb_controller.speed_calculator();
                                            }

                                            if (wb_controller.minutes_controller
                                                    .text.length ==
                                                1) {
                                              wb_controller
                                                      .minutes_controller.text =
                                                  "0${wb_controller.minutes_controller.text}";
                                            } else if (wb_controller
                                                    .minutes_controller
                                                    .text
                                                    .length >
                                                1) {
                                              wb_controller
                                                      .minutes_controller.text =
                                                  wb_controller
                                                      .minutes_controller.text
                                                      .substring(1);
                                            }
                                          },
                                          onTapOutside: (e) {
                                            CommonFunction.keyboardHide(
                                                context);
                                          },
                                        ),
                                        Text(
                                          MyString.mins_var,
                                          style: MyTextStyle.textStyle(
                                              FontWeight.w500,
                                              15.4,
                                              MyColor.app_black_color),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                ":",
                                style: MyTextStyle.textStyle(FontWeight.w700,
                                    30, MyColor.app_black_color),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.4),
                                    color: MyColor.app_textform_bg_color,
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: SizedBox(
                                    height: 75,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          style: MyTextStyle.textStyle(
                                              FontWeight.w700,
                                              30,
                                              MyColor.app_black_color),
                                          controller:
                                              wb_controller.second_controller,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          onChanged: (value) {
                                            if (wb_controller.km_controller.text
                                                    .trim()
                                                    .isEmpty ||
                                                wb_controller.km_controller.text
                                                        .trim() ==
                                                    "0") {
                                              wb_controller.km_controller.text =
                                                  "00";
                                            }
                                            if (wb_controller
                                                    .meter_controller.text
                                                    .trim()
                                                    .isEmpty ||
                                                wb_controller
                                                        .meter_controller.text
                                                        .trim() ==
                                                    "0") {
                                              wb_controller
                                                  .meter_controller.text = "00";
                                            }
                                            if (wb_controller.km_controller.text
                                                        .trim() !=
                                                    "00" ||
                                                wb_controller
                                                        .meter_controller.text
                                                        .trim() !=
                                                    "00") {
                                              wb_controller.speed_calculator();
                                            }

                                            if (wb_controller.second_controller
                                                    .text.length ==
                                                1) {
                                              wb_controller
                                                      .second_controller.text =
                                                  "0${wb_controller.second_controller.text}";
                                            } else if (wb_controller
                                                    .second_controller
                                                    .text
                                                    .length >
                                                1) {
                                              wb_controller
                                                      .second_controller.text =
                                                  wb_controller
                                                      .second_controller.text
                                                      .substring(1);
                                            }
                                          },
                                          inputFormatters: [
                                            // LengthLimitingTextInputFormatter(
                                            //     2),
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            _NumberLimitFormatter(60),
                                          ],
                                          decoration: InputDecoration(
                                            filled: true,
                                            contentPadding: EdgeInsets.zero,
                                            isDense: true,
                                            fillColor: Colors.transparent,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(
                                                  4.4), // Set your desired radius
                                              borderSide: BorderSide
                                                  .none, // No border side to keep it clean
                                            ),
                                            hintText: "00",
                                            hintStyle: MyTextStyle.textStyle(
                                                FontWeight.w700,
                                                30,
                                                MyColor.app_hint_color),
                                          ),
                                          onTapOutside: (e) {
                                            CommonFunction.keyboardHide(
                                                context);
                                          },
                                        ),
                                        Text(
                                          MyString.sec_var,
                                          style: MyTextStyle.textStyle(
                                              FontWeight.w500,
                                              15.4,
                                              MyColor.app_black_color),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 21,
                        ),
                        Obx(
                          () => CustomView.differentStyleTextTogether(
                              "${MyString.pace_var} : ",
                              FontWeight.w700,
                              "${wb_controller.tv_speed.value}",
                              FontWeight.w700,
                              21,
                              MyColor.app_black_color),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            print("clear_input");
                            wb_controller.hours_controller.clear();
                            wb_controller.minutes_controller.clear();
                            wb_controller.second_controller.clear();
                            wb_controller.km_controller.clear();
                            wb_controller.meter_controller.clear();
                            wb_controller.clearInputs();
                          },
                          child: Text(
                            MyString.clear_input_var.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: MyTextStyle.textStyle(
                                FontWeight.w600, 16, MyColor.screen_bg),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
            ),
            Divider(
              thickness: 1,
              color: MyColor.app_black_color,
              height: 1,
            ),
            const SizedBox(
              height: 16,
            ),
            CustomView.differentStyleTextTogether(
                "${MyString.workout_type_var.substring(0, 7).toUpperCase()} ",
                FontWeight.w400,
                MyString.notes_var.toUpperCase(),
                FontWeight.w700,
                19,
                MyColor.app_black_color),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                height: wb_controller.heightPerBox! * 20,
                child: TextFormField(
                  controller: wb_controller.note_controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  expands: true,
                  /* inputFormatters: [
                    LengthLimitingTextInputFormatter(250),
                  ],*/
                  style: MyTextStyle.textStyle(
                      FontWeight.w600, 15, MyColor.app_black_color),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8),
                    filled: true,
                    fillColor: MyColor.app_textform_bg_color,
                    border: InputBorder.none,
                    hintText: MyString.any_note_to_var,
                    hintStyle: MyTextStyle.textStyle(
                        FontWeight.w600, 15, MyColor.ap_grey_color_bg),
                  ),
                  onTapOutside: (e) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: CustomView.transparentButton(
                            MyString.cancel_var,
                            FontWeight.w500,
                            wb_controller.widthPerBox!,
                            16.0,
                            Colors.grey.withOpacity(0.5),
                            cancelClick,
                            height: 41)),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      flex: 1,
                      child: CustomView.buttonShow(
                          MyString.save_var,
                          FontWeight.w500,
                          wb_controller.widthPerBox!,
                          16.0,
                          MyColor.app_orange_color.value ??
                              const Color(0xFFFF4300),
                          saveClick,
                          buttonHeight: 41),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 21,
            ),
            wb_controller.typeOfClick.value == "Edit"
                ? SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      icon: Image.asset(
                        MyAssetsImage.app_delete_icon,
                        color: MyColor.app_black_color,
                        height: 15,
                        width: 15,
                      ), // Your icon here
                      label: CustomView.differentStyleTextTogether(
                          " Delete ",
                          FontWeight.w400,
                          "Workout",
                          FontWeight.w700,
                          16.8,
                          MyColor.app_black_color), // Your text here
                      onPressed: () {
                        print(
                            "Workkout Id :-- ${wb_controller.userWorkoutId.value}");
                        wb_controller
                            .deleteWorkout_Api(
                                context, wb_controller.userWorkoutId.value!)
                            .then((value) {
                          if (value != "") {
                            userWorkoutList();
                          }
                        });
                      },
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
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
                    wb_controller.fontSize * 3.5, MyColor.app_black_color),
                inputFormatters: inputFormatter,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "00",
                  hintStyle: MyTextStyle.textStyle(FontWeight.w700,
                      wb_controller.fontSize * 3.5, MyColor.app_black_color),
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
                wb_controller.fontSize * 2.5, MyColor.app_black_color),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<CalendarController>();
  }

  Widget dropDownSelectWidgetCenterOne(
      BuildContext context,
      String selectedWorkout,
      WorkoutType? dropdownValue1,
      Function(WorkoutType) onChangedCallback,
      {double? height}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        height: height != null ? 55 : 40,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 10, right: 15),
        decoration: BoxDecoration(
          color: MyColor.app_text_box_bg_color,
          border: Border.all(color: MyColor.app_text_box_bg_color, width: 0.0),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: DropdownButton(
          value: dropdownValue1,
          hint: Text(
            selectedWorkout == "" ? "Select" : selectedWorkout,
            style: MyTextStyle.textStyle(
                FontWeight.w600, 19, MyColor.app_black_color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          isExpanded: true,
          icon: Image.asset(
            MyAssetsImage.app_textField_dropdown,
            height: 15,
            width: 15,
          ),
          elevation: 16,
          style: TextStyle(
              color: MyColor.app_black_color,
              fontSize: 19,
              fontWeight: FontWeight.w600),
          alignment: Alignment.center,
          underline: Container(
            height: 2,
          ),
          items: wb_controller.workoutTypeList
              .map<DropdownMenuItem<WorkoutType>>(
                  (WorkoutType workoutTypeValue) {
            return DropdownMenuItem<WorkoutType>(
              value: workoutTypeValue,
              child: Text(
                workoutTypeValue.name.toString(),
                textAlign: TextAlign.start,
                maxLines: null,
                //overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (value) {
            onChangedCallback(value!);
          },
        ),
      ),
    );
  }

  void editSave(userWorkoutId) {
    var distance = "";
    var time = "";
    var convertPace = "";
    if (wb_controller.checkedValue.value) {
      print("km_controller :-- ${wb_controller.km_controller.text}");
       if (wb_controller.km_controller.text.isEmpty || wb_controller.km_controller.text.trim() == "00") {
        wb_controller.km_controller.text = "0";
      }
      distance =
          "${wb_controller.km_controller.text.trim()}.${wb_controller.meter_controller.text.trim()}";
      time =
          "${wb_controller.hours_controller.text.trim()}:${wb_controller.minutes_controller.text.trim().length <= 1 ? "0${wb_controller.minutes_controller.text.trim()}" : wb_controller.minutes_controller.text.trim()}:${wb_controller.second_controller.text.trim().length <= 1 ? "0${wb_controller.second_controller.text.trim()}" : wb_controller.second_controller.text.trim()}";
      var paceCal = wb_controller.timeValidation();

      print("paceCal $paceCal");

      var arr = paceCal.split(":");
      if (arr.length == 2) {
        if (arr[1].length == 1) {
          arr[1] = "0" + arr[1];
        }
        paceCal = arr[0] + ":" + arr[1];
      }
      convertPace = "$paceCal/KM";
    } else {
      distance = "";
      time = "";
      convertPace = "";
    }

    wb_controller.logbook_saveWorkout_api(
            userWorkoutId,
            wb_controller.workoutTypeId.value,
            wb_controller.levelTypeNum.value,
            DateFormat("yyyy-MM-dd").format(wb_controller.currentDate.value),
            wb_controller.checkedValue.value ? "1" : "0",
            distance,
            time,
            convertPace,
            wb_controller.note_controller.text.trim())
        .then((value) {
      if (value != "") {
        Get.back();
        userWorkoutList();
      }
    });
  }

  Future<dynamic> showDialogBoxNew(String headingFirstMSG, headingSecondMSG,
      mainMSG, typeOfClick, VoidCallback acceptClick, declineClick) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(20.0))), //this right here
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
                          icon: Image.asset(
                            MyAssetsImage.app_cancel_board,
                            width: 13,
                          )),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "${headingFirstMSG} ",
                        style: MyTextStyle.black_text_welcome_msg_style(
                            FontWeight.w500, 20),
                        children: <TextSpan>[
                          TextSpan(
                            text: headingSecondMSG,
                            style: MyTextStyle.black_text_welcome_msg_style(
                                FontWeight.w900, 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        mainMSG,
                        style: MyTextStyle.black_text_welcome_msg_style(
                            FontWeight.w500, 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                typeOfClick == MyString.accept_var ? 60 : 0),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: CustomView.transparentButton(
                                    typeOfClick == MyString.accept_var
                                        ? "DONE"
                                        : MyString.cancel_var,
                                    FontWeight.w500,
                                    60,
                                    16.8,
                                    Colors.grey.withOpacity(0.5),
                                    declineClick)),
                            const SizedBox(
                              width: 16,
                            ),
                            typeOfClick != MyString.accept_var
                                ? Expanded(
                                    flex: 1,
                                    child: CustomView.buttonShow(
                                        MyString.confirm_var,
                                        FontWeight.w500,
                                        wb_controller.widthPerBox!,
                                        16.8,
                                        MyColor.app_orange_color.value ??
                                            Color(0xFFFF4300),
                                        acceptClick),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void createWorkout(userWorkoutId) {
    var distance = "";
    var time = "";
    var convertPace = "";

    print("userWorkoutId : -- $userWorkoutId");
    print("km_controller :-- ${wb_controller.km_controller.text}");
    if (wb_controller.km_controller.text.isEmpty || wb_controller.km_controller.text.trim() == "00") {
      wb_controller.km_controller.text = "0";
    }
    if (wb_controller.hours_controller.text.isEmpty) {
      wb_controller.hours_controller.text = "00";
    }
    if (wb_controller.minutes_controller.text.isEmpty) {
      wb_controller.minutes_controller.text = "00";
    }
    if (wb_controller.second_controller.text.isEmpty) {
      wb_controller.second_controller.text = "00";
    }

    if (wb_controller.checkedValue.value) {
      distance =
          " ${wb_controller.km_controller.text.trim()}.${wb_controller.meter_controller.text.trim()}";
      time =
          "${wb_controller.hours_controller.text.trim()}:${wb_controller.minutes_controller.text.trim().length <= 1 ? "0${wb_controller.minutes_controller.text.trim()}" : wb_controller.minutes_controller.text.trim()}:${wb_controller.second_controller.text.trim().length <= 1 ? "0${wb_controller.second_controller.text.trim()}" : wb_controller.second_controller.text.trim()}";

      var pace = wb_controller.timeValidation();
      var arr = pace.split(":");
      if (arr.length == 2) {
        if (arr[1].length == 1) {
          arr[1] = "0" + arr[1];
        }
        pace = arr[0] + ":" + arr[1];
      }
      convertPace = "$pace/KM";
    } else {
      distance = "";
      time = "";
      convertPace = "";
    }
    wb_controller
        .logbook_saveWorkout_api(
            wb_controller.userWorkoutId.value,
            wb_controller.workoutTypeId.value,
            wb_controller.levelTypeNum.value,
            DateFormat("yyyy-MM-dd").format(wb_controller.currentDate.value),
            wb_controller.checkedValue.value ? "1" : "0",
            distance,
            time,
            convertPace,
            wb_controller.note_controller.text.trim())
        .then((value) {
      if (value != '') {
        wb_controller.clearInputs();
        userWorkoutList();
      }
    });
  }

  void userWorkoutList() {
    wb_controller
        .logbook_userWorkoutList_api(
            DateFormat("yyyy-MM-dd").format(wb_controller.currentDate.value))
        .then((value) {
      if (value != "") {
        print("value userWorkout :- $value");
        wb_controller.userWorkoutModel.value =
            logbookUserworkoutListModelFromJson(value);
        wb_controller.userWorkoutList.value =
            wb_controller.userWorkoutModel.value!.data;
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
      // Return old value if not a number or greater than limit
      return oldValue;
    }

    return newValue;
  }
}
