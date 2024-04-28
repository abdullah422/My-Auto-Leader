
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mal/model/meet_model.dart';
import 'package:mal/modules/zoom/cubit/bloc/zoom_event.dart';
import 'package:mal/modules/zoom/cubit/bloc/zoom_state.dart';

import '../../../../shared/network/remote/api.dart';
import '../../../../shared/network/remote/end_points.dart';

class ZoomSyncBloc extends Bloc<ZoomEvent, ZoomState> {
  ZoomSyncBloc() : super(ZoomInitialState()) {
    on((event, emit) async {
      if(event is SyncZoom){
        try {
          await API().postData(
          endPoint: EndPoints.zoomSync, ).then((value) async {

            if(value.data["success"]==true){
              emit(SyncLoadedState("", true));
            } else {
              emit(SyncLoadedState(value.data["message"], false));
            }

        });
        } on DioError catch (e) {
          if (e.type.name == 'other') {
            emit(SyncLoadedState(
                "", false));
          } else {
            debugPrint(e.error);
            debugPrint(e.response!.data.toString());
            emit(SyncLoadedState(e.response?.data['message']??"", false,));
          }
        } catch (e) {
      debugPrint(e.toString());
      emit(SyncLoadedState(
      "", false, ));
      }
      }
    });
  }

}