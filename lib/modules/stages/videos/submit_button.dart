import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mal/shared/components/circular_Progress.dart';
import 'package:mal/shared/styles/colors.dart';
import 'package:mal/translations/locale_keys.g.dart';

import '../../../shared/styles/text_styles.dart';

class SubmitButton extends StatelessWidget {
  final Function onTap;
  final bool submitLoading;

  const SubmitButton(
      {Key? key, required this.onTap, required this.submitLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(right: 16.w, left: 16.w, bottom: 30.h, top: 30.h),
      //height: 70.h,
      child: Row(
        children: [
          InkWell(
            onTap:(){
              if(!submitLoading){
                onTap();
              }
            },
            child: Directionality(
              textDirection: context.locale == const Locale('ar')
                  ? ui.TextDirection.ltr
                  : ui.TextDirection.rtl,
              child: Container(
                  width: 104.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0.sp),
                    color: kBlack,
                  ),
                  child: submitLoading
                      ? Center(
                          child: SizedBox(
                            child: CustomCircularProgress(cColor: kWhite),
                            height: 30.sp,
                            width: 30.sp,
                          ),
                        )
                      : SizedBox(
                          width: 80.w,
                          height: 24.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/svg/submit.svg',
                                width: 14.55.w,
                                height: 12.73.h,
                              ),
                              Text(
                                LocaleKeys.submit.tr(),
                                style: sendButton2Style,
                              ),
                            ],
                          ),
                        )),
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      ),
    );
  }
}
