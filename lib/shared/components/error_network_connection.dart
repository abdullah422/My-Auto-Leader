import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mal/shared/styles/colors.dart';
import 'package:mal/shared/styles/text_styles.dart';

import '../../translations/locale_keys.g.dart';

class ErrorNetworkConnection extends StatelessWidget {
  final bool? fromAlert;
  final Function onCallback;

  const ErrorNetworkConnection(
      {Key? key, required this.onCallback, this.fromAlert})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        fromAlert ?? false
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 15.h,
                  ),
                  image(),
                  SizedBox(
                    height: 20.h,
                    width: MediaQuery.of(context).size.width,
                  ),
                  InkWell(
                      onTap: () {
                        onCallback();
                      },
                      child: buttonContent()),
                  SizedBox(
                    height: 20.h,
                    width: MediaQuery.of(context).size.width,
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 210.h,
                    width: MediaQuery.of(context).size.width,
                  ),
                  image(),
                  SizedBox(
                    height: 80.h,
                    width: MediaQuery.of(context).size.width,
                  ),
                  InkWell(
                    onTap: () {
                      onCallback();
                    },
                    child: buttonContent(),
                  ),
                ],
              ),
      ],
    );
  }

  Widget image() {
    return SvgPicture.asset(
      'assets/svg/undraw_broadcast_jhwx.svg',
      height: 200.h,
      width: 300.w,
    );
  }

  Widget buttonContent() {
    return Container(
      width: 250.0.w,
      height: 50.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: kYellow,
      ),
      child: Center(
        child: Text(
          LocaleKeys.try_again.tr(),
          style: buttonTextBlackStyle,
        ),
      ),
    );
  }
}
