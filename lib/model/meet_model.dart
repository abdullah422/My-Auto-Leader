class MeetModel{
  int? userId;
  String? zoomId;
  String? meetingId;
  String? topic;
  String? duration;
  String? startTime;
  String? timezone;
  String? startUrl;
  String? joinUrl;
  String? scheduleFor;
  String? zoomCreatedAt;
  String? updatedAt;
  String? createdAt;
  int? id;

  MeetModel(
      {this.userId,
        this.zoomId,
        this.meetingId,
        this.topic,
        this.duration,
        this.startTime,
        this.timezone,
        this.startUrl,
        this.joinUrl,
        this.zoomCreatedAt,
        this.updatedAt,
        this.createdAt,
        this.scheduleFor,
        this.id});

  MeetModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    zoomId = json['zoom_id'];
    meetingId = json['meeting_id'].toString();
    topic = json['topic'];
    scheduleFor = json['schedule_for'];
    duration = json['duration'].toString();
    startTime = json['start_time'];
    timezone = json['timezone'];
    startUrl = json['start_url'];
    joinUrl = json['join_url'];
    zoomCreatedAt = json['zoom_created_at'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['zoom_id'] = zoomId;
    data['meeting_id'] = meetingId;
    data['topic'] = topic;
    data['duration'] = duration;
    data['start_time'] = startTime;
    data['timezone'] = timezone;
    data['start_url'] = startUrl;
    data['join_url'] = joinUrl;
    data['zoom_created_at'] = zoomCreatedAt;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}