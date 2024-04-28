import 'package:mal/model/user_model.dart';
import 'package:mal/model/user_profile_model.dart';
class ProfileResponse {
  late UserProfile profile;
  late User user;
  ProfileResponse.fromJson(Map<String, dynamic> json) {
    profile = UserProfile.fromJson(json['profile']);
    user = User.fromJson(json['user']);
  }
} //end of response
