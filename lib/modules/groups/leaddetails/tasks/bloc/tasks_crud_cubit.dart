
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../../../model/task_model.dart';
import '../../../../../shared/network/remote/api.dart';
import '../../../../../shared/network/remote/end_points.dart';
import 'bloc.dart';

class TasksCrudCubit extends Cubit<TasksState> {
  final Uuid uuid;
  TasksCrudCubit(this.uuid) : super(InitialTasksState());

  void add(TaskModel model) async {
    emit(LoadingCrudTasksState(uuid.v4()));
    try {
      await API().postData(
          endPoint: EndPoints.addUserTask,
          data: model.toJson()).then((value) async {
        try {
          if (value.statusCode == 200) {
            emit(LoadedCrudTasksState(
                true, uuid.v4()
            ));
          } else {
            emit(LoadedCrudTasksState(
                false, uuid.v4()
            ));
          }
        } on DioError catch (e) {
          debugPrint(e.toString());
          emit(LoadedCrudTasksState(false, uuid.v4()));
        } catch (e) {
          debugPrint(e.toString());
          emit(LoadedCrudTasksState(false, uuid.v4()));
        }
      });
    } on DioError catch (e) {
      debugPrint(e.toString());
      emit(LoadedCrudTasksState(false, uuid.v4()));
    }
  }

  void edit(TaskModel model, int? id) async {
    emit(LoadingCrudTasksState(uuid.v4()));
    try {
      await API().postData(
          endPoint: "${EndPoints.editUserTask}$id",
          data: model.toJson()).then((value) async {
        try {
          if (value.statusCode == 200) {
            emit(LoadedCrudTasksState(
                true, uuid.v4()
            ));
          } else {
            emit(LoadedCrudTasksState(
                false, uuid.v4()
            ));
          }
        } on DioError catch (e) {
          debugPrint(e.toString());
          emit(LoadedCrudTasksState(false, uuid.v4()));
        } catch (e) {
          debugPrint(e.toString());
          emit(LoadedCrudTasksState(false, uuid.v4()));
        }
      });
    } on DioError catch (e) {
      debugPrint(e.toString());
      emit(LoadedCrudTasksState(false, uuid.v4()));
    }
  }

  void delete(int id) async {
    emit(LoadingCrudTasksState(uuid.v4()));
    try {
      await API().postDataPure(
          endPoint: EndPoints.deleteUserTask+id.toString(),).then((value) async {
        try {
          if (value.statusCode == 200) {
            emit(LoadedCrudTasksState(
                true, uuid.v4()
            ));
          } else {
            emit(LoadedCrudTasksState(
                false, uuid.v4()
            ));
          }
        } on DioError catch (e) {
          debugPrint(e.toString());
          emit(LoadedCrudTasksState(false, uuid.v4()));
        } catch (e) {
          debugPrint(e.toString());
          emit(LoadedCrudTasksState(false, uuid.v4()));
        }
      });
    } on DioError catch (e) {
      debugPrint(e.toString());
      emit(LoadedCrudTasksState(false, uuid.v4()));
    }
  }

  /// m is either complete or incomplete
  void mark(String m, int? id) async {
    emit(LoadingCrudTasksState(uuid.v4()));
    try {
      await API().postData(
          endPoint: "${EndPoints.markUserTask}$id",
          data: {"status": m}).then((value) async {
        try {
          if (value.statusCode == 200) {
            emit(LoadedCrudTasksState(
                true, uuid.v4()
            ));
          } else {
            emit(LoadedCrudTasksState(
                false, uuid.v4()
            ));
          }
        } on DioError catch (e) {
          debugPrint(e.toString());
          emit(LoadedCrudTasksState(false, uuid.v4()));
        } catch (e) {
          debugPrint(e.toString());
          emit(LoadedCrudTasksState(false, uuid.v4()));
        }
      });
    } on DioError catch (e) {
      debugPrint(e.toString());
      emit(LoadedCrudTasksState(false, uuid.v4()));
    }
  }
}
