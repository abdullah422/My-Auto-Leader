import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mal/shared/components/app_routes.dart';
import 'package:mal/shared/network/local/shared_preferences.dart';
import 'package:mal/translations/locale_keys.g.dart';

import '../styles/colors.dart';
import '../styles/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final int? index;

  const CustomAppBar({Key? key, this.title, this.index}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(78.h);

  @override
  Widget build(BuildContext context) {

    return AppBar(
      title: index == 0
          ? const AppBarImage()
          : Text(title != null
              ? title.toString()
              : index == 1
                  ? LocaleKeys.stages.tr()
                  : index == 2
                      ? 'Zoom'
                      : index == 3
                          ? LocaleKeys.share_messages.tr()
                          : '',overflow: TextOverflow.ellipsis),
      titleTextStyle: headingStyle,
      centerTitle: true,
      backgroundColor: kYellow,
      elevation: 0,
      toolbarHeight: 78.h,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.r),
          bottomRight: Radius.circular(25.r),
        ),
      ),
      leadingWidth: 63.w,
      leading: title != null
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 35.sp,
                color: kBlack,
              ),
            )
          : null,
      actions: [
        Visibility(
          visible: title != LocaleKeys.notification.tr() &&
              title != LocaleKeys.edit_profile.tr(),
          child: Padding(
            padding: EdgeInsets.only(right: 25.8.w, left: 25.8.w),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20.h),
              child: const NotificationIcon()
            ),
          ),
        ),
      ],
      automaticallyImplyLeading: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }
}

class AppBarImage extends StatelessWidget {
  const AppBarImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      width: 117.w,
      child: Image.asset(
        'assets/images/SIMPLY.png',
        width: 171.w,
        height: 48.h,
      ),
    );
  }
}


class NotificationIcon extends StatefulWidget {

  const NotificationIcon({Key? key}) : super(key: key);

  @override
  State<NotificationIcon> createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon> {
  var numberOfN  =SharedPrefHelper.getNewNumberOfNoti()??0;
  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: ()async {
        await SharedPrefHelper.saveNewNumberOfNoti(number:0).then((value){
          setState(() {
            numberOfN = 0;
          });
          Navigator.pushNamed(
              context, AppRoutes.notificationScreenRoute);
        });

      },
      child:numberOfN==0?SvgPicture.asset(
        'assets/svg/notification.svg',
        width: 24.18.w,
        height: 27.3.h,
      ):Badge(
        badgeContent: Text(numberOfN.toString(),style: TextStyle(fontSize: 15.sp,color:kWhite),),
        child: SvgPicture.asset(
          'assets/svg/notification.svg',
          width: 24.18.w,
          height: 27.3.h,
        ),
      ),
    );
  }
}

