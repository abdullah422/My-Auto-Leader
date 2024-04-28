import 'contact_model.dart';

class GroupModel{
  int? id;
  String? title;
  int? userId;
  String? createdAt;
  String? updatedAt;
  List<ContactModel>? contacts;

  GroupModel(
      {this.id,
        this.title,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.contacts});

  GroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['contacts'] != null) {
      contacts = <ContactModel>[];
      json['contacts'].forEach((v) {
        contacts!.add(ContactModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (contacts != null) {
      data['contacts'] = contacts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}