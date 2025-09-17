import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:club_runner/util/route_helper/RouteHelper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

//For Local Storage
  await GetStorage.init();
  configLoading();

  runApp(const MyApp());
}

void configLoading() {
  EasyLoading.instance
    ..maskType = EasyLoadingMaskType
        .black // Prevents interaction with widgets underneath
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..maskColor = MyColor.screen_bg
    ..backgroundColor = Colors.black
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Trainza',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.manrope().fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: MyColor.screen_bg),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        scaffoldBackgroundColor: MyColor.screen_bg,
        hoverColor: Colors.transparent,
        textSelectionTheme:
            TextSelectionThemeData(cursorColor: MyColor.app_black_color),
        useMaterial3: true,
      ),
      initialRoute: RouteHelper.getSplashScreen(),
      getPages: RouteHelper.pageList,
      // builder: EasyLoading.init(),
      navigatorKey: navigatorKey,
      builder: (context, child) {
        final mediaQuery =
            MediaQuery.of(context).copyWith(textScaleFactor: 1.0);
        return MediaQuery(
          data: mediaQuery,
          child: EasyLoading.init()(context, child),
        );
      },
    );
  }
}
