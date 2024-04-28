
class TaskModel{
  int? id;
  String? title;
  int? userId;
  String? createdAt;
  String? updatedAt;
  String? status;

  TaskModel(
      {this.id,
        this.title,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.status});

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    userId = json['contact_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['contact_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    return data;
  }
}