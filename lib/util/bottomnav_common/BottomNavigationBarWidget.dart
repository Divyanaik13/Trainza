import 'package:club_runner/util/const_value/ConstValue.dart';
import 'package:club_runner/util/route_helper/RouteHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/MainScreenController.dart';
import '../asstes_image/AssetsImage.dart';
import '../my_color/MyColor.dart';
import '../size_config/SizeConfig.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return BottomNavigationBar(
        currentIndex: ConstValue.bottomNavIndex,
        onTap: (index) {
          //msc.selectedTab.value = index;
          ConstValue.bottomNavIndex = index;
          setState(() {});

          print(ConstValue.bottomNavIndex);
          switch (index) {
            case 0:
              Get.offAllNamed(RouteHelper.getDashBoardScreen());
              break;
            case 1:
              Get.offAllNamed(RouteHelper.getTrainingScreen());
              break;
            case 2:
              Get.offAllNamed(RouteHelper.getNewsScreen());
              break;
            case 3:
              Get.offAllNamed(RouteHelper.getEventScreen());
              break;
            default:
              Get.offAllNamed(RouteHelper.getDashBoardScreen());
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: MyColor.screen_bg,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              MyAssetsImage.app_home_icon_bottom_nav,
              color:
                  ConstValue.bottomNavIndex == 0 ? Colors.white : Colors.grey,
              height: heightPerBox! * 2.3,
            ),
            label: 'Dash',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              MyAssetsImage.app_training_icon_bottom_nav,
              color:
                  ConstValue.bottomNavIndex == 1 ? Colors.white : Colors.grey,
              height: heightPerBox! * 2.3,
            ),
            label: 'Training',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              MyAssetsImage.app_news_icon_bottom_nav,
              color:
                  ConstValue.bottomNavIndex == 2 ? Colors.white : Colors.grey,
              height: heightPerBox! * 2.3,
            ),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              MyAssetsImage.app_event_icon_bottom_nav,
              color:
                  ConstValue.bottomNavIndex == 3 ? Colors.white : Colors.grey,
              height: heightPerBox! * 2.3,
            ),
            label: 'Events',
          ),
        ],
      );
    });
  }
}
