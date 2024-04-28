import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mal/modules/login/cubit/auth_cubit.dart';
import 'package:mal/modules/login/cubit/auth_states.dart';
import 'package:mal/shared/components/app_bar.dart';
import 'package:mal/shared/components/app_routes.dart';
import 'package:mal/shared/components/circular_Progress.dart';
import 'package:mal/shared/components/error_network_connection.dart';
import 'package:mal/shared/components/snack_bar.dart';
import 'package:mal/shared/network/remote/end_points.dart';
import 'package:mal/shared/styles/colors.dart';
import 'package:mal/shared/styles/text_styles.dart';
import 'package:mal/translations/locale_keys.g.dart';

import '../../shared/components/alert_dialog.dart';
import '../../shared/transparent_image.dart';

class UserInformationScreen extends StatefulWidget {
  /* final UserProfile userProfile;*/

  const UserInformationScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>.value(
      value: ModalRoute.of(context)!.settings.arguments as AuthCubit,
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is UpdateProfileSuccessState) {
            CustomAlert.buildAlertCanNotPop(
                context,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    SvgPicture.asset(
                      'assets/svg/done.svg',
                      width: 160.w,
                      height: 120.h,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                        child: Text(state.message.toString())),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 90.w,
                          height: 40.h,
                          margin: EdgeInsets.only(
                            left: 16.w,
                            right: 16.w,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: kBlack,
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, AppRoutes.loadingPage);
                            },
                            child: Center(
                              child: Text(
                                LocaleKeys.done.tr(),
                                style: sendButton2Style,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ));
          } else if (state is NoChangesHappened) {
            CustomSnackBar.buildErrorSnackBar(
                context, LocaleKeys.no_changes.tr());
          } else if (state is GetUserProfileErrorState) {
            CustomSnackBar.buildErrorSnackBar(context, state.error);
          }
          else if (state is UpdateProfileErrorState) {
            CustomSnackBar.buildErrorSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          var authCubit = AuthCubit.get(context);
          late TextEditingController phoneEditingController =
          TextEditingController(text: authCubit.userProfile!.phoneNumber);
          late TextEditingController telegramEditingController =
          TextEditingController(
              text: authCubit.userProfile!.telegramUsername);

          return Scaffold(
            appBar: CustomAppBar(title: LocaleKeys.edit_profile.tr()),
            body: authCubit.getUserProfileLoading
                ? authCubit.getUserProfileErrorConnection
                    ? ErrorNetworkConnection(
                        onCallback: () {
                          authCubit.getUserProfile();
                        },
                      )
                    : const Center(
                        child: CustomCircularProgress(),
                      )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 40.h),
                        Column(
                          children: [
                            Container(
                                height: 164.sp,
                                width: 164.sp,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: kBorder, width: 6),
                                    shape: BoxShape.circle,
                                    color: kWhite),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: 164.sp,
                                      width: 164.sp,
                                      child: CircleAvatar(
                                        child: ClipOval(
                                          child: authCubit.image == null
                                              ? Stack(
                                                  children: [
                                                    Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: kYellow,
                                                      ),
                                                    ),
                                                    FadeInImage.memoryNetwork(
                                                      placeholder:
                                                          kTransparentImage,
                                                      image:
                                                          '${EndPoints.baseUrlForImage}${authCubit.userProfile!.image}',
                                                      fit: BoxFit.cover,
                                                      height: 164.sp,
                                                      width: 164.sp,
                                                    ),
                                                  ],
                                                )
                                              : Image.file(
                                                  File(authCubit.image!.path),
                                                  fit: BoxFit.cover,
                                                  width: 164.sp,
                                                  height: 164.sp,
                                                ),
                                        ),
                                        foregroundColor: Colors.transparent,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: InkWell(
                                        onTap: () {
                                          authCubit.selectProfileImage();
                                        },
                                        child: SizedBox(
                                          height: 50.h,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color(0xFFE5E5E5),
                                            radius: 22.sp,
                                            child: Center(
                                                child: Icon(
                                              Icons.camera_alt_outlined,
                                              size: 25.sp,
                                              color: kBlack,
                                            ) /*SvgPicture.asset(
                                                      'assets/svg/camera.svg',
                                                    ),*/
                                                ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Container(
                          width: 396.w,
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 8.h,
                                  bottom: 10.h,
                                ),
                                child: SizedBox(
                                  height: 25.h,
                                  child: Text(
                                    LocaleKeys.phone_number.tr(),
                                    style: titleForTextFieldStyle,
                                  ),
                                ),
                              ),
                              TextFormField(
                                autocorrect: false,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.phone_enabled_outlined,
                                    color: kIconGray,
                                    size: 20.sp,
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                      maxHeight: 40.h,
                                      minHeight: 40.h,
                                      maxWidth: 40.w,
                                      minWidth: 40.w),
                                  hintText: '+20XXXXXXXXXXXX',
                                  hintStyle: TextStyle(
                                      fontSize: 14.sp,
                                      color: kHintForTextField),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.sp)),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.sp)),
                                    borderSide:
                                        BorderSide(color: kGray, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.sp)),
                                    borderSide:
                                        BorderSide(color: kGray, width: 2),
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                  ),
                                  errorStyle: TextStyle(
                                    fontSize: 12.sp,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    borderSide:
                                        BorderSide(color: kBorder, width: 2),
                                  ),
                                  //fillColor: kWhite,
                                  filled: true,
                                  //<-- SEE HERE
                                  fillColor: kWhiteForTextField,
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.only(top: 0, bottom: 0),
                                ),
                                maxLines: 1,
                                controller: phoneEditingController,
                                style: TextStyle(
                                  fontSize: 17.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Container(
                          width: 396.w,
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 8.h,
                                  bottom: 10.h,
                                ),
                                child: SizedBox(
                                  height: 25.h,
                                  child: Text(
                                    LocaleKeys.telegram_username.tr(),
                                    style: titleForTextFieldStyle,
                                  ),
                                ),
                              ),
                              TextFormField(
                                autocorrect: false,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.telegram_outlined,
                                    color: kIconGray,
                                    size: 20.sp,
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                      maxHeight: 40.h,
                                      minHeight: 40.h,
                                      maxWidth: 40.w,
                                      minWidth: 40.w),
                                  hintText: '@username',
                                  hintStyle: TextStyle(
                                      fontSize: 14.sp,
                                      color: kHintForTextField),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.sp)),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.sp)),
                                    borderSide:
                                        BorderSide(color: kGray, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.sp)),
                                    borderSide:
                                        BorderSide(color: kGray, width: 2),
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                  ),
                                  errorStyle: TextStyle(
                                    fontSize: 12.sp,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    borderSide:
                                        BorderSide(color: kBorder, width: 2),
                                  ),
                                  //fillColor: kWhite,
                                  filled: true,
                                  //<-- SEE HERE
                                  fillColor: kWhiteForTextField,
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.only(top: 0, bottom: 0),
                                ),
                                maxLines: 1,
                                controller: telegramEditingController,
                                style: TextStyle(
                                  fontSize: 17.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: 320.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 90.w,
                              height: 40.h,
                              margin: EdgeInsets.only(
                                left: 16.w,
                                right: 16.w,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: authCubit.updateProfileLoading
                                    ? Colors.grey
                                    : kBlack,
                              ),
                              child: InkWell(
                                onTap: () {
                                  authCubit.updateProfile(
                                      phone: phoneEditingController.text,
                                      telegram: telegramEditingController.text);
                                },
                                child: Center(
                                  child: authCubit.updateProfileLoading
                                      ? SizedBox(
                                          height: 28.h,
                                          width: 28.h,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            color:
                                                authCubit.updateProfileLoading
                                                    ? kBlack
                                                    : kWhite,
                                          ),
                                        )
                                      : Text(
                                          LocaleKeys.save.tr(),
                                          style: sendButton2Style,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

}
