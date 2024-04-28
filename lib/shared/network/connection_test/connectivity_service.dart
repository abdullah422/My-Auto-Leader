import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../styles/colors.dart';
import '../../styles/text_styles.dart';
enum ConnectivityStatus{
  wifi,
  cellular,
  offline,
}
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._();
  factory ConnectivityService()=> _instance;

  Connectivity connectivity = Connectivity();
  StreamController<ConnectivityStatus>connectionStatusController=StreamController<ConnectivityStatus>();

  ConnectivityService._(){
    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      var connectionStatus = _getStatusFromResult(result);
      connectionStatusController.add(connectionStatus);
    });
  }

  ConnectivityStatus _getStatusFromResult(ConnectivityResult result){

    switch(result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.wifi;
      case ConnectivityResult.none:
          return ConnectivityStatus.offline;
      default:
        return ConnectivityStatus.offline;
    }

  }
  void buildErrorInternetConnectionSnackBar(
      GlobalKey<ScaffoldMessengerState> messengerKey,
      { String text = "No internet Connection",
        Color bgColor = Colors.red
      }){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      messengerKey.currentState?.showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: Colors.white,
                  size: 18.r,
                ),
                SizedBox(width: 8.w),
                Text(text,
                    style: errorTextStyle, overflow: TextOverflow.visible),
              ],
            ),
            backgroundColor: kRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
          )
      );});
  }
}

