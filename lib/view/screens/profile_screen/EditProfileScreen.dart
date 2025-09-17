import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:club_runner/controller/EditProfileController.dart';
import 'package:club_runner/models/HeightList_Model.dart';
import 'package:club_runner/models/StateList_Model.dart';
import 'package:club_runner/models/WeightList_Model.dart';
import 'package:club_runner/util/FunctionConstant/FunctionConstant.dart';
import 'package:club_runner/util/asstes_image/AssetsImage.dart';
import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:club_runner/util/text_style/MyTextStyle.dart';
// import 'package:country_calling_code_picker/country.dart';
// import 'package:country_calling_code_picker/functions.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../controller/ProfileController.dart';
import '../../../models/UserProfile_Model.dart';
import '../../../util/custom_view/CustomView.dart';
import '../../../util/local_storage/LocalStorage.dart';
import '../../../util/masking_string_constant/MaskingStringConstant.dart';
import '../../../util/route_helper/RouteHelper.dart';
import '../../../util/size_config/SizeConfig.dart';
import '../../../util/string_const/MyString.dart';
import 'SelectImageDialog.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Date
  DateTime currentDate = DateTime.now();
  String? selectedDate;
  String? formattedDateTime;
  var email_checked = false.obs;
  var contact_checked = false.obs;
  List<Country> countryMetaListNew = [];
  var fontSize = SizeConfig.fontSize();

  var _imageFile = Rxn<File>();
  final controller = EditProfileController();
  ProfileController ps_controller = Get.put(ProfileController());
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _dropdownKey = GlobalKey();
  LocalStorage sp = LocalStorage();

  // var intialData = PhoneNumber(isoCode: 'ZA').obs;

  @override
  void initState() {
    controller.maskFormatter.value  =  MaskTextInputFormatter(
        mask: '##-###-####',
        filter: { "#": RegExp(r'[0-9]') },
        type: MaskAutoCompletionType.lazy
    );
    _scrollController.addListener(() {
      print("Scroll position: ${_scrollController.position}");
    });
    userProfile("");
    controller.countryList_Api().then((value) {
      if(ps_controller.memberInfo.value!.country==""){
        for (var country in controller.countryList) {
          if (country.name == "South Africa") {
            print("South Africa");
            controller.countryName.value = country.name;
            controller.countryMeta.value = country.id;
            controller.stateList_Api(controller.countryMeta.value);
            break;
          }
        }
      }

    });
    controller.heightList_Api();
    controller.weightList_Api();
    if(ps_controller.memberInfo.value!.countryMeta!=""){
      controller.stateList_Api(ps_controller.memberInfo.value!.countryMeta);
    }


    super.initState();
  }

  @override
  void dispose() {
    print("Dispose");
    _scrollController.dispose();
    super.dispose();
  }
  DateTime? selectedDateTime;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? userSelectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.red,
            ).copyWith(secondary: Colors.red),
          ),
          child: Builder(builder: (BuildContext context) {
            return child!;
          }),
        );
      },
    );

    if (userSelectedDate == null) {
      return;
    } else {
      print("currentDate >>>" + userSelectedDate.toString());
      setState(() {
        selectedDateTime = userSelectedDate;
        controller.dobctrl.text =
            DateFormat('dd MMMM yyy').format(selectedDateTime!);
      });

      print("currentDate >>>" + DateTime.now().toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final country = controller.selectedCountry.value;

    print("check country :-- $country");

    return Container(
      color: MyColor.screen_bg,
      child: SafeArea(
        child: Scaffold(
          body:  SingleChildScrollView(physics: BouncingScrollPhysics(),
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 38),
            child: SizedBox(
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CustomView.customAppBar(
                        MyString.edit_var, MyString.profile_var, () {
                      Get.back();
                    }),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                            color: MyColor.app_divder_color,
                            thickness: 1,
                            height: 2),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: CustomView.differentStyleTextTogether(
                              MyString.your_details_var
                                  .toString()
                                  .substring(0, 5),
                              FontWeight.w400,
                              MyString.your_details_var
                                  .toString()
                                  .substring(5, 12),
                              FontWeight.w700,
                              fontSize * 4.5,
                              MyColor.app_white_color),
                        ),
                        Divider(
                          color: MyColor.app_divder_color,
                          thickness: 1,
                          height: 2,
                        ),
                        const SizedBox(height: 23.5),

                        //First Name
                        infoInput(
                            MyString.first_name_var,
                            MyString.first_name_var,
                            controller.firstnamectrl,
                            TextInputType.text,
                            false, () {
                          controller.isError.value = 0;
                        }, [
                          LengthLimitingTextInputFormatter(20),
                          // FilteringTextInputFormatter.deny(MyString.nameregex)
                        ]),
                        controller.isError.value == 1
                            ? CustomView.errorField(
                                controller.errorMessage1.value,
                                controller.errorMessage2.value,
                                FontWeight.w500,
                                FontWeight.w700,
                                10)
                            : const SizedBox(),
                        const SizedBox(height: 10),
                        // Surname/ last name
                        infoInput(
                            MyString.surname_var,
                            MyString.surname_var,
                            controller.lastnamectrl,
                            TextInputType.text,
                            false, () {
                          controller.isError.value = 0;
                        }, [
                          LengthLimitingTextInputFormatter(20),
                          // FilteringTextInputFormatter.deny(MyString.nameregex)
                        ]),
                        controller.isError.value == 2
                            ? CustomView.errorField(
                                controller.errorMessage1.value,
                                controller.errorMessage2.value,
                                FontWeight.w500,
                                FontWeight.w700,
                                10)
                            : const SizedBox(),
                        const SizedBox(height: 10),
                        //Email Address
                        infoInput(
                            MyString.email_single_var,
                            MyString.youremail_var,
                            controller.emailctrl,
                            TextInputType.emailAddress,
                            false, () {
                          controller.isError.value = 0;
                        }, [
                          LengthLimitingTextInputFormatter(50),
                        ]),
                        const SizedBox(height: 5),
                        // secondcheckbox(MyString.share_publicly_var, done),
                        checkBox(MyString.share_publicly_var, email_checked),
                        controller.isError.value == 3 ||
                                controller.isError.value == 4
                            ? CustomView.errorField(
                                controller.errorMessage1.value,
                                controller.errorMessage2.value,
                                FontWeight.w500,
                                FontWeight.w700,
                                10)
                            : const SizedBox(),
                        const SizedBox(height: 10),

                        // Phone Number
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(MyString.contactNo_var,
                                style: MyTextStyle.textStyle(FontWeight.w500,
                                    14.5, MyColor.app_white_color)),
                            const SizedBox(height: 5),
                            CustomView.phoneTextField(
                                controller.contactNoctrl, [
                              LengthLimitingTextInputFormatter(15),
                              FilteringTextInputFormatter.digitsOnly,
                              controller.maskFormatter.value!

                             /* CountryNumberFormatter(
                                isoCode: _selectedCountry?.countryCode ?? "ZA",
                                dialCode:
                                    _selectedCountry?.callingCode ?? "+27",
                                onInputFormatted: (TextEditingValue value) {
                                  controller.contactNoctrl.text = value.text;
                                },
                              )*/

                            ], () {
                              controller.isError.value = 0;
                            },
                                () => _onPressed(),
                                controller.selectedCountry.value != null?
                                controller.selectedCountry.value!:
                                     Country(
                                       name: MyString.southAfrica_var,
                                        flag: "🇿🇦",//"flags/zaf.png",
                                        code:MyString.southAfrica_countryCode_var,
                                        dialCode: MyString.southAfrica_dialCode_var,nameTranslations: const {},
                                       minLength: 3,
                                       maxLength: 15),
                                    (event) async{
                                  print('onTapOutside');
                                  if (!await CommonFunction.getPhoneNumberValidation(
                                  controller.contactNoctrl.text.trim().toString(),
                                      controller.selectedCountry.value!.code)) {
                                      controller.isError.value = 6;
                                      controller.errorMessage1.value = "Please input a valid ";
                                      controller.errorMessage2.value = "mobile number";
                                      }
                                  CommonFunction.keyboardHide(Get.context!);
                                }
                                ,onFieldSubmitted:(p)async{
                                  print("ssssssss ${controller.contactNoctrl.text.trim().toString()}");
                               if (!await CommonFunction.getPhoneNumberValidation(
                              controller.contactNoctrl.text.trim().toString(),
                                   controller.selectedCountry.value!.code)) {
                              controller.isError.value = 6;
                              controller.errorMessage1.value = "Please input a valid ";
                              controller.errorMessage2.value = "mobile number";
                              }
                              return true;
                            },
                                maskHint: controller.contactNoctrl.text.isEmpty && controller.selectedCountry.value?.dialCode != null?
                                PhoneNumberMask.getMaskPattern("+${controller.selectedCountry.value!.dialCode}")
                                    .replaceAll('#', "_ "):"__-___-____"
                            ),
                            const SizedBox(height: 5),
                            checkBox(
                                MyString.share_publicly_var, contact_checked),
                          ],
                        ),
                        controller.isError.value == 5 ||
                                controller.isError.value == 6
                            ? CustomView.errorField(
                                controller.errorMessage1.value,
                                controller.errorMessage2.value,
                                FontWeight.w500,
                                FontWeight.w700,
                                10)
                            : const SizedBox(),
                        const SizedBox(height: 10),

                        // Date of birth
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                MyString.dob_var +
                                    MyString.requider_var.toLowerCase(),
                                style: MyTextStyle.textStyle(FontWeight.w400,
                                    14.5, MyColor.app_white_color)),
                            const SizedBox(height: 5),
                            SizedBox(
                              height: 40,
                              child: TextFormField(
                                controller: controller.dobctrl,
                                keyboardType: TextInputType.number,
                                readOnly: true,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: MyColor.app_text_box_bg_color,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyColor.app_border_grey_color,
                                        width: 0.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyColor.app_border_grey_color,
                                        width: 0.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: MyString.select_dob_var,
                                  prefixIcon:
                                      const Icon(Icons.calendar_today_outlined),
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    fontFamily: GoogleFonts.manrope().fontFamily,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: MyColor.app_hint_color),
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 14),
                                ),
                                onTap: () {
                                  _selectDate(context);
                                  controller.isError.value = 0;
                                },
                              ),
                            ),
                          ],
                        ),
                        controller.isError.value == 7
                            ? CustomView.errorField(
                                controller.errorMessage1.value,
                                controller.errorMessage2.value,
                                FontWeight.w500,
                                FontWeight.w700,
                                10)
                            : const SizedBox(),
                        const SizedBox(height: 10),

                        // Gender
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                MyString.gender_var +
                                    MyString.requider_var.toLowerCase(),
                                style: MyTextStyle.textStyle(FontWeight.w400,
                                    14.5, MyColor.app_white_color)),
                            const SizedBox(height: 5),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: MyColor.app_text_box_bg_color,
                                  border: Border.all(
                                      color: MyColor.app_border_grey_color),
                                  borderRadius: BorderRadius.circular(5)),
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              child: Row(
                                children: [
                                  controller.addRadioButton(
                                      1, MyString.female_var, context),
                                  const SizedBox(width: 5),
                                  controller.addRadioButton(
                                      0, MyString.male_var, context),
                                ],
                              ),
                            ),
                            controller.isError.value == 8
                                ? CustomView.errorField(
                                    controller.errorMessage1.value,
                                    controller.errorMessage2.value,
                                    FontWeight.w500,
                                    FontWeight.w700,
                                    10)
                                : const SizedBox(),
                            const SizedBox(height: 10),
                          ],
                        ),

                        // select height
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(MyString.height_var + MyString.not_public_var,
                                style: MyTextStyle.textStyle(FontWeight.w500,
                                    14.5, MyColor.app_white_color)),
                            const SizedBox(height: 5),
                            Obx(() {
                              print(controller.dropdownheight.value);
                              return Container(
                                //key: _dropdownKey,
                                width: (MediaQuery.of(context).size.width) - 20,
                                height: 40,
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  color: MyColor.app_text_box_bg_color,
                                  border: Border.all(
                                      color: MyColor.app_text_box_bg_color,
                                      width: 0.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),

                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<HeightMeta>(
                                    isExpanded: true,
                                    hint: Text(
                                        controller.selectedHeight.value == "" ||
                                            controller.selectedHeight.value == null
                                            ? MyString.select_height_var
                                            : controller.selectedHeight.value.toString(),
                                        style: MyTextStyle.textStyle(
                                            FontWeight.w500,
                                            15,
                                            MyColor.app_black_color)),
                                    items: controller.heightList.value.map((HeightMeta? value) => DropdownMenuItem<HeightMeta>(
                                      value: value,
                                      child: Text(
                                        value!.height,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                        .toList(),
                                    onChanged: (HeightMeta? cvalue) {
                                      setState(() {
                                        controller.selectedHeight.value = cvalue!.height;
                                        controller.heightMeta.value  = cvalue!.id;
                                        controller.isError.value = 0;
                                      });
                                    },
                                    buttonStyleData: const ButtonStyleData(
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                      height: 40,
                                      width: 200,
                                    ),
                                    dropdownStyleData: const DropdownStyleData(
                                      maxHeight: 200,
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 40,
                                    ),

                                    iconStyleData:  IconStyleData(
                                      icon: Image.asset(MyAssetsImage.app_textField_dropdown,
                                          height: 15, width: 15),
                                    ),

                                    dropdownSearchData: DropdownSearchData(
                                      searchController: controller.weightctrl,
                                      searchInnerWidgetHeight: 50,
                                      searchInnerWidget: Container(
                                        height: 50,
                                        color: MyColor.app_text_box_bg_color,
                                        padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8,),
                                        child: TextFormField(
                                          expands: true,
                                          maxLines: null,
                                          controller: controller.weightctrl,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                            hintText: 'Search for an item...',
                                            hintStyle: const TextStyle(fontSize: 12),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      searchMatchFn: (item, searchValue) {
                                        return item.value!.height.toString().isCaseInsensitiveContains(searchValue);
                                      },
                                    ),
                                    //This to clear the search value when you close the menu
                                    onMenuStateChange: (isOpen) {
                                      if (isOpen) {
                                        // _scrollToDropdown();
                                      } else {
                                        controller.weightctrl.clear();
                                      }
                                    },
                                  ),
                                ),
                              );
                            })
                          ],
                        ),
                        controller.isError.value == 9
                            ? CustomView.errorField(
                                controller.errorMessage1.value,
                                controller.errorMessage2.value,
                                FontWeight.w500,
                                FontWeight.w700,
                                10)
                            : const SizedBox(),

                        const SizedBox(height: 10),
                        // weight
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(MyString.weight_var + MyString.not_public_var,
                                style: MyTextStyle.textStyle(FontWeight.w500,
                                    14.5, MyColor.app_white_color)),
                            const SizedBox(height: 5),
                            Obx(() {
                              print(
                                  "dropdownweight:-- ${controller.dropdownweight.value}");
                              return Container(
                                width: (MediaQuery.of(context).size.width) - 20,
                                height: 40,
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  color: MyColor.app_text_box_bg_color,
                                  border: Border.all(
                                      color: MyColor.app_text_box_bg_color,
                                      width: 0.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: DropdownButtonHideUnderline(
                                 child: DropdownButton2<WeightMeta>(
                                isExpanded: true,
                                hint: Text(
                                    controller.selectedWeightValue == "" ||
                                        controller.selectedWeightValue == null
                                        ? MyString.select_weight_var
                                        : controller.selectedWeightValue.toString(),
                                    style: MyTextStyle.textStyle(
                                        FontWeight.w500,
                                        15,
                                        MyColor.app_black_color)),
                                items: controller.weightList.value.map((WeightMeta? value) => DropdownMenuItem<WeightMeta>(
                                  value: value,
                                  child: Text(
                                    value!.weight,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                                    .toList(),
                                onChanged: (WeightMeta? cvalue) {
                                  setState(() {
                                    controller.selectedWeightValue.value = cvalue!.weight;
                                    controller.weightMeta.value  = cvalue!.id;
                                    controller.isError.value = 0;
                                  });
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  height: 40,
                                  width: 200,
                                ),
                                dropdownStyleData: const DropdownStyleData(
                                  maxHeight: 200,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                ),

                                iconStyleData:  IconStyleData(
                                  icon: Image.asset(MyAssetsImage.app_textField_dropdown,
                                      height: 15, width: 15),
                                ),

                                dropdownSearchData: DropdownSearchData(
                                  searchController: controller.weightctrl,
                                  searchInnerWidgetHeight: 50,
                                  searchInnerWidget: Container(
                                    height: 50,
                                    color: MyColor.app_text_box_bg_color,
                                    padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8,),
                                    child: TextFormField(
                                      expands: true,
                                      maxLines: null,
                                      controller: controller.weightctrl,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        hintText: 'Search for an item...',
                                        hintStyle: const TextStyle(fontSize: 12),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  searchMatchFn: (item, searchValue) {
                                    return item.value!.weight.toString().isCaseInsensitiveContains(searchValue);
                                  },
                                ),
                                //This to clear the search value when you close the menu
                                onMenuStateChange: (isOpen) {
                                  if (!isOpen) {
                                    controller.weightctrl.clear();
                                  }
                                },
                              ),
                              ),
                              );
                            })
                          ],
                        ),
                        controller.isError.value == 10
                            ? CustomView.errorField(
                                controller.errorMessage1.value,
                                controller.errorMessage2.value,
                                FontWeight.w500,
                                FontWeight.w700,
                                10)
                            : const SizedBox(),
                        const SizedBox(height: 22),
                        Divider(
                          color: MyColor.app_divder_color,
                          thickness: 1,
                          height: 2,
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                MyString.bibNumber_var +
                                    MyString.optional_var,
                                style: MyTextStyle.textStyle(FontWeight.w400,
                                    14.5, MyColor.app_white_color)),
                            const SizedBox(height: 5),
                            SizedBox(
                              height: 40,
                              child: TextFormField(
                                controller: controller.bibController,
                                onTap: () {},
                                keyboardType: TextInputType.text,
                                readOnly: false,
                                textAlignVertical: TextAlignVertical.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9]*$'))
                                ],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: MyColor.app_light_yellow_color,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyColor.app_light_yellow_color,
                                        width: 0.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyColor.app_light_yellow_color,
                                        width: 0.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: MyString.bibNumberhint_var,
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      fontFamily:
                                      GoogleFonts.manrope().fontFamily,
                                      color: MyColor.app_hint_color),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 14),
                                ),
                                onTapOutside: (event) {
                                  print('onTapOutside');
                                  CommonFunction.keyboardHide(Get.context!);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Divider(
                          color: MyColor.app_divder_color,
                          thickness: 1,
                          height: 2,
                        ),
                        const SizedBox(
                          height: 19,
                        ),
                        // Country
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                MyString.country_var +
                                    MyString.requider_var.toLowerCase(),
                                style: MyTextStyle.textStyle(FontWeight.w500,
                                    14.5, MyColor.app_white_color)),
                            const SizedBox(height: 7),
                            Obx(() {
                              print(controller.dropdowncountry.value);
                              return InkWell(
                                onTap: ()async{
                                var selectedCountry = await Get.toNamed(RouteHelper.getCountryPicker());
                                if (selectedCountry != null) {
                                  // Handle the selected country in your TextFormField
                                  controller.countryName.value = selectedCountry["name"];
                                  controller.countryMeta.value = selectedCountry["id"];
                                  controller.stateMeta.value = "";
                                  controller.selectedState.value = "";
                                  print("countryName : " + controller.countryName.value);
                                  print("countryID : " + controller.countryMeta.value.toString());
                                  controller.stateList_Api(controller.countryMeta.value);
                                 // countryController.text = countryName.toString();

                                }
                                },
                                child: Container(
                                  width: (MediaQuery.of(context).size.width) - 20,
                                  height: 40,
                                  padding:
                                      const EdgeInsets.only(left: 15, right: 15),
                                  decoration: BoxDecoration(
                                    color: MyColor.app_text_box_bg_color,
                                    border: Border.all(
                                        color: MyColor.app_text_box_bg_color,
                                        width: 0.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${controller.countryName.value}"),
                                      Image.asset(
                                          MyAssetsImage.app_textField_dropdown,
                                          height: 15,
                                          width: 15),
                                    ],
                                  )
                                  /*DropdownButton(
                                    value: controller.dropdowncountry.value,
                                    hint: Text(
                                        ps_controller.memberInfo.value!.country ==
                                                    "" ||
                                                ps_controller.memberInfo.value!.country ==
                                                    null
                                            ? MyString.select_country_var
                                            : ps_controller.memberInfo.value!.country,
                                        style: MyTextStyle.textStyle(
                                            FontWeight.w500,
                                            15,
                                            MyColor.app_black_color)),
                                    isExpanded: true,
                                    icon: Image.asset(
                                        MyAssetsImage.app_textField_dropdown,
                                        height: 15,
                                        width: 15),
                                    elevation: 16,
                                    style: TextStyle(
                                      color: MyColor.app_black_color,
                                      fontSize: 15,
                                    ),
                                    underline: Container(
                                      height: 2,
                                    ),
                                    items: controller.countryList.value
                                        .map<DropdownMenuItem<CountryMeta>>(
                                            (CountryMeta value) {
                                      return DropdownMenuItem<CountryMeta>(
                                        value: value,
                                        child: Text(
                                          "${value.name}",
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (CountryMeta? cvalue) {
                                      print("Select Value $cvalue");
                                      controller.dropdowncountry.value = cvalue;
                                      controller.countryMeta.value = controller.dropdowncountry.value!.id;

                                      controller.stateList_Api(
                                          controller.dropdowncountry.value!.id);
                                    },
                                  ),*/
                                ),
                              );
                            }),
                          ],
                        ),
                        controller.isError.value == 11
                            ? CustomView.errorField(
                                controller.errorMessage1.value,
                                controller.errorMessage2.value,
                                FontWeight.w500,
                                FontWeight.w700,
                                10)
                            : const SizedBox(),
                        const SizedBox(height: 10),
                        //State/ privacy
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                MyString.state_province_var +
                                    MyString.requider_var.toLowerCase(),
                                style: MyTextStyle.textStyle(FontWeight.w500,
                                    14.5, MyColor.app_white_color)),
                            const SizedBox(height: 7),
                            Obx(() {
                              print(controller.dropdownstate.value);
                              return Container(
                                width: (MediaQuery.of(context).size.width) - 20,
                                height: 40,
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  color: MyColor.app_text_box_bg_color,
                                  border: Border.all(
                                      color: MyColor.app_text_box_bg_color,
                                      width: 0.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<StateMeta>(
                                    isExpanded: true,
                                    hint: Text(
                                        controller.selectedState.value == "" ||
                                            controller.selectedState.value == null
                                            ? MyString.select_state_province_var
                                            : controller.selectedState.value.toString(),
                                        style: MyTextStyle.textStyle(
                                            FontWeight.w500,
                                            15,
                                            MyColor.app_black_color)),
                                    items: controller.stateList.value.map((StateMeta? value) => DropdownMenuItem<StateMeta>(
                                      value: value,
                                      child: Text(
                                        value!.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                        .toList(),
                                    onChanged: (StateMeta? cvalue) {
                                      setState(() {
                                        controller.selectedState.value = cvalue!.name;
                                        controller.stateMeta.value  = cvalue!.id;
                                        controller.isError.value = 0;
                                      });
                                    },

                                    buttonStyleData: const ButtonStyleData(
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                      height: 40,
                                      width: 200,
                                    ),
                                    dropdownStyleData: const DropdownStyleData(
                                      maxHeight: 200,
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 40,
                                    ),

                                    iconStyleData:  IconStyleData(
                                      icon: Image.asset(MyAssetsImage.app_textField_dropdown,
                                          height: 15, width: 15),
                                    ),

                                    dropdownSearchData: DropdownSearchData(
                                      searchController: controller.weightctrl,
                                      searchInnerWidgetHeight: 50,
                                      searchInnerWidget: Container(
                                        height: 50,
                                        color: MyColor.app_text_box_bg_color,
                                        padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8,),
                                        child: TextFormField(
                                          expands: true,
                                          maxLines: null,
                                          controller: controller.weightctrl,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                            hintText: 'Search for an item...',
                                            hintStyle: const TextStyle(fontSize: 12),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      searchMatchFn: (item, searchValue) {
                                        return item.value!.name.toString().isCaseInsensitiveContains(searchValue);
                                      },
                                    ),
                                    //This to clear the search value when you close the menu
                                    onMenuStateChange: (isOpen) {
                                      if (!isOpen) {
                                        controller.weightctrl.clear();
                                      }
                                    },
                                  ),
                                ),
                              );
                            })
                          ],
                        ),
                        controller.isError.value == 12
                            ? CustomView.errorField(
                                controller.errorMessage1.value,
                                controller.errorMessage2.value,
                                FontWeight.w500,
                                FontWeight.w700,
                                10)
                            : const SizedBox(),
                        const SizedBox(height: 10),
                        infoInput(
                            MyString.town_city_var +
                                MyString.requider_var.toLowerCase(),
                            MyString.enter_town_city_var,
                            controller.cityctrl,
                            TextInputType.text,
                            false, () {
                          controller.isError.value = 0;
                        }, [
                          LengthLimitingTextInputFormatter(50),
                        ]),
                        controller.isError.value == 13
                            ? CustomView.errorField(
                                controller.errorMessage1.value,
                                controller.errorMessage2.value,
                                FontWeight.w500,
                                FontWeight.w700,
                                10)
                            : const SizedBox(),
                      ],
                    ),
                    const SizedBox(height: 26),
                    Divider(
                      color: MyColor.app_divder_color,
                      thickness: 1,
                      height: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CustomView.differentStyleTextTogether(
                          MyString.profile_picture_var
                              .toString()
                              .substring(0, 9),
                          FontWeight.w500,
                          MyString.profile_picture_var
                              .toString()
                              .substring(9, 15),
                          FontWeight.w700,
                          18,
                          MyColor.app_white_color),
                    ),
                    Divider(
                      color: MyColor.app_divder_color,
                      thickness: 1,
                      height: 2,
                    ),
                    Container(
                      width: SizeConfig.screenWidth,
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      decoration: BoxDecoration(
                          // color: MyColor.app_white_color,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: [
                          Obx(() => CircleAvatar(
                                radius: 70,
                                backgroundColor: MyColor.app_border_grey_color,
                                child: CircleAvatar(
                                    radius: 70,
                                    backgroundColor: MyColor.app_grey_color,
                                    child: (_imageFile.value != null &&
                                            _imageFile!.value?.path != "")
                                        ? ClipOval(
                                            child: Image.file(
                                              _imageFile.value!,
                                              // height: 120,
                                              // width: 120,
                                            ),
                                          )
                                        : ClipOval(
                                            child: controller.profileImg.value != ""
                                                ? Image.network(
                                                    controller.profileImg.value,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    MyAssetsImage.app_profileimg,
                                                    fit: BoxFit.cover,
                                                  ),
                                          )),
                              )),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              UploadImageDialog.show(context, () async {
                                Get.back();
                                var file = await CommonFunction().pickImage(ImageSource.camera);
                                print(">>>>>> $file");
                                print(">camera>>>>> ${file?.path}");
                                _imageFile!.value = File(file!.path);
                              }, () async {
                                Get.back();
                                var file = await CommonFunction().pickImage(ImageSource.gallery);
                                print(">>>>>> $file");
                                print(">gallery>>>>> ${file?.path}");
                                _imageFile!.value = File(file!.path);
                              });
                            },
                            child: Card(
                              margin: EdgeInsets.zero,
                              color: MyColor.app_orange_color.value ??
                                  const Color(0xFFFF4300),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: SizedBox(
                                width: 164,
                                height: 44,
                                // padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                child: Center(
                                  child: Text(MyString.select_photo_var,
                                      textAlign: TextAlign.center,
                                      style: MyTextStyle.buttonTextStyle(
                                          FontWeight.w600, 15)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        _imageFile?.value = null;
                        controller.profileImg.value = '';
                        controller.removeProfilePicture.value = "1";
                      },
                      child: Text(
                        MyString.remove_var,
                        style: MyTextStyle.textStyle(
                            FontWeight.w600, 14, MyColor.app_white_color),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        validation();
                        print("object");
                      },
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        // padding: EdgeInsets.all(15),
                        //width: widthPerBox! * 75,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          color: MyColor.app_orange_color.value ??
                              const Color(0xFFFF4300),
                        ),
                        child: Text(
                          MyString.save_var,
                          style: MyTextStyle.textStyle(FontWeight.w700, 16.8,
                              MyColor.app_button_text_dynamic_color,
                              letterSpacing: 0.48),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          color: MyColor.app_white_color,
                        ),
                        child: Text(
                          MyString.cancel_var,
                          style: MyTextStyle.textStyle(
                              FontWeight.w700, 16.8, MyColor.app_black_color,
                              letterSpacing: 0.48),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 26,
                    ),
                    //delete button
                    InkWell(
                      onTap: () {
                        Get.toNamed(RouteHelper.getSettingScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            MyAssetsImage.app_delete,
                            height: 21,
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Text(
                            MyString.delete_profile_var,
                            style: MyTextStyle.textStyle(
                                FontWeight.w600, 16, MyColor.app_white_color),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget infoInput(
      String heading,
      hintText,
      TextEditingController controller,
      TextInputType inputType,
      bool readOnly,
      void Function() onTap,
      List<TextInputFormatter>? inputFormatter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(heading,
            style: MyTextStyle.textStyle(
                FontWeight.w500, 14.5, MyColor.app_white_color)),
        const SizedBox(height: 7),
        CustomView.profileTextFiled(controller, inputType, hintText, 15.0,
            readOnly, inputFormatter, onTap),
      ],
    );
  }

  Future<bool> validation() async {
    print("firstnamectrl validation :-- ${controller.firstnamectrl.text}");
    if (controller.firstnamectrl.text.trim().isEmpty && controller.firstnamectrl.text.trim()=="") {
      controller.isError.value = 1;
      controller.errorMessage1.value = "Please input ";
      controller.errorMessage2.value = "first name";
      _scrollToError(0);
    } else if (controller.lastnamectrl.text.trim().isEmpty && controller.lastnamectrl.text.trim()=="") {
      controller.isError.value = 2;
      controller.errorMessage1.value = "Please input ";
      controller.errorMessage2.value = "last name";
      _scrollToError(1);
    } else if (controller.emailctrl.text.trim().isEmpty) {
      controller.isError.value = 3;
      controller.errorMessage1.value = "Please input an ";
      controller.errorMessage2.value = "email address";
      _scrollToError(2);
    } else if (!controller.emailctrl.text.trim().isEmail) {
      controller.isError.value = 3;
      controller.errorMessage1.value = "Please input a ";
      controller.errorMessage2.value = "valid email address";
      _scrollToError(3);
    } else if (controller.contactNoctrl.text.trim().isEmpty) {
      controller.isError.value = 5;
      controller.errorMessage1.value = "Please input ";
      controller.errorMessage2.value = "mobile number";
      _scrollToError(4);
      }else if (!await CommonFunction.getPhoneNumberValidation(
        controller.contactNoctrl.text.trim().replaceAll("-", "").toString(),
        controller.selectedCountry.value!.code)) {
    controller.isError.value = 6;
    controller.errorMessage1.value = "Please input a valid ";
    controller.errorMessage2.value = "mobile number";
    _scrollToError(5);
    }else if (controller.dobctrl.text.trim().isEmpty) {
      controller.isError.value = 7;
      controller.errorMessage1.value = "Please select ";
      controller.errorMessage2.value = "date of birth";
      _scrollToError(6);
    } else if (controller.select.value=="Other" || controller.select.value.isEmpty) {
      controller.isError.value = 8;
      controller.errorMessage1.value = "Please select ";
      controller.errorMessage2.value = "gender";
      _scrollToError(7);
    } else if (controller.dropdowncountry.value == "Country") {
      controller.isError.value = 11;
      controller.errorMessage1.value = "Please select ";
      controller.errorMessage2.value = "country";
      _scrollToError(10);
    } else if (controller.selectedState.value.isEmpty) {
      controller.isError.value = 12;
      controller.errorMessage1.value = "Please select ";
      controller.errorMessage2.value = "State/Province";
      _scrollToError(11);
    } else if (controller.cityctrl.text.trim().isEmpty) {
      controller.isError.value = 13;
      controller.errorMessage1.value = "Please select ";
      controller.errorMessage2.value = "Town/City";
      _scrollToError(12);
    } else {
      print("selectedDateTime :- ${selectedDateTime}");
      print("Gender Nd :- ${controller.select.value}");
      print("selectedDateTime :- ${selectedDateTime}");

      EditProfileController.updateProfile_api(
          context,
          controller.firstnamectrl.text.trim(),
          controller.lastnamectrl.text.trim(),
          controller.emailctrl.text.trim(),
          email_checked.value == true ? "1" : "0",
          controller.selectedCountry.value!.dialCode.replaceAll("+", ""),
          controller.selectedCountry.value!.code,
          controller.contactNoctrl.text.trim().replaceAll("-", ""),
          contact_checked.value == true ? "1" : "0",
          DateFormat("yyyy-MM-dd").format(selectedDateTime != null
              ? selectedDateTime!
              : DateTime.parse(ps_controller.memberInfo.value!.dateOfBirth)),
          controller.select.value == "Male"
              ? "1"
              : controller.select.value == "Female"
                  ? "2"
                  : "3",
          controller.heightMeta.value,
          controller.weightMeta.value,
          controller.countryMeta.value,
          controller.stateMeta.value,
          controller.cityctrl.text.trim(),
          controller.removeProfilePicture.value,
          controller.bibController.text.trim(),
          _imageFile.value).then((value) {
            if(value==200){
              print("value updateProfile :-- ${value}");
              LocalStorage.setStringValue(sp.phoneDialCode, controller.selectedCountry.value!.dialCode);
              LocalStorage.setStringValue(sp.phoneNumber, controller.contactNoctrl.text.trim());
              LocalStorage.setStringValue(sp.useremail,  controller.emailctrl.text.trim());

              Get.back(result: "refresh");
            }
      });
    }
    return false;
  }

/*  void initCountry() async {
    Country? country = await getCountryByCountryCode(context, 'ZA');
    controller.selectedCountry.value = country;
    List<Country> countryAll = await getCountries(context);

    setState(() {
      print("countryAll ${countryAll.length}");
      countryMetaListNew = countryAll;

      for (final element1 in countryMetaListNew) {
        if (controller.dailCode == element1.dialCode) {
          controller.flagImg = element1.flag;
          print("controller.flagImg ${controller.flagImg}");
          print("element1.callingCode ${element1.dialCode}");
          controller.selectedCountry.value = element1;
        }
      }

      //_selectedCountry = country;
      //defaultCountryCode = country!.callingCode;
      //print("_selectedCountry " + _selectedCountry.toString());
      //print("selectedCountryCodeNew " + _selectedCountry!.callingCode);
      // print("countryMetaListNew ${countryMetaListNew.length}");
    });
  }*/

  Future<void> initCountry() async {
    // Set the initial country and update controller.selectedCountry
    final Country initialCountry = countries.firstWhere(
          (country) => country.code == 'ZA', // 'ZA' is the country code for South Africa
      orElse: () => countries.first,    // Fallback to the first country
    );

    // Initialize controller with the selected country's details
    controller.selectedCountry.value = initialCountry;

    // Load all available countries into the list
    setState(() {
      print("Total countries available: ${countries.length}");
      countryMetaListNew = countries;

      // Find and set the selected country's flag and dial code
      for (final country in countryMetaListNew) {
        print("controller.dailCode: ${controller.dailCode}");
        print("country.dialCode ${country.dialCode}");
        if (controller.dailCode.replaceAll("+", "") == country.dialCode) {
          controller.flagImg = country.flag;
          print("Flag: ${controller.flagImg}");
          print("Dial Code: ${country.dialCode}");
          controller.selectedCountry.value = country;
        }
      }
    });
  }

/*  Future<void> pickCameraImage(ImageSource camera) async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (imageFile != null) {
      File originalFile = File(imageFile.path);

      // Fix the image rotation
      File fixedImage = await FlutterExifRotation.rotateImage(path: originalFile.path);

      _imageFile!.value = fixedImage;
     // _imageFile!.value = File(imageFile.path);

      _cropImage(_imageFile!.value!.path);
    }
  }

  _cropImage(filePath) async {
    await ImageCropper.platform
        .cropImage(
            sourcePath: filePath,
            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1))
        .then((value) {
      _imageFile!.value = File(value!.path);
      print("Image Path>>>" + _imageFile.toString());
    });
  }

  /// Get from gallery
  _getFromGallery(ImageSource gallery) async {
    XFile? pickedFile = (await ImagePicker.platform.getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    ));

    _cropImage(pickedFile!.path);
  }*/


  void _onPressed() async {
    Country country = await Get.toNamed(RouteHelper.getCountryPickerScreen());

    if (country != null) {
      setState(() {
        controller.selectedCountry.value = country;
        controller.defaultCountryCode.value = controller.selectedCountry.value!.dialCode;
        controller.contactNoctrl.text = "";
        print("Selected Code " + controller.selectedCountry.value.toString());
        String maskPattern = PhoneNumberMask.getMaskPattern("+${controller.selectedCountry.value!.dialCode}");
        controller.maskFormatter.value =  MaskTextInputFormatter(
          // mask: '+# (###) ###-##-##',
            mask: maskPattern,
            filter: { "#": RegExp(r'[0-9]') },
            type: MaskAutoCompletionType.lazy
        );
      });
    }
  }

  //Check Box
  Widget checkBox(String text, RxBool checked) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: const BorderSide(color: Colors.white),
              activeColor: MyColor.screen_bg,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              fillColor: MaterialStateProperty.all(
                  checked.value ? MyColor.app_white_color : MyColor.screen_bg),
              checkColor: MyColor.screen_bg,
              value: checked.value,
              onChanged: (newValue) {
                checked.value = newValue!;
              },
            ),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: MyTextStyle.textStyle(
                FontWeight.w500, fontSize * 3.5, MyColor.app_white_color),
          )
        ],
      );
    });
  }

  userProfile(String memberId) {
    ps_controller.userProfile_api(memberId).then((value) {
      if (value != "") {
        ps_controller.profilemodel.value = userProfileModelFromJson(value);
        ps_controller.memberInfo.value =
            ps_controller.profilemodel.value!.data.memberInfo;
        ps_controller.personalBests.value =
            ps_controller.profilemodel.value!.data.personalBests;
        ps_controller.eventResults.value =
            ps_controller.profilemodel.value!.data.eventResults;

        controller.firstnamectrl.text = ps_controller.memberInfo.value!.firstName;
        controller.lastnamectrl.text = ps_controller.memberInfo.value!.lastName;
        controller.emailctrl.text = ps_controller.memberInfo.value!.email;
        controller.contactNoctrl.text = ps_controller.memberInfo.value!.phoneNumber;
        controller.bibController.text = ps_controller.memberInfo.value!.bibNumber;
        print(">>>>>phoneDialCode ${ps_controller.memberInfo.value!.phoneDialCode}");
        String maskPattern =  PhoneNumberMask.getMaskPattern("+${ps_controller.memberInfo.value!.phoneDialCode.replaceAll("+", "")}");
       log("Masking",error: "$maskPattern");
        controller.maskFormatter.value =  MaskTextInputFormatter(
          // mask: '+# (###) ###-##-##',
            mask: maskPattern,
            filter: { "#": RegExp(r'[0-9]') },
            type: MaskAutoCompletionType.lazy
        );

        if( controller.maskFormatter.value != null){
          controller.maskFormatter.value!.updateMask(mask: maskPattern);
          controller.contactNoctrl.text =
              controller.maskFormatter.value!.maskText(controller.contactNoctrl.text);
        }



        if (ps_controller.memberInfo.value!.dateOfBirth != "") {
          print("dd MMMM yyyy");
          controller.dobctrl.text = DateFormat("dd MMMM yyyy").format(
              DateTime.parse(ps_controller.memberInfo.value!.dateOfBirth));
        }
        if (ps_controller.memberInfo.value!.heightDescription != "") {
          controller.selectedHeight.value = ps_controller.memberInfo.value!.heightDescription;
          controller.heightMeta.value = ps_controller.memberInfo.value!.height;

          print(
              "heightDescription ${ps_controller.memberInfo.value!.heightDescription}");
          print("Height ${controller.dropdownheight.value?.height}");
        }
        if (ps_controller.memberInfo.value!.weightDescription != "") {
          controller.selectedWeightValue.value = ps_controller.memberInfo.value!.weightDescription;
          controller.weightMeta.value = ps_controller.memberInfo.value!.weight;
        }
        if (ps_controller.memberInfo.value!.country != "") {
          print("object country :-- ${ps_controller.memberInfo.value!.country}");
          controller.countryName.value = ps_controller.memberInfo.value!.country;
          controller.countryMeta.value = ps_controller.memberInfo.value!.countryMeta;

          print("object dropdowncountry :-- ${controller.countryName.value}");
        }
        if (ps_controller.memberInfo.value!.state != "") {
          controller.selectedState.value = ps_controller.memberInfo.value!.state;
          controller.stateMeta.value = ps_controller.memberInfo.value!.stateMeta;
        }
        controller.cityctrl.text = ps_controller.memberInfo.value!.town;
        controller.select.value = ps_controller.memberInfo.value!.gender == "1"
            ? "Male"
            : ps_controller.memberInfo.value!.gender == "2"
                ? "Female"
                : "Other";

        controller.profileImg.value = ps_controller.memberInfo.value!.profilePicture;
        controller.dailCode = "+${ps_controller.memberInfo.value!.phoneDialCode.replaceAll("+", "")}";
        email_checked.value = ps_controller.memberInfo.value!.isEmailPubliclyShared == "0"
                ? false
                : true;
        contact_checked.value = ps_controller.memberInfo.value!.isNumberPubliclyShared == "0"
                ? false
                : true;
        print("phoneNumbertext ${controller.dailCode}");
        initCountry();

        // _selectedCountry = Country(ps_controller.memberInfo.value!.country,ps_controller.memberInfo.value!.);
      }
    });
  }

  void _scrollToError(int index) {
    // Assuming each field has a fixed height of 60.0
    double fieldHeight = 60.0;
    _scrollController.animateTo(
      index * fieldHeight,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

}

