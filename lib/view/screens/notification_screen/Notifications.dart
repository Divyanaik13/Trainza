import 'package:club_runner/controller/NotificationController.dart';
import 'package:club_runner/util/asstes_image/AssetsImage.dart';
import 'package:club_runner/util/custom_view/CustomView.dart';
import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:club_runner/util/size_config/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controller/MainScreenController.dart';
import '../../../util/string_const/MyString.dart';
import '../../../util/text_style/MyTextStyle.dart';

class Notification_Screen extends StatefulWidget {
  const Notification_Screen({Key? key}) : super(key: key);

  @override
  State<Notification_Screen> createState() => _Notification_ScreenState();
}

class _Notification_ScreenState extends State<Notification_Screen> {
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var screenWidth = SizeConfig.screenWidth;
  var pageNo = 1;

  NotificationController controller = Get.put(NotificationController());
  ScrollController _scrollController = ScrollController();
  MainScreenController msc = Get.find();

  @override
  void initState() {
    controller.notificationList_API(pageNo);
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.offset.toInt() == _scrollController.position.maxScrollExtent.toInt()) {
      if (controller.loadMore.value) {
        pageNo++;
        print("_scrollListener pageNo:- $pageNo");
        controller.notificationList_API(pageNo,);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx((){
        return  Scaffold(
          body:  SingleChildScrollView(physics: BouncingScrollPhysics(),
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    scrolledUnderElevation: 0,
                    elevation: 0.0,
                    centerTitle: true,
                    leadingWidth: 25,
                    leading: GestureDetector(
                      onTap: () {
                        msc.selectedTab.value = 0;
                       // Get.offAllNamed(RouteHelper.mainScreen);
                      },
                      child: Image.asset(
                        MyAssetsImage.app_menu,
                        color: MyColor.app_white_color,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: MyColor.app_orange_color.value??Color(0xFFFF4300),
                    ),
                    child: Center(
                      child: RichText(
                          text: TextSpan(
                            text: "PUSH ",
                            style: MyTextStyle.textStyle(
                                FontWeight.w500, 17, MyColor.app_button_text_dynamic_color,letterSpacing: 1.48),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "NOTIFICATIONS",
                                  style: MyTextStyle.textStyle(
                                      FontWeight.w900, 17, MyColor.app_button_text_dynamic_color,letterSpacing: 1.48)),
                            ],
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  controller.notificationList.isNotEmpty?InkWell(
                    onTap: () {
                      showDialogBox(
                        MyString.ClearAllNotificaton_var,
                        MyString.cancel_var,
                            () {
                          Get.back();
                        },
                            () {
                          Get.back();
                        },
                      );
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Clear All Notifications",
                        textAlign: TextAlign.center,
                        style: MyTextStyle.textStyle(
                            FontWeight.w500, 14, MyColor.app_white_color),
                      ),
                    ),
                  ):Align(
                    alignment: Alignment.center,
                    child: Text(
                      "No Items to Display",
                      textAlign: TextAlign.center,
                      style: MyTextStyle.textStyle(
                          FontWeight.w600, 15, MyColor.app_white_color),
                    ),
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  Obx(() {
                    return ListView.builder(
                      itemCount: controller.notificationList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        var notification = controller.notificationList[index];
                        String startDate = "";
                        String startTime = "";

                        if (notification.createdAt != "") {
                          print("startDate ${notification.createdAt}");
                          startDate = DateFormat("dd MMMM yyyy").format(notification.createdAt);
                          startTime = DateFormat("hh:mm").format(notification.createdAt);
                          print("startDate---> $startDate");
                        }
                        print("read Status ${notification.readStatus}");

                        return InkWell(
                          onTap: () {
                            controller.readNotification_api(notification.id).then((success) {
                              if (success) {
                                notification.readStatus = 1;
                                controller.notificationList.refresh();
                                if(notification.eventsId!=""){
                                  print("notification.eventDate ${notification.eventDate}");
                                  msc.dateSend.value = DateTime.parse(notification.eventDate);
                                  msc.eventId.value = notification.eventsId!;
                                  msc.selectedTab.value = 5;
                                }
                                else if(notification.newsId!=""){
                                  msc.dateSend.value = DateTime.parse(notification.publicationDate);
                                  msc.eventId.value = notification.newsId!;
                                  msc.selectedTab.value = 6;
                                }else if(notification.trainingId!=""){
                                  msc.dateSend.value = DateTime.parse(notification.trainingDate);
                                  msc.eventId.value = notification.trainingId!;
                                  msc.selectedTab.value = 2;
                                }
                              } else {
                                print("Failed to mark notification as read");
                              }
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 13),
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: notification.readStatus == 0
                                  ? MyColor.app_white_color.withOpacity(MyColor.app_white_color.opacity * 0.7)
                                  : MyColor.app_white_color,
                            ),
                            child: RichText(
                              maxLines: 3,
                              text: TextSpan(
                                text: "$startDate at ${startTime} ",
                                style: MyTextStyle.textStyle(
                                  FontWeight.w500,
                                  14,
                                  MyColor.app_orange_color.value ?? Color(0xFFFF4300),
                                  lineHeight: 1.5,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "> ${notification.message}",
                                    style: MyTextStyle.textStyle(
                                      FontWeight.w500,
                                      14,
                                      MyColor.app_black_color,
                                      lineHeight: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );

                  }),
                  controller.pageLoader.value?
                  Center(child: CircularProgressIndicator(color: MyColor.app_orange_color.value))
                      :SizedBox(),
                ],
              ),
            ),
          ),
        );
      })
    );
  }

  Future<dynamic> showDialogBox(String headingFirstMSG, typeOfClick,
      VoidCallback acceptClick, declineClick) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Dialog(
                insetPadding: EdgeInsets.only(left: 20, right: 20, top: 28),
                alignment: Alignment.topCenter,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Image.asset(MyAssetsImage.app_cancel_board,
                                color: Colors.grey, width: 12)),
                      ),
                      Text(
                        "CLEAR ALL NOTIFICATIONS?",
                        style: MyTextStyle.textStyle(
                            FontWeight.w700, 18.16, MyColor.app_black_color),
                      ),
                      SizedBox(
                        height: 21,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Expanded(
                                  child: CustomView.transparentButton(
                                      typeOfClick == MyString.cancel_var
                                          ? "Cancel"
                                          : MyString.Clear_var,
                                      FontWeight.w600,
                                      3.76,
                                      18.16,
                                      Colors.grey.withOpacity(0.5),
                                      declineClick)),
                              SizedBox(
                                width: 14,
                              ),
                              typeOfClick != MyString.accept_var
                                  ? Expanded(
                                      flex: 1,
                                      child: CustomView.buttonShow(
                                          MyString.Clear_var,
                                          FontWeight.w600,
                                          3.76,
                                          18.16,
                                          MyColor.app_orange_color.value??Color(0xFFFF4300),
                                          (){
                                            controller.notificationDelete_Api().then((value) {
                                              if(value != ""){
                                                controller.notificationList_API(1);
                                                Get.back();
                                              }

                                            });
                                          }),
                                    )
                                  : SizedBox()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
