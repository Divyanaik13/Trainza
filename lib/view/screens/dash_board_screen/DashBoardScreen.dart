import 'package:club_runner/network/EndPointList.dart';
import 'package:club_runner/util/asstes_image/AssetsImage.dart';
import 'package:club_runner/util/custom_view/CustomView.dart';
import 'package:club_runner/util/local_storage/LocalStorage.dart';
import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:club_runner/util/route_helper/RouteHelper.dart';
import 'package:club_runner/util/string_const/MyString.dart';
import 'package:club_runner/util/text_style/MyTextStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controller/MainScreenController.dart';
import '../../../controller/ProfileController.dart';
import '../../../controller/dashboardController.dart';
import '../../../util/size_config/SizeConfig.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  DeshboardController db_controller = Get.put(DeshboardController());
  ProfileController ps_controller = Get.put(ProfileController());
  var screenWidth = SizeConfig.screenWidth;
  MainScreenController msc = Get.put(MainScreenController());
  var isActi = "0".obs;

  @override
  void initState() {
    super.initState();

    db_controller.changeClubData();
    print(
        "currentClubData_logo :-- ${LocalStorage.getStringValue(db_controller.sp.currentClubData_logo)}");
    WidgetsFlutterBinding.ensureInitialized();
    db_controller.img = LocalStorage.getStringValue(db_controller.sp.userprofilePicture);
    db_controller.firstName = LocalStorage.getStringValue(db_controller.sp.userfirstName);
    db_controller.lastName = LocalStorage.getStringValue(db_controller.sp.userlastName);
    db_controller.clubLogo.value = LocalStorage.getStringValue(db_controller.sp.currentClubData_logo);
    db_controller.isMembershipActive = LocalStorage.getStringValue(db_controller.sp.isMembershipActive);
    db_controller.isMembershipExpire = LocalStorage.getStringValue(db_controller.sp.isMembershipExpire);
    db_controller.isMembershipFinal.value = LocalStorage.getStringValue(db_controller.sp.isMembershipFinal);
    print(
        "isMembershipActive :-- ${LocalStorage.getStringValue(db_controller.sp.isMembershipActive)}");
    print(
        "isMembershipExpire :-- ${LocalStorage.getStringValue(db_controller.sp.isMembershipExpire)}");

    Future.delayed(Duration.zero, () async {
      db_controller.getValue();
      db_controller.invitation_Api();
      db_controller.sp_Controller.joinedClubs_Api();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: Colors.black,
          child: SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      CustomView.twotextView(
                          MyString.dash_var,
                          FontWeight.w800,
                          MyString.board_var,
                          FontWeight.w300,
                          20,
                          MyColor.app_white_color,
                          1.74),
                      const SizedBox(
                        height: 39,
                      ),
                      //profile view
                      InkWell(
                        onTap: () async {
                          var data = {
                            "userId": "",
                            "screenType": MyString.profile_var,
                          };
                          var result = await Get.toNamed(
                              RouteHelper.getProfileScreen(),
                              parameters: data);
                          print("result getProfileScreen ${result}");
                          if (result == "refresh") {
                            db_controller.img =
                                ps_controller.memberInfo.value!.profilePicture;
                            db_controller.firstName =
                                ps_controller.memberInfo.value!.firstName;
                            db_controller.lastName =
                                ps_controller.memberInfo.value!.lastName;
                            db_controller.dialCode =
                                ps_controller.memberInfo.value!.phoneDialCode;
                            db_controller.phoneNumber =
                                ps_controller.memberInfo.value!.phoneNumber;
                            db_controller.email =
                                ps_controller.memberInfo.value!.email;
                            print(
                                "phoneNumber ${db_controller.dialCode}${db_controller.phoneNumber}");
                            print("email ${db_controller.email}");
                            db_controller.callback();
                          }
                        },
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(
                              height: (SizeConfig.screenWidth! - 40) * 0.21,
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(3.79)),
                                border:
                                    Border.all(color: Colors.white, width: 1),
                              ),
                              child: SizedBox(
                                height: 60,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      // margin: EdgeInsets.only(left: 110.0),
                                      // width: (SizeConfig.screenWidth! - 110 - 40 - 40),
                                      child: Container(
                                        margin: EdgeInsets.only(left: 110.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              db_controller.firstName == ""
                                                  ? "NA"
                                                  : db_controller.firstName,
                                              textAlign: TextAlign.start,
                                              style: MyTextStyle.textStyle(
                                                  FontWeight.w300,
                                                  19,
                                                  MyColor.app_white_color),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Text(
                                              db_controller.lastName == "" ||
                                                      db_controller.lastName ==
                                                          "null" ||
                                                      db_controller.lastName ==
                                                          null
                                                  ? "NA"
                                                  : db_controller.lastName,
                                              textAlign: TextAlign.start,
                                              style: MyTextStyle.textStyle(
                                                  FontWeight.w600,
                                                  19,
                                                  MyColor.app_white_color),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: MyColor.app_white_color,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              // padding: const EdgeInsets.all(2),
                              height: (SizeConfig.screenWidth! - 40) * 0.21 + 6,
                              width: (SizeConfig.screenWidth! - 40) * 0.21 + 6,
                              margin: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: MyColor.app_white_color, width: 2),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.network(
                                  db_controller.img,
                                  fit: BoxFit.cover,
                                  height:
                                      (SizeConfig.screenWidth! - 40) * 0.21 + 4,
                                  width:
                                      (SizeConfig.screenWidth! - 40) * 0.21 + 4,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      MyAssetsImage.app_default_user,
                                      height: (SizeConfig.screenWidth! - 40) *
                                              0.21 +
                                          4,
                                      width: (SizeConfig.screenWidth! - 40) *
                                              0.21 +
                                          4,
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: Image.asset(
                                        MyAssetsImage.app_loader,
                                        height: (SizeConfig.screenWidth! - 40) *
                                                0.21 +
                                            4,
                                        width: (SizeConfig.screenWidth! - 40) *
                                                0.21 +
                                            4,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // training and logbook
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: boxShow(
                                MyAssetsImage.app_training_dash_board,
                                MyString.training_var,
                                db_controller.clubLogo.value.isEmpty || db_controller.isMembershipFinal.value == "0"
                                    ? MyColor.app_dashboard_disable_color
                                    :  MyColor.app_white_color, () async {
                              if (db_controller.clubLogo.value.isEmpty) {
                                var back = await Get.toNamed(
                                    RouteHelper.getMembershipScreen());
                                print("result1 :-- $back");
                                if (back == "refresh") {
                                  print("back >> ");
                                  db_controller.isMembershipFinal.refresh();
                                  db_controller.callback();
                                }
                              } else {
                                if (db_controller.isMembershipFinal.value == "0") {
                                  var back = await Get.toNamed(
                                      RouteHelper.getMembershipScreen());

                                  print("result2 :-- $back");
                                  if (back == "refresh") {
                                    print("back else");
                                    db_controller.callback();
                                  }
                                } else {
                                  db_controller.msc.selectedTab.value = 2;
                                }
                              }

                              /*db_controller.clubLogo.isEmpty
                                  ? Get.toNamed(
                                      RouteHelper.getMembershipScreen())
                                  : (db_controller.isMembershipFinal == "0"
                                      ? Get.toNamed(
                                          RouteHelper.getMembershipScreen())
                                      : db_controller.msc.selectedTab.value =
                                          2);*/
                              // Get.toNamed(RouteHelper.getMainScreen());
                            }),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            flex: 1,
                            child: boxShow(
                                MyAssetsImage.app_log_book_dash_board,
                                MyString.logbook_var,
                                MyColor.app_white_color, () async {
                              var back = await Get.toNamed(
                                  RouteHelper.getWorkoutLogbookScreen());
                              if (back == "refresh") {
                                print("back else");
                                db_controller.callback();
                              }
                            }),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //results and pb
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: boxShow(
                                MyAssetsImage.app_result_board,
                                MyString.result_var,
                                db_controller.clubLogo.value.isEmpty || db_controller.isMembershipFinal.value == "0"
                                    ? MyColor.app_dashboard_disable_color
                                    : MyColor.app_white_color, () async {
                              if (db_controller.clubLogo.value.isEmpty) {
                                var back = await Get.toNamed(
                                    RouteHelper.getMembershipScreen());
                                print("back1 :-- $back");
                                if (back == "refresh") {
                                  print("back else");
                                  db_controller.callback().then((value) {
                                    setState(() {});
                                    print(">>>>>>>>>>>1. "+db_controller.isMembershipFinal.value);
                                  });
                                }
                              } else {
                                if (db_controller.isMembershipFinal.value ==
                                    "0") {
                                  var back = await Get.toNamed(
                                      RouteHelper.getMembershipScreen());
                                  print("back2 :-- $back");
                                  if (back == "refresh") {
                                    print("back else");
                                    db_controller.callback().then((value) {
                                      setState(() {});

                                      print(">>>>>>>>>>>2. "+db_controller.isMembershipFinal.value);
                                    });
                                  }
                                } else {
                                  var result = await Get.toNamed(RouteHelper.getResultScreen());
                                  print("back3 :-- $result");
                                  if (result == "refresh") {
                                    print("back else");
                                    db_controller.callback().then((value) {
                                      setState(() {});
                                      print(">>>>>>>>>>>3. "+db_controller.isMembershipFinal.value);
                                    });
                                  }
                                }
                              }
                              /*   db_controller.clubLogo.isEmpty
                                  ? Get.toNamed(
                                      RouteHelper.getMembershipScreen())
                                  : (db_controller.isMembershipFinal == "0"
                                      ? Get.toNamed(
                                          RouteHelper.getMembershipScreen())
                                      : Get.toNamed(
                                          RouteHelper.getResultScreen()));*/
                            }),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            flex: 1,
                            child: boxShow(
                                MyAssetsImage.app_yourPB_dash_board,
                                MyString.your_pb_var,
                                MyColor.app_white_color, () async {
                              var back = await Get.toNamed(
                                  RouteHelper.getPersonalBestScreen());
                              if (back == "refresh") {
                                print("back Pb's");
                                db_controller.callback();
                              }
                            }),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //news event
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: boxShow(
                                MyAssetsImage.app_news_dash_board,
                                MyString.news_var,
                                db_controller.clubLogo.value.isEmpty
                                    ? MyColor.app_dashboard_disable_color
                                    : (db_controller.isMembershipFinal.value ==
                                            "0"
                                        ? MyColor.app_dashboard_disable_color
                                        : MyColor.app_white_color), () async {
                              if (db_controller.clubLogo.value.isEmpty) {
                                var back = await Get.toNamed(
                                    RouteHelper.getMembershipScreen());
                                if (back == "refresh") {
                                  print("back else");
                                  db_controller.callback();
                                }
                              } else {
                                if (db_controller.isMembershipFinal.value ==
                                    "0") {
                                  var back = await Get.toNamed(
                                      RouteHelper.getMembershipScreen());
                                  if (back == "refresh") {
                                    print("back else");
                                    db_controller.callback();
                                  }
                                } else {
                                  db_controller.msc.selectedTab.value = 3;
                                }
                              }
                              /* db_controller.clubLogo.isEmpty
                                  ? Get.toNamed(
                                      RouteHelper.getMembershipScreen())
                                  : (db_controller.isMembershipFinal == "0"
                                      ? Get.toNamed(
                                          RouteHelper.getMembershipScreen())
                                      : db_controller.msc.selectedTab.value =
                                          3);*/
                            }),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            flex: 1,
                            child: boxShow(
                                MyAssetsImage.app_event_board,
                                MyString.events_var,
                                db_controller.clubLogo.value.isEmpty
                                    ? MyColor.app_dashboard_disable_color
                                    : (db_controller.isMembershipFinal.value ==
                                            "0"
                                        ? MyColor.app_dashboard_disable_color
                                        : MyColor.app_white_color), () async {
                              if (db_controller.clubLogo.value.isEmpty) {
                                var back = await Get.toNamed(
                                    RouteHelper.getMembershipScreen());
                                if (back == "refresh") {
                                  print("back else");
                                  db_controller.callback();
                                }
                              } else {
                                if (db_controller.isMembershipFinal.value ==
                                    "0") {
                                  var back = await Get.toNamed(
                                      RouteHelper.getMembershipScreen());
                                  if (back == "refresh") {
                                    print("back else");
                                    db_controller.callback();
                                  }
                                } else {
                                  db_controller.msc.selectedTab.value = 4;
                                }
                              }
                              /* db_controller.clubLogo.isEmpty
                                  ? Get.toNamed(
                                      RouteHelper.getMembershipScreen())
                                  : (db_controller.isMembershipFinal == "0"
                                      ? Get.toNamed(
                                          RouteHelper.getMembershipScreen())
                                      : db_controller.msc.selectedTab.value =
                                          4);*/
                            }),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //member - membership
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: boxShow(
                                MyAssetsImage.app_members_dash_board,
                                MyString.members_var,
                                db_controller.clubLogo.value.isEmpty || db_controller.currentClubData_canViewOtherMembers != "1"
                                    ? MyColor.app_dashboard_disable_color
                                    : (db_controller.isMembershipFinal.value == "0"
                                        ? MyColor.app_dashboard_disable_color
                                        : MyColor.app_white_color), () async {
                              if (db_controller.clubLogo.value.isEmpty ||
                                  db_controller.currentClubData_canViewOtherMembers !=
                                      "1") {
                                var back = await Get.toNamed(
                                    RouteHelper.getMembershipScreen());
                                if (back == "refresh") {
                                  print("back else");
                                  db_controller.callback();
                                }
                              } else {
                                if (db_controller.isMembershipFinal.value ==
                                    "0") {
                                  var back = await Get.toNamed(
                                      RouteHelper.getMembershipScreen());
                                  if (back == "refresh") {
                                    print("back else");
                                    db_controller.callback();
                                  }
                                } else {
                                  var back = await Get.toNamed(
                                      RouteHelper.getMembersScreen());
                                  if (back == "refresh") {
                                    print("back ");
                                    db_controller.callback();
                                  }
                                }
                              }
                            }),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            flex: 1,
                            child: boxShow(
                                MyAssetsImage.app_membership_board,
                                MyString.membership_var,
                                MyColor.app_white_color, () async {
                              var back = await Get.toNamed(
                                  RouteHelper.getMembershipScreen());
                              if (back == "refresh") {
                                print("back else");
                                db_controller.callback();
                              }
                            }),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //profile - login/pass
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: boxShow(
                                MyAssetsImage.app_your_profile_dash_board,
                                MyString.your_profile_var,
                                MyColor.app_white_color, () async {
                              var data = {
                                "userId": "",
                                "screenType": MyString.profile_var,
                              };
                              var result = await Get.toNamed(
                                  RouteHelper.getProfileScreen(),
                                  parameters: data);
                              print("result ${result}");
                              if (result == "refresh") {
                                db_controller.img = ps_controller
                                    .memberInfo.value!.profilePicture;
                                db_controller.firstName =
                                    ps_controller.memberInfo.value!.firstName;
                                db_controller.lastName =
                                    ps_controller.memberInfo.value!.lastName;
                                db_controller.dialCode = ps_controller
                                    .memberInfo.value!.phoneDialCode;
                                db_controller.phoneNumber =
                                    ps_controller.memberInfo.value!.phoneNumber;
                                db_controller.email =
                                    ps_controller.memberInfo.value!.email;
                                print(
                                    "phoneNumber ${db_controller.dialCode}${db_controller.phoneNumber}");
                                print("email ${db_controller.email}");
                                db_controller.callback();
                              }
                            }),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            flex: 1,
                            child: boxShow(
                                MyAssetsImage.app_login_pass_dash_board,
                                MyString.login_pass_var,
                                MyColor.app_white_color, () async {
                              var back = await Get.toNamed(
                                  RouteHelper.getLoginPasswordScreen());
                              if (back == "refresh") {
                                print("back ");
                                db_controller.callback();
                              }
                            }),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //setting - logout
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: boxShow(
                                MyAssetsImage.app_setting_dash_board,
                                MyString.setting_var,
                                MyColor.app_white_color, () async {
                              var back = await Get.toNamed(
                                  RouteHelper.getSettingScreen());
                              if (back == "refresh") {
                                print("back ");
                                db_controller.callback();
                              }
                            }),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            flex: 1,
                            child: boxShow(
                                MyAssetsImage.app_logout_dash_board,
                                MyString.logout_var,
                                MyColor.app_white_color, () {
                              db_controller.showAlertDialog(
                                  context, MyString.logout_alert_var);
                            }),
                          )
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      db_controller.sp_Controller.joinClub.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 15),
                              child: Text(
                                MyString.some_features_are_disable_var,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                  color: MyColor.app_white_color,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : SizedBox(),

                      //find a club button
                      InkWell(
                        onTap: () async {
                          var back = await Get.toNamed(
                              RouteHelper.getJoinClubScreen());
                          if (back == "refresh") {
                            print("back club button");
                            db_controller.callback();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              MyString.findAClub_var,
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 17.0,
                                color: MyColor.app_white_color,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: MyColor.app_white_color,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      // Switch button
                      db_controller.sp_Controller.joinClub.isNotEmpty && db_controller.sp_Controller.joinClub.length > 1
                          ? CustomView.customButtonWithBorder(MyString.switchWithoutSpace_var, () async{
                              print("SWITCH");
                              var data = await Get.toNamed(RouteHelper.getSwitchProfileScreen());

                              if (data == "refresh") {
                                print("back SWITCH");
                                db_controller.callback();
                              }

                            }, 156, 6.0)
                          : SizedBox(),
                      db_controller.sp_Controller.joinClub.isNotEmpty &&
                              db_controller.sp_Controller.joinClub.length > 1
                          ? const SizedBox(
                              height: 34,
                            )
                          : SizedBox(),

                      // Club invitation
                      db_controller.sp_Controller.joinClub.isNotEmpty
                          ? db_controller.invitationsList.isNotEmpty
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(top: 6, bottom: 6),
                                  child: CustomView.twotextView(
                                      MyString.club_var,
                                      FontWeight.w800,
                                      MyString.invites_var,
                                      FontWeight.w300,
                                      20,
                                      MyColor.app_white_color,
                                      1.74),
                                )
                              : SizedBox()
                          : CustomView.twotextView(
                              MyString.club_var,
                              FontWeight.w800,
                              MyString.invites_var,
                              FontWeight.w300,
                              20,
                              MyColor.app_white_color,
                              1.74),

                      db_controller.sp_Controller.joinClub.isNotEmpty
                          ? db_controller.invitationsList.isNotEmpty
                              ? Text(
                                  MyString.view_and_accepts_var,
                                  style: MyTextStyle.textStyle(FontWeight.w300,
                                      14, MyColor.app_white_color),
                                  textAlign: TextAlign.center,
                                )
                              : SizedBox()
                          : Text(
                              MyString.view_and_accepts_var,
                              style: MyTextStyle.textStyle(
                                  FontWeight.w300, 14, MyColor.app_white_color),
                              textAlign: TextAlign.center,
                            ),

                      db_controller.sp_Controller.joinClub.isNotEmpty
                          ? db_controller.invitationsList.isNotEmpty
                              ? const SizedBox(
                                  height: 25,
                                )
                              : SizedBox()
                          : const SizedBox(
                              height: 25,
                            ),

                      listViewShow(),

                      const SizedBox(
                        height: 38,
                      ),

                      SizedBox(
                        height: ((SizeConfig.screenWidth)! -
                                (SizeConfig.screenWidth! * 40 / 100)) /
                            1.62,
                        width: (SizeConfig.screenWidth)! -
                            (SizeConfig.screenWidth! * 40 / 100),
                        child: LocalStorage.getStringValue(
                                    db_controller.sp.currentClubData_logo) ==
                                ""
                            ? Image.asset(MyAssetsImage.app_trainza_ratioLogo,
                                fit: BoxFit.fill)
                            : Image.network(
                                LocalStorage.getStringValue(
                                    db_controller.sp.currentClubData_logo),
                                fit: BoxFit.fill),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget boxShow(
    String image,
    String boxName,
    // double opacity,
    Color color,
    VoidCallback onClick,
  ) {
    print("color :-- $color");
    return InkWell(
      onTap: onClick,
      child: SizedBox(
        height: (SizeConfig.screenWidth! - 52) * 0.15,
        child: Card(
          margin: EdgeInsets.zero,
          color: color,
          // MyColor.app_white_color.withOpacity(opacity),
          // color: MyColor.app_dashboard_disable_color,
          elevation: 0.0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3.79))),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
            child: Row(
              children: [
                Image.asset(
                  image,
                  height: 24,
                  width: 24,
                ),
                const SizedBox(
                  width: 13,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    boxName,
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: GoogleFonts.manrope().fontFamily,
                        fontWeight: FontWeight.w700),
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listViewShow() {
    return db_controller.invitationsList.length == 0 &&
            db_controller.sp_Controller.joinClub.length == 0
        ? SizedBox(
            child: Card(
              color: MyColor.app_white_color,
              margin: EdgeInsets.zero,
              elevation: 0.0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    MyString.no_Invites_var,
                    style: MyTextStyle.textStyle(
                        FontWeight.w600, 17, const Color(0xFF424242)),
                  ),
                ),
              ),
            ),
          )
        : Obx(() => ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: db_controller.invitationsList.length,
              itemBuilder: (context, index) {
                var invitation = db_controller.invitationsList[index];
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
                                    padding: invitation.appLogoFilename
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
                                        invitation.appLogoFilename,
                                        height: 80,
                                        width: 131.2,
                                        fit: BoxFit.contain,
                                      ),
                                    ))),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  invitation.clubName,
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
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                // flex: 1,
                                child: CustomView.transparentButton(
                                    MyString.decline_var,
                                    FontWeight.w500,
                                    4.32,
                                    16.8,
                                    Colors.grey.withOpacity(0.5), () {
                              db_controller.declineInvitation_Api(invitation.id);
                              Get.back();
                            })),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              // flex: 1,
                              child: CustomView.buttonShow(
                                MyString.accept_var,
                                FontWeight.w500,
                                4.32,
                                16.8,
                                MyColor.app_orange_color.value ??
                                    Color(0xFFFF4300),
                                () {
                                  db_controller.acceptInvitation_Api(invitation.id);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ));
  }

  Future<dynamic> showDialogBox(String headingFirstMSG, headingSecondMSG,
      mainMSG, typeOfClick, VoidCallback acceptClick, declineClick) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(20.0))), //this right here
            child: Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Image.asset(
                            MyAssetsImage.app_cancel_board,
                            width: 13,
                          )),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "${headingFirstMSG} ",
                        style: MyTextStyle.black_text_welcome_msg_style(
                            FontWeight.w500, 20),
                        children: <TextSpan>[
                          TextSpan(
                            text: headingSecondMSG,
                            style: MyTextStyle.black_text_welcome_msg_style(
                                FontWeight.w900, 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        mainMSG,
                        style: MyTextStyle.black_text_welcome_msg_style(
                            FontWeight.w500, 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                typeOfClick == MyString.accept_var ? 60 : 0),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: CustomView.transparentButton(
                                    typeOfClick == MyString.accept_var
                                        ? "DONE"
                                        : MyString.cancel_var,
                                    FontWeight.w500,
                                    60,
                                    16.8,
                                    Colors.grey.withOpacity(0.5),
                                    declineClick)),
                            const SizedBox(
                              width: 16,
                            ),
                            typeOfClick != MyString.accept_var
                                ? Expanded(
                                    flex: 1,
                                    child: CustomView.buttonShow(
                                        MyString.decline_var,
                                        FontWeight.w500,
                                        db_controller.widthPerBox!,
                                        16.8,
                                        MyColor.app_orange_color.value ??
                                            Color(0xFFFF4300),
                                        acceptClick),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
