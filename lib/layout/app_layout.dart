import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mal/shared/components/app_bar.dart';
import 'package:mal/shared/styles/colors.dart';

import 'cubit/layout_cubit.dart';
import 'cubit/layout_states.dart';
import 'exit_dialog.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({Key? key}) : super(key: key);

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: BlocConsumer<LayoutCubit, LayoutStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = LayoutCubit.get(context);
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: cubit.currentIndex == 4
                ? null
                : CustomAppBar(index:cubit.currentIndex,),
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: ClipRRect(
              borderRadius:  BorderRadius.only(
                topLeft: Radius.circular(25.sp),
                topRight: Radius.circular(25.sp),),
              child: BottomNavigationBar(
                onTap: (int value) {
                  cubit.changeBottomNavBar(value);
                },
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                currentIndex: cubit.currentIndex,
                backgroundColor: kYellow,
                iconSize: 5.sp,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: SizedBox(
                        height: 46.h,
                        child: CircleAvatar(
                          radius: 22.sp,
                          backgroundColor:
                              cubit.currentIndex == 0 ? kWhite : kYellow,
                          child: SvgPicture.asset(
                              'assets/svg/home-svgrepo-com (1).svg',
                            width: 20.0.w,
                            height: 24.0.h,),
                        ),
                      ),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: SizedBox(
                        height: 46.h,
                        child: CircleAvatar(
                          radius: 22.sp,
                          backgroundColor:
                              cubit.currentIndex == 1 ? kWhite : kYellow,
                          child: SvgPicture.asset(
                            'assets/svg/task-list-svgrepo-com.svg',
                            width: 20.0.w,
                            height: 24.0.h,
                          ),
                        ),
                      ),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: SizedBox(
                        height: 46.h,
                        child: CircleAvatar(
                          radius: 22.sp,
                          backgroundColor:
                              cubit.currentIndex == 2 ? kWhite : kYellow,
                          child:
                          /*Icon(Icons.video_call_outlined,color: kBlack,size: 35.sp,),*/SvgPicture.asset(
                            'assets/svg/video-svgrepo-com.svg',
                            width: 20.0,
                            height: 16.0,
                          )
                        ),
                      ),
                      label: ''),
                  BottomNavigationBarItem(

                      icon: SizedBox(
                        height: 46.h,
                        child: CircleAvatar(
                          radius: 22.sp,
                          backgroundColor:
                              cubit.currentIndex == 3 ? kWhite : kYellow,
                          child: SvgPicture.asset(
                              'assets/svg/message-svgrepo-com (1).svg',
                            width: 20.0.w,
                            height: 20.0.h,
                          )
                        ),
                      ),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: SizedBox(
                        height: 46.h,
                        child: CircleAvatar(
                          radius: 22.sp,
                          backgroundColor:
                              cubit.currentIndex == 4 ? kWhite : kYellow,
                          child: SvgPicture.asset(
                            'assets/svg/user-svgrepo-com (1).svg',
                            width: 20.0.w,
                            height: 21.0.h,
                          )
                        ),
                      ),
                      label: ''),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
