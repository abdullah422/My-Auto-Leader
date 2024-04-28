
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mal/model/address_model.dart';
import 'package:mal/model/contact_model.dart';
import 'package:mal/model/email_model.dart';
import 'package:mal/model/phone_model.dart';
import 'package:mal/modules/groups/contacts/bloc/contact_state.dart';

import '../../../../model/add_contacts_request.dart';
import '../../../../shared/network/remote/api.dart';
import '../../../../shared/network/remote/end_points.dart';
import '../contact_data.dart';

class UploadContactsCubit extends Cubit<ContactState>{
  UploadContactsCubit() : super(ContactInitialState());

  void addContactToGroup(int groupId, List<ContactData> data)async{
      emit(UploadingContactsState());
      AddContactsRequest request = convertDataToModels(groupId,data);
      try {
        await API().postDataPure(
            endPoint: EndPoints.addContactsToGroup,
            data: request.toJson()).then((value) async {
          try {
            if (value.statusCode == 200) {
              emit(UploadedContactsState(true,));
            } else {
              emit(UploadedContactsState(false,));
            }
          } on DioError catch (e) {
            debugPrint(e.toString());
            emit(UploadedContactsState(false,));
          } catch (e) {
            debugPrint(e.toString());
            emit(UploadedContactsState(false,));
          }
        });
      } on DioError catch (e) {
        debugPrint(e.toString());
        emit(UploadedContactsState(false,));
      }
  }

  void addContactModelToGroup(int groupId, ContactModel model)async{
    emit(UploadingContactsState());
    model.status ??= "no status";
    if(model.status?.isEmpty == true){
      model.status = "no status";
    }
    AddContactsRequest request = convertDataToModel(groupId,model);
    try {
      await API().postDataPure(
          endPoint: EndPoints.addContactsToGroup,
          data: request.toJson()).then((value) async {
        try {
          if (value.statusCode == 200) {
            emit(UploadedContactsState(true,));
          } else {
            emit(UploadedContactsState(false,));
          }
        } on DioError catch (e) {
          debugPrint(e.toString());
          emit(UploadedContactsState(false,));
        } catch (e) {
          debugPrint(e.toString());
          emit(UploadedContactsState(false,));
        }
      });
    } on DioError catch (e) {
      debugPrint(e.toString());
      emit(UploadedContactsState(false,));
    }
  }

  void editContactModelToGroup(int groupId, ContactModel model)async{
    emit(UploadingContactsState());
    try {
      await API().postDataPure(
          endPoint: EndPoints.editContact+(model.id?.toString()??""),
          data: model.toJson()).then((value) async {
        try {
          if (value.statusCode == 200) {
            emit(UploadedContactsState(true,));
          } else {
            emit(UploadedContactsState(false,));
          }
        } on DioError catch (e) {
          debugPrint(e.toString());
          emit(UploadedContactsState(false,));
        } catch (e) {
          debugPrint(e.toString());
          emit(UploadedContactsState(false,));
        }
      });
    } on DioError catch (e) {
      debugPrint(e.toString());
      emit(UploadedContactsState(false,));
    }
  }


  AddContactsRequest convertDataToModels(int groupId, List<ContactData> data) {
    List<ContactModel> contacts = [];
    for(int i = 0; i < data.length; i++){
      ContactModel model = ContactModel();
      model.displayName = data[i].contact?.displayName;
      model.givenName = data[i].contact?.givenName;
      model.familyName = data[i].contact?.familyName;
      DateTime date = data[i].contact?.birthday??DateTime.now();
      model.birthday = DateFormat('yyyy-MM-dd').format(date);
      model.company = data[i].contact?.company;
      model.jobTitle = data[i].contact?.jobTitle;
      model.status = "cold";
      model.phones = [];
      for(int j = 0; j < (data[i].contact?.phones?.length??0); j++){
        model.phones?.add(PhoneModel(value: data[i].contact!.phones![j].value,
            label: data[i].contact!.phones![j].label));
      }
      for(int j = 0; j < (data[i].contact?.emails?.length??0); j++){
        model.emails?.add(EmailModel(value: data[i].contact!.emails![j].value,
            label: data[i].contact!.emails![j].label));
      }
      for(int j = 0; j < (data[i].contact?.postalAddresses?.length??0); j++){
        model.addresses?.add(AddressModel(street: data[i].contact!.postalAddresses![j].street,
            label: data[i].contact!.postalAddresses![j].label, city: data[i].contact!.postalAddresses![j].city,
        country: data[i].contact!.postalAddresses![j].country, region: data[i].contact!.postalAddresses![j].region,
        postcode: data[i].contact!.postalAddresses![j].postcode));
      }

      contacts.add(model);
    }
    return AddContactsRequest(groupId.toString(), contacts);
  }

  AddContactsRequest convertDataToModel(int groupId, ContactModel model) {
    List<ContactModel> contacts = [];
    contacts.add(model);
    return AddContactsRequest(groupId.toString(), contacts);
  }
}