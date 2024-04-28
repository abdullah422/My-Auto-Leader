
import 'package:mal/model/contact_model.dart';

class AddContactsRequest{
  String? groupId;
  List<ContactModel>? contacts;

  AddContactsRequest(this.groupId, this.contacts);

  AddContactsRequest.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    if (json['data'] != null) {
      contacts = <ContactModel>[];
      json['data'].forEach((v) {
        contacts!.add(ContactModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['group_id'] = groupId;
    if (contacts != null) {
      data['data'] = contacts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}