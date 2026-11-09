import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_interceptor.dart';
import 'error_interceptor.dart';

class DioFactory {
  static Dio create({required FlutterSecureStorage storage}) {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(storage),
      ErrorInterceptor(),
      LogInterceptor(requestBody: true, responseBody: true), // útil en debug
    ]);

    return dio;
  }
}