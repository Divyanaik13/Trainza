import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_runner/controller/NewsController.dart';
import 'package:club_runner/controller/TwoNewScreenController.dart';
import 'package:club_runner/util/FunctionConstant/FunctionConstant.dart';
import 'package:club_runner/util/custom_view/CustomView.dart';
import 'package:club_runner/util/text_style/MyTextStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../controller/CalendarController.dart';
import '../../../controller/MainScreenController.dart';
import '../../../models/NewsDetailModel.dart';
import '../../../service/NotificationServices.dart';
import '../../../util/asstes_image/AssetsImage.dart';
import '../../../util/const_value/ConstValue.dart';
import '../../../util/local_storage/LocalStorage.dart';
import '../../../util/my_color/MyColor.dart';
import '../../../util/route_helper/RouteHelper.dart';
import '../../../util/size_config/SizeConfig.dart';

class NewsDetailsScreen extends StatefulWidget {
  const NewsDetailsScreen({Key? key}) : super(key: key);

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  TwoNewScreenController controller = Get.put(TwoNewScreenController());
  CalendarController calendarController = Get.put(CalendarController());
  MainScreenController ms = Get.find();
  NewsController newsController = Get.put(NewsController());
  LocalStorage sp = LocalStorage();

  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var fontSize = SizeConfig.fontSize();
  var currentDate = DateTime.now().obs;

  var screenWidth = SizeConfig.screenWidth;
  var showCurrentDate = false.obs;

  ///Rishabh
  var month = "", year = "", direction = "1";

  bool openCalendar = false, isSwipe = false;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    Future.delayed(Duration.zero, () async {
      print("Date :-- ${ms.dateSend.value}");
    });
    Future.delayed(Duration.zero, () async {
      getDatesApi(currentDate.value, "1", false);
    });
    Future.delayed(Duration.zero, () async {
      if ((NotificationService.notificationPayloadModel?.date != '') &&
          (NotificationService.notificationPayloadModel?.notificationType ==
              "news")) {
        ms.eventId.value = NotificationService.notificationPayloadModel!.referenceId;
        callEventDetailAndMange(
            DateTime.parse(NotificationService.notificationPayloadModel!.date));
        print("dateSend notify news :-- ${ms.dateSend.value}");
        currentDate.value =
            DateTime.parse(NotificationService.notificationPayloadModel!.date);
        newsController.selectedDay.value =
            DateTime.parse(NotificationService.notificationPayloadModel!.date);
        newsController.focusedDay.value =
            DateTime.parse(NotificationService.notificationPayloadModel!.date);
        newsController.newsDetailList.clear();
      } else if (ms.dateSend.value != null) {
        callEventDetailAndMange(ms.dateSend.value!);
        print("dateSend notify news else:-- ${ms.dateSend.value}");
        currentDate.value = ms.dateSend.value!;
        newsController.selectedDay.value = ms.dateSend.value!;
        newsController.focusedDay.value = ms.dateSend.value!;
        newsController.newsDetailList.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 0) {
          //right swipe
          print("right CR swipe ${currentDate.value}");

          if (findFirstPreviousDate(currentDate.value) != null) {
            currentDate.value = findFirstPreviousDate(currentDate.value)!;
            callEventDetailAndMange(currentDate.value);
          } else {
            openCalendar = false;

            var dateValue =
                DateTime(currentDate.value.year, currentDate.value.month - 1);
            Future.delayed(Duration.zero, () async {
              getDatesApi(dateValue, "1", true);
            });
          }

          //}
          //}
        } else if (details.primaryVelocity! < 0) {
          //Left Swipe
          print("left swipe");
          var crDate =
              DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(currentDate.value);
          if (findNextDate(
                  DateFormat('yyyy-MM-dd HH:mm:ss.SSS').parse(crDate)) !=
              null) {
            currentDate.value = findNextDate(currentDate.value)!;
            callEventDetailAndMange(currentDate.value);
          } else {
            print("Here 123 ${currentDate.value.month}");
            openCalendar = false;
            var dateValue =
                DateTime(currentDate.value.year, currentDate.value.month + 1);
            Future.delayed(Duration.zero, () async {
              getDatesApi(dateValue, "2", true);
            });
          }
        }
      },
      child: Container(
        color: MyColor.screen_bg,
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(
                  () {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(height: 30),
                        CustomView.customAppBarWithDrawer(
                          () {
                            ConstValue.isFromNotification = false;
                            ConstValue.isCalendarDisable = false;
                            ConstValue.isPopupShow = false;
                            NotificationService.notificationPayloadModel!.date = '';
                            NotificationService.notificationPayloadModel = null;
                            ms.selectedTab.value = 0;
                            //Get.offAllNamed(RouteHelper.mainScreen);
                          },
                          () {
                            // ms.selectedTab.value = 3;
                            NotificationService.notificationPayloadModel?.date = '';
                            NotificationService.notificationPayloadModel = null;
                            showCurrentDate.value = true;
                            ConstValue.isPopupShow = true;
                            newsController.tempCurrentDate.value = currentDate.value;
                            getDatesApi(currentDate.value, "1", false).then((value) {
                              var focusedDay = Rx<DateTime>(DateTime(
                                  currentDate.value.year,
                                  currentDate.value.month,
                                  currentDate.value.day));
                              var selectedDay = Rx<DateTime>(DateTime(
                                  currentDate.value.year,
                                  currentDate.value.month,
                                  currentDate.value.day));

                              openCalendar = true;
                              CommonFunction.showCalenderDialogBox(
                                  context,
                                  selectedDay,
                                  selectedDay,
                                  heightPerBox!,
                                  fontSize,
                                  widthPerBox,
                                  newsController.newsDateTypeList.value,
                                  controller: calendarController,
                                  onClickLeftIcon: (newFocusedDay) {
                                    print("on left click : $newFocusedDay");
                                    Future.delayed(Duration.zero, () async {
                                      showCurrentDate.value = false;
                                      getDatesApi(newFocusedDay, "1", false);
                                    });
                                  }, onClickRightIcon: (newFocusedDay) {
                                print("on right click : $newFocusedDay");

                                Future.delayed(Duration.zero, () async {
                                  showCurrentDate.value = false;
                                  getDatesApi(newFocusedDay, "2", false);
                                });
                              }).then((value) {
                                print("New Value:--  $value");
                                ConstValue.isPopupShow = false;
                                if (value != null) {
                                  currentDate.value = value;
                                  callEventDetailAndMange(currentDate.value);
                                } else {
                                  newsController.focusedDay = focusedDay;
                                  newsController.selectedDay = selectedDay;
                                }
                              });
                            });
                       /*     if(newsController.newsDateTypeList.isNotEmpty && currentDate.value.month != newsController.newsDateTypeList[0].month)
                            {
                              print("test new if");
                            Future.delayed(Duration.zero, () async {
                              getDatesApi(currentDate.value, "1", false).then((value) {
                                var focusedDay = Rx<DateTime>(DateTime(
                                    currentDate.value.year,
                                    currentDate.value.month,
                                    currentDate.value.day));
                                var selectedDay = Rx<DateTime>(DateTime(
                                    currentDate.value.year,
                                    currentDate.value.month,
                                    currentDate.value.day));

                                openCalendar = true;
                                CommonFunction.showCalenderDialogBox(
                                    context,
                                    selectedDay,
                                    selectedDay,
                                    heightPerBox!,
                                    fontSize,
                                    widthPerBox,
                                    newsController.newsDateTypeList.value,
                                    controller: calendarController,
                                    onClickLeftIcon: (newFocusedDay) {
                                      print("on left click : $newFocusedDay");
                                      Future.delayed(Duration.zero, () async {
                                        showCurrentDate.value = false;
                                        getDatesApi(newFocusedDay, "1", false);
                                      });
                                    }, onClickRightIcon: (newFocusedDay) {
                                  print("on right click : $newFocusedDay");

                                  Future.delayed(Duration.zero, () async {
                                    showCurrentDate.value = false;
                                    getDatesApi(newFocusedDay, "2", false);
                                  });
                                }).then((value) {
                                  print("New Value:--  $value");
                                  if (value != null) {
                                    currentDate.value = value;
                                    callEventDetailAndMange(currentDate.value);
                                  } else {
                                    newsController.focusedDay = focusedDay;
                                    newsController.selectedDay = selectedDay;
                                  }
                                });
                              });
                            });
                            }
                            else{
                              print("test new else");
                              newsController.tempCurrentDate.value = currentDate.value;
                              getDatesApi(currentDate.value, "1", false).then((value) {
                                var focusedDay = Rx<DateTime>(DateTime(
                                    currentDate.value.year,
                                    currentDate.value.month,
                                    currentDate.value.day));
                                var selectedDay = Rx<DateTime>(DateTime(
                                    currentDate.value.year,
                                    currentDate.value.month,
                                    currentDate.value.day));

                                openCalendar = true;
                                CommonFunction.showCalenderDialogBox(
                                    context,
                                    selectedDay,
                                    selectedDay,
                                    heightPerBox!,
                                    fontSize,
                                    widthPerBox,
                                    newsController.newsDateTypeList.value,
                                    controller: calendarController,
                                    onClickLeftIcon: (newFocusedDay) {
                                      print("on left click : $newFocusedDay");
                                      Future.delayed(Duration.zero, () async {
                                        showCurrentDate.value = false;
                                        getDatesApi(newFocusedDay, "1", false);
                                      });
                                    }, onClickRightIcon: (newFocusedDay) {
                                  print("on right click : $newFocusedDay");

                                  Future.delayed(Duration.zero, () async {
                                    showCurrentDate.value = false;
                                    getDatesApi(newFocusedDay, "2", false);
                                  });
                                }).then((value) {
                                  print("New Value:--  $value");
                                  if (value != null) {
                                    currentDate.value = value;
                                    callEventDetailAndMange(currentDate.value);
                                  } else {
                                    newsController.focusedDay = focusedDay;
                                    newsController.selectedDay = selectedDay;
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
                          "NEWS",
                          currentDate,
                          MyColor.app_orange_color.value ??
                              const Color(0xFFFF4300),
                          () {
                            print("right Click ");
                            if (findFirstPreviousDate(currentDate.value) !=
                                null) {
                              currentDate.value =
                                  findFirstPreviousDate(currentDate.value)!;
                              callEventDetailAndMange(currentDate.value);
                            } else {
                              openCalendar = false;
                              var dateValue = DateTime(currentDate.value.year,
                                  currentDate.value.month - 1);
                              Future.delayed(Duration.zero, () async {
                                getDatesApi(dateValue, "1", true);
                              });
                            }
                          },
                          () {
                            print("left Click");
                            if (findNextDate(currentDate.value) != null) {
                              currentDate.value =
                                  findNextDate(currentDate.value)!;
                              callEventDetailAndMange(currentDate.value);
                            } else {
                              print("Here");
                              openCalendar = false;
                              var dateValue = DateTime(currentDate.value.year,
                                  currentDate.value.month + 1);
                              Future.delayed(Duration.zero, () async {
                                getDatesApi(dateValue, "2", true);
                              });
                            }
                          },
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        newsController.newsDetailModel.value == null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 25),
                                child: Text(
                                  "",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      height: 1.111,
                                      color: MyColor.app_white_color),
                                ),
                              )
                            : newsDetailList(),
                        const SizedBox(height: 20),
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
                                ? Image.asset(
                                    MyAssetsImage.app_trainza_ratioLogo,
                                    fit: BoxFit.fill)
                                : Image.network(
                                    LocalStorage.getStringValue(
                                        sp.currentClubData_logo),
                                    fit: BoxFit.fill),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget newsDetailList() {
    return Obx(
      () {
        if (newsController.newsDetailList.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Text(
              "No Items to Display",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.111,
                  color: MyColor.app_white_color),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: newsController.newsDetailList.value.length,
          itemBuilder: (context, index) {
            var list = newsController.newsDetailList.value[index];

            var newsInfo = list.content;

            if (newsInfo.contains("<p><br></p><p>")) {
              newsInfo = newsInfo.replaceAll("<p><br></p><p>", "");
            }
            if (newsInfo.contains("<p><br></p>")) {
              newsInfo = newsInfo.replaceAll("<p><br></p>", "");
            }
            if (newsInfo.contains("<p><br>")) {
              newsInfo = newsInfo.replaceAll("<p><br>", "");
            }

            print("list.featureImage ${list.featureImage}");

            return Column(
              children: [
                Card(
                  margin: EdgeInsets.zero,
                  elevation: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          list.title.toString(),
                          style: MyTextStyle.textStyle(
                              FontWeight.w600, 22, MyColor.app_black_color,
                              letterSpacing: -0.37, lineHeight: 1.364),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          " ${DateFormat("dd MMMM yyyy").format(DateTime.parse(list.publicationDate.toString()))}",
                          style: MyTextStyle.textStyle(FontWeight.w700, 15,
                              MyColor.app_text_dynamic_color),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        list.featureImage.toString() != "" &&
                                list.featureImage.toString() != "null" &&
                                list.featureImage.toString() != null &&
                                list.featureImage!.toString().isNotEmpty
                            ? InkWell(
                                onTap: () {
                                  List<String> imageArray = [];
                                  imageArray.add(
                                      list.featureOriginalImage.toString());
                                  Get.toNamed(
                                      RouteHelper.getFullScreenImagePreview(),
                                      arguments: {
                                        'images': imageArray,
                                        'initialIndex': index,
                                      });
                                },
                                child: AspectRatio(
                                  aspectRatio: 1.0 / 1.0,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: MyAssetsImage.app_loader,
                                        image: list.featureImage.toString(),
                                        fit: BoxFit.cover,
                                        height: heightPerBox! * 42,
                                        imageErrorBuilder: (context, error,
                                                stackTrace) =>
                                            Image.asset(
                                                MyAssetsImage.app_squanreImage,
                                                fit: BoxFit.fill,
                                                height: heightPerBox! * 42),
                                      )),
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 5),
                        list.newsGallery.isNotEmpty
                            ? GridView.builder(
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 5.0,
                                  mainAxisSpacing: 5.0,
                                ),
                                itemCount: list.newsGallery.length,
                                primary: false,
                                shrinkWrap: true,
                                itemBuilder:
                                    (BuildContext context, int Gindex) {
                                  return InkWell(
                                    onTap: () {
                                      List<String> imageArray = [];
                                      for (var value in list.newsGallery) {
                                        imageArray.add(value.image);
                                      }
                                      Get.toNamed(
                                          RouteHelper
                                              .getFullScreenImagePreview(),
                                          arguments: {
                                            'images': imageArray,
                                            'initialIndex': Gindex,
                                          });
                                    },
                                    child: AspectRatio(
                                      aspectRatio: 1.0 / 1.0,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child:
                                          FadeInImage.assetNetwork(
                                            placeholder: MyAssetsImage.app_loader,
                                            image: list.newsGallery[Gindex].thumb_image == ""?list.newsGallery[Gindex].image:list.newsGallery[Gindex].thumb_image,
                                            fit: BoxFit.contain,
                                            imageCacheHeight: 150, //adding these two parameters
                                            imageCacheWidth: 150,
                                            height: heightPerBox! * 42,
                                            imageErrorBuilder: (context, error,
                                                stackTrace) =>
                                                Image.asset(
                                                    MyAssetsImage.app_squanreImage,
                                                    fit: BoxFit.fill,
                                                    height: heightPerBox! * 42),
                                          ))
                                          )
                                      //),
                                    //),
                                  );
                                },
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 10,
                        ),

                        HtmlWidget(
                          ''' $newsInfo  ''',
                          textStyle: MyTextStyle.textStyle(
                              FontWeight.w400, 16, MyColor.app_black_color,
                              lineHeight: 1.5),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        //Button Condition
                        list.isButtonAdded == "1"
                            ? CustomView.buttonShow(
                                list.buttonLable,
                                FontWeight.w600,
                                6,
                                19.2,
                                MyColor.app_orange_color.value ??
                                    const Color(0xFFFF4300), () {
                                controller.launchUrlweb(list.buttonLink);
                              }, buttonHeight: 54)
                            : const SizedBox(),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                list.newsPoll.questionId != "null"
                    ? const SizedBox(
                        height: 10,
                      )
                    : const SizedBox(),
                list.newsPoll.questionId != "null"
                    ? pollView(list.id, list.newsPoll, index)
                    : const SizedBox(),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 17,
            );
          },
        );
      },
    );
  }

  Widget pollView(String newsId, NewsPoll newsPoll, int index) {
    var total = getTotal(newsPoll);
    return Card(
      color: MyColor.app_white_color,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      elevation: 0.0,
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text("${newsPoll.question}",
                  style: TextStyle(
                      fontFamily: GoogleFonts.manrope().fontFamily,
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      color: MyColor.app_black_color)),
              const SizedBox(
                height: 10,
              ),
              pollBarDataList(newsId.toString(), newsPoll, index, total),
              newsPoll.myAnswerId!.isEmpty
                  ? CustomView.buttonShow("VOTE NOW", FontWeight.w600, 4, 19.2,
                      MyColor.app_orange_color.value ?? const Color(0xFFFF4300),
                      () {
                      //Vote Api Call here... Rishabh
                      if (newsController.answerId.value.isNotEmpty &&
                          newsPoll.answers![newsController.indexValue.value]
                                  .answerId ==
                              newsController.answerId.value) {
                        newsController.addVote(newsId, newsController.questionId.value,
                                newsController.answerId.value)
                            .then((code) {
                          print("add vote news" + code.toString());
                          var abc = jsonDecode(code);
                          var poll = abc['data']['newsPoll'];
                          print("add vote news" + poll.toString());
                          if (abc['code'].toString() == "200") {
                          newsPoll.myAnswerId = newsController.answerId.value;
                          newsController.questionId.value = "";
                          newsController.answerId.value = "";
                          //newsPoll = NewsPoll.fromJson(poll);
                          newsPoll.answers!.clear();
                          for (var value in poll['answers']) {
                            var ans = Answer(
                                answerId: value['answerId'].toString(),
                                answer: value['answer'].toString(),
                                votes: value['votes'].toString(),
                                viewVoter: true);
                            newsPoll.answers!.add(ans);
                          }
                          newsController.newsDetailModel.refresh();
                          //addVoteToModel(newsPoll);
                          }
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
                  if (newsPoll.myAnswerId!.isNotEmpty) {
                    newsController.cancelVote_Api(newsId).then((statusCode) {
                      print("statusCodeR :--  ${statusCode}");
                      if (statusCode == "200") {
                        clearVote(newsPoll);
                      }
                    });
                  }
                },
                child: Text(
                    newsPoll.myAnswerId!.isNotEmpty
                        ? "CANCEL AND CLEAR YOUR VOTE"
                        : "VOTE TO VIEW RESULTS",
                    style: MyTextStyle.textStyle(
                        FontWeight.w600, 14, MyColor.app_text_grey_event)),
              ),
            ],
          )),
    );
  }

  void addVoteToModel(NewsPoll newsPoll) {
    newsPoll.myAnswerId = newsController.answerId.value;
    newsController.questionId.value = "";
    newsController.answerId.value = "";
    for (var value in newsPoll.answers!) {
      if (value.answerId == newsPoll.myAnswerId) {
        value.votes = (int.parse(value.votes) + 1).toString();
      }
    }
    newsController.newsDetailModel.refresh();
  }

  void clearVote(NewsPoll newsPoll) {
    if (newsPoll.myAnswerId!.isNotEmpty) {
      for (var value in newsPoll.answers!) {
        if (value.answerId == newsPoll.myAnswerId) {
          value.votes = (int.parse(value.votes) - 1).toString();
        }
      }

      newsPoll.myAnswerId = "";
      newsController.indexValue.value = -1;
      newsController.newsDetailModel.refresh();
    }
  }

  int getTotal(NewsPoll newsPoll) {
    var total = 0;
    if (newsPoll.answers != null) {
      for (int i = 0; i < newsPoll.answers!.length; i++) {
        total = total + int.parse(newsPoll.answers![i].votes);
      }
    }
    return total;
  }

  Widget pollBarDataList(
      String newsId, NewsPoll newsPoll, int maiListIndex, totalVale) {
    List<Answer> answerList = newsPoll.answers!;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: answerList.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        //For Divide and get Percent %.
        var divNumber = totalVale / int.parse(answerList[index].votes);
        divNumber.toString() == "NaN" ? divNumber = 0 : divNumber = divNumber;

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
                      if (newsPoll.myAnswerId!.isEmpty) {
                        newsController.indexValue.value = index;
                        newsController.maiListIndex.value = maiListIndex;
                        newsController.questionId.value = newsPoll.questionId!;
                        newsController.answerId.value =
                            answerList[index].answerId;
                      }
                    },
                    child: Card(
                      color: MyColor.app_textform_bg_color2,
                      margin: const EdgeInsets.only(bottom: 0),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: (newsController.indexValue.value ==
                                              index &&
                                          newsController.maiListIndex.value ==
                                              maiListIndex) ||
                                      newsPoll.myAnswerId ==
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
                                      width: newsPoll.myAnswerId!.isEmpty
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
                                          "${answerList[index].answer}",
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
                            (newsController.indexValue.value == index &&
                                        newsController.maiListIndex.value ==
                                            maiListIndex) ||
                                    newsPoll.myAnswerId ==
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
                  newsPoll.myAnswerId!.isNotEmpty
                      ? Row(
                          children: [
                            Text(
                              "${answerList[index].votes} ${int.parse(answerList[index].votes) <= 1 ? "Vote" : "Votes"}",
                              style: MyTextStyle.textStyle(
                                  FontWeight.w600, 13, MyColor.app_black_color),
                              textAlign: TextAlign.left,
                            ),
                            newsPoll.showParticipantDetails.toString() == "1" &&
                                    int.parse(answerList[index].votes) > 0
                                ? //show vote in 1
                                InkWell(
                                    onTap: () {
                                      print("view Voter");
                                      voterIndex = index;

                                      for (int i = 0;
                                          i < newsController.newsDetailList.length;
                                          i++) {
                                        for (int j = 0;
                                            j < newsController.newsDetailList[i]
                                                    .newsPoll.answers!.length;
                                            j++) {
                                          if (i != maiListIndex) {
                                            newsController
                                                .newsDetailList[i]
                                                .newsPoll
                                                .answers![j]
                                                .viewVoter = false;
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
                                        newsController.viewVoterList(
                                            newsId,
                                            answerList[index]
                                                .answerId
                                                .toString());
                                      }

                                      answerList[index].viewVoter =
                                          !answerList[index].viewVoter!;
                                      newsController.voterListNews.refresh();
                                      newsController.voterModelNews.refresh();
                                      newsController.newsDetailModel.refresh();
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
                          newsController.voterListNews.isNotEmpty
                      ? const Divider(
                          height: 0,
                          thickness: 1,
                        )
                      : SizedBox(),
                  const SizedBox(
                    height: 5,
                  ),
                  answerList[index].viewVoter!
                      ? ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 170.0,
                          ),
                          child: Obx(() {
                            return showVoterList();
                          }))
                      : SizedBox(),
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
      itemCount: newsController.voterListNews.value.length,
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
                    image: newsController.voterListNews[index]
                        .profilePicture, // "https://i.pinimg.com/736x/92/01/f3/9201f3d81c7d28ea365f18f16453d3ab.jpg"
                    placeholderFit: BoxFit.cover,
                    fit: BoxFit.cover,
                    height: 100,
                    width: 50,
                  ),
                ),
              ),
              const SizedBox(
                width: 13,
              ),
              Flexible(
                  child: CustomView.differentStyleTextTogether(
                      newsController.voterListNews[index].firstName,
                      FontWeight.w200,
                      " ${newsController.voterListNews[index].lastName}",
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

  Future<void> getDatesApi(
      DateTime currentDateRx, String direction, bool isSwipe) async {
    month = DateFormat('MM').format(currentDateRx).toString();
    year = DateFormat('yyyy').format(currentDateRx).toString();

    if (month.length > 1 && month[0] == "0") {
      month = month[1].toString();
    }
    print("Date month :-- $month/$year");

    Future.delayed(Duration.zero, () {
      newsController.newsAvailableDate(month, year, direction, (dateResponse) {
        if (newsController.newsDateList.isNotEmpty) {
          newsController.newsDateTypeList.clear();
        }else{
          openCalendar = false;
          Get.back();
        }
        if (newsController.newsDateList.isNotEmpty){

          for (var dateString in newsController.newsDateList) {
            DateTime originalDate = DateTime.parse(dateString);
            int year = originalDate.year;
            int month = originalDate.month;
            int day = originalDate.day;
            newsController.newsDateTypeList.add(DateTime(year, month, day));
          }
          newsController.newsDateTypeList.refresh();
          if (openCalendar) {
            ConstValue.isPopupShow = false;
            WidgetsFlutterBinding.ensureInitialized();
            Get.back();
            if (newsController.newsDateTypeList.isNotEmpty) {
              Future.delayed(Duration.zero).then((value) {
                var date;
                if(showCurrentDate.value){
                  date = currentDate;
                  showCurrentDate.value = false;
                }else{
                  date = Rx(newsController.newsDateTypeList[0]);
                }

                CommonFunction.showCalenderDialogBox(
                    context,
                    date,
                    date,
                    heightPerBox!,
                    fontSize,
                    widthPerBox,
                    newsController.newsDateTypeList.value,
                    controller: calendarController,
                    onClickLeftIcon: (newFocusedDay) {
                      Future.delayed(Duration.zero, () async {
                        getDatesApi(newFocusedDay, "1", false);
                      });
                    }, onClickRightIcon: (newFocusedDay) {
                  Future.delayed(Duration.zero, () async {
                    getDatesApi(newFocusedDay, "2", false);
                  });
                }).then((value) {
                  if (value != null) {
                    currentDate.value = value;
                    callEventDetailAndMange(currentDate.value);
                  } else {
                    print("crDate  :-- ${currentDate.value}");
                    currentDate.value =  newsController.tempCurrentDate.value;
                  }
                });
              });
            }
          }

        }else{
          print("object empty ${ConstValue.isPopupShow}");
          Get.back();
          if (ConstValue.isPopupShow){
            ConstValue.isPopupShow = false;
            CommonFunction.showAlertDialogdelete(context, "No Items to display", () {Get.back();});
          }
        }

        if (isSwipe) {
          if (newsController.newsDateTypeList.isNotEmpty) {
            if (direction.toString() == "1") {
              if (ConstValue.isFromLastOrPrevious) {
                ConstValue.isFromLastOrPrevious = false;
                currentDate.value = newsController.newsDateTypeList[0];
              } else {
                currentDate.value = newsController.newsDateTypeList[
                    newsController.newsDateTypeList.length - 1];
              }
            } else {
              if (ConstValue.isFromLastOrPrevious) {
                ConstValue.isFromLastOrPrevious = false;
                currentDate.value = newsController.newsDateTypeList[
                    newsController.newsDateTypeList.length - 1];
              } else {
                currentDate.value = newsController.newsDateTypeList[0];
              }
            }
          }

          Future.delayed(const Duration(milliseconds: 00), () {
            callEventDetailAndMange(currentDate.value);
          });
        }
      });
    });
  }

  void callEventDetailAndMange(DateTime currentDate) {
    newsController.newsDetailList.clear();
    newsController
        .fetchNewsDetail(
            DateFormat("yyyy-MM-dd").parse(currentDate.toString()).toString())
        .then((value) {
      for (var valueList in newsController.newsDetailList.value) {
        if (NotificationService.notificationPayloadModel?.referenceId != null) {
          print("if referenceId");
          if (NotificationService.notificationPayloadModel?.referenceId == valueList.id) {
            newsController.newsDetailList.remove(valueList);
            newsController.newsDetailList.insert(0, valueList);
          }
        }
        else {
          print("else eventId");
          if (ms.eventId == valueList.id) {
            newsController.newsDetailList.remove(valueList);
            newsController.newsDetailList.insert(0, valueList);
          }
        }

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

    for (DateTime date in newsController.newsDateTypeList) {
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
    print(
        'newsController.newsDateTypeList ${newsController.newsDateTypeList.length}');

    for (var date in newsController.newsDateTypeList) {
      print('date in loop ${date}');
      print('crdate in loop ${crDate}');
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
    super.dispose();
    Get.delete<CalendarController>();
    ms.dateSend.value = null;
    ms.eventId.value = "";
    if (ConstValue.isFromNotification) {
      //ConstValue.isFromNotification = false;
    }
  }
}
