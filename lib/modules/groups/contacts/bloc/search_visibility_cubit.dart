
import 'package:bloc/bloc.dart';
import 'package:mal/modules/groups/contacts/bloc/contact_state.dart';
import 'package:uuid/uuid.dart';

class SearchVisibilityCubit extends Cubit<ContactState>{
  final Uuid uuid;
  SearchVisibilityCubit(this.uuid) : super(SearchVisibilityState(false, "gjiwe"));

  void show(){
    emit(SearchVisibilityState(true, uuid.v4()));
  }

  void hide(){
    emit(SearchVisibilityState(false, uuid.v4()));
  }
}