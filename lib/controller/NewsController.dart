import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:club_runner/models/NewsDetailModel.dart';
import 'package:club_runner/models/NewsListModel.dart';
import 'package:club_runner/models/voterListModel.dart';
import 'package:club_runner/network/DioServices.dart';
import 'package:club_runner/network/EndPointList.dart';
import 'package:club_runner/util/FunctionConstant/FunctionConstant.dart';
import 'package:club_runner/util/const_value/ConstValue.dart';
import 'package:club_runner/util/local_storage/LocalStorage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/NewsAvailableDateModel.dart';
import '../network/ApiServices.dart';
import '../util/api_message_constant/ApiMsgConstant.dart';

class NewsController extends GetxController {
  LocalStorage sp = LocalStorage();

  var newsModel = Rxn<NewsListModel>();
  var newsFetchList = <NewsList>[].obs;
  var loadMore = false.obs;
  var loaderNewFetchList = false.obs;
  var pageNumber = 0.obs;

  //For News Fetch Detail
  var newsDetailModel = Rxn<NewsDetailModel>();
  var newsDetailList = <NewsDatum>[].obs;
  var indexValue =0.obs;
  var maiListIndex =0.obs;

  //For add Vote
  var questionId = "".obs;
  var answerId = "".obs;
  var voteAdded = false.obs;

  //For show voter list..
  var voterModelNews = Rxn<VoterListModel>();
  var voterListNews = <PollVotersList>[].obs;

  //get event Available Date
  var newsAvailableDateModel = Rxn<NewsAvailableDateModel>();
  var newsDateList = <String>[].obs;
  var newsDateTypeList = <DateTime>[].obs;
  var selectedDay =Rx<DateTime>(DateTime.now());
  var focusedDay = Rx<DateTime>(DateTime.now());
  var tempCurrentDate = DateTime.now().obs;

  //Fetch News List
  Future<void> fetchNewsList(int pageNumber) async {

    if (pageNumber == 0 || pageNumber == 1) {
      newsModel.value = null;
      newsFetchList.clear();
      CommonFunction.showLoader();
    } else {
      loaderNewFetchList.value = true;
    }

    var query = "?pageNo=$pageNumber";
    print("Query :-- $query");

    try {
      var response = await DioServices.getMethod(
          WebServices.fetchNewList + query, DioServices.getAllHeaders());
      print("NewList response :-- ${response.data}");
      CommonFunction.hideLoader();
      loaderNewFetchList.value = false;
      newsModel.value = newsListModelFromJson(jsonEncode(response.data));

      loadMore.value = bool.parse(newsModel.value!.data.loadMore);
      if (newsModel.value != null) {
        newsFetchList.addAll(newsModel.value!.data.newsList);
      }
    } catch (e) {
      CommonFunction.hideLoader();
      loaderNewFetchList.value = false;
      log("Exception :-- ", error: e.toString());
    }
  }

  //Fetch News Detail
  Future<void> fetchNewsDetail(String date) async {
    CommonFunction.showLoader();
    voterListNews.clear();
    newsDetailModel.value = null;
    indexValue.value = -1;
    maiListIndex.value = -1;
    newsDetailList.clear();
    print("query date :- $date");

    try {
      var response = await DioServices.getMethod(
          "${WebServices.fetchNewDetail}$date", DioServices.getAllHeaders());

      print("News Detail response :-- ${response.data}");
      CommonFunction.hideLoader();

      newsDetailModel.value =
          newsDetailModelFromJson(jsonEncode(response.data));
      if (newsDetailModel.value != null) {
        newsDetailList.clear();
        newsDetailList.addAll(newsDetailModel.value!.data.newsData);
      }
    } catch (e) {
      CommonFunction.hideLoader();
      log("Exception :-- ", error: e.toString());
    }
  }

  //Add Vote to poll
   Future<String> addVote(String newsId, questionIdP,answerIdP)async{
     voterListNews.clear();
    CommonFunction.showLoader();
    Map<String,String> addVoteMap = {
      "questionId" : questionIdP,
      "answerId" : answerIdP
    };
    print("addVoteMap :-  $addVoteMap");

    var query  = "$newsId/pollVote";
    print("addVote query :-  $addVoteMap");

    try{
      var response = await DioServices.postMethod("${WebServices.addVote}$query", addVoteMap, DioServices.getAllHeaders());
      print("Add Vote Response :-- ${response.data}");
      CommonFunction.hideLoader();


      var jsonResponse = response.data;


     var code = jsonResponse["code"].toString();

     if(code == "200"){
       voteAdded.value = true;
     }

     return jsonEncode(jsonResponse);
    }catch(e){
      CommonFunction.hideLoader();
      log("Exception :-- ",error: e.toString());
    }
    return "";
}

  //Cancel vote
  Future<String> cancelVote_Api(String newsId) async {
    voterListNews.clear();
    CommonFunction.showLoader();

    print("Headers:-- ${ApiService.getAllHeaders()}");

    try {
      var url = WebServices.cancelVote + "$newsId/cancelVote";
      print("Request URL:-- $url");
      var response = await ApiService.deleteData(
          url, ApiService.getAllHeaders());
      print("cancelVote Responce -${response.body}");

      CommonFunction.hideLoader();

      var jsonResponse = jsonDecode(response.body);

      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];

      print("statusCode:- $statusCode");
      print("data:- $data");
      String responseMessage = ApiMsgConstant.getResponseMessage(statusCode.toString());

      if (statusCode == 200) {

        print("cancelVote Success : ${response.body}");

        return statusCode.toString();
      }
      else{
        return responseMessage;
      }

    } catch (e) {
      print("Catch error $e");
    }
    return ApiMsgConstant.getResponseMessage("500");
  }

  Future<void> viewVoterList(String newsId,answerId)async{
    voterListNews.clear();
    CommonFunction.showLoader();

    var viewVoterUrl = WebServices.viewVoterListNews + "$newsId/pollVoters?answerId=$answerId&skipPaging=1";

    print("viewVoterUrl :-- $viewVoterUrl");

    try{
      var response = await DioServices.getMethod(viewVoterUrl, DioServices.getAllHeaders());
      CommonFunction.hideLoader();
      print("view Voter list response :-- ${response.data}");

      voterModelNews.value = voterListModelFromJson(jsonEncode(response.data));

      if(voterModelNews != null){
        voterListNews.value.addAll(voterModelNews.value!.data.pollVotersList);
        voterModelNews.refresh();
        voterListNews.refresh();
      }

    }catch(e){
      CommonFunction.hideLoader();
      log("Exception :-- ",error:  e.toString());
    }


  }

  /// Event getEventDates available
  Future<void> newsAvailableDate(String month, year,direction,Function(DateTime) funCall)async{

    CommonFunction.showLoader();

    try{

      var url = "/getNewsDates?month=$month&year=$year&direction=$direction";
      print("url :-- $url");

      var response = await DioServices.getMethod("${WebServices.fetchNewList}$url", DioServices.getAllHeaders());
      CommonFunction.hideLoader();
      print("newsAvailableDate response :-- ${response.data}");


      newsAvailableDateModel.value = newsAvailableDateModelFromJson(jsonEncode(response.data));

      if (newsAvailableDateModel.value!.data.newsDates.length==0){
        ConstValue.isFromLastOrPrevious = true;
      }

      if(newsAvailableDateModel.value != null){
        var year = int.parse(newsAvailableDateModel.value!.data.year);
        var month = int.parse(newsAvailableDateModel.value!.data.month);

        newsDateList.value = newsAvailableDateModel.value!.data.newsDates;

        print("newsDateList response :-- ${newsDateList.value}");

        if(year != null){
          Future.delayed(Duration.zero, () async {
            funCall(DateTime(year, month, 01));
          });
        }

      }

    }catch(e){
      CommonFunction.hideLoader();
      log("Exception news :-- ", error: e.toString());
    }
  }
}
