class Weather {
  final int id;
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final String description;
  final String iconCode;
  final int humidity;
  final double windSpeed;

  const Weather({
    required this.id,
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json['id'] as int,
      cityName: json['name'] as String,
      country: json['sys']['country'] as String,
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      description: (json['weather'][0]['description'] as String),
      iconCode: json['weather'][0]['icon'] as String,
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
    );
  }

  String get iconUrl =>
      'https://openweathermap.org/img/wn/$iconCode@2x.png';
}