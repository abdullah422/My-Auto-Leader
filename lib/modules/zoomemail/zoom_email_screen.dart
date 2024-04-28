import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/components/app_bar.dart';
import '../../shared/components/snack_bar.dart';
import '../../shared/constants/constants.dart';
import '../../shared/styles/colors.dart';
import '../../shared/styles/text_styles.dart';
import '../../translations/locale_keys.g.dart';
import 'bloc/edit_zoom_email_cubit.dart';
import 'bloc/edit_zoom_state.dart';
import 'bloc/get_zoom_email_cubit.dart';

class ZoomEmailScreen extends StatefulWidget {
  const ZoomEmailScreen({Key? key}) : super(key: key);

  @override
  State<ZoomEmailScreen> createState() => _ZoomEmailScreenState();
}

class _ZoomEmailScreenState extends State<ZoomEmailScreen> {

  late GetZoomEmailCubit getZoomEmailCubit;
  late EditZoomEmailCubit editZoomEmailCubit;
  late TextEditingController emailEditingController;

  @override
  void initState() {
    super.initState();
    editZoomEmailCubit = EditZoomEmailCubit();
    getZoomEmailCubit = GetZoomEmailCubit();
    getZoomEmailCubit.getZoomEmail();
    emailEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: LocaleKeys.edit_zoom_email.tr()),
      body: BlocBuilder<GetZoomEmailCubit, EditZoomState>(
        bloc: getZoomEmailCubit,
        builder: (context, state) {
          if(state is GetZoomEmailLoadedState){
            emailEditingController = TextEditingController(text: state.email);
            return Column(
              children: [
                Container(
                  margin: const EdgeInsetsDirectional.only(start: 24, end: 24, top: 48),
                  child: TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: kIconGray,
                        size: 20.sp,
                      ),
                      prefixIconConstraints: BoxConstraints(
                          maxHeight: 40.h,
                          minHeight: 40.h,
                          maxWidth: 40.w,
                          minWidth: 40.w),
                      hintText: LocaleKeys.email.tr(),
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
                    controller: emailEditingController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return LocaleKeys.enter_your_email.tr();
                      } else {
                        if (!emailValidatorRegExp.hasMatch(value)) {
                          return LocaleKeys.enter_valid_email.tr();
                        }
                      }
                      return null;
                    },
                    style: TextStyle(
                      fontSize: 17.sp,
                    ),
                  ),
                ),
                BlocConsumer<EditZoomEmailCubit, EditZoomState>(
                  bloc: editZoomEmailCubit,
                  listener: (context, state) {
                    if(state is GetZoomEmailLoadedState){
                      if(state.success == false){
                        CustomSnackBar.buildErrorSnackBar(
                            context, LocaleKeys.edit_zoom_email_error.tr(), seconds: 4);
                      } else {
                        CustomSnackBar.buildSuccessSnackBar(
                            context, LocaleKeys.edit_zoom_email_success.tr(), seconds: 4);
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  builder:(context, state) {
                    if(state is EditZoomLoadingState){
                      return Container(
                        width: 90.w,
                        height: 40.h,
                        margin: EdgeInsets.only(
                            left: 16.w,
                            right: 16.w,
                            top: 36
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: kBlack,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white ,
                          ),
                        ),
                      );
                    }
                    return Container(
                      width: 90.w,
                      height: 40.h,
                      margin: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          top: 36
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: kBlack,
                      ),
                      child: InkWell(
                        onTap: () {
                          if(emailValidatorRegExp.hasMatch(emailEditingController.text)){
                            editZoomEmailCubit.editEmail(emailEditingController.text);
                          }
                        },
                        child: Center(
                          child: Text(
                            LocaleKeys.save.tr(),
                            style: sendButton2Style,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: kYellow,
            ),
          );
        },
      ),
    );
  }
}
