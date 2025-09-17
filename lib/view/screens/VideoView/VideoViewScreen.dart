import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../util/FunctionConstant/FunctionConstant.dart';
import '../../../util/custom_view/CustomView.dart';
import '../../../util/my_color/MyColor.dart';
import '../../../util/size_config/SizeConfig.dart';
import '../../../util/string_const/MyString.dart';

class VideoViewScreen extends StatefulWidget {
  const VideoViewScreen({Key? key}) : super(key: key);

  @override
  State<VideoViewScreen> createState() => _VideoViewScreenState();
}

class _VideoViewScreenState extends State<VideoViewScreen> {
  late VideoPlayerController? _controller;
  ChewieController? _chewieController;
  YoutubePlayerController? _youtubeController;
  bool _isYouTubeVideo = false;
  bool _isError = false;
  String _errorMessage = "";
  var isInFullScreen = false.obs;

  @override
  void initState() {
    super.initState();

    _initializePlayer();
    print("link ${Get.parameters['videolink']}");
  }

  Future<void> _initializePlayer() async {
    CommonFunction.showLoader();
    try {
      var videolink = Get.parameters['videolink'];

      if (videolink != null) {
        if (videolink.contains("youtu")) {
          print("youtube $videolink");
          if (YoutubePlayer.convertUrlToId(videolink) != null) {
            _isYouTubeVideo = true;
            _youtubeController = YoutubePlayerController(
              initialVideoId: YoutubePlayer.convertUrlToId(videolink)!,
              flags: YoutubePlayerFlags(
                autoPlay: true,
                loop: true,
              ),
            );
          } else
            print("youtube else $videolink");
        } else {
          print("Mp 4 $videolink");
          if (videolink.toString().contains("http:")) {
            videolink = videolink?.replaceAll("http:", "https:");
          }
          _controller = VideoPlayerController.network(videolink!);
          //final videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
          //videolink));
          await _controller?.initialize();
          _chewieController = ChewieController(
            videoPlayerController: _controller!,
            autoPlay: true,
            looping: true,
          );
          _chewieController?.addListener(() {
            if (_chewieController!.isFullScreen) {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeRight,
                DeviceOrientation.landscapeLeft,
              ]);
            } else {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
            }
          });
        }
      }

      setState(() {
        CommonFunction.hideLoader();
      });
    } catch (error) {
      CommonFunction.hideLoader();
      setState(() {
        _isError = true;
        _errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var heightPerBox = SizeConfig.blockSizeVerticalHeight;

    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      return Scaffold(
        body:  SingleChildScrollView(physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              orientation == Orientation.landscape?SizedBox():
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.scrollViewPadding!),
                child:
                    CustomView.customAppBar(MyString.view, MyString.video, () {
                  Get.back();
                }),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: _isError
                    ? Text(
                        "Error: $_errorMessage",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.111,
                            color: MyColor.app_white_color),
                      )
                    : Get.parameters['videolink'].toString().contains("youtu")
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.minPadding!),
                            height: 300,
                            child: YoutubePlayer(
                              controller: _youtubeController!,
                              showVideoProgressIndicator: true,
                            ),
                          )
                        : _chewieController == null
                            ? Container(
                                child: Text(
                                  "No Video to Display",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      height: 1.111,
                                      color: MyColor.app_white_color),
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.minPadding!),
                                height: 300,
                                child: Chewie(
                                  controller: _chewieController!,
                                ),
                              ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget player() {
    return Obx(() => YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _youtubeController!,
            showVideoProgressIndicator: true,
          ),
          onEnterFullScreen: () {
            isInFullScreen.value = true;
          },
          onExitFullScreen: () {
            isInFullScreen.value = false;
          },
          builder: (BuildContext context, Widget widget) => widget,
        ));
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _controller?.dispose(); // Ensure null-safe disposal
    _youtubeController?.dispose();
    super.dispose();
  }
}
