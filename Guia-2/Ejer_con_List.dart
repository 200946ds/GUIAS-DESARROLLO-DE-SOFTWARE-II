class ListNode {
  int val;
  ListNode? next;
  ListNode(this.val, [this.next]);
}

ListNode? mergeTwoLists(ListNode? lista1, ListNode? lista2) {
  // Nodo auxiliar para simplificar la construcción de la lista
  final ListNode dummy = ListNode(0);
  ListNode tail = dummy;

  while (lista1 != null && lista2 != null) {
    if (lista1.val <= lista2.val) {
      tail.next = lista1;
      lista1 = lista1.next;
    } else {
      tail.next = lista2;
      lista2 = lista2.next;
    }
    tail = tail.next!;
  }

  // Conectar los nodos restantes (solo una de las listas tendrá nodos)
  tail.next = lista1 ?? lista2;

  return dummy.next;
}

// Construye una lista enlazada a partir de una List
ListNode? construirLista(List<int> valores) {
  ListNode? cabeza;
  for (var i = valores.length - 1; i >= 0; i--) {
    cabeza = ListNode(valores[i], cabeza);
  }
  return cabeza;
}

// Convierte una lista enlazada a List para imprimirla
List<int> aList(ListNode? nodo) {
  final List<int> resultado = [];
  while (nodo != null) {
    resultado.add(nodo.val);
    nodo = nodo.next;
  }
  return resultado;
}

void main() {
  // Ejemplo 1
  var r1 = mergeTwoLists(construirLista([1, 2, 4]), construirLista([1, 3, 4]));
  print(aList(r1)); // [1, 1, 2, 3, 4, 4]

  // Ejemplo 2
  var r2 = mergeTwoLists(construirLista([]), construirLista([]));
  print(aList(r2)); // []

  // Ejemplo 3
  var r3 = mergeTwoLists(construirLista([]), construirLista([0]));
  print(aList(r3)); // [0]
}