

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mal/model/contact_model.dart';
import 'package:mal/modules/groups/leads/bloc/leads_state.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/network/remote/api.dart';
import '../../../../shared/network/remote/end_points.dart';

class LeadsCubit extends Cubit<LeadsState>{
  LeadsCubit(this.uuid) : super(InitialLeadsState());
  final Uuid uuid;
  Future getLeads(int groupId)async{
    try {
      emit(LoadingGetLeadsState(uuid.v4()));
      await API().getData(endPoint: "${EndPoints.groupDetails}$groupId",
      ).then((value) async {
        try {
          if(value.data["groups"]!=null){
            var leads = <ContactModel>[];
            value.data["groups"]["contacts"].forEach((v) {
              leads.add(ContactModel.fromJson(v));
            });
            emit(LoadedLeadsState(true, leads));
          }

        } on DioError catch (e) {
          debugPrint(e.toString());
          emit(LoadedLeadsState(false, null));
        } catch (e) {
          debugPrint(e.toString());
          emit(LoadedLeadsState(false, null));
        }
      });
    } on DioError catch (e){
      debugPrint(e.toString());
      emit(LoadedLeadsState(false, null));
    }
  }
}