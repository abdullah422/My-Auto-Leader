import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mal/shared/styles/text_styles.dart';
import 'package:mal/translations/locale_keys.g.dart';

import '../../shared/styles/colors.dart';
class PasswordTextField extends StatelessWidget {
  final cubit ;
  const PasswordTextField({Key? key, this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 396.w,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: 8.h, bottom:10.h,),
            child: SizedBox(
              child: Text(
                LocaleKeys.password.tr(),
                style: titleForTextFieldStyle,
              ),
            ),
          ),
          SizedBox(
              child: TextFormField(
                controller: cubit.password,
                obscureText: !cubit.showPassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock_outlined,
                    color: kIconGray,
                    size: 20.sp,
                  ),
                  prefixIconConstraints: BoxConstraints(
                      maxHeight: 40.h,
                      minHeight: 40.h,
                      maxWidth: 40.w,
                      minWidth: 40.w),
                  suffixIcon: InkWell(
                    onTap: (){
                      cubit.showOrHidePassword();
                    },
                    child: Icon(
                      cubit.showPassword?Icons.visibility_outlined:Icons.visibility_off_outlined,
                      color: kIconGray,
                      size: 22.sp,
                    ),
                  ),
                  suffixIconConstraints: BoxConstraints(
                      maxHeight: 40.h,
                      minHeight: 40.h,
                      maxWidth: 40.w,
                      minWidth: 40.w),
                  hintText: '********',
                  hintStyle: TextStyle(fontSize: 14.sp,color: kHintForTextField),
                  disabledBorder: const OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedErrorBorder:  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(12.sp)),
                    borderSide:
                    const BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:  BorderRadius.all(
                        Radius.circular(15.sp)),
                    borderSide:
                    BorderSide(color: kGray, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:  BorderRadius.all(
                        Radius.circular(15.sp)),
                    borderSide:
                    BorderSide(color: kGray, width: 2),
                  ),
                  isDense: true,
                  errorBorder: const OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.red, width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: kBorder, width: 2),
                  ),
                  errorMaxLines: 1,
                  errorStyle: errorValidationStyle,
                  //fillColor: Colors.,
                  fillColor: kWhiteForTextField,
                  filled: true,
                  contentPadding: EdgeInsets.all(5),
                  // border: InputBorder.none,
                ),
                cursorColor: Colors.black,
                validator: (value) {
                  if (value!.isEmpty)
                  {
                    return LocaleKeys.enter_your_password.tr();
                  }
                  return null;
                },
                style: TextStyle(fontSize:18.sp),
              )),
        ],
      ),
    );
  }
}
