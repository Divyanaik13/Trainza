import 'dart:convert';
import 'dart:ffi';
import 'package:club_runner/util/FunctionConstant/FunctionConstant.dart';
import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:club_runner/util/string_const/MyString.dart';
import 'package:club_runner/util/text_style/MyTextStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../util/asstes_image/AssetsImage.dart';
import '../../../../util/custom_view/CustomView.dart';
import '../../../../util/size_config/SizeConfig.dart';
import '../../../controller/CalendarController.dart';
import '../../../controller/EventDetailController.dart';
import '../../../controller/EventScreenController.dart';
import '../../../controller/MainScreenController.dart';
import '../../../models/EventDetail(Date)_Model.dart';
import '../../../service/NotificationServices.dart';
import '../../../util/const_value/ConstValue.dart';
import '../../../util/local_storage/LocalStorage.dart';
import '../../../util/route_helper/RouteHelper.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var screenWidth = SizeConfig.screenWidth;
  var fontSize = SizeConfig.fontSize();
  LocalStorage sp = LocalStorage();

  EventDetailsController controller = Get.put(EventDetailsController());
  EventController eventcon = Get.put(EventController());
  CalendarController calendarController = Get.put(CalendarController());
  MainScreenController msc = Get.find();
  var month = "", year = "", direction = "1";
  bool openCalendar = false, isSwipe = false;
  var currentIndex = 0.obs;
  var showCurrentDate = false.obs;

  @override
  void initState() {
    super.initState();
    print("initState event detail");
    WidgetsFlutterBinding.ensureInitialized();
    currentIndex.value = -1;
    Future.delayed(Duration.zero, () async {
      print("Date :-- ${msc.dateSend.value}");
    });
    Future.delayed(Duration.zero, () async {
      getDatesApi(controller.currentDate.value, "1", false);
    });
    Future.delayed(Duration.zero, () async {
      if ((NotificationService.notificationPayloadModel?.date != '') &&
          (NotificationService.notificationPayloadModel?.notificationType ==
              "event")) {
        //  msc.eventId.value = NotificationService.notificationPayloadModel!.referenceId;
        callEventDetailAndMange(
            DateTime.parse(NotificationService.notificationPayloadModel!.date));
        print("dateSend notify ${msc.eventId.value}");
        controller.currentDate.value =
            DateTime.parse(NotificationService.notificationPayloadModel!.date);
        controller.selectedDay.value =
            DateTime.parse(NotificationService.notificationPayloadModel!.date);
        controller.focusedDay.value =
            DateTime.parse(NotificationService.notificationPayloadModel!.date);
        controller.dateData.clear();
        if (ConstValue.isFromNotification) {
          //ConstValue.isFromNotification = false;
        }
      } else if (msc.dateSend.value != null) {
        callEventDetailAndMange(msc.dateSend.value!);
        print("dateSend else if ${msc.dateSend.value}");
        controller.currentDate.value = msc.dateSend.value!;
        controller.selectedDay.value = msc.dateSend.value!;
        controller.focusedDay.value = msc.dateSend.value!;
        controller.dateData.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 0) {
          //right swipe
          print("right CR swipe");
          if (findFirstPreviousDate(controller.currentDate.value) != null) {
            controller.currentDate.value =
                findFirstPreviousDate(controller.currentDate.value)!;
            callEventDetailAndMange(controller.currentDate.value);
          } else {
            openCalendar = false;
            var dateValue = DateTime(controller.currentDate.value.year,
                controller.currentDate.value.month - 1);
            Future.delayed(Duration.zero, () async {
              getDatesApi(dateValue, "1", true);
            });
          }
        } else if (details.primaryVelocity! < 0) {
          //Left Swipe
          print("left swipe ${controller.currentDate.value}");
          var crDate = DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
              .format(controller.currentDate.value);
          print("crDate $crDate");
          if (findNextDate(
                  DateFormat('yyyy-MM-dd HH:mm:ss.SSS').parse(crDate)) !=
              null) {
            print("findNextDate if ");
            controller.currentDate.value =
                findNextDate(controller.currentDate.value)!;
            callEventDetailAndMange(controller.currentDate.value);
          } else {
            print("Here 123 ${controller.currentDate.value.month}");
            openCalendar = false;
            var dateValue = DateTime(controller.currentDate.value.year,
                controller.currentDate.value.month + 1);
            Future.delayed(Duration.zero, () async {
              getDatesApi(dateValue, "2", true);
            });
          }
        }
      },
      child: Container(
        color: MyColor.screen_bg,
        child: SafeArea(child: Obx(() {
          return Scaffold(
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  CustomView.customAppBarWithDrawer(
                    () {
                      ConstValue.isFromNotification = false;
                      ConstValue.isCalendarDisable = false;
                      ConstValue.isPopupShow = false;
                      msc.selectedTab.value = 0;
                      NotificationService.notificationPayloadModel = null;
                      //  Get.offAllNamed(RouteHelper.mainScreen);
                    },
                    () {
                      ConstValue.isCalendarDisable = false;
                      showCurrentDate.value = true;
                      NotificationService.notificationPayloadModel = null;
                      ConstValue.isPopupShow = true;
                      controller.tempCurrentDate.value = controller.currentDate.value;
                      getDatesApi(controller.currentDate.value, "2", false)
                          .then((value) {

                        var focusedDay = Rx<DateTime>(DateTime(
                            controller.currentDate.value.year,
                            controller.currentDate.value.month,
                            controller.currentDate.value.day));
                        var selectedDay = Rx<DateTime>(DateTime(
                            controller.currentDate.value.year,
                            controller.currentDate.value.month,
                            controller.currentDate.value.day));

                        openCalendar = true;
                        CommonFunction.showCalenderDialogBox(
                            context,
                            selectedDay,
                            selectedDay,
                            heightPerBox!,
                            fontSize,
                            widthPerBox,
                            controller.eventDateTypeList.value,
                            controller: calendarController,
                            onClickLeftIcon: (newFocusedDay) {
                              print("on left click : $newFocusedDay");
                              Future.delayed(Duration.zero, () async {
                                getDatesApi(newFocusedDay, "1", false);
                              });
                            }, onClickRightIcon: (newFocusedDay) {
                          print("on right click : $newFocusedDay");
                          Future.delayed(Duration.zero, () async {
                            getDatesApi(newFocusedDay, "2", false);
                          });
                        }).then((value) {
                          ConstValue.isPopupShow = false;
                          print("New Value else :--  $value");
                          if (value != null) {
                            controller.currentDate.value = value;
                            callEventDetailAndMange(controller.currentDate.value);
                          } else {
                            print("focusedDay :--  ${controller.focusedDay}");
                            controller.focusedDay = focusedDay;
                            controller.selectedDay = selectedDay;
                          }
                        });
                      });
                     /* if (controller.eventDateTypeList.isNotEmpty && controller.currentDate.value.month != controller.eventDateTypeList[0].month)
                      {
                        print("if event date list");
                        Future.delayed(Duration.zero, () async {
                          getDatesApi(controller.currentDate.value, "2", false)
                              .then((value) {
                            ConstValue.isPopupShow = false;
                            var focusedDay = Rx<DateTime>(DateTime(
                                controller.currentDate.value.year,
                                controller.currentDate.value.month,
                                controller.currentDate.value.day));
                            var selectedDay = Rx<DateTime>(DateTime(
                                controller.currentDate.value.year,
                                controller.currentDate.value.month,
                                controller.currentDate.value.day));

                            openCalendar = true;
                            CommonFunction.showCalenderDialogBox(
                                context,
                                selectedDay,
                                selectedDay,
                                heightPerBox!,
                                fontSize,
                                widthPerBox,
                                controller.eventDateTypeList.value,
                                controller: calendarController,
                                onClickLeftIcon: (newFocusedDay) {
                              print("on left click : $newFocusedDay");
                              Future.delayed(Duration.zero, () async {
                                getDatesApi(newFocusedDay, "1", false);
                              });
                            }, onClickRightIcon: (newFocusedDay) {
                              print("on right click : $newFocusedDay");

                              Future.delayed(Duration.zero, () async {
                                getDatesApi(newFocusedDay, "2", false);
                              });
                            }).then((value) {
                              print("New Value:--  $value");
                              if (value != null) {
                                controller.currentDate.value = value;
                                callEventDetailAndMange(
                                    controller.currentDate.value);
                              } else {
                                controller.focusedDay = focusedDay;
                                controller.selectedDay = selectedDay;
                              }
                            });
                          });
                        });
                      }
                      else {
                        print("else event date list ${controller.currentDate.value}");
                        controller.tempCurrentDate.value = controller.currentDate.value;
                        getDatesApi(controller.currentDate.value, "2", false)
                            .then((value) {
                          ConstValue.isPopupShow = false;
                          var focusedDay = Rx<DateTime>(DateTime(
                              controller.currentDate.value.year,
                              controller.currentDate.value.month,
                              controller.currentDate.value.day));
                          var selectedDay = Rx<DateTime>(DateTime(
                              controller.currentDate.value.year,
                              controller.currentDate.value.month,
                              controller.currentDate.value.day));

                          openCalendar = true;
                          CommonFunction.showCalenderDialogBox(
                              context,
                              selectedDay,
                              selectedDay,
                              heightPerBox!,
                              fontSize,
                              widthPerBox,
                              controller.eventDateTypeList.value,
                              controller: calendarController,
                              onClickLeftIcon: (newFocusedDay) {
                            print("on left click : $newFocusedDay");
                            Future.delayed(Duration.zero, () async {
                              getDatesApi(newFocusedDay, "1", false);
                            });
                          }, onClickRightIcon: (newFocusedDay) {
                            print("on right click : $newFocusedDay");
                            Future.delayed(Duration.zero, () async {
                              getDatesApi(newFocusedDay, "2", false);
                            });
                          }).then((value) {
                            print("New Value else :--  $value");
                            if (value != null) {
                              controller.currentDate.value = value;
                              callEventDetailAndMange(controller.currentDate.value);
                            } else {
                              print("focusedDay :--  ${controller.focusedDay}");
                              controller.focusedDay = focusedDay;
                              controller.selectedDay = selectedDay;
                            }
                          });
                        });
                      }*/
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomView.cardViewDateClick(
                    MyString.events_var,
                    controller.currentDate,
                    MyColor.app_orange_color.value ?? const Color(0xFFFF4300),
                    () {
                      print("right Click ");
                      if (findFirstPreviousDate(controller.currentDate.value) !=
                          null) {
                        controller.currentDate.value = findFirstPreviousDate(
                            controller.currentDate.value)!;
                        callEventDetailAndMange(controller.currentDate.value);
                      } else {
                        openCalendar = false;

                        var dateValue = DateTime(
                            controller.currentDate.value.year,
                            controller.currentDate.value.month - 1);
                        Future.delayed(Duration.zero, () async {
                          getDatesApi(dateValue, "1", true);
                        });
                      }
                    },
                    () {
                      print("left Click");
                      if (findNextDate(controller.currentDate.value) != null) {
                        controller.currentDate.value =
                            findNextDate(controller.currentDate.value)!;
                        callEventDetailAndMange(controller.currentDate.value);
                      } else {
                        print("Here 345 ${controller.currentDate.value.month}");
                        openCalendar = false;
                        var dateValue = DateTime(
                            controller.currentDate.value.year,
                            controller.currentDate.value.month + 1);
                        Future.delayed(Duration.zero, () async {
                          getDatesApi(dateValue, "2", true);
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  controller.dateData.value.isEmpty
                      ? Text("No Items to Display",
                          style: MyTextStyle.textStyle(
                              FontWeight.w500, 20, MyColor.app_white_color))
                      : Obx(
                          () => ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.dateData.value.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                var info = controller.dateData.value[index];
                                var eventStartDate;
                                var startdate;
                                var enddate;
                                String startTime = "";
                                var eventEndDate;
                                String endTime = "";
                                String repeatingTime = "";
                                TextEditingController hcon =
                                    TextEditingController();
                                TextEditingController mcon =
                                    TextEditingController();
                                TextEditingController scon =
                                    TextEditingController();

                                if (info.eventInfo.dateType != 3) {
                                  eventStartDate = DateFormat('dd MMMM yyyy')
                                      .format(DateTime.parse(
                                          info.eventInfo.eventStartDate));
                                  startdate = DateFormat('EEE ').format(
                                      DateTime.parse(
                                          info.eventInfo.eventStartDate));
                                  DateTime dateTime = DateFormat("HH:mm:ss")
                                      .parse(
                                          info.eventInfo.startTime.toString());
                                  startTime =
                                      DateFormat("HH:mm").format(dateTime);
                                  if (info.eventInfo.dateType == 2) {
                                    DateTime enddateTime =
                                        DateFormat("HH:mm:ss").parse(
                                            info.eventInfo.endTime.toString());
                                    endTime =
                                        DateFormat("HH:mm").format(enddateTime);
                                    eventEndDate = DateFormat('dd MMMM yyyy')
                                        .format(DateTime.parse(
                                            info.eventInfo.eventEndDate));
                                    enddate = DateFormat('EEE ').format(
                                        DateTime.parse(
                                            info.eventInfo.eventEndDate));
                                  } else {
                                    endTime = "";
                                    enddate = "";
                                    eventEndDate = "";
                                  }
                                } else {
                                  // eventStartDate = "";
                                  eventStartDate = DateFormat('dd MMMM yyyy')
                                      .format(DateTime.parse(controller
                                          .currentDate.value
                                          .toString()));
                                  startdate = DateFormat('EEE ').format(
                                      DateTime.parse(controller
                                          .currentDate.value
                                          .toString()));
                                  startTime = "";
                                  endTime = "";
                                  enddate = "";
                                  eventEndDate = "";
                                  DateTime dateTime = DateFormat("HH:mm:ss")
                                      .parse(info.eventInfo.repeatingTime
                                          .toString());
                                  repeatingTime =
                                      DateFormat("HH:mm").format(dateTime);
                                }

                                print("startTime :-- $startTime");
                                print(
                                    "Button :-- ${info.eventInfo.isButtonAdded}");
                                var result = info.eventResults.result;
                                print("result 22 " + result.toString());

                                if (result != "") {
                                  List<String> splitResult =
                                      info.eventResults.result!.split(':');

                                  print("splitResult $splitResult");
                                  hcon.text =
                                      int.parse(splitResult[0]).toString();
                                  mcon.text = splitResult[1].toString();
                                  scon.text = splitResult[2].toString();

                                  print("hours_controller 2 ${hcon.text}");
                                  print("min_controller ${mcon.text}");
                                  print("sec_controller ${scon.text}");
                                } else {
                                  hcon.text = "";
                                  mcon.text = "";
                                  scon.text = "";

                                  print("hours_controller else ${hcon.text}");
                                  print("min_controller else ${mcon.text}");
                                  print("sec_controller else ${scon.text}");
                                }

                                var eventInfo = info.eventInfo.eventInfo;

                                if (eventInfo.contains("<p><br></p><p>")) {
                                  eventInfo = eventInfo.replaceAll(
                                      "<p><br></p><p>", "");
                                }
                                if (eventInfo.contains("<p><br></p>")) {
                                  eventInfo =
                                      eventInfo.replaceAll("<p><br></p>", "");
                                }
                                if (eventInfo.contains("<p><br>")) {
                                  eventInfo =
                                      eventInfo.replaceAll("<p><br>", "");
                                }

                                print(
                                    "eventInfo Id :-- ${controller.dateData.value[index].eventInfo.id}");

                                return Column(
                                  children: [
                                    Card(
                                      elevation: 0.0,
                                      margin: EdgeInsets.zero,
                                      color: MyColor.app_white_color,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(info.eventInfo.title,
                                                style: MyTextStyle.textStyle(
                                                    FontWeight.w600,
                                                    22,
                                                    MyColor.app_black_color,
                                                    letterSpacing: -0.37)),
                                            info.eventInfo.image == null
                                                ? const SizedBox(height: 0)
                                                : const SizedBox(height: 15),
                                            info.eventInfo.image == null
                                                ? const SizedBox()
                                                : InkWell(
                                                    onTap: () {
                                                      List<String> imageArray =
                                                          [];
                                                      imageArray.add(info
                                                          .eventInfo
                                                          .originalImage!);
                                                      Get.toNamed(
                                                          RouteHelper
                                                              .getFullScreenImagePreview(),
                                                          arguments: {
                                                            'images':
                                                                imageArray,
                                                            'initialIndex':
                                                                index,
                                                          });
                                                    },
                                                    child: AspectRatio(
                                                      aspectRatio: 1.0 / 1.0,
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          child: FadeInImage
                                                              .assetNetwork(
                                                            placeholder:
                                                                MyAssetsImage
                                                                    .app_loader,
                                                            image: info
                                                                .eventInfo.image
                                                                .toString(),
                                                            fit: BoxFit.cover,
                                                            height:
                                                                heightPerBox! *
                                                                    42,
                                                            imageErrorBuilder: (context,
                                                                    error,
                                                                    stackTrace) =>
                                                                Image.asset(
                                                                    MyAssetsImage
                                                                        .app_squanreImage,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    height:
                                                                        heightPerBox! *
                                                                            42),
                                                          )),
                                                    ),
                                                  ),
                                            const SizedBox(height: 5),
                                            info.eventGallery.isNotEmpty
                                                ? GridView.builder(
                                                    padding: EdgeInsets.zero,
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 4,
                                                      crossAxisSpacing: 5.0,
                                                      mainAxisSpacing: 5.0,
                                                    ),
                                                    itemCount: info
                                                        .eventGallery.length,
                                                    primary: false,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int Gindex) {
                                                      return InkWell(
                                                        onTap: () {
                                                          List<String>
                                                              imageArray = [];
                                                          for (var value in info
                                                              .eventGallery) {
                                                            imageArray.add(
                                                                value.image);
                                                          }
                                                          Get.toNamed(
                                                              RouteHelper
                                                                  .getFullScreenImagePreview(),
                                                              arguments: {
                                                                'images':
                                                                    imageArray,
                                                                'initialIndex':
                                                                    Gindex,
                                                              });
                                                        },
                                                        child: AspectRatio(
                                                          aspectRatio:
                                                              1.0 / 1.0,
                                                          child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              child: FadeInImage
                                                                  .assetNetwork(
                                                                placeholder:
                                                                    MyAssetsImage
                                                                        .app_loader,
                                                                image: info
                                                                    .eventGallery[
                                                                Gindex]
                                                                    .thumb_image==""? info
                                                                    .eventGallery[
                                                                        Gindex]
                                                                    .image:info
                                                                    .eventGallery[
                                                                Gindex]
                                                                    .thumb_image,
                                                                fit: BoxFit
                                                                    .cover,
                                                                height:
                                                                    heightPerBox! *
                                                                        42,
                                                                imageCacheHeight: 150, //adding these two parameters
                                                                imageCacheWidth: 150,
                                                                imageErrorBuilder: (context,
                                                                        error,
                                                                        stackTrace) =>
                                                                    Image.asset(
                                                                        MyAssetsImage
                                                                            .app_squanreImage,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        height: heightPerBox! *
                                                                            42),
                                                              )),
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : Container(),
                                            info.eventGallery.isNotEmpty
                                                ? const SizedBox(height: 20)
                                                : const SizedBox(height: 0),
                                            HtmlWidget(
                                              '''$eventInfo''',
                                              textStyle: MyTextStyle.textStyle(
                                                  FontWeight.w400,
                                                  16,
                                                  MyColor.app_black_color,
                                                  lineHeight: 1.5),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            controller.showBoxData(
                                              MyString.start_var,
                                              Column(
                                                children: [
                                                  CustomView
                                                      .differentStyleTextTogether(
                                                          startdate,
                                                          FontWeight.w300,
                                                          eventStartDate,
                                                          FontWeight.w600,
                                                          18,
                                                          MyColor
                                                              .app_black_color),
                                                  Text(
                                                      info.eventInfo.dateType ==
                                                              3
                                                          ? repeatingTime
                                                          : startTime,
                                                      style: MyTextStyle.textStyle(
                                                          FontWeight.w600,
                                                          18,
                                                          MyColor
                                                              .app_black_color))
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            info.eventInfo.dateType == 2
                                                ? controller.showBoxData(
                                                    MyString.finish_var,
                                                    Column(
                                                      children: [
                                                        CustomView
                                                            .differentStyleTextTogether(
                                                                enddate,
                                                                FontWeight.w300,
                                                                eventEndDate,
                                                                FontWeight.w600,
                                                                18,
                                                                MyColor
                                                                    .app_black_color),
                                                        Text(
                                                            info.eventInfo
                                                                        .dateType ==
                                                                    3
                                                                ? repeatingTime
                                                                : endTime,
                                                            style: MyTextStyle
                                                                .textStyle(
                                                                    FontWeight
                                                                        .w600,
                                                                    18,
                                                                    MyColor
                                                                        .app_black_color))
                                                      ],
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            SizedBox(
                                              height:
                                                  info.eventInfo.dateType == 2
                                                      ? 10
                                                      : 0,
                                            ),
                                            // controller.showBoxData(
                                            //   MyString.time_space_var,
                                            //   Text(
                                            //     info.eventInfo.dateType==3?repeatingTime:startTime,
                                            //       style: MyTextStyle.textStyle(
                                            //           FontWeight.w600,
                                            //           18,
                                            //           MyColor.app_black_color)),
                                            // ),
                                            // const SizedBox(
                                            //   height: 10,
                                            // ),
                                            (info.eventInfo.locationName !=
                                                        "" ||
                                                    info.eventInfo
                                                            .googleAddress !=
                                                        "")
                                                ? controller.showBoxData(
                                                    MyString.venue_var,
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20.0),
                                                      child: Column(
                                                        children: [
                                                          info.eventInfo
                                                                      .locationName !=
                                                                  ""
                                                              ? Text(
                                                                  info.eventInfo
                                                                      .locationName
                                                                      .toString(),
                                                                  style: MyTextStyle.textStyle(
                                                                      FontWeight
                                                                          .w600,
                                                                      18,
                                                                      MyColor
                                                                          .app_black_color),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center)
                                                              : const SizedBox(),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          info.eventInfo
                                                                      .googleAddress !=
                                                                  ""
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    CommonFunction.openMap(
                                                                        info.eventInfo
                                                                            .latitude,
                                                                        info.eventInfo
                                                                            .longitude);
                                                                  },
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Image
                                                                          .asset(
                                                                        MyAssetsImage
                                                                            .app_location_icon,
                                                                        width:
                                                                            11,
                                                                        height:
                                                                            14,
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              5),
                                                                      Text(
                                                                          MyString
                                                                              .view_location_var,
                                                                          style: MyTextStyle.textStyle(
                                                                              FontWeight.w600,
                                                                              11,
                                                                              MyColor.app_black_color),
                                                                          textAlign: TextAlign.center)
                                                                    ],
                                                                  ),
                                                                )
                                                              : const SizedBox(),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            info.eventInfo.isButtonAdded == 1
                                                ? CustomView.buttonShow(
                                                    info.eventInfo.buttonLable,
                                                    FontWeight.w600,
                                                    4,
                                                    19.2,
                                                    MyColor.app_orange_color
                                                            .value ??
                                                        const Color(0xFFFF4300),
                                                    () {
                                                      _launchUrl(info.eventInfo
                                                          .buttonLink);
                                                    },
                                                    // buttonHeight: 54,
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    ),
                                    info.eventInfo.distances.isNotEmpty
                                        ? submitResultCard(
                                            context,
                                            index,
                                            controller.currentDate.value,
                                            hcon,
                                            mcon,
                                            scon)
                                        : const SizedBox(),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: info.eventResultList.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (BuildContext context,
                                            int outerindex) {
                                          var eventresults =
                                              info.eventResultList[outerindex];
                                          var unit =
                                              eventresults.distanceUnit == 1
                                                  ? "KM"
                                                  : "MI";
                                          var genderCategory = eventresults
                                                      .genderCategory ==
                                                  3
                                              ? "- MEN - WOMEN"
                                              : eventresults.genderCategory == 2
                                                  ? "- WOMEN"
                                                  : eventresults
                                                              .genderCategory ==
                                                          1
                                                      ? "- MEN"
                                                      : "N/A";

                                          return Container(
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            decoration: BoxDecoration(
                                                color: MyColor.app_white_color,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5.0))),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Row(children: [
                                                    Image.asset(
                                                      MyAssetsImage
                                                          .app_stop_watch,
                                                      width: 29,
                                                      height: 34,
                                                    ),
                                                    const SizedBox(width: 26),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        RichText(
                                                          text: TextSpan(
                                                            text:
                                                                "${eventresults.distance.toString() + unit}",
                                                            style: MyTextStyle
                                                                .textStyle(
                                                                    FontWeight
                                                                        .w700,
                                                                    20,
                                                                    MyColor
                                                                        .app_black_color),
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                text:
                                                                    " RESULTS",
                                                                style: MyTextStyle
                                                                    .textStyle(
                                                                        FontWeight
                                                                            .w300,
                                                                        20,
                                                                        MyColor
                                                                            .app_black_color),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        RichText(
                                                          text: TextSpan(
                                                            text: "ALL ",
                                                            style: MyTextStyle
                                                                .textStyle(
                                                                    FontWeight
                                                                        .w900,
                                                                    13,
                                                                    MyColor
                                                                        .app_black_color),
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                text:
                                                                    genderCategory,
                                                                style: MyTextStyle
                                                                    .textStyle(
                                                                        FontWeight
                                                                            .w600,
                                                                        13,
                                                                        MyColor
                                                                            .app_black_color),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ]),
                                                ),
                                                ListView.builder(
                                                    itemCount: eventresults
                                                        .results.length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int innerIndex) {
                                                      var result = eventresults
                                                          .results[innerIndex];
                                                      var gender = eventresults
                                                          .results[innerIndex]
                                                          .gender;
                                                      int displayIndex =
                                                          innerIndex + 1;
                                                      List<String> splitResult =
                                                          eventresults
                                                              .results[
                                                                  innerIndex]
                                                              .result
                                                              .split(':');

                                                      print(
                                                          "Result ${jsonEncode(result)}");
                                                      print("gender $gender");
                                                      print(
                                                          "splitResult $splitResult");
                                                      var resultTime =
                                                          "${int.parse(splitResult[0])}:${splitResult[1]}:${splitResult[2]}";
                                                      print(
                                                          "resultTime $resultTime");
                                                      return Container(
                                                        margin: const EdgeInsets
                                                            .only(bottom: 0),
                                                        color: info.eventResults
                                                                    .id ==
                                                                result.id
                                                            ? const Color(
                                                                0xFFF4F683)
                                                            : (innerIndex % 2 ==
                                                                    0)
                                                                ? const Color(
                                                                    0xFFEEEEEE)
                                                                : MyColor
                                                                    .app_white_color,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          child: Row(
                                                            children: [
                                                              Text(displayIndex
                                                                  .toString()),
                                                              const SizedBox(
                                                                  width: 25),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    width: (SizeConfig
                                                                            .screenWidth! -
                                                                        110),
                                                                    child: Text(
                                                                      "${result.firstName + " " + (result.lastName == "" || result.lastName == "null" || result.lastName == null ? "" : result.lastName)}",
                                                                      style: MyTextStyle.textStyle(
                                                                          FontWeight
                                                                              .w500,
                                                                          16,
                                                                          MyColor
                                                                              .app_black_color),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                  RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      text:
                                                                          resultTime,
                                                                      style: MyTextStyle.textStyle(
                                                                          FontWeight
                                                                              .w700,
                                                                          15,
                                                                          MyColor
                                                                              .app_black_color),
                                                                      children: <TextSpan>[
                                                                        TextSpan(
                                                                          text: gender == 1
                                                                              ? "\t\t\tM"
                                                                              : gender == 2
                                                                                  ? "\t\t\tF"
                                                                                  : "",
                                                                          style: MyTextStyle.textStyle(
                                                                              FontWeight.w700,
                                                                              15,
                                                                              MyColor.app_black_color),
                                                                        ),
                                                                        TextSpan(
                                                                          text: result.age.toString() == "" || result.age.toString() == "null"
                                                                              ? ""
                                                                              : result.age.toString(),
                                                                          style: MyTextStyle.textStyle(
                                                                              FontWeight.w300,
                                                                              15,
                                                                              MyColor.app_black_color),
                                                                        ),
                                                                        TextSpan(
                                                                          text:
                                                                              "\t\t\t${result.pace}",
                                                                          style: MyTextStyle.textStyle(
                                                                              FontWeight.w300,
                                                                              15,
                                                                              MyColor.app_black_color),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    })
                                              ],
                                            ),
                                          );
                                        }),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    info.eventPoll.questionId != null &&
                                            info.eventPoll.questionId != "null"
                                        ? Obx(() {
                                            return pollView(
                                                controller.dateData.value[index]
                                                    .eventInfo.id,
                                                info.eventPoll,
                                                index);
                                          })
                                        : SizedBox(),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                );
                              }),
                        ),
                  const SizedBox(
                    height: 20,
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
                    height: 20,
                  ),
                ],
              ),
            ),
            // bottomNavigationBar: const BottomNavigationBarWidget(),
          );
        })),
      ),
    );
  }

  Widget submitResultCard(
      BuildContext context,
      int index,
      DateTime date,
      TextEditingController hcont,
      TextEditingController mcont,
      TextEditingController scont) {
    print("Index $index");
    controller.select_distance.value = null;
    Distance? targetDistance;

    print(
        "eventResults  : ${jsonEncode(controller.dateData.value[index].eventResults)}");
    print(
        "eventDate ${controller.dateData.value[index].eventInfo.eventStartDate}");
    print(
        "eventEndDate ${controller.dateData.value[index].eventInfo.eventEndDate}");

    if (controller.dateData.value[index].eventResults.id != "") {
      if (controller.dateData.value[index].eventInfo.distances.any((element) =>
          element.id ==
          controller.dateData.value[index].eventResults.evDistancesId)) {
        try {
          targetDistance = controller.dateData.value[index].eventInfo.distances
              .firstWhere((element) =>
                  element.id ==
                  controller.dateData.value[index].eventResults.evDistancesId);

          controller.dateData.value[index].eventResults.evDistance =
              targetDistance.distance.toString();
          controller.dateData.value[index].eventResults.evDistanceUnit =
              targetDistance.unit.toString();
          print(
              'Distance for ID ${controller.dateData.value[index].eventResults.evDistancesId}: ${targetDistance.distance}');
        } catch (e) {
          print(
              'ID ${controller.dateData.value[index].eventResults.evDistancesId} not found');
        }
      }
    }

    var isDisabled = false.obs;

    if (controller.dateData.value[index].eventInfo.repeatingDays.toString() !=
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

      isDisabled.value = cDay != eventDay;
      print("repeating days isDisabled ${isDisabled.value}");
    } else {
      if (controller.dateData.value[index].eventInfo.eventStartDate != "" &&
          controller.dateData.value[index].eventInfo.eventEndDate == null) {
        print(
            "eventStartDate current if ${DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)}");
        print(
            "eventStartDate if ${DateTime.parse(controller.dateData.value[index].eventInfo.eventStartDate)}");
        isDisabled.value = DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day) !=
            DateTime.parse(
                controller.dateData.value[index].eventInfo.eventStartDate);
        print("eventStartDate if  ${isDisabled.value}");
      } else {
        print("Date Range");
        print(
            "isBefore ${DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).isBefore(DateTime.parse(controller.dateData.value[index].eventInfo.eventEndDate))}");
        print(
            "isAfter ${DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).isAfter(DateTime.parse(controller.dateData.value[index].eventInfo.eventStartDate))}");

        isDisabled.value = !((DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                    .isAfter(DateTime.parse(controller
                        .dateData.value[index].eventInfo.eventStartDate)) ||
                (DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString() ==
                    DateTime.parse(controller.dateData.value[index].eventInfo.eventStartDate)
                        .toString())) &&
            (DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).isBefore(DateTime.parse(controller.dateData.value[index].eventInfo.eventEndDate)) ||
                (DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                        .toString() ==
                    DateTime.parse(controller.dateData.value[index].eventInfo.eventEndDate)
                        .toString())));
        print("Date Range :-- ${isDisabled.value}");
      }
    }

/*    if (controller.dateData.value[index].eventInfo.eventStartDate != "" &&
        controller.dateData.value[index].eventInfo.eventEndDate == null) {
      print("eventStartDate ");
      isDisabled.value = DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day) !=
          DateTime.parse(
              controller.dateData.value[index].eventInfo.eventStartDate);
    }
    else if (controller.dateData.value[index].eventInfo.repeatingDays
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

    return controller.dateData.value[index].eventResults.isEditClicked!.value
        ? Obx(
            () => Card(
              color: const Color(0xFFDEDEDE),
              elevation: 0.0,
              margin: EdgeInsets.only(top: heightPerBox!),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        text:
                            "YOUR ${controller.dateData.value[index].eventResults.evDistance.toString()}${controller.dateData.value[index].eventResults.evDistanceUnit == "1" ? "KM" : "MI"} ",
                        style: MyTextStyle.textStyle(
                            FontWeight.w700, 21, MyColor.app_black_color),
                        children: <TextSpan>[
                          TextSpan(
                            text: MyString.result_var,
                            style: MyTextStyle.textStyle(
                                FontWeight.w500, 21, MyColor.app_black_color),
                          ),
                        ],
                      ),
                    ),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4.4))),
                              child: Column(
                                children: [
                                  TextFormField(
                                    readOnly: true,
                                    controller: hcont,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                    ],
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w700,
                                        30,
                                        MyColor.app_black_color),
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
                                    onTapOutside: (e) {
                                      CommonFunction.keyboardHide(context);
                                    },
                                  ),
                                  Text(
                                    MyString.hours_var,
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w500,
                                        15.4,
                                        MyColor.app_black_color,
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4.4))),
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              margin: const EdgeInsets.symmetric(horizontal: 7),
                              child: Column(
                                children: [
                                  TextFormField(
                                    readOnly: true,
                                    controller: mcont,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                    ],
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w700,
                                        30,
                                        MyColor.app_black_color),
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
                                    onTapOutside: (e) {
                                      CommonFunction.keyboardHide(context);
                                    },
                                  ),
                                  Text(
                                    MyString.mins_var,
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w500,
                                        15.4,
                                        MyColor.app_black_color,
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4.4))),
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              margin: const EdgeInsets.symmetric(horizontal: 7),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: scont,
                                    keyboardType: TextInputType.number,
                                    readOnly: true,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                    ],
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w700,
                                        30,
                                        MyColor.app_black_color),
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
                                  ),
                                  Text(
                                    MyString.sec_var,
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w500,
                                        15.4,
                                        MyColor.app_black_color,
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
                      height: 18,
                    ),
                    InkWell(
                      onTap: () {
                        print(
                            "evDistanceR:--  ${controller.dateData[index].eventResults.evDistance}");
                        controller.dateData[index].eventResults.editDistance =
                            controller.dateData[index].eventResults.evDistance!;
                        controller.dateData[index].eventResults.editDistanceId =
                            controller
                                .dateData[index].eventResults.evDistancesId!;
                        controller.dateData[index].eventResults.editEventId =
                            controller.dateData[index].eventResults.id!;
                        controller.select_distance.value = null;

                        controller.dateData[index].eventResults.isEditClicked
                            ?.value = false;
                        controller.dateData.refresh();
                      },
                      child: RichText(
                        text: TextSpan(
                          text: MyString.mistake_var,
                          style: MyTextStyle.textStyle(
                              FontWeight.w600, 16, MyColor.app_black_color),
                          children: <TextSpan>[
                            TextSpan(
                              text: MyString.editYourResult_var,
                              style: MyTextStyle.textStyle(
                                  FontWeight.w400, 16, MyColor.app_black_color),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Obx(
            () => Card(
              color: const Color(0xFFDEDEDE),
              elevation: 0.0,
              margin: EdgeInsets.only(top: heightPerBox!),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    CustomView.twotextView("EVENT ", FontWeight.w500, "RESULTS",
                        FontWeight.w700, 20, MyColor.app_black_color, 0),
                    const SizedBox(
                      height: 15,
                    ),
                    Obx(
                      () => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            decoration: BoxDecoration(
                              color: MyColor.app_text_box_bg_color,
                              border: Border.all(
                                  color: MyColor.app_border_color, width: 1.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: DropdownButton(
                              value: currentIndex.value == index
                                  ? controller.select_distance.value
                                  : null,
                              hint: Text(controller.dateData[index].eventResults
                                          .editDistance == ""
                                  ? "Select Distance"
                                  : "${controller.dateData[index].eventResults.editDistance!} ${controller.dateData[index].eventResults.evDistanceUnit == "1" ? "KM" : "MI"}"),
                              isExpanded: true,
                              icon: Image.asset(
                                  MyAssetsImage.app_textField_dropdown,
                                  height: 15,
                                  width: 15),
                              elevation: 16,
                              style: TextStyle(
                                color: MyColor.app_hint_color,
                                fontSize: 15,
                              ),
                              underline: Container(
                                height: 2,
                              ),
                              items: controller
                                  .dateData[index].eventInfo.distances
                                  .map<DropdownMenuItem<Distance>>(
                                      (Distance value) {
                                return DropdownMenuItem<Distance>(
                                  value: value,
                                  child: Text(
                                    "${value.distance} ${value.unit == 1 ? "KM" : "MI"}",
                                  ),
                                );
                              }).toList(),
                              onChanged:
                              // isDisabled.value
                              //     ? null
                              //     :
                                  (Distance? newValue) async {
                                      currentIndex.value = index;
                                      if (currentIndex.value == index) {
                                        controller.select_distance.value =
                                            newValue!;
                                        controller.distanceid.value =
                                            newValue.id;
                                        controller.distanceValue.value =
                                            newValue.distance.toString();
                                        controller.dateData[index].eventResults
                                                .editDistance =
                                            newValue.distance.toString();
                                        if (controller.dateData[index]
                                                .eventResults.editEventId !=
                                            "") {
                                          controller.dateData[index]
                                                  .eventResults.editDistanceId =
                                              controller.distanceid.value;
                                        }
                                      }
                                    },
                            ),
                          )),
                    ),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4.4))),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: hcont,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    readOnly: false, //isDisabled.value ? true : false,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(3),
                                      _NumberLimitFormatter(1000),
                                    ],
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w700,
                                        30,
                                        MyColor.app_black_color),
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
                                  ),
                                  Text(
                                    MyString.hours_var,
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w500,
                                        15.4,
                                        MyColor.app_black_color,
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4.4))),
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              margin: const EdgeInsets.symmetric(horizontal: 7),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: mcont,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    readOnly: false, //isDisabled.value ? true : false,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      _NumberLimitFormatter(60),
                                    ],
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w700,
                                        30,
                                        MyColor.app_black_color),
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
                                    onChanged: (val) {
                                      if (mcont.text.length == 1 && mcont.text[0] != "0" ) {
                                        mcont.text = "0${mcont.text}";
                                      } else if (mcont.text.length > 2) {
                                        mcont.text = mcont.text.substring(1);
                                      }
                                    },
                                  ),
                                  Text(
                                    MyString.mins_var,
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w500,
                                        15.4,
                                        MyColor.app_black_color,
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4.4))),
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              margin: const EdgeInsets.symmetric(horizontal: 7),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: scont,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    readOnly:
                                    // isDisabled.value ? true :
                                    false,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      _NumberLimitFormatter(60),
                                    ],
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w700,
                                        30,
                                        MyColor.app_black_color),
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
                                    onChanged: (val) {
                                      if (scont.text.length == 1 && scont.text[0] != "0") {
                                        scont.text = "0${scont.text}";
                                      } else if (scont.text.length > 2) {
                                        scont.text = scont.text.substring(1);
                                      }
                                    },
                                  ),
                                  Text(
                                    MyString.sec_var,
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w500,
                                        15.4,
                                        MyColor.app_black_color,
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
                      height: 18,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          width: SizeConfig.screenWidth,
                          height: 54,
                          child: ElevatedButton(
                              onPressed:
                              // isDisabled.value
                              //     ? null
                              //     :
                                  () {
                                      CommonFunction.keyboardHide(context);
                                      if (hcont.text.trim().isEmpty) {
                                        hcont.text = "0";
                                      }
                                      if (mcont.text.trim().isEmpty) {
                                        mcont.text = "00";
                                      }
                                      if (scont.text.trim().isEmpty) {
                                        scont.text = "00";
                                      }
                                      if (controller.select_distance.value ==
                                              null &&
                                          controller
                                                  .dateData[index]
                                                  .eventResults
                                                  .editDistanceId ==
                                              "") {
                                        CustomView.showAlertDialogBox(
                                            context, "Please select distance");
                                      } else if (hcont.text.trim().isEmpty &&
                                          mcont.text.trim().isEmpty &&
                                          scont.text.trim().isEmpty) {
                                        CustomView.showAlertDialogBox(
                                            context, "Please enter time");
                                      } //Diksha
                                      else if ((hcont.text.trim().toString() ==
                                                  "0" &&
                                              mcont.text.trim().toString() ==
                                                  "00" &&
                                              scont.text.trim().toString() ==
                                                  "00") ||
                                          (hcont.text.trim().toString() ==
                                                  "00" &&
                                              mcont.text.trim().toString() ==
                                                  "00" &&
                                              scont.text.trim().toString() ==
                                                  "00")) {
                                        CustomView.showAlertDialogBox(
                                            context, "Please enter time");
                                      } else {
                                        print(
                                            "hcount :--- ${hcont.text.trim().toString()}");
                                        if (hcont.text.trim().isEmpty) {
                                          hcont.text = "00";
                                        }
                                        if (mcont.text.trim().isEmpty) {
                                          mcont.text = "00";
                                        }
                                        if (scont.text.trim().isEmpty) {
                                          scont.text = "00";
                                        }

                                        if (controller.dateData[index]
                                                .eventResults.editEventId !=
                                            "") {
                                          controller.distanceid.value =
                                              controller.dateData[index]
                                                  .eventResults.editDistanceId!;
                                          controller.distanceValue.value =
                                              controller.dateData[index]
                                                  .eventResults.editDistance!;
                                          controller.dateData[index]
                                                  .eventResults.id =
                                              controller.dateData[index]
                                                  .eventResults.editEventId!;
                                        }

                                        print(
                                            "time getting null :== ${hcont.text} : ${mcont.text} : ${scont.text}");

                                        onSubmitCall(
                                            hcont, mcont, scont, index);
                                      }
                                    },
                              style: ButtonStyle(
                                backgroundColor:
                                // isDisabled.value
                                //     ? MaterialStateProperty.all(
                                //         MyColor.app_border_grey_color)
                                //     :
                                MaterialStateProperty.all(
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
                                  MyString.submitYourResult_var
                                      .substring(6, 19),
                                  FontWeight.w600,
                                  17,
                                  MyColor.app_white_color,
                                  1)),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw Exception('Could not launch $_url');
    }
  }

  Widget pollView(String eventId, EventPoll eventPoll, int index) {
    print("eventPoll questionId :-- ${eventPoll.questionId}");
    var total = getTotal(eventPoll);
    // var total = 0;
    // if (eventPoll.answers != null) {
    //   for (int i = 0; i < eventPoll.answers!.length; i++) {
    //     total = total + int.parse(eventPoll.answers[i].voteCount??"0");
    //   }
    // }
    return Card(
      color: MyColor.app_white_color,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.5),
              child: Text("${eventPoll.question}",
                  style: TextStyle(
                      fontFamily: GoogleFonts.manrope().fontFamily,
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      color: MyColor.app_black_color)),
            ),
            SizedBox(
              height: 10,
            ),
            pollBarDataList(eventPoll, index, total, eventId),
            eventPoll.myAnswerId!.isEmpty
                ? CustomView.buttonShow("VOTE NOW", FontWeight.w600, 4, 19.2,
                    MyColor.app_orange_color.value ?? const Color(0xFFFF4300),
                    () {
                    //Vote Api Call here... Rishabh
                    if (controller.answerId.value.isNotEmpty &&
                        eventPoll.answers![controller.indexValue.value]
                                .answerId ==
                            controller.answerId.value) {
                      controller.Event_pollVote_api(
                              eventId,
                              controller.questionId.value,
                              controller.answerId.value,
                              "")
                          .then((code) {
                        print(code.toString());
                        print("add vote news" + code.toString());
                        var abc = jsonDecode(code);
                        var poll = abc['data']['eventPoll'];
                        print("add vote event" + poll.toString());
                        var acode = abc['code'].toString();
                        if (acode == "200") {
                          print("acode" + poll.toString());
                          eventPoll.myAnswerId = controller.answerId.value;
                          controller.questionId.value = "";
                          controller.answerId.value = "";
                          //newsPoll = NewsPoll.fromJson(poll);
                          eventPoll.answers!.clear();
                          for (var value in poll['answers']) {
                            var ans = Answer(
                                answerId: value['answerId'].toString(),
                                answer: value['answer'].toString(),
                                voteCount: value['voteCount'].toString(),
                                viewVoter: true);
                            eventPoll.answers!.add(ans);
                          }
                          print("eventPoll.answers!.length");
                          print(eventPoll.answers!.length);
                          controller.eventDateModel.refresh();
                          controller.dateData.refresh();
                          controller.eventInfoList.refresh();
                        }
                        /* if (code.toString() != "") {
                          addVoteToModel(eventPoll);
                        } else {
                          print("vbvbbvcbvcbvcbvcb");
                        }*/
                      });
                    } else {
                      CommonFunction.showAlertDialogdelete(
                          Get.context!, "Please select an option first", () {
                        Get.back();
                      });
                    }
                  }, buttonHeight: 54)
                : const SizedBox(),
            const SizedBox(
              height: 13,
            ),
            InkWell(
              onTap: () {
                //Clear APi hit
                if (eventPoll.myAnswerId!.isNotEmpty) {
                  controller
                      .cancelVote_Api(context, eventId)
                      .then((statusCode) {
                    if (statusCode.toString() == "200") {
                      //Clear APi hit
                      clearVote(eventPoll);
                    }
                  });
                }
              },
              child: Text(
                  eventPoll.myAnswerId!.isNotEmpty
                      ? "CANCEL AND CLEAR YOUR VOTE"
                      : "VOTE TO VIEW RESULTS",
                  style: MyTextStyle.textStyle(
                      FontWeight.w600, 14, MyColor.app_text_grey_event)),
            ),
          ],
        ),
      ),
    );
  }

  void addVoteToModel(EventPoll eventPoll) {
    eventPoll.myAnswerId = controller.answerId.value;
    controller.questionId.value = "";
    controller.answerId.value = "";
    for (var value in eventPoll.answers!) {
      if (value.answerId == eventPoll.myAnswerId) {
        value.voteCount = (int.parse(value.voteCount) + 1).toString();
      }
    }
    controller.eventDateModel.refresh();
    controller.dateData.refresh();
    controller.eventInfoList.refresh();
  }

  void clearVote(EventPoll eventPoll) {
    if (eventPoll.myAnswerId!.isNotEmpty) {
      for (var value in eventPoll.answers!) {
        if (value.answerId == eventPoll.myAnswerId) {
          value.voteCount = (int.parse(value.voteCount) - 1).toString();
        }
      }
      eventPoll.myAnswerId = "";
      controller.indexValue.value = -1;
      controller.eventDateModel.refresh();
      controller.dateData.refresh();
      controller.eventInfoList.refresh();
    }
  }

  int getTotal(EventPoll eventPoll) {
    var total = 0;
    print("getTotal event :-- ${eventPoll.answers!.length}");
    if (eventPoll.answers!.length > 0) {
      for (int i = 0; i < eventPoll.answers!.length; i++) {
        total = total + int.parse(eventPoll.answers![i].voteCount);
      }
    }
    return total;
  }

  Widget pollBarDataList(
      EventPoll eventPoll, int maiListIndex, totalValue, String eventId) {
    List<Answer> answerList = eventPoll.answers!;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: answerList.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var divNumber = 1.0;
        if (answerList.length > 0) {
          divNumber = totalValue / int.parse(answerList[index].voteCount);
          divNumber.toString() == "NaN" ? divNumber = 0 : divNumber = divNumber;
        }

        return SizedBox(
          width: screenWidth,
          child: Obx(
            () {
              var voterIndex = -1;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      print(eventPoll.myAnswerId!);
                      print(answerList[index].answerId);
                      if (eventPoll.myAnswerId!.isEmpty) {
                        controller.indexValue.value = index;
                        controller.maiListIndex.value = maiListIndex;
                        controller.questionId.value = eventPoll.questionId!;
                        controller.answerId.value = answerList[index].answerId;
                      }
                    },
                    child: Card(
                      color: MyColor.app_textform_bg_color2,
                      margin: const EdgeInsets.only(bottom: 0),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: (controller.indexValue.value == index &&
                                          controller.maiListIndex.value ==
                                              maiListIndex) ||
                                      eventPoll.myAnswerId ==
                                          answerList[index].answerId
                                  ? MyColor.app_orange_color.value ??
                                      const Color(0xFFFF4300)
                                  : MyColor.app_textform_bg_color),
                          borderRadius: BorderRadius.circular(3.65)),
                      elevation: 0.0,
                      child: SizedBox(
                        height: SizeConfig.screenWidth! * 0.12,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Stack(children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Stack(children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(3.0),
                                          bottomLeft: Radius.circular(3.0),
                                        ),
                                        color: MyColor.app_textform_bg_color,
                                      ),
                                      width: eventPoll.myAnswerId!.isEmpty
                                          ? SizeConfig.screenWidth
                                          : (SizeConfig.screenWidth! - 50) /
                                              divNumber,
                                      //...(Total number of votes/current vote)
                                      height: SizeConfig.screenWidth! * 0.12,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 15),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          answerList[index].answer.toString(),
                                          style: TextStyle(
                                              color: MyColor.app_black_color,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                            (controller.indexValue.value == index &&
                                        controller.maiListIndex.value ==
                                            maiListIndex) ||
                                    eventPoll.myAnswerId ==
                                        answerList[index].answerId
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: MyColor.app_orange_color.value ??
                                          const Color(0xFFFF4300),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(5.0),
                                        topRight: Radius.zero,
                                        bottomLeft: Radius.circular(5.0),
                                        bottomRight: Radius.zero,
                                      ),
                                    ),
                                    width: 10,
                                  )
                                : const SizedBox(),
                          ]),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  eventPoll.myAnswerId!.isNotEmpty
                      ? Row(
                          children: [
                            Text(
                              "${answerList[index].voteCount} ${int.parse(answerList[index].voteCount) <= 1 ? "Vote" : "Votes"}",
                              style: MyTextStyle.textStyle(
                                  FontWeight.w600, 13, MyColor.app_black_color),
                              textAlign: TextAlign.left,
                            ),
                            eventPoll.showParticipantDetails.toString() ==
                                        "1" &&
                                    int.parse(answerList[index].voteCount) > 0
                                ? //show vote in 1
                                InkWell(
                                    onTap: () {
                                      voterIndex = index;

                                      for (int i = 0;
                                          i < controller.dateData.length;
                                          i++) {
                                        for (int j = 0;
                                            j <
                                                controller.dateData[i].eventPoll
                                                    .answers!.length;
                                            j++) {
                                          if (i != maiListIndex) {
                                            controller.dateData[i].eventPoll
                                                .answers![j].viewVoter = false;
                                          }
                                        }
                                      }

                                      for (int i = 0;
                                          i < answerList.length;
                                          i++) {
                                        if (i != index) {
                                          answerList[i].viewVoter = false;
                                        }
                                      }

                                      if (!answerList[index].viewVoter!) {
                                        controller.Event_pollVoters_api(
                                            0,
                                            eventPoll.answers![index].answerId,
                                            eventId);
                                      }

                                      answerList[index].viewVoter =
                                          !answerList[index].viewVoter!;

                                      controller.dateData.refresh();
                                      controller.eventDateModel.refresh();
                                      controller.voters.refresh();
                                      controller.pollVotersList.refresh();
                                    },
                                    child: Text(
                                      "- View Voters ",
                                      style: MyTextStyle.textStyle(
                                          FontWeight.w600,
                                          13,
                                          MyColor.app_black_color),
                                      textAlign: TextAlign.left,
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 7,
                  ),
                  answerList[index].viewVoter! &&
                          controller.pollVotersList.isNotEmpty
                      ? const Divider()
                      : const SizedBox(),
                  answerList[index].viewVoter!
                      ? ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 170.0,
                          ),
                          child: Obx(() {
                            return showVoterList();
                          }))
                      : const SizedBox(),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget showVoterList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: controller.pollVotersList.length,
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(3.0),
              bottomLeft: Radius.circular(3.0),
            ),
            color: MyColor.app_textform_bg_color,
          ),
          height: SizeConfig.screenWidth! * 0.127,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50), // Image border
                child: SizedBox.fromSize(
                  child: FadeInImage.assetNetwork(
                    placeholder: MyAssetsImage.app_loader,
                    image: controller.pollVotersList[index]
                        .profilePicture, // "https://i.pinimg.com/736x/92/01/f3/9201f3d81c7d28ea365f18f16453d3ab.jpg"
                    placeholderFit: BoxFit.cover,
                    fit: BoxFit.cover,
                    height: 100,
                    width: 50,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Flexible(
                  child: CustomView.differentStyleTextTogether(
                      controller.pollVotersList[index].firstName,
                      FontWeight.w200,
                      " ${controller.pollVotersList[index].lastName == "" || controller.pollVotersList[index].lastName == "null" || controller.pollVotersList[index].lastName == null ? "" : controller.pollVotersList[index].lastName}",
                      FontWeight.w600,
                      14,
                      MyColor.app_black_color)),
              const SizedBox(
                width: 7,
              ),
            ],
          ),
        );
      },
    );
  }

  void onSubmitCall(TextEditingController hcont, TextEditingController mcont,
      TextEditingController scont, int index) {
    // add Result Api call
    print("convertPace hcont :-- ${int.parse(hcont.text.trim().toString())}");
    print("convertPace mcont :-- ${int.parse(mcont.text.trim().toString())}");
    print("convertPace scont :-- ${int.parse(scont.text.trim().toString())}");
    print(
        "distanceValue :-- ${double.parse(controller.distanceValue.value.toString())}");
    var pace = CommonFunction.calculatePace(
        double.parse(controller.distanceValue.value.toString()),
        int.parse(hcont.text.trim().toString()),
        int.parse(mcont.text.trim().toString()),
        int.parse(scont.text.trim().toString()));

    print("pace event result : $pace");

    var arr = pace.split(":");
    if (arr.length == 2) {
      if (arr[1].length == 1) {
        arr[1] = "0" + arr[1];
      }
      pace = arr[0] + ":" + arr[1];
    }
    var convertPace = "$pace p/km".toString();
    print("convertPace onSubmitCall :-- $convertPace");

    var timeSend =
        "${hcont.text.trim().length == 1 ? "${hcont.text.trim()}" : hcont.text.trim()}:"
        "${mcont.text.trim().length == 1 ? "0${mcont.text.trim()}" : mcont.text.trim()}:"
        "${scont.text.trim().length == 1 ? "0${scont.text.trim()}" : scont.text.trim()}";

    controller.Event_addResults_api(
            controller.dateData[index].eventInfo.id,
            controller.distanceid.value,
            timeSend,
            convertPace,
            controller.dateData[index].eventResults.id)
        .then((addEventResponse) {
      print("addResults value :-- $addEventResponse");
      final parsedJson = jsonDecode(addEventResponse);
      if (parsedJson['data']['id'] != null) {
        final String id = parsedJson['data']['id'] ?? "";
        final String result = parsedJson['data']['result'];
        final String evDistancesId = parsedJson['data']['evDistancesId'];

        controller.dateData[index].eventResults.id = id;
        controller.dateData[index].eventResults.evDistancesId = evDistancesId;
        controller.dateData[index].eventResults.result = result;

        //To refresh the result list....
        controller.EventResultList_API(
            0, controller.dateData[index].eventInfo.id, index);
      }

      if (controller.dateData[index].eventResults.id != "") {
        controller.dateData[index].eventResults.isEditClicked?.value = true;
      } else {
        controller.dateData[index].eventResults.isEditClicked?.value = false;
      }

      controller.dateData[index].eventResults
          .editDistance = "";
      controller.select_distance.value = null;
      controller.dateData.refresh();
    });
  }

  Future<void> getDatesApi(
      DateTime currentDate, String direction, bool isSwipe) async {
    month = DateFormat('MM').format(currentDate).toString();
    year = DateFormat('yyyy').format(currentDate).toString();

    if (month.length > 1 && month[0] == "0") {
      month = month[1].toString();
    }
    print("Date month :-- $month/$year");

    Future.delayed(Duration.zero, () {
      controller.eventAvailableDate(month, year, direction, (dateResponse) {


           print("object notempty ");
          if (controller.eventDateList.isNotEmpty) {
            print("not empty date list ");
            controller.eventDateTypeList.clear();
          } else {
            print("onBack");
            openCalendar = false;
            Get.back();
          }
           if (controller.eventDateList.isNotEmpty){
             for (var dateString in controller.eventDateList) {
               DateTime originalDate = DateTime.parse(dateString);
               int year = originalDate.year;
               int month = originalDate.month;
               int day = originalDate.day;
               controller.eventDateTypeList.add(DateTime(year, month, day));
             }

             controller.eventDateTypeList.refresh();
             if (openCalendar) {
               ConstValue.isPopupShow = false;
               print("openCalendar $openCalendar");
               WidgetsFlutterBinding.ensureInitialized();
               Get.back();
               if (controller.eventDateTypeList.isNotEmpty) {
                 print("list not empty");
                 Future.delayed(Duration.zero).then((value) {
                   var date;
                   if (showCurrentDate.value) {
                     date = controller.currentDate;
                     showCurrentDate.value = false;
                   } else {
                     date = Rx(controller.eventDateTypeList[0]);
                   }

                   CommonFunction.showCalenderDialogBox(
                       context,
                       date,
                       date,
                       heightPerBox!,
                       fontSize,
                       widthPerBox,
                       controller.eventDateTypeList.value,
                       controller: calendarController,
                       onClickLeftIcon: (newFocusedDay) {
                         Future.delayed(Duration.zero, () async {
                           getDatesApi(newFocusedDay, "1", false);
                         });
                       }, onClickRightIcon: (newFocusedDay) {
                     print("onClickRightIcon ddddd---> $newFocusedDay");
                     Future.delayed(Duration.zero, () async {
                       getDatesApi(newFocusedDay, "2", false);
                     });
                   }).then((value) {
                     print("value crDate :-- $value");
                     if (value != null) {
                       controller.currentDate.value = value;
                       callEventDetailAndMange(controller.currentDate.value);
                     } else {
                      controller.currentDate.value =  controller.tempCurrentDate.value;
                       print("crDate inside  :-- ${controller.currentDate.value}");
                     }
                   });
                 });
               }
             }
           }else{
             print("object empty ${ConstValue.isPopupShow}");
             Get.back();
             if (ConstValue.isPopupShow){
               if(direction == "2"){
                 getDatesApi(controller.currentDate.value, "1", false)
                     .then((value) {

                   var focusedDay = Rx<DateTime>(DateTime(
                       controller.currentDate.value.year,
                       controller.currentDate.value.month,
                       controller.currentDate.value.day));
                   var selectedDay = Rx<DateTime>(DateTime(
                       controller.currentDate.value.year,
                       controller.currentDate.value.month,
                       controller.currentDate.value.day));

                   openCalendar = true;
                   ConstValue.isPopupShow = true;
                   CommonFunction.showCalenderDialogBox(
                       context,
                       selectedDay,
                       selectedDay,
                       heightPerBox!,
                       fontSize,
                       widthPerBox,
                       controller.eventDateTypeList.value,
                       controller: calendarController,
                       onClickLeftIcon: (newFocusedDay) {
                         print("on left click : $newFocusedDay");
                         Future.delayed(Duration.zero, () async {
                           getDatesApi(newFocusedDay, "1", false);
                         });
                       }, onClickRightIcon: (newFocusedDay) {
                     print("on right click : $newFocusedDay");
                     Future.delayed(Duration.zero, () async {
                       getDatesApi(newFocusedDay, "2", false);
                     });
                   }).then((value) {

                     print("New Value else :--  $value");
                     if (value != null) {
                       ConstValue.isPopupShow = false;
                       controller.currentDate.value = value;
                       callEventDetailAndMange(controller.currentDate.value);
                     } else {
                       print("focusedDay :--  ${controller.focusedDay}");
                       controller.focusedDay = focusedDay;
                       controller.selectedDay = selectedDay;
                     }
                   });
                 });
               }else{
                 ConstValue.isPopupShow = false;
                 CommonFunction.showAlertDialogdelete(context, "No Items to display", () {Get.back();});
               }

             }
           }
          if (isSwipe) {
            /* if(controller.eventDateTypeList.isNotEmpty){
            if(direction.toString() == "1"){
              controller.currentDate.value = controller.eventDateTypeList[controller.eventDateTypeList.length-1];
            }else{
              controller.currentDate.value = controller.eventDateTypeList[0];
            }
          }*/

            if (controller.eventDateTypeList.isNotEmpty) {
              if (direction.toString() == "1") {
                if (ConstValue.isFromLastOrPrevious) {
                  ConstValue.isFromLastOrPrevious = false;
                  controller.currentDate.value = controller.eventDateTypeList[0];
                } else {
                  controller.currentDate.value = controller
                      .eventDateTypeList[controller.eventDateTypeList.length - 1];
                }
              } else {
                if (ConstValue.isFromLastOrPrevious) {
                  ConstValue.isFromLastOrPrevious = false;
                  controller.currentDate.value = controller
                      .eventDateTypeList[controller.eventDateTypeList.length - 1];
                } else {
                  controller.currentDate.value = controller.eventDateTypeList[0];
                }
              }
            }

            Future.delayed(const Duration(milliseconds: 00), () {
              callEventDetailAndMange(controller.currentDate.value);
            });
          }
      });
    });
  }

  void callEventDetailAndMange(DateTime currentDate) {
    controller.dateData.value.clear();
    controller.EventDetail_api(currentDate).then((value) {
      if (value != "") {
        print("value EventDetail_api :- ${value}");
        controller.eventDateModel.value = eventDateModelFromJson(value);
        controller.dateData.value =
            controller.eventDateModel.value!.data.eventData;

        for (var valueList in controller.dateData.value) {
          if (valueList.eventResults.id != "") {
            valueList.eventResults.isEditClicked?.value = true;
          } else {
            valueList.eventResults.isEditClicked?.value = false;
          }
          print("referenceId ${NotificationService.notificationPayloadModel?.referenceId}");
          if (NotificationService.notificationPayloadModel?.referenceId != null) {
            print("if referenceId");
            if (NotificationService.notificationPayloadModel?.referenceId == valueList.eventInfo.id) {
              controller.dateData.value.remove(valueList);
              controller.dateData.value.insert(0, valueList);
            }
          } else {
            print("else eventId");
            if (msc.eventId.value == valueList.eventInfo.id) {
              controller.dateData.value.remove(valueList);
              controller.dateData.value.insert(0, valueList);
            }
          }
        }

        controller.selectedDay.value = currentDate;
        controller.focusedDay.value = currentDate;
      }
    });
  }

  //next date from array list
  DateTime? findNextDate(DateTime currentDate) {
    var crDate = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      0,
      0,
      0,
      0,
      0,
    );
    for (DateTime date in controller.eventDateTypeList) {
      if (date.isAfter(crDate)) {
        return date;
      }
    }
    return null;
  }

//previous date from array list
  DateTime? findFirstPreviousDate(DateTime currentDate) {
    var crDate = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      0,
      0,
      0,
      0,
      0,
    );
    DateTime? previousDate;
    for (var date in controller.eventDateTypeList.value) {
      if (date.isBefore(crDate)) {
        previousDate = date;
      } else {
        break;
      }
    }
    return previousDate;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<CalendarController>();
    msc.dateSend.value = null;
    msc.eventId.value = "";
    controller.dateData.value.clear();
    if (ConstValue.isFromNotification) {
      print('hhhhhhhhhhh');
    }
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
