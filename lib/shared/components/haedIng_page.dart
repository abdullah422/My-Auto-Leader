import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mal/shared/styles/text_styles.dart';

class Header extends StatelessWidget {
  final String headTitle;

  const Header({Key? key, required this.headTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /*Container(
          width: 32.w,
          height: 32.h,
          margin: EdgeInsets.symmetric(horizontal: 44.w, vertical: 17.h),
         *//* child: InkWell(
            child: Icon(Icons.arrow_back),
          onTap: (){
              Navigator.pop(context);
          },
          ),*//*
        ),
        SizedBox(
          width: 31.w,
        ),*/
        SizedBox(
          height: 60.h,
          child: Center(
            child: SizedBox(
              height: 29.h,
              child: Text(
                headTitle,style: headingStyle,),
              ),
            ),
          ),
      ],
    );
  }
}
