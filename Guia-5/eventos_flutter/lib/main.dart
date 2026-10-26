import 'package:flutter/material.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventos e Interactividad',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MenuPrincipal(),
    );
  }
}

// ======================================================
// MENÚ PRINCIPAL
// ======================================================
class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Práctica 05 - Eventos'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),
          const Text('Ejercicios Básicos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _item(context, 'B1. Cambiar color de fondo', const EjercicioColorFondo()),
          _item(context, 'B2. Contador + y -', const EjercicioContadorMasMenos()),
          _item(context, 'B3. Capturar texto y mostrarlo', const EjercicioMostrarTexto()),

          const SizedBox(height: 20),
          const Text('Ejercicios Intermedios', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _item(context, 'I1. Formulario nombre + edad', const EjercicioFormularioNombreEdad()),
          _item(context, 'I2. Switch encendido/apagado', const EjercicioSwitch()),
          _item(context, 'I3. Detectar doble clic', const EjercicioDobleClic()),

          const SizedBox(height: 20),
          const Text('Ejercicios Avanzados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _item(context, 'A1. Lista dinámica', const EjercicioListaDinamica()),
          _item(context, 'A2. Validación de formulario', const EjercicioValidacion()),
          _item(context, 'A3. Juego: Contador de taps', const EjercicioJuegoTaps()),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String titulo, Widget pantalla) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(titulo),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => pantalla)),
      ),
    );
  }
}

// ======================================================
// EJERCICIO BÁSICO 1: Cambiar color de fondo
// ======================================================
class EjercicioColorFondo extends StatefulWidget {
  const EjercicioColorFondo({super.key});

  @override
  State<EjercicioColorFondo> createState() => _EjercicioColorFondoState();
}

class _EjercicioColorFondoState extends State<EjercicioColorFondo> {
  Color colorFondo = Colors.white;

  final List<Color> colores = [
    Colors.red.shade200,
    Colors.blue.shade200,
    Colors.green.shade200,
    Colors.orange.shade200,
    Colors.purple.shade200,
    Colors.white,
  ];

  int indice = 0;

  void cambiarColor() {
    setState(() {
      indice = (indice + 1) % colores.length;
      colorFondo = colores[indice];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(title: const Text('B1 - Cambiar color de fondo')),
      body: Center(
        child: ElevatedButton(
          onPressed: cambiarColor,
          child: const Text('Cambiar color de fondo'),
        ),
      ),
    );
  }
}

// ======================================================
// EJERCICIO BÁSICO 2: Contador + y -
// ======================================================
class EjercicioContadorMasMenos extends StatefulWidget {
  const EjercicioContadorMasMenos({super.key});

  @override
  State<EjercicioContadorMasMenos> createState() => _EjercicioContadorMasMenosState();
}

class _EjercicioContadorMasMenosState extends State<EjercicioContadorMasMenos> {
  int contador = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('B2 - Contador + y -')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$contador', style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => contador--),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('-', style: TextStyle(fontSize: 30, color: Colors.white)),
                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: () => setState(() => contador++),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('+', style: TextStyle(fontSize: 30, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// EJERCICIO BÁSICO 3: Capturar texto y mostrarlo
// ======================================================
class EjercicioMostrarTexto extends StatefulWidget {
  const EjercicioMostrarTexto({super.key});

  @override
  State<EjercicioMostrarTexto> createState() => _EjercicioMostrarTextoState();
}

class _EjercicioMostrarTextoState extends State<EjercicioMostrarTexto> {
  String texto = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('B3 - Capturar texto')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Escribe aquí',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => texto = value),
            ),
            const SizedBox(height: 30),
            Text(
              texto.isEmpty ? 'Nada escrito aún' : 'Escribiste: $texto',
              style: const TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// EJERCICIO INTERMEDIO 1: Formulario nombre + edad
// ======================================================
class EjercicioFormularioNombreEdad extends StatefulWidget {
  const EjercicioFormularioNombreEdad({super.key});

  @override
  State<EjercicioFormularioNombreEdad> createState() => _EjercicioFormularioNombreEdadState();
}

class _EjercicioFormularioNombreEdadState extends State<EjercicioFormularioNombreEdad> {
  String nombre = '';
  String edad = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('I1 - Nombre y Edad')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder()),
              onChanged: (v) => setState(() => nombre = v),
            ),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Edad', border: OutlineInputBorder()),
              onChanged: (v) => setState(() => edad = v),
            ),
            const SizedBox(height: 30),
            if (nombre.isNotEmpty || edad.isNotEmpty)
              Text(
                'Hola $nombre, tienes $edad años',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// EJERCICIO INTERMEDIO 2: Switch
// ======================================================
class EjercicioSwitch extends StatefulWidget {
  const EjercicioSwitch({super.key});

  @override
  State<EjercicioSwitch> createState() => _EjercicioSwitchState();
}

class _EjercicioSwitchState extends State<EjercicioSwitch> {
  bool encendido = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('I2 - Switch')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              encendido ? Icons.lightbulb : Icons.lightbulb_outline,
              size: 100,
              color: encendido ? Colors.amber : Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              encendido ? 'ENCENDIDO' : 'APAGADO',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: encendido ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 30),
            Switch(
              value: encendido,
              onChanged: (valor) {
                setState(() => encendido = valor);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// EJERCICIO INTERMEDIO 3: Detectar doble clic
// ======================================================
class EjercicioDobleClic extends StatefulWidget {
  const EjercicioDobleClic({super.key});

  @override
  State<EjercicioDobleClic> createState() => _EjercicioDobleClicState();
}

class _EjercicioDobleClicState extends State<EjercicioDobleClic> {
  int contadorDoble = 0;
  Color color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('I3 - Doble clic')),
      body: Center(
        child: GestureDetector(
          onDoubleTap: () {
            setState(() {
              contadorDoble++;
              color = color == Colors.blue ? Colors.orange : Colors.blue;
            });
          },
          child: Container(
            width: 200,
            height: 200,
            color: color,
            alignment: Alignment.center,
            child: Text(
              'Doble taps: $contadorDoble\n(Toca dos veces)',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

// ======================================================
// EJERCICIO AVANZADO 1: Lista dinámica
// ======================================================
class EjercicioListaDinamica extends StatefulWidget {
  const EjercicioListaDinamica({super.key});

  @override
  State<EjercicioListaDinamica> createState() => _EjercicioListaDinamicaState();
}

class _EjercicioListaDinamicaState extends State<EjercicioListaDinamica> {
  final List<String> items = [];
  final controlador = TextEditingController();

  void agregar() {
    if (controlador.text.trim().isEmpty) return;
    setState(() {
      items.add(controlador.text.trim());
      controlador.clear();
    });
  }

  @override
  void dispose() {
    controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('A1 - Lista dinámica')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controlador,
                    decoration: const InputDecoration(
                      labelText: 'Nuevo elemento',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => agregar(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: agregar, child: const Text('Agregar')),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('Lista vacía'))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(child: Text('${index + 1}')),
                        title: Text(items[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() => items.removeAt(index));
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// EJERCICIO AVANZADO 2: Validación de formulario
// ======================================================
class EjercicioValidacion extends StatefulWidget {
  const EjercicioValidacion({super.key});

  @override
  State<EjercicioValidacion> createState() => _EjercicioValidacionState();
}

class _EjercicioValidacionState extends State<EjercicioValidacion> {
  final _formKey = GlobalKey<FormState>();
  final nombreCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  @override
  void dispose() {
    nombreCtrl.dispose();
    emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('A2 - Validación')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  if (value.trim().length < 3) {
                    return 'Mínimo 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Correo', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El correo es obligatorio';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Correo no válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('¡Formulario válido! Hola ${nombreCtrl.text}'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text('Validar y Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================
// EJERCICIO AVANZADO 3: Juego contador de taps
// ======================================================
class EjercicioJuegoTaps extends StatefulWidget {
  const EjercicioJuegoTaps({super.key});

  @override
  State<EjercicioJuegoTaps> createState() => _EjercicioJuegoTapsState();
}

class _EjercicioJuegoTapsState extends State<EjercicioJuegoTaps> {
  int taps = 0;
  int tiempoRestante = 10;
  bool jugando = false;
  bool terminado = false;

  void iniciarJuego() {
    setState(() {
      taps = 0;
      tiempoRestante = 10;
      jugando = true;
      terminado = false;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted || !jugando) return false;

      setState(() {
        tiempoRestante--;
        if (tiempoRestante <= 0) {
          jugando = false;
          terminado = true;
        }
      });
      return tiempoRestante > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('A3 - Juego de Taps')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              terminado ? '¡Tiempo terminado!' : (jugando ? '¡Toca rápido!' : 'Presiona Iniciar'),
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            Text('Taps: $taps', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Tiempo: $tiempoRestante s', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 40),
            if (!jugando)
              ElevatedButton(
                onPressed: iniciarJuego,
                child: Text(terminado ? 'Jugar de nuevo' : 'Iniciar'),
              ),
            if (jugando)
              GestureDetector(
                onTap: () => setState(() => taps++),
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: const Text('¡TAP!', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}