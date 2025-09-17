import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import '../models/ResultListModel.dart';
import '../network/DioServices.dart';
import '../network/EndPointList.dart';
import '../util/FunctionConstant/FunctionConstant.dart';

class ResultScreenController extends GetxController{

  var resultList = <MemberResultList>[].obs;
  var resultModel = Rxn<ResultListModel>();
  var loadMore = false.obs;
  var loaderNewFetchList = false.obs;
  var pageNumber = 0.obs;


  // Get api function
  Future<void> raceResultList_API(int pageNo) async {
    print("pageNo $pageNo");
    if (pageNumber == 0 || pageNumber == 1) {
      resultModel.value = null;
      resultList.clear();
      CommonFunction.showLoader();
    } else {
      loaderNewFetchList.value = true;
    }

    print("Headers:-- ${DioServices.getAllHeaders()}");

    try {
      var url = WebServices.resultList+"?pageNo=$pageNo";
      print("Request URL:-- $url");
      var response = await DioServices.getMethod(url, DioServices.getAllHeaders());
      print("Result Date Response :-- ${response.data}");
      CommonFunction.hideLoader();
      loaderNewFetchList.value = false;
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode:- $statusCode");
      print("data:-$data");

      if(response.statusCode == 200){
        resultModel.value = resultListModelFromJson(jsonEncode(response.data));
        print("result Module :--- ${resultModel.value}");
        resultList.value.addAll(resultModel.value!.data.memberResultList);
        loadMore.value = resultModel.value!.data.loadMore;

        print("loadMore results :--${loadMore.value}");

        resultList.refresh();
        resultModel.refresh();


      }
    } catch (e) {
      CommonFunction.hideLoader();
      loaderNewFetchList.value = false;
      log("Exception :-- ", error: e.toString());
    }
  }
}