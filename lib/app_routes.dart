import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/layout/app_layout.dart';
import 'package:mal/layout/cubit/layout_cubit.dart';
import 'package:mal/modules/feedback_screen.dart';
import 'package:mal/modules/groups/contacts/contact_select_screen.dart';
import 'package:mal/modules/groups/groups_screen.dart';
import 'package:mal/modules/groups/leaddetails/edit_lead_screen.dart';
import 'package:mal/modules/groups/leaddetails/lead_details_screen.dart';
import 'package:mal/modules/groups/leads/leads_screen.dart';
import 'package:mal/modules/home/cubit/home_cubit.dart';
import 'package:mal/modules/loading_page/Loading_page.dart';
import 'package:mal/modules/loading_page/cubit/loading_cubit.dart';
import 'package:mal/modules/login/cubit/auth_cubit.dart';
import 'package:mal/modules/notifications/notifications_screen.dart';
import 'package:mal/modules/stages/control_stages_screen.dart';
import 'package:mal/modules/stages/cubit/stages_cubit.dart';
import 'package:mal/modules/zoom/create_meeting_screen.dart';
import 'package:mal/modules/zoomemail/zoom_email_screen.dart';
import 'modules/groups/leads/change_group_screen.dart';
import 'modules/login/login_screen.dart';
import 'modules/notifications/cubit/notification_cubit.dart';
import 'modules/office/office_screen.dart';
import 'modules/profile/user_information_screeen.dart';
import 'modules/sending/cubit/sending_cubit.dart';
import 'modules/services/services_screen.dart';
import 'shared/components/app_routes.dart';

class RoutesManager {
  static Route routes(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.loadingPage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (BuildContext context) => LoadingCubit()..checker(),
              //LoadingCubit(),
              child: const LoadingPage()),
          settings: settings,
        );

      /*case AppRoutes.videoScreenRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
              create: (BuildContext context) =>
                  StagesCubit()..getStageDetails(settings.arguments as int),
              child: VideosScreen()),
        );*/

      /*case AppRoutes.subStages:
        return MaterialPageRoute(
            builder: (_) => SubStagesScreen(),
            settings: settings);*/

      case AppRoutes.userInformation:
        return MaterialPageRoute(
            builder: (_) => const UserInformationScreen(),
            settings: settings);
      case AppRoutes.editZoomEmail:
        return MaterialPageRoute(
            builder: (_) => const ZoomEmailScreen(),
            settings: settings);
      case AppRoutes.controlStagesScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
              create: (BuildContext context){
                final Map<String,dynamic> data = settings.arguments as Map <String,dynamic>;
                return  StagesCubit()..getStageDetails(data['stage_id']);
              },
              child: const ControlStagesScreen()),
        );

     /* case AppRoutes.subStages:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
              create: (BuildContext context) =>
              StagesCubit()*//*..getStageDetails(settings.arguments as int)*//*,
              child: const SubStagesScreen()),
        );*/

      case AppRoutes.appLayoutRoute:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (BuildContext context) => LayoutCubit()),
                    BlocProvider(
                      create: (BuildContext context) => StagesCubit(),
                    ),
                    BlocProvider(
                      create: (BuildContext context) => HomeCubit()
                        ..getAllAds()
                        ..getStages(),
                    ),
                    BlocProvider(
                      create: (BuildContext context) =>
                          AuthCubit()..getUserProfile()..getSettings(),
                    ),
                    BlocProvider(
                      create: (BuildContext context) => SendingCubit()..getMessages(),
                    ),
                    /*BlocProvider.value(
                      value:AuthCubit()..getUserProfile() ,
                    ),*/
                  ],
                  child: const AppLayout(),
                ),
            settings: settings);





      case AppRoutes.notificationScreenRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (BuildContext context) =>
                  NotificationCubit()..getAllNotifications(),
              //LoadingCubit(),
              child: const NotificationsScreen()),
          settings: settings,
        );

      /*case AppRoutes.homeScreenRoute:
        return MaterialPageRoute(
            builder: (_) => const HomeScreen(), settings: settings);*/

      /*case AppRoutes.stagesScreenRoute:
        return MaterialPageRoute(
            builder: (_) => const StagesScreen(), settings: settings);*/

      /* case AppRoutes.sendingScreenRoute:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (BuildContext context) => SendingCubit()..getMessages(),
                child: const SendingScreen()),
            settings: settings);*/


      case AppRoutes.loginScreenRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => AuthCubit(),
            child: const LoginScreen(),
          ),
          settings: settings,
        );

      case AppRoutes.createMeeting:
        return MaterialPageRoute(
            builder: (_) => const CreateMeetingScreen(), settings: settings);

      case AppRoutes.groups:
        return MaterialPageRoute(
            builder: (_) => const GroupsScreen(), settings: settings);

      case AppRoutes.groupLeaders:
        Map map = settings.arguments as Map;
        int id = map["group_id"];
        String name = map["name"];
        return MaterialPageRoute(
            builder: (_) => LeadsScreen(id, name), settings: settings);

      case AppRoutes.leaderDetails:
        int? id = settings.arguments as int?;
        return MaterialPageRoute(
            builder: (_) => LeadDetailsScreen(id??0), settings: settings);

      case AppRoutes.selectContacts:
        int id = settings.arguments as int;
        return MaterialPageRoute(
            builder: (_) => ContactSelectScreen(id), settings: settings);

      case AppRoutes.editLeader:
        Map map = settings.arguments as Map;
        int? id = map["lead_id"];
        int groupId = map["group_id"];
        return MaterialPageRoute(
            builder: (_) => EditLeadScreen(id, groupId), settings: settings);
      case AppRoutes.changeGroup:
        Map map = settings.arguments as Map;
        List<int> ids = map["ids"] as List<int>;
        int oldGroupId = map["oldId"];
        return MaterialPageRoute(
            builder: (_) => ChangeGroupScreen(ids, oldGroupId), settings: settings);

      case AppRoutes.office:
        return MaterialPageRoute(
            builder: (_) => const OfficeScreen(), settings: settings);

      case AppRoutes.services:
        Map map = settings.arguments as Map;
        String url = map["url"];
        return MaterialPageRoute(
            builder: (_) =>  ServicesScreen(url), settings: settings);


      default:
        return MaterialPageRoute(
            builder: (_) => const FeedBackScreen(), settings: settings);
    }
  }
}
