import 'dart:convert';
import 'dart:developer';

import 'package:club_runner/models/ResultListModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../models/ResultEventsDistanceData_Model.dart';
import '../network/DioServices.dart';
import '../network/EndPointList.dart';
import '../util/FunctionConstant/FunctionConstant.dart';
import '../util/my_color/MyColor.dart';
import '../util/size_config/SizeConfig.dart';

class RaceResultScreenController extends GetxController {
  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var screenWidth = SizeConfig.screenWidth;
  var fontSize = SizeConfig.fontSize();
  final selectedDay = DateTime.now().obs;
  final focusedDay = DateTime.now().obs;

  var message = "Today".obs;
  var eventDistanceDataModel = Rxn<ResultEventsDistanceDataModel>();
  var eventDistanceData = <EventsDistanceList>[].obs;
  // New list to store event dates
  var eventDates = <DateTime>[].obs;

  final List<DateTime> toHighlight = [
    DateTime(2024, 04, 01),
    DateTime(2024, 04, 26),
    DateTime(2024, 04, 13),
    DateTime(2024, 05, 30),
  ];

  List<Map<String, String>> demoMap = [
    {
      "heading": "EDENVALE MARATHON 2024",
      "date": "SUN 05 NOV 2024",
    },
    {
      "heading": "MARATHON RUN",
      "date": "SUN 05 NOV 2024",
    },
    {
      "heading": "MARATHON WALK",
      "date": "SUN 05 NOV 2024",
    },
  ];

  bool isDayDisabled(DateTime day) {
    print("focused month ${focusedDay.value.month.toString()}");
    if (day.month == focusedDay.value.month) {
      return true;
    }
    return false;
  }

  Future<void> showYearPickerDialog(
      BuildContext context, DateTime value, focusedDay, selectedDay) async {
    final DateTime? pickedYear = await showDatePicker(
      context: context,
      initialDate: focusedDay.value,
      firstDate: DateTime.utc(0000),
      lastDate: DateTime.utc(2030, 3, 14),
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                  brightness: Brightness.light,
                  primary: MyColor.app_orange_color.value ?? Color(0xFFFF4300)),
              datePickerTheme: DatePickerThemeData(
                headerBackgroundColor:
                    MyColor.app_orange_color.value ?? Color(0xFFFF4300),
                headerForegroundColor: MyColor.app_white_color,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero),
              )),
          child: child!,
        );
      },
    );

    if (pickedYear != null && pickedYear != focusedDay) {
      focusedDay = pickedYear;
      selectedDay = pickedYear;
    }
  }

  Future<void> resultEventsDistanceData_API(String month, String year) async {
    CommonFunction.showLoader();
    print("Headers:-- ${DioServices.getAllHeaders()}");

    try {
      var url =
          WebServices.resultEventsDistanceData + "?month=$month&year=$year";
      print("Request URL:-- $url");
      var response =
          await DioServices.getMethod(url, DioServices.getAllHeaders());
      print("Result EventsDistanceData Response :-- ${response.data}");
      CommonFunction.hideLoader();
      //  pageLoader.value =false;
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode EventsDistanceData:- $statusCode");
      print("data EventsDistanceData:-${jsonEncode(data)}");

      if (response.statusCode == 200) {
        eventDistanceDataModel.value =
            resultEventsDistanceDataModelFromJson(jsonEncode(data));
        //eventDistanceData.value = eventDistanceDataModel.value!.eventsDistanceData;

        print("eventDistanceData List :-- ${eventDistanceData.value}");

        // Extract event dates from eventDistanceData
        for (var event in eventDistanceDataModel.value!.eventsDistanceData) {
          if (!eventDates.contains(event.eventDate)) {
            print("Date eventDate :- ${event.eventDate}");
            eventDates.add(event.eventDate);
          }

          eventDates.refresh();
        }
        print("Current Date ${DateTime.now()}");
        //create it as  function
    /*    if (eventDates.contains(DateTime.now())) {
          for (var event in eventDistanceDataModel.value!.eventsDistanceData) {
            if (DateTime.now() == event.eventDate) {
              eventDistanceData.add(event);

              print("eventDistanceData 123 ${eventDistanceData.value}");
            }
            eventDistanceData.refresh();
          }
        }*/

        DateTime now = DateTime.now();
        getResultData(now);

        print("Event Dates: $eventDates");
        eventDistanceDataModel.refresh();
        eventDistanceData.refresh();
        eventDates.refresh();
      }
    } catch (e) {
      CommonFunction.hideLoader();
      // pageLoader.value =false;
      log("Exception :-- ", error: e.toString());
    }
  }

  void getResultData(DateTime selectedDate){
    eventDistanceData.clear();
    DateTime today = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    if (eventDates.any((date) => DateTime(date.year, date.month, date.day) == today)) {
      for (var event in eventDistanceDataModel.value!.eventsDistanceData) {
        DateTime eventDate = DateTime(event.eventDate.year, event.eventDate.month, event.eventDate.day);
        if (eventDate == today) {
          eventDistanceData.add(event);

          print("eventDistanceData 123 ${jsonEncode(eventDistanceData.value)}");
        }
        eventDistanceData.refresh();
      }
    }
  }
}
