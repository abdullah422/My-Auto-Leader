
import 'package:equatable/equatable.dart';

abstract class ZoomEvent extends Equatable{

}

class CreateMeetEvent extends ZoomEvent{
  final String startDateTime;
  final String meetingTopic;

  CreateMeetEvent(this.startDateTime, this.meetingTopic);

  @override
  List<Object?> get props => [startDateTime, meetingTopic];
}

class UpdateMeetEvent extends ZoomEvent{
  final String meetingId;

  UpdateMeetEvent(this.meetingId);

  @override
  List<Object?> get props => [meetingId, ];
}

class GetMeetingsEvent extends ZoomEvent{
  final int meetingType; //0 is previous and the 1 is upcoming
  final String perPage;
  final String pageNumber;

  GetMeetingsEvent(this.meetingType, this.perPage, this.pageNumber);

  @override
  List<Object?> get props => [meetingType, perPage, pageNumber];

}

class ResetMeetingList extends ZoomEvent{
  @override
  List<Object?> get props => [];

}

class SyncZoom extends ZoomEvent{
  @override
  List<Object?> get props => [];

}