import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/colors.dart';
import '../styles/text_styles.dart';

class CustomSnackBar {
  CustomSnackBar._();

  static buildErrorSnackBar(BuildContext context, String message,
      {int? seconds}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: seconds ?? 2),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: 18.r,
            ),
            SizedBox(width: 8.w),
            SizedBox(
              width: 300.w,
              child: Text(message,
                  style: errorTextStyle, overflow: TextOverflow.visible),
            ),
          ],
        ),
        backgroundColor: kRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
      ),
    );
  }

  static buildSuccessSnackBar(BuildContext context, String message, {int? seconds}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: seconds??4),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.done,
              color: Colors.white,
              size: 18.r,
            ),
            SizedBox(width: 8.w),
            Text(message,
                style: errorTextStyle, overflow: TextOverflow.visible),
          ],
        ),
        backgroundColor: kGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
      ),
    );
  }
}
