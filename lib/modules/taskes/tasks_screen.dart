import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/styles/colors.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                  },
                  child: Container(
                    height: 32.h,
                    margin: EdgeInsets.symmetric(
                        horizontal: 44.w, vertical: 17.h),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: 790.h,
                      child: ListView(
                        children: [
                          InkWell(
                            onTap: () {
                              //Navigator.push(context,MaterialPageRoute(builder:(context)=>VideosScreen()));
                              print('onTap Rectangle 23');
                            },
                            child: Container(
                              // margin: EdgeInsets.symmetric(horizontal: 37.w),
                              margin: EdgeInsets.only(
                                  left: 37.w, right: 37.w, bottom: 24.h),
                              width: 354.0.w,
                              height: 160.0.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: kBlack,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.16),
                                    offset: Offset(0, 7.0),
                                    blurRadius: 21.0,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height:32.h,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:  [
                                        Padding(
                                          padding: EdgeInsets.only(left:22.w,right:22.w,top:11.h,),
                                          child:
                                          Text('Stage',style: TextStyle(color:kWhite,fontWeight: FontWeight.bold,fontSize: 18.r),),
                                        ),
                                        Container(
                                          width: 23.w,
                                          height: 23.h,
                                          margin: EdgeInsets.only(left:22.w,right:22.w,top:11.h),
                                          child: CircleAvatar(
                                            backgroundColor: kYellow,
                                            //maxRadius: 23.r,
                                            child: Center(
                                              child: Text('1',style: TextStyle(color:kBlack),),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width:140.w ,
                                    height: 91.h,
                                    child: Image.asset('assets/images/SIMPLY.png',),
                                  ),
                                  SizedBox(
                                    height: 37.h,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('Enter now',style: TextStyle(color:kWhite,fontSize: 14.r),),
                                        SizedBox(width: 4.5.w,),
                                        Icon(Icons.arrow_forward,color: kYellow,),
                                        SizedBox(width: 20.w,),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              //TODO: onTap Rectangle 23
                              print('onTap Rectangle 23');
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 37.w, right: 37.w, bottom: 24.h),
                              width: 354.0.w,
                              height: 159.0.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: kBlack,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.16),
                                    offset: const Offset(0, 7.0),
                                    blurRadius: 21.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              //TODO: onTap Rectangle 23
                              print('onTap Rectangle 23');
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 37.w, right: 37.w, bottom: 24.h),
                              width: 354.0.w,
                              height: 159.0.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: kBlack,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.16),
                                    offset: const Offset(0, 7.0),
                                    blurRadius: 21.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              //TODO: onTap Rectangle 23
                              print('onTap Rectangle 23');
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 37.w, right: 37.w, bottom: 24.h),
                              width: 354.0.w,
                              height: 159.0.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: kBlack,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.16),
                                    offset: Offset(0, 7.0),
                                    blurRadius: 21.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
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

