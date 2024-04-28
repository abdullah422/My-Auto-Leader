import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper{
  static late SharedPreferences sharedPref;

  static Future<void> init() async{
    sharedPref = await SharedPreferences.getInstance();
  }

  static Future<bool> saveUserToken({required String token}) async{
      return await sharedPref.setString('token', token);
  }
  static Future<bool> saveMFCToken({required String mFCToken}) async{
    return await sharedPref.setString('MFCToken', mFCToken);
  }
  static String? getCurrentMFCToken() {
    return sharedPref.getString('MFCToken');
  }
  static Future<bool> saveNewNumberOfNoti({required int number}) async{
    return await sharedPref.setInt('noti', number);
  }
  static int? getNewNumberOfNoti() {
    return sharedPref.getInt('noti');
  }
  static Future<bool> savePreviousNumberOfNoti({required int number}) async{
    return await sharedPref.setInt('p_noti', number);
  }
  static int? getPreviousNumberOfNoti() {
    return sharedPref.getInt('p_noti');
  }


  static Future<bool> saveLanguage({required String lang}) async{
    return await sharedPref.setString('lang', lang);
  }
  static String? getCurrentLanguage() {
    return sharedPref.getString('lang');
  }

  static String? getUserToken() {
    return sharedPref.getString('token');
  }

  static Future<bool> deleteUserToken() async{
    return await sharedPref.remove('token');
  }

  static Future<bool> setPhoneVerifiedState({required bool verified}) async{
    return await sharedPref.setBool('phoneVerified', verified);
  }

  static bool getPhoneVerifiedState() {
    bool? state = sharedPref.getBool('phoneVerified');
    if(state == null){
      return false;
    }else{
      return state;
    }

  }



}