
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mal/model/meet_model.dart';
import 'package:mal/modules/zoom/cubit/bloc/zoom_event.dart';
import 'package:mal/modules/zoom/cubit/bloc/zoom_state.dart';

import '../../../../shared/network/remote/api.dart';
import '../../../../shared/network/remote/end_points.dart';

class ZoomMeetingsBloc extends Bloc<ZoomEvent, ZoomState> {
  ZoomMeetingsBloc() : super(ZoomInitialState()) {
    on((event, emit) async {
      if (event is GetMeetingsEvent) {
        if(state is MeetingLoadedState){
          if((state as MeetingLoadedState).hasMore == true){
            await sendRequest(emit, state, event);
          }
        } else {
          await sendRequest(emit, state, event);
        }
      } else if(event is ResetMeetingList){
        emit(ZoomInitialState());
      }
    });
  }

  Future sendRequest(Emitter<ZoomState> emit, ZoomState state, GetMeetingsEvent event)async{
    int page = 1;
    if(state is MeetingLoadedState){
      page = ((state).currentPage??1)+1;
    }
    await API().getQueryData(endPoint: event.meetingType == 0?EndPoints.previousMeetings:
    EndPoints.upcomingMeetings, query: {
      'per_page': event.perPage,
      'page_number': page.toString(),
    }).then((value) async {
      try {
        String keyName = event.meetingType == 1?"upcoming_meetings":"previous_meetings";
        if(value.data[keyName]["data"]!=null){
          var meetings = <MeetModel>[];
          int currentPage = 1;
          if(state is MeetingLoadedState){
            meetings.addAll(state.meets!);
            currentPage = (state.currentPage??0)+1;
          }
          value.data[keyName]["data"].forEach((v){
            meetings.add(MeetModel.fromJson(v));
          });
          bool hasMore = value.data[keyName]["next_page_url"]!=null;
          emit(MeetingLoadedState(meetings, hasMore, currentPage));
        }
      } on DioError catch (e) {
        if (e.type.name == 'other') {
          emit(MeetingLoadedState(
              null, false, null));
        } else if (e.type == DioErrorType.connectTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          emit(MeetingLoadedState(
              null, false, null));
        } else {
          print(e.error);
          print(e.response!.data.toString());
          emit(MeetingLoadedState(
              null, false, null));
        }
      } catch (e) {
        print(e);
        emit(MeetingLoadedState(
            null, false, null));
      }
    });
  }
}