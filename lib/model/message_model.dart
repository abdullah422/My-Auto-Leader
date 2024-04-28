
class Message {
  int? id;
  int? userId;
  String? mContent;
  String? type;
  String? createdAt;
  String? updatedAt;

  Message({this.id, this.userId, this.mContent, this.type, this.createdAt, this.updatedAt});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    mContent = json['content'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['message'] = mContent;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

/*
class Message {
  int? id;
  int? userId;
  Content? content;
  String? type;
  String? createdAt;
  String? updatedAt;

  Message(
      {this.id,
        this.userId,
        this.content,
        this.type,
        this.createdAt,
        this.updatedAt});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    content =
    json['content'] != null ? Content.fromJson(json['content']) : null;
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    if (content != null) {
      data['content'] = content!.toJson();
    }
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Content {
  String? en;

  Content({this.en});

  Content.fromJson(Map<String, dynamic> json) {
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['en'] = en;
    return data;
  }
}*/
