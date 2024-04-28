

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../model/contact_model.dart';
import '../../../../shared/network/remote/api.dart';
import '../../../../shared/network/remote/end_points.dart';
import 'bloc.dart';

class LeadDetailsCubit extends Cubit<LeadDetailsState>{
  LeadDetailsCubit() : super(InitialLeadDetailsState());

  void getContactDetails(int? contactId) async{
    if(contactId==null){
      emit(LoadedLeadDetailsState(true, null));
    } else {
      try {
        emit(LoadingLeadDetailsState());
        await API().getData(endPoint: "${EndPoints.getContact}$contactId",
        ).then((value) async {
          try {
            if (value.data["contact"] != null) {
              ContactModel data = ContactModel.fromJson(value.data["contact"]);
              emit(LoadedLeadDetailsState(true, data));
            }
          } on DioError catch (e) {
            debugPrint(e.toString());
            emit(LoadedLeadDetailsState(false, null));
          } catch (e) {
            debugPrint(e.toString());
            emit(LoadedLeadDetailsState(false, null));
          }
        });
      } on DioError catch (e) {
        debugPrint(e.toString());
        emit(LoadedLeadDetailsState(false, null));
      }
    }
  }
}