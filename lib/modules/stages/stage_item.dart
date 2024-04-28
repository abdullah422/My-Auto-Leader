import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mal/model/stage_model.dart';
import 'package:mal/shared/components/alert_dialog.dart';
import 'package:mal/shared/styles/colors.dart';
import 'package:mal/translations/locale_keys.g.dart';
import '../../shared/styles/text_styles.dart';

class BuildStageItem extends StatelessWidget {
  final Stage? stage;
  final int? index;

  const BuildStageItem({Key? key, this.stage, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 16.h),
        width: 396.0.w,
        height: MediaQuery.of(context).textScaleFactor >= 1.7 ? 220.h : 210.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.sp),
          color: kBlack,
        ),
        child: stage!.status == 1
            ? Column(
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
                        width: 250.w,
                        child: Text(
                          stage!.title.toString(),
                          style: label3Style,
                          overflow:TextOverflow.ellipsis,
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
                  SizedBox(
                    width: 140.w,
                    height: 110.h,
                    child: SvgPicture.asset('assets/svg/Support.svg'),
                  ),
                  SizedBox(
                    height: 50.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          LocaleKeys.enter_now.tr(),
                          style: label4Style,
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: kYellow,
                        ),
                        SizedBox(
                          width: 10.w,
                        )
                      ],
                    ),
                  )
                ],
              )
            : Stack(
                children: [
                  Center(
                    child: SizedBox(
                      width: 140.w,
                      height: 110.h,
                      child: SvgPicture.asset('assets/svg/Support.svg'),
                    ),
                  ),
                  Visibility(
                      visible: stage!.status == 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
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
                          child: SvgPicture.asset(
                            'assets/svg/lock.svg',
                            width: 70.w,
                            height: 70.h,
                          ),
                        ),
                      ))
                ],
              ));
  }
}
