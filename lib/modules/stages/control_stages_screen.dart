import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mal/model/stage_details_model.dart';
import 'package:mal/modules/stages/sub_stages.dart';
import 'package:mal/modules/stages/videos/videos_screen.dart';
import 'package:mal/shared/components/app_bar.dart';
import 'package:mal/shared/components/error_network_connection.dart';
import 'package:mal/shared/components/snack_bar.dart';
import 'package:mal/shared/styles/text_styles.dart';
import 'package:mal/translations/locale_keys.g.dart';
import '../../shared/components/app_routes.dart';
import '../../shared/styles/colors.dart';
import 'cubit/stages_cubit.dart';
import 'cubit/stages_states.dart';

class ControlStagesScreen extends StatefulWidget {

  const ControlStagesScreen({Key? key}) : super(key: key);

  @override
  State<ControlStagesScreen> createState() => _ControlStagesScreenState();
}

class _ControlStagesScreenState extends State<ControlStagesScreen> {

  @override
  Widget build(BuildContext context) {
    Map<String,dynamic> data = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    return BlocConsumer<StagesCubit, StagesStates>(
      listener: (context, state) {
        if (state is GetStageDetailsErrorState) {
          CustomSnackBar.buildErrorSnackBar(context, state.error);
        }
      },
      builder: (context, state) {
        var cubit = StagesCubit.get(context);
        if (cubit.getStageDetailsLoading) {
          return Scaffold(
              body: cubit.getStagesErrorConnection
                  ? ErrorNetworkConnection(
                      onCallback: () {
                        cubit.getStageDetails(data['stage_id']);
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: kYellow,
                      ),
                    ));
        } else {
          if (cubit.stageDetails!.subStages!.isEmpty) {
            return VideosScreen(
              stagesDetails: cubit.stageDetails as StageDetails,
              stageIndex:data['index'],
            );
          } else {
            return SubStagesScreen(
              subStages: cubit.stageDetails!.subStages as List<SubStages>,stageIndex:data['index'],

            );
          }
        }
      },
    );
  }

  Widget buildAlertContent({required String message, required int status}) {
    if (status == 3) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ErrorNetworkConnection(
            onCallback: () {
              Navigator.pop(context);
            },
            fromAlert: true,
          )
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 15.h,
          ),
          status == 1
              ? SvgPicture.string(
                  '<svg viewBox="0.0 0.0 233.44 140.05" ><path transform="translate(78.18, 2.86)" d="M 83.42546081542969 33.83553314208984 C 84.66550445556641 32.52254486083984 84.73844146728516 30.40716171264648 83.42546081542969 29.09416198730469 L 68.98251342773438 13.77589797973633 C 68.39896392822266 13.11940956115723 67.52364349365234 12.75468444824219 66.64829254150391 12.75468444824219 C 66.64829254150391 12.75468444824219 66.64829254150391 12.75468444824219 66.64829254150391 12.75468444824219 C 65.77297210693359 12.75468444824219 64.89762878417969 13.11940956115723 64.31409454345703 13.77589797973633 L 15.80624389648438 64.1802978515625 L 35.06350326538086 83.94815063476562 L 83.42546081542969 33.83553314208984 Z" fill="#36be75" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(-6.75, 49.19)" d="M 27.06143188476562 18.71889114379883 C 26.40493392944336 18.0623836517334 25.60254669189453 17.6976490020752 24.72721099853516 17.6976490020752 C 23.85188674926758 17.6976490020752 23.04950904846191 18.0623836517334 22.39299964904785 18.71889114379883 L 7.731230735778809 33.81831741333008 C 6.418237686157227 35.13129806518555 6.418237686157227 37.31962203979492 7.731230735778809 38.63262176513672 L 53.83190536499023 86.04628753662109 C 56.74966812133789 89.10996246337891 60.39687728881836 90.86061096191406 63.46054077148438 90.86061096191406 C 67.83718872070312 90.86061096191406 71.55733489990234 87.578125 73.01622009277344 86.19216156005859 C 73.01622009277344 86.19216156005859 73.01622009277344 86.19216156005859 73.08916473388672 86.11923217773438 L 82.86367034912109 76.05295562744141 L 27.06143188476562 18.71889114379883 Z" fill="#36be75" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(43.87, -11.25)" d="M 188.6347808837891 27.58948707580566 L 174.1918487548828 12.2712230682373 C 173.6083068847656 11.61472415924072 172.7329711914062 11.25 171.8576507568359 11.25 C 171.8576507568359 11.25 171.8576507568359 11.25 171.8576507568359 11.25 C 170.9822998046875 11.25 170.1069946289062 11.61472415924072 169.5234222412109 12.2712230682373 L 69.00644683837891 116.3624572753906 L 32.46142578125 78.72330474853516 C 31.80492782592773 78.06681823730469 31.00254058837891 77.70208740234375 30.12721633911133 77.70208740234375 C 29.25188064575195 77.70208740234375 28.44950485229492 78.06681823730469 27.79299354553223 78.72330474853516 L 13.13122749328613 93.82275390625 C 11.81822967529297 95.13573455810547 11.81822967529297 97.32405853271484 13.13122749328613 98.63706207275391 L 59.23191833496094 146.0507354736328 C 62.1496696472168 149.1143951416016 65.79689788818359 150.8650207519531 68.86054229736328 150.8650207519531 C 73.23719024658203 150.8650207519531 76.95732879638672 147.5825347900391 78.41622161865234 146.1965942382812 C 78.41622161865234 146.1965942382812 78.41622161865234 146.1965942382812 78.48914337158203 146.1236572265625 L 188.634765625 32.25790405273438 C 189.8748474121094 31.01785850524902 189.8748474121094 28.90248680114746 188.6347808837891 27.58948707580566 Z" fill="#36be75" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                  width: 233.44,
                  height: 140.05,
                )
              : SvgPicture.asset(
                  'assets/svg/faild.svg',
                  width: 233.44,
                  height: 140.05,
                ),
          SizedBox(
            height: 30.h,
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: messageForSucOrFai,
          ),
          SizedBox(
            height: 30.h,
          ),
          InkWell(
            onTap: () {
              if (status == 1) {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                    context, AppRoutes.appLayoutRoute);
              } else {
                Navigator.pop(context);
              }
            },
            child: Container(
              width: 200.w,
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: kYellow,
              ),
              child: Center(
                child: Text(
                  LocaleKeys.done.tr(),
                  style: TextStyle(
                      fontSize: 22.0.r,
                      color: kBlack,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
        ],
      );
    }
  }
}
