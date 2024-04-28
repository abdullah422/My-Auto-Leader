import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../../shared/network/remote/api.dart';
import '../../../shared/network/remote/end_points.dart';
import 'edit_zoom_state.dart';

class GetZoomEmailCubit extends Cubit<EditZoomState> {
  GetZoomEmailCubit() : super(EditZoomInitialState());

  void getZoomEmail() async {
    try {
      await API()
          .getData(
        endPoint: EndPoints.getZoomEmail,
      )
          .then((value) async {
        emit(GetZoomEmailLoadedState(true, value.data["zoom_email"]));
      });
    } on DioError catch (e) {
      if (e.type.name == 'other') {
        emit(GetZoomEmailLoadedState(false, ""));
      } else {
        emit(GetZoomEmailLoadedState(false, ""));
      }
    } catch (e) {
      emit(GetZoomEmailLoadedState(false, ""));
    }
  }
}
