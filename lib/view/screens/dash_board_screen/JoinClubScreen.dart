import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controller/dashboardController.dart';
import '../../../network/EndPointList.dart';
import '../../../util/asstes_image/AssetsImage.dart';
import '../../../util/custom_view/CustomView.dart';
import '../../../util/my_color/MyColor.dart';
import '../../../util/string_const/MyString.dart';

class JoinClubScreen extends StatefulWidget {
  const JoinClubScreen({super.key});

  @override
  State<JoinClubScreen> createState() => _JoinClubScreenState();
}

class _JoinClubScreenState extends State<JoinClubScreen> {
  DeshboardController db_controller = Get.put(DeshboardController());
  TextEditingController searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  int pageNo = 1;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    _scrollController.addListener(_scrollListener);
    db_controller.clubListApi(pageNo.toString(), searchController.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColor.screen_bg,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                CustomView.customAppBar(
                    MyString.joinClub_var.toString().substring(0, 4),
                    MyString.joinClub_var.toString().substring(4), () {
                  Get.back(result: "refresh");
                }),
              SizedBox(height: 20),
             Obx((){
               return
                 db_controller.clubList.isNotEmpty || db_controller.clubListModel.value != null?
                 ListView.builder(
                   controller: _scrollController,
                 shrinkWrap: true,
                 physics: NeverScrollableScrollPhysics(),
                 itemCount: db_controller.clubList.length,
                 itemBuilder: (BuildContext context, int index) {
                   var club = db_controller.clubList[index];
                   return Container(
                     decoration: BoxDecoration(
                         color: MyColor.app_white_color,
                         borderRadius:
                         const BorderRadius.all(Radius.circular(5.0))),
                     margin: const EdgeInsets.only(bottom: 15),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Container(
                           margin: const EdgeInsets.all(0.0),
                           decoration: BoxDecoration(
                               color: MyColor.app_white_color,
                               borderRadius:
                               const BorderRadius.all(Radius.circular(5.0))),
                           child: Row(
                             children: [
                               Card(
                                   elevation: 0.0,
                                   color: MyColor.screen_bg,
                                   shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(5.0)),
                                   child: Container(
                                       height: 80,
                                       width: 131.2,
                                       padding: club.appLogoFilename
                                          .contains(WebServices.club_url)
                                          ? EdgeInsets.all(4)
                                          : EdgeInsets.zero,
                                       // color: MyColor.app_white_color,
                                       decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(4),
                                         color: Color(0xFF3F3F3F),
                                       ),
                                       child: ClipRRect(
                                         borderRadius: BorderRadius.circular(4),
                                         child: Image.network(
                                           club.appLogoFilename,
                                           height: 80,
                                           width: 131.2,
                                           fit: BoxFit.contain,
                                         ),
                                       ))),
                               Flexible(
                                 child: Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Text(
                                     club.clubName,
                                     maxLines: 3,
                                     style: TextStyle(
                                         color: MyColor.screen_bg,
                                         fontFamily:
                                         GoogleFonts.manrope().fontFamily,
                                         fontWeight: FontWeight.w600,
                                         fontSize: 17),
                                   ),
                                 ),
                               )
                             ],
                           ),
                         ),
                         club.requestId == ""?  Container(
                           padding: const EdgeInsets.symmetric(horizontal: 80.0,vertical: 5),
                           decoration: BoxDecoration(
                             color: Colors.grey.withOpacity(0.5),
                           ),
                           child: CustomView.transparentButton(
                               MyString.request_var,
                               FontWeight.w500,
                               4.32,
                               16.8,
                               Colors.grey.withOpacity(0.5), () {
                             db_controller.memberJoinRequestApi(club.id);
                           }),
                         ):
                         Container(
                           padding: const EdgeInsets.symmetric(horizontal: 80.0,vertical: 5),
                           decoration: BoxDecoration(
                             color: Colors.grey.withOpacity(0.5),
                           ),
                           child: CustomView.buttonShow(
                             MyString.cancelRequest_var,
                             FontWeight.w500,
                             4.32,
                             16.8,
                             MyColor.app_orange_color.value ??
                                 Color(0xFFFF4300),
                                 () {
                               db_controller.cancelJoinRequest(club.requestId);
                             },
                           ),
                         ),
                       ],
                     ),
                   );
                 },
               ):Center(
                 child: Text(
                     MyString.noClubsToDisplay_var,
                     style: TextStyle(
                       color: MyColor.app_white_color,
                       fontWeight: FontWeight.w500,
                       fontSize: 15),
                   ),
               );
             })
              ])
          ),
        ),
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.offset.toInt() ==
        _scrollController.position.maxScrollExtent.toInt()) {
      if (db_controller.loadMore.value) {
        pageNo++;
        print("_scrollListener pageNo:- $pageNo");
        db_controller.clubListApi(pageNo.toString(), searchController.text);
      }
    }
  }
}
