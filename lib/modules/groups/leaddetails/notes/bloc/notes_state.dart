
import 'package:equatable/equatable.dart';
import 'package:mal/model/note_model.dart';

abstract class NotesState extends Equatable{

}

class InitialNotesState extends NotesState{
  @override
  List<Object?> get props => [];

}


class LoadingGetNotesState extends NotesState{
  final String random;
  LoadingGetNotesState(this.random);


  @override
  List<Object?> get props => [random];

}

class LoadedNotesState extends NotesState{
  final bool success;
  final List<NoteModel>? notes;

  LoadedNotesState(this.success, this.notes);


  @override
  List<Object?> get props => [success, notes];
}

class LoadingCrudNotesState extends NotesState{
  final String random;
  LoadingCrudNotesState(this.random);


  @override
  List<Object?> get props => [random];

}

class LoadedCrudNotesState extends NotesState{
  final bool success;
  final String random;
  LoadedCrudNotesState(this.success, this.random);


  @override
  List<Object?> get props => [success, random];

}
