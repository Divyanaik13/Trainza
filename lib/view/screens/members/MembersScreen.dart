import 'package:club_runner/util/route_helper/RouteHelper.dart';
import 'package:club_runner/util/string_const/MyString.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/MemberScreenController.dart';
import '../../../util/asstes_image/AssetsImage.dart';
import '../../../util/custom_view/CustomView.dart';

import '../../../util/debounder/Debouncer.dart';
import '../../../util/my_color/MyColor.dart';
import '../../../util/size_config/SizeConfig.dart';
import '../../../util/text_style/MyTextStyle.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  MemberScreenController ms_controller = Get.put(MemberScreenController());
  ScrollController scrollController = ScrollController();
  Debouncer debouncer = Debouncer(milliseconds: 500);
  TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    scrollListener();
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    ms_controller.fetchMemberClubList(ms_controller.pageNo, "");
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Container(
          color: MyColor.screen_bg,
          child: SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    customAppBar(MyString.mem_var, MyString.bers_var, () {
                      Get.back(result: "refresh");
                    }),
                    searchbar(),
                    const SizedBox(
                      height: 30,
                    ),
                    showList(),
                    const SizedBox(
                      height: 30,
                    ),
                    ms_controller.showLoaderMember.value
                        ? CircularProgressIndicator(
                            color: MyColor.app_orange_color.value,
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget customAppBar(String firstText, secondText, VoidCallback onClick) {
    return Column(
      children: [
        const SizedBox(height: 30),
        AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          leadingWidth: 30,
          leading: GestureDetector(
            onTap: onClick,
            child: Image.asset(
              MyAssetsImage.app_back_icon,
              fit: BoxFit.contain,
            ),
          ),
          title: CustomView.twotextViewNoSpace(firstText, FontWeight.w900,
              secondText, FontWeight.w300, 20, MyColor.app_white_color),
          actions: [
            GestureDetector(
              onTap: () {
                ms_controller.search.value = false;
              },
              child: Image.asset(
                MyAssetsImage.app_searchImagewithciecule,
                height: 30,
                width: 30,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget showList() {
    return ms_controller.fetchMemberList.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Text(
              "No Members to Display",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.111,
                  color: MyColor.app_white_color),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ms_controller.fetchMemberList.length,
            itemBuilder: (context, index) {
              var memberList = ms_controller.fetchMemberList[index];
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      var data = {
                        "userId": memberList.id,
                        "screenType": MyString.member_var
                      };
                      Get.toNamed(RouteHelper.getProfileScreen(),
                          parameters: data);
                    },
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          height: (SizeConfig.screenWidth! - 40) * 0.21,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(3.79)),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: SizedBox(
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 110.0),
                                    // width: (SizeConfig.screenWidth! - 110-40-40),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${memberList.firstName}",
                                          softWrap: true,
                                          textAlign: TextAlign.start,
                                          style: MyTextStyle.textStyle(
                                              FontWeight.w300,
                                              19,
                                              MyColor.app_white_color),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          "${memberList.lastName==""||memberList.lastName=="null"?"NA":memberList.lastName}",
                                          softWrap: true,
                                          textAlign: TextAlign.start,
                                          style: MyTextStyle.textStyle(
                                              FontWeight.w600,
                                              19,
                                              MyColor.app_white_color),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
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
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: MyColor.app_white_color, width: 2),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: FadeInImage.assetNetwork(
                              placeholder: MyAssetsImage.app_loader,
                              placeholderFit: BoxFit.cover,
                              image: "${memberList.profilePicture}",
                              fit: BoxFit.cover,
                              height: (SizeConfig.screenWidth! - 40) * 0.21 + 4,
                              width: (SizeConfig.screenWidth! - 40) * 0.21 + 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ms_controller.heightPerBox!,
                  )
                ],
              );
            },
          );
  }

  Widget searchbar() {
    print("ms_controller.search field");
    return Obx(() => ms_controller.search.value
        ? Container()
        : SizedBox(
            height: 40,
            child: TextField(
              controller: searchTextController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(19),
                  borderSide: BorderSide.none,
                ),
                hintText: "search...",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 17),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(MyAssetsImage.app_searchImage),
                ),
                suffixIcon: GestureDetector(
                    onTap: () {
                      print(ms_controller.search.value);
                      ms_controller.search.value = true;
                      searchTextController.clear();
                      ms_controller.pageNo = 1;
                      ms_controller.fetchMemberClubList(ms_controller.pageNo,
                          searchTextController.text.trim());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        MyAssetsImage.app_cancel_board,
                      ),
                    )),
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
              ),
              style: const TextStyle(
                color: Colors.black,
              ),
              onChanged: (value) {
                debouncer.run(() {
                  print(searchTextController.text.trim());
                  ms_controller.pageNo = 1;
                  ms_controller.fetchMemberClubList(
                      ms_controller.pageNo, searchTextController.text.trim());
                });
              },
            ),
          ));
  }

  void scrollListener() {
    scrollController.addListener(() {
      if (scrollController.offset.toInt() ==
          scrollController.position.maxScrollExtent.toInt()) {
        if (ms_controller.loadMoreValue.value) {
          ms_controller.pageNo = ms_controller.pageNo + 1;
          ms_controller.fetchMemberClubList(ms_controller.pageNo, "");
        }
      }
    });
  }
}
