
import 'package:equatable/equatable.dart';
import 'package:mal/model/task_model.dart';

abstract class TasksState extends Equatable{

}

class InitialTasksState extends TasksState{
  @override
  List<Object?> get props => [];

}


class LoadingGetTasksState extends TasksState{
  final String random;
  LoadingGetTasksState(this.random);


  @override
  List<Object?> get props => [random];

}

class LoadedTasksState extends TasksState{
  final bool success;
  final List<TaskModel>? tasks;

  LoadedTasksState(this.success, this.tasks);


  @override
  List<Object?> get props => [success, tasks];
}

class LoadingCrudTasksState extends TasksState{
  final String random;
  LoadingCrudTasksState(this.random);


  @override
  List<Object?> get props => [random];

}

class LoadedCrudTasksState extends TasksState{
  final bool success;
  final String random;
  LoadedCrudTasksState(this.success, this.random);


  @override
  List<Object?> get props => [success, random];

}
