import 'package:flutter/material.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Calculadora(),
    );
  }
}

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String _display = '0';          // Lo que se muestra en pantalla
  String _operacion = '';         // +, -, ×, ÷
  double _primerNumero = 0;       // Primer operando
  bool _nuevoNumero = true;       // Indica si el siguiente dígito empieza un número nuevo

  // Color del display según el valor
  Color get _colorDisplay {
    final valor = double.tryParse(_display) ?? 0;
    if (valor == 0) return Colors.grey.shade700;
    if (valor < 0) return Colors.red.shade600;
    return Colors.blue.shade800;
  }

  void _presionarDigito(String digito) {
    setState(() {
      if (_nuevoNumero) {
        _display = digito;
        _nuevoNumero = false;
      } else {
        // Evitar múltiples ceros a la izquierda
        if (_display == '0' && digito != '.') {
          _display = digito;
        } else {
          _display += digito;
        }
      }
    });
  }

  void _presionarPunto() {
    setState(() {
      if (_nuevoNumero) {
        _display = '0.';
        _nuevoNumero = false;
      } else if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _presionarOperacion(String op) {
    setState(() {
      _primerNumero = double.tryParse(_display) ?? 0;
      _operacion = op;
      _nuevoNumero = true;
    });
  }

  void _calcular() {
    if (_operacion.isEmpty) return;

    setState(() {
      final segundoNumero = double.tryParse(_display) ?? 0;
      double resultado = 0;

      switch (_operacion) {
        case '+':
          resultado = _primerNumero + segundoNumero;
          break;
        case '-':
          resultado = _primerNumero - segundoNumero;
          break;
        case '×':
          resultado = _primerNumero * segundoNumero;
          break;
        case '÷':
          if (segundoNumero == 0) {
            _display = 'Error';
            _operacion = '';
            _nuevoNumero = true;
            return;
          }
          resultado = _primerNumero / segundoNumero;
          break;
      }

      // Formatear el resultado (quitar .0 si es entero)
      if (resultado == resultado.toInt()) {
        _display = resultado.toInt().toString();
      } else {
        _display = resultado.toStringAsFixed(6)
            .replaceAll(RegExp(r'0+$'), '')
            .replaceAll(RegExp(r'\.$'), '');
      }

      _operacion = '';
      _nuevoNumero = true;
    });
  }

  void _limpiar() {
    setState(() {
      _display = '0';
      _operacion = '';
      _primerNumero = 0;
      _nuevoNumero = true;
    });
  }

  // Widget reutilizable para los botones
  Widget _boton(String texto, {Color? color, Color? textoColor, VoidCallback? onPressed}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey.shade200,
            foregroundColor: textoColor ?? Colors.black87,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: Text(
            texto,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora Básica'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            // ========== DISPLAY ==========
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                alignment: Alignment.bottomRight,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: _colorDisplay,
                  ),
                  child: Text(
                    _display,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),

            // ========== BOTONES ==========
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Fila 1: C  ÷  ×  -
                    Row(
                      children: [
                        _boton('C', color: Colors.red.shade400, textoColor: Colors.white, onPressed: _limpiar),
                        _boton('÷', color: Colors.orange.shade400, textoColor: Colors.white, onPressed: () => _presionarOperacion('÷')),
                        _boton('×', color: Colors.orange.shade400, textoColor: Colors.white, onPressed: () => _presionarOperacion('×')),
                        _boton('-', color: Colors.orange.shade400, textoColor: Colors.white, onPressed: () => _presionarOperacion('-')),
                      ],
                    ),
                    // Fila 2: 7  8  9  +
                    Row(
                      children: [
                        _boton('7', onPressed: () => _presionarDigito('7')),
                        _boton('8', onPressed: () => _presionarDigito('8')),
                        _boton('9', onPressed: () => _presionarDigito('9')),
                        _boton('+', color: Colors.orange.shade400, textoColor: Colors.white, onPressed: () => _presionarOperacion('+')),
                      ],
                    ),
                    // Fila 3: 4  5  6
                    Row(
                      children: [
                        _boton('4', onPressed: () => _presionarDigito('4')),
                        _boton('5', onPressed: () => _presionarDigito('5')),
                        _boton('6', onPressed: () => _presionarDigito('6')),
                        // Espacio vacío o puedes poner otro botón
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                    // Fila 4: 1  2  3
                    Row(
                      children: [
                        _boton('1', onPressed: () => _presionarDigito('1')),
                        _boton('2', onPressed: () => _presionarDigito('2')),
                        _boton('3', onPressed: () => _presionarDigito('3')),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                    // Fila 5: 0  .  =
                    Row(
                      children: [
                        _boton('0', onPressed: () => _presionarDigito('0')),
                        _boton('.', onPressed: _presionarPunto),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ElevatedButton(
                              onPressed: _calcular,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: const Text(
                                '=',
                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}