import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:get/state_manager.dart';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/EventAvailableDateModel.dart';
import '../models/EventDetail(Date)_Model.dart';
import '../models/Event_PollVoters_Model.dart';
import '../network/ApiServices.dart';
import '../network/DioServices.dart';
import '../network/EndPointList.dart';
import '../util/FunctionConstant/FunctionConstant.dart';
import '../util/api_message_constant/ApiMsgConstant.dart';

import '../util/const_value/ConstValue.dart';
import '../util/my_color/MyColor.dart';
import '../util/size_config/SizeConfig.dart';

import '../util/text_style/MyTextStyle.dart';

class EventDetailsController extends GetxController {
  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var screenWidth = SizeConfig.screenWidth;
  var fontSize = SizeConfig.fontSize();
  TextEditingController distanceCtrl = TextEditingController();


  var members = [].obs;

  var eventDateModel = Rxn<EventDateModel>();
  var dateData = <EventDatum>[].obs;
  var eventInfoList = <EventInfo>[].obs;
  var _pace = "".obs;

  var indexValue = 0.obs;
  var maiListIndex = 0.obs;

  //For add Vote
  var questionId = "".obs;
  var answerId = "".obs;
  var voteAdded = false.obs;

  // voter list
  var voters = Rxn<EventPollVoters>();
  var pollVotersList =  <PollVotersList>[].obs;

  late Timer timer;
  Duration? timeDifference = const Duration();
  var currentDate = DateTime.now().obs;
  var tempCurrentDate = DateTime.now().obs;
  var selectedVotersList = Rxn<int>();
  var selectedVotersOptions = Rxn<int>();
  var selectMainList = Rxn<int>();
  var isGiveVote = false.obs;


  // var distance =null;
  var select_distance = Rxn<Distance>();
  var distanceid = "".obs;
  var distanceValue = "".obs;

  //for submit result
  var isSubmit = false.obs;
  var isEditClicked = false.obs;

  //get event Available Date
  var eventAvailableDateModel = Rxn<EventAvailableDateModel>();
  var eventDateList = <String>[].obs;
  var eventDateTypeList = <DateTime>[].obs;
  var selectedDay =Rx<DateTime>(DateTime.now());
  var focusedDay = Rx<DateTime>(DateTime.now());

  showVendors(int index, int indexparent) {
    if (index != selectedVotersList.value) {
      selectedVotersList.value = index;
      selectMainList.value = indexparent;
    } else {
      selectedVotersList.value = -1;
    }
  }

  selectOption(int index, int parentIndex) {
    selectedVotersOptions.value = index;
    selectMainList.value = parentIndex;
  }

  Future<void> launchUrlweb(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw Exception('Could not launch $_url');
    }
  }

  btnVote() {
    if (isGiveVote.value) {
      isGiveVote.value = false;
    } else {
      isGiveVote.value = true;
    }

    print("GGGGG " + isGiveVote.value.toString());
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsFlutterBinding.ensureInitialized();
    _calculateTimeDifference();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeDifference();
    });
  }

  void _calculateTimeDifference() {
    final now = DateTime.now();
    final defaultTime = DateTime(now.year, now.month, now.day, 12,
        0); // Assuming default time is 12:00 PM
    final difference = now.difference(defaultTime);
    if (difference.isNegative) {
      timeDifference = null;
    } else {
      timeDifference = difference;
    }
  }

  // Time
  Widget buildTimeElement(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: MyColor.app_white_color,
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: [
          Text(
            value,
            style: MyTextStyle.textStyle(FontWeight.w500, fontSize * 3.5,
                MyColor.app_orange_color.value ?? Color(0xFFFF4300)),
          ),
          Text(
            label,
            style: MyTextStyle.textStyle(
                FontWeight.w500, fontSize * 2.5, MyColor.app_black_color),
          ),
        ],
      ),
    );
  }

// showBox
  Widget showBoxData(String heading, Widget remainWidgetColumn) {
    return SizedBox(
      width: screenWidth,
      child: Card(
        color: MyColor.app_light_grey_color,
        elevation: 0.0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Column(children: [
          Card(
            elevation: 0.0,
            color: MyColor.app_white_color,
            margin: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                heading,
                style: MyTextStyle.textStyle(
                    FontWeight.w900, 15, MyColor.app_black_color),
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          remainWidgetColumn,
          SizedBox(
            height: 12,
          ),
        ]),
      ),
    );
  }

  Future<String> EventResultList_API(int pageNo, String eventId,int mainIndex) async {
    dateData[mainIndex].eventResultList.clear();
    print("Main index :-- $mainIndex");
    CommonFunction.showLoader();
    print("Headers:-- ${DioServices.getAllHeaders()}");

    try {
      var url = "${WebServices.event}/$eventId/result?&skipPaging=1";
      print("Request URL:-- $url");
      var response =
          await DioServices.getMethod(url, DioServices.getAllHeaders());
      print("EventResultList Response :-- ${response.data}");
      CommonFunction.hideLoader();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      if (response.statusCode == 200) {

        for (var i in data["eventResultList"]) {
          dateData[mainIndex].eventResultList.add(EventResultList.fromJson(i));
        }
        dateData.refresh();
        return jsonEncode(jsonResponse);
      }
      return jsonEncode(jsonResponse);
    } catch (e) {
      CommonFunction.hideLoader();
      log("Exception :-- ", error: e.toString());
      return "";
    }
  }

  // Event Date Get API
  Future<String> EventDetail_api(DateTime date) async {
    isSubmit.value = false;
    isEditClicked.value = false;
    indexValue.value = -1;
    maiListIndex.value = -1;
    distanceValue.value = "";
    distanceid.value = "";
    CommonFunction.showLoader();
    print("Headers:-- ${DioServices.getAllHeaders()}");

    var formateddate = DateFormat('yyyy-MM-dd').format(date);

    print("formateddate $formateddate");

    try {
      var url = WebServices.event + "/$formateddate";
      print("Request URL:-- $url");
      var response =
          await DioServices.getMethod(url, DioServices.getAllHeaders());
      print("Event Date Response :-- ${response.data}");
      CommonFunction.hideLoader();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode:- $statusCode");
      print("data EventDate_api :-$data");

      if (response.statusCode == 200) {
        print("response.statusCode ${response.statusCode}");
        print("Event detail :- ${dateData.value}");
        return jsonEncode(response.data);
      }
      return jsonEncode(response.data);
    } catch (e) {
      CommonFunction.hideLoader();
      log("Exception EventDetail :-- ", error: e.toString());
      return "";
    }
  }

  // Event poll voters Get API
  Future<void> Event_PollVoters_API(
      int pageNo, String answerId, String eventId) async {
    CommonFunction.showLoader();
    print("Headers:-- ${DioServices.getAllHeaders()}");

    try {
      var url = WebServices.event +
          "/$eventId/pollVoters" +
          "?pageNo=$pageNo,answerId=$answerId";
      print("Request URL:-- $url");
      var response =
          await DioServices.getMethod(url, DioServices.getAllHeaders());
      print("Event Date Response :-- ${response.data}");
      CommonFunction.hideLoader();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode:- $statusCode");
      print("data:-$data");

      if (response.statusCode == 200) {
        print("response.statusCode $response.statusCode");
        // Resultlistmodel.value = eventDetailListModelFromJson(jsonEncode(response.data));
        // members.value = Resultlistmodel.value!.data.eventResultList;
      }
    } catch (e) {
      CommonFunction.hideLoader();
      log("Exception :-- ", error: e.toString());
    }
  }

  // Event Id Result Post API
  Future<String> Event_addResults_api(String eventId, distanceId, time, pace,
      eventResultId) async {
    CommonFunction.showLoader();
    Map<String, String> body = {
      "distanceId": distanceId,
      "time": time,
      "pace": pace,
      "eventResultId": eventResultId,
    };
    print("Body:-- $body");
    var url = "${WebServices.event}/$eventId/result";
    print("url:-- $url");

    try {
      var response =
          await DioServices.postMethod(url, body, DioServices.getAllHeaders());

      CommonFunction.hideLoader();

      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("statusCode:-$statusCode");
      print("jsonResponse Event_addResults_api:-$jsonResponse");

      if (statusCode == 200) {
        return jsonEncode(response.data);
      }
      return jsonEncode(response.data);
    } catch (e) {
      CommonFunction.hideLoader();
      print("Catch error $e");
      return "";
    }
  }

  // Add Event poll vote API
  Future<String> Event_pollVote_api(String eventId, String questionIdP,
      String answerIdP, String pollVoteIdP) async {
    CommonFunction.showLoader();
    Map<String, String> body = {
      "questionId": questionIdP,
      "answerId": answerIdP,
      "pollVoteId": pollVoteIdP,
    };
    print("Body:-- $body");

    try {
      var response = await DioServices.postMethod(
        WebServices.event + "/$eventId/pollVote",
        body,
        DioServices.getAllHeaders(),
      );
      print("Event_PollVote_Api Reasponce ${response.data}");
      CommonFunction.hideLoader();
      // LocalStorage sp = LocalStorage();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("statusCode:-$statusCode");
      print("data:-$data");

      if (statusCode == 200) {
        print("success ");
        voteAdded.value = true;
      }
      return jsonEncode(jsonResponse);
    } catch (e) {
      CommonFunction.hideLoader();
      print("Catch error $e");
    }
    return "";
  }

  //cancel or clear vote
  Future<String> cancelVote_Api(BuildContext context,String eventId) async {
    pollVotersList.value.clear();
    CommonFunction.showLoader();

    print("Headers:-- ${ApiService.getAllHeaders()}");

    var url = WebServices.event+"/$eventId/cancelVote";

    print("Cancel vote url : - $url");

    try {
      var response = await ApiService.deleteData(
          url, ApiService.getAllHeaders());
      print("Delete Account Response -${response.body}");

      CommonFunction.hideLoader();

      var jsonResponse = jsonDecode(response.body);

      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("statusCode:-$statusCode");
      print("data:-$data");
      String responseMessage = ApiMsgConstant.getResponseMessage(statusCode.toString());

      if (statusCode == 200) {
        return statusCode.toString();
      }else{
        return responseMessage;
      }

    } catch (e) {
      print("Catch error $e");
    }
    return ApiMsgConstant.getResponseMessage("500");
  }

  // Event poll voters Get API
  Future<void> Event_pollVoters_api(int pageNo, String answerId, String eventId) async {
    CommonFunction.showLoader();
    pollVotersList.value.clear();
    print("Headers:-- ${DioServices.getAllHeaders()}");

    try {
      var url = WebServices.event + "/$eventId/pollVoters" + "?answerId=$answerId&skipPaging=1";

      print("Request URL Event_PollVoters:-- $url");
      var response =
      await DioServices.getMethod(url, DioServices.getAllHeaders());
      print("Event Date Response :-- ${response.data}");
      CommonFunction.hideLoader();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode:- $statusCode");
      print("data:-$data");
      String responseMessage = ApiMsgConstant.getResponseMessage(statusCode.toString());

      if (statusCode == 200) {
        voters.value = eventPollVotersFromJson(jsonEncode(response.data));
        pollVotersList.value.addAll(voters.value!.data.pollVotersList);
        voters.refresh();
        pollVotersList.refresh();
      }
    } catch (e) {
      CommonFunction.hideLoader();
      log("Exception :-- ", error: e.toString());
    }
  }

  /// Event getEventDates available
  Future<void> eventAvailableDate(String month, year,direction,Function(DateTime) funCall)async{

    CommonFunction.showLoader();

    try{
      print("eventAvailableDate month year :-- $month $year");
      var url = "/getEventDates?month=$month&year=$year&direction=$direction";
      print("url :-- $url");

      var response = await DioServices.getMethod("${WebServices.event}$url", DioServices.getAllHeaders());
      CommonFunction.hideLoader();
      print("eventAvailableDate response :-- ${response.data}");

      eventAvailableDateModel.value = eventAvailableDateModelFromJson(jsonEncode(response.data));

      if (eventAvailableDateModel.value!.data.eventDates.isEmpty){
        ConstValue.isFromLastOrPrevious = true;
      }

      if(eventAvailableDateModel.value != null){
        var year = int.parse(eventAvailableDateModel.value!.data.year);
        var month = int.parse(eventAvailableDateModel.value!.data.month);

        //selectedDay.value = DateTime(year, month, 01);
        // focusedDay.value = DateTime(year, month, 01);
        eventDateList.value = eventAvailableDateModel.value!.data.eventDates;

        if(year != null){
          Future.delayed(Duration.zero, () async {
            funCall(DateTime(year, month, 01));
          });
        }


        // funCall(DateTime(year, month, 01));
      }

    }catch(e){
      CommonFunction.hideLoader();
      log("Exception :-- ", error: e.toString());
    }
  }

}
