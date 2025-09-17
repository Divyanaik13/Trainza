import 'package:club_runner/controller/MainScreenController.dart';
import 'package:club_runner/controller/NewsController.dart';
import 'package:club_runner/util/asstes_image/AssetsImage.dart';
import 'package:club_runner/util/const_value/ConstValue.dart';
import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:club_runner/util/string_const/MyString.dart';
import 'package:club_runner/util/text_style/MyTextStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../../controller/CalendarController.dart';
import '../../../network/EndPointList.dart';
import '../../../util/FunctionConstant/FunctionConstant.dart';
import '../../../util/custom_view/CustomView.dart';
import '../../../util/local_storage/LocalStorage.dart';
import '../../../util/size_config/SizeConfig.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var screenWidth = SizeConfig.screenWidth;
  var fontSize = SizeConfig.fontSize();
  var currentDate = DateTime.now().obs;
  final _selectedDay = DateTime.now().obs;
  final _focusedDay = DateTime.now().obs;
  LocalStorage sp = LocalStorage();
  CalendarController controller = Get.put(CalendarController());
  NewsController newsController = Get.put(NewsController());
  MainScreenController ms = Get.find();
  ScrollController scrollController = ScrollController();
  bool openCalendar = false;
  bool ispopup = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    WidgetsFlutterBinding.ensureInitialized();
    newsController.pageNumber.value = 1;
    newsController.fetchNewsList(newsController.pageNumber.value);
    getDatesApi(_selectedDay.value,"1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Obx(
          () {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              controller: scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  CustomView.customAppBarWithDrawer(
                    () {
                      //ConstValue.isFromNotification = false;
                      ConstValue.isCalendarDisable = false;
                      ConstValue.isPopupShow = false;
                      ms.selectedTab.value = 0;
                    //  Get.offAllNamed(RouteHelper.mainScreen);
                    },
                    () {
                     // ms.selectedTab.value = 6;
                      _selectedDay.value = DateTime.now();
                      _focusedDay.value = DateTime.now();
                      ConstValue.isPopupShow = true;
                      getDatesApi(_focusedDay.value,"1").then((value) {
                        print("value ");
                        openCalendar = true;
                        CommonFunction.showCalenderDialogBox(
                            context,
                            _focusedDay,
                            _selectedDay,
                            heightPerBox!,
                            fontSize,
                            widthPerBox,
                            newsController.newsDateTypeList.value,
                            controller: controller,
                            // disable: true,
                            onClickLeftIcon: (newFocusedDay){
                              print("on left click : $newFocusedDay");
                              getDatesApi(newFocusedDay,"1");
                            },
                            onClickRightIcon: (newFocusedDay){
                              print("on right click : $newFocusedDay");
                            //  getDatesApi(newFocusedDay, "2");
                              final today = DateTime.now();
                              if (newFocusedDay.isAfter(today)) {
                                print("Cannot select a future date: $newFocusedDay");
                              } else {
                                print("on right click : $newFocusedDay");
                                getDatesApi(newFocusedDay, "2");
                              }
                            }
                        ).then((date) {
                          ConstValue.isPopupShow = false;
                          print("New Value:--  $date");
                          if(date != null){
                            ms.dateSend.value = date;
                            ms.selectedTab.value = 6;
                          }
                        });
                      });

                     /* if(newsController.newsDateList.isEmpty){
                        ispopup = true;
                      }
                       if(!ispopup){
                         getDatesApi(_focusedDay.value,"1").then((value) {
                           print("value ");
                           openCalendar = true;
                           CommonFunction.showCalenderDialogBox(
                               context,
                               _focusedDay,
                               _selectedDay,
                               heightPerBox!,
                               fontSize,
                               widthPerBox,
                               newsController.newsDateTypeList.value,
                               controller: controller,
                               // disable: true,
                               onClickLeftIcon: (newFocusedDay){
                                 print("on left click : $newFocusedDay");
                                 getDatesApi(newFocusedDay,"1");
                               },
                               onClickRightIcon: (newFocusedDay){
                                 print("on right click : $newFocusedDay");
                                 getDatesApi(newFocusedDay, "2");
                                 final today = DateTime.now();
                                 if (newFocusedDay.isAfter(today)) {
                                   print("Cannot select a future date: $newFocusedDay");
                                 } else {
                                   print("on right click : $newFocusedDay");
                                   getDatesApi(newFocusedDay, "2");
                                 }
                               }
                           ).then((date) {
                             print("New Value:--  $date");
                             if(date != null){
                               ms.dateSend.value = date;
                               ms.selectedTab.value = 6;
                             }
                           });

                         });
                       }else{
                         CommonFunction.showAlertDialogdelete(context, "No Items to display", () {Get.back();});
                       }*/


                    /*  if(newsController.newsDateTypeList.isNotEmpty&&_selectedDay.value.month != newsController.newsDateTypeList[0].month){
                        getDatesApi(_focusedDay.value,"1").then((value) {
                          openCalendar = true;
                          CommonFunction.showCalenderDialogBox(
                              context,
                              _focusedDay,
                              _selectedDay,
                              heightPerBox!,
                              fontSize,
                              widthPerBox,
                              newsController.newsDateTypeList.value,
                              controller: controller,
                              // disable: true,
                              onClickLeftIcon: (newFocusedDay){
                                print("on left click : $newFocusedDay");
                                getDatesApi(newFocusedDay,"1");
                              },
                              onClickRightIcon: (newFocusedDay){
                                print("on right click : $newFocusedDay");
                                getDatesApi(newFocusedDay, "2");
                                */
                      /*  final today = DateTime.now();
                            if (newFocusedDay.isAfter(today)) {
                              print("Cannot select a future date: $newFocusedDay");
                            } else {
                              print("on right click : $newFocusedDay");
                              getDatesApi(newFocusedDay, "2");
                            }*/
                      /*
                              }
                          ).then((date) {
                            print("New Value:--  $date");
                            if(date != null){
                              ms.dateSend.value = date;
                              ms.selectedTab.value = 6;
                            }
                          });
                        });
                      }
                      else{
                        getDatesApi(_focusedDay.value,"1").then((value) {
                          print("value ");

                           openCalendar = true;
                            CommonFunction.showCalenderDialogBox(
                                context,
                                _focusedDay,
                                _selectedDay,
                                heightPerBox!,
                                fontSize,
                                widthPerBox,
                                newsController.newsDateTypeList.value,
                                controller: controller,
                                // disable: true,
                                onClickLeftIcon: (newFocusedDay){
                                  print("on left click : $newFocusedDay");
                                  getDatesApi(newFocusedDay,"1");
                                },
                                onClickRightIcon: (newFocusedDay){
                                  print("on right click : $newFocusedDay");
                                  getDatesApi(newFocusedDay, "2");
                              final today = DateTime.now();
                            if (newFocusedDay.isAfter(today)) {
                              print("Cannot select a future date: $newFocusedDay");
                            } else {
                              print("on right click : $newFocusedDay");
                              getDatesApi(newFocusedDay, "2");
                            }
                                }
                            ).then((date) {
                              print("New Value:--  $date");
                              if(date != null){
                                ms.dateSend.value = date;
                                ms.selectedTab.value = 6;
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
                    height: 40,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 5),
                    width: screenWidth,
                    decoration: BoxDecoration(
                        color: MyColor.app_orange_color.value ??
                            const Color(0xFFFF4300),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      MyString.news_var,
                      style: MyTextStyle.textStyle(
                          FontWeight.w900, 17, MyColor.app_button_text_dynamic_color,
                          letterSpacing: 1.48),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  newsController.newsModel.value == null
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
                      : showNewsList(),
                  newsController.loaderNewFetchList.value
                      ? Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: MyColor.app_orange_color.value,
                          ),
                        )
                      : const SizedBox(height: 22),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child:
                        SizedBox(
                          height: ((SizeConfig.screenWidth)!-(SizeConfig.screenWidth!*40/100))/1.62,
                          width: (SizeConfig.screenWidth)!-(SizeConfig.screenWidth!*40/100),
                         child: LocalStorage.getStringValue(
                                  sp.currentClubData_logo) ==
                              ""
                          ? Image.asset(MyAssetsImage.app_trainza_ratioLogo,
                              fit: BoxFit.fill)
                          : Image.network(
                              LocalStorage.getStringValue(
                                  sp.currentClubData_logo),
                              fit: BoxFit.fill),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget showNewsList() {
    if (newsController.newsFetchList.isEmpty) {
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
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: newsController.newsFetchList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          var date = DateFormat('dd MMMM yyyy')
              .format(newsController.newsFetchList[index].publicationDate);
          return InkWell(
            onTap: () {
              ms.dateSend.value =newsController.newsFetchList[index].publicationDate;
              ms.eventId.value = newsController.newsFetchList[index].id;
              ms.selectedTab.value = 6;
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
                          color: Color(0xFF3F3F3F),
                          padding: newsController
                              .newsFetchList[index].featureImage
                              .contains(WebServices.club_url)
                              ? EdgeInsets.all(4)
                              : EdgeInsets.zero,
                          height: 100,
                          width: 100,
                          child: FadeInImage.assetNetwork(
                            placeholder: MyAssetsImage.app_loader,
                            placeholderFit: BoxFit.contain,
                            image: newsController
                                .newsFetchList[index].featureImage,
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
                            newsController.newsFetchList.value[index].title,
                            maxLines: 3,
                            style: MyTextStyle.textStyle(
                                FontWeight.w600, 16, MyColor.app_black_color,
                                letterSpacing: -0.3),
                            overflow:TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            date,
                            style: MyTextStyle.textStyle(FontWeight.w600, 13,
                                MyColor.app_text_dynamic_color,
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
        });
  }

  Future<void> getDatesApi(DateTime currentDate,String direction)async{

    var month = DateFormat('MM').format(currentDate).toString();
    var  year = DateFormat('yyyy').format(currentDate).toString();

    if(month.length >1 && month[0] == "0"){
      month = month[1].toString();
    }
    print("Date month :-- $month/$year");

    newsController.newsAvailableDate(month, year,direction,(dateResponse){}).then((response) {

      print("newsAvailableDate 12345 ${newsController.newsDateList}");

      if(newsController.newsDateList.isNotEmpty){
        newsController.newsDateTypeList.clear();
        for(var dateString in newsController.newsDateList){
          DateTime originalDate = DateTime.parse(dateString);
          int year = originalDate.year;
          int month = originalDate.month;
          int day = originalDate.day;
          newsController.newsDateTypeList.add(DateTime(year, month, day));
        }
        newsController.newsDateTypeList.refresh();
        if(newsController.newsDateTypeList.isNotEmpty){
          _focusedDay.value = newsController.newsDateTypeList[0];
          _selectedDay.value = newsController.newsDateTypeList[0];
        }

        if(openCalendar){
          ConstValue.isPopupShow = false;
          Get.back();
          if(newsController.newsDateTypeList.isNotEmpty){
            CommonFunction.showCalenderDialogBox(
                context,
                _focusedDay,
                _selectedDay,
                heightPerBox!,
                fontSize,
                widthPerBox,
                newsController.newsDateTypeList.value,
                controller: controller,
                onClickLeftIcon: (newFocusedDay){
                  getDatesApi(newFocusedDay,"1");
                },
                onClickRightIcon: (newFocusedDay){

                  getDatesApi(newFocusedDay,"2");
                })
                .then((date) {
              print("New Value:--  $date");

              if(date != null){
                ms.dateSend.value = date;
                ms.selectedTab.value = 6;
              }
            });
          }
        }
      }else{

        Get.back();
        if (ConstValue.isPopupShow){
          ConstValue.isPopupShow = false;
           CommonFunction.showAlertDialogdelete(context, "No Items to display", () {Get.back();});
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("news dispose");
    Get.delete<CalendarController>();
  }

  void scrollListener() {
    if (scrollController.offset.toInt() == scrollController.position.maxScrollExtent.toInt()) {
      if (newsController.loadMore.value) {
        newsController.pageNumber.value++;
        print("_scrollListener pageNo:- ${newsController.pageNumber.value}");
        newsController.fetchNewsList(newsController.pageNumber.value);
      }
    }
  }
}
