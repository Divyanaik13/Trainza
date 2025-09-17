import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../models/EventListModel.dart';
import '../network/DioServices.dart';
import '../network/EndPointList.dart';
import '../util/FunctionConstant/FunctionConstant.dart';

class EventController extends GetxController {
  var listmodel = Rxn<EventListModel>();
  var eventList = [].obs;
  var loadMore = false.obs;
  var pageLoader = false.obs;

  var REPEATING_DAYS = [
    {
      "id": 1,
      "day": "Sun",
    },
    {
      "id": 2,
      "day": "Mon",
    },
    {
      "id": 3,
      "day": "Tues",
    },
    {
      "id": 4,
      "day": "Wed",
    },
    {
      "id": 5,
      "day": "Thu",
    },
    {
      "id": 6,
      "day": "Fri",
    },
    {
      "id": 7,
      "day": "Sat",
    },
  ];

  // Event List Get API
  Future<void> EventList_API(int pageNo, String eventDate) async {
    if (pageNo == 0 || pageNo == 1) {
      CommonFunction.showLoader();
      eventList.clear();
    } else {
      pageLoader.value = true;
    }
    print("Headers:-- ${DioServices.getAllHeaders()}");

    try {
      var url = WebServices.event + "?pageNo=$pageNo&eventDate=$eventDate";
      var response =
          await DioServices.getMethod(url, DioServices.getAllHeaders());
      print("Event List Response :-- ${response.data}");
      CommonFunction.hideLoader();
      pageLoader.value = false;
      var jsonResponse = response.data;
      var statusCode = jsonResponse["code"];
      var data = jsonResponse["data"];
      print("statusCode:- $statusCode");
      print("data:- $data");

      if (response.statusCode == 200) {
        print("response.statusCode ${response.statusCode}");

        listmodel.value = eventListModelFromJson(jsonEncode(response.data));
        eventList.value.addAll(listmodel.value!.data.eventList);
        loadMore.value = listmodel.value!.data.loadMore;

        listmodel.refresh();
        eventList.refresh();
        print("loadmore ${loadMore.value}");
        print("pageNo $pageNo");

        /* if (loadMore == true) {
          pageNo++;
          print("pageNo ++ :- $pageNo");
        }*/
      }
    } catch (e) {
      CommonFunction.hideLoader();
      pageLoader.value = false;
      log("Exception :-- ", error: e.toString());
    }
  }
}
