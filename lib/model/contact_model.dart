import 'package:mal/model/phone_model.dart';

import 'address_model.dart';
import 'email_model.dart';

class ContactModel {
  int? id;
  String? displayName;
  String? givenName;
  String? familyName;
  List<EmailModel>? emails;
  List<PhoneModel>? phones;
  List<AddressModel>? addresses;
  String? birthday;
  String? company;
  String? jobTitle;
  String? status;
  int? groupId;
  int? userId;
  String? createdAt;
  String? updatedAt;

  ContactModel(
      {this.id,
        this.displayName,
        this.givenName,
        this.familyName,
        this.emails,
        this.phones,
        this.addresses,
        this.birthday,
        this.company,
        this.jobTitle,
        this.status,
        this.groupId,
        this.userId,
        this.createdAt,
        this.updatedAt});

  ContactModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['displayName'];
    givenName = json['givenName'];
    familyName = json['familyName'];
    if (json['emails'] != null) {
      emails = <EmailModel>[];
      json['emails'].forEach((v) {
        emails!.add(EmailModel.fromJson(v));
      });
    }
    if (json['phones'] != null) {
      phones = <PhoneModel>[];
      json['phones'].forEach((v) {
        phones!.add(PhoneModel.fromJson(v));
      });
    }
    if (json['addresses'] != null) {
      addresses = <AddressModel>[];
      json['addresses'].forEach((v) {
        addresses!.add(AddressModel.fromJson(v));
      });
    }
    birthday = json['birthday'];
    company = json['company'];
    jobTitle = json['jobTitle'];
    status = json['status'];
    groupId = json['group_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['displayName'] = displayName;
    data['givenName'] = givenName;
    data['familyName'] = familyName;
    if (emails != null) {
      data['emails'] = emails!.map((v) => v.toJson()).toList();
    } else {
      data['emails'] = null;
    }
    if (phones != null) {
      data['phones'] = phones!.map((v) => v.toJson()).toList();
    } else {
      data['phones'] = null;
    }
    if (addresses != null) {
      data['addresses'] = addresses!.map((v) => v.toJson()).toList();
    } else {
      data['addresses'] = null;
    }
    data['birthday'] = birthday;
    data['company'] = company;
    data['jobTitle'] = jobTitle;
    data['status'] = status;
    data['group_id'] = groupId;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}