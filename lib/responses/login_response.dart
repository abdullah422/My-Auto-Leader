
import 'package:mal/model/user_model.dart';
class LoginResponse {
  late User user;
  late String? token;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    user = User.fromJson(json['data']['user']);
    token = json['data']['token'];
  }
} //end of response
