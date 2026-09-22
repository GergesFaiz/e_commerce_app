import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../utils/app_constants.dart';
import '../utils/cache_helper.dart';

class DioFactory {
  static Dio getDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = CacheHelper.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['token'] = token;
          }
          handler.next(options);
        },
        onError: (error, handler) {
          // Unauthorized -> clear local session so router guard kicks in.
          if (error.response?.statusCode == 401) {
            unawaited(CacheHelper.removeToken());
          }
          handler.next(error);
        },
      ),
    );

    // Log only in debug builds to avoid leaking tokens in release.
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }

    return dio;
  }
}
