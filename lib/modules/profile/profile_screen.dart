import 'dart:io';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mal/layout/cubit/layout_cubit.dart';
import 'package:mal/modules/login/cubit/auth_cubit.dart';
import 'package:mal/modules/login/cubit/auth_states.dart';
import 'package:mal/shared/components/alert_dialog.dart';
import 'package:mal/shared/components/app_routes.dart';
import 'package:mal/shared/components/error_network_connection.dart';
import 'package:mal/shared/components/snack_bar.dart';
import 'package:mal/shared/network/local/shared_preferences.dart';
import 'package:mal/shared/network/remote/end_points.dart';
import 'package:mal/shared/styles/text_styles.dart';
import 'package:mal/shared/transparent_image.dart';
import 'package:mal/translations/locale_keys.g.dart';

import '../../shared/styles/colors.dart';
import 'Privacy.dart';
import 'terms_screen.dart';
import 'about_us_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AuthCubit outerAuthCubit;

  @override
  void initState() {
    super.initState();
    outerAuthCubit = AuthCubit();
    outerAuthCubit.getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is GetUserProfileErrorState) {
            CustomSnackBar.buildErrorSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          var authCubit = AuthCubit.get(context);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: authCubit.getUserProfileLoading ? 320.h : 375.h,
                  //height: 375.h,
                  child: Stack(
                    children: [
                      Container(
                        width: 428.0.w,
                        height: 223.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(25.sp),
                          ),
                          color: kYellow,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.16),
                              offset: const Offset(0, 11.0),
                              blurRadius: 25.0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 43.h,
                                  margin: EdgeInsets.only(
                                      left: 26.w, right: 26.w, top: 22.h),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.start,
                            ),
                            Image.asset(
                              'assets/images/SIMPLY.png',
                              width: 171.w,
                              height: 48.h,
                            ),
                          ],
                        ),
                      ),
                      authCubit.getUserProfileLoading
                          ? Center(
                              child: CircularProgressIndicator(color: kYellow),
                            )
                          :
                          //Center(child: CircularProgressIndicator(color: kYellow),),
                          Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 164.sp,
                                      width: 164.sp,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: kBorder, width: 6),
                                          shape: BoxShape.circle,
                                          color: kWhite),
                                      child: SizedBox(
                                        height: 164.sp,
                                        width: 164.sp,
                                        child: SizedBox(
                                          child: CircleAvatar(
                                            child: Center(
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      '${EndPoints.baseUrlForImage}${authCubit.userProfile == null ? '' : authCubit.userProfile!.image}',
                                                  placeholder: (context, url) =>Center(child: CircularProgressIndicator(color: kYellow,),),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                    height: 164.sp,
                                                    width: 164.sp,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            foregroundColor: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 70.h,
                                      width: 200.w,
                                      child: Center(
                                        child: Text(
                                          authCubit.user == null
                                              ? ''
                                              : authCubit.user!.username,
                                          style: titleBlackStyle,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                authCubit.getUserProfileLoading || authCubit.getSettingsLoading
                    ? authCubit.getUserProfileErrorConnection ||
                            authCubit.getSettingsErrorConnection
                        ? ErrorNetworkConnection(
                            fromAlert: true,
                            onCallback: () {
                              if (authCubit.getUserProfileErrorConnection) {
                                authCubit.getUserProfile();
                              } else if (authCubit.getSettingsErrorConnection) {
                                authCubit.getSettings();
                              }
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(
                              color: kYellow,
                            ),
                          )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.userInformation,
                                  arguments: authCubit);
                            },
                            child: SizedBox(
                              width: 406.w,
                              height: 52.h,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SvgPicture.string(
                                    // Icon awesome-user-edit
                                    '<svg viewBox="47.53 450.0 25.94 20.76" ><path transform="translate(47.53, 450.0)" d="M 9.080456733703613 10.37766456604004 C 11.9464750289917 10.37766456604004 14.26928901672363 8.054851531982422 14.26928901672363 5.18883228302002 C 14.26928901672363 2.322813034057617 11.9464750289917 0 9.080456733703613 0 C 6.214437007904053 0 3.891624450683594 2.322813272476196 3.891624450683594 5.18883228302002 C 3.891624450683594 8.054851531982422 6.214437007904053 10.37766456604004 9.080456733703613 10.37766456604004 Z M 12.71263885498047 11.67487239837646 L 12.03565788269043 11.67487239837646 C 11.13571929931641 12.08835792541504 10.13443756103516 12.32347774505615 9.080455780029297 12.32347774505615 C 8.026473999023438 12.32347774505615 7.029244899749756 12.08835792541504 6.125253677368164 11.67487239837646 L 5.448273181915283 11.67487239837646 C 2.440372705459595 11.67487239837646 0 14.11524486541748 0 17.12314605712891 L 0 18.80951690673828 C 0 19.88376808166504 0.8715616464614868 20.75532913208008 1.945812225341797 20.75532913208008 L 13.08963966369629 20.75532913208008 C 12.99234962463379 20.47967147827148 12.95181179046631 20.18779945373535 12.98424339294434 19.89187431335449 L 13.25990009307861 17.42312431335449 L 13.30854511260986 16.9731559753418 L 13.62879371643066 16.65290641784668 L 16.76236152648926 13.5193395614624 C 15.76918601989746 12.39644336700439 14.33009719848633 11.67487144470215 12.7126407623291 11.67487144470215 Z M 14.548996925354 17.56500816345215 L 14.27334213256836 20.03781127929688 C 14.22875022888184 20.45129585266113 14.57737636566162 20.79992294311523 14.98680686950684 20.75127601623535 L 17.45555686950684 20.47561836242676 L 23.04571151733398 14.88546276092529 L 20.13915634155273 11.97890377044678 L 14.54899978637695 17.56500625610352 Z M 25.66039657592773 10.90060138702393 L 24.12401580810547 9.36422061920166 C 23.74701309204102 8.98721981048584 23.13083839416504 8.98721981048584 22.75383949279785 9.36422061920166 L 21.22150993347168 10.89654731750488 L 21.05530548095703 11.06275177001953 L 23.96591758728027 13.96930885314941 L 25.66039657592773 12.27483081817627 C 26.03739929199219 11.89377498626709 26.03739929199219 11.28165626525879 25.66039657592773 10.90060043334961 Z" fill="#1c1b21" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                    width: 24.w,
                                    height: 19.h,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    LocaleKeys.edit_profile.tr(),
                                    style: titleBlackStyle,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: kIconGray,
                                  )
                                  /*Directionality(
                                    textDirection:ui.TextDirection.ltr,
                                    child: SvgPicture.asset(
                                      'assets/svg/profile_arrow.svg',
                                      width: 25.w,
                                      height: 20.76.h,
                                    ),
                                  ),*/
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.editZoomEmail);
                            },
                            child: SizedBox(
                              height: 52.h,
                              width: 406.w,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Icon(
                                    Icons.meeting_room,
                                    size: 19.78.w,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    LocaleKeys.edit_zoom_email.tr(),
                                    style: titleBlackStyle,
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: kIconGray,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(AppRoutes.office);
                            },
                            child: SizedBox(
                              height: 52.h,
                              width: 406.w,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Icon(
                                    Icons.business_center,
                                    size: 19.78.w,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    LocaleKeys.go_to_office.tr(),
                                    style: titleBlackStyle,
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: kIconGray,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          BlocBuilder<AuthCubit, AuthStates>(
                            bloc: outerAuthCubit,
                            builder: (context, innerState) {
                              return InkWell(
                                onTap: () {
                                  if (innerState
                                      is GetUserProfileSuccessState) {
                                    Navigator.of(context).pushNamed(
                                        AppRoutes.services,
                                        arguments: {
                                          "url": innerState
                                                  .userProfile?.simplyUrl ??
                                              ""
                                        });
                                  }
                                },
                                child: SizedBox(
                                  height: 52.h,
                                  width: 406.w,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Icon(
                                        Icons.design_services,
                                        size: 19.78.w,
                                      ),
                                      SizedBox(
                                        width: 15.w,
                                      ),
                                      Text(
                                        LocaleKeys.go_to_services.tr(),
                                        style: titleBlackStyle,
                                      ),
                                      const Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: kIconGray,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(AppRoutes.groups);
                            },
                            child: SizedBox(
                              height: 52.h,
                              width: 406.w,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Icon(
                                    Icons.group,
                                    size: 19.78.w,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    LocaleKeys.groups.tr(),
                                    style: titleBlackStyle,
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: kIconGray,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              CustomAlert.buildAlert(
                                  context, buildAlertContent());
                              /*  showAlertDialog(context);*/
                            },
                            child: SizedBox(
                              height: 52.h,
                              width: 406.w,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/svg/language.svg',
                                    width: 18.78.w,
                                    height: 22.95.h,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    LocaleKeys.language.tr(),
                                    style: titleBlackStyle,
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: kIconGray,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => AboutUsScreen(
                                            htmlCode: authCubit.settings!.about
                                                .toString(),
                                            links: {
                                              'facebook':
                                                  authCubit.settings!.facebook,
                                              'Instagram':
                                                  authCubit.settings!.instagram,
                                              'linkedIn':
                                                  authCubit.settings!.linkedin,
                                              'tiktok':
                                                  authCubit.settings!.tiktok,
                                              'twitter':
                                                  authCubit.settings!.twitter,
                                              'youtube':
                                                  authCubit.settings!.youtube
                                            },
                                          )));
                            },
                            child: SizedBox(
                              height: 52.h,
                              width: 406.w,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svg/about.svg',
                                        width: 16.w,
                                        height: 20.h,
                                      ),
                                      SizedBox(
                                        width: 14.w,
                                      ),
                                      Text(
                                        LocaleKeys.about_us.tr(),
                                        style: titleBlackStyle,
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: kIconGray,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Privacy(
                                            logo: authCubit.settings!.logo
                                                .toString(),
                                            htmlCode: authCubit
                                                .settings!.privacy
                                                .toString(),
                                          )));
                            },
                            child: SizedBox(
                              height: 52.h,
                              width: 406.w,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/svg/shield-svgrepo-com.svg',
                                    width: 20.w,
                                    height: 24.h,
                                  ),
                                  SizedBox(
                                    width: 17.w,
                                  ),
                                  Text(
                                    LocaleKeys.privacy.tr(),
                                    style: titleBlackStyle,
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: kIconGray,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => TermsScreen(
                                            htmlCode: authCubit.settings!.faq
                                                .toString(),
                                          )));
                            },
                            child: SizedBox(
                              height: 52.h,
                              width: 406.w,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/svg/lock-privacy-svgrepo-com (1).svg',
                                    width: 18.78.w,
                                    height: 22.95.h,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    LocaleKeys.terms.tr(),
                                    style: titleBlackStyle,
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: kIconGray,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              var cubit = LayoutCubit.get(context);
                              await SharedPrefHelper.deleteUserToken()
                                  .then((value) {
                                print("token" +
                                    SharedPrefHelper.getUserToken().toString());
                                cubit.currentIndex = 0;
                                Navigator.pushReplacementNamed(
                                    context, AppRoutes.loadingPage);
                              });
                            },
                            child: SizedBox(
                              height: 52.h,
                              width: 406.w,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/svg/logout.svg',
                                    width: 18.w,
                                    height: 22.h,
                                  ),
                                  SizedBox(
                                    width: 12.w,
                                  ),
                                  Text(
                                    LocaleKeys.logout.tr(),
                                    style: titleGrayStyle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: kIconGray,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildAlertContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          LocaleKeys.select_language.tr(),
          style: titleBlackStyle,
        ),
        SizedBox(
          height: 30.h,
          width: 300.w,
        ),
        InkWell(
          onTap: () async {
            if (context.locale == const Locale('en')) {
            } else {
              await context.setLocale(const Locale('en')).then((value) async {
                await SharedPrefHelper.saveLanguage(lang: 'en').then((value) {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.loadingPage);
                });
              });
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                color: const Color(0xFFEBEBEB)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/english.png',
                      height: 27.h,
                      width: 40.w,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      'English',
                      style: label1Style,
                    ),
                  ],
                ),
                SizedBox(
                  width: 50.w,
                  child: context.locale == const Locale('en')
                      ? Icon(
                          Icons.done_outline_outlined,
                          color: kYellow,
                        )
                      : null,
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
        InkWell(
          onTap: () async {
            if (context.locale == const Locale('ar')) {
            } else {
              await context.setLocale(const Locale('ar')).then((value) async {
                await SharedPrefHelper.saveLanguage(lang: 'ar').then((value) {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.loadingPage);
                });
              });
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                color: const Color(0xFFEBEBEB)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/arabic.png',
                      height: 27.h,
                      width: 40.w,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      'العربية',
                      style: languageStyle,
                    ),
                  ],
                ),
                SizedBox(
                  width: 50.w,
                  child: context.locale == const Locale('ar')
                      ? Icon(
                          Icons.done_outline_outlined,
                          color: kYellow,
                        )
                      : null,
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
        InkWell(
          onTap: () async {
            if (context.locale == const Locale('fr')) {
            } else {
              await context.setLocale(const Locale('fr')).then((value) async {
                await SharedPrefHelper.saveLanguage(lang: 'fr').then((value) {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.loadingPage);
                });
              });
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                color: const Color(0xFFEBEBEB)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/france.png',
                      height: 27.h,
                      width: 40.w,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      'Français',
                      style: languageStyle,
                    ),
                  ],
                ),
                SizedBox(
                  width: 50.w,
                  child: context.locale == const Locale('fr')
                      ? Icon(
                          Icons.done_outline_outlined,
                          color: kYellow,
                        )
                      : null,
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
        InkWell(
          onTap: () async {
            if (context.locale == const Locale('de')) {
            } else {
              await context.setLocale(const Locale('de')).then((value) async {
                await SharedPrefHelper.saveLanguage(lang: 'de').then((value) {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.loadingPage);
                });
              });
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                color: const Color(0xFFEBEBEB)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/germany.png',
                      height: 27.h,
                      width: 40.w,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      'Deutsche',
                      style: languageStyle,
                    ),
                  ],
                ),
                SizedBox(
                  width: 50.w,
                  child: context.locale == const Locale('de')
                      ? Icon(
                          Icons.done_outline_outlined,
                          color: kYellow,
                        )
                      : null,
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
        InkWell(
          onTap: () async {
            if (context.locale == const Locale('bn')) {
            } else {
              await context.setLocale(const Locale('bn')).then((value) async {
                await SharedPrefHelper.saveLanguage(lang: 'bn').then((value) {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.loadingPage);
                });
              });
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                color: const Color(0xFFEBEBEB)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/bangladesh.png',
                      height: 27.h,
                      width: 40.w,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      'বাংলা',
                      style: languageStyle,
                    ),
                  ],
                ),
                SizedBox(
                  width: 50.w,
                  child: context.locale == const Locale('bn')
                      ? Icon(
                          Icons.done_outline_outlined,
                          color: kYellow,
                        )
                      : null,
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
        InkWell(
          onTap: () async {
            if (context.locale == const Locale('tr')) {
            } else {
              await context.setLocale(const Locale('tr')).then((value) async {
                await SharedPrefHelper.saveLanguage(lang: 'tr').then((value) {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.loadingPage);
                });
              });
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                color: const Color(0xFFEBEBEB)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/turkey.png',
                      height: 27.h,
                      width: 40.w,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      'Türkçe',
                      style: languageStyle,
                    ),
                  ],
                ),
                SizedBox(
                  width: 50.w,
                  child: context.locale == const Locale('tr')
                      ? Icon(
                          Icons.done_outline_outlined,
                          color: kYellow,
                        )
                      : null,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
