import 'package:club_runner/util/custom_view/CustomView.dart';
import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:club_runner/util/string_const/MyString.dart';
import 'package:club_runner/util/text_style/MyTextStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import '../../../util/asstes_image/AssetsImage.dart';
import '../../../util/size_config/SizeConfig.dart';

class ViewRouteScreen extends StatefulWidget {
  const ViewRouteScreen({super.key});

  @override
  State<ViewRouteScreen> createState() => _ViewRouteScreenState();
}

class _ViewRouteScreenState extends State<ViewRouteScreen> {
  var heightPerBox = SizeConfig.blockSizeVerticalHeight;
  var widthPerBox = SizeConfig.blockSizeHorizontalWith;
  var fontSize = SizeConfig.fontSize();
  bool blockScroll = false;
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    // Retrieve the parameters passed from the previous screen
    final imageUrl = Get.parameters['imageUrl'] ?? '';
    final routeName = Get.parameters['routeName'] ?? 'Route Name';
    final distance = Get.parameters['distance'] ?? '0 KM';
    final routeDetail = Get.parameters['routeDetail'] ?? 'Route Details';

    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        physics: BouncingScrollPhysics(),
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.scrollViewPadding!),
        child: Column(
          children: [
            CustomView.customAppBar(MyString.route_var, MyString.info_var, () {
              Get.back();
            }),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                routeName,
                style: MyTextStyle.textStyle(
                  FontWeight.w600,
                  20,
                  MyColor.app_white_color,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              distance,
              style: MyTextStyle.textStyle(
                FontWeight.w700,
                25,
                MyColor.app_white_color,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              child: Center(
                child: HtmlWidget(
                  '''${routeDetail}''',
                  textStyle: MyTextStyle.textStyle(
                    FontWeight.w500,
                    16,
                    MyColor.app_white_color,
                    lineHeight: 1.5,
                  ),
                ),
              ),
            ),
            if (imageUrl != null && imageUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child:InteractiveViewer(
                  panEnabled: true, // set to false if you don’t want dragging
                  scaleEnabled: true,
                  minScale: 1.0,
                  maxScale: 4.0, // how much user can zoom in
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ) /*InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(20.0),
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    margin: const EdgeInsets.only(bottom: kBottomNavigationBarHeight * 1),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
                    child: Hero(
                      tag: 'imageHero',
                      child: FadeInImage.assetNetwork(
                        placeholder: MyAssetsImage.app_loader,
                        image: imageUrl,
                        fit: BoxFit.contain,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Image.asset(
                              MyAssetsImage.app_your_profile_dash_board,
                              width: SizeConfig.screenWidth! / 2.3,
                              height: SizeConfig.screenWidth! / 2.3,
                              fit: BoxFit.fill,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )*/
                /* PinchZoomReleaseUnzoomWidget(
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                  twoFingersOn: () => setState(() => blockScroll = true),
                  twoFingersOff: () => Future.delayed(
                    PinchZoomReleaseUnzoomWidget.defaultResetDuration,
                    () => setState(() => blockScroll = false),
                  ),
                ),*/
              )
            else
              SizedBox(
                height: 10,
              ),
          ],
        ),
      ),
    );
  }
}
