import 'package:dio/dio.dart';

class AuthRemoteDatasource {
  final Dio _dio;

  // Usamos reqres.in para autenticación de prueba
  static const _baseUrl = 'https://reqres.in/api';

  AuthRemoteDatasource(this._dio);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dio.post(
      '$_baseUrl/login',
      data: {'email': email, 'password': password},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    final response = await _dio.post(
      '$_baseUrl/register',
      data: {'email': email, 'password': password},
    );
    return response.data as Map<String, dynamic>;
  }
}