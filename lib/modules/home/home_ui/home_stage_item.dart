import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mal/model/stage_model.dart';
import 'package:mal/shared/components/alert_dialog.dart';
import 'package:mal/shared/styles/colors.dart';
import 'package:mal/shared/styles/text_styles.dart';
import 'package:mal/translations/locale_keys.g.dart';

class BuildHomeStageItem extends StatelessWidget {
  final int index;
  final Stage? stage;
  final Function onTap;

  const BuildHomeStageItem(
      {Key? key, this.stage, required this.onTap, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 328.h,
        margin: EdgeInsets.only(
            left: context.locale == const Locale('ar') ? 12.w : 0.w,
            right: context.locale == const Locale('ar') ? 0.w : 12.w),
        width: MediaQuery.of(context).textScaleFactor > 1.7 ? 250.w : 218.w,
        decoration: BoxDecoration(
          color: kBlack,
          borderRadius: BorderRadius.all(Radius.circular(12.sp)),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10.w,
                      height: 50.h,
                    ),
                    InkWell(
                      onTap: () {
                        CustomAlert.buildStageInfoAlert(
                            context: context,
                            stageInfo: {
                              'title': stage!.title,
                              'des': stage!.description,
                            });
                      },
                      child: Icon(
                        Icons.error_outline_rounded,
                        color: kWhite,
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    SizedBox(
                      width: 100.w,
                      child: Text(
                        stage!.title.toString(),
                        style: label3Style,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                      ),
                      child: CircleAvatar(
                        radius: 15.sp,
                        backgroundColor: kYellow,
                        child: Center(
                          child: Text(
                            index.toString(),
                            style: TextStyle(color: kBlack),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Center(
                  child: SizedBox(
                    child: SvgPicture.asset(
                      'assets/svg/Support.svg',
                      width: 100.w,
                      height: 160.h,
                    ),
                  ),
                ),
                SizedBox(
                  height: 37.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        LocaleKeys.enter_now.tr(),
                        style: label4Style,
                      ),
                      SizedBox(
                        width: 4.5.w,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: kYellow,
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                    ],
                  ),
                )
              ],
            ),
            stage!.status == 0
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.sp),
                      color: kBlack.withOpacity(0.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.16),
                          offset: const Offset(0, 7.0),
                          blurRadius: 21.0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset('assets/svg/lock.svg'),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
