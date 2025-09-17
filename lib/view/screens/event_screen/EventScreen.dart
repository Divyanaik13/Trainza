import 'package:club_runner/controller/CalendarController.dart';
import 'package:club_runner/controller/EventScreenController.dart';
import 'package:club_runner/util/asstes_image/AssetsImage.dart';
import 'package:club_runner/util/custom_view/CustomView.dart';
import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:club_runner/util/text_style/MyTextStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../util/size_config/SizeConfig.dart';
import '../../../../util/string_const/MyString.dart';
import '../../../controller/EventDetailController.dart';
import '../../../controller/MainScreenController.dart';
import '../../../network/EndPointList.dart';
import '../../../util/FunctionConstant/FunctionConstant.dart';
import '../../../util/const_value/ConstValue.dart';
import '../../../util/local_storage/LocalStorage.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var screenWidth = SizeConfig.screenWidth;
  var fontSize = SizeConfig.fontSize();
  LocalStorage sp = LocalStorage();
  CalendarController controller = Get.put(CalendarController());
  ScrollController _scrollController = ScrollController();
  EventDetailsController eventDetailsController = EventDetailsController();
  var pageNo = 1;

  EventController eventcon = Get.put(EventController());
  MainScreenController msc = Get.find();

  final _selectedDay = DateTime.now().obs;
  final _focusedDay = DateTime.now().obs;

  bool openCalendar = false;

  void initState() {
    eventcon.EventList_API(pageNo, "");
    _scrollController.addListener(_scrollListener);
    super.initState();
    getDatesApi(_selectedDay.value, "1");
  }

  void _scrollListener() {
    if (_scrollController.offset.toInt() ==
        _scrollController.position.maxScrollExtent.toInt()) {
      if (eventcon.loadMore.value) {
        pageNo++;
        print("_scrollListener pageNo:- $pageNo");
        eventcon.EventList_API(pageNo, "");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: SingleChildScrollView(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 30),
                CustomView.customAppBarWithDrawer(
                  () {
                    ConstValue.isFromNotification = false;
                    ConstValue.isPopupShow = false;
                    msc.selectedTab.value = 0;
                  },
                  () {
                    _selectedDay.value = DateTime.now();
                    _focusedDay.value = DateTime.now();
                    ConstValue.isPopupShow = true;
                    print("eventDateTypeList :-- ${eventDetailsController.eventDateTypeList}");
                    getDatesApi(_focusedDay.value, "2").then((value){
                      openCalendar = true;
                      CommonFunction.showCalenderDialogBox(
                          context,
                          _focusedDay,
                          _selectedDay,
                          heightPerBox!,
                          fontSize,
                          widthPerBox,
                          eventDetailsController.eventDateTypeList,
                          controller: controller,
                          onClickLeftIcon: (newFocusedDay) {
                            print("on left click : $newFocusedDay");
                            getDatesApi(newFocusedDay, "1");
                          },
                          onClickRightIcon: (newFocusedDay) {
                        print("on right click : $newFocusedDay");
                        getDatesApi(newFocusedDay, "2");
                      }).then((date)
                      {
                        print("New Value:--  $date");
                        if (date != null) {
                          ConstValue.isPopupShow = false;
                          msc.dateSend.value = date;
                          msc.selectedTab.value = 5;
                        }
                      });
                    });

                   /* if(eventDetailsController.eventDateTypeList.isNotEmpty&&_selectedDay.value.month != eventDetailsController.eventDateTypeList[0].month){
                      print("_selectedDay month :-- ${_selectedDay.value.month}");
                      print("eventDateTypeList month :-- ${eventDetailsController.eventDateTypeList[0].month}");
                      getDatesApi(_focusedDay.value, "1").then((value){
                        openCalendar = true;
                        CommonFunction.showCalenderDialogBox(
                            context,
                            _focusedDay,
                            _selectedDay,
                            heightPerBox!,
                            fontSize,
                            widthPerBox,
                            eventDetailsController.eventDateTypeList,
                            controller: controller,
                            onClickLeftIcon: (newFocusedDay) {
                              print("on left click : $newFocusedDay");
                              getDatesApi(newFocusedDay, "1");
                            }, onClickRightIcon: (newFocusedDay) {
                          print("on right click : $newFocusedDay");
                          getDatesApi(newFocusedDay, "2");
                        }).then((date)
                        {
                          print("New Value:--  $date");
                          if (date != null) {
                            msc.dateSend.value = date;
                            msc.selectedTab.value = 5;
                          }
                        });
                      });
                    }
                    else{
                      print("else eventDateTypeList $_focusedDay $_selectedDay");
                      getDatesApi(_focusedDay.value, "1").then((value) {
                        openCalendar = true;
                        CommonFunction.showCalenderDialogBox(
                            context,
                            _focusedDay,
                            _selectedDay,
                            heightPerBox!,
                            fontSize,
                            widthPerBox,
                            eventDetailsController.eventDateTypeList,
                            controller: controller,
                            onClickLeftIcon: (newFocusedDay) {
                              print("on left click : $newFocusedDay");
                              getDatesApi(newFocusedDay, "1");
                            }, onClickRightIcon: (newFocusedDay) {
                          print("on right click : $newFocusedDay");
                          getDatesApi(newFocusedDay, "2");
                        }).then((date)
                        {
                          print("New Value:--  $date");
                          if (date != null) {
                            msc.dateSend.value = date;
                            msc.selectedTab.value = 5;
                          }
                        });
                      });
                    }*/
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 5),
                  width: screenWidth,
                  height: 40,
                  decoration: BoxDecoration(
                      color: MyColor.app_orange_color.value!,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    MyString.events_var,
                    style: MyTextStyle.textStyle(FontWeight.w900, 17,
                        MyColor.app_button_text_dynamic_color,
                        letterSpacing: 1.48),
                    textAlign: TextAlign.center,
                  ),
                ),
                showList(),
                eventcon.pageLoader.value
                    ? CircularProgressIndicator(
                        color: MyColor.app_orange_color.value,
                      )
                    : const SizedBox(),
                const SizedBox(height: 22),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: ((SizeConfig.screenWidth)! -
                            (SizeConfig.screenWidth! * 40 / 100)) /
                        1.62,
                    width: (SizeConfig.screenWidth)! -
                        (SizeConfig.screenWidth! * 40 / 100),
                    child:
                        LocalStorage.getStringValue(sp.currentClubData_logo) ==
                                ""
                            ? Image.asset(MyAssetsImage.app_trainza_ratioLogo,
                                fit: BoxFit.fill)
                            : Image.network(
                                LocalStorage.getStringValue(
                                    sp.currentClubData_logo),
                                fit: BoxFit.fill,),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget showList() {
    return eventcon.eventList.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Text(
              "No Items to Display",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.111,
                  color: MyColor.app_white_color),
            ),
          )
        : Obx(() => ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: eventcon.eventList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              var event = eventcon.eventList[index];
              var date;
              var day;

              if (event.startDate != null && event.startDate.isNotEmpty) {
                DateTime parsedDate = DateTime.parse(event.startDate);
                date = DateFormat('dd MMMM yyyy').format(parsedDate);
              } else {
                date = "";
              }

              if (event.repeatingDays == "null" ||
                  event.repeatingDays == "" ||
                  event.repeatingDays == null) {
                print("111222");
                day = "";
              } else {
                print("repeatingDays 123 ${event.repeatingDays}");
                day = eventcon.REPEATING_DAYS.firstWhere((element) =>
                    element['id'] == int.parse(event.repeatingDays))['day'];
              }

              print("arr id $day");

              return InkWell(
                onTap: () {
                  print(
                      "current day ${DateFormat('EEE').format(DateTime.now())}");
                  print("repeatingDays event ${event.repeatingDays}");

                  if (event.repeatingDays == "null" ||
                      event.repeatingDays == "" ||
                      event.repeatingDays == null) {
                    msc.dateSend.value = DateTime.parse(event.startDate);
                    msc.eventId.value = event.id;
                    msc.selectedTab.value = 5;
                  }
                  else {
                    var arr = eventcon.REPEATING_DAYS
                        .where((day) => day['day'] == DateFormat('EEE').format(DateTime.now()))
                        .toList();

                    print("arr 123 $arr ${DateFormat('EEE').format(DateTime.now())}");

                    if (arr.length > 0) {
                      var obj = arr[0];
                      var abc = int.parse(event.repeatingDays);
                      var ab = obj['id'] as int;
                      var difrc = abc - ab;
                      if (difrc >= 0) {
                      } else {
                        difrc = 7 - (- difrc);
                      }
                      var date = DateTime(DateTime.now().year,
                          DateTime.now().month, (DateTime.now().day) + difrc);
                      msc.dateSend.value = date;
                      msc.eventId.value = event.id;
                      msc.selectedTab.value = 5;
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.only(top: 14),
                  decoration: BoxDecoration(
                      color: MyColor.app_white_color,
                      border: Border.all(color: const Color(0xFFB4B4B4)),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: Container(
                              padding: event.eventImg
                                  .contains(WebServices.club_url)
                                  ? EdgeInsets.all(4)
                                  : EdgeInsets.zero,
                              color: Color(0xFF3F3F3F),
                              height: 100,
                              width: 100,
                              child: Image.network(
                                event.eventImg,
                                fit: BoxFit.contain,
                              ),
                            )),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                maxLines: 3,
                                style: MyTextStyle.textStyle(FontWeight.w600,
                                    16, MyColor.app_black_color,
                                    letterSpacing: -0.3),
                                overflow:TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                date,
                                style: MyTextStyle.textStyle(FontWeight.w600,
                                    13, MyColor.app_text_dynamic_color,
                                    letterSpacing: -0.3),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  Future<void> getDatesApi(DateTime currentDate, String direction) async {
    var month = DateFormat('MM').format(currentDate).toString();
    var year = DateFormat('yyyy').format(currentDate).toString();

    if (month.length > 1 && month[0] == "0") {
      month = month[1].toString();
    }
    print("Date month :-- $month/$year");

    eventDetailsController.eventAvailableDate(month, year, direction, (dateResponse) {})
        .then((response) {

          if(eventDetailsController.eventDateList.isNotEmpty){
            eventDetailsController.eventDateTypeList.clear();
            for (var dateString in eventDetailsController.eventDateList) {
              DateTime originalDate = DateTime.parse(dateString);
              int year = originalDate.year;
              int month = originalDate.month;
              int day = originalDate.day;
              eventDetailsController.eventDateTypeList.add(DateTime(year, month, day));
            }
            eventDetailsController.eventDateTypeList.refresh();

            if(eventDetailsController.eventDateTypeList.isNotEmpty){
              _focusedDay.value = eventDetailsController.eventDateTypeList[0];
              _selectedDay.value = eventDetailsController.eventDateTypeList[0];
            }

            if (openCalendar) {
              ConstValue.isPopupShow = false;
              Get.back();
              CommonFunction.showCalenderDialogBox(
                  context,
                  _focusedDay,
                  _selectedDay,
                  heightPerBox!,
                  fontSize,
                  widthPerBox,
                  eventDetailsController.eventDateTypeList.value,
                  controller: controller, onClickLeftIcon: (newFocusedDay) {
                getDatesApi(newFocusedDay, "1");
              }, onClickRightIcon: (newFocusedDay) {
                getDatesApi(newFocusedDay, "2");
              }).then((date) {
                print("New Value:--  $date");

                if (date != null) {
                  msc.dateSend.value = date;
                  msc.selectedTab.value = 5;
                }
              });
              /* if (eventDetailsController.eventDateTypeList.isNotEmpty) {
          CommonFunction.showCalenderDialogBox(
              context,
              _focusedDay,
              _selectedDay,
              heightPerBox!,
              fontSize,
              widthPerBox,
              eventDetailsController.eventDateTypeList.value,
              controller: controller, onClickLeftIcon: (newFocusedDay) {
            getDatesApi(newFocusedDay, "1");
          }, onClickRightIcon: (newFocusedDay) {
            getDatesApi(newFocusedDay, "2");
          }).then((date) {
            print("New Value:--  $date");

            if (date != null) {
              msc.dateSend.value = date;
              msc.selectedTab.value = 5;
            }
          });
        }*/
            }
          }else{
            Get.back();
            if (ConstValue.isPopupShow){
              if(direction == "2"){
                getDatesApi(_focusedDay.value, "1").then((value){
                  openCalendar = true;
                  ConstValue.isPopupShow = true;
                  CommonFunction.showCalenderDialogBox(
                      context,
                      _focusedDay,
                      _selectedDay,
                      heightPerBox!,
                      fontSize,
                      widthPerBox,
                      eventDetailsController.eventDateTypeList,
                      controller: controller,
                      onClickLeftIcon: (newFocusedDay) {
                        print("on left click : $newFocusedDay");
                        getDatesApi(newFocusedDay, "1");
                      }, onClickRightIcon: (newFocusedDay) {
                    print("on right click : $newFocusedDay");
                    getDatesApi(newFocusedDay, "2");
                  }).then((date)
                  {
                    print("New Value:--  $date");
                    if (date != null) {
                      ConstValue.isPopupShow = false;
                      msc.dateSend.value = date;
                      msc.selectedTab.value = 5;
                    }
                  });
                });
              }
              else{
                ConstValue.isPopupShow = false;
                CommonFunction.showAlertDialogdelete(context, "No Items to display", () {Get.back();});
              }
            }
          }

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<CalendarController>();
  }
}
