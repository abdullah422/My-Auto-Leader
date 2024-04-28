
import 'package:equatable/equatable.dart';

import '../../../model/group_model.dart';

abstract class GroupsState extends Equatable{

}

class InitialGroupsState extends GroupsState{
  @override
  List<Object?> get props => [];

}

class EditGroupsState extends GroupsState{
  final String random;
  final int selectedCount;
  EditGroupsState(this.random, this.selectedCount);


  @override
  List<Object?> get props => [random,selectedCount];

}

class RefreshGroupsState extends GroupsState{
  final String random;
  RefreshGroupsState(this.random);


  @override
  List<Object?> get props => [random];

}

class LoadingGetGroupsState extends GroupsState{
  final String random;
  LoadingGetGroupsState(this.random);


  @override
  List<Object?> get props => [random];

}

class LoadedGroupsState extends GroupsState{
  final bool success;
  final List<GroupModel>? groups;

  LoadedGroupsState(this.success, this.groups);


  @override
  List<Object?> get props => [success, groups];

}

class LoadingCreateGroupState extends GroupsState{
  final String random;
  LoadingCreateGroupState(this.random);


  @override
  List<Object?> get props => [random];

}

class LoadedCreateGroupState extends GroupsState{
  final bool success;
  final String random;
  LoadedCreateGroupState(this.success, this.random);


  @override
  List<Object?> get props => [success, random];

}



