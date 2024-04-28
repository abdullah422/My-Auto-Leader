import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mal/model/stage_details_model.dart';
import 'package:mal/modules/login/cubit/auth_cubit.dart';
import 'package:mal/modules/stages/cubit/stages_cubit.dart';
import 'package:mal/shared/components/alert_dialog.dart';
import 'package:mal/shared/components/app_bar.dart';
import 'package:mal/shared/components/app_routes.dart';
import 'package:mal/shared/styles/colors.dart';
import 'package:mal/shared/styles/text_styles.dart';
import '../../translations/locale_keys.g.dart';
import 'cubit/stages_states.dart';

class SubStagesScreen extends StatefulWidget {
  final  List<SubStages> subStages;
  final int stageIndex;
  const SubStagesScreen({Key? key, required this.subStages, required this.stageIndex}) : super(key: key);

  @override
  State<SubStagesScreen> createState() => _SubStagesScreenState();
}

class _SubStagesScreenState extends State<SubStagesScreen> {
  /* BlocProvider<AuthCubit>.value(
  value: ModalRoute.of(context)!.settings.arguments as AuthCubit,*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: LocaleKeys.stage.tr() + '  ${widget.stageIndex}'),
        backgroundColor: kWhite,
        body: Container(
          height: (MediaQuery.of(context).size.height),
          margin: EdgeInsets.symmetric(
            horizontal: 16.w,
          ),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 3.4,
                crossAxisSpacing: 16.w,
                //mainAxisSpacing: 16.h,
              ),
              itemCount:widget.subStages.length,
              itemBuilder: (BuildContext ctx, index) {
                return InkWell(
                  onTap: (){
                    if(widget.subStages[index].status==1){
                      Navigator.pushNamed(
                        context,
                        AppRoutes.controlStagesScreen,
                        //arguments:[index].id,
                        arguments: {
                          'stage_id': widget.subStages[index]
                              .id as int,
                          'index':index+1
                        },
                      );
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: BuildSubStageItem(
                      index: index,
                      previousIndex: widget.stageIndex,
                      stage: widget.subStages[index],
                    ),
                  ),
                );
              }),
        ));
  }
}

class BuildSubStageItem extends StatelessWidget {
  final int index;
  final int previousIndex;
  final SubStages stage;

  const BuildSubStageItem({
    Key? key,
    required this.index, required this.stage, required this.previousIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (stage.status == 0) {
      return Stack(
        children: [
          Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: kBlack, borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: SvgPicture.asset('assets/svg/sub_stage.svg'),
              )),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: kBlack.withOpacity(0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.16),
                  offset: const Offset(0, 7.0),
                  blurRadius: 21.0,
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/svg/lock.svg',
                width: 45.w,
                height: 55.h,
              ),
            ),
          )
        ],
      );
    } else {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: kBlack, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 10.w,
                  height: 50.h,
                ),
                InkWell(
                  onTap: () {
                    CustomAlert.buildStageInfoAlert(context: context,stageInfo:{'title':stage.title,
                      'des':stage.description,});
                  },
                  child: Icon(
                    Icons.error_outline_rounded,
                    color: kWhite,size:22.sp
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  '${LocaleKeys.stage.tr()} $previousIndex - ${index+1}',
                  style: label5Style,
                ),
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            Expanded(child: SvgPicture.asset('assets/svg/sub_stage.svg')),
            SizedBox(
              height: 50.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    LocaleKeys.enter_now.tr(),
                    style: label4Style,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: kYellow,
                  ),
                  SizedBox(
                    width: 10.w,
                  )
                ],
              ),
            )
          ],
        ),
      );
    }
  }
}
