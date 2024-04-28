
import 'package:bloc/bloc.dart';
import 'package:mal/modules/groups/bloc/groups_state.dart';
import 'package:uuid/uuid.dart';

class GroupsUiCubit extends Cubit<GroupsState>{
  GroupsUiCubit(this.uuid) : super(InitialGroupsState());
  final Uuid uuid;
  void showEdit(int selectedCount){
    emit(EditGroupsState(uuid.v4(), selectedCount));
  }

  void hideEdit(){
    emit(InitialGroupsState());
  }
}