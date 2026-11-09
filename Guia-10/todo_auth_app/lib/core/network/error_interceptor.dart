import 'package:dio/dio.dart';
import '../exceptions/api_exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout =>
        const NetworkException(),
      DioExceptionType.connectionError => const NetworkException(),
      DioExceptionType.badResponse => _mapStatusCode(err.response?.statusCode),
      _ => ServerException(err.response?.statusCode ?? 0, err.message),
    };

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        response: err.response,
        type: err.type,
      ),
    );
  }

  ApiException _mapStatusCode(int? code) {
    return switch (code) {
      401 || 403 => const UnauthorizedException(),
      404 => const ServerException(404, 'Recurso no encontrado.'),
      422 => const ValidationException('Datos inválidos.'),
      _ => ServerException(code ?? 0),
    };
  }
}