import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mal/layout/cubit/layout_cubit.dart';
import 'package:mal/model/stage_model.dart';
import 'package:mal/modules/home/cubit/home_cubit.dart';
import 'package:mal/modules/home/cubit/home_states.dart';
import 'package:mal/modules/home/home_ui/carousel.dart';
import 'package:mal/modules/stages/cubit/stages_cubit.dart';
import 'package:mal/shared/components/app_routes.dart';
import 'package:mal/shared/components/circular_Progress.dart';
import 'package:mal/shared/components/snack_bar.dart';
import 'package:mal/shared/styles/text_styles.dart';
import 'package:mal/translations/locale_keys.g.dart';

import '../../../shared/components/error_network_connection.dart';
import '../../../shared/styles/colors.dart';
import '../../loading_page/cubit/Loading_states.dart';
import '../../loading_page/cubit/loading_cubit.dart';
import 'home_stage_item.dart';
import 'zoom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late LoadingCubit loadingCubit;

  @override
  void initState() {
    super.initState();
    loadingCubit = LoadingCubit();
    loadingCubit.getUserDetailsOnly();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is GetAllAdsErrorState) {
          CustomSnackBar.buildErrorSnackBar(context, state.error);
        } else if (state is GetStagesErrorState) {
          CustomSnackBar.buildErrorSnackBar(context, state.error);
        } else if (state is GetAllAdsErrorConnectionState ||
            state is GetStagesErrorConnectionState) {
          CustomSnackBar.buildErrorSnackBar(
              context, LocaleKeys.chek_internet.tr());
        }
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        var stagesCubit = StagesCubit.get(context);
        var layoutCubit = LayoutCubit.get(context);
        if (cubit.getAdsLoading && cubit.getStagesLoading) {
          return Center(
            child: CustomCircularProgress(
              cColor: kYellow,
            ),
          );
        } else {
          return cubit.getAdsConnectionError || cubit.getStagesConnectionError
              ? ErrorNetworkConnection(
                  onCallback: () {
                    cubit.tryAgain();
                  },
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BlocBuilder<LoadingCubit, LoadingStates>(
                        bloc: loadingCubit,
                        builder: (context, state) {
                          if (state is GetUserDetailsLoadedState) {
                            if ((int.parse(
                                    state.userProfile?.expireDate ?? "0")) <=
                                30) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(16)),
                                margin: const EdgeInsetsDirectional.only(
                                    start: 8, end: 8, top: 8),
                                padding: const EdgeInsetsDirectional.only(
                                    top: 4, bottom: 4),
                                alignment: Alignment.center,
                                child: Text(
                                  LocaleKeys.subscription_date.tr(args: [
                                    state.userProfile?.expireDate?.toString() ??
                                        ""
                                  ]),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }
                          }
                          return Container();
                        },
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Container(
                        width: 396.w,
                        height: 180.h,
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        child: cubit.adss.isNotEmpty
                            ? Carousel(ads: cubit.adss)
                            : Center(
                                child: SvgPicture.asset(
                                  'assets/svg/no_ads.svg',
                                  height: 160.h,
                                ),
                              ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.stages.tr(),
                              style: label1Style,
                            ),
                            InkWell(
                              onTap: () {
                                layoutCubit.changeBottomNavBar(1);
                              },
                              child: Text(
                                LocaleKeys.show_all.tr(),
                                style: subLabel2Style,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        width: 396.w,
                        height: 328.h,
                        child: cubit.getStagesLoading
                            ? Center(
                                child: CustomCircularProgress(cColor: kYellow),
                              )
                            : cubit.stages.isEmpty
                                ? Center(
                                    child: SvgPicture.asset(
                                        'assets/svg/no_stages.svg'),
                                  )
                                : ListView.builder(
                                    physics: const BouncingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics(),
                                    ),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: cubit.stages
                                        .getRange(
                                            0,
                                            cubit.stages.length < 5
                                                ? cubit.stages.length
                                                : 5)
                                        .toList()
                                        .length,
                                    itemBuilder: (_, index) {
                                      return BuildHomeStageItem(
                                        index: index + 1,
                                        stage: cubit.stages[index],
                                        onTap: () {
                                          if (cubit.stages[index].status == 1) {
                                            // stagesCubit.getStageDetails(cubit
                                            //     .stages[index].stageId as int);
                                            Navigator.pushNamed(
                                              context,
                                              AppRoutes.controlStagesScreen,
                                              arguments: {
                                                'stage_id': cubit.stages[index]
                                                    .stageId as int,
                                                'index': index + 1
                                              },
                                            );
                                          }
                                        },
                                      );
                                    }),
                      ),
                      SizedBox(
                        height: 34.h,
                      ),
                      const ZoomButton(),
                      SizedBox(
                        height: 30.h,
                      )
                    ],
                  ),
                );
        }
      },
    );
  }
}
