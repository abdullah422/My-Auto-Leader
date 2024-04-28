import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal/model/notification_model.dart' as noti;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mal/modules/notifications/cubit/notification_cubit.dart';
import 'package:mal/modules/notifications/cubit/notification_states.dart';
import 'package:mal/shared/components/app_bar.dart';
import 'package:mal/shared/components/circular_Progress.dart';
import 'package:mal/shared/components/error_network_connection.dart';
import 'package:mal/shared/components/snack_bar.dart';
import 'package:mal/shared/styles/text_styles.dart';
import 'package:mal/translations/locale_keys.g.dart';

import '../../shared/styles/colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationCubit, NotificationStates>(
      listener: (context, state) {
        if (state is GetAllNotificationErrorState) {
          CustomSnackBar.buildErrorSnackBar(context, state.error);
        } else if (state is GetAllNotificationErrorState) {
          CustomSnackBar.buildErrorSnackBar(context, state.error);
        }
      },
      builder: (context, state) {
        var nCubit = NotificationCubit.get(context);
        return Scaffold(
          appBar: CustomAppBar(title: LocaleKeys.notification.tr()),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: nCubit.getNotificationLoading
                ? Center(
                    child: CustomCircularProgress(
                      cColor: kYellow,
                    ),
                  )
                : nCubit.internetConnectionError
                    ? ErrorNetworkConnection(onCallback: () {
                        nCubit.getAllNotifications();
                      })
                    : nCubit.notification.isEmpty
                        ? NoDateFound(
                            message: LocaleKeys.no_notifications_yet.tr(),
                          )
                        : ListView.builder(
                            itemCount: nCubit.notification.length,
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: EdgeInsets.only(top: 16.h,bottom:nCubit.notification.length==index+1?16.h:0),
                                child: NotificationItem(
                                  notification: nCubit.notification[index],
                                ),
                              );
                            },
                          ),
          ),
        );
      },
    );
  }
}

class NotificationItem extends StatelessWidget {
  final noti.Notification notification;

  const NotificationItem({Key? key, required this.notification})
      : super(key: key);

  String calculateTimeDifferenceBetween(
      {required DateTime startDate, required DateTime endDate}) {
    int seconds = endDate.difference(startDate).inSeconds.abs();
    print(seconds);
    if (seconds < 60) {
      return '${seconds.abs()} ${LocaleKeys.second.tr()}';
    } else if (seconds >= 60 && seconds < 3600) {
      return '${startDate.difference(endDate).inMinutes.abs()} ${LocaleKeys.mminute.tr()}';
    } else if (seconds >= 3600 && seconds < 86400) {
      return '${startDate.difference(endDate).inHours.abs()} ${LocaleKeys.hours.tr()}';
    } else {
      return '${startDate.difference(endDate).inDays.abs()} ${LocaleKeys.day.tr()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
          color: const Color(0xFFEBEBEB),
          borderRadius: BorderRadius.all(Radius.circular(12.sp))),
      //height: 70.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 65.sp,
            width: 65.sp,
            margin: EdgeInsets.only(top: 10.h),
            decoration: BoxDecoration(
              border: Border.all(color: kBorder, width: 1),
              borderRadius: const BorderRadius.all(
                Radius.circular(100),
              ),
            ),
            child: CircleAvatar(
              backgroundColor: kYellow,
              child: Padding(
                padding: EdgeInsets.all(6.sp),
                child: ClipOval(
                    child: notification.role == 'all'
                        ? Image.asset(
                            'assets/images/SIMPLY.png',
                            width: 60.sp,
                            height: 60.sp,
                          )
                        : Center(
                            child: Icon(
                              Icons.lock,
                              color: kBlack,
                              size: 30.sp,
                            ),
                          )),
              ),
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 3.h,
              ),
              Text(
                notification.title.toString(),
                style: GoogleFonts.notoKufiArabic(
                    fontSize: 19.sp, fontWeight:FontWeight.w600, color: kBlack),
              ),
              SizedBox(
                child: Text(
                  notification.body.toString(),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.notoKufiArabic(
                      fontSize: 16.sp,
                      color: kBlack),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    calculateTimeDifferenceBetween(
                        startDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                            .parse(notification.createdAt.toString(),true),
                        endDate: DateTime.now())+' ${LocaleKeys.ago.tr()}',style: GoogleFonts.notoKufiArabic(
                      fontSize: 13.sp, color: kBlack),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
//Text(new DateTime.fromMillisecondsSinceEpoch(values[index]["start_time"]*1000).toString(),
}

class NoDateFound extends StatelessWidget {
  final String message;

  const NoDateFound({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 155.h,
        ),
        Container(
          width: 428.w,
          margin: EdgeInsets.symmetric(horizontal: 50.w),
          child: SizedBox(
            width: 300.w,
            height: 300.h,
            child: SvgPicture.asset(
              'assets/svg/no_data.svg',
            ),
          ),
        ),
        SizedBox(
          height: 30.h,
        ),
        SizedBox(
          child: Text(
            message,
            style: messageForSucOrFai,
          ),
        )
      ],
    );
  }
}
