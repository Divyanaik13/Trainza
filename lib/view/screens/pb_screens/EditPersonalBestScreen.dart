import 'package:club_runner/controller/EditPersonalBestScreenController.dart';
import 'package:club_runner/models/DistanceMeta_Model.dart';
import 'package:club_runner/util/FunctionConstant/FunctionConstant.dart';
import 'package:club_runner/util/asstes_image/AssetsImage.dart';
import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:club_runner/util/string_const/MyString.dart';
import 'package:club_runner/util/text_style/MyTextStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../models/PbDistanceMeta_Model.dart';
import '../../../util/custom_view/CustomView.dart';
import '../../../util/size_config/SizeConfig.dart';

class EditPersonalBest extends StatefulWidget {
  const EditPersonalBest({super.key});

  @override
  State<EditPersonalBest> createState() => _EditPersonalBestState();
}

class _EditPersonalBestState extends State<EditPersonalBest> {
   EditPersonalBestScreenController epb_controller = Get.put(EditPersonalBestScreenController());
   var submitCard = false.obs;

  @override
  void initState() {
    epb_controller.PersonalBest_API();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColor.screen_bg,
      child: SafeArea(
          child: Obx(() {
            return Scaffold(
              body:  SingleChildScrollView(physics: BouncingScrollPhysics(),
                padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.scrollViewPadding!),
                child: Column(
                  children: [
                    CustomView.customAppBar(
                        MyString.your_pb_var.toString().substring(0, 4),
                        MyString.your_pb_var.toString().substring(4),
                            () {
                          Get.back(result: "refresh");
                          epb_controller.PersonalBest_API().then((value) {
                            if (value != ""){
                            epb_controller.distanceMeta_API().then((value) {

                                print("distanceMetaListNew.length");
                                print(epb_controller.personalBestList.length);
                                print(epb_controller.distanceMetaList.length);
                              });
                            }
                          });
                        }),

                    SizedBox(height: 30),
                    Divider(
                      color: MyColor.app_divder_color,
                      thickness: 1,
                      height: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CustomView.differentStyleTextTogether(
                          "PERSONAL ",
                          FontWeight.w700,
                          "BESTS",
                          FontWeight.w300,
                          14.0,
                          MyColor.app_white_color),
                    ),
                    Divider(
                      color: MyColor.app_divder_color,
                      thickness: 1,
                      height: 2,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Obx(() =>  ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: epb_controller.personalBestList.length,
                        itemBuilder: (context, index) {
                          var pb = epb_controller.personalBestList[index];
                          print("pd length---- $pb");
                          print("Unit:--- ${pb.unit}");
                          int unit = int.tryParse(pb.unit) ?? 0;
                          String formattedBestTime = pb.bestTime;

                          // Try to split the bestTime into hours, minutes, and seconds
                          List<String> timeParts = formattedBestTime.split(':');
                          if (timeParts.length == 3) {
                            // Format hours, minutes, and seconds
                            int hours = int.tryParse(timeParts[0]) ?? 0;
                            int minutes = int.tryParse(timeParts[1]) ?? 0;
                            int seconds = int.tryParse(timeParts[2]) ?? 0;
                            formattedBestTime = '${hours.toString()}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
                          } else if (timeParts.length == 2) {
                            // Format minutes and seconds
                            int minutes = int.tryParse(timeParts[0]) ?? 0;
                            int seconds = int.tryParse(timeParts[1]) ?? 0;
                            formattedBestTime = '${minutes.toString()}:${seconds.toString().padLeft(2, '0')}';
                          }
                          return InkWell(
                            onTap: (){
                              submitCard.value = true;
                              epb_controller.distanceKM.value = pb.distance;
                              epb_controller.distanceId = pb.distanceId;
                              epb_controller.distanceUnit = pb.unit;

                              List<String> splitResult = pb.bestTime.split(':');
                              epb_controller.hourController.text =splitResult[0];
                              epb_controller.minController.text =splitResult[1];
                              epb_controller.secController.text =splitResult[2];

                              print("splitResult $splitResult");

                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              height: 38,
                              decoration: BoxDecoration(
                                  border: Border.all(color: MyColor.app_border_color),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(),
                                  CustomView.differentStyleTextTogether(
                                      pb.distance.toString() + (unit == 1 ? 'KM ' : 'MI '),
                                      FontWeight.w700,
                                      formattedBestTime,
                                      FontWeight.w300,
                                      16,
                                      MyColor.app_white_color),
                                  InkWell(
                                      onTap: () {
                                        print("Delete--- ${pb.id}");
                                        epb_controller.deletepersonalBest_Api(context, pb.id).then((value) {
                                          if (value != "") {
                                            // Reset fields after deletion
                                            epb_controller.distanceKM.value = "";
                                            epb_controller.distanceId = "";
                                            epb_controller.hourController.clear();
                                            epb_controller.minController.clear();
                                            epb_controller.secController.clear();
                                            epb_controller.PersonalBest_API().then((value) {
                                            if (epb_controller.personalBestList.isEmpty){
                                              Get.back(result: "refresh");
                                            }
                                            });
                                          }
                                        });
                                      },
                                      child: Image.asset(
                                        MyAssetsImage.app_delete_icon,
                                        height: 17,
                                        width: 14,
                                      ))
                                ],
                              ),
                            ),
                          );
                        })),
                    SizedBox(
                      height: 21,
                    ),
                    submitCard.value == true? submitResultCard(context): SizedBox(),
                  ],
                ),
              ));
            },
          )
      ),
      );
    }

  Widget _buildTimeElement(String label, TextEditingController controller,
      List<TextInputFormatter> inputFormatter) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
      decoration: BoxDecoration(
          color: MyColor.app_white_color,
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 35,
            child: Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                style: MyTextStyle.textStyle(FontWeight.w500,
                    epb_controller.fontSize * 3.5, MyColor.app_black_color),
                inputFormatters: inputFormatter,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "00",
                  hintStyle: MyTextStyle.textStyle(
                      FontWeight.w700, 25, MyColor.app_black_color),
                ),
                onTapOutside: (event) {
                  print('onTapOutside');
                  CommonFunction.keyboardHide(context);
                },
              ),
            ),
          ),
          Text(
            label,
            style: MyTextStyle.textStyle(
                FontWeight.w500, 15.4, MyColor.app_black_color),
          ),
        ],
      ),
    );
  }

  Widget submitResultCard(BuildContext context) {
    return Obx(() {
      return Card(
        color: Color(0xFFDEDEDE),
        margin: EdgeInsets.only(top: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: CustomView.twotextView(
                    "SELECT ",
                    FontWeight.w500,
                    "DISTANCE",
                    FontWeight.w700,
                    18,
                    MyColor.app_black_color,
                    0),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    width: (MediaQuery.of(context).size.width) - 20,
                    height: 40,
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                      color: MyColor.app_text_box_bg_color,
                      border: Border.all(color: Color(0xFF979797), width: 1.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child:  DropdownButton<PersonalBestDistanceMeta>(
                      value: epb_controller.selectedDistance.value,
                      hint:Text(
                        epb_controller.distanceKM.value == ""
                            ? "Select Distance"
                            : "${epb_controller.distanceKM.value}${epb_controller.distanceUnit.toString()=="1"?"KM":"MI"}",
                      ),
                      isExpanded: true,
                      iconSize: 0.0,
                      // icon: Image.asset(MyAssetsImage.app_textField_dropdown,
                      //     height: 15, width: 15),
                      elevation: 16,
                      style: TextStyle(
                        color: MyColor.app_hint_color,
                        fontSize: 15,
                      ),
                      underline: Container(
                        height: 2,
                      ),
                      items: epb_controller.distanceMetaList
                          .map<DropdownMenuItem<PersonalBestDistanceMeta>>((PersonalBestDistanceMeta value) {
                        return DropdownMenuItem<PersonalBestDistanceMeta>(
                          value: value,
                          child: Text(
                            "${value.distance}${value.distanceUnit=="1"?" KM ":" MI "}",
                          ),
                        );
                      }).toList(),
                      onChanged: (PersonalBestDistanceMeta? value) {
                        epb_controller.selectedDistance.value = value!;
                        (value) {
                          print("Select Value 1 $value");
                          epb_controller.selectedDistance.value = value;
                        };
                      },
                      // onTap: onTap,
                    ),
                  )),
              SizedBox(
                height: 17,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        margin: EdgeInsets.symmetric(horizontal: 7),
                        decoration: BoxDecoration(
                            color: MyColor.app_white_color,
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.4))),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: epb_controller.hourController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(3),
                                FilteringTextInputFormatter.digitsOnly,
                                _NumberLimitFormatter(1000),
                              ],
                              style: MyTextStyle.textStyle(
                                  FontWeight.w700, 30, MyColor.app_black_color),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                hintText: "00",
                                hintStyle: MyTextStyle.textStyle(
                                    FontWeight.w700,
                                    30,
                                    MyColor.app_border_grey_color),
                              ),
                              onTapOutside: (e) {
                                CommonFunction.keyboardHide(context);
                              },
                            ),
                            Text(
                              MyString.hours_var,
                              style: MyTextStyle.textStyle(FontWeight.w500,
                                  15.4, MyColor.app_black_color,
                                  lineHeight: 1.571),
                            )
                          ],
                        ),
                      ),
                    ),
                    Text(
                      " : ",
                      style: MyTextStyle.textStyle(
                          FontWeight.w700, 30.8, MyColor.app_black_color),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: MyColor.app_white_color,
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.4))),
                        padding: EdgeInsets.symmetric(vertical: 5),
                        margin: EdgeInsets.symmetric(horizontal: 7),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: epb_controller.minController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                // LengthLimitingTextInputFormatter(
                                //     2),
                                FilteringTextInputFormatter.digitsOnly,
                                _NumberLimitFormatter(60),
                              ],
                              style: MyTextStyle.textStyle(
                                  FontWeight.w700, 30, MyColor.app_black_color),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                hintText: "00",
                                hintStyle: MyTextStyle.textStyle(
                                    FontWeight.w700,
                                    30,
                                    MyColor.app_border_grey_color),
                              ),
                              onTapOutside: (e) {
                                CommonFunction.keyboardHide(context);
                              },
                              onChanged: (value){
                                print(
                                    "controller :- ${epb_controller.minController.text}");

                                if (epb_controller.minController.text.length == 1&&
                                    epb_controller.minController.text[0] != "0") {
                                  epb_controller.minController.text =
                                  "0${epb_controller.minController.text}";
                                } else if (epb_controller.minController.text.length > 2) {
                                  epb_controller.minController.text =
                                      epb_controller.minController.text.substring(1);
                                }
                              },
                            ),
                            Text(
                              MyString.mins_var,
                              style: MyTextStyle.textStyle(FontWeight.w500,
                                  15.4, MyColor.app_black_color,
                                  lineHeight: 1.571),
                            )
                          ],
                        ),
                      ),
                    ),
                    Text(
                      " : ",
                      style: MyTextStyle.textStyle(
                          FontWeight.w700, 30.8, MyColor.app_black_color),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: MyColor.app_white_color,
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.4))),
                        padding: EdgeInsets.symmetric(vertical: 5),
                        margin: EdgeInsets.symmetric(horizontal: 7),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: epb_controller.secController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                // LengthLimitingTextInputFormatter(
                                //     2),
                                FilteringTextInputFormatter.digitsOnly,
                                _NumberLimitFormatter(60),
                              ],
                              style: MyTextStyle.textStyle(
                                  FontWeight.w700, 30, MyColor.app_black_color),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                hintText: "00",
                                hintStyle: MyTextStyle.textStyle(
                                    FontWeight.bold,
                                    30,
                                    MyColor.app_border_grey_color),
                              ),
                              onTapOutside: (e) {
                                CommonFunction.keyboardHide(context);
                              },
                              onChanged: (value){
                                print(
                                    "controller :- ${epb_controller.secController.text}");

                                if (epb_controller.secController.text.length == 1&&
                                    epb_controller.secController.text[0] != "0") {
                                  epb_controller.secController.text =
                                  "0${epb_controller.secController.text}";
                                } else if (epb_controller.secController.text.length > 2) {
                                  epb_controller.secController.text =
                                      epb_controller.secController.text.substring(1);
                                }
                              },
                            ),
                            Text(
                              MyString.sec_var,
                              style: MyTextStyle.textStyle(FontWeight.w500,
                                  15.4, MyColor.app_black_color,
                                  lineHeight: 1.571),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    width: SizeConfig.screenWidth,
                    height: 54,
                    child: ElevatedButton(
                        onPressed: () {
                          CommonFunction.keyboardHide(context);
                          print("submitYourResult");

                          if (epb_controller.distanceKM == "" || epb_controller.distanceKM == "Select Distance"){
                            print("submitYourResult---1");
                            CustomView.showAlertDialogBox(
                                context, "Please select distance");
                          }else if(epb_controller.hourController.text.isEmpty && epb_controller.minController.text.isEmpty &&
                              epb_controller.secController.text.isEmpty){
                            CustomView.showAlertDialogBox(
                                context, "Please enter time");
                            print("please enter time");
                          }else if ((epb_controller.hourController.text == "00" || epb_controller.hourController.text == "0") &&
                              (epb_controller.minController.text == "00" || epb_controller.minController.text == "0") &&
                              (epb_controller.secController.text == "00" || epb_controller.secController.text == "0")) {
                            print("please enter time here");
                            CustomView.showAlertDialogBox(
                                context, "Please enter time");
                          } else if(epb_controller.hourController.text == "00" && epb_controller.minController.text == "00"
                              && epb_controller.secController.text == "00"){
                            CustomView.showAlertDialogBox(
                                context, "Please enter time");
                            print("please enter time");
                          }else if(epb_controller.hourController.text == "0" && epb_controller.minController.text == "0"
                              && epb_controller.secController.text == "0"){
                            CustomView.showAlertDialogBox(
                                context, "Please enter time");
                            print("please enter time");
                          }

                         else {
                           if (epb_controller.hourController.text == "00" || epb_controller.hourController.text == "" || epb_controller.hourController.text == "0"){
                             epb_controller.hourController.text ="00";
                          } if (epb_controller.minController.text == "00" || epb_controller.minController.text == ""|| epb_controller.minController.text == "0"){
                             epb_controller.minController.text = "00";
                          } if (epb_controller.secController.text == "00" || epb_controller.secController.text == "" || epb_controller.minController.text == "0"){
                             epb_controller.secController.text = "00";
                          }
                            setState(() {
                              epb_controller.savePersonalBest_api().then((value) {
                                epb_controller.distanceKM.value = "";
                                epb_controller.distanceId = "";
                                epb_controller.hourController.clear();
                                epb_controller.minController.clear();
                                epb_controller.secController.clear();
                                epb_controller.PersonalBest_API();
                              });
                            });
                          }
                        },

                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              MyColor.app_orange_color.value ??
                                  Color(0xFFFF4300)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        child: CustomView.twotextView(
                            MyString.submitYourResult_var.substring(0, 6),
                            FontWeight.w400,
                            MyString.submitYourResult_var.substring(6, 19),
                            FontWeight.w600,
                            17,
                            MyColor.app_button_text_dynamic_color,
                            1)),
                  )),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      );
    });
  }
}
// Number formate
class _NumberLimitFormatter extends TextInputFormatter {
  final int limit;

  _NumberLimitFormatter(this.limit);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final parsed = int.tryParse(newValue.text);
    if (parsed == null || parsed >= limit) {
      // Return old value if not a number or greater than limit
      return oldValue;
    }
    return newValue;
  }
}
