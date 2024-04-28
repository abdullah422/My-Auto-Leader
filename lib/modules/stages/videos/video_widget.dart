// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:mal/shared/styles/colors.dart';
// import 'package:video_player/video_player.dart';
//
// class VideoWidget extends StatefulWidget {
//   const VideoWidget({Key? key}) : super(key: key);
//
//   @override
//   State<VideoWidget> createState() => _VideoWidgetState();
// }
//
// class _VideoWidgetState extends State<VideoWidget> {
//   VideoPlayerController? controller;
//
//   @override
//   void initState() {
//     super.initState();
//
//     controller = VideoPlayerController.network(
//          'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
//         //'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
//        // 'https://learn-videos-simply.s3.me-south-1.amazonaws.com/services/Web+Bilder.mp4',
//     )
//       ..addListener(() => setState(() {}))
//       ..setLooping(false)
//       ..initialize().then((_) => controller!.pause());
//   }
//
//   @override
//   void dispose() {
//     controller!.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return VideoPlayerWidget(controller: controller as VideoPlayerController);
//   }
// }
//
// class VideoPlayerWidget extends StatelessWidget {
//   final VideoPlayerController controller;
//
//   const VideoPlayerWidget({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);
//
//   String getPosition() {
//     final duration = Duration(
//         milliseconds: controller.value.position.inMilliseconds.round());
//
//     return [duration.inMinutes, duration.inSeconds]
//         .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
//         .join(':');
//   }
//
//   Future forward5Seconds() async =>
//       goToPosition((currentPosition) => currentPosition + Duration(seconds: 5));
//
//   Future rewind5Seconds() async =>
//       goToPosition((currentPosition) => currentPosition - Duration(seconds: 5));
//
//   Future goToPosition(
//     Duration Function(Duration currentPosition) builder,
//   ) async {
//     final currentPosition = await controller.position;
//     final newPosition = builder(currentPosition!);
//
//     await controller.seekTo(newPosition);
//   }
//
//   /* void setOrientation(bool isPortrait) {
//     if (isPortrait) {
//       Wakelock.disable();
//       SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
//     } else {
//       Wakelock.enable();
//       SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
//     }
//   }*/
//
//   @override
//   Widget build(BuildContext context) {
//     final isMuted = controller.value.volume == 0;
//     return controller.value.isInitialized
//         ? Column(
//             children: [
//               Container(
//                   margin: EdgeInsets.symmetric(horizontal: 16.w),
//                   child: Center(child: buildVideo())),
//               Container(
//                 width: 395.w,
//                 height: 70.h,
//                 margin: EdgeInsets.symmetric(horizontal:16.w),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     bottomRight: Radius.circular(25.r),
//                     bottomLeft: Radius.circular(25.r),
//                   ),
//                   color: kGray,
//                 ),
//                 child: Column(
//                 children: [
//                   SizedBox(
//                     height: 8.h,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         child: buildIndicator(),
//                         height: 10.h,
//                         width: 320.w,
//                       ),
//                       SizedBox(
//                         width: 15.w,
//                       ),
//                       SizedBox(
//                           height: 12.h,
//                           width: 40.w,
//                           child: Text(
//                             getPosition(),
//                             style: TextStyle(fontSize: 12.r),
//                           ))
//                     ],
//                   ),
//                   Expanded(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         IconButton(
//                           onPressed: rewind5Seconds,
//                           icon: Icon(Icons.replay_5),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             controller.value.isPlaying
//                                 ? controller.pause()
//                                 : controller.play();
//                           },
//                           icon: controller.value.isPlaying
//                               ? const Icon(Icons.pause)
//                               : const Icon(Icons.play_arrow),
//                         ),
//                         IconButton(
//                           onPressed: forward5Seconds,
//                           iconSize: 22.r,
//                           icon: const Icon(Icons.forward_5),
//                           hoverColor: Colors.transparent,
//                           splashColor: Colors.transparent,
//                           focusColor: Colors.transparent,
//                           highlightColor: Colors.transparent,
//                         ),
//                         IconButton(
//                           icon: Icon(
//                             isMuted ? Icons.volume_off : Icons.volume_up,
//                           ),
//                           onPressed: () =>
//                               controller.setVolume(isMuted ? 1 : 0),
//                         ),
//                         /*GestureDetector(
//                           child: const Icon(
//                             Icons.fullscreen,
//                             color: Colors.white,
//                             size: 28,
//                           ),
//                           //onTap: onClickedFullScreen,
//                         ),*/
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               ),
//             ],
//           )
//         : SizedBox(
//             height: 267.h,
//             child: Center(child: CircularProgressIndicator()),
//           );
//   }
//
//   Widget buildVideo() => Container(
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(16)),
//         ),
//         //margin: EdgeInsets.symmetric(horizontal: 37.w),
//         // padding: EdgeInsets.all(0),
//         child: Stack(
//           children: <Widget>[
//             buildVideoPlayer(),
//             Positioned.fill(child: BasicOverlayWidget(controller: controller)),
//           ],
//         ),
//       );
//
//   Widget buildIndicator() => VideoProgressIndicator(
//         controller,
//         allowScrubbing: true,
//         colors: VideoProgressColors(playedColor: kYellow),
//       );
//
//   Widget buildVideoPlayer() => AspectRatio(
//         aspectRatio: controller.value.aspectRatio,
//         child: VideoPlayer(controller),
//       );
// }
//
// class BasicOverlayWidget extends StatelessWidget {
//   final VideoPlayerController controller;
//
//   const BasicOverlayWidget({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//         behavior: HitTestBehavior.opaque,
//         onTap: () =>
//             controller.value.isPlaying ? controller.pause() : controller.play(),
//         child: Stack(
//           children: <Widget>[
//             buildPlay(),
//             /* Positioned(
//               bottom: 2.h,
//               left: 0,
//               right: 0,
//               child: buildIndicator(),
//             ),*/
//           ],
//         ),
//       );
//
//   Widget buildIndicator() => VideoProgressIndicator(
//         controller,
//         allowScrubbing: true,
//         colors: VideoProgressColors(playedColor: kYellow),
//       );
//
//   Widget buildPlay() => controller.value.isPlaying
//       ? Container()
//       : Container(
//           alignment: Alignment.center,
//           color: Colors.black26,
//           child: Icon(Icons.play_arrow, color: Colors.white, size: 80),
//         );
// }

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../shared/styles/colors.dart';

/*
class VideoWidget extends StatefulWidget {
  final String url;
  const VideoWidget({Key? key, required this.url}) : super(key: key);

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
 int rotate = 0;
 double width = 395.w;
 double height = 250.h;
 bool showRotateButton = false;
  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: rotate,
       child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              ClipRRect(
                child: WebView(
                  initialUrl:
                      widget.url,
                  onWebViewCreated:(v){

                  },
                  onPageStarted: (v){
                    showRotateButton = true;
                    setState(() {
                    });
                  },
                ),
                borderRadius: BorderRadius.all(Radius.circular(15.sp)),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Visibility(
                  visible:showRotateButton,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.sp)),
                      color:const Color(0xFFE5E5E5).withOpacity(0.8)
                    ),
                    height: 50.h,
                    width: 50.w,
                    child: IconButton(
                      icon: Icon(Icons.screen_rotation_outlined,size: 25.sp,),
                      onPressed: () {
                       if(rotate==1){
                         width = 395.w;
                         height =250.h;
                         rotate =0;
                       }else{
                         rotate =1;
                         width = 755.h;
                         height =395.w;
                       }
                        setState(() {
                        });
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
       ),
    );
  }
}
*/

class VideoWidget extends StatefulWidget {
  final String url;

  const VideoWidget({Key? key, required this.url}) : super(key: key);

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  int? rotate;
  int ? mod;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rotate = 0;
    mod = 0;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RotatedBox(
          quarterTurns: rotate!,
          child: Stack(
            children: [
              WebView(
                initialUrl: widget.url,
                onWebViewCreated: (v) {},
              ),
              Positioned.fill(
                bottom: 0,
                right: 0,
                child: Align(
                  alignment: context.locale == const Locale('ar')?Alignment.bottomLeft:Alignment.bottomRight,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.sp)),
                        color: const Color(0xFFE5E5E5).withOpacity(0.8)),
                    height: 50.h,
                    width: 50.w,
                    child: IconButton(
                      icon: Icon(
                        Icons.screen_rotation_outlined,
                        size: 25.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          mod = mod!+1;
                          if(mod!%2==1){
                            rotate=1;
                          }
                          else{
                            rotate =0;
                          }
                          //rotate = rotate!+1;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: context.locale == const Locale('ar')?Alignment.topRight:Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.sp)),
                        color: const Color(0xFFE5E5E5).withOpacity(0.8)),
                    height: 50.h,
                    width: 50.w,
                    child: IconButton(
                      icon: Icon(
                        //context.locale == const Locale('ar')?Icons.arrow_back:Icons.arrow_forward,
                        Icons.arrow_back,
                        size: 35.sp,
                        color: kBlack,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
