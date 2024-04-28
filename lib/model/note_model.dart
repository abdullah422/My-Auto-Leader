
class NoteModel{
  int? id;
  String? title;
  String? content;
  int? userId;
  String? createdAt;
  String? updatedAt;

  NoteModel(
      {this.id,
        this.title,
        this.content,
        this.userId,
        this.createdAt,
        this.updatedAt});

  NoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    userId = json['contact_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['contact_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}