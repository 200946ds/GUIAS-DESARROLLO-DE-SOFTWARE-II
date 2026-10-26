import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive & Accesible',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MenuPrincipal(),
    );
  }
}

// ======================
// CLASE DE BREAKPOINTS
// ======================
class Breakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double wide = 1440;

  static bool isMobile(BuildContext ctx) =>
      MediaQuery.sizeOf(ctx).width < mobile;

  static bool isTablet(BuildContext ctx) {
    final w = MediaQuery.sizeOf(ctx).width;
    return w >= mobile && w < desktop;
  }

  static bool isDesktop(BuildContext ctx) =>
      MediaQuery.sizeOf(ctx).width >= desktop;
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
        title: const Text('Práctica 06 - Responsive & Accesible'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('1. Diseño Responsivo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _item(context, 'LayoutBuilder (móvil vs tablet)', const DemoLayoutBuilder()),
          _item(context, 'MediaQuery + FractionallySizedBox', const DemoMediaQuery()),
          _item(context, 'Flexible y Expanded', const DemoFlexibleExpanded()),
          _item(context, 'Grid adaptable', const DemoAdaptiveGrid()),
          _item(context, 'Navegación adaptable (Rail / Bottom)', const DemoNavigationAdaptativa()),

          const SizedBox(height: 20),
          const Text('2. Accesibilidad', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _item(context, 'Texto escalable', const DemoTextoEscalable()),
          _item(context, 'Touch Targets (mínimo 44px)', const DemoTouchTargets()),
          _item(context, 'Semantics + MergeSemantics', const DemoSemantics()),
          _item(context, 'Anuncios dinámicos', const DemoAnuncios()),
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
// DEMO 1: LayoutBuilder
// ======================================================
class DemoLayoutBuilder extends StatelessWidget {
  const DemoLayoutBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LayoutBuilder')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final esAncho = constraints.maxWidth > 600;

          return Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: esAncho
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _caja('Izquierda', Colors.blue),
                        const SizedBox(width: 20),
                        _caja('Derecha', Colors.green),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _caja('Arriba', Colors.blue),
                        const SizedBox(height: 20),
                        _caja('Abajo', Colors.green),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _caja(String texto, Color color) {
    return Container(
      width: 150,
      height: 100,
      color: color,
      alignment: Alignment.center,
      child: Text(texto, style: const TextStyle(color: Colors.white, fontSize: 18)),
    );
  }
}

// ======================================================
// DEMO 2: MediaQuery + FractionallySizedBox
// ======================================================
class DemoMediaQuery extends StatelessWidget {
  const DemoMediaQuery({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final orientacion = MediaQuery.orientationOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);

    return Scaffold(
      appBar: AppBar(title: const Text('MediaQuery')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ancho: ${size.width.toStringAsFixed(0)} px'),
            Text('Alto: ${size.height.toStringAsFixed(0)} px'),
            Text('Orientación: $orientacion'),
            Text('Text Scale: ${textScale.toStringAsFixed(2)}'),
            const SizedBox(height: 30),
            const Text('FractionallySizedBox (80% del ancho):'),
            const SizedBox(height: 10),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Botón 80% del ancho'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// DEMO 3: Flexible y Expanded
// ======================================================
class DemoFlexibleExpanded extends StatelessWidget {
  const DemoFlexibleExpanded({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flexible & Expanded')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Expanded (flex: 2 y flex: 1)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 60,
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: const Text('2/3', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 60,
                    color: Colors.orange,
                    alignment: Alignment.center,
                    child: const Text('1/3', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Flexible vs Expanded', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  child: Container(
                    height: 60,
                    color: Colors.purple,
                    alignment: Alignment.center,
                    child: const Text('Flexible', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 60,
                    color: Colors.teal,
                    alignment: Alignment.center,
                    child: const Text('Expanded', style: TextStyle(color: Colors.white)),
                  ),
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
// DEMO 4: Grid adaptable
// ======================================================
class DemoAdaptiveGrid extends StatelessWidget {
  const DemoAdaptiveGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(12, (i) => 'Item ${i + 1}');

    return Scaffold(
      appBar: AppBar(title: const Text('Grid Adaptable')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Calcula columnas según el ancho disponible
          final cols = (constraints.maxWidth / 160).floor().clamp(1, 4);

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.indigo.shade100,
                child: Center(
                  child: Text(
                    items[index],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ======================================================
// DEMO 5: Navegación adaptable (NavigationRail / BottomNav)
// ======================================================
class DemoNavigationAdaptativa extends StatefulWidget {
  const DemoNavigationAdaptativa({super.key});

  @override
  State<DemoNavigationAdaptativa> createState() => _DemoNavigationAdaptativaState();
}

class _DemoNavigationAdaptativaState extends State<DemoNavigationAdaptativa> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text('Inicio', style: TextStyle(fontSize: 28))),
    const Center(child: Text('Buscar', style: TextStyle(fontSize: 28))),
    const Center(child: Text('Perfil', style: TextStyle(fontSize: 28))),
  ];

  @override
  Widget build(BuildContext context) {
    final esDesktop = Breakpoints.isDesktop(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Navegación Adaptativa')),
      body: Row(
        children: [
          // NavigationRail solo en pantallas grandes
          if (esDesktop)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (i) => setState(() => _selectedIndex = i),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.home), label: Text('Inicio')),
                NavigationRailDestination(icon: Icon(Icons.search), label: Text('Buscar')),
                NavigationRailDestination(icon: Icon(Icons.person), label: Text('Perfil')),
              ],
            ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
      // BottomNavigationBar solo en móvil
      bottomNavigationBar: Breakpoints.isMobile(context)
          ? BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (i) => setState(() => _selectedIndex = i),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
              ],
            )
          : null,
    );
  }
}

// ======================================================
// DEMO 6: Texto escalable
// ======================================================
class DemoTextoEscalable extends StatelessWidget {
  const DemoTextoEscalable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Texto Escalable')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Este texto respeta la escala del sistema.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ve a Ajustes del emulador → Accesibilidad → Tamaño de fuente y cámbialo. '
              'Este texto crecerá automáticamente.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// DEMO 7: Touch Targets (mínimo 44-48 px)
// ======================================================
class DemoTouchTargets extends StatelessWidget {
  const DemoTouchTargets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Touch Targets')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'El icono puede ser pequeño, pero el área de toque debe ser ≥ 44-48 px.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Forma correcta
            const Text('✅ Correcto (área 48x48)'),
            const SizedBox(height: 10),
            SizedBox(
              width: 48,
              height: 48,
              child: IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('¡Área de toque correcta!')),
                  );
                },
                icon: const Icon(Icons.favorite, size: 24, color: Colors.red),
              ),
            ),

            const SizedBox(height: 40),

            // Forma incorrecta (solo para mostrar)
            const Text('❌ Incorrecto (área muy pequeña)'),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {},
              child: const Icon(Icons.favorite, size: 24, color: Colors.grey),
            ),
            const Text('(Difícil de tocar)', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// DEMO 8: Semantics + MergeSemantics
// ======================================================
class DemoSemantics extends StatefulWidget {
  const DemoSemantics({super.key});

  @override
  State<DemoSemantics> createState() => _DemoSemanticsState();
}

class _DemoSemanticsState extends State<DemoSemantics> {
  bool recordarme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Semantics')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Semantics para un widget sin texto
            Semantics(
              label: 'Foto de perfil de María García',
              hint: 'Doble toque para cambiar la foto',
              button: true,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cambiar foto')),
                  );
                },
                child: const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.indigo,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text('↑ Este avatar tiene etiqueta semántica'),

            const SizedBox(height: 40),

            // MergeSemantics
            const Text('MergeSemantics (checkbox + texto):'),
            const SizedBox(height: 10),
            MergeSemantics(
              child: Row(
                children: [
                  Checkbox(
                    value: recordarme,
                    onChanged: (v) => setState(() => recordarme = v!),
                  ),
                  const Text('Recordar contraseña'),
                ],
              ),
            ),
            const Text(
              'El lector de pantalla lee todo junto.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // ExcludeSemantics para iconos decorativos
            Row(
              children: [
                ExcludeSemantics(
                  child: Icon(Icons.star, color: Colors.amber.shade600),
                ),
                const SizedBox(width: 8),
                const Text('Icono decorativo (excluido de semántica)'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// DEMO 9: Anuncios dinámicos
// ======================================================
class DemoAnuncios extends StatefulWidget {
  const DemoAnuncios({super.key});

  @override
  State<DemoAnuncios> createState() => _DemoAnunciosState();
}

class _DemoAnunciosState extends State<DemoAnuncios> {
  int contador = 0;
  bool cargando = false;

  void agregarAlCarrito() {
    setState(() => contador++);

    // Anuncio para lectores de pantalla
    SemanticsService.announce(
      'Producto añadido al carrito. Total: $contador',
      TextDirection.ltr,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Añadido. Total: $contador')),
    );
  }

  void simularCarga() async {
    setState(() => cargando = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anuncios Dinámicos')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Productos en carrito: $contador', style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: agregarAlCarrito,
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Añadir al carrito'),
            ),
            const SizedBox(height: 40),

            // liveRegion
            Semantics(
              liveRegion: true,
              child: cargando
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 16),
                        Text('Cargando...'),
                      ],
                    )
                  : const Text('Listo', style: TextStyle(fontSize: 18, color: Colors.green)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: simularCarga,
              child: const Text('Simular carga'),
            ),
          ],
        ),
      ),
    );
  }
}