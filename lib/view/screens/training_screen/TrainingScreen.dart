import 'package:club_runner/controller/CalendarController.dart';
import 'package:club_runner/controller/TrainingController.dart';
import 'package:club_runner/util/FunctionConstant/FunctionConstant.dart';
import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:club_runner/util/route_helper/RouteHelper.dart';
import 'package:club_runner/util/string_const/MyString.dart';
import 'package:club_runner/util/text_style/MyTextStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controller/MainScreenController.dart';
import '../../../service/NotificationServices.dart';
import '../../../util/asstes_image/AssetsImage.dart';
import '../../../util/custom_view/CustomView.dart';
import '../../../util/local_storage/LocalStorage.dart';
import '../../../util/size_config/SizeConfig.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var fontSize = SizeConfig.fontSize();
  CalendarController controller = Get.put(CalendarController());

  trainingController trnController = Get.put(trainingController());
  MainScreenController ms = Get.find();

  var currentDate = DateTime.now().obs;
  final _selectedDay = DateTime.now().obs;
  final _focusedDay = DateTime.now().obs;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Future.delayed(Duration.zero, () async {
      if ((NotificationService.notificationPayloadModel?.date != '') &&
          (NotificationService.notificationPayloadModel?.notificationType ==
              "training")) {
        print("dateSend notify news 1:-- ${NotificationService.notificationPayloadModel!.date}");
        ms.eventId.value = NotificationService.notificationPayloadModel!.referenceId;
        ms.dateSend.value = DateTime.parse(NotificationService.notificationPayloadModel!.date);
        if(ms.dateSend.value!=null){
          currentDate.value = ms.dateSend.value!;
          ms.dateSend.value = null;
        }
       // trnController.TrainingList_API(currentDate.value);
        callEventDetailAndMange(currentDate.value);

        print("dateSend notify news :-- ${ms.dateSend.value}");
        // currentDate.value =
        //     DateTime.parse(NotificationService.notificationPayloadModel!.date);
        // _selectedDay.value =
        //     DateTime.parse(NotificationService.notificationPayloadModel!.date);
        // _focusedDay.value =
        //     DateTime.parse(NotificationService.notificationPayloadModel!.date);
        trnController.trainingList.clear();
      }else{
        print("ms.dateSend.value ${ms.dateSend.value}");
        if(ms.dateSend.value!=null){
          currentDate.value = ms.dateSend.value!;
          ms.dateSend.value = null;
        }
       // trnController.TrainingList_API(currentDate.value!);
        callEventDetailAndMange(currentDate.value);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Swipe code
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 0) {
          print("right swap");
          //right swipe
          currentDate.value =
              currentDate.value.subtract(const Duration(days: 1));
          trnController.TrainingList_API(currentDate.value);
        } else if (details.primaryVelocity! < 0) {
          //Left Swipe
          print("Left swap");
          currentDate.value = currentDate.value.add(const Duration(days: 1));
          trnController.TrainingList_API(currentDate.value);
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
                      ms.selectedTab.value = 0;
                      //Get.offAllNamed(RouteHelper.mainScreen);
                    },
                    () {
                      CommonFunction.showCalenderDialogBox(
                              context,
                              _focusedDay,
                              _selectedDay,
                              heightPerBox!,
                              fontSize,
                              widthPerBox,
                              trnController.trainingDateList.value,
                              controller: controller)
                          .then((value) {
                        print("New Value:--  $value");
                        if (value != null) {
                          currentDate.value = value;
                          trnController.TrainingList_API(currentDate.value);
                          currentDate.refresh();
                        }
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomView.cardViewDateClick(
                    MyString.training_var,
                    currentDate,
                    MyColor.app_orange_color.value ?? Color(0xFFFF4300),
                    () {
                      _decrementDate();
                      trnController.TrainingList_API(currentDate.value);
                    },
                    () {
                      _incrementDate();
                      trnController.TrainingList_API(currentDate.value);
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  _listShow(),
                  trnController.birthDayData.isNotEmpty
                      ? InkWell(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.only(top: 15),
                            width: SizeConfig.screenWidth,
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: MyColor.app_orange_color.value ??
                                    Color(0xFFFF4300),
                                borderRadius: BorderRadius.circular(4.0)),
                            child: CustomView.differentStyleTextTogether(
                                MyString.happy_birthday_var.substring(0, 5),
                                FontWeight.w900,
                                MyString.happy_birthday_var.substring(5),
                                FontWeight.w300,
                                17,
                                MyColor.app_button_text_dynamic_color,
                                letterSpacing: 1.48,
                                lineHeight: 1.176),
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 13,
                  ),
                  userNameShow(),
                  SizedBox(height: 20),
                  SizedBox(
                    height: ((SizeConfig.screenWidth)! -
                            (SizeConfig.screenWidth! * 40 / 100)) /
                        1.62,
                    width: (SizeConfig.screenWidth)! -
                        (SizeConfig.screenWidth! * 40 / 100),
                    child: LocalStorage.getStringValue(
                                trnController.sp.currentClubData_logo) ==
                            ""
                        ? Image.asset(MyAssetsImage.app_trainza_ratioLogo,
                            fit: BoxFit.fill)
                        : Image.network(
                            LocalStorage.getStringValue(
                                trnController.sp.currentClubData_logo),
                            fit: BoxFit.fill),
                  ),
                ],
              ),
            ),
          );
        })),
      ),
    );
  }

  void _incrementDate() {
    currentDate.value = currentDate.value.add(const Duration(days: 1));
  }

  void _decrementDate() {
    currentDate.value = currentDate.value.subtract(const Duration(days: 1));
  }

  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw Exception('Could not launch $_url');
    }
  }

  Widget _listShow() {
    return Obx(() {
      if (trnController.trainingList.isEmpty) {
        return Padding(
          padding: const EdgeInsets.only(
            top: 25,
          ),
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
      return ListView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: trnController.trainingList.length,
        itemBuilder: (context, index) {
          var training = trnController.trainingList[index];
          print("Training item: $training");
          print("Video link : ${training.workout.videoLink}");
          String startTime;

          if (training.trainingTime != "") {
            DateTime dateTime =
                DateFormat("HH:mm").parse(training.trainingTime);
            startTime = DateFormat("HH:mm").format(dateTime);

            print("training.trainingTime --> ${training.trainingTime}");
            print("startTime : $startTime");
          } else {
            startTime = "DO:IT";
          }

          print("Distance unit ${training.routeInfo.distanceUnit}");
          print("Distance ${training.routeInfo.distance}");
          print("Images length ${training.workout.images.length}");

          var workoutInfo = training.workout.details;
          var routeInfo = training.routeInfo.routeDetail;

          if (workoutInfo.contains("<p><br></p><p>") ||
              routeInfo.contains("<p><br></p><p>")) {
            workoutInfo = workoutInfo.replaceAll("<p><br></p><p>", "");
            routeInfo = routeInfo.replaceAll("<p><br></p><p>", "");
          }
          if (workoutInfo.contains("<p><br></p>") ||
              routeInfo.contains("<p><br></p>")) {
            workoutInfo = workoutInfo.replaceAll("<p><br></p>", "");
            routeInfo = routeInfo.replaceAll("<p><br></p>", "");
          }
          if (workoutInfo.contains("<p><br>") ||
              routeInfo.contains("<p><br>")) {
            workoutInfo = workoutInfo.replaceAll("<p><br>", "");
            routeInfo = routeInfo.replaceAll("<p><br>", "");
          }

          return Card(
              color: MyColor.app_white_color,
              margin: const EdgeInsets.only(bottom: 15),
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0)),
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: 80,
                            margin: EdgeInsets.only(
                              top: 10,
                              // bottom: 10,
                              left: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
                              color: MyColor.app_orange_color.value ??
                                  Color(0xFFFF4300),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              color: MyColor.app_white_color,
                              border: Border.all(
                                width: 0.0,
                                color: MyColor.app_white_color,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  training.groups[0].name.toString(),
                                  style: MyTextStyle.textStyle(FontWeight.w600,
                                      20, MyColor.app_black_color,
                                      letterSpacing: -0.2),
                                ),
                                Text(
                                  training.groups[0].subtitle.toString() ==
                                          "null"
                                      ? "NA"
                                      : training.groups[0].subtitle.toString(),
                                  style: MyTextStyle.textStyle(FontWeight.w500,
                                      14, MyColor.app_black_color,
                                      lineHeight: 1.222),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ))
                        ]),
                  ),
                  IntrinsicHeight(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            alignment: Alignment.topCenter,
                            width: 80,
                            padding:
                                EdgeInsets.only(left: 10, right: 10),
                            margin: EdgeInsets.only(
                              // top: 10,
                              bottom: 10,
                              left: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(5.0)),
                              color: MyColor.app_orange_color.value ??
                                  Color(0xFFFF4300),
                            ),
                            child: Text(
                              startTime,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: MyTextStyle.textStyle(FontWeight.w700, 18,
                                  MyColor.app_button_text_dynamic_color,
                                  letterSpacing: 0.5),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: MyColor.app_white_color,
                                border: Border.all(
                                  width: 0.0,
                                  color: MyColor.app_white_color,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    training.workout.workoutType,
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w600,
                                        18,
                                        MyColor.app_black_color,
                                        lineHeight: 1.3),
                                  ),
                                  training.routeInfo.distance == "null"
                                      ? SizedBox()
                                      : const SizedBox(height: 18),
                                  training.routeInfo.distance == "null"
                                      ? SizedBox()
                                      : Text(
                                          training.routeInfo.routeName,
                                          style: MyTextStyle.textStyle(
                                              FontWeight.w600,
                                              18,
                                              MyColor.app_black_color,
                                              lineHeight: 1.3),
                                        ),
                                  training.routeInfo.distance == "null"
                                      ? SizedBox()
                                      : const SizedBox(height: 3),
                                  Text(
                                    training.routeInfo.distance == "null" ? ""
                                        : training.routeInfo.distance.toString() +
                                            (training.routeInfo.distanceUnit ==
                                                        1
                                                    ? ' KM'
                                                    : ' MI')
                                                .toString(),
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w700,
                                        22,
                                        MyColor.app_black_color,
                                        letterSpacing: 0.5),
                                  ),
                                  training.routeInfo.distance == "null"
                                      ? SizedBox()
                                      : SizedBox(height: 11),
                                  HtmlWidget(
                                    '''$workoutInfo''',
                                    textStyle: MyTextStyle.textStyle(
                                        FontWeight.w500,
                                        16,
                                        MyColor.app_black_color,
                                        lineHeight: 1.5),
                                  ),
                                  const SizedBox(height: 10),
                                  training.workout.images.length >= 3
                                      ? Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                List<String> imageArray =
                                                    training.workout.images;
                                                Get.toNamed(
                                                  RouteHelper
                                                      .getFullScreenImagePreview(),
                                                  arguments: {
                                                    'images': imageArray,
                                                    'initialIndex': 0,
                                                  },
                                                );
                                              },
                                              child: Container(
                                                width: SizeConfig.screenWidth,
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                  child: Image.network(
                                                    training.workout.images[0],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                List<String> imageArray =
                                                    training.workout.images;
                                                Get.toNamed(
                                                  RouteHelper
                                                      .getFullScreenImagePreview(),
                                                  arguments: {
                                                    'images': imageArray,
                                                    'initialIndex': 1,
                                                  },
                                                );
                                              },
                                              child: Container(
                                                width: SizeConfig.screenWidth,
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                  child: Image.network(
                                                    training.workout.images[1],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                List<String> imageArray =
                                                    training.workout.images;
                                                Get.toNamed(
                                                  RouteHelper
                                                      .getFullScreenImagePreview(),
                                                  arguments: {
                                                    'images': imageArray,
                                                    'initialIndex': 2,
                                                  },
                                                );
                                              },
                                              child: Container(
                                                width: SizeConfig.screenWidth,
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                  child: Image.network(
                                                    training.workout.images[2],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : training.workout.images.length == 2
                                          ? Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    List<String> imageArray =
                                                        training.workout.images;
                                                    Get.toNamed(
                                                      RouteHelper.getFullScreenImagePreview(),
                                                      arguments: {
                                                        'images': imageArray,
                                                        'initialIndex': 0,
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    width:
                                                        SizeConfig.screenWidth,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4.0)),
                                                      child: Image.network(
                                                        training
                                                            .workout.images[0],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    List<String> imageArray =
                                                        training.workout.images;
                                                    Get.toNamed(
                                                      RouteHelper
                                                          .getFullScreenImagePreview(),
                                                      arguments: {
                                                        'images': imageArray,
                                                        'initialIndex': 1,
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    width:
                                                        SizeConfig.screenWidth,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4.0)),
                                                      child: Image.network(
                                                        training
                                                            .workout.images[1],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : training.workout.images.length == 1
                                              ? InkWell(
                                                  onTap: () {
                                                    List<String> imageArray =
                                                        training.workout.images;
                                                    Get.toNamed(
                                                      RouteHelper
                                                          .getFullScreenImagePreview(),
                                                      arguments: {
                                                        'images': imageArray,
                                                        'initialIndex': 0,
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    width:
                                                        SizeConfig.screenWidth,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4.0)),
                                                      child: Image.network(
                                                        training
                                                            .workout.images[0],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      training.routeInfo.routeLink != "" &&
                                              training.routeInfo.routeLink.isNotEmpty
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                  top: 3, bottom: 5, right: 8),
                                              width: (SizeConfig.screenWidth! - 40) * 0.2,
                                              child: InkWell(
                                                  onTap: () {
                                                    _launchUrl(training
                                                        .routeInfo.routeLink);
                                                  },
                                                  child:
                                                      CustomView.trainingBlock(
                                                    "ROUTE",
                                                    "LINK",
                                                    MyAssetsImage.app_route,
                                                  )),
                                            )
                                          : Container(),
                                      training.routeInfo.routeImage != "" &&
                                              training.routeInfo.routeName.isNotEmpty
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                  top: 3, bottom: 5, right: 8),
                                              width: (SizeConfig.screenWidth! -
                                                      40) *
                                                  0.2,
                                              child: InkWell(
                                                onTap: () {
                                                  Map<String, String>? data = {
                                                    "imageUrl": training
                                                        .routeInfo.routeImage
                                                        .toString(),
                                                    "routeName": training
                                                        .routeInfo.routeName,
                                                    "distance":
                                                        '${training.routeInfo.distance}${training.routeInfo.distanceUnit == 1 ? ' KM' : ' MI'}',
                                                    "routeDetail": routeInfo,
                                                  };
                                                  Get.toNamed(
                                                      RouteHelper.getViewRouteScreen(),
                                                      parameters: data);
                                                },
                                                child: CustomView.trainingBlock(
                                                    "ROUTE",
                                                    "INFO",
                                                    MyAssetsImage
                                                        .app_routeimage),
                                              ),
                                            )
                                          : Container(),
                                      training.workout.videoLink != "" &&
                                              training
                                                  .workout.videoLink.isNotEmpty
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                top: 3,
                                                bottom: 5,
                                              ),
                                              width: (SizeConfig.screenWidth! -
                                                      40) *
                                                  0.2,
                                              child: InkWell(
                                                  onTap: () {
                                                    var video = {
                                                      "videolink": training
                                                          .workout.videoLink,
                                                    };
                                                    print(
                                                        "Video link ----> $video");
                                                    Get.toNamed(
                                                            RouteHelper
                                                                .getViewVideoScreen(),
                                                            parameters: video)!
                                                        .then((value) {
                                                      print("GGGGG");
                                                      SystemChrome
                                                          .setPreferredOrientations([
                                                        DeviceOrientation
                                                            .portraitDown,
                                                        DeviceOrientation
                                                            .portraitUp,
                                                      ]);
                                                    });
                                                  },
                                                  child:
                                                      CustomView.trainingBlock(
                                                          "VIEW",
                                                          "VIDEO",
                                                          MyAssetsImage
                                                              .app_video)),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  )
                ],
              )
              /*  IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // first container
                  Container(
                    padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                        // top: training.groups[0].subtitle.length <= 100
                        //     ? training.groups[0].subtitle.length.toDouble()+50
                        //     : 64),
                        top: 65),
                    margin: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color:
                          MyColor.app_orange_color.value ?? Color(0xFFFF4300),
                    ),
                    child: Text(
                      startTime,
                      style: MyTextStyle.textStyle(FontWeight.w700, 18,
                          MyColor.app_button_text_dynamic_color,
                          letterSpacing: 0.5),
                    ),
                  ),

                  // second container
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: MyColor.app_white_color,
                        border: Border.all(
                          width: 0.0,
                          color: MyColor.app_white_color,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            training.groups[0].name.toString(),
                            style: MyTextStyle.textStyle(
                                FontWeight.w600, 20, MyColor.app_black_color,
                                letterSpacing: -0.2),
                          ),
                          Text(
                            training.groups[0].subtitle.toString(),
                            style: MyTextStyle.textStyle(
                                FontWeight.w500, 14, MyColor.app_black_color,
                                lineHeight: 1.222),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            training.workout.workoutType,
                            style: MyTextStyle.textStyle(
                                FontWeight.w600, 18, MyColor.app_black_color,
                                lineHeight: 1.3),
                          ),
                          training.routeInfo.distance == "null"
                              ? SizedBox()
                              : const SizedBox(height: 18),
                          training.routeInfo.distance == "null"
                              ? SizedBox()
                              : Text(
                                  training.routeInfo.routeName,
                                  style: MyTextStyle.textStyle(FontWeight.w600,
                                      18, MyColor.app_black_color,
                                      lineHeight: 1.3),
                                ),
                          training.routeInfo.distance == "null"
                              ? SizedBox()
                              : const SizedBox(height: 3),
                          Text(
                            training.routeInfo.distance == "null"
                                ? ""
                                : training.routeInfo.distance.toString() +
                                    (training.routeInfo.distanceUnit == 1
                                            ? ' KM'
                                            : ' MI')
                                        .toString(),
                            style: MyTextStyle.textStyle(
                                FontWeight.w700, 22, MyColor.app_black_color,
                                letterSpacing: 0.5),
                          ),
                          training.routeInfo.distance == "null"
                              ? SizedBox()
                              : SizedBox(height: 11),
                          HtmlWidget(
                            '''$workoutInfo''',
                            textStyle: MyTextStyle.textStyle(
                                FontWeight.w500, 16, MyColor.app_black_color,
                                lineHeight: 1.5),
                          ),
                          const SizedBox(height: 10),
                          training.workout.images.length >= 3
                              ? Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        List<String> imageArray =
                                            training.workout.images;
                                        Get.toNamed(
                                          RouteHelper
                                              .getFullScreenImagePreview(),
                                          arguments: {
                                            'images': imageArray,
                                            'initialIndex': 0,
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: SizeConfig.screenWidth,
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                          child: Image.network(
                                            training.workout.images[0],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        List<String> imageArray =
                                            training.workout.images;
                                        Get.toNamed(
                                          RouteHelper
                                              .getFullScreenImagePreview(),
                                          arguments: {
                                            'images': imageArray,
                                            'initialIndex': 1,
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: SizeConfig.screenWidth,
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                          child: Image.network(
                                            training.workout.images[1],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        List<String> imageArray =
                                            training.workout.images;
                                        Get.toNamed(
                                          RouteHelper
                                              .getFullScreenImagePreview(),
                                          arguments: {
                                            'images': imageArray,
                                            'initialIndex': 2,
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: SizeConfig.screenWidth,
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                          child: Image.network(
                                            training.workout.images[2],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : training.workout.images.length == 2
                                  ? Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            List<String> imageArray =
                                                training.workout.images;
                                            Get.toNamed(
                                              RouteHelper
                                                  .getFullScreenImagePreview(),
                                              arguments: {
                                                'images': imageArray,
                                                'initialIndex': 0,
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: SizeConfig.screenWidth,
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                              child: Image.network(
                                                training.workout.images[0],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            List<String> imageArray =
                                                training.workout.images;
                                            Get.toNamed(
                                              RouteHelper
                                                  .getFullScreenImagePreview(),
                                              arguments: {
                                                'images': imageArray,
                                                'initialIndex': 1,
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: SizeConfig.screenWidth,
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                              child: Image.network(
                                                training.workout.images[1],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : training.workout.images.length == 1
                                      ? InkWell(
                                          onTap: () {
                                            List<String> imageArray =
                                                training.workout.images;
                                            Get.toNamed(
                                              RouteHelper
                                                  .getFullScreenImagePreview(),
                                              arguments: {
                                                'images': imageArray,
                                                'initialIndex': 0,
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: SizeConfig.screenWidth,
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                              child: Image.network(
                                                training.workout.images[0],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox(),

                          const SizedBox(height: 10),
                          Stack(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                training.routeInfo.routeLink != "" &&
                                        training.routeInfo.routeLink.isNotEmpty
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            top: 3, bottom: 5, right: 8),
                                        width: (SizeConfig.screenWidth! - 40) *
                                            0.21,
                                        child: InkWell(
                                            onTap: () {
                                              _launchUrl(
                                                  training.routeInfo.routeLink);
                                            },
                                            child: CustomView.trainingBlock(
                                              "ROUTE",
                                              "LINK",
                                              MyAssetsImage.app_route,
                                            )),
                                      )
                                    : Container(),
                                training.routeInfo.routeImage != "" &&
                                        training.routeInfo.routeName.isNotEmpty
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            top: 3, bottom: 5, right: 10),
                                        width: (SizeConfig.screenWidth! - 40) *
                                            0.22,
                                        child: InkWell(
                                          onTap: () {
                                            Map<String, String>? data = {
                                              "imageUrl": training
                                                  .routeInfo.routeImage
                                                  .toString(),
                                              "routeName":
                                                  training.routeInfo.routeName,
                                              "distance":
                                                  '${training.routeInfo.distance}${training.routeInfo.distanceUnit == 1 ? ' KM' : ' MI'}',
                                              "routeDetail": routeInfo,
                                            };
                                            Get.toNamed(
                                                RouteHelper
                                                    .getViewRouteScreen(),
                                                parameters: data);
                                          },
                                          child: CustomView.trainingBlock(
                                              "ROUTE",
                                              "INFO",
                                              MyAssetsImage.app_routeimage),
                                        ),
                                      )
                                    : Container(),
                                training.workout.videoLink != "" &&
                                        training.workout.videoLink.isNotEmpty
                                    ? Container(
                                        margin: EdgeInsets.only(
                                          top: 3,
                                          bottom: 5,
                                        ),
                                        width: (SizeConfig.screenWidth! - 40) *
                                            0.22,
                                        child: InkWell(
                                            onTap: () {
                                              var video = {
                                                "videolink":
                                                    training.workout.videoLink,
                                              };
                                              print("Video link ----> $video");
                                              Get.toNamed(
                                                      RouteHelper
                                                          .getViewVideoScreen(),
                                                      parameters: video)!
                                                  .then((value) {
                                                print("GGGGG");
                                                SystemChrome
                                                    .setPreferredOrientations([
                                                  DeviceOrientation
                                                      .portraitDown,
                                                  DeviceOrientation.portraitUp,
                                                ]);
                                              });
                                            },
                                            child: CustomView.trainingBlock(
                                                "VIEW",
                                                "VIDEO",
                                                MyAssetsImage.app_video)),
                                      )
                                    : Container(),
                              ],
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),*/
              );
        },
      );
    });
  }

  Widget userNameShow() {
    return Obx(() => ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: trnController.birthDayData.length,
          itemBuilder: (context, index) {
            var birthday = trnController.birthDayData[index];
            print("Birthday -----> $birthday");
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    height: (SizeConfig.screenWidth! - 40) * 0.21,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: MyColor.app_white_color,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(3.79)),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 110.0),
                            width: (SizeConfig.screenWidth! - 110 - 40 - 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  birthday.firstName,
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  style: MyTextStyle.textStyle(FontWeight.w300,
                                      19, MyColor.app_black_color),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  birthday.lastName,
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  style: MyTextStyle.textStyle(FontWeight.w600,
                                      19, MyColor.app_black_color),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: MyColor.app_white_color,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: MyColor.app_white_color, width: 2),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: FadeInImage.assetNetwork(
                        placeholder: MyAssetsImage.app_loader,
                        placeholderFit: BoxFit.cover,
                        image: birthday.profilePicture,
                        fit: BoxFit.cover,
                        height: (SizeConfig.screenWidth! - 40) * 0.21 + 4,
                        width: (SizeConfig.screenWidth! - 40) * 0.21 + 4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }

  void callEventDetailAndMange(DateTime currentDate) {
    trnController.trainingList.clear();
    trnController.TrainingList_API(currentDate)
        .then((value) {
          print("ddddd ${trnController.trainingList.length}");
      for (var valueList in trnController.trainingList.value) {
        if (NotificationService.notificationPayloadModel != null && NotificationService.notificationPayloadModel!.referenceId.isNotEmpty) {
          print("if referenceId");
          if (NotificationService.notificationPayloadModel?.referenceId == valueList.id) {
            trnController.trainingList.remove(valueList);
            trnController.trainingList.insert(0, valueList);
            NotificationService.notificationPayloadModel?.referenceId = "";
            NotificationService.notificationPayloadModel=null;
            ms.eventId.value = "";
          }else{
            print("notification else");
          }
        }
        else {
          if (ms.eventId.value == valueList.id) {
            print("if eventId ${ms.eventId.value}");
            trnController.trainingList.remove(valueList);
            trnController.trainingList.insert(0, valueList);
            ms.eventId.value = "";
          }else{
            print("else eventId ${ms.eventId.value}");
          }
        }

      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    NotificationService.notificationPayloadModel?.referenceId = "";
    NotificationService.notificationPayloadModel=null;
    ms.eventId.value = "";
    trnController.trainingList.clear();
    Get.delete<CalendarController>();
  }
}
