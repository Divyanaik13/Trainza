import 'package:club_runner/util/text_style/MyTextStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../controller/ProfileController.dart';
import '../../../models/UserProfile_Model.dart';
import '../../../util/asstes_image/AssetsImage.dart';
import '../../../util/custom_view/CustomView.dart';
import '../../../util/local_storage/LocalStorage.dart';
import '../../../util/masking_string_constant/MaskingStringConstant.dart';
import '../../../util/my_color/MyColor.dart';
import '../../../util/route_helper/RouteHelper.dart';
import '../../../util/size_config/SizeConfig.dart';

class FullProfileScreen extends StatefulWidget {
  const FullProfileScreen({super.key});

  @override
  State<FullProfileScreen> createState() => _FullProfileScreenState();
}

class _FullProfileScreenState extends State<FullProfileScreen> {
  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var screenWidth = SizeConfig.screenWidth;
  var fontSize = SizeConfig.fontSize();
  LocalStorage sp = LocalStorage();
  ProfileController ps_controller = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    userProfile("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: MyColor.screen_bg,
        child: Obx(() {
          return SafeArea(
              child: Scaffold(
            body:  SingleChildScrollView(physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomView.customAppBar("FULL ", "PROFILE", () {
                    Get.back();
                  }),
                  SizedBox(
                    height: 30,
                  ),
                  Divider(
                    color: MyColor.app_divder_color,
                    thickness: 1,
                    height: 2,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomView.differentStyleTextTogether(
                        "Your ",
                        FontWeight.w400,
                        "Details",
                        FontWeight.w700,
                        18,
                        MyColor.app_white_color),
                  ),
                  Divider(
                    color: MyColor.app_divder_color,
                    thickness: 1,
                    height: 2,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  ProfileText(
                      "Name",
                      ps_controller.memberInfo.value!.firstName != ""
                          ? "${ps_controller.memberInfo.value!.firstName}\t${ps_controller.memberInfo.value!.lastName}"
                          : "NA"),
                  SizedBox(height: 10),
                  ProfileText(
                      "Email",
                      ps_controller.memberInfo.value!.email != ""
                          ? ps_controller.memberInfo.value!.email
                          : "NA"),
                  SizedBox(height: 10),
                  ProfileText(
                      "Contact Number",
                      ps_controller.memberInfo.value!.phoneDialCode != ""
                          ? "+${ps_controller.memberInfo.value!.phoneDialCode}\t${ps_controller.phoneNumber.value}"
                          : "NA"),
                  SizedBox(height: 10),
                  ProfileText(
                      "Date of Birth",
                      ps_controller.memberInfo.value!.dateOfBirth != ""
                          ? DateFormat("dd MMMM yyyy").format(
                          DateTime.parse(ps_controller.memberInfo.value!.dateOfBirth))
                          : "NA"),
                  SizedBox(height: 10),
                  ProfileText(
                      "Gender",
                      ps_controller.memberInfo.value!.gender == "1"
                          ? "Male"
                          : ps_controller.memberInfo.value!.gender == "2"
                              ? "Female"
                              : ps_controller.memberInfo.value!.gender == "3"
                                  ? "Other"
                                  : "NA"),
                  SizedBox(height: 10),
                  ProfileText(
                      "Height",
                      ps_controller.memberInfo.value!.heightDescription != ""
                          ? ps_controller.memberInfo.value!.heightDescription
                          : "NA"),
                  SizedBox(height: 10),
                  ProfileText(
                      "Weight",
                      ps_controller.memberInfo.value!.weightDescription != ""
                          ? ps_controller.memberInfo.value!.weightDescription
                          : "NA"),
                  SizedBox(height: 10),
                  Divider(
                    color: MyColor.app_divder_color,
                    thickness: 1,
                    height: 2,
                  ),
                  SizedBox(height: 10),
                  ProfileText(
                      "BIB Number",
                      ps_controller.memberInfo.value!.bibNumber != ""
                          ? ps_controller.memberInfo.value!.bibNumber
                          : "NA"),
                  SizedBox(height: 10),
                  Divider(
                    color: MyColor.app_divder_color,
                    thickness: 1,
                    height: 2,
                  ),
                  SizedBox(height: 10),
                  ProfileText(
                      "Country",
                      ps_controller.memberInfo.value!.country != ""
                          ? ps_controller.memberInfo.value!.country
                          : "NA"),
                  SizedBox(height: 10),
                  ProfileText(
                      "State/Province",
                      ps_controller.memberInfo.value!.state != ""
                          ? ps_controller.memberInfo.value!.state
                          : "NA"),
                  SizedBox(height: 10),
                  ProfileText(
                      "Town/City",
                      ps_controller.memberInfo.value!.town != ""
                          ? ps_controller.memberInfo.value!.town
                          : "NA"),
                  SizedBox(height: 10),
                  Divider(
                    color: MyColor.app_divder_color,
                    thickness: 1,
                    height: 2,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomView.differentStyleTextTogether(
                        "Profile ",
                        FontWeight.w400,
                        "Picture",
                        FontWeight.w700,
                        18,
                        MyColor.app_white_color),
                  ),
                  Divider(
                    color: MyColor.app_divder_color,
                    thickness: 1,
                    height: 2,
                  ),
                  SizedBox(height: 10),
                  // Center(
                  //   child: ClipRRect(
                  //       borderRadius: BorderRadius.circular(300),
                  //       child: FadeInImage.assetNetwork(
                  //         placeholder: MyAssetsImage.app_loader,
                  //         placeholderFit: BoxFit.cover,
                  //         image: ps_controller.memberInfo.value!.profilePicture,
                  //         imageErrorBuilder: (context, error, stackTrace) {
                  //           return Image.asset(MyAssetsImage.app_default_user);
                  //         },
                  //         fit: BoxFit.cover,
                  //         height: 150,
                  //       )),
                  // ),
                Obx(() {
                  print(">>>>>> >>> ${ ps_controller.profileImage.value}");
                  return  Center(
                    child: CircleAvatar(
                      backgroundColor: MyColor.app_white_color,
                      radius: 75,
                      // decoration: BoxDecoration(
                      //   border: Border.all(
                      //       color: MyColor.app_white_color, width: 2),
                      //   // shape: BoxShape.rectangle,
                      //   borderRadius: BorderRadius.circular(150),
                      // ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: Image.network(
                          ps_controller.profileImage.value,
                          fit: BoxFit.cover,
                          height: 150,
                          width: 150,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              MyAssetsImage.app_default_user,
                              height: 150,
                              width: 150,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                                child:  Image.asset(
                                  MyAssetsImage.app_loader,
                                  height: 150,
                                  width: 150,
                                ),
                            );
                          },
                        )

                        /*FadeInImage.assetNetwork(
                          placeholder: MyAssetsImage.app_loader,
                          placeholderFit: BoxFit.cover,
                          image: ps_controller.profileImage.value,//ps_controller.memberInfo.value!.profilePicture,
                          imageErrorBuilder:
                              (context, error, stackTrace) {
                            return Image.asset(
                              MyAssetsImage.app_default_user,
                              height: 150,
                              width: 150,
                            );
                          },
                          fit: BoxFit.cover,
                          height: 150,
                          width: 150,
                        ),*/
                      ),
                    ),
                  );
                },),
                  SizedBox(height: 10),
                  Divider(
                    color: MyColor.app_divder_color,
                    thickness: 1,
                    height: 2,
                  ),
                  SizedBox(height: 32),
                  CustomView.customButtonWithBorder("EDIT PROFILE", ()async {
                    print("EDIT PROFILE");
                  var result= await Get.toNamed(RouteHelper.getEditProfileScreen());
                  if(result=="refresh"){
                    userProfile("");
                  }
                  }, 162, 2.0),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ));
        }));
  }

  Widget ProfileText(
    String text,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text,
            style: MyTextStyle.textStyle(
                FontWeight.w400, 13.05, MyColor.app_white_color)),
        Text(value,
            style: MyTextStyle.textStyle(
                FontWeight.w600, 16.2, MyColor.app_white_color)),
      ],
    );
  }

  userProfile(String memberId) {
    ps_controller.userProfile_api(memberId).then((value) {
      if (value != "") {
        ps_controller.profilemodel.value = userProfileModelFromJson(value);
        ps_controller.memberInfo.value = ps_controller.profilemodel.value!.data.memberInfo;
        ps_controller.personalBests.value = ps_controller.profilemodel.value!.data.personalBests;
        ps_controller.eventResults.value = ps_controller.profilemodel.value!.data.eventResults;

        ps_controller.profileImage.value = ps_controller.memberInfo.value!.profilePicture;
        ps_controller.phoneNumber.value = ps_controller.memberInfo.value!.phoneNumber;
         print("${ ps_controller.profileImage.value}");

        String maskPattern = PhoneNumberMask.getMaskPattern("+${ps_controller.memberInfo.value!.phoneDialCode}");
        print("get value after profile maskPattern $maskPattern");
        ps_controller.maskFormatter.value =  MaskTextInputFormatter(
            mask: '+# (###) ###-##-##',
            // mask: maskPattern,
            filter: { "#": RegExp(r'[0-9]') },
            type: MaskAutoCompletionType.lazy
        );

        if( ps_controller.maskFormatter.value != null){
          ps_controller.maskFormatter.value!.updateMask(mask: maskPattern);
        }
        ps_controller.phoneNumber.value = ps_controller.maskFormatter.value!.maskText(ps_controller.phoneNumber.value);


        LocalStorage.setStringValue(sp.userprofilePicture, ps_controller.memberInfo.value!.profilePicture);
        LocalStorage.setStringValue(sp.userfirstName, ps_controller.memberInfo.value!.firstName);
        LocalStorage.setStringValue(sp.userlastName, ps_controller.memberInfo.value!.lastName);

        print("userprofilePicture :- ${LocalStorage.getStringValue(sp.userprofilePicture)}");
        print("userprofilePicture :- ${LocalStorage.getStringValue(sp.userfirstName)}");
        print("userprofilePicture :- ${LocalStorage.getStringValue(sp.userlastName)}");
        print("memberInfo phoneNumber :- ${ps_controller.phoneNumber.value}");

        print("object:--${ps_controller.memberInfo.value!.country}");
      }
    });
  }
}
