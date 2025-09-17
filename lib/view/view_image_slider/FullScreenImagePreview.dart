import 'package:club_runner/util/asstes_image/AssetsImage.dart';
import 'package:club_runner/util/size_config/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullScreenImagePreview extends StatefulWidget {
  @override
  State<FullScreenImagePreview> createState() => _FullScreenImagePreviewState();
}

class _FullScreenImagePreviewState extends State<FullScreenImagePreview> {
  List<String> imageArray = [];
  int initialIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    imageArray = Get.arguments['images'];
    initialIndex = Get.arguments['initialIndex'];
    _pageController = PageController(initialPage: initialIndex);
    print(imageArray[0]);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.cancel,
              color: Colors.white,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: PageView.builder(
          itemCount: imageArray.length,
          controller: _pageController,
          itemBuilder: (context, index) {
            return imageArray.length>=0? imageView(imageArray[index]):SizedBox();
          },
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Widget imageView(String imageUrl) {
    return Center(
      child: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(20.0),
        minScale: 1.0,
        maxScale: 5.0,
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
      ),
    );
  }
}