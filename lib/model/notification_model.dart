class Notification {
  int? id;
  String? title;
  String? body;
  String? role;
  int? userId;
  String? createdAt;
  String? updatedAt;
  String? status;

  Notification(
      {this.id,
        this.title,
        this.body,
        this.role,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.status});

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    role = json['role'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
  }
}