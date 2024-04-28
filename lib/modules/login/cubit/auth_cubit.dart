import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mal/model/settings_model.dart';
import 'package:mal/model/user_model.dart';
import 'package:mal/model/user_profile_model.dart';
import 'package:mal/responses/login_response.dart';
import 'package:mal/responses/profile_response.dart';
import 'package:mal/shared/network/local/shared_preferences.dart';
import 'package:mal/shared/network/remote/api.dart';
import 'package:mal/shared/network/remote/end_points.dart';
import 'package:mal/translations/locale_keys.g.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(context) => BlocProvider.of<AuthCubit>(context);
  late String token;
  late bool isLoginLoading = false;

  UserProfile? userProfile;
  User? user;
  bool getUserProfileLoading = false;
  bool getUserProfileErrorConnection = false;

  void getUserProfile() async {
    getUserProfileLoading = true;
    getUserProfileErrorConnection = false;
    try {
      emit(GetUserProfileLoadingState());
      await API().getData(endPoint: EndPoints.getUserProfile).then((value) {
        ProfileResponse profileResponse = ProfileResponse.fromJson(value.data);
        userProfile = profileResponse.profile;
        user = profileResponse.user;
        if (userProfile != null && user != null) {
          getUserProfileLoading = false;
          emit(GetUserProfileSuccessState(userProfile: userProfile));
        }
      });
    } on DioError catch (e) {
      if (e.type.name == 'other') {
        emit(GetUserProfileErrorState(error: LocaleKeys.chek_internet.tr()));
        getUserProfileErrorConnection = true;
      } else if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        emit(GetUserProfileErrorState(error: LocaleKeys.chek_internet.tr()));
        getUserProfileErrorConnection = true;
      } else {
        getUserProfileErrorConnection = true;
        emit(GetUserProfileErrorState(error: LocaleKeys.ops.tr()));
      }
    } catch (e) {
      getUserProfileErrorConnection = true;
      emit(GetUserProfileErrorState(error: LocaleKeys.ops.tr()));
    }
  }

  bool getSettingsLoading = true;
  bool getSettingsErrorConnection = false;
  Settings? settings;

  void getSettings() async {
    getSettingsLoading = true;
    getSettingsErrorConnection = false;
    userProfile = null;
    user = null;
    try {
      emit(GetSettingsLoadingState());
      await API().getData(endPoint: EndPoints.getSettings).then((value) {
        settings = Settings.fromJson(value.data['settings']);
        getSettingsLoading = false;
        emit(GetSettingsSuccessState(settings: settings));
      });
    } on DioError catch (e) {
      if (e.type.name == 'other') {
        emit(GetSettingsErrorState(error: LocaleKeys.chek_internet.tr()));
        getSettingsErrorConnection = true;
      } else if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        emit(GetSettingsErrorState(error: LocaleKeys.chek_internet.tr()));
        getSettingsErrorConnection = true;
      } else {
        getSettingsErrorConnection = true;
        emit(GetSettingsErrorState(error: LocaleKeys.ops.tr()));
      }
    } catch (e) {
      getSettingsErrorConnection = true;
      emit(GetSettingsErrorState(error: LocaleKeys.ops.tr()));
    }
  }

  TextEditingController? email = TextEditingController();
  TextEditingController? password = TextEditingController();
  bool showPassword = false;

  void showOrHidePassword() {
    showPassword = !showPassword;
    emit(ChangePasswordVisibilityState());
  }

  void fillForTest(String e, pass) {
    email = TextEditingController(text: e.toString());
    password = TextEditingController(text: pass.toString());
    emit(ForTest());
  }

  login() async {
    try {
      isLoginLoading = true;
      emit(LoginLoadingState());
      await API().postData(endPoint: EndPoints.login, data: {
        'username': email!.text,
        'password': password!.text,
        'user_token': SharedPrefHelper.getCurrentMFCToken()
      }).then((value) async {
        isLoginLoading = false;
        if (value.data["status"] == "425") {
          emit(LoginDioErrorState(error: value.data["message"]));
        } else {
          var userResponse = LoginResponse.fromJson(value.data);
          token = userResponse.token.toString();
          await SharedPrefHelper.saveUserToken(
                  token: userResponse.token.toString())
              .then((value) {
            print(SharedPrefHelper.getUserToken());
            emit(LoginSuccessState());
          });
        }
      });
    } on DioError catch (e) {
      if (e.type.name == 'other') {
        emit(LoginDioErrorState(error: LocaleKeys.chek_internet.tr()));
        isLoginLoading = false;
      } else if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        emit((LoginErrorState(error: LocaleKeys.no_internet.tr())));
        isLoginLoading = false;
      } else {
        isLoginLoading = false;
        emit(LoginDioErrorState(error: e.response!.data['error']));
      }
    } catch (e) {
      isLoginLoading = false;
      print(e);
      emit((LoginErrorState(error: 'Please try again')));
    }
  }

  ImagePicker imagePicker = ImagePicker();
  XFile? image;

  void selectProfileImage() async {
    final XFile? selectedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      image = selectedImage;
      emit(ProfileImageLoadedState());
    }
  } //end of selectImages

  void deleteSelectedImage() {
    image = null;
    emit(RemoveSelectedImageState());
  } //end of deleteSelectedImage

  bool updateProfileLoading = false;

  void updateProfile({required String phone, telegram}) async {
    print('data from Api : ${userProfile!.telegramUsername}');
    print('data from Text : $telegram');
    if ((phone == userProfile!.phoneNumber) &&
        (telegram == userProfile!.telegramUsername) &&
        image == null) {
      //||userProfile!.telegramUsername==null
      //||userProfile!.phoneNumber==null
      emit(NoChangesHappened());
      print('no changes ');
    } else {
      updateProfileLoading = true;
      emit(UpdateProfileLoadingState());
      try {
        await API().postData(endPoint: EndPoints.updateProfile, data: {
          'phone_number': phone,
          'telegram_username': telegram,
          'user_token': SharedPrefHelper.getCurrentMFCToken()
        }).then((value) {
          print(value.data['message']);
          if (image != null) {
            uploadImageProfile();
          } else {
            updateProfileLoading = false;
            emit(UpdateProfileSuccessState(message: value.data['message']));
          }
        });
      } on DioError catch (e) {
        updateProfileLoading = false;
        emit(UpdateProfileErrorState(LocaleKeys.ops.tr()));
      } catch (e) {
        updateProfileLoading = false;
        emit(UpdateProfileErrorState(LocaleKeys.ops.tr()));
      }
    }
  } //end of updateProfile

  void uploadImageProfile() async {
    emit(UploadImageLoadingState());
    var multipartFile =
        await MultipartFile.fromFile(image!.path, filename: image!.name);
    try {
      await API().postData(endPoint: EndPoints.upLoadImageProfile, data: {
        'image': multipartFile,
        'user_token': SharedPrefHelper.getCurrentMFCToken()
      }).then((value) {
        emit(UploadImageSuccessState());
        updateProfileLoading = false;
        emit(UpdateProfileSuccessState(message: 'profile Updated'));
      });
    } on DioError catch (e) {

      updateProfileLoading = false;
      emit(UploadImageErrorState(LocaleKeys.ops.tr()));
    } catch (e) {
      updateProfileLoading = false;
      emit(UploadImageErrorState(LocaleKeys.ops.tr()));
    }
  } //end of uploadImageProfile
}
