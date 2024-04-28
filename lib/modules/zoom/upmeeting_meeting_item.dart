import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_sdk/zoom_options.dart';
import 'package:flutter_zoom_sdk/zoom_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal/model/meet_model.dart';
import 'package:mal/translations/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/styles/colors.dart';

class UpcomingMeetingItem extends StatefulWidget {
  const UpcomingMeetingItem(this.meetModel, this.callback, {Key? key})
      : super(key: key);
  final MeetModel meetModel;
  final Function(String, String) callback;

  @override
  State<UpcomingMeetingItem> createState() => _UpcomingMeetingItemState();
}

class _UpcomingMeetingItemState extends State<UpcomingMeetingItem> {
  late bool showLoading;

  String appKey = "pnKZm2RvtIlfKhcTzYEzRfhWif4VlZiVhc9t";
  String appSecret = "dnnxdjMsIYbyPlKyJ7Brkw6Zc9PF9xWfuWpU";

  // String appKey = "8swfbiytKbLKGVZ2myYfUH279Vbo8WAUj7QZ";
  // String appSecret = "a3ypyI4yPB6tr7StZKa4GC1bo7NwPx2jD3Kw";
  // String appKey = "hlshkk0eRCubj8fuEYUKIQ";
  // String appSecret = "vL9kpeFo15Fj6MU8tpDWJSolnfxLybmh";
  // String appKey = "cKybea4JTkON6_dbbaqqqg";
  // String appSecret = "KzOHRfDCYdgoKMvO28UoYNnGT32TqV12Mkj5";
  Timer? timer;

  @override
  void initState() {
    super.initState();
    showLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 16, end: 16, top: 16),
      padding: const EdgeInsetsDirectional.only(
          start: 16, top: 16, bottom: 16, end: 16),
      decoration: const BoxDecoration(
        color: Color(0xffe6e6e6),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/svg/meeting.svg',
            width: 24,
            height: 24,
          ),
          Container(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.meetModel.topic ?? "",
                style: GoogleFonts.almarai(
                  textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                convertToLocalDate(widget.meetModel.startTime),
                style: GoogleFonts.almarai(
                    textStyle:
                        const TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ],
          ),
          Expanded(child: Container()),
          Column(
            children: [
              InkWell(
                onTap: () async{
                  await launchUrl(Uri.parse(widget.meetModel.startUrl??""),mode: LaunchMode.externalApplication);
                },
                child: Container(
                  width: 84.w,
                  alignment: AlignmentDirectional.center,
                  margin: const EdgeInsetsDirectional.only(end: 0),
                  padding: EdgeInsetsDirectional.only(
                       start:4.w, top: 4.h, bottom: 4.h),
                  decoration: BoxDecoration(
                      color: kYellow,
                      borderRadius:
                      const BorderRadius.all(Radius.circular(12))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.start_as_host.tr(),
                        style: GoogleFonts.almarai(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Icon(Icons.person, color: Colors.black, size: 20.w,)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.h,),
              showLoading
                  ? Container(
                width: 84.w,
                alignment: AlignmentDirectional.center,
                      margin: const EdgeInsetsDirectional.only(end: 0),
                      padding:  EdgeInsetsDirectional.only(
                          start: 8.w, end: 8.w, top: 4.h, bottom: 4.h),
                      decoration: BoxDecoration(
                          color: kYellow,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12))),
                      child: SizedBox(
                        width: 16.w,
                        height: 16.h,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        if (!showLoading) {
                          // setState(() {
                          //   showLoading = true;
                          // });
                          startZoomMeet();
                          // widget.callback(widget.meetModel.startUrl??"", widget.meetModel.meetingId??"");
                        }
                      },
                      child: Container(
                        width: 84.w,
                        alignment: AlignmentDirectional.center,
                        margin: const EdgeInsetsDirectional.only(end: 0),
                        padding: EdgeInsetsDirectional.only(
                            start: 8.w, end: 8.w, top: 4.h, bottom: 4.h),
                        decoration: BoxDecoration(
                            color: kYellow,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              LocaleKeys.start_as_gust.tr(),
                              style: GoogleFonts.almarai(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Icon(Icons.group, color: Colors.black, size: 20.w,)
                          ],
                        ),
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }

  String convertToLocalDate(String? startTime) {
    if (startTime != null) {
      DateTime d =
          DateFormat("yyyy-MM-dd HH:mm:ss", "en").parse(startTime, true);
      d = d.toLocal();
      return DateFormat("yyyy/MM/dd HH:mm", "en").format(d);
    }
    return "";
  }

  void startZoomMeet() {
    bool _isMeetingEnded(String status) {
      var result = false;

      if (Platform.isAndroid) {
        result = status == "MEETING_STATUS_DISCONNECTING" ||
            status == "MEETING_STATUS_FAILED";
        setState(() {
          showLoading = false;
        });
      } else {
        result = status == "MEETING_STATUS_IDLE";
      }

      return result;
    }

    ZoomOptions zoomOptions = ZoomOptions(
      domain: "zoom.us",
      appKey: appKey, //API KEY FROM ZOOM
      appSecret: appSecret, //API SECRET FROM ZOOM
    );
    String url = widget.meetModel.startUrl ?? "";
    var uri = Uri.parse(url);
    setState(() {
      showLoading = true;
    });
    var meetUri = Uri.parse(widget.meetModel.joinUrl ?? "");
    String zak = uri.queryParameters["zak"] ?? "";
    String meetId = meetUri.path.substring(
      meetUri.path.lastIndexOf("/") + 1,
    );
    String meetPassword = meetUri.queryParameters["pwd"] ?? "";
    var meetingOptions = ZoomMeetingOptions(
      // zoomAccessToken: zak,
      userId: widget.meetModel.scheduleFor,
      // userPassword: 'zoomYE0*7#',
      meetingId: meetId,
      meetingPassword: meetPassword,
      // jwtAPIKey: "cKybea4JTkON6_dbbaqqqg",
      // jwtSignature: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOm51bGwsImlzcyI6ImNLeWJlYTRKVGtPTjZfZGJiYXFxcWciLCJleHAiOjE2NjE5ODQ5MTcsImlhdCI6MTY2MTg5ODUxN30.Ca13qwcDDk1Xh0FBtahbPEiuQ81oa3W3iEsqjxBHUTI"
      /// pass meeting password for join meeting only
      // disableDialIn: "false",
      // disableDrive: "true",
      // disableInvite: "false",
      // disableShare: "false",
      // disableTitlebar: "false",
      // viewOptions: "true",
      // noAudio: "false",
      // noDisconnectAudio: "false"
    );

    var zoom = ZoomView();
    zoom.initZoom(zoomOptions).then((results) {
      if (results[0] == 0) {
        zoom.onMeetingStatus().listen((status) {
          if (kDebugMode) {
            print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
          }
          if (_isMeetingEnded(status[0])) {
            if (kDebugMode) {
              print("[Meeting Status] :- Ended");
            }
            setState(() {
              showLoading = false;
            });
            timer?.cancel();
          }
          if (status[0] == "MEETING_STATUS_INMEETING") {
            zoom.meetinDetails().then((meetingDetailsResult) {
              if (kDebugMode) {
                print("[MeetingDetailsResult] :- " +
                    meetingDetailsResult.toString());
              }
            });
          }
        });
        if (kDebugMode) {
          print("listen on event channel");
        }
        zoom.joinMeeting(meetingOptions).then((loginResult) {
          // if (kDebugMode) {
          //   print(
          //       "[LoginResult] :- " + loginResult[0] + " - " + loginResult[1]);
          // }
          // if (loginResult[0] == "SDK ERROR") {
          //   //SDK INIT FAILED
          //   if (kDebugMode) {
          //     print((loginResult[1]).toString());
          //   }
          //   return;
          // } else if (loginResult[0] == "LOGIN ERROR") {
          //   //LOGIN FAILED - WITH ERROR CODES
          //   if (kDebugMode) {
          //     if (loginResult[1] ==
          //         ZoomError.ZOOM_AUTH_ERROR_WRONG_ACCOUNTLOCKED) {
          //       print("Multiple Failed Login Attempts");
          //     }
          //     print((loginResult[1]).toString());
          //   }
          //   return;
          // } else {
          //   //LOGIN SUCCESS & MEETING STARTED - WITH SUCCESS CODE 200
          //   if (kDebugMode) {
          //     print((loginResult[0]).toString());
          //   }
          // }
        }).catchError((error) {
          if (kDebugMode) {
            print("[Error Generated] : " + error);
          }
        });
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("[Error Generated] : " + error);
      }
    });
  }
}
