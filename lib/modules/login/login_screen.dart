import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal/modules/login/cubit/auth_cubit.dart';
import 'package:mal/modules/login/password_text_field.dart';
import 'package:mal/modules/login/username_text_field.dart';
import 'package:mal/shared/components/app_routes.dart';
import 'package:mal/shared/components/snack_bar.dart';
import 'package:mal/shared/styles/colors.dart';
import 'package:mal/shared/styles/text_styles.dart';
import 'package:mal/translations/locale_keys.g.dart';

import 'cubit/auth_states.dart';
import 'email_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          Navigator.pushReplacementNamed(context, AppRoutes.loadingPage);
        } else if (state is LoginDioErrorState) {
          CustomSnackBar.buildErrorSnackBar(
            context,
               state.error
                  .toString(), seconds: 4);
        } else if (state is LoginErrorState) {
          CustomSnackBar.buildErrorSnackBar(
         context,state.error.toString());
        }
      },
      builder: (context, state) {
        var cubit = AuthCubit.get(context);
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: kWhite,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 205.h,
                  ),
                  InkWell(
                    onTap: () {
                      // cubit.fillForTest(
                      //     'abdulmalekdery963@gmail.com', '!Ab2%3C1d@');
                      cubit.fillForTest(
                          'company10', 'Mal1234512345');
                    },
                    child: Container(
                      child: Image.asset('assets/images/SIMPLY.png'),
                      margin: EdgeInsets.symmetric(horizontal: 74.w),
                    ),
                  ),
                  SizedBox(
                    height: 95.h,
                    child: Center(child: Text('My Auto Leader',style:GoogleFonts.almarai(fontSize: 25.sp, color: kBlack),),),
                  ),
                  UsernameTextField(cubit: cubit),
                  SizedBox(
                    height: 16.h,
                  ),
                  PasswordTextField(cubit: cubit),
                  SizedBox(
                    height: 80.h,
                  ),
                  InkWell(
                    onTap: cubit.isLoginLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              cubit.login();
                            }
                          },
                    child: Container(
                      width: 300.0.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.sp),
                        color: cubit.isLoginLoading ? Colors.grey : kYellow,
                      ),
                      child: Center(
                        child: cubit.isLoginLoading
                            ? SizedBox(
                                height: 30.sp,
                                width: 30.sp,
                                child: CircularProgressIndicator(
                                  color: cubit.isLoginLoading ? kBlack : kWhite,
                                ),
                              )
                            : Text(LocaleKeys.login.tr(),
                                style: buttonTextBlackStyle),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  SnackBar errorSnackBar(String error) {
    return SnackBar(
      duration: const Duration(seconds: 2),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Colors.white,
            size: 18.sp,
          ),
          SizedBox(width: 8.w),
          Text(error, style: errorTextStyle, overflow: TextOverflow.visible),
        ],
      ),
      backgroundColor: kRed,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.sp),
      ),
      margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
    );
  }
}
/*
class CustomSnackBar extends StatelessWidget {
  final String error;
  const CustomSnackBar ({Key? key, required this.error}) : super(key: key);

  @override
  SnackBar build(BuildContext context) {
    return ;
  }
}
*/
