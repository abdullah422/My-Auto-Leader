import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArrowBack extends StatelessWidget {
  const ArrowBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 32.h,
        margin: EdgeInsets.symmetric(
            horizontal: 44.w, vertical: 17.h),
        child: Icon(Icons.arrow_back,size: 30.r,),
      ),
    );
  }
}
