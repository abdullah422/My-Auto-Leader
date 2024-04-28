import '../../../model/user_profile_model.dart';

abstract class LoadingStates {}

class LoadingInitialState extends LoadingStates {}

class GotoHomeScreenState extends LoadingStates {}
class CheckerState extends LoadingStates {}

class GotoLoginScreenState extends LoadingStates {}

class GetUserDetailsSuccessState extends LoadingStates {}
class GetUserDetailsLoadingState extends LoadingStates {}

class GetUserDetailsLoadedState extends LoadingStates {
  final UserProfile? userProfile;

  GetUserDetailsLoadedState({this.userProfile});
}
class GetUserDetailsErrorState extends LoadingStates {
  final String ? error;

  GetUserDetailsErrorState({this.error});
}
class GetUserDetailsErrorConnectionState extends LoadingStates {
  final String ? error;

  GetUserDetailsErrorConnectionState({this.error});
}


class GetAllNotificationLoadingState extends LoadingStates {}

class GetAllNotificationSuccessState extends LoadingStates {}

class GetAllNotificationErrorState extends LoadingStates {
  final String error;

  GetAllNotificationErrorState(this.error);
}
class GetNotiErrorConnectionState extends LoadingStates {
  final String ? error;

  GetNotiErrorConnectionState({this.error});
}
