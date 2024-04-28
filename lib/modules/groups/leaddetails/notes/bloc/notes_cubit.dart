

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mal/model/note_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../../shared/network/remote/api.dart';
import '../../../../../shared/network/remote/end_points.dart';
import 'bloc.dart';


class NotesCubit extends Cubit<NotesState>{
  NotesCubit(this.uuid) : super(InitialNotesState());
  final Uuid uuid;
  Future getNotes(int contactId)async{
    try {
      emit(LoadingGetNotesState(uuid.v4()));
      await API().getData(endPoint: "${EndPoints.getUserNotes}$contactId",
      ).then((value) async {
        try {
          if(value.data["notes"]!=null){
            var notes = <NoteModel>[];
            value.data["notes"].forEach((v) {
              notes.add(NoteModel.fromJson(v));
            });
            emit(LoadedNotesState(true, notes));
          }

        } on DioError catch (e) {
          debugPrint(e.toString());
          emit(LoadedNotesState(false, null));
        } catch (e) {
          debugPrint(e.toString());
          emit(LoadedNotesState(false, null));
        }
      });
    } on DioError catch (e){
      debugPrint(e.toString());
      emit(LoadedNotesState(false, null));
    }
  }
}