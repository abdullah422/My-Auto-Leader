
import 'package:equatable/equatable.dart';
import 'package:mal/model/contact_model.dart';

abstract class LeadDetailsState extends Equatable{

}

class InitialLeadDetailsState extends LeadDetailsState{
  @override
  List<Object?> get props => [];

}

class LoadingLeadDetailsState extends LeadDetailsState{
  @override
  List<Object?> get props => [];

}

class LoadedLeadDetailsState extends LeadDetailsState{
  final bool success;
  final ContactModel? data;


  LoadedLeadDetailsState(this.success, this.data);

  @override
  List<Object?> get props => [success, data];

}

class RefreshState extends LeadDetailsState{
  final String random;

  RefreshState(this.random);

  @override
  List<Object?> get props => [random];

}