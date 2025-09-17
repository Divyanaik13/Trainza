import 'dart:developer';
import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:club_runner/controller/CalendarController.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../asstes_image/AssetsImage.dart';
import '../const_value/ConstValue.dart';
import '../custom_view/CustomView.dart';
import '../local_storage/LocalStorage.dart';
import '../my_color/MyColor.dart';
import '../size_config/SizeConfig.dart';
import '../text_style/MyTextStyle.dart';

class CommonFunction {
  static LocalStorage sp = LocalStorage();

/*  static getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;

      LocalStorage.setStringValue(
          sp.deviceId, iosDeviceInfo.identifierForVendor!);

      print("Get getdeviceId : ${LocalStorage.getStringValue(sp.deviceId)}");

      print("iosDeviceInfo : ${iosDeviceInfo.identifierForVendor}");
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;

      LocalStorage.setStringValue(sp.deviceId, androidDeviceInfo.id);

      print("Get getdeviceId : ${LocalStorage.getStringValue(sp.deviceId)}");

      print("androidDeviceInfo : ${androidDeviceInfo.id}");
    }
  }*/

  ///Get device iD
  static getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      const androidIdPlugin = AndroidId();
      String? androidId = await androidIdPlugin.getId();
      LocalStorage.setStringValue(sp.deviceId, androidId!);

      print("Get androidId : $androidId");
      print("Get getdeviceId : ${LocalStorage.getStringValue(sp.deviceId)}");
      return androidId;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      LocalStorage.setStringValue(sp.deviceId, iosInfo.identifierForVendor!);
      return iosInfo.identifierForVendor; // Unique iOS ID
    }
    return null;
  }


    static getDeviceType() {
    Platform.isIOS
        ? LocalStorage.setStringValue(sp.deviceType, "2")
        : LocalStorage.setStringValue(sp.deviceType, "1");

    print(">>>>>>>deviceType : " + LocalStorage.getStringValue(sp.deviceType));
  }

  static keyboardHide(BuildContext context) {
    FocusNode? currentFocus = FocusManager.instance.primaryFocus;
    if (currentFocus!.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static Future<bool> getPhoneNumberValidation(
      String phone_number, iso_code) async {
    // bool? isValid = await PhoneNumberUtil.isValidPhoneNumber(
    //     phoneNumber: phone_number.replaceAll(" ", ""), isoCode: iso_code);
    // return isValid!;
    return true;
  }


  static Future<dynamic> showCalenderDialogBox(
      BuildContext context,
      Rx<DateTime> _focusedDay,
      Rx<DateTime> _selectedDay,
      double heightPerBox,
      fontSize,
      widthPerBox,
      List<DateTime> toHighlight,
      {CalendarController? controller,
      Function(dynamic)? onClickLeftIcon,
      Function(dynamic)? onClickRightIcon,
      bool? disable}) {
    print("disable :-- $disable");
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          controller?.updateText(_selectedDay);
          return Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            alignment: Alignment.topCenter,
            child: Container(
                decoration: BoxDecoration(
                    color: MyColor.app_white_color,
                    borderRadius: BorderRadius.circular(5.0)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TableCalendar(
                        availableGestures: AvailableGestures.none,
                        firstDay: DateTime.utc(0000, 00, 00),
                        lastDay: ConstValue.isCalendarDisable == false
                            ? DateTime.utc(2030, 3, 14)
                            : DateTime.now(), //DateTime.utc(2030, 3, 14),
                        focusedDay: _focusedDay.value,
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          rightChevronPadding: EdgeInsets.zero,
                          leftChevronPadding: EdgeInsets.zero,
                          leftChevronMargin: EdgeInsets.zero,
                          rightChevronMargin: EdgeInsets.zero,
                          leftChevronIcon: InkWell(
                            onTap: () {
                              final newFocusedDay = DateTime(
                                  _focusedDay.value.year,
                                  _focusedDay.value.month - 1);
                              _focusedDay.value = newFocusedDay;
                              if (onClickLeftIcon != null) {
                                onClickLeftIcon(newFocusedDay);
                              }
                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(8, 8, 10, 8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MyColor.app_orange_color.value ??
                                      const Color(0xFFFF4300)),
                              child: Image.asset(
                                MyAssetsImage.app_PreviousIcon,
                                color: MyColor.app_button_text_dynamic_color,
                                height: 15.5,
                                width: 15.5,
                              ),
                            ),
                          ),
                          rightChevronIcon: InkWell(
                            onTap: () {
                              if (ConstValue.isCalendarDisable == true) {
                                print("disable true");
                                if (DateTime.now().month != _focusedDay.value.month) {
                                  print("disable true current month");
                                  final newFocusedDay = DateTime(
                                      _focusedDay.value.year,
                                      _focusedDay.value.month + 1);
                                  _focusedDay.value = newFocusedDay;
                                  if (onClickRightIcon != null) {
                                    onClickRightIcon(newFocusedDay);
                                  }
                                  setState(() {});
                                }
                                return;
                              } else {
                                print("disable false");
                                final newFocusedDay = DateTime(
                                    _focusedDay.value.year,
                                    _focusedDay.value.month + 1);
                                _focusedDay.value = newFocusedDay;
                                if (onClickRightIcon != null) {
                                  onClickRightIcon(newFocusedDay);
                                }
                                setState(() {});
                              }

                              /*  if((disable == false || disable == null)){
                                print("disable false");
                                final newFocusedDay = DateTime(
                                    _focusedDay.value.year,
                                    _focusedDay.value.month + 1);
                                _focusedDay.value = newFocusedDay;
                                if (onClickRightIcon != null) {
                                  onClickRightIcon(newFocusedDay);
                                }
                                setState(() {});
                              }else{
                                print("disable true ${_focusedDay.value.isBefore(DateTime.now())}");
                                */
                              /*if(_focusedDay.value.isBefore(DateTime.now()))*/ /*
                                if(DateTime.now().month != _focusedDay.value.month){
                                  print("isBefore");
                                  final newFocusedDay = DateTime(
                                      _focusedDay.value.year,
                                      _focusedDay.value.month + 1);
                                  _focusedDay.value = newFocusedDay;
                                  if (onClickRightIcon != null) {
                                    onClickRightIcon(newFocusedDay);
                                  }
                                  setState(() {});
                                }
                              }*/
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MyColor.app_orange_color.value ??
                                      const Color(0xFFFF4300)),
                              child: Image.asset(
                                MyAssetsImage.app_arrow_white,
                                color: MyColor.app_button_text_dynamic_color,
                                height: 15.5,
                                width: 15.5,
                              ),
                            ),
                          ),
                          titleTextStyle: MyTextStyle.textStyle(
                            FontWeight.w700,
                            20,
                            MyColor.app_black_color,
                          )!,
                          titleTextFormatter: (date, locale) =>
                              DateFormat.yMMMM(locale)
                                  .format(date)
                                  .toUpperCase(),
                        ),
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: MyTextStyle.textStyle(
                              FontWeight.w600, 15, MyColor.app_black_color,
                              lineHeight: 0.912)!,
                          weekendStyle: MyTextStyle.textStyle(
                              FontWeight.w600, 15, MyColor.app_black_color,
                              lineHeight: 0.912)!,
                        ),
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay.value, day);
                        },
                        onDaySelected: (selectedDay, focusedDaynew) {
                          _focusedDay.value = focusedDaynew;
                          if (isDayDisabled(selectedDay, _focusedDay.value)) {
                            _selectedDay.value = selectedDay;
                          }
                          log("_selectedDay2 :-- ${_selectedDay}");
                          controller?.updateText(_selectedDay);
                          setState(() {});
                        },
                        calendarStyle: CalendarStyle(
                          cellMargin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 7),
                          selectedDecoration: BoxDecoration(
                            color: MyColor.app_orange_color.value ??
                                const Color(0xFFFF4300),
                            shape: BoxShape.rectangle,
                          ),
                        ),
                        calendarBuilders: CalendarBuilders(
                          dowBuilder: (context, day) {
                            final text =
                                DateFormat.E().format(day).toUpperCase();
                            return Center(
                              child: Text(
                                text,
                                style: MyTextStyle.textStyle(FontWeight.w600,
                                    15, MyColor.app_black_color,
                                    lineHeight: 0.912),
                              ),
                            );
                          },
                          todayBuilder: (context, day, focusedDay) {
                            for (DateTime d in toHighlight) {
                              if (day.day == d.day &&
                                  day.month == d.month &&
                                  day.year == d.year) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: MyColor.app_grey_color,
                                  ),
                                  child: Center(
                                    child: Text(day.day.toString()),
                                  ),
                                );
                              }
                            }
                            return null;
                          },
                          defaultBuilder: (context, day, focusedDay) {
                            for (DateTime d in toHighlight) {
                              if (day.day == d.day &&
                                  day.month == d.month &&
                                  day.year == d.year) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: MyColor.app_grey_color,
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${day.day}',
                                      style: TextStyle(
                                        color: MyColor.app_black_color,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Changed to spaceBetween for better alignment
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                _selectedDay.value = DateTime.utc(
                                  _selectedDay.value.year,
                                  _selectedDay.value.month,
                                  _selectedDay.value.day - 1,
                                );

                                // _selectedDay.refresh();
                                //  _focusedDay.refresh();
                                controller?.updateText(_selectedDay);
                                if (onClickLeftIcon != null &&
                                    _selectedDay.value.month !=
                                        _focusedDay.value.month) {
                                  onClickLeftIcon!(_selectedDay.value);
                                  // onClickRightIcon(_selectedDay.value);
                                }
                                _focusedDay.value = _selectedDay.value;
                                print("Calendar -1 ");
                                setState(() {});
                              },
                              child: Card(
                                elevation: 0.0,
                                color: const Color(0xFFEEEEEE),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.arrow_back_ios_new,
                                        color: MyColor.app_black_color,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 9),
                                      Image.asset(
                                        MyAssetsImage.app_calendar_mius,
                                        color: MyColor.app_black_color,
                                        width: 25,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Card(
                              elevation: 0.0,
                              color: MyColor.app_orange_color.value ??
                                  const Color(0xFFFF4300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  controller!.message.value.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: MyTextStyle.textStyle(FontWeight.w700,
                                      18, MyColor.app_button_text_dynamic_color,
                                      letterSpacing: 0.59),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                DateTime now = DateTime.now();
                                DateTime selectedDay = _selectedDay.value;

                                if (ConstValue.isCalendarDisable == true) {
                                  print("disable true ${now.day} --- ${selectedDay.day}");
                                  print("disable true ${now.month} --- ${selectedDay.month}");

                                  if (selectedDay.isBefore(now) || selectedDay.isAtSameMomentAs(now)) {
                                    print("disable true current month");
                                    DateTime newSelectedDay = selectedDay.add(const Duration(days: 1));

                                    // Prevent selecting future dates
                                    if (newSelectedDay.isAfter(now)) {
                                      print("Cannot select a future date");
                                      return; // Stop the user from selecting a future date
                                    }

                                    _selectedDay.value = newSelectedDay;
                                    controller?.updateText(_selectedDay);

                                    if (onClickRightIcon != null &&
                                        _selectedDay.value.month != _focusedDay.value.month) {
                                      onClickRightIcon(_selectedDay.value);
                                    }

                                    _focusedDay.value = _selectedDay.value;
                                    print("Calendar +1 day");
                                    setState(() {});
                                  }
                                  return;
                                } else {
                                  print("disable false");
                                  DateTime newSelectedDay = selectedDay.add(const Duration(days: 1));

                                  // Prevent selecting future dates
                                  // if (newSelectedDay.isAfter(now)) {
                                  //   print("Cannot select a future date");
                                  //   return; // Stop the user from selecting a future date
                                  // }

                                  _selectedDay.value = newSelectedDay;
                                  controller?.updateText(_selectedDay);

                                  if (onClickRightIcon != null && _selectedDay.value.month !=
                                      _focusedDay.value.month) {
                                    onClickRightIcon(_selectedDay.value);
                                  }

                                  _focusedDay.value = _selectedDay.value;
                                  print("Calendar +1 day");
                                  setState(() {});
                                }
                              },
                              child: Card(
                                elevation: 0.0,
                                color: const Color(0xFFEEEEEE),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        MyAssetsImage.app_calendar_plus,
                                        color: MyColor.app_black_color,
                                        width: 25,
                                      ),
                                      const SizedBox(width: 9),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: MyColor.app_black_color,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                        /*  Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                if (ConstValue.isCalendarDisable == true) {
                                  print("disable true 12 ${DateTime.now().day}  --- ${_focusedDay.value.day}");
                                  print("disable true 12 ${DateTime.now().month}  --- ${_focusedDay.value.month}");

                                  if (DateTime.now().day != _focusedDay.value.day) {
                                    print("disable true current month");
                                    _selectedDay.value = DateTime.utc(
                                      _selectedDay.value.year,
                                      _selectedDay.value.month,
                                      _selectedDay.value.day + 1,
                                    );
                                   *//* if (_selectedDay.value.isAfter(DateTime.now())) {
                                      print("Cannot select a future date");
                                      return; // Stop the user from selecting a future date
                                    }*//*
                                    controller.updateText(_selectedDay);
                                    // _selectedDay.refresh();
                                    // _focusedDay.refresh();

                                    if (onClickRightIcon != null &&
                                        _selectedDay.value.month !=
                                            _focusedDay.value.month) {
                                      onClickRightIcon(_selectedDay.value);
                                    }
                                    _focusedDay.value = _selectedDay.value;
                                    print("Calendar +1 ");
                                    setState(() {});
                                  }
                                  return;
                                }
                                else {
                                  print("disable true current month");
                                  _selectedDay.value = DateTime.utc(
                                    _selectedDay.value.year,
                                    _selectedDay.value.month,
                                    _selectedDay.value.day + 1,
                                  );
                                  controller.updateText(_selectedDay);
                                  // _selectedDay.refresh();
                                  // _focusedDay.refresh();

                                  if (onClickRightIcon != null &&
                                      _selectedDay.value.month !=
                                          _focusedDay.value.month) {
                                    onClickRightIcon(_selectedDay.value);
                                  }
                                  _focusedDay.value = _selectedDay.value;
                                  print("Calendar +1 ");
                                  setState(() {});
                                }
                              },
                              child: Card(
                                elevation: 0.0,
                                color: const Color(0xFFEEEEEE),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        MyAssetsImage.app_calendar_plus,
                                        color: MyColor.app_black_color,
                                        width: 25,
                                      ),
                                      const SizedBox(width: 9),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: MyColor.app_black_color,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),*/
                        ],
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          ConstValue.isPopupShow = false;
                          Get.back(result: _selectedDay.value);
                        },
                        child: Text(
                          "CLOSE",
                          style: MyTextStyle.textStyle(
                            FontWeight.w700,
                            14,
                            MyColor.app_black_color,
                          ),
                        ),
                      ),
                    ],
                  );
                })),
          );
        });
  }


  static bool isDayDisabled(DateTime day, _focusedDay) {
    print("focused month ${_focusedDay.month.toString()}");
    if (day.month == _focusedDay.month) {
      return true;
    }
    return false;
  }

  static Future<dynamic> showAlertDialogdelete(
      BuildContext context, mainMSG, void Function() onTap) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          var fontSize = SizeConfig.fontSize();
          var heightPerBox = SizeConfig.blockSizeVerticalHeight;
          // var widthPerBox = SizeConfig.blockSizeHorizontalWith;
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)), //this right here
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Align(
                    //   alignment: Alignment.topRight,
                    //   child: IconButton(
                    //       onPressed: () {
                    //         Get.back();
                    //       },
                    //       icon: Icon(Icons.cancel)),
                    // ),
                    Text("ALERT!",
                        style: MyTextStyle.textStyle(
                            FontWeight.w600,
                            fontSize * 6,
                            MyColor.app_orange_color.value ??
                                Color(0xFFFF4300))),
                    SizedBox(
                      height: heightPerBox! * 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        mainMSG,
                        style: MyTextStyle.black_text_welcome_msg_style(
                            FontWeight.w500, fontSize * 4.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: heightPerBox * 2.6,
                    ),
                    CustomView.buttonShow(
                        "OK",
                        FontWeight.w700,
                        5,
                        19.0,
                        MyColor.app_orange_color.value ?? Color(0xFFFF4300),
                        onTap,
                        buttonHeight: 54),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String iosUrl = 'https://maps.apple.com/?q=$latitude,$longitude';
    if (GetPlatform.isAndroid) {
      String googleUrl =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      if (await canLaunch(googleUrl)) {
        await launch(googleUrl);
      } else {
        throw 'Could not launch $googleUrl';
      }
    } else {
      if (await canLaunch(iosUrl)) {
        await launch(iosUrl);
      } else {
        throw 'Could not open the map.';
      }
    }
  }

  static void showLoader() {
    EasyLoading.show(dismissOnTap: false);
  }

  static void hideLoader() {
    EasyLoading.dismiss();
  }

  static String calculatePace(
      double distance, int hours, int minutes, int seconds) {
    double totalTimeInMinutes = (hours * 60) + minutes + (seconds / 60);
    double pacePerMint = totalTimeInMinutes / distance;
    print("pacePerMint :-- $pacePerMint");
    var mint =
        int.parse(pacePerMint.toStringAsFixed(2).toString().split(".")[0]);
    double second = (pacePerMint - mint) * 60;
    print("aaaaa ${'$mint $second'}");
    return '$mint:${second.toInt()}';
  }

  //new image picker code
  Future<CroppedFile?> pickImage(ImageSource imageSource) async {
    XFile? imageFile =
    await ImagePicker().pickImage(source: imageSource, imageQuality: 40);
    print("pickImage File :--  ${imageFile?.path}");

    if (imageFile != null) {
      //File rotatedImage = await FlutterExifRotation.rotateImage(path: imageFile.path);
      // var cropFile = await _cropImage(imageFile.path);
      // print("_cropImage File :--  ${cropFile?.path}");
      // return cropFile;

      // Compress and fix rotation
      File? compressedImage = await compressImage(File(imageFile.path));

      print("Compressed Image Path: ${compressedImage?.path}");

      // Crop the image
      CroppedFile? croppedFile = await _cropImage(compressedImage?.path);

      print("Cropped Image Path: ${croppedFile?.path}");

      return croppedFile;

    }
    return null;
  }


/*  Future<File?> compressImage(File imageFile) async {
    final outputPath = imageFile.path.replaceAll('.jpg', '_compressed.jpg');

    XFile? compressedXFile = await FlutterImageCompress.compressAndGetFile(
      imageFile.path,
      outputPath,
      quality: 80,  // Adjust quality as needed (lower = smaller file size)
      rotate: 0,    // Automatically corrects EXIF rotation
    );

    // Convert XFile to File
    return compressedXFile != null ? File(compressedXFile.path) : null;
  }*/

  //for image rotation issue
  Future<File?> compressImage(File imageFile) async {
    String fileExtension = imageFile.path.split('.').last.toLowerCase();

    // Skip compression for PNG files
    if (fileExtension == "png") {
      print("PNG compression is not supported, returning original file.");
      return imageFile;
    }

    // Ensure unique output file path
    String outputPath = imageFile.path.replaceAll('.jpg', '_compressed.jpg').replaceAll('.jpeg', '_compressed.jpeg');

    XFile? compressedXFile = await FlutterImageCompress.compressAndGetFile(
      imageFile.path,
      outputPath,
      quality: 80,  // Adjust quality
    );

    return compressedXFile != null ? File(compressedXFile.path) : imageFile;
  }

  Future<CroppedFile?> _cropImage(filePath) async {
    CroppedFile? cropImage = await ImageCropper.platform.cropImage(
        sourcePath: filePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1));

    return cropImage;
  }

}
