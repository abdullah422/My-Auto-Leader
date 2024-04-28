



import 'package:mal/model/user_profile_model.dart';

import '../../../model/settings_model.dart';

abstract class AuthStates {}
class AuthInitialState extends AuthStates {}

class LoginLoadingState extends AuthStates {}
class LoginSuccessState extends AuthStates {}
class ChangePasswordVisibilityState extends AuthStates {}

class LoginDioErrorState extends AuthStates {
  final String error;
  LoginDioErrorState({required this.error});
}
class LoginErrorState extends AuthStates {
  final String error;
  LoginErrorState({required this.error});
}
class GetUserProfileLoadingState extends AuthStates {}
class GetUserProfileSuccessState extends AuthStates {
  final UserProfile ? userProfile;

  GetUserProfileSuccessState({this.userProfile});
}
class GetUserProfileErrorState extends AuthStates {
  final String error;

  GetUserProfileErrorState({required this.error});
}
class ChangeLoginButtonStates extends AuthStates {}
class ForTest extends AuthStates {}


class ProfileImageLoadedState extends AuthStates {}
class RemoveSelectedImageState extends AuthStates {}


//update profile
class UpdateProfileLoadingState extends AuthStates {}
class UpdateProfileSuccessState extends AuthStates {
  final String message;

  UpdateProfileSuccessState({required this.message});
}
class UpdateProfileErrorState extends AuthStates {
  final String error;

  UpdateProfileErrorState(this.error);
}

//update profile
class NoChangesHappened extends AuthStates {}
class UploadImageLoadingState extends AuthStates {}
class UploadImageSuccessState extends AuthStates {}
class UploadImageErrorState extends AuthStates {
  final String error;

  UploadImageErrorState(this.error);
}

class GetSettingsLoadingState extends AuthStates {}
class GetSettingsSuccessState extends AuthStates {
  final Settings ? settings;

  GetSettingsSuccessState({this.settings});
}
class GetSettingsErrorState extends AuthStates {
  final String error;

  GetSettingsErrorState({required this.error});
}