
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/model/group_model.dart';
import 'package:mal/modules/groups/bloc/groups_state.dart';
import 'package:uuid/uuid.dart';

import '../../../shared/network/remote/api.dart';
import '../../../shared/network/remote/end_points.dart';

class GroupsCubit extends Cubit<GroupsState>{
  GroupsCubit(this.uuid) : super(InitialGroupsState());
  final Uuid uuid;
  Future getGroups()async{
    try {
      emit(LoadingGetGroupsState(uuid.v4()));
      await API().getData(endPoint: EndPoints.getGroups,).then((value) async {
        try {
          if(value.data["groups"]!=null){
            var groups = <GroupModel>[];
            value.data["groups"].forEach((v) {
              groups.add(GroupModel.fromJson(v));
            });
            emit(LoadedGroupsState(true, groups));
          }

        } on DioError catch (e) {
          debugPrint(e.toString());
          emit(LoadedGroupsState(false, null));
        } catch (e) {
          debugPrint(e.toString());
          emit(LoadedGroupsState(false, null));
        }
      });
    } on DioError catch (e){
      debugPrint(e.toString());
      emit(LoadedGroupsState(false, null));
    }
  }
}