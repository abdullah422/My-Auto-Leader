

import 'package:bloc/bloc.dart';
import 'package:mal/modules/groups/contacts/bloc/contact_state.dart';
import 'package:uuid/uuid.dart';

import '../contact_data.dart';

class ContactCubit extends Cubit<ContactState>{
  final Uuid uuid;
  ContactCubit(this.uuid) : super(ContactInitialState());
  
  void refresh(){
    emit(ContactChangedState(uuid.v4()));
  }

}