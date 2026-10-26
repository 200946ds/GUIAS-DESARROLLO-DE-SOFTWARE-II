import 'package:flutter/material.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guía de Widgets',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MenuPrincipal(), // Pantalla de menú
    );
  }
}

// ===============
// MENÚ PRINCIPAL 
// ===============
class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guía Práctica de Widgets'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _botonMenu(context, '1. Layout básico', const Ejercicio1Layout()),
          _botonMenu(context, '2. Tarjeta de Perfil', const Ejercicio2Tarjeta()),
          _botonMenu(context, '3. Formulario (Input)', const Ejercicio3Formulario()),
          _botonMenu(context, '4. Navegación', const Ejercicio4Navegacion()),
          _botonMenu(context, '5. Feedback (Progress, Dialog, Chip)', const Ejercicio5Feedback()),
        ],
      ),
    );
  }

  Widget _botonMenu(BuildContext context, String titulo, Widget pantalla) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => pantalla),
          );
        },
      ),
    );
  }
}

// ======================================================
// EJERCICIO 1 - Layout básico
// ======================================================
class Ejercicio1Layout extends StatelessWidget {
  const Ejercicio1Layout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejercicio 1 - Layout')),
      body: Center(
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Container + Column + Padding',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Botón de ejemplo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================
// EJERCICIO 2 - Tarjeta de Perfil
// ======================================================
class Ejercicio2Tarjeta extends StatelessWidget {
  const Ejercicio2Tarjeta({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejercicio 2 - Tarjeta')),
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Diego Ninancuro',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Ingeniería Informática',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _estadistica('120', 'Proyectos'),
                    _estadistica('4.8', 'Rating'),
                    _estadistica('5+', 'Años'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _estadistica(String valor, String etiqueta) {
    return Column(
      children: [
        Text(valor, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        Text(etiqueta, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}


// ======================================================
// EJERCICIO 3 - Formulario
// ======================================================
class Ejercicio3Formulario extends StatefulWidget {
  const Ejercicio3Formulario({super.key});

  @override
  State<Ejercicio3Formulario> createState() => _Ejercicio3FormularioState();
}

class _Ejercicio3FormularioState extends State<Ejercicio3Formulario> {
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  bool _aceptoTerminos = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejercicio 3 - Formulario')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _correoController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _aceptoTerminos,
                  onChanged: (valor) {
                    setState(() => _aceptoTerminos = valor!);
                  },
                ),
                const Text('Acepto los términos'),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_aceptoTerminos) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Hola ${_nombreController.text}!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Debes aceptar los términos'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// EJERCICIO 4 - Navegación
// ======================================================
class Ejercicio4Navegacion extends StatelessWidget {
  const Ejercicio4Navegacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejercicio 4 - Pantalla A')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PantallaB()),
            );
          },
          child: const Text('Ir a Pantalla B'),
        ),
      ),
    );
  }
}

class PantallaB extends StatelessWidget {
  const PantallaB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pantalla B')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Volver a Pantalla A'),
        ),
      ),
    );
  }
}

// ======================================================
// EJERCICIO 5 - Feedback
// ======================================================
class Ejercicio5Feedback extends StatefulWidget {
  const Ejercicio5Feedback({super.key});

  @override
  State<Ejercicio5Feedback> createState() => _Ejercicio5FeedbackState();
}

class _Ejercicio5FeedbackState extends State<Ejercicio5Feedback> {
  bool _chipSeleccionado = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejercicio 5 - Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('CircularProgressIndicator:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Confirmar'),
                    content: const Text('¿Estás seguro de continuar?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Aceptar'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Mostrar AlertDialog'),
            ),
            const SizedBox(height: 30),

            const Text('Chip / FilterChip:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: const Text('Flutter'),
                  avatar: const CircleAvatar(child: Text('F')),
                  onDeleted: () {},
                ),
                FilterChip(
                  label: const Text('Dart'),
                  selected: _chipSeleccionado,
                  onSelected: (valor) {
                    setState(() => _chipSeleccionado = valor);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

