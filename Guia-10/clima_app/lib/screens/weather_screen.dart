import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../exceptions/weather_exceptions.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

enum WeatherUiState { initial, loading, success, error, empty }

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _service = WeatherService();
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  WeatherUiState _state = WeatherUiState.initial;
  Weather? _weather;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLastCity();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCity = prefs.getString('last_city');
    if (lastCity != null && lastCity.isNotEmpty) {
      _controller.text = lastCity;
      _searchWeather(lastCity);
    }
  }

  Future<void> _saveLastCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_city', city);
  }

  Future<void> _searchWeather(String city) async {
    if (city.trim().length < 3) return;

    setState(() {
      _state = WeatherUiState.loading;
      _errorMessage = null;
      _weather = null;
    });

    try {
      final weather = await _service.getWeather(city.trim());
      await _saveLastCity(city.trim());

      setState(() {
        _weather = weather;
        _state = WeatherUiState.success;
      });
    } on WeatherException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _state = WeatherUiState.error;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error inesperado. Intenta de nuevo.';
        _state = WeatherUiState.error;
      });
    }
  }

  void _onSearch() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      _searchWeather(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Campo de búsqueda
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Ciudad',
                        hintText: 'Ej: Cusco, Lima, Arequipa',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_city),
                      ),
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (_) => _onSearch(),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingresa una ciudad';
                        }
                        if (value.trim().length < 3) {
                          return 'Mínimo 3 caracteres';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _state == WeatherUiState.loading
                        ? null
                        : _onSearch,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                    ),
                    child: const Icon(Icons.search),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Contenido según el estado
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return switch (_state) {
      WeatherUiState.initial => const Center(
          child: Text(
            'Busca una ciudad para ver el clima',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      WeatherUiState.loading => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Obteniendo clima...'),
            ],
          ),
        ),
      WeatherUiState.empty => const Center(
          child: Text('No hay datos para mostrar'),
        ),
      WeatherUiState.error => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  _errorMessage ?? 'Error desconocido',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _searchWeather(_controller.text),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      WeatherUiState.success => _buildSuccess(),
    };
  }

  Widget _buildSuccess() {
    final w = _weather!;
    return SingleChildScrollView(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                '${w.cityName}, ${w.country}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Image.network(
                w.iconUrl,
                width: 100,
                height: 100,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.wb_sunny, size: 80),
              ),
              Text(
                '${w.temperature.toStringAsFixed(1)}°C',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                w.description,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),
              _infoRow(Icons.thermostat, 'Sensación',
                  '${w.feelsLike.toStringAsFixed(1)}°C'),
              _infoRow(Icons.water_drop, 'Humedad', '${w.humidity}%'),
              _infoRow(Icons.air, 'Viento',
                  '${w.windSpeed.toStringAsFixed(1)} m/s'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}