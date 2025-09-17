import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/TrainingList_Model.dart';
import '../network/DioServices.dart';
import '../network/EndPointList.dart';
import '../util/FunctionConstant/FunctionConstant.dart';
import '../util/local_storage/LocalStorage.dart';

class trainingController extends GetxController{

  var trainingmodel = Rxn<TrainingListModel>();
  var trainingList = <TrainingList>[].obs;
  var birthDayData =<BirthDayDatum>[].obs;
  var trainingDateList = <DateTime>[].obs;
  LocalStorage sp = LocalStorage();

  Future<void> TrainingList_API(DateTime date) async {
    CommonFunction.showLoader();
    print("Headers:-- ${DioServices.getAllHeaders()}");
    // trainingList.clear();
    var formateddate = DateFormat('yyyy-MM-dd').format(date);

    try {
      var url = WebServices.trainingList+"/$formateddate";
      print("Request URL:-- $url");
      var response = await DioServices.getMethod(url, DioServices.getAllHeaders());
      print("Training Date Response :-- ${response.data}");
      CommonFunction.hideLoader();
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode:- $statusCode");
      print("data:-$data");


      if(response.statusCode == 200){
        trainingmodel.value = trainingListModelFromJson(jsonEncode(response.data));
        trainingList.value = trainingmodel.value!.data.trainingList;
        birthDayData.value = trainingmodel.value!.data.birthDayData;
        trainingDateList.value = trainingmodel.value!.data.calendarData;
        print("trainingList :-- " + jsonEncode(trainingList.value.length));
      }
    } catch (e) {
      CommonFunction.hideLoader();
      log("Exception :-- ", error: e.toString());
    }
  }
}