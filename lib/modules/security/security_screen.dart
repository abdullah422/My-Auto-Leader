import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/styles/colors.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* InkWell(
                    onTap: () {
                    },
                    child: Container(
                      height: 32.h,
                      margin: EdgeInsets.symmetric(
                          horizontal: 44.w, vertical: 17.h),
                      child: Icon(Icons.arrow_back),
                    ),
                  ),*/
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: 790.h,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: 15.h, left: 37.w, right: 37.w),
                            height: 88.0.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: kWhite,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.16),
                                  offset: Offset(0, 8.0),
                                  blurRadius: 25.0,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 30.h, left: 37.w, right: 37.w),
                            height: 88.0.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: kWhite,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.16),
                                  offset: Offset(0, 8.0),
                                  blurRadius: 25.0,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 30.h, left: 37.w, right: 37.w),
                            height: 88.0.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: kWhite,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.16),
                                  offset: Offset(0, 8.0),
                                  blurRadius: 25.0,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    //TODO: onTap Group 133
                                    print('onTap Group 133');
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 37.h),
                                    alignment: Alignment(0.0, 0.04),
                                    width: 141.0.w,
                                    height: 52.0.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: kBlack,
                                    ),
                                    child: Text(
                                      'Save',style: TextStyle(
                                        fontSize:20.r,color: kWhite
                                    ),

                                    ),
                                  )
                              )],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      )
    );
  }
}

