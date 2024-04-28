import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mal/shared/constants/constants.dart';
import 'package:mal/shared/styles/text_styles.dart';
import 'package:mal/translations/locale_keys.g.dart';

import '../../shared/styles/colors.dart';
import 'cubit/auth_cubit.dart';
class UsernameTextField extends StatelessWidget {
  final AuthCubit ? cubit;

  const UsernameTextField({Key? key,  this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: Text(
                LocaleKeys.user_name.tr(),
                style: titleForTextFieldStyle,
              ),
            ),
          ),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(

              prefixIcon: Icon(
                Icons.person,
                color: kIconGray,
                size: 20.sp,
              ),
              prefixIconConstraints: BoxConstraints(
                  maxHeight: 40.h,
                  minHeight: 40.h,
                  maxWidth: 40.w,
                  minWidth: 40.w),
              hintText: LocaleKeys.user_name.tr(),
              hintStyle: hintForTextFieldStyle,
              focusedErrorBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.sp)),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:  BorderRadius.all(Radius.circular(15.sp)),
                borderSide: BorderSide(color: kGray, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:  BorderRadius.all(Radius.circular(12.sp)),
                borderSide: BorderSide(color: kGray, width: 2),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width:2),
              ),
              errorStyle:errorValidationStyle,
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: kBorder, width: 2),
              ),
              filled: true,


              fillColor: kWhiteForTextField,
              isDense: true,
              contentPadding:EdgeInsets.only(top: 5.h, bottom: 5.h),
            ),
            cursorColor: Colors.black,
            maxLines: 1,
            validator: (value) {
              if (value!.isEmpty) {
                return LocaleKeys.enter_user_name.tr();
              } else {
              }
              return null;
            },
            controller: cubit!.email,
            style:TextStyle(fontSize: 18.sp),
          ),
        ],
      ),
    );
  }
}
