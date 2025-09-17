import 'package:club_runner/util/asstes_image/AssetsImage.dart';
import 'package:club_runner/util/custom_view/CustomView.dart';
import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:club_runner/util/route_helper/RouteHelper.dart';
import 'package:club_runner/util/text_style/MyTextStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controller/EventScreenController.dart';
import '../../../controller/ResultScreenController.dart';
import '../../../util/size_config/SizeConfig.dart';
import '../../../util/string_const/MyString.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  ResultScreenController resultController = Get.put(ResultScreenController());
  EventController eventcon = Get.put(EventController());

  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var screenWidth = SizeConfig.screenWidth;
  var screenHeight = SizeConfig.screenHeight;
  var fontSize = SizeConfig.fontSize();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    resultController.pageNumber.value = 1;
    resultController.raceResultList_API(resultController.pageNumber.value);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        // Button
        floatingActionButton: InkWell(
          onTap: () async {
            var getData = await Get.toNamed(RouteHelper.getRaceResultScreen());
            print("getData :-- ${getData}");
            if (getData == "refresh") {
              resultController.raceResultList_API(0);
              return;
            }
          },
          child: Container(
              height: 54,
              margin: EdgeInsets.only(left: 40, right: 8),
              padding: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: MyColor.app_orange_color.value ?? Color(0xFFFF4300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: CustomView.differentStyleTextTogether(
                        MyString.add_var,
                        FontWeight.w400,
                        MyString.aresult_var,
                        FontWeight.w600,
                        17,
                        MyColor.app_button_text_dynamic_color),
                  ),
                  // SizedBox(width: widthPerBox! * 30),
                  // Icon(
                  //   Icons.arrow_forward_ios,
                  //   color: MyColor.app_white_color,
                  // )
                  Image.asset(
                    MyAssetsImage.app_arrow_white,
                    height: 20,
                    width: 10,
                    color: MyColor.app_button_text_dynamic_color,
                  )
                ],
              )),
        ),
        body: Container(
          height: screenHeight,
          padding: EdgeInsets.only(bottom: 80),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                CustomView.customAppBar(MyString.race_var, MyString.result__var,
                    () {
                  Get.back(result: "refresh");
                }),
                SizedBox(
                  height: 30,
                ),
                resultController.resultList.isEmpty? Align(
                  alignment: Alignment.center,
                  child: Text(
                    "No Results to Display",
                    textAlign: TextAlign.center,
                    style: MyTextStyle.textStyle(
                        FontWeight.w600, 15, MyColor.app_white_color),
                  ),
                ):Obx(() {
                  return Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: resultController.resultList.value.length,
                      itemBuilder: (context, index) {
                        var result = resultController.resultList.value[index];
                        var distanceUnit = result.distanceUnit.toString() == "1"
                            ? " KM"
                            : " MI";
                        var date;
                        var day;

                        if (result.startDate != "null" &&
                            result.startDate != "" &&
                            result.startDate != null) {
                          date = DateFormat(' d MMM yyyy')
                              .format(DateTime.parse(result.startDate));
                          day = DateFormat('EE')
                              .format(DateTime.parse(result.startDate));
                        } else {
                          date = "";
                        }

                        if (result.repeatingDays == "null" ||
                            result.repeatingDays == "" ||
                            result.repeatingDays == null) {
                          print("111222");
                          day = "";
                        } else {
                          print("repeatingDays 123 ${result.repeatingDays}");
                          day = eventcon.REPEATING_DAYS.firstWhere((element) =>
                              element['id'] ==
                              int.parse(result.repeatingDays))['day'];
                        }

                        return InkWell(
                          onTap: () async {
                            var data = {
                              "resultId": result.id,
                              "index": index.toString()
                            };
                            var getData = await Get.toNamed(
                                RouteHelper.getEditRaceEventScreen(),
                                parameters: data);
                            print("getData $getData");
                            if (getData != null) {
                              print("getData $getData");

                              if (getData == "refresh") {
                                resultController.raceResultList_API(0);
                                return;
                              }

                              result.pace = getData['pace'];
                              result.distance =
                                  double.parse(getData['distance']);
                              result.result = getData['eventResult'];
                              index = int.parse(getData['index']);

                              print("pace ${result.pace}");
                              print("distance ${result.distance}");
                              print("eventresult ${result.result}");
                              print("index $index");

                              resultController.resultList.refresh();
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border:
                                    Border.all(color: MyColor.app_white_color)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  result.title,
                                  style: MyTextStyle.textStyle(FontWeight.w700,
                                      14, MyColor.app_white_color),
                                ),
                                day == ""
                                    ? CustomView.differentStyleTextTogether(
                                        day,
                                        FontWeight.w600,
                                        date,
                                        FontWeight.w400,
                                        14,
                                        MyColor.app_white_color)
                                    : Text(
                                        day.toString(),
                                        style: MyTextStyle.textStyle(
                                            FontWeight.w600,
                                            13,
                                            MyColor.app_text_dynamic_color,
                                            letterSpacing: -0.3),
                                      ),
                                Text(
                                  "${result.pace.toString()} - ${result.distance.toString() + distanceUnit} - ${result.result.toString()}",
                                  // "4:34p/km - 42.2KM - 4:35:32",
                                  style: MyTextStyle.textStyle(FontWeight.w400,
                                      14, MyColor.app_white_color),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
                resultController.loaderNewFetchList.value
                    ? Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: MyColor.app_orange_color.value,
                        ),
                      )
                    : const SizedBox(height: 22),
              ],
            ),
          ),
        ),
      );
    });
  }

  void scrollListener() {
    if (scrollController.offset.toInt() ==
        scrollController.position.maxScrollExtent.toInt()) {
      if (resultController.loadMore.value) {
        resultController.pageNumber.value++;
        print(
            "_scrollListener pageNo:- ${resultController.pageNumber.value}");
        resultController.raceResultList_API(resultController.pageNumber.value);
      }
    }
  }
}
