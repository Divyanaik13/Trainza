import 'package:club_runner/util/custom_view/CustomView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controller/SwitchProfileController.dart';
import '../../../network/EndPointList.dart';
import '../../../util/my_color/MyColor.dart';
import '../../../util/size_config/SizeConfig.dart';

class SwitchProfile extends StatefulWidget {
  const SwitchProfile({super.key});

  @override
  State<SwitchProfile> createState() => _SwitchProfileState();
}

class _SwitchProfileState extends State<SwitchProfile> {
  switchProfileController sp_Controller = Get.put(switchProfileController());

  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var screenWidth = SizeConfig.screenWidth;
  var fontSize = SizeConfig.fontSize();

  @override
  void initState() {
    sp_Controller.joinedClubs_Api();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Obx(() => Scaffold(
              body:  SingleChildScrollView(physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    CustomView.customAppBar("SWITCH ", "PROFILE", () {
                      Get.back(result: "refresh");
                    }),
                    SizedBox(height: 30),
                    sp_Controller.joinClub.isEmpty
                        ? Text(
                            "No clubs to display",
                            style: TextStyle(
                                color: MyColor.app_white_color,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: sp_Controller.joinClub.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              var club = sp_Controller.joinClub[index];

                              print("club : -- " + club.toString());
                              return GestureDetector(
                                onTap: () {
                                  sp_Controller.switchClubs_Api(club.id);
                                  // Get.back();
                                },
                                child: Card(
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Card(
                                          elevation: 0.0,
                                          color: MyColor.screen_bg,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Container(
                                              padding: club.appLogoFilename
                                                  .contains(WebServices.club_url)
                                                  ? EdgeInsets.all(4)
                                                  : EdgeInsets.zero,
                                              height: 80,
                                              width: 131.2,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(4),
                                                color: Color(0xFF3F3F3F),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                child: Image.network(
                                                  club.appLogoFilename,
                                                  height: 80,
                                                  width: 131.2,
                                                  fit: BoxFit.fill,
                                                ),
                                              ))),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Flexible(
                                        child: Text(
                                          club.clubName,
                                          style: TextStyle(
                                              color: MyColor.screen_bg,
                                              fontFamily: GoogleFonts.manrope()
                                                  .fontFamily,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              letterSpacing: -0.4,
                                              height: 1.176),
                                          maxLines: 3,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            )));
  }
}
