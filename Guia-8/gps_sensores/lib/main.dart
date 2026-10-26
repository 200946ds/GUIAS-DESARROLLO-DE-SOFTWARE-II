import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPS y Sensores',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MenuPage(),
    );
  }
}

// ======================================================
// MENÚ PRINCIPAL
// ======================================================
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Práctica 08 - GPS y Sensores'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _boton(context, '1. GPS - Ubicación actual', const GpsPage()),
          _boton(context, '2. Sensores (Acelerómetro / Giroscopio)', const SensoresPage()),
          _boton(context, '3. Cámara (image_picker)', const CamaraPage()),
        ],
      ),
    );
  }

  Widget _boton(BuildContext context, String texto, Widget pagina) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(texto),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => pagina)),
      ),
    );
  }
}

// ======================================================
// 1. GPS - UBICACIÓN
// ======================================================
class GpsPage extends StatefulWidget {
  const GpsPage({super.key});

  @override
  State<GpsPage> createState() => _GpsPageState();
}

class _GpsPageState extends State<GpsPage> {
  Position? _posicion;
  String _estado = 'Presiona el botón para obtener ubicación';
  StreamSubscription<Position>? _stream;
  bool _rastreando = false;
  final List<Position> _ruta = [];

  Future<bool> _verificarPermisos() async {
    bool servicio = await Geolocator.isLocationServiceEnabled();
    if (!servicio) {
      setState(() => _estado = 'El GPS está desactivado');
      return false;
    }

    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        setState(() => _estado = 'Permiso denegado');
        return false;
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      setState(() => _estado = 'Permiso denegado permanentemente. Ve a Ajustes.');
      return false;
    }
    return true;
  }

  Future<void> _obtenerUbicacion() async {
    if (!await _verificarPermisos()) return;

    setState(() => _estado = 'Obteniendo ubicación...');

    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _posicion = pos;
        _estado = 'Ubicación obtenida';
      });
    } catch (e) {
      setState(() => _estado = 'Error: $e');
    }
  }

  void _toggleRastreo() async {
    if (_rastreando) {
      await _stream?.cancel();
      setState(() {
        _rastreando = false;
        _estado = 'Rastreo detenido. Puntos: ${_ruta.length}';
      });
    } else {
      if (!await _verificarPermisos()) return;

      _ruta.clear();
      _stream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5, // metros
        ),
      ).listen((pos) {
        setState(() {
          _posicion = pos;
          _ruta.add(pos);
          _estado = 'Rastreando... (${_ruta.length} puntos)';
        });
      });

      setState(() => _rastreando = true);
    }
  }

  @override
  void dispose() {
    _stream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GPS - Ubicación')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_estado, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            if (_posicion != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Latitud: ${_posicion!.latitude.toStringAsFixed(6)}'),
                      Text('Longitud: ${_posicion!.longitude.toStringAsFixed(6)}'),
                      Text('Precisión: ${_posicion!.accuracy.toStringAsFixed(1)} m'),
                      Text('Altitud: ${_posicion!.altitude.toStringAsFixed(1)} m'),
                      if (_ruta.length >= 2)
                        Text(
                          'Distancia recorrida: ${_calcularDistancia().toStringAsFixed(1)} m',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
              ),
            ],

            const Spacer(),

            ElevatedButton.icon(
              onPressed: _obtenerUbicacion,
              icon: const Icon(Icons.my_location),
              label: const Text('Obtener ubicación actual'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _toggleRastreo,
              style: ElevatedButton.styleFrom(
                backgroundColor: _rastreando ? Colors.red : Colors.teal,
                foregroundColor: Colors.white,
              ),
              icon: Icon(_rastreando ? Icons.stop : Icons.play_arrow),
              label: Text(_rastreando ? 'Detener rastreo' : 'Iniciar rastreo'),
            ),
          ],
        ),
      ),
    );
  }

  double _calcularDistancia() {
    double total = 0;
    for (int i = 1; i < _ruta.length; i++) {
      total += Geolocator.distanceBetween(
        _ruta[i - 1].latitude,
        _ruta[i - 1].longitude,
        _ruta[i].latitude,
        _ruta[i].longitude,
      );
    }
    return total;
  }
}

// ======================================================
// 2. SENSORES
// ======================================================
class SensoresPage extends StatefulWidget {
  const SensoresPage({super.key});

  @override
  State<SensoresPage> createState() => _SensoresPageState();
}

class _SensoresPageState extends State<SensoresPage> {
  AccelerometerEvent? _accel;
  GyroscopeEvent? _gyro;
  UserAccelerometerEvent? _userAccel;
  bool _agitado = false;

  final List<StreamSubscription> _subs = [];

  @override
  void initState() {
    super.initState();

    _subs.add(accelerometerEventStream().listen((e) {
      setState(() => _accel = e);
    }));

    _subs.add(gyroscopeEventStream().listen((e) {
      setState(() => _gyro = e);
    }));

    _subs.add(userAccelerometerEventStream().listen((e) {
      setState(() {
        _userAccel = e;
        // Detección de agitación
        final magnitud = sqrt(e.x * e.x + e.y * e.y + e.z * e.z);
        if (magnitud > 15) {
          _agitado = true;
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) setState(() => _agitado = false);
          });
        }
      });
    }));
  }

  @override
  void dispose() {
    for (var s in _subs) {
      s.cancel();
    }
    super.dispose();
  }

  String _fmt(double? v) => v?.toStringAsFixed(2) ?? '-';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sensores de Movimiento')),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: _agitado ? Colors.red.shade100 : null,
        child: ListView(
          children: [
            if (_agitado)
              const ListTile(
                leading: Icon(Icons.vibration, color: Colors.red),
                title: Text(
                  '¡AGITAMIENTO DETECTADO!',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ListTile(
              leading: const Icon(Icons.sensors),
              title: const Text('Acelerómetro (con gravedad)'),
              subtitle: Text('X: ${_fmt(_accel?.x)}  Y: ${_fmt(_accel?.y)}  Z: ${_fmt(_accel?.z)}'),
            ),
            ListTile(
              leading: const Icon(Icons.directions_walk),
              title: const Text('Movimiento (sin gravedad)'),
              subtitle: Text('X: ${_fmt(_userAccel?.x)}  Y: ${_fmt(_userAccel?.y)}  Z: ${_fmt(_userAccel?.z)}'),
            ),
            ListTile(
              leading: const Icon(Icons.rotate_right),
              title: const Text('Giroscopio (rad/s)'),
              subtitle: Text('X: ${_fmt(_gyro?.x)}  Y: ${_fmt(_gyro?.y)}  Z: ${_fmt(_gyro?.z)}'),
            ),
            if (_accel != null)
              ListTile(
                leading: const Icon(Icons.straighten),
                title: const Text('Inclinación aproximada'),
                subtitle: Text(
                  '${(atan2(_accel!.y, sqrt(_accel!.x * _accel!.x + _accel!.z * _accel!.z)) * 180 / pi).toStringAsFixed(1)}°',
                ),
              ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Agita el dispositivo para probar la detección de movimiento.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// 3. CÁMARA (simple con image_picker)
// ======================================================
class CamaraPage extends StatefulWidget {
  const CamaraPage({super.key});

  @override
  State<CamaraPage> createState() => _CamaraPageState();
}

class _CamaraPageState extends State<CamaraPage> {
  File? _imagen;
  final _picker = ImagePicker();

  Future<void> _tomarFoto() async {
    final XFile? foto = await _picker.pickImage(source: ImageSource.camera);
    if (foto != null) {
      setState(() => _imagen = File(foto.path));
    }
  }

  Future<void> _elegirGaleria() async {
    final XFile? foto = await _picker.pickImage(source: ImageSource.gallery);
    if (foto != null) {
      setState(() => _imagen = File(foto.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cámara')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imagen != null)
              Image.file(_imagen!, height: 300, fit: BoxFit.cover)
            else
              const Icon(Icons.camera_alt, size: 100, color: Colors.grey),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _tomarFoto,
              icon: const Icon(Icons.camera),
              label: const Text('Tomar foto'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _elegirGaleria,
              icon: const Icon(Icons.photo_library),
              label: const Text('Elegir de galería'),
            ),
          ],
        ),
      ),
    );
  }
}