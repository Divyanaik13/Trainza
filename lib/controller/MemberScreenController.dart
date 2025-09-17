import 'dart:convert';
import 'dart:developer';

import 'package:club_runner/models/MembersClubModel.dart';
import 'package:club_runner/network/DioServices.dart';
import 'package:club_runner/network/EndPointList.dart';
import 'package:club_runner/util/FunctionConstant/FunctionConstant.dart';
import 'package:get/get.dart';

import '../util/size_config/SizeConfig.dart';

class MemberScreenController extends GetxController{
  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var fontSize = SizeConfig.fontSize();
  Rx<bool> search = true.obs;

  List<Map<String, String>> listMap = [
    {"title": "Andrew", "subTitle": "Barnes"},
    {"title": "Bennie", "subTitle": "McCarthy"},
    {"title": "Clive", "subTitle": "Simpkins"},
    {"title": "Diana", "subTitle": "Kelpworth"},
    {"title": "Frank", "subTitle": "Bannerman"},
    {"title": "Geraid", "subTitle": "yapp"},
  ];

  //For fetch member
  var loadMoreValue = false.obs;
  var fetchMemberModel = Rxn<MembersClubModel>();
  var fetchMemberList = <MemberList>[].obs;
  var pageNo = 1;
  var showLoaderMember = false.obs;

  Future<void> fetchMemberClubList(int pageNo,String searchName) async{
    if(pageNo == 1){
      fetchMemberList.clear();
      CommonFunction.showLoader();
    }else{
      showLoaderMember.value = true;
    }


     var query = "?pageNo=$pageNo&search=$searchName";
     print("query :-- $query");
    try{

      var response= await DioServices.getMethod(
          "${WebServices.clubMemberFetchList}$query", DioServices.getAllHeaders());
      CommonFunction.hideLoader();
      showLoaderMember.value = false;
      print("fetchMember response :-- ${response.data}");

      var jsonResponse = response.data;

      var code = jsonResponse["code"];
      var data = jsonResponse["data"];
       loadMoreValue.value = data["loadMore"];

       print(loadMoreValue.value);

      if(code.toString() == "200"){
        fetchMemberModel.value = membersClubModelFromJson(jsonEncode(response.data));
          fetchMemberList.addAll(fetchMemberModel.value!.data.memberList);

          print("fetchMemberList count :-- ${fetchMemberModel.value!.data.count}");

      }



    }catch(e){
      log("Exception :-- ",error: e.toString());
      CommonFunction.hideLoader();
      showLoaderMember.value = false;
    }
  }
}