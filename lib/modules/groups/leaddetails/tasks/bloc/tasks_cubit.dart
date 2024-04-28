

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mal/model/task_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../../shared/network/remote/api.dart';
import '../../../../../shared/network/remote/end_points.dart';
import 'bloc.dart';


class TasksCubit extends Cubit<TasksState>{
  TasksCubit(this.uuid) : super(InitialTasksState());
  final Uuid uuid;
  Future getTasks(int contactId)async{
    try {
      emit(LoadingGetTasksState(uuid.v4()));
      await API().getData(endPoint: "${EndPoints.getUserTasks}$contactId",
      ).then((value) async {
        try {
          if(value.data["tasks"]!=null){
            var tasks = <TaskModel>[];
            value.data["tasks"].forEach((v) {
              tasks.add(TaskModel.fromJson(v));
            });
            emit(LoadedTasksState(true, tasks));
          }

        } on DioError catch (e) {
          debugPrint(e.toString());
          emit(LoadedTasksState(false, null));
        } catch (e) {
          debugPrint(e.toString());
          emit(LoadedTasksState(false, null));
        }
      });
    } on DioError catch (e){
      debugPrint(e.toString());
      emit(LoadedTasksState(false, null));
    }
  }
}