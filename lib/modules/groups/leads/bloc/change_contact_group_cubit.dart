
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mal/modules/groups/leads/bloc/leads_state.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/network/remote/api.dart';
import '../../../../shared/network/remote/end_points.dart';

class ChangeContactGroupCubit extends Cubit<LeadsState>{
  final Uuid uuid;
  ChangeContactGroupCubit(this.uuid) : super(InitialLeadsState());

  void changeGroup(List<int> contactIds, int newGroupId)async{
    emit(LoadingCrudLeadsState(uuid.v4()));
    try {
      await API().postDataPure(
          endPoint: EndPoints.changeContactsGroup, data:
      {"group_id": newGroupId, "contacts_ids": contactIds}
      ).then((value) async {
        try {
          if (value.statusCode == 200) {
            emit(LoadedCrudLeadState(
                true, uuid.v4()
            ));
          } else {
            emit(LoadedCrudLeadState(
                false, uuid.v4()
            ));
          }
        } on DioError catch (e) {
          debugPrint(e.toString());
          emit(LoadedCrudLeadState(false, uuid.v4()));
        } catch (e) {
          debugPrint(e.toString());
          emit(LoadedCrudLeadState(false, uuid.v4()));
        }
      });
    } on DioError catch (e) {
      debugPrint(e.toString());
      emit(LoadedCrudLeadState(false, uuid.v4()));
    }
  }

}