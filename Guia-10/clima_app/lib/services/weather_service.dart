import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../exceptions/weather_exceptions.dart';
import '../models/weather.dart';

class WeatherService {
  Future<Weather> getWeather(String city) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];

    if (apiKey == null || apiKey.isEmpty || apiKey == 'tu_api_key_aqui') {
      throw const ApiKeyException();
    }

    final uri = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather'
      '?q=$city&appid=$apiKey&units=metric&lang=es',
    );

    try {
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 10));

      return switch (response.statusCode) {
        200 => Weather.fromJson(jsonDecode(response.body)),
        401 => throw const ApiKeyException(),
        404 => throw CityNotFoundException(city),
        _ => throw ServerException(response.statusCode),
      };
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const TimeoutException();
    } on FormatException {
      throw const ServerException(0);
    }
  }
}