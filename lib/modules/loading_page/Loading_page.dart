

import 'package:easy_localization/easy_localization.dart';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_sdk/zoom_options.dart';
import 'package:flutter_zoom_sdk/zoom_view.dart';
import 'package:mal/main.dart';
import 'package:mal/shared/components/app_routes.dart';
import 'package:mal/shared/components/snack_bar.dart';
import 'package:mal/shared/network/local/shared_preferences.dart';
import 'package:mal/shared/styles/colors.dart';
import 'package:mal/translations/locale_keys.g.dart';
import 'package:uni_links/uni_links.dart';

import '../../shared/components/error_network_connection.dart';
import 'cubit/Loading_states.dart';
import 'cubit/loading_cubit.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  late bool _initialURILinkHandled;
  String appKey = "8swfbiytKbLKGVZ2myYfUH279Vbo8WAUj7QZ";
  String appSecret = "a3ypyI4yPB6tr7StZKa4GC1bo7NwPx2jD3Kw";

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _initialURILinkHandled = false;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/launcher_icon',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new messageopen app event was published');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        Navigator.pushReplacementNamed(context, AppRoutes.loadingPage);
      }
    });

    if (SharedPrefHelper.getCurrentMFCToken() == null) {
      FirebaseMessaging.instance.getToken().then((value) {
        SharedPrefHelper.saveMFCToken(mFCToken: value.toString())
            .then((value) {});
      });
    }
    print('don\'t save');
    print(SharedPrefHelper.getCurrentMFCToken());
    _initURIHandler();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoadingCubit, LoadingStates>(
      listener: (context, state) {
        if (state is GotoLoginScreenState) {
          print('go to login');
          Navigator.pushReplacementNamed(context, AppRoutes.loginScreenRoute);
        } else if (state is GetUserDetailsErrorState) {
          CustomSnackBar.buildErrorSnackBar(context , state.error.toString() );
        } else if (state is GetUserDetailsSuccessState) {
          print('go to home');
          Navigator.pushReplacementNamed(context, (AppRoutes.appLayoutRoute));
        }
        else if (state is GetUserDetailsErrorConnectionState) {
          CustomSnackBar.buildErrorSnackBar(context,  state.error.toString());
        }
      },
      builder: (context, state) {
        var cubit = LoadingCubit.get(context);
        return SafeArea(
          child: Scaffold(
            body: cubit.stillCheck
                ? Center(
                    child: CircularProgressIndicator(
                        color: kYellow, backgroundColor: kGray),
                  )
                : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Visibility(
                            visible:cubit.shouldLogin,
                            child: Column(
                              children: [
                                SizedBox(height: 210.h,),
                                SvgPicture.asset(
                                  'assets/svg/security.svg',
                                  height: 200.h,
                                  width: 300.w,
                                ),
                                SizedBox(
                                  height: 100.h,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, AppRoutes.loginScreenRoute);
                                  },
                                  child: Container(
                                    width: 250.0.w,
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(12.r),
                                      color: kYellow,
                                    ),
                                    child: Center(
                                      child: Text(
                                        LocaleKeys.login.tr(),
                                        style: TextStyle(
                                            fontSize: 22.0.r,
                                            color: kBlack,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible:cubit.internetConnectionError,
                            child: ErrorNetworkConnection(onCallback: (){
                              cubit.checker();
                            }),
                          ),
                          SizedBox(width:MediaQuery.of(context).size.width,)
                        ],
                      )
          ),
        );
      },
    );
  }

  Future<void> _initURIHandler() async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      try {
        final initialURI = await getInitialUri();
        // Use the initialURI and warn the user if it is not correct,
        // but keep in mind it could be `null`.
        if (initialURI != null) {
          if (initialURI.pathSegments.length > 1) {
            String meetId = initialURI.pathSegments[1];
            String meetPassword = initialURI.queryParameters["pwd"]??"";
            startZoomMeet(meetId, meetPassword);
          }
          debugPrint("Initial URI received $initialURI");
          if (!mounted) {
            return;
          }
        } else {
          debugPrint("Null Initial URI received");
        }
      } on PlatformException {
        // Platform messages may fail, so we use a try/catch PlatformException.
        // Handle exception by warning the user their action did not succeed
        debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) {
        if (!mounted) {
          return;
        }
        debugPrint('Malformed Initial URI received');
      }
    }
  }

  void startZoomMeet(String meetId, String meetPassword) {
    bool _isMeetingEnded(String status) {
      var result = false;

      if (Platform.isAndroid) {
        result = status == "MEETING_STATUS_DISCONNECTING" ||
            status == "MEETING_STATUS_FAILED";

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

    var meetingOptions = ZoomMeetingOptions(
      meetingId: meetId,
      meetingPassword: meetPassword,
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

        }).catchError((error){
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
