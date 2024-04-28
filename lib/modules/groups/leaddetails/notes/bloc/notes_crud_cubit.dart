
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mal/model/note_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../../shared/network/remote/api.dart';
import '../../../../../shared/network/remote/end_points.dart';
import 'bloc.dart';

class NotesCrudCubit extends Cubit<NotesState> {
  final Uuid uuid;
  NotesCrudCubit(this.uuid) : super(InitialNotesState());

  void add(NoteModel model) async {
    emit(LoadingCrudNotesState(uuid.v4()));
    try {
      await API().postData(
          endPoint: EndPoints.addUserNote,
          data: model.toJson()).then((value) async {
        try {
          if (value.statusCode == 200) {
            emit(LoadedCrudNotesState(
                true, uuid.v4()
            ));
          } else {
            emit(LoadedCrudNotesState(
                false, uuid.v4()
            ));
          }
        } on DioError catch (e) {
          debugPrint(e.toString());
          emit(LoadedCrudNotesState(false, uuid.v4()));
        } catch (e) {
          debugPrint(e.toString());
          emit(LoadedCrudNotesState(false, uuid.v4()));
        }
      });
    } on DioError catch (e) {
      debugPrint(e.toString());
      emit(LoadedCrudNotesState(false, uuid.v4()));
    }
  }

  void edit(NoteModel model, int? id) async {
    emit(LoadingCrudNotesState(uuid.v4()));
    try {
      await API().postData(
          endPoint: "${EndPoints.editUserNote}$id",
          data: model.toJson()).then((value) async {
        try {
          if (value.statusCode == 200) {
            emit(LoadedCrudNotesState(
                true, uuid.v4()
            ));
          } else {
            emit(LoadedCrudNotesState(
                false, uuid.v4()
            ));
          }
        } on DioError catch (e) {
          debugPrint(e.toString());
          emit(LoadedCrudNotesState(false, uuid.v4()));
        } catch (e) {
          debugPrint(e.toString());
          emit(LoadedCrudNotesState(false, uuid.v4()));
        }
      });
    } on DioError catch (e) {
      debugPrint(e.toString());
      emit(LoadedCrudNotesState(false, uuid.v4()));
    }
  }

  void delete(int id) async {
    emit(LoadingCrudNotesState(uuid.v4()));
    try {
      await API().postDataPure(
          endPoint: EndPoints.deleteUserNote+id.toString(),).then((value) async {
        try {
          if (value.statusCode == 200) {
            emit(LoadedCrudNotesState(
                true, uuid.v4()
            ));
          } else {
            emit(LoadedCrudNotesState(
                false, uuid.v4()
            ));
          }
        } on DioError catch (e) {
          debugPrint(e.toString());
          emit(LoadedCrudNotesState(false, uuid.v4()));
        } catch (e) {
          debugPrint(e.toString());
          emit(LoadedCrudNotesState(false, uuid.v4()));
        }
      });
    } on DioError catch (e) {
      debugPrint(e.toString());
      emit(LoadedCrudNotesState(false, uuid.v4()));
    }
  }
}
