
import 'package:equatable/equatable.dart';
import 'package:mal/model/meet_model.dart';

abstract class ZoomState extends Equatable{

}

class ZoomInitialState extends ZoomState{
  @override
  List<Object?> get props => [];

}

class CreateMeetingLoadingState extends ZoomState{
  @override
  List<Object?> get props => [];
}

class UpdateMeetingLoadingState extends ZoomState{
  @override
  List<Object?> get props => [];
}

class CreateMeetingLoadedState extends ZoomState{
  final String message;
  final bool success;
  final MeetModel? meetModel;

  CreateMeetingLoadedState(this.message, this.success, this.meetModel);

  @override
  List<Object?> get props => [message, success, meetModel];
}

class UpdateMeetingLoadedState extends ZoomState{
  final String message;
  final bool success;

  UpdateMeetingLoadedState(this.message, this.success,);

  @override
  List<Object?> get props => [message, success,];
}

class MeetingLoadedState extends ZoomState{
  final List<MeetModel>? meets;
  final bool? hasMore;
  final int? currentPage;

  MeetingLoadedState(this.meets, this.hasMore, this.currentPage);

  @override
  List<Object?> get props => [meets, hasMore, currentPage];
}

class SyncLoadedState extends ZoomState{
  final String message;
  final bool success;

  SyncLoadedState(this.message, this.success,);

  @override
  List<Object?> get props => [message, success,];
}