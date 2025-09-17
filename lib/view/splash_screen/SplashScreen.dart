import 'dart:async';
import 'package:club_runner/util/asstes_image/AssetsImage.dart';
import 'package:club_runner/util/local_storage/LocalStorage.dart';
import 'package:club_runner/util/route_helper/RouteHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import '../../service/NotificationServices.dart';
import '../../util/FunctionConstant/FunctionConstant.dart';
import '../../util/size_config/SizeConfig.dart';


NotificationService notificationService = NotificationService();
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  LocalStorage localStorage = LocalStorage();
  String isLogin = "";
  String isOnboarding = "";
  var fontSizeType = "medium";

  @override
  void initState() {
    CommonFunction.getDeviceId();
    CommonFunction.getDeviceType();
    notificationService.initialize().then((value) {
      NotificationService.localNotification(context);
    //  navigateScreen();
    });
    isLogin = LocalStorage.getStringValue(localStorage.authToken);
    isOnboarding = LocalStorage.getStringValue(localStorage.isOnboardingStep);
    super.initState();
    print("isLogin :---- $isLogin");
    print("isOnboarding :---- $isOnboarding");
    print("deviceId :---- ${LocalStorage.getStringValue(localStorage.deviceId)}");
    Timer(
        Duration(seconds: 2), ()=> navigate()
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context,fontSizeType);
    return  SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(MyAssetsImage.splashIcon, fit: BoxFit.cover,));
  }


  void navigate(){
    if(isOnboarding=="0" && isLogin!=""){
      Get.offAllNamed(RouteHelper.getOnBoardingScreen());
    }else if(isOnboarding=="1" && isLogin!=""){
      Get.offAllNamed(RouteHelper.getMainScreen());
    }else{
      Get.offAllNamed(RouteHelper.getWelcomeScreen());
    }
   /* if(isLogin!=""){
      Get.offAllNamed(RouteHelper.getMainScreen());
    }else{
      Get.offAllNamed(RouteHelper.getWelcomeScreen());
    }*/
  }
}
