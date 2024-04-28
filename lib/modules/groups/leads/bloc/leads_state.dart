
import 'package:equatable/equatable.dart';
import 'package:mal/model/contact_model.dart';

abstract class LeadsState extends Equatable{

}

class InitialLeadsState extends LeadsState{
  @override
  List<Object?> get props => [];

}


class LoadingGetLeadsState extends LeadsState{
  final String random;
  LoadingGetLeadsState(this.random);


  @override
  List<Object?> get props => [random];

}

class EditLeadsState extends LeadsState{
  final String random;
  final int selectedCount;
  EditLeadsState(this.random, this.selectedCount);


  @override
  List<Object?> get props => [random,selectedCount];

}


class LoadedLeadsState extends LeadsState{
  final bool success;
  final List<ContactModel>? leads;

  LoadedLeadsState(this.success, this.leads);


  @override
  List<Object?> get props => [success, leads];
}

class LoadingCrudLeadsState extends LeadsState{
  final String random;
  LoadingCrudLeadsState(this.random);


  @override
  List<Object?> get props => [random];

}

class LoadedCrudLeadState extends LeadsState{
  final bool success;
  final String random;
  LoadedCrudLeadState(this.success, this.random);


  @override
  List<Object?> get props => [success, random];

}

class ChangedImageState extends LeadsState{
  final String? firstName;
  final String? lastName;
  ChangedImageState(this.firstName, this.lastName);


  @override
  List<Object?> get props => [firstName, lastName];

}

class ChangedBirthdayState extends LeadsState{
  final String? birthday;
  ChangedBirthdayState(this.birthday, );


  @override
  List<Object?> get props => [birthday, ];

}