/*
import 'package:dio/dio.dart';

import '../local/shared_preferences.dart';


class Api {
  static final dio = Dio(
    BaseOptions(
      baseUrl: 'https://backendmal.simply37.com',
      receiveDataWhenStatusError: true,
    ),
  );

  static void initializeInterceptors() {
    dio.interceptors
        .add(InterceptorsWrapper(
      onRequest: (request, handler) async {
        var headers = {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${SharedPrefHelper.getUserToken() ?? ''}',
          'X-localization':'en'
        };
        request.headers.addAll(headers);
        print('${request.method} ${request.path}');
        print('${request.headers}');
        print('${request.queryParameters}');
        return handler.next(request);
        //continue
      },
      onResponse: (response, handler) {
        print('${response.data}');
        print('${response.data['status']}');
        print(response.requestOptions.queryParameters);
        return handler.next(response);
      }, onError: (error, handler) {
    },));
  }

}*/
