import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/layout/cubit/layout_states.dart';
import 'package:mal/modules/stages/cubit/stages_cubit.dart';
import '../../modules/home/home_ui/home_screen.dart';
import '../../modules/profile/profile_screen.dart';
import '../../modules/sending/Sending_ui/sending_screen.dart';
import '../../modules/stages/stages_screen.dart';
import '../../modules/zoom/zoom_screen.dart';
import '../../responses/notification_response.dart';
import '../../shared/network/remote/api.dart';
import '../../shared/network/remote/end_points.dart';
import '../../translations/locale_keys.g.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitialState());

  static LayoutCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    const HomeScreen(),
    BlocProvider(
        create: (context)=>StagesCubit(),
        child: StagesScreen()
    ),
   /* BlocProvider<StagesCubit,StagesStates>(
    lazy: true,
                create: (BuildContext context) => StagesScreen(),
                child: StagesScreen()),*/
     const ZoomScreen(),
     const SendingScreen(),
     const ProfileScreen()
  ];

  void changeBottomNavBar(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  /*List<Notificatio> notification = [];


  late  bool internetConnectionError = false;
  late bool getNotificationLoading = true;
  getAllNotifications() async {
    getNotificationLoading = true;
    emit(GetAllNotificationLoadingState());
    notification = [];
    try {
      await API()
          .getData(
        endPoint: EndPoints.getAllNotification,
      )
          .then((value) {
        var notificationResponse = NotificationResponse.fromJson(value.data);
        notification = notificationResponse.notifications!;
        print('get Notifications successfully');
        getNotificationLoading = false;
        emit(GetAllNotificationSuccessState());
      });
    } on DioError catch (e) {
      if (e.type.name == 'other') {
        emit(GetNotiErrorConnectionState(error: LocaleKeys.chek_internet.tr()));
        getNotificationLoading = false;
        internetConnectionError = true;
      } else if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        emit(GetNotiErrorConnectionState(error: LocaleKeys.no_internet.tr()));
        getNotificationLoading = false;
        internetConnectionError = true;

      } else {

        emit(GetNotiErrorConnectionState(error: LocaleKeys.ops));
      }

      emit(GetAllNotificationErrorState('Ops something wrong'));
    } catch (e) {
      print(e.toString());

      emit(GetAllNotificationErrorState('Ops something wrong'));
    }
  }*/
}
