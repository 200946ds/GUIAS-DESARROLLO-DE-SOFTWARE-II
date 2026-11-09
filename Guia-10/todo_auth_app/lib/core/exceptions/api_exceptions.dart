sealed class ApiException implements Exception {
  final String message;
  const ApiException(this.message);
}

class NetworkException extends ApiException {
  const NetworkException() : super('Sin conexión a internet.');
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException() : super('Sesión expirada. Inicia sesión de nuevo.');
}

class ServerException extends ApiException {
  final int statusCode;
  const ServerException(this.statusCode, [String? msg])
      : super(msg ?? 'Error del servidor ($statusCode).');
}

class ValidationException extends ApiException {
  const ValidationException(super.message);
}