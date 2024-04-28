import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/responses/notification_response.dart';
import 'package:mal/shared/network/local/shared_preferences.dart';
import 'package:mal/shared/network/remote/api.dart';
import 'package:mal/shared/network/remote/end_points.dart';
import 'package:mal/translations/locale_keys.g.dart';

import '../../../model/notification_model.dart';
import '../../../model/user_profile_model.dart';
import 'Loading_states.dart';

class LoadingCubit extends Cubit<LoadingStates> {
  LoadingCubit() : super(LoadingInitialState());

  static LoadingCubit get(context) => BlocProvider.of(context);
  bool stillCheck = false;

  void checker() async {
    stillCheck = true;
    emit(CheckerState());
    await Future.delayed(Duration(seconds: 2)).then((value) {
      checkIsLogin();
    });
  }

  void checkIsLogin() async {
    var token = SharedPrefHelper.getUserToken();
    if (token == null) {
      emit(GotoLoginScreenState());
    } else {
      getUserDetails();
      //getAllNotifications();
    }
  }

  bool getUserDetailsLoading = false;
  bool internetConnectionError = false;
  bool shouldLogin = false;

  void getUserDetails() async {
    getUserDetailsLoading = true;
    internetConnectionError = false;
    emit(GetUserDetailsLoadingState());
    try {
      await API().getData(endPoint: EndPoints.getUserDetails).then((value) {
        getAllNotifications();
      });
    } on DioError catch (e) {
      if (e.type.name == 'other') {
        emit(GetUserDetailsErrorConnectionState(
            error: LocaleKeys.chek_internet.tr()));
        internetConnectionError = true;
        getUserDetailsLoading = false;
        stillCheck = false;
      } else if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        emit(GetUserDetailsErrorConnectionState(
            error: LocaleKeys.no_internet.tr()));
        internetConnectionError = true;
        getUserDetailsLoading = false;
        stillCheck = false;
      } else {
        shouldLogin = true;
        stillCheck = false;
        emit(GetUserDetailsErrorState(error: LocaleKeys.please_login.tr()));
      }
    } catch (e) {
      shouldLogin = false;
      stillCheck = false;
      emit(GetUserDetailsErrorState(error: LocaleKeys.ops.tr()));
    }
  }

  void getUserDetailsOnly() async {
    try {
      await API().getData(endPoint: EndPoints.getUserDetails).then((value) {
        UserProfile userProfile = UserProfile.fromJson(value.data["user"]["profile"]);
        emit(GetUserDetailsLoadedState(userProfile: userProfile));
      });
    } on DioError catch (e) {
      if (e.type.name == 'other') {
        emit(GetUserDetailsErrorConnectionState(
            error: LocaleKeys.chek_internet.tr()));
        internetConnectionError = true;
        getUserDetailsLoading = false;
        stillCheck = false;
      } else if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        emit(GetUserDetailsErrorConnectionState(
            error: LocaleKeys.no_internet.tr()));
        internetConnectionError = true;
        getUserDetailsLoading = false;
        stillCheck = false;
      } else {
        shouldLogin = true;
        stillCheck = false;
        emit(GetUserDetailsErrorState(error: LocaleKeys.please_login.tr()));
      }
    } catch (e) {
      shouldLogin = false;
      stillCheck = false;
      emit(GetUserDetailsErrorState(error: LocaleKeys.ops.tr()));
    }
  }

  List<Notification> notification = [];

  bool getInternetConnectionError = false;
  bool getNotificationLoading = true;

  getAllNotifications() async {
    getInternetConnectionError = false;
    getNotificationLoading = true;
    emit(GetAllNotificationLoadingState());
    notification = [];
    try {
      await API()
          .getData(
        endPoint: EndPoints.getAllNotification,
      )
          .then((value) async {
        var notificationResponse = NotificationResponse.fromJson(value.data);
        notification = notificationResponse.notifications!;
        if(notificationResponse.notifications?.length == 0){
          emit(GetUserDetailsSuccessState());
        }
        final int previousNumber =
            SharedPrefHelper.getPreviousNumberOfNoti() ?? 0;
        if (notification.isNotEmpty) {
          if (previousNumber <= notification.length) {
            await SharedPrefHelper.saveNewNumberOfNoti(
                    number: notification.length - previousNumber.abs())
                .then((value) async {
              await SharedPrefHelper.savePreviousNumberOfNoti(
                  number: notification.length).then((value){
                emit(GetUserDetailsSuccessState());
              });
            });
          }
        } else {
          await SharedPrefHelper.saveNewNumberOfNoti(number: 0);
          await SharedPrefHelper.savePreviousNumberOfNoti(number: 0);
        }
        print('get Notifications successfully');
        getNotificationLoading = false;
        emit(GetAllNotificationSuccessState());
      });
    } on DioError catch (e) {
      if (e.type.name == 'other') {
        emit(GetNotiErrorConnectionState(error: LocaleKeys.chek_internet.tr()));
        getInternetConnectionError = true;
      } else if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        emit(GetNotiErrorConnectionState(error: LocaleKeys.no_internet.tr()));
        getInternetConnectionError = true;
      } else {
        getInternetConnectionError = true;
        emit(GetNotiErrorConnectionState(error: LocaleKeys.ops));
      }
      emit(GetAllNotificationErrorState(LocaleKeys.ops));
    } catch (e) {
      getInternetConnectionError = true;
      print(e.toString());
      emit(GetAllNotificationErrorState(LocaleKeys.ops));
    }
  }
}
