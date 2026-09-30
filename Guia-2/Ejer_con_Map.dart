List<int> interseccion(List<int> nums1, List<int> nums2) {
  // Map que cuenta cuántas veces aparece cada número en nums1
  final Map<int, int> conteo = {};
  for (final n in nums1) {
    conteo[n] = (conteo[n] ?? 0) + 1;
  }

  final List<int> resultado = [];
  for (final n in nums2) 
  {
    final int disponibles = conteo[n] ?? 0;
    if (disponibles > 0) {
      resultado.add(n);
      conteo[n] = disponibles - 1; // consumir una aparición
    }
  }

  return resultado;
}

void main() {
  // Ejemplo 1
  print(interseccion([1, 2, 2, 1], [2, 2])); // [2, 2]

  // Ejemplo 2
  print(interseccion([4, 9, 5], [9, 4, 9, 8, 4])); // [9, 4]
}