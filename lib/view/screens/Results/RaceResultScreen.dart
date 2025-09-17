import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:club_runner/controller/RaceResultScreenController.dart';
import 'package:club_runner/util/asstes_image/AssetsImage.dart';
import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:club_runner/util/route_helper/RouteHelper.dart';
import 'package:club_runner/util/text_style/MyTextStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../controller/CalendarController.dart';
import '../../../util/custom_view/CustomView.dart';
import '../../../util/string_const/MyString.dart';

class RaceResultScreen extends StatefulWidget {
  const RaceResultScreen({super.key});

  @override
  State<RaceResultScreen> createState() => _RaceResultScreenState();
}

class _RaceResultScreenState extends State<RaceResultScreen> {
  RaceResultScreenController rr_controller = Get.put(RaceResultScreenController());

  CalendarController controller = Get.put(CalendarController());

  var now = new DateTime.now();
  var Monthformatter = new DateFormat('M');
  var Yearformatter = new DateFormat('yyyy');


  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    // String month = Monthformatter.format(now);
    // String year = Yearformatter.format(now);
    print("current month ${rr_controller.focusedDay.value.month}");
      rr_controller.resultEventsDistanceData_API(rr_controller.focusedDay.value.month.toString(),rr_controller.focusedDay.value.year.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        color: MyColor.screen_bg,
        child: SafeArea(
          child: Scaffold(
            body:  SingleChildScrollView(physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  CustomView.customAppBar("${MyString.race_var.toUpperCase()} ",
                      MyString.result_var.toUpperCase(), () {
                    Get.back(result: "refresh");
                  }),
                  SizedBox(
                    height: 40,
                  ),

                  // rr_controller.eventDates.isNotEmpty?
                  calenderShow(),
                      // :SizedBox(),
                  SizedBox(
                    height: 29,
                  ),
                  eventListShow(),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            //  bottomNavigationBar: const BottomNavigationBarWidget(),
          ),
        ),
      );
    });
  }

  Widget calenderShow() {
    return Container(
      decoration: BoxDecoration(
          color: MyColor.app_white_color,
          borderRadius: BorderRadius.circular(5.0)),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => TableCalendar(
            availableGestures: AvailableGestures.none,
            firstDay: DateTime.utc(0000, 00, 00),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: rr_controller.focusedDay.value,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              rightChevronPadding: EdgeInsets.zero,
              leftChevronPadding: EdgeInsets.zero,
              leftChevronMargin: EdgeInsets.zero,
              rightChevronMargin: EdgeInsets.zero,
              leftChevronIcon: InkWell(
                onTap: (){
                  final newFocusedDay = DateTime(rr_controller.focusedDay.value.year, rr_controller.focusedDay.value.month - 1);
                  rr_controller.focusedDay.value = newFocusedDay;
                  print("focused day ${rr_controller.focusedDay.value.month}");
                  rr_controller.resultEventsDistanceData_API(rr_controller.focusedDay.value.month.toString(),rr_controller.focusedDay.value.year.toString());
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(8, 8, 10, 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyColor.app_orange_color.value ?? Color(0xFFFF4300)),
                  child: Image.asset(
                    MyAssetsImage.app_PreviousIcon,
                    height: 15.5,
                    width: 15.5,
                  ),
                ),
              ),
              rightChevronIcon: InkWell(
                onTap: (){
                  final newFocusedDay = DateTime(rr_controller.focusedDay.value.year, rr_controller.focusedDay.value.month + 1);
                  rr_controller.focusedDay.value = newFocusedDay;
                  print("focused day ${rr_controller.focusedDay.value.month}");
                  rr_controller.resultEventsDistanceData_API(rr_controller.focusedDay.value.month.toString(),rr_controller.focusedDay.value.year.toString());
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(10, 8, 8, 8),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyColor.app_orange_color.value ?? Color(0xFFFF4300)),
                  child: Image.asset(
                    MyAssetsImage.app_arrow_white,
                    height: 15.5,
                    width: 15.5,
                  ),
                ),
              ),
              titleTextStyle: MyTextStyle.textStyle(
                FontWeight.w700,
                20,
                MyColor.app_black_color,
              )!,
              titleTextFormatter: (date, locale) =>
                  DateFormat.yMMMM(locale).format(date).toUpperCase(),
            ),
            startingDayOfWeek: StartingDayOfWeek.monday,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: MyTextStyle.textStyle(
                  FontWeight.w600, 15, MyColor.app_black_color,
                  lineHeight: 0.912)!,
              weekendStyle: MyTextStyle.textStyle(
                  FontWeight.w600, 15, MyColor.app_black_color,
                  lineHeight: 0.912)!,
            ),
            selectedDayPredicate: (day) {
              return isSameDay(rr_controller.selectedDay.value, day);
            },
            //OnTap of particular date
            onDaySelected: (selectedDay, focusedDay) {
              rr_controller.focusedDay.value = focusedDay;
              if (rr_controller.isDayDisabled(selectedDay)) {
                rr_controller.selectedDay.value = selectedDay;
              }
              log("_selectedDay2 :-- ${rr_controller.selectedDay.value}");
              rr_controller.getResultData(rr_controller.selectedDay.value);
              controller.updateText(rr_controller.selectedDay);
            },
            calendarStyle: CalendarStyle(
              cellMargin: EdgeInsets.symmetric(horizontal: 1, vertical: 7),
              selectedDecoration: BoxDecoration(
                color: MyColor.app_orange_color.value ?? Color(0xFFFF4300),
                shape: BoxShape.rectangle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                final text = DateFormat.E().format(day).toUpperCase();
                return Center(
                  child: Text(
                    text,
                    style: MyTextStyle.textStyle(
                        FontWeight.w600, 15, MyColor.app_black_color,
                        lineHeight: 0.912),
                  ),
                );
              },
              todayBuilder: (context, day, focusedDay) {
                for (DateTime d in rr_controller.eventDates) {
                  if (day.day == d.day &&
                      day.month == d.month &&
                      day.year == d.year) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 1, vertical: 7),
                      decoration: BoxDecoration(
                        color: MyColor.app_grey_color,
                        borderRadius: BorderRadius.zero,
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: MyColor.app_black_color,
                          ),
                        ),
                      ),
                    );
                  }
                }
                return null;
              },
              defaultBuilder: (context, day, focusedDay) {
                for (DateTime d in rr_controller.eventDates.value) {
                  if (day.day == d.day &&
                      day.month == d.month &&
                      day.year == d.year) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 1, vertical: 7),
                      decoration: BoxDecoration(
                        color: MyColor.app_grey_color,
                        borderRadius: BorderRadius.zero,
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: MyColor.app_black_color,
                          ),
                        ),
                      ),
                    );
                  }
                }
                return null;
              },
            ),
          ),),
          Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Changed to spaceBetween for better alignment
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    rr_controller.selectedDay.value = DateTime.utc(
                      rr_controller.selectedDay.value.year,
                      rr_controller.selectedDay.value.month,
                      rr_controller.selectedDay.value.day - 1,
                    );
                    rr_controller.selectedDay.refresh();
                    rr_controller.focusedDay.refresh();
                    controller.updateText(rr_controller.selectedDay);
                    print("Calendar -1 selectedDay  ${rr_controller.selectedDay.value}");
                    print("Calendar -1 focusedDay  ${rr_controller.focusedDay.value}");

                    if(rr_controller.selectedDay.value.month != rr_controller.focusedDay.value.month){
                      rr_controller.resultEventsDistanceData_API(rr_controller.selectedDay.value.month.toString(),rr_controller.selectedDay.value.year.toString());
                    }
                    rr_controller.focusedDay.value = rr_controller.selectedDay.value ;
                  },
                  child: Card(
                    elevation: 0.0,
                    color: Color(0xFFEEEEEE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back_ios_new,
                            color: MyColor.app_black_color,
                            size: 18,
                          ),
                          SizedBox(width: 9),
                          Image.asset(
                            MyAssetsImage.app_calendar_mius,
                            color: MyColor.app_black_color,
                            width: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Card(
                  elevation: 0.0,
                  color: MyColor.app_orange_color.value ?? Color(0xFFFF4300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      controller.message.value.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: MyTextStyle.textStyle(
                          FontWeight.w700, 18, MyColor.app_white_color,
                          letterSpacing: 0.59),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    rr_controller.selectedDay.value = DateTime.utc(
                      rr_controller.selectedDay.value.year,
                      rr_controller.selectedDay.value.month,
                      rr_controller.selectedDay.value.day + 1,
                    );
                    controller.updateText(rr_controller.selectedDay);
                    rr_controller.selectedDay.refresh();
                    rr_controller.focusedDay.refresh();
                    print("Calendar +1 ");
                    if(rr_controller.selectedDay.value.month != rr_controller.focusedDay.value.month){
                      rr_controller.resultEventsDistanceData_API(rr_controller.selectedDay.value.month.toString(),rr_controller.selectedDay.value.year.toString());
                    }
                    rr_controller.focusedDay.value = rr_controller.selectedDay.value;
                  },
                  child: Card(
                    elevation: 0.0,
                    color: Color(0xFFEEEEEE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            MyAssetsImage.app_calendar_plus,
                            color: MyColor.app_black_color,
                            width: 25,
                          ),
                          SizedBox(width: 9),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: MyColor.app_black_color,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              Get.back(result: rr_controller.selectedDay.value);
            },
            child: Text(
              "CLOSE",
              style: MyTextStyle.textStyle(
                FontWeight.w700,
                14,
                MyColor.app_black_color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget eventListShow() {
    return rr_controller.eventDistanceData.value.isEmpty
        ? Text("No Items to Display",
            style: MyTextStyle.textStyle(FontWeight.w600,
                rr_controller.fontSize * 4, MyColor.app_white_color))
        : Column(
            children: [
              Text("Select Event",
                  style: MyTextStyle.textStyle(
                      FontWeight.w600, 18, MyColor.app_white_color)),
              SizedBox(
                height: rr_controller.heightPerBox!,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rr_controller.eventDistanceData.length,
                  itemBuilder: (context, index) {
                    var eventList = rr_controller.eventDistanceData.value[index];
                    return InkWell(
                      onTap: () async{
                        var data = {
                          "eventName": eventList.eventName.toString(),
                          "eventDate": eventList.eventDate.toString(),
                          "eventId": eventList.id.toString(),
                          "distance": jsonEncode(eventList.distances)
                        };
                      var value = await  Get.toNamed(RouteHelper.getEditRaceEventScreen(),parameters: data);

                      print("value : $value");
                      if(value != null){
                        Get.back(result: "refresh");
                      }
                      },
                      child: Card(
                        color:
                            MyColor.app_orange_color.value ?? Color(0xFFFF4300),
                        margin: EdgeInsets.only(top: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                eventList.eventName,
                                style: MyTextStyle.textStyle(FontWeight.w700,
                                    14, MyColor.app_white_color,
                                    lineHeight: 1.429),
                              ),
                              const SizedBox(
                                height: 1,
                              ),
                              CustomView.differentStyleTextTogether(
                                  DateFormat('EE').format(eventList.eventDate),
                                  FontWeight.w700,
                                  DateFormat(' d MMM yyyy').format(eventList.eventDate),
                                  FontWeight.w300,
                                  14,
                                  MyColor.app_white_color,
                                  lineHeight: 1.429),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          );
  }
}
