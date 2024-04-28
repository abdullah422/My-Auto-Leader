
import 'package:bloc/bloc.dart';
import 'package:mal/modules/groups/leads/bloc/leads_state.dart';
import 'package:uuid/uuid.dart';

class LeadsUiCubit extends Cubit<LeadsState>{
  LeadsUiCubit(this.uuid) : super(InitialLeadsState());
  final Uuid uuid;
  void showEdit(int selectedCount){
    emit(EditLeadsState(uuid.v4(), selectedCount));
  }

  void hideEdit(){
    emit(InitialLeadsState());
  }
}