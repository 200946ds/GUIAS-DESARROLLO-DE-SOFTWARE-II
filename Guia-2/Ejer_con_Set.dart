int frutasSinColocar(List<int> frutas, List<int> cestas) {
  // Set con los índices de las cestas que ya están ocupadas
  final Set<int> cestasUsadas = {};
  int sinColocar = 0;

  for (final fruta in frutas) 
  {
    bool colocada = false;

    // Buscar la cesta disponible más a la izquierda con capacidad suficiente
    for (var j = 0; j < cestas.length; j++) 
    {
      if (!cestasUsadas.contains(j) && cestas[j] >= fruta) 
      {
        cestasUsadas.add(j);
        colocada = true;
        break;
      }
    }

    if (!colocada) 
    {
      sinColocar++;
    }
  }

  return sinColocar;
}

void main() {
  // Ejemplo 1
  print(frutasSinColocar([4, 2, 5], [3, 5, 4])); // 1

  // Ejemplo 2
  print(frutasSinColocar([3, 6, 1], [6, 4, 7])); // 0
}