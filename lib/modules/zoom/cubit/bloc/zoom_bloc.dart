import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mal/model/meet_model.dart';
import 'package:mal/modules/zoom/cubit/bloc/zoom_event.dart';
import 'package:mal/modules/zoom/cubit/bloc/zoom_state.dart';
import 'package:mal/translations/locale_keys.g.dart';

import '../../../../shared/network/remote/api.dart';
import '../../../../shared/network/remote/end_points.dart';

class CreateMeetBloc extends Bloc<ZoomEvent, ZoomState> {
  CreateMeetBloc() : super(ZoomInitialState()) {
    on((event, emit) async {
      if (event is CreateMeetEvent) {
        emit(CreateMeetingLoadingState());
        try {
          await API().postData(endPoint: EndPoints.createMeeting, data: {
            'start_time': event.startDateTime,
            'topic': event.meetingTopic,
          }).then((value) async {
            try {
              var response = MeetModel.fromJson(value.data["meeting"]);
              emit(CreateMeetingLoadedState("", true, response));
            } on DioError catch (e) {
              if (e.type.name == 'other') {
                emit(CreateMeetingLoadedState(
                    LocaleKeys.chek_internet.tr(), false, null));
              } else if (e.type == DioErrorType.connectTimeout ||
                  e.type == DioErrorType.receiveTimeout) {
                emit(CreateMeetingLoadedState(
                    LocaleKeys.chek_internet.tr(), false, null));
              } else {
                print(e.response!.data);
                print(e.response!.data.toString());
                emit(CreateMeetingLoadedState(
                    LocaleKeys.chek_internet.tr(), false, null));
              }
            } catch (e) {
              print(e);
              emit(CreateMeetingLoadedState(
                  LocaleKeys.chek_internet.tr(), false, null));
            }
          });
        } on DioError catch (e){
          emit(CreateMeetingLoadedState(
              LocaleKeys.chek_internet.tr(), false, null));
        }
        }

    });
  }
}
