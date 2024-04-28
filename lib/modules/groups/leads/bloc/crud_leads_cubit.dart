

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mal/model/contact_model.dart';
import 'package:mal/modules/groups/leads/bloc/leads_state.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/network/remote/api.dart';
import '../../../../shared/network/remote/end_points.dart';


class CrudLeadsCubit extends Cubit<LeadsState> {
  final Uuid uuid;
  CrudLeadsCubit(this.uuid) : super(InitialLeadsState());


  void edit(ContactModel model, int? id) async {
    emit(LoadingCrudLeadsState(uuid.v4()));
    try {
      await API().postData(
          endPoint: "${EndPoints.editContact}$id",
          data: model.toJson()).then((value) async {
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

  void deleteContacts(List<int?> ids) async {
    emit(LoadingCrudLeadsState(uuid.v4()));
    try {
      await API().postDataPure(
          endPoint: EndPoints.deleteContacts, data:
      {"ids": ids}).then((value) async {
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
