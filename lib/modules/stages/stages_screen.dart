import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mal/model/stage_model.dart';
import 'package:mal/modules/home/cubit/home_cubit.dart';
import 'package:mal/modules/home/cubit/home_states.dart';
import 'package:mal/modules/stages/stage_item.dart';
import 'package:mal/shared/components/app_routes.dart';
import 'package:mal/shared/components/error_network_connection.dart';
import 'package:mal/shared/styles/text_styles.dart';
import 'package:mal/translations/locale_keys.g.dart';

import '../../shared/styles/colors.dart';
import 'cubit/stages_cubit.dart';

class StagesScreen extends StatefulWidget {
  const StagesScreen({Key? key}) : super(key: key);

  @override
  State<StagesScreen> createState() => _StagesScreenState();
}

class _StagesScreenState extends State<StagesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var stagesCubit = StagesCubit.get(context);
        var homeCubit = HomeCubit.get(context);
        return Scaffold(
            backgroundColor: kWhite,
            body: homeCubit.getStagesLoading
                ? homeCubit.getStagesConnectionError
                    ? ErrorNetworkConnection(onCallback: () {
                        homeCubit.getStages();
                      })
                    : Center(
                        child: CircularProgressIndicator(
                        color: kYellow,
                      ))
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12.r)),
                    ),
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      itemCount: homeCubit.stages.length,
                      itemBuilder: (_, index) => InkWell(
                          onTap: () {
                            if (homeCubit.stages[index].status == 1) {
                              // stagesCubit.getStageDetails(cubit
                              //     .stages[index].stageId as int);
                              Navigator.pushNamed(
                                context,
                                AppRoutes.controlStagesScreen,
                               /* arguments:
                                    homeCubit.stages[index].stageId as int,*/
                                arguments: {
                                  'stage_id': homeCubit.stages[index]
                                      .stageId as int,
                                  'index':index+1
                                },
                              );
                            }
                            /*if (homeCubit.stages[index].status == 1) {
                              print(homeCubit.stages[index].stageId);
                              *//* stagesCubit.getStageDetails(
                                      homeCubit.stages[index].stageId as int);*//*
                              Navigator.pushNamed(context, AppRoutes.subStages,
                                  arguments:
                                      homeCubit.stages[index].stageId as int);
                            }*/
                            /*if (homeCubit.stages[index].status == 1) {
                                  print(homeCubit.stages[index].stageId);
                                  stagesCubit.getStageDetails(
                                      homeCubit.stages[index].stageId as int);
                                  Navigator.pushNamed(
                                      context, AppRoutes.videoScreenRoute,
                                      arguments: homeCubit.stages[index].stageId
                                          as int);
                                }*/
                          },
                          child: BuildStageItem(
                              stage: homeCubit.stages[index],
                              index: index + 1)),
                    ),
                  ));
      },
    );
  }
}
