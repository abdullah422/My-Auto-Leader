class Stage {
  int? id;
  int? userId;
  int? stageId;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? title;
  String? description;

  Stage(
      {this.id,
        this.userId,
        this.stageId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.title,
        this.description});

  Stage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    stageId = json['stage_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    title = json['title'];
    description = json['description'];
  }
}