sealed class WeatherException implements Exception {
  final String message;
  const WeatherException(this.message);
}

class NetworkException extends WeatherException {
  const NetworkException()
      : super('Sin conexión a internet. Verifica tu red.');
}

class TimeoutException extends WeatherException {
  const TimeoutException()
      : super('La petición tardó demasiado. Intenta de nuevo.');
}

class ApiKeyException extends WeatherException {
  const ApiKeyException()
      : super('API Key inválida o no activada. Revisa tu clave.');
}

class CityNotFoundException extends WeatherException {
  final String city;
  const CityNotFoundException(this.city)
      : super('No se encontró la ciudad "$city".');
}

class ServerException extends WeatherException {
  final int statusCode;
  const ServerException(this.statusCode)
      : super('Error del servidor ($statusCode).');
}