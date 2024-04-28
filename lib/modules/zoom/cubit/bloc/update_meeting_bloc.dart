
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:mal/model/meet_model.dart';
import 'package:mal/modules/zoom/cubit/bloc/zoom_event.dart';
import 'package:mal/modules/zoom/cubit/bloc/zoom_state.dart';

import '../../../../shared/network/remote/api.dart';
import '../../../../shared/network/remote/end_points.dart';

class UpdateMeetingBloc extends Bloc<ZoomEvent, ZoomState> {
  UpdateMeetingBloc() : super(ZoomInitialState()) {
    on((event, emit) async {
      if (event is UpdateMeetEvent) {
        emit(UpdateMeetingLoadingState());
        try {
          await API().postData(endPoint: EndPoints.updateMeeting, data: {
            'meeting_id': event.meetingId,
            // 'email':
          }).then((value) async {
            try {
              // var response = MeetModel.fromJson(value.data["meeting"]);
              emit(UpdateMeetingLoadedState("", true, ));
            } on DioError catch (e) {
              if (e.type.name == 'other') {
                emit(UpdateMeetingLoadedState(
                    'Please chek you internet connection', false, ));
              } else if (e.type == DioErrorType.connectTimeout ||
                  e.type == DioErrorType.receiveTimeout) {
                emit(UpdateMeetingLoadedState(
                    'Please chek you internet connection', false, ));
              } else {
                print(e.response!.data);
                print(e.response!.data.toString());
                emit(UpdateMeetingLoadedState(
                    'Please chek you internet connection', false, ));
              }
            } catch (e) {
              print(e);
              emit(UpdateMeetingLoadedState(
                  'Please chek you internet connection', false, ));
            }
          });
        } on DioError catch (e){
          emit(UpdateMeetingLoadedState(
              'Please chek you internet connection', false,));
        }
      }

    });
  }
}
