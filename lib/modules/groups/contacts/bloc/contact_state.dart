
import 'package:equatable/equatable.dart';

import '../contact_data.dart';

abstract class ContactState extends Equatable{

}

class ContactInitialState extends ContactState{

  ContactInitialState();


  @override
  List<Object?> get props => [];

}

class UploadingContactsState extends ContactState{

  UploadingContactsState();


  @override
  List<Object?> get props => [];

}


class UploadedContactsState extends ContactState{
  final bool success;
  UploadedContactsState(this.success);


  @override
  List<Object?> get props => [success];

}



class ContactChangedState extends ContactState{
  final String random;

  ContactChangedState(this.random);


  @override
  List<Object?> get props => [random];

}

class SearchVisibilityState extends ContactState{
  final bool visibility;
  final String random;

  SearchVisibilityState(this.visibility, this.random);


  @override
  List<Object?> get props => [visibility, random];

}