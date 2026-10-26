import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formularios y Datos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
        title: const Text('Práctica 07 - Formularios y Datos'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _item(
            context,
            'Ejercicio 1: Registro y Autenticación Avanzado',
            'Validaciones de email, contraseña segura, confirmar contraseña y términos',
            const EjercicioRegistro(),
          ),
          const SizedBox(height: 12),
          _item(
            context,
            'Ejercicio 2: Inventario de Productos (CRUD Local)',
            'Formulario + lista dinámica con agregar y eliminar productos',
            const EjercicioInventario(),
          ),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String titulo, String subtitulo, Widget pantalla) {
    return Card(
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(subtitulo),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => pantalla)),
      ),
    );
  }
}

// ======================================================
// MODELO DE DATOS - USUARIO (Ejercicio 1)
// ======================================================
class Usuario {
  final String email;
  final String password;
  final bool aceptaTerminos;

  Usuario({
    required this.email,
    required this.password,
    required this.aceptaTerminos,
  });
}

// ======================================================
// MODELO DE DATOS - PRODUCTO (Ejercicio 2)
// ======================================================
class Producto {
  final String id;
  final String nombre;
  final int cantidad;
  final double precio;
  final String categoria;

  Producto({
    required this.id,
    required this.nombre,
    required this.cantidad,
    required this.precio,
    required this.categoria,
  });

  double get subtotal => cantidad * precio;
}

// ======================================================
// EJERCICIO 1: Sistema de Registro Avanzado
// ======================================================
class EjercicioRegistro extends StatefulWidget {
  const EjercicioRegistro({super.key});

  @override
  State<EjercicioRegistro> createState() => _EjercicioRegistroState();
}

class _EjercicioRegistroState extends State<EjercicioRegistro> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _aceptaTerminos = false;
  String? _errorTerminos;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Validación de Email (RegEx de la guía)
  String? _validateEmail(String? value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (value == null || value.isEmpty) {
      return 'El correo es obligatorio';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Ingrese un formato de correo electrónico válido';
    }
    return null;
  }

  // Validación de Contraseña Segura (RegEx de la guía)
  String? _validatePassword(String? value) {
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    } else if (!passwordRegex.hasMatch(value)) {
      return 'Mínimo 8 caracteres, mayúscula, minúscula y número';
    }
    return null;
  }

  // Validación de Confirmar Contraseña
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirme su contraseña';
    }
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  void _enviarFormulario() {
    // Validar términos primero
    setState(() {
      _errorTerminos = _aceptaTerminos ? null : 'Debe aceptar los términos y condiciones';
    });

    if (_formKey.currentState!.validate() && _aceptaTerminos) {
      // Ocultar teclado
      FocusScope.of(context).unfocus();

      // Mostrar éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registro exitoso para ${_emailController.text}'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Avanzado'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Crear cuenta',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Campo Correo
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),

              // Campo Contraseña + botón mostrar/ocultar
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                validator: _validatePassword,
              ),
              const SizedBox(height: 16),

              // Campo Confirmar Contraseña
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: 'Confirmar Contraseña',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() => _obscureConfirm = !_obscureConfirm);
                    },
                  ),
                ),
                validator: _validateConfirmPassword,
              ),
              const SizedBox(height: 20),

              // Términos y Condiciones
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _aceptaTerminos,
                    onChanged: (value) {
                      setState(() {
                        _aceptaTerminos = value ?? false;
                        _errorTerminos = null;
                      });
                    },
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text('Acepto los términos y condiciones'),
                    ),
                  ),
                ],
              ),
              if (_errorTerminos != null)
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 8),
                  child: Text(
                    _errorTerminos!,
                    style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 24),

              // Botón Enviar
              ElevatedButton(
                onPressed: _enviarFormulario,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Registrarse', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================
// EJERCICIO 2: Inventario de Productos (CRUD Local)
// ======================================================
class EjercicioInventario extends StatefulWidget {
  const EjercicioInventario({super.key});

  @override
  State<EjercicioInventario> createState() => _EjercicioInventarioState();
}

class _EjercicioInventarioState extends State<EjercicioInventario> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _precioController = TextEditingController();

  String? _categoriaSeleccionada;
  final List<Producto> _productos = [];

  final List<String> _categorias = ['Electrónica', 'Hogar', 'Alimentos', 'Ropa'];

  @override
  void dispose() {
    _nombreController.dispose();
    _cantidadController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  void _agregarProducto() {
    if (_formKey.currentState!.validate()) {
      final producto = Producto(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: _nombreController.text.trim(),
        cantidad: int.parse(_cantidadController.text),
        precio: double.parse(_precioController.text),
        categoria: _categoriaSeleccionada!,
      );

      setState(() {
        _productos.add(producto);
      });

      // Limpiar formulario
      _formKey.currentState!.reset();
      _nombreController.clear();
      _cantidadController.clear();
      _precioController.clear();
      setState(() => _categoriaSeleccionada = null);

      FocusScope.of(context).unfocus();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto agregado correctamente'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _eliminarProducto(String id) {
    setState(() {
      _productos.removeWhere((p) => p.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario de Productos'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // ========== FORMULARIO ==========
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Nombre
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del Producto',
                      prefixIcon: Icon(Icons.shopping_bag),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El nombre es obligatorio';
                      }
                      if (value.trim().length <= 3) {
                        return 'Debe tener más de 3 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Cantidad
                  TextFormField(
                    controller: _cantidadController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Cantidad en Stock',
                      prefixIcon: Icon(Icons.numbers),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La cantidad es obligatoria';
                      }
                      final cantidad = int.tryParse(value);
                      if (cantidad == null || cantidad <= 0) {
                        return 'Debe ser un número mayor a cero';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Precio
                  TextFormField(
                    controller: _precioController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Precio Unitario',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El precio es obligatorio';
                      }
                      final precio = double.tryParse(value);
                      if (precio == null || precio <= 0) {
                        return 'Debe ser un número válido mayor a cero';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Categoría (Dropdown)
                  DropdownButtonFormField<String>(
                    value: _categoriaSeleccionada,
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(),
                    ),
                    items: _categorias
                        .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _categoriaSeleccionada = value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Seleccione una categoría';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Botón Agregar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _agregarProducto,
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar Producto'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(thickness: 1),

          // ========== LISTA DE PRODUCTOS ==========
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'Productos registrados',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text('${_productos.length} items'),
              ],
            ),
          ),

          Expanded(
            child: _productos.isEmpty
                ? const Center(
                    child: Text(
                      'No hay productos.\nAgrega el primero arriba.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _productos.length,
                    itemBuilder: (context, index) {
                      final p = _productos[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text(p.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('Categoría: ${p.categoria}'),
                              Text('Cantidad: ${p.cantidad}  |  Precio: S/ ${p.precio.toStringAsFixed(2)}'),
                              Text(
                                'Subtotal: S/ ${p.subtotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _eliminarProducto(p.id),
                          ),
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