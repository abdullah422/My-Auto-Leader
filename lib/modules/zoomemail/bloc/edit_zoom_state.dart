

import 'package:equatable/equatable.dart';

abstract class EditZoomState extends Equatable{

}

class EditZoomInitialState extends EditZoomState{
  @override
  List<Object?> get props => [];
}

class EditZoomLoadingState extends EditZoomState{
  @override
  List<Object?> get props => [];
}


class GetZoomEmailLoadedState extends EditZoomInitialState{
  final bool success;
  final String? email;

  GetZoomEmailLoadedState(this.success, this.email);

  @override
  List<Object?> get props => [ success, email];
}