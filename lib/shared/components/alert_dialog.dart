import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mal/model/stage_model.dart';
import 'package:mal/shared/styles/text_styles.dart';

class CustomAlert {
  CustomAlert._();

  static buildAlert(BuildContext context, Widget content) {
    AlertDialog alert = AlertDialog(
      content: content,

    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  static buildAlertCanNotPop(BuildContext context, Widget content) {
    AlertDialog alert = AlertDialog(
      content: content,
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(onWillPop: () async => false, child: alert);
      },
    );
  }

  static buildDismissibleAlert(BuildContext context, Widget content){
    AlertDialog alert = AlertDialog(
      content: content,
    );
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return  alert;
      },
    );
  }

  static buildStageInfoAlert(
      {required BuildContext context, required Map<String, dynamic>
      stageInfo}) {
    AlertDialog alert = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(stageInfo['title'].toString(),style:titleStyle,),
          SizedBox(height: 10.h,),
          Text(stageInfo['des'].toString())
        ],
      ),

    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
