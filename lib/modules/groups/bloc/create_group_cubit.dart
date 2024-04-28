import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mal/modules/groups/bloc/groups_state.dart';
import 'package:uuid/uuid.dart';

import '../../../shared/network/remote/api.dart';
import '../../../shared/network/remote/end_points.dart';

class CreateGroupCubit extends Cubit<GroupsState> {
  final Uuid uuid;
  CreateGroupCubit(this.uuid) : super(InitialGroupsState());

  void createGroup(String name) async {
    emit(LoadingCreateGroupState(uuid.v4()));
    try {
      await API().postData(
          endPoint: EndPoints.createGroup,
          data: {"title": name}).then((value) async {
        try {
          if (value.statusCode == 200) {
            emit(LoadedCreateGroupState(
              true,
                uuid.v4()
            ));
          } else {
            emit(LoadedCreateGroupState(
              false,
                uuid.v4()
            ));
          }
        } on DioError catch (e) {
          debugPrint(e.toString());
          emit(LoadedCreateGroupState(false, uuid.v4()));
        } catch (e) {
          debugPrint(e.toString());
          emit(LoadedCreateGroupState(false, uuid.v4()));
        }
      });
    } on DioError catch (e) {
      debugPrint(e.toString());
      emit(LoadedCreateGroupState(false, uuid.v4()));
    }
  }

  void editGroup(String name, int? id) async {
    emit(LoadingCreateGroupState(uuid.v4()));
    try {
      await API().postData(
          endPoint: "${EndPoints.editGroup}$id",
          data: {"title": name}).then((value) async {
        try {
          if (value.statusCode == 200) {
            emit(LoadedCreateGroupState(
              true, uuid.v4()
            ));
          } else {
            emit(LoadedCreateGroupState(
              false, uuid.v4()
            ));
          }
        } on DioError catch (e) {
          debugPrint(e.toString());
          emit(LoadedCreateGroupState(false, uuid.v4()));
        } catch (e) {
          debugPrint(e.toString());
          emit(LoadedCreateGroupState(false, uuid.v4()));
        }
      });
    } on DioError catch (e) {
      debugPrint(e.toString());
      emit(LoadedCreateGroupState(false, uuid.v4()));
    }
  }

  void deleteGroups(List<int?> ids) async {
    emit(LoadingCreateGroupState(uuid.v4()));
    try {
      await API().postDataPure(
          endPoint: EndPoints.deleteGroups, data:
      {"ids": ids}).then((value) async {
        try {
          if (value.statusCode == 200) {
            emit(LoadedCreateGroupState(
                true, uuid.v4()
            ));
          } else {
            emit(LoadedCreateGroupState(
                false, uuid.v4()
            ));
          }
        } on DioError catch (e) {
          debugPrint(e.toString());
          emit(LoadedCreateGroupState(false, uuid.v4()));
        } catch (e) {
          debugPrint(e.toString());
          emit(LoadedCreateGroupState(false, uuid.v4()));
        }
      });
    } on DioError catch (e) {
      debugPrint(e.toString());
      emit(LoadedCreateGroupState(false, uuid.v4()));
    }
  }
}
