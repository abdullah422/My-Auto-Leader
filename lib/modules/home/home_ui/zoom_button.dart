import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mal/shared/styles/text_styles.dart';
import 'package:mal/translations/locale_keys.g.dart';

import '../../../layout/cubit/layout_cubit.dart';
import '../../../shared/components/app_routes.dart';
import '../../../shared/styles/colors.dart';

class ZoomButton extends StatelessWidget {
  const ZoomButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
        await Navigator.of(context).pushNamed(AppRoutes.createMeeting);
        LayoutCubit.get(context).changeBottomNavBar(2);
      },
      child: Container(
        width: 250.w,
        height: 80.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: kBlack,
        ),
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Text(LocaleKeys.create_meeting.tr(),style:buttonTextWhiteStyle,),
            const SizedBox(width: 4,),
            SvgPicture.asset(
              'assets/svg/create_meeting.svg',
              width: 16,
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
