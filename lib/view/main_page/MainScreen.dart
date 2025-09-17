import 'package:club_runner/controller/MainScreenController.dart';
import 'package:club_runner/util/asstes_image/AssetsImage.dart';
import 'package:club_runner/util/local_storage/LocalStorage.dart';
import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:club_runner/view/screens/dash_board_screen/DashBoardScreen.dart';
import 'package:club_runner/view/screens/event_screen/EventDetailScreen.dart';
import 'package:club_runner/view/screens/event_screen/EventScreen.dart';
import 'package:club_runner/view/screens/news_screen/NewsDetailScreen.dart';
import 'package:club_runner/view/screens/news_screen/NewsScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/NotificationController.dart';
import '../../controller/dashboardController.dart';
import '../../service/NotificationServices.dart';
import '../../util/const_value/ConstValue.dart';
import '../../util/route_helper/RouteHelper.dart';
import '../../util/size_config/SizeConfig.dart';
import '../screens/notification_screen/Notifications.dart';
import '../screens/training_screen/TrainingScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;

  MainScreenController msc = Get.put(MainScreenController());
  DeshboardController db_controller = Get.put(DeshboardController());

  LocalStorage sp = LocalStorage();
  NotificationController Notificationcontroller =
      Get.put(NotificationController());

  String notificationUnreadCount = "";
  final List _pages = [
    const DashBoardScreen(),
    const Notification_Screen(),
    const TrainingScreen(),
    const NewsScreen(),
    const EventScreen(),
    const EventDetailScreen(),
    const NewsDetailsScreen()
  ];

  @override
  void initState() {
    super.initState();
    print(" jiiiiiihiii ${ConstValue.isFromNotification}");
    ConstValue.notificationUnreadCount.value = LocalStorage.getStringValue(sp.notificationUnreadCount);
    print("jiiiiiihiii notificationUnreadCount :-- ${ConstValue.notificationUnreadCount.value}");
    if (!ConstValue.isFromNotification) {
      msc.selectedTab.value = 0;
    }
    if (ConstValue.isFromNotification) {
      Future.delayed(Duration.zero, () async {
        print(
            "Notification Date:-- ${NotificationService.notificationPayloadModel!.date}");
        msc.dateSend.value =
            DateTime.parse(NotificationService.notificationPayloadModel!.date);
        msc.eventId.value =
            NotificationService.notificationPayloadModel!.notificationId;

        if (NotificationService.notificationPayloadModel!.notificationType == "event") {
          ConstValue.isCalendarDisable = false;
          Notificationcontroller.readNotification_api(NotificationService.notificationPayloadModel!.notificationId);
          msc.selectedTab.value = 5;
        } else if (NotificationService.notificationPayloadModel!.notificationType == "news") {
          ConstValue.isCalendarDisable = true;
          print(
              "${NotificationService.notificationPayloadModel!.notificationType} = news tab");
          Notificationcontroller.readNotification_api(NotificationService.notificationPayloadModel!.notificationId);
          msc.selectedTab.value = 6;
        }else if(NotificationService.notificationPayloadModel!.notificationType == "training"){
          Notificationcontroller.readNotification_api(NotificationService.notificationPayloadModel!.notificationId);
          msc.selectedTab.value = 2;
        }
      });
      /* if(ConstValue.isFromNotification&&NotificationService.notificationPayloadModel!.notificationType=="news")
      {
        print("object");
        msc.dateSend.value =DateTime.parse(NotificationService.notificationPayloadModel!.date);
        msc.eventId.value = NotificationService.notificationPayloadModel!.notificationId;
        msc.selectedTab.value = 6;
      }
*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
        onWillPop: () async => false,
        child: Container(
          color: MyColor.screen_bg,
          child: SafeArea(
            child: Scaffold(
                body: _pages[msc.selectedTab.value],
                bottomNavigationBar: buildMyNavBar(context)),
          ),
        ),
      );
    });
  }

  buildMyNavBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              ConstValue.isCalendarDisable = false;
              ConstValue.isPopupShow = false;
              if (NotificationService.notificationPayloadModel?.date != "") {
                NotificationService.notificationPayloadModel?.date = '';
                NotificationService.notificationPayloadModel = null;
              }
              msc.selectedTab.value = 0;
            },
            child: Image.asset(MyAssetsImage.app_menu_inactive,
                height: 45,
                width: 45,
                color: msc.selectedTab.value == 0
                    ? MyColor.app_orange_color.value
                    : Colors.white),
          ),
          InkWell(
              onTap: () async {
                ConstValue.isPopupShow = false;
                ConstValue.isCalendarDisable = false;
                if (NotificationService.notificationPayloadModel?.date != "") {
                  NotificationService.notificationPayloadModel?.date = '';
                  NotificationService.notificationPayloadModel = null;
                }
                if (LocalStorage.getStringValue(sp.currentClubData_logo) == "") {
                  var back = await Get.toNamed(RouteHelper.getMembershipScreen());
                  print("back else 123!");
                  if (back == "refresh") {
                    print("back else 123");
                    db_controller.callback();
                  }
                } else {
                  if (LocalStorage.getStringValue(sp.isMembershipFinal) == "0") {
                    var back = await Get.toNamed(RouteHelper.getMembershipScreen());
                    print("back else 456! $back");
                    if (back == "refresh") {
                      print("back else 456");
                      db_controller.callback();
                    }
                  } else {
                    msc.selectedTab.value = 1;
                  }
                }
              },
              child: Stack(
                children: [
                  Image.asset(
                    MyAssetsImage.app_bell_inactive,
                    width: 45,
                    height: 45,
                    color: msc.selectedTab.value == 1
                        ? MyColor.app_orange_color.value ?? Color(0xFFFF4300)
                        : Colors.white,
                  ),
                  ConstValue.notificationUnreadCount.value == "0" || ConstValue.notificationUnreadCount.value == ""
                      ?SizedBox(): Positioned(
                          right: 14,
                          top: 14,
                          child: Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: MyColor.app_orange_color.value,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '', // You can replace this with your dynamic badge number
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                ],
              )
              /* Image.asset(MyAssetsImage.app_bell_inactive,
                width: 45,
                height: 45,
                color: msc.selectedTab.value == 1
                    ? MyColor.app_orange_color.value ?? Color(0xFFFF4300)
                    : Colors.white),*/
              ),
          Obx(
            () => InkWell(
              onTap: () async {
                ConstValue.isPopupShow = false;
                ConstValue.isCalendarDisable = false;
                if (NotificationService.notificationPayloadModel?.date != "") {
                  NotificationService.notificationPayloadModel?.date = '';
                  NotificationService.notificationPayloadModel = null;
                }
                if (LocalStorage.getStringValue(sp.currentClubData_logo) ==
                    "") {
                  var back =
                      await Get.toNamed(RouteHelper.getMembershipScreen());
                  if (back == "refresh") {
                    print("back else");
                    db_controller.callback();
                  }
                } else {
                  if (LocalStorage.getStringValue(sp.isMembershipFinal) ==
                      "0") {
                    var back =
                        await Get.toNamed(RouteHelper.getMembershipScreen());
                    if (back == "refresh") {
                      print("back else");
                      db_controller.callback();
                    }
                  } else {
                    msc.selectedTab.value = 2;
                  }
                }
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: MyColor.app_orange_color.value ?? Color(0xFFFF4300),
                    shape: BoxShape.circle),
                child: Image.asset(
                  MyAssetsImage.app_training_calendar_inactive,
                  width: 50,
                  height: 50,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              ConstValue.isPopupShow = false;
              ConstValue.isCalendarDisable = true;
              if (NotificationService.notificationPayloadModel?.date != "") {
                NotificationService.notificationPayloadModel?.date = '';
                NotificationService.notificationPayloadModel = null;
              }
              if (LocalStorage.getStringValue(sp.currentClubData_logo) == "") {
                var back = await Get.toNamed(RouteHelper.getMembershipScreen());
                if (back == "refresh") {
                  print("back else");
                  db_controller.callback();
                }
              } else {
                if (LocalStorage.getStringValue(sp.isMembershipFinal) == "0") {
                  var back =
                      await Get.toNamed(RouteHelper.getMembershipScreen());
                  if (back == "refresh") {
                    print("back else");
                    db_controller.callback();
                  }
                } else {
                  msc.selectedTab.value = 3;
                }
              }
            },
            child: Image.asset(
              MyAssetsImage.app_news_inactive,
              width: 45,
              height: 45,
              color: msc.selectedTab.value == 3 || msc.selectedTab.value == 6
                  ? MyColor.app_orange_color.value ?? Color(0xFFFF4300)
                  : Colors.white,
            ),
          ),
          InkWell(
            onTap: () async {
              ConstValue.isPopupShow = false;
              ConstValue.isCalendarDisable = false;
              if (NotificationService.notificationPayloadModel?.date != "") {
                NotificationService.notificationPayloadModel?.date = '';
                NotificationService.notificationPayloadModel = null;
              }
              if (LocalStorage.getStringValue(sp.currentClubData_logo) == "") {
                var back = await Get.toNamed(RouteHelper.getMembershipScreen());
                if (back == "refresh") {
                  print("back else");
                  db_controller.callback();
                }
              } else {
                if (LocalStorage.getStringValue(sp.isMembershipFinal) == "0") {
                  var back =
                      await Get.toNamed(RouteHelper.getMembershipScreen());
                  if (back == "refresh") {
                    print("back else");
                    db_controller.callback();
                  }
                } else {
                  msc.selectedTab.value = 4;
                }
              }
            },
            child: Image.asset(
              MyAssetsImage.app_event_inactive,
              width: 45,
              height: 45,
              color: msc.selectedTab.value == 4 || msc.selectedTab.value == 5
                  ? MyColor.app_orange_color.value ?? Color(0xFFFF4300)
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
