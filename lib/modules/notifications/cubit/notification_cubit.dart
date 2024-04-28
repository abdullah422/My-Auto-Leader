

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/model/notification_model.dart';
import 'package:mal/modules/notifications/cubit/notification_states.dart';
import 'package:mal/responses/notification_response.dart';
import 'package:mal/shared/network/remote/api.dart';
import 'package:mal/shared/network/remote/end_points.dart';
import 'package:mal/translations/locale_keys.g.dart';

class NotificationCubit extends Cubit<NotificationStates> {
  NotificationCubit() : super(NotificationInitialState());

  static NotificationCubit get(context) => BlocProvider.of(context);



  List<Notification> notification = [];


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
  }




}
