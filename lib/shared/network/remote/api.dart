import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mal/services/navigation_service.dart';
import 'package:mal/shared/components/app_routes.dart';

import '../local/shared_preferences.dart';
import 'end_points.dart';

class API {
  late Dio dio;
  String? token;

  static final API _instance = API._();

  factory API() => _instance;

  API._() {
    dio = Dio(BaseOptions(
        baseUrl: EndPoints.baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: 60 * 1000,
        receiveTimeout: 60 * 1000,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${SharedPrefHelper.getUserToken() ?? ''}',
          'X-localization': SharedPrefHelper.getCurrentLanguage() == null
              ? 'en'
              : '${SharedPrefHelper.getCurrentLanguage()}'
        }));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          log('${options.method} ${options.path}');
          log('${options.headers}');

          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (e, handler) {
          if(e.response?.statusCode == 425){
            NavigationService.instance.pushNamedAndRemoveUntil(AppRoutes.loginScreenRoute);
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> postData(
      {required String endPoint,
      Map<String, dynamic>? data,
      Map<String, dynamic>? params}) async {
    token = SharedPrefHelper.getUserToken();
    FormData formData = FormData.fromMap(data ?? {});
    return dio.post(endPoint,
        data: formData,
        queryParameters: params,
        options: Options(headers: {
          'Authorization': 'Bearer ${SharedPrefHelper.getUserToken() ?? ''}',
          'X-localization': SharedPrefHelper.getCurrentLanguage() == null
              ? 'en'
              : '${SharedPrefHelper.getCurrentLanguage()}'
        }));
  }

  Future<Response> postDataPure(
      {required String endPoint,
        Map<String, dynamic>? data,
        Map<String, dynamic>? params}) async {
    token = SharedPrefHelper.getUserToken();
    return dio.post(endPoint,
        data: data,
        queryParameters: params,
        options: Options(headers: {
          'Authorization': 'Bearer ${SharedPrefHelper.getUserToken() ?? ''}',
          'X-localization': SharedPrefHelper.getCurrentLanguage() == null
              ? 'en'
              : '${SharedPrefHelper.getCurrentLanguage()}'
        }));
  }

  Future<Response> getData({required String endPoint}) async {
    return dio.get(endPoint,
        options: Options(headers: {
          'Authorization': 'Bearer ${SharedPrefHelper.getUserToken() ?? ''}',
          'X-localization': SharedPrefHelper.getCurrentLanguage() == null
              ? 'en'
              : '${SharedPrefHelper.getCurrentLanguage()}'
        }));
  }

  Future<Response> getQueryData(
      {required String endPoint, required Map<String, String> query}) async {
    return dio.get(endPoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${SharedPrefHelper.getUserToken() ?? ''}',
          },
        ),
        queryParameters: query);
  }

  Future<Response> putData({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    token = SharedPrefHelper.getUserToken();

    dio.options.headers = {
      'lang': 'en',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    return await dio.put(
      url,
      queryParameters: query,
      //data: data,
    );
  }

  Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    token = SharedPrefHelper.getUserToken();

    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': 'en',
      'Authorization': 'Bearer $token',
    };
    return await dio.delete(
      url,
      queryParameters: query,
    );
  }
}
